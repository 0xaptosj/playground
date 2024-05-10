module playground_addr::playground_1 {
    use std::string;
    use aptos_std::string_utils;
    use aptos_framework::delegation_pool;
    use aptos_framework::event;
    use aptos_framework::staking_contract;
    use aptos_framework::staking_proxy;

    #[event]
    struct MyEvent has store, drop {
        bools: vector<bool>,
    }

    // ================================= Entry Functions ================================= //

    public entry fun my_function(bools: vector<bool>) {
        event::emit(MyEvent {
            bools
        })
    }

    fun convert_u64_to_string(num: u64): string::String {
        string_utils::format1(&b"{}", num)
    }

    #[test]
    fun test_convert_u64_to_string() {
        let converted = convert_u64_to_string(123);
        delegation_pool::get_stake()

        assert!(converted == string::utf8(b"123"), 1);

    }

    #[view]
    fun get_staking_reward(delegator_addr: address): u64 {
    }
}
