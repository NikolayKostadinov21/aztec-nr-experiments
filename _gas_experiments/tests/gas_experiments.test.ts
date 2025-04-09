import { AccountManager, AccountWallet, CompleteAddress, ContractDeployer, createLogger, Fr, PXE, waitForPXE, TxStatus, createPXEClient, getContractInstanceFromDeployParams, Logger, FeeJuicePaymentMethod } from "@aztec/aztec.js";
import { getInitialTestAccountsWallets } from "@aztec/accounts/testing"
import {
    MainContract, MainContractArtifact
} from '../src/artifacts/Main.js';
import { GasSettings } from '@aztec/stdlib/gas';
import { beforeAll, beforeEach, describe, expect, test } from 'vitest';

const { PXE_URL = 'http://localhost:8080' } = process.env;
const setupSandbox = async () => {
    const pxe = createPXEClient(PXE_URL);
    await waitForPXE(pxe);
    return pxe;
};

describe('Gas estimation', () => {
    let pxe: PXE;
    let wallets: AccountWallet[] = [];
    let accounts: CompleteAddress[] = [];

    beforeEach(async () => {
        pxe = await setupSandbox();
        console.log('goes in beforeAll')
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

    test('Write one field to storage', async () => {
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();
        const aliceWallet = wallets[0].getAddress();

        let tx_req_write_field_to_storage = contract.withWallet(wallets[0]).methods.constructor();

        const estimated_write_field_to_storage = await tx_req_write_field_to_storage.estimateGas();
        console.log("estimated_write_field_to_storage: ", estimated_write_field_to_storage);

        let paymentMethod = new FeeJuicePaymentMethod(aliceWallet);
        let sent_tx_for_writing_field_to_storage = await tx_req_write_field_to_storage.send({
            fee: {
                gasSettings: estimated_write_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("sent_tx_for_writing_field_to_storage: ", sent_tx_for_writing_field_to_storage);
        console.log("sent_tx_for_writing_field_to_storage.transactionFee: ", sent_tx_for_writing_field_to_storage.transactionFee);
    }, 30000);

});