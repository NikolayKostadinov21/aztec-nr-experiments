use dep::aztec::{
    prelude::AztecAddress,
    protocol_types::{
        contract_instance::ContractInstance,
        storage::map::derive_storage_slot_in_map,
    },
    test::helpers::test_environment::TestEnvironment,
};
use dep::aztec::oracle::{execution::get_block_number, storage::storage_read};

use crate::Main;
global TWO: Field = 2;

unconstrained pub fn setup() -> (&mut TestEnvironment, AztecAddress) {
    let mut env = TestEnvironment::new();

    let initializer_call_interface = Main::interface().constructor();
    let adfs_contract = env.deploy_self("Main").with_public_void_initializer(
        initializer_call_interface,
    );

    (&mut env, adfs_contract.to_address())
}

#[test]
unconstrained fn test_set_feeds() {
    let (env, adfs_contract_address) = setup();

    let key: Field = 11;
    let value: Field = 59;
    Main::at(adfs_contract_address).set_storage_single(key, value).call(&mut env.public());
    // let get_storage_value = Main::read_storage_single(key);

    // let slot_in_map = 1;
    let block_number = get_block_number();
    let single_slot = Main::storage_layout().single.slot;
    let one_single_slot = derive_storage_slot_in_map(single_slot, key);
    let single_value_count: u32 = storage_read(adfs_contract_address, one_single_slot, block_number);
    println("single_value_count");
    println(single_value_count);
}

#[test]
unconstrained fn test_set_fields() {
    let (env, adfs_contract_address) = setup();

    let key: Field = 0;
    let value: Field = 690;
    Main::at(adfs_contract_address).set_storage_fields(value).call(&mut env.public());
    // let get_storage_value = Main::read_storage_single(key);

    // let slot_in_map = 1;
    let block_number = get_block_number();
    let single_slot = Main::storage_layout().single.slot;
    let one_single_slot = derive_storage_slot_in_map(single_slot, key);
    let single_value_count: u32 = storage_read(adfs_contract_address, one_single_slot, block_number);
    println("single_value_count");
    println(single_value_count);
}
