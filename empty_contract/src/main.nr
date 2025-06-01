use dep::aztec::macros::aztec;

#[aztec]
pub contract Main { // putting pub here just in case
    use dep::aztec::macros::{functions::{initializer, public, view}, storage::storage};
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use aztec::protocol_types::debug_log::debug_log;

    #[public]
    #[initializer]
    fn constructor() {}

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
