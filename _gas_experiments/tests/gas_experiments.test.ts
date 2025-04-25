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
    test.skip('Deploying the contract', async () => {
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

        //


        const tx = deployer.deploy(deployArgs);
        const estimated_tx = await tx.estimateGas();
        console.log("estimated_tx: ", estimated_tx);
        let paymentMethod = new FeeJuicePaymentMethod(wallets[0].getAddress());
        let sent_tx_for_deployment = deployer.deploy(deployArgs).send({
            fee: {
                gasSettings: estimated_tx,
                paymentMethod
            },
            contractAddressSalt: salt
        });
        console.log('sent_tx_for_deployment:', sent_tx_for_deployment);
        //

        const receipt = await sent_tx_for_deployment.getReceipt();

        expect(receipt).toEqual(
            expect.objectContaining({
                status: TxStatus.PENDING,
                error: '',
            }),
        );

        const receiptAfterMined = await sent_tx_for_deployment.wait({ wallet: wallets[0] });
        console.log('receiptAfterMined: ', receiptAfterMined);

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

    test.only('Write to storage one field in hashmap', async () => {
        console.log('==========================Write to storage one field in hashmap===================================');
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();
        const aliceWallet = wallets[0].getAddress();

        let tx_req_write_field_to_storage = contract.withWallet(wallets[0]).methods.write_field_in_hashmap(0, 1);

        const estimated_write_field_to_storage_in_hashmap = await tx_req_write_field_to_storage.estimateGas();
        console.log("estimated_write_field_to_storage_in_hashmap: ", estimated_write_field_to_storage_in_hashmap);

        let paymentMethod = new FeeJuicePaymentMethod(aliceWallet);
        let sent_tx_for_writing_field_to_storage = await tx_req_write_field_to_storage.send({
            fee: {
                gasSettings: estimated_write_field_to_storage_in_hashmap,
                paymentMethod
            }
        }).wait();

        console.log("Write to storage one field in hashmap: ", sent_tx_for_writing_field_to_storage);
        console.log("Write to storage one field in hashmap's transactionFee: ", sent_tx_for_writing_field_to_storage.transactionFee);

        let returnedValue = await contract.withWallet(wallets[0]).methods.get_field_from_hashmap(0).simulate();
        console.log('returnedValue', returnedValue);
        expect(returnedValue).toBe(1n);


        let tx_req_read_field_to_storage = contract.withWallet(wallets[0]).methods.get_field_from_hashmap(0);

        const estimated_read_field_to_storage = await tx_req_read_field_to_storage.estimateGas();
        console.log("estimated_read_field_to_storage: ", estimated_read_field_to_storage);

        let sent_tx_for_reading_field_to_storage = await tx_req_read_field_to_storage.send({
            fee: {
                gasSettings: estimated_read_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("Reading one field from hashmap: ", sent_tx_for_reading_field_to_storage);
        console.log("Reading one field from hashmap's transactionFee: ", sent_tx_for_reading_field_to_storage.transactionFee);

    }, 30000);

    test.only('Write directly to storage one field', async () => {
        console.log('==========================Write directly to storage one field===================================');
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();
        const aliceWallet = wallets[0].getAddress();

        let tx_req_write_field_to_storage = contract.withWallet(wallets[0]).methods.directly_write_field_to_storage(0, 1);

        const estimated_directly_write_field_to_storage = await tx_req_write_field_to_storage.estimateGas();
        console.log("estimated_directly_write_field_to_storage: ", estimated_directly_write_field_to_storage);

        let paymentMethod = new FeeJuicePaymentMethod(aliceWallet);
        let sent_tx_for_writing_field_to_storage = await tx_req_write_field_to_storage.send({
            fee: {
                gasSettings: estimated_directly_write_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("Write directly to storage one field: ", sent_tx_for_writing_field_to_storage);
        console.log("Write directly to storage one field's transactionFee: ", sent_tx_for_writing_field_to_storage.transactionFee);

        let returnedValue = await contract.withWallet(wallets[0]).methods.directly_get_field_from_storage(0).simulate();
        console.log('returnedValue', returnedValue);
        expect(returnedValue).toBe(1n);

        let tx_req_read_field_to_storage = contract.withWallet(wallets[0]).methods.directly_get_field_from_storage(0);

        const estimated_read_field_to_storage = await tx_req_read_field_to_storage.estimateGas();
        console.log("estimated_read_field_to_storage: ", estimated_read_field_to_storage);

        let sent_tx_for_reading_field_to_storage = await tx_req_read_field_to_storage.send({
            fee: {
                gasSettings: estimated_read_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("Reading one field from hashmap: ", sent_tx_for_reading_field_to_storage);
        console.log("Reading one field from hashmap's transactionFee: ", sent_tx_for_reading_field_to_storage.transactionFee);
    }, 30000);

    test('Reading one field from hashmap', async () => {
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();
        const aliceWallet = wallets[0].getAddress();

        let tx_req_write_field_to_storage = contract.withWallet(wallets[0]).methods.get_field_from_hashmap(0);

        const estimated_write_field_to_storage = await tx_req_write_field_to_storage.estimateGas();
        console.log("estimated_write_field_to_storage: ", estimated_write_field_to_storage);

        let paymentMethod = new FeeJuicePaymentMethod(aliceWallet);
        let sent_tx_for_writing_field_to_storage = await tx_req_write_field_to_storage.send({
            fee: {
                gasSettings: estimated_write_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("Reading one field from hashmap: ", sent_tx_for_writing_field_to_storage);
        console.log("Reading one field from hashmap's transactionFee: ", sent_tx_for_writing_field_to_storage.transactionFee);


        let returnedValue = await contract.withWallet(wallets[0]).methods.directly_get_field_from_storage(0).simulate();
        console.log('returnedValue', returnedValue);
        expect(returnedValue).toBe(1);
    }, 30000);

    test('Reading one field directly from storage', async () => {
        const contract = await MainContract.deploy(wallets[0])
            .send()
            .deployed();
        const aliceWallet = wallets[0].getAddress();

        let tx_req_write_field_to_storage = contract.withWallet(wallets[0]).methods.directly_get_field_from_storage(0);

        const estimated_write_field_to_storage = await tx_req_write_field_to_storage.estimateGas();
        console.log("estimated_write_field_to_storage: ", estimated_write_field_to_storage);

        let paymentMethod = new FeeJuicePaymentMethod(aliceWallet);
        let sent_tx_for_writing_field_to_storage = await tx_req_write_field_to_storage.send({
            fee: {
                gasSettings: estimated_write_field_to_storage,
                paymentMethod
            }
        }).wait();

        console.log("Reading one field directly from storage: ", sent_tx_for_writing_field_to_storage);
        console.log("Reading one field directly from storage's transactionFee: ", sent_tx_for_writing_field_to_storage.transactionFee);
    }, 30000);
});