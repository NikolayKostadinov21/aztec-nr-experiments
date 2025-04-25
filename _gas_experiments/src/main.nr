use dep::aztec::macros::aztec;

#[aztec]
contract Main {
    use dep::aztec::macros::{functions::{initializer, public, view}, storage::storage};
    // use dep::aztec::oracle::debug_log::debug_log;
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use aztec::protocol_types::debug_log::debug_log;

    #[public]
    #[initializer]
    fn constructor() {}
    #[storage]
    struct Storage<Context> {
        field_in_map: Map<Field, PublicMutable<Field, Context>, Context>,
        just_field: PublicMutable<Field, Context>,
    }

    #[public]
    fn write_field_in_hashmap(index: Field, value: Field) {
        storage.field_in_map.at(index).write(value);
    }

    #[public]
    #[view]
     fn get_field_from_hashmap(index: Field) -> Field {
        storage.field_in_map.at(index).read()
    }

    #[public]
    fn directly_write_field_to_storage(storage_address: Field, value_to_write: Field) {
        context.storage_write(storage_address, value_to_write);
    }

    #[public]
    #[view]
    fn directly_get_field_from_storage(storage_address: Field) -> Field {
        context.storage_read(storage_address)
    }
}
