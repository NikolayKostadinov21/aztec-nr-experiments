import { AccountManager, AccountWallet, CompleteAddress, ContractDeployer, createLogger, Fr, PXE, waitForPXE, TxStatus, createPXEClient, getContractInstanceFromDeployParams, Logger, FeeJuicePaymentMethod } from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing"
import {
    MainContract, MainContractArtifact
} from '../src/artifacts/Main.js';
import { GasSettings, getGasLimits } from '@aztec/stdlib/gas';
import { beforeAll, describe, expect, test } from 'vitest';

const { PXE_URL = 'http://localhost:8080' } = process.env;
const setupSandbox = async () => {
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
        console.log('goes here')
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

        // const makeTransferRequest = () => bananaCoin.methods.transfer_in_public(aliceAddress, bobAddress, 1n, 0n);
        // const estimatedGas = await makeTransferRequest().estimateGs();


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

    test.only('Sets new feeds', async () => {
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();

        // await contract
        //     .withWallet(wallets[0])
        //     .methods.set_just_field(1)
        //     .send()
        //     .wait();

        let x = await contract
            .withWallet(wallets[0])
            .methods.get_just_field()
            .simulate();
        console.log('result x is: ', x);
    }, 300000);

});