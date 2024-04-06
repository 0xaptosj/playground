module playground_addr::coin_playground {
    use std::option;
    use std::signer;
    use std::string;
    use aptos_framework::coin;

    struct TestCoin has key {}

    struct Config has key {
        mint_capability: coin::MintCapability<TestCoin>,
        burn_capability: coin::BurnCapability<TestCoin>,
        freeze_capability: coin::FreezeCapability<TestCoin>,
    }

    fun init_module(sender: &signer) {
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<TestCoin>(
            sender,
            string::utf8(b"Test"),
            string::utf8(b"symbol"),
            8,
            true
        );

        move_to(
            sender,
            Config {
                burn_capability: burn_cap,
                freeze_capability: freeze_cap,
                mint_capability: mint_cap
            }
        );
    }

    public entry fun mint_coin(sender: &signer, amount: u64) acquires Config {
        let coin_cap = borrow_global<Config>(@playground_addr);
        let minted_coin = coin::mint(amount, &coin_cap.mint_capability);
        coin::register<TestCoin>(sender);
        coin::deposit(signer::address_of(sender), minted_coin)
    }

    #[view]
    public fun getTotalSupply(): u128 {
        let maybe_supply = coin::supply<TestCoin>();
        if (option::is_some(&maybe_supply)) {
            option::extract(&mut maybe_supply)
        } else {
            0
        }
    }

    #[view]
    public fun getBalance(user: address): u64 {
        coin::balance<TestCoin>(user)
    }

    #[test_only]
    use aptos_framework::account;
    #[test(sender = @playground_addr)]
    fun test_happy_path(sender: &signer) acquires Config {
        let sender_addr = signer::address_of(sender);
        account::create_account_for_test(sender_addr);

        init_module(sender);
        assert!(getTotalSupply() == 0, 1);

        mint_coin(sender, 2);
        assert!(getTotalSupply() == 2, 2);
        assert!(getBalance(sender_addr) == 2, 3);
    }
}
