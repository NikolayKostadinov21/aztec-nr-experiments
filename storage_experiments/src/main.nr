use dep::aztec::macros::aztec;

#[aztec]
contract Main {
    use dep::aztec::macros::{functions::{initializer, public, view}, storage::storage};
    use dep::aztec::oracle::debug_log::debug_log;
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use dep::aztec::protocol_types::{debug_log::debug_log_format, traits::{Deserialize, Serialize}};
    use std::meta::derive;

    global TWO_POW_32_MIN_1: u32 = 0xFFFFFFFF;
    global TWO_POW_32: u64 = 0x100000000;

    #[storage]
    struct Storage<Context> {
        contract_storage: PublicMutable<[Field; TWO_POW_32_MIN_1 - 1000], Context>,
        array_64: PublicMutable<[Field; 64], Context>,
        block_number: PublicMutable<Field, Context>,
    }

    #[public]
    fn set_feeds(feed_input_data: Field, array__64: [Field; 64]) {
        storage.block_number.write(feed_input_data);
        storage.array_64.write(array__64);
    }
}
