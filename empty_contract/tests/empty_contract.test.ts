import { AccountManager, AccountWallet, AztecAddress, CompleteAddress, ContractDeployer, ContractInstanceWithAddress, Fr, getContractInstanceFromDeployParams, L1FeeJuicePortalManager, PXE, SponsoredFeePaymentMethod, TxStatus } from "@aztec/aztec.js";
import { beforeAll, beforeEach, describe, expect, test } from "vitest";
import { setupPXE } from "../utils/setup_pxe.js";
import { generateSchnorrAccounts } from "@aztec/accounts/testing";
import { getSchnorrAccount } from "@aztec/accounts/schnorr";
import { getSponsoredFPCInstance } from "../utils/sponsored_fpc.js";
import { SponsoredFPCContract } from "@aztec/noir-contracts.js/SponsoredFPC";
import { MainContractArtifact } from "../src/artifacts/Main.js";

describe("Almost empty contract", () => {
    let pxe: PXE;
    let firstWallet: AccountWallet;
    let accounts: CompleteAddress[] = [];
    let sandboxInstance;
    let sponsoredFPC: ContractInstanceWithAddress;
    let sponsoredPaymentMethod: SponsoredFeePaymentMethod;

    let randomAccountManagers: AccountManager[] = [];
    let randomWallets: AccountWallet[] = [];
    let randomAddresses: AztecAddress[] = [];

    let l1PortalManager: L1FeeJuicePortalManager;
    let skipSandbox: boolean;

    beforeAll(async () => {
        pxe = await setupPXE();

        sponsoredFPC = await getSponsoredFPCInstance();
        await pxe.registerContract({ instance: sponsoredFPC, artifact: SponsoredFPCContract.artifact });
        sponsoredPaymentMethod = new SponsoredFeePaymentMethod(sponsoredFPC.address);

        // generate random accounts
        randomAccountManagers = await Promise.all(
            (await generateSchnorrAccounts(5)).map(
                a => getSchnorrAccount(pxe, a.secret, a.signingKey, a.salt)
            )
        );
        // get corresponding wallets
        randomWallets = await Promise.all(randomAccountManagers.map(am => am.getWallet()));
        // get corresponding addresses
        randomAddresses = await Promise.all(randomWallets.map(async w => (w.getCompleteAddress()).address));

    });

    test("Should deploys the contract", async () => {
        const salt = Fr.random();
        const mainContractArtifact = MainContractArtifact
        const accounts = await Promise.all(
            (await generateSchnorrAccounts(2)).map(
                async a => await getSchnorrAccount(pxe, a.secret, a.signingKey, a.salt)
            )
        );
        await Promise.all(accounts.map(a => a.deploy({ fee: { paymentMethod: sponsoredPaymentMethod } }).wait()));
        const daWallets = await Promise.all(accounts.map(a => a.getWallet()));
        const [deployerWallet, adminWallet] = daWallets;
        const [deployerAddress, adminAddress] = daWallets.map(w => w.getAddress());

        const deploymentData = await getContractInstanceFromDeployParams(mainContractArtifact,
            {
                constructorArgs: [],
                salt,
                deployer: deployerWallet.getAddress()
            });
        const deployer = new ContractDeployer(mainContractArtifact, deployerWallet);
        const tx = deployer.deploy(adminAddress).send({
            contractAddressSalt: salt,
            fee: { paymentMethod: sponsoredPaymentMethod } // without the sponsoredFPC the deployment fails, thus confirming it works
        })
        const receipt = await tx.getReceipt();

        expect(receipt).toEqual(
            expect.objectContaining({
                status: TxStatus.PENDING,
                error: ''
            }),
        );

        console.log('receipt: ', receipt);
        const receiptAfterMined = await tx.wait({ wallet: deployerWallet });
        expect(await pxe.getContractMetadata(deploymentData.address)).toBeDefined();
        expect((await pxe.getContractMetadata(deploymentData.address)).contractInstance).toBeTruthy();
        expect(receiptAfterMined).toEqual(
            expect.objectContaining({
                status: TxStatus.SUCCESS,
            }),
        );

        console.log('random addresses: ', randomAddresses);

        expect(receiptAfterMined.contract.instance.address).toEqual(deploymentData.address)
    }, 100000)

});