use dep::aztec::macros::aztec;
mod test;

#[aztec]
contract Main {
    use dep::aztec::{macros::{functions::{initializer, public}, storage::storage}};
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};

    #[storage]
    struct Storage<Context> {
        single: Map<Field, PublicMutable<Field, Context>, Context>,
        fields: PublicMutable<Field, Context>,
    }

    #[public]
    #[initializer]
    fn constructor() {
        storage.single.at(1).write(1);
        storage.fields.write(69);
    }

    #[public]
    fn set_storage_fields(value: Field) {
        storage.fields.write(value);
    }

    unconstrained fn read_fields_value(key: Field) -> Field {
        storage.fields.read()
    }

    #[public]
    fn set_storage_single(key: Field, value: Field) {
        storage.single.at(key).write(value);
    }

    unconstrained fn read_storage_single(key: Field) -> Field {
        storage.single.at(key).read()
    }
}
