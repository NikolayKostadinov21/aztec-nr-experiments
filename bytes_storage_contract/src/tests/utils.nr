use dep::aztec::{
    prelude::AztecAddress,
    protocol_types::storage::map::derive_storage_slot_in_map,
    test::helpers::test_environment::TestEnvironment,
};

use crate::Main;
global TWO: Field = 2;
global TWO_POW_13: Field = 8192; // 2^13
global TWO_POW_115: Field = 41538374868278621028243970633760768; // 2^115
global TWO_POW_128: Field = 340282366920938463463374607431768211456; // 2^128

pub unconstrained fn setup() -> (&mut TestEnvironment, AztecAddress) {
    let mut env = TestEnvironment::new();

    let initializer_call_interface = Main::interface().constructor();
    let main_contract = env.deploy_self("Main").with_public_void_initializer(
        initializer_call_interface,
    );

    env.advance_block_by(1);
    (&mut env, main_contract.to_address())
}

pub unconstrained fn calculate_feed_index(feed_id: Field, round: Field, stride: Field) -> Field {
    (TWO_POW_128 * TWO.pow_32(stride)) + ((feed_id * TWO_POW_13) * TWO.pow_32(stride)) + (round * TWO.pow_32(stride))
}

pub unconstrained fn calculate_round_index(stride: Field, feed_id: Field) -> Field {
    let latest_rounds_record = ((TWO_POW_115 * stride + feed_id) / 15);
    let quotient = latest_rounds_record / 15;
    let quot_times_15 = quotient * 15;
    latest_rounds_record - quot_times_15
}
