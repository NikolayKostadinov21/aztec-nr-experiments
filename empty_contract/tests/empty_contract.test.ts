import { AccountManager, AccountWallet, AztecAddress, CompleteAddress, ContractInstanceWithAddress, L1FeeJuicePortalManager, PXE, SponsoredFeePaymentMethod } from "@aztec/aztec.js";

describe("Voting", () => {
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

});