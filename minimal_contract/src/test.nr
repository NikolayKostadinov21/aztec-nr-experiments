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

unconstrained pub fn setup() -> (&mut TestEnvironment, AztecAddress) {
    let mut env = TestEnvironment::new();

    let initializer_call_interface = Main::interface().constructor();
    let main_contract = env.deploy_self("Main").with_public_void_initializer(
        initializer_call_interface,
    );

    (&mut env, main_contract.to_address())
}

#[test]
unconstrained fn test_set_feeds() {
    let (env, main_contract_address) = setup();

    let key = 3;
    let get_just_field = Main::at(main_contract_address).double(key).view(&mut env.public());
    println("get_just_field");
    println(get_just_field as u32);
}