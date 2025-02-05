use dep::aztec::macros::aztec;
mod tests;

#[aztec]
contract Main {
    use dep::aztec::{macros::{functions::{initializer, public}, storage::storage}};
    use dep::aztec::prelude::{AztecAddress, Map, PublicImmutable, PublicMutable};
    use dep::aztec::protocol_types::traits::{Packable, Serialize, Deserialize};

    #[storage]
    struct Storage<Context> {
        data_feeds: Map<Field, PublicMutable<FeedDataLenTwo, Context>, Context>,
        data_feeds_max_len: Map<Field, PublicMutable<FeedDataMaxLen, Context>, Context>,
    }

    global TWO_DATA_FEED_LEN_AS_FIELDS: u32 = 2;
    /// Max fields to be written in the storage of the smart contract per TX
    /// Context: https://github.com/AztecProtocol/aztec-packages/blob/master/barretenberg/cpp/src/barretenberg/vm/aztec_constants.hpp#L18
    global MAX_DATA_FEED_LEN_AS_FIELDS: u32 = 63;
    /// The smallest value one can write in storage for the `data_feeds` Map is 1 Field.
    /// Thus the `feed_input_data` array can be at most 63 * (feed's index + feed's length + feed's value).
    global MAX_INPUT_ARRAY_SIZE: u32 = 3 * MAX_DATA_FEED_LEN_AS_FIELDS;

    /// TODO: When aztec-nr's storage macro start handling field types with generics implement `FeedData` with generic param
    struct FeedDataLenTwo {
        data: BoundedVec<Field, TWO_DATA_FEED_LEN_AS_FIELDS>
    }

    impl Packable<TWO_DATA_FEED_LEN_AS_FIELDS> for FeedDataLenTwo {
        fn pack(self) -> [Field; TWO_DATA_FEED_LEN_AS_FIELDS] {
            self.data.storage
        }

        fn unpack(input: [Field; TWO_DATA_FEED_LEN_AS_FIELDS]) -> Self {
            Self {
                data: BoundedVec::from_array(input)
            }
        }
    }

    struct FeedDataMaxLen {
        data: BoundedVec<Field, MAX_DATA_FEED_LEN_AS_FIELDS>
    }

    impl Packable<MAX_DATA_FEED_LEN_AS_FIELDS> for FeedDataMaxLen {
        fn pack(self) -> [Field; MAX_DATA_FEED_LEN_AS_FIELDS] {
            self.data.storage
        }

        fn unpack(input: [Field; MAX_DATA_FEED_LEN_AS_FIELDS]) -> Self {
            Self {
                data: BoundedVec::from_array(input)
            }
        }
    }

    #[public]
    #[initializer]
    fn constructor() {}

    #[public]
    fn set_feeds_with_len_two(
        feed_input_data: [Field; MAX_INPUT_ARRAY_SIZE],
        feeds_len: Field,
    ) {
        // Doing a cast here to avoid casting one more time
        let feeds_len_u64 = feeds_len as u64;
        let mut new_index: u64 = 0;
        for i in new_index..feeds_len_u64 {
            let feed_id = feed_input_data[new_index];
            let curr_feed_len = feed_input_data[new_index + 1] as u64;
            new_index = new_index + 2;

            let mut data: BoundedVec<Field, TWO_DATA_FEED_LEN_AS_FIELDS> = BoundedVec::new();
            for j in 0..curr_feed_len {
                data.push(feed_input_data[new_index + j]);
            }
            storage.data_feeds.at(feed_id).write(
                FeedDataLenTwo {
                    data
                }
            );

            new_index = new_index + curr_feed_len;
        }
    }

    #[public]
    fn set_feeds_with_max_len(
        feed_input_data: [Field; MAX_INPUT_ARRAY_SIZE],
        feeds_len: Field,
    ) {
        // Doing a cast here to avoid casting one more time
        let feeds_len_u64 = feeds_len as u64;
        let mut new_index: u64 = 0;
        for i in new_index..feeds_len_u64 {
            let feed_id = feed_input_data[new_index];
            let curr_feed_len = feed_input_data[new_index + 1] as u64;
            new_index = new_index + 2;

            let mut data: BoundedVec<Field, MAX_DATA_FEED_LEN_AS_FIELDS> = BoundedVec::new();
            for j in 0..curr_feed_len {
                data.push(feed_input_data[new_index + j]);
            }
            storage.data_feeds_max_len.at(feed_id).write(
                FeedDataMaxLen {
                    data
                }
            );

            new_index = new_index + curr_feed_len;
        }
    }
}
