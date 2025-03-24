use dep::aztec::macros::aztec;
mod test;

#[aztec]
contract Main {
    use dep::aztec::macros::{functions::{initializer, public, view}, storage::storage};
    // use dep::aztec::oracle::debug_log::debug_log;
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use aztec::protocol_types::debug_log::debug_log;

    #[storage]
    struct Storage<Context> {
        field_in_map: Map<Field, PublicMutable<Field, Context>, Context>,
        just_field: PublicMutable<Field, Context>,
    }

    #[public]
    #[initializer]
    fn constructor() {
        debug_log("asdf");
        storage.field_in_map.at(1).write(1);
        storage.just_field.write(700);
    }

    #[public]
    fn set_just_field(value: Field) {
        debug_log("asdf");
        storage.just_field.write(value);
    }

    unconstrained fn read_just_field_value() -> Field {
        storage.just_field.read()
    }

    #[public]
    #[view]
    fn get_just_field() -> pub Field {
        storage.just_field.read()
    }

    #[public]
    fn set_field_in_map(key: Field, value: Field) {
        storage.field_in_map.at(key).write(value);
    }

    #[public]
    #[view]
    fn read_field_in_map(key: Field) -> pub Field {
        storage.field_in_map.at(key).read()
    }
}
