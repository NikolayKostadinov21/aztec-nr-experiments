import { AccountManager, AccountWallet, CompleteAddress, ContractDeployer, createLogger, Fr, PXE, waitForPXE, TxStatus, createPXEClient, getContractInstanceFromDeployParams, Logger } from "@aztec/aztec.js";
import { getInitialTestAccountsWallets, generateSchnorrAccounts } from "@aztec/accounts/testing"
import { getSchnorrAccount } from '@aztec/accounts/schnorr';
import { spawn } from 'child_process';
import { SponsoredFeePaymentMethod } from './sponsored_fee_payment_method.js';

import {
    MainContract, MainContractArtifact
} from '../src/artifacts/Main.js';

import { beforeAll, describe, expect, test } from 'vitest';

const setupSandbox = async () => {
    const { PXE_URL = 'http://localhost:8080' } = process.env;
    const pxe = createPXEClient(PXE_URL);
    await waitForPXE(pxe);
    return pxe;
};
const sleep = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

describe('Reading from/Writing to storage', () => {
    let pxe: PXE;
    let wallets: AccountWallet[] = [];
    let accounts: CompleteAddress[] = [];

    beforeAll(async () => {
        pxe = await setupSandbox();

        wallets = await getInitialTestAccountsWallets(pxe);
        accounts = wallets.map(w => w.getCompleteAddress());
    });
    test('Deploying the contract', async () => {
        const salt = Fr.random();
        const mainContractArtifact =
            MainContractArtifact;
        const deployArgs = wallets[0].getCompleteAddress().address;

        const deploymentData = getContractInstanceFromDeployParams(
            mainContractArtifact,
            {
                constructorArgs: [deployArgs],
                salt,
                deployer: wallets[0].getAddress(),
            },
        );

        const deployer = new ContractDeployer(
            mainContractArtifact,
            wallets[0],
        );
        const tx = deployer.deploy(deployArgs).send({ contractAddressSalt: salt });
        const receipt = await tx.getReceipt();

        expect(receipt).toEqual(
            expect.objectContaining({
                status: TxStatus.PENDING,
                error: '',
            }),
        );

        const receiptAfterMined = await tx.wait({ wallet: wallets[0] });

        expect(await pxe.getContractMetadata((await deploymentData).address)).toBeDefined();
        expect((await pxe.getContractMetadata((await deploymentData).address)).contractInstance).toBeTruthy();
        expect(receiptAfterMined).toEqual(
            expect.objectContaining({
                status: TxStatus.SUCCESS,
            }),
        );

        console.log(receiptAfterMined.contract.instance.address);

        expect(receiptAfterMined.contract.instance.address).toEqual((await deploymentData).address)
    }, 30000);

    test('Sets new feeds', async () => {
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();

        await contract
            .withWallet(wallets[0])
            .methods.set_just_field(1)
            .send()
            .wait();
    }, 30000);

});