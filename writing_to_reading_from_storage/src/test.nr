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
    let main_contract = env.deploy_self("Main").with_public_void_initializer(
        initializer_call_interface,
    );

    env.advance_block_by(1);
    (&mut env, main_contract.to_address())
}

#[test]
unconstrained fn test_set_feeds() {
    let (env, main_contract_address) = setup();

    let key: Field = 11;
    let value: Field = 59;
    Main::at(main_contract_address).set_field_in_map(key, value).call(&mut env.public());

    let block_number = get_block_number();
    let field_in_map_slot = Main::storage_layout().field_in_map.slot;
    let field_in_map_slot = derive_storage_slot_in_map(field_in_map_slot, key);
    let field_in_map_value: u32 = storage_read(main_contract_address, field_in_map_slot, block_number);
    println("field_in_map_value");
    println(field_in_map_value);
    // let get_field_in_map = Main::read_field_in_map(key);
    // println("get_field_in_map");
    // println(get_field_in_map);

    let get_just_field = Main::at(main_contract_address).read_field_in_map(key).view(&mut env.public());
    // let get_just_field = Main::read_just_field_value().view(&mut context);
    println("get_just_field");
    println(get_just_field as u32);
}

#[test]
unconstrained fn test_set_just_field() {
    let (env, main_contract_address) = setup();

    let key: Field = 0;
    let value: Field = 690;
    Main::at(main_contract_address).set_just_field(value).call(&mut env.public());
    // let get_storage_value = Main::read_storage_single(key);

    // let slot_in_map = 1;
    let block_number = get_block_number();
    let just_field_slot = Main::storage_layout().just_field.slot;
    let derive_storage_slot_of_just_field_slot = derive_storage_slot_in_map(just_field_slot, 5);
    let just_field_value: u32 = storage_read(main_contract_address, derive_storage_slot_of_just_field_slot, block_number);
    println("just_field_value");
    println(just_field_value);
    let get_just_field = Main::at(main_contract_address).get_just_field().view(&mut env.public());
    // let get_just_field = Main::read_just_field_value().view(&mut context);
    println("get_just_field");
    println(get_just_field as u32);
}
// read_fields_value