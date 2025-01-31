use dep::aztec::oracle::{execution::get_block_number, storage::storage_read};
use dep::aztec::{
    protocol_types::storage::map::derive_storage_slot_in_map,
    prelude::AztecAddress
};
use crate::Main;
use crate::tests::utils;
use crate::tests::helper_vars;
use utils::{calculate_feed_index, calculate_round_index};
use helper_vars::{
    TWELVE, TWO_POW_128, TWO_POW_115, TWO_POW_13, ZERO,
    ONE, TWO, first_feed_ix, helper_31_data_feeds_with_len_2, helper_data_feed_with_len_63
};

#[test]
unconstrained fn test_store_31_field_elements_with_data_length_2() {
    let (env, main_contract_address) = utils::setup();

    let feeds_len = 31;
    // README:
    // let feeds_len = 32; // <=== This will result in:
    // `Failed calling external resolver.
    // ErrorObject {
    //    code: InvalidRequest,
    //    message: "Reached the limit (63) on number of 'public data (contract storage) write'
    //    per tx 'storage_write_opcode(storage_slot, value)'",
    //    data: None
    // }`
    //

    Main::at(main_contract_address).set_feeds_with_len_two(
        helper_31_data_feeds_with_len_2.storage,
        feeds_len,
    ).call(&mut env.public());

    let block_number = get_block_number();
    let data_feeds_slot = Main::storage_layout().data_feeds.slot;
    let data_feed_first_slot = derive_storage_slot_in_map(data_feeds_slot, 700);
    let data_feed_first_slot_value: u32 = storage_read(main_contract_address, data_feed_first_slot, block_number);
    println("data_feed_first_slot_value");
    println(data_feed_first_slot_value);
    assert(data_feed_first_slot_value == 157);
}

#[test]
unconstrained fn test_store_1_field_element_with_data_length_63() {
    let (env, main_contract_address) = utils::setup();

    let feeds_len = 1;
    // README:
    // let feeds_len = 2; // <=== This will result in:
    // `Failed calling external resolver.
    // ErrorObject {
    //    code: InvalidRequest,
    //    message: "Reached the limit (63) on number of 'public data (contract storage) write'
    //    per tx 'storage_write_opcode(storage_slot, value)'",
    //    data: None
    // }`
    //

    Main::at(main_contract_address).set_feeds_with_max_len(
        helper_data_feed_with_len_63.storage,
        feeds_len,
    ).call(&mut env.public());

    let block_number = get_block_number();
    let data_feeds_max_len_slot = Main::storage_layout().data_feeds_max_len.slot;
    let data_feeds_max_len_first_slot = derive_storage_slot_in_map(data_feeds_max_len_slot, 1);
    let data_feed_max_len_first_slot_value: u32 = storage_read(main_contract_address, data_feeds_max_len_first_slot, block_number);
    println("data_feed_max_len_first_slot_value");
    println(data_feed_max_len_first_slot_value);
}
