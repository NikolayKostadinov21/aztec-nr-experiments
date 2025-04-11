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
        // field_in_map: Map<Field, PublicMutable<Field, Context>, Context>,
        just_field: PublicMutable<Field, Context>,
    }

    #[public]
    fn set_just_field(value: Field) {
        storage.just_field.write(value);
    }

    #[public]
    #[view]
     fn get_just_field() -> Field {
        storage.just_field.read()
    }
}
