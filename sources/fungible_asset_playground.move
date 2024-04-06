module playground_addr::fungible_asset_playground {
    use std::option;
    use std::signer;
    use std::string;
    use aptos_framework::fungible_asset;
    use aptos_framework::object;
    use aptos_framework::primary_fungible_store;

    const FA_OBJ_SEED: vector<u8> = b"MY_FA";

    struct TestCoin has key {}

    struct Config has key {
        mint_ref: fungible_asset::MintRef,
        burn_ref: fungible_asset::BurnRef,
        transfer_ref: fungible_asset::TransferRef
    }

    fun init_module(sender: &signer) {
        let fa_obj_constructor_ref = &object::create_named_object(sender, FA_OBJ_SEED);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            fa_obj_constructor_ref,
            option::none(),
            string::utf8(b"Test"),
            string::utf8(b"symbol"),
            8,
            string::utf8(b"icon_url"),
            string::utf8(b"project_url"),
        );
        let mint_ref = fungible_asset::generate_mint_ref(fa_obj_constructor_ref);
        let burn_ref = fungible_asset::generate_burn_ref(fa_obj_constructor_ref);
        let transfer_ref = fungible_asset::generate_transfer_ref(fa_obj_constructor_ref);
        move_to(sender, Config {
            mint_ref,
            burn_ref,
            transfer_ref,
        });
    }

    public entry fun mint_fa(sender: &signer, amount: u64) acquires Config {
        let sender_addr = signer::address_of(sender);
        let config = borrow_global<Config>(@playground_addr);
        let minted_fa = fungible_asset::mint(&config.mint_ref, amount);
        primary_fungible_store::deposit(sender_addr, minted_fa);
    }

    #[view]
    public fun getTotalSupply(): u128 {
        let fa_obj = object::address_to_object<object::ObjectCore>(get_fa_obj_address());
        let maybe_supply = fungible_asset::supply(fa_obj);
        if (option::is_some(&maybe_supply)) {
            option::extract(&mut maybe_supply)
        } else {
            0
        }
    }

    #[view]
    public fun getBalance(user: address): u64 {
        let fa_obj = object::address_to_object<object::ObjectCore>(get_fa_obj_address());
        primary_fungible_store::balance(user, fa_obj)
    }

    #[view]
    public fun get_fa_obj_address(): address {
        object::create_object_address(&@playground_addr, FA_OBJ_SEED)
    }

    #[test_only]
    use aptos_framework::account;

    #[test(sender = @playground_addr)]
    fun test_happy_path(sender: &signer) acquires Config {
        let sender_addr = signer::address_of(sender);
        account::create_account_for_test(sender_addr);

        init_module(sender);
        assert!(getTotalSupply() == 0, 1);

        mint_fa(sender, 2);
        assert!(getTotalSupply() == 2, 2);
        assert!(getBalance(sender_addr) == 2, 3);
    }
}
