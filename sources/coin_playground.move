module playground_addr::coin_playground {
    use std::string;
    use aptos_framework::account;
    use aptos_framework::coin;

    struct TestCoin has key {}

    struct CoinCap has key {
        mint_capability: coin::MintCapability<TestCoin>,
        burn_capability: coin::BurnCapability<TestCoin>,
        freeze_capability: coin::FreezeCapability<TestCoin>,
    }

    public entry fun create_coin(sender: &signer) {
        let (resource_signer, _signer_cap) = account::create_resource_account(sender, b"token_account");
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<TestCoin>(
            &resource_signer,
            string::utf8(b"Test"),
            string::utf8(b"symbol"),
            8,
            true
        );

        move_to(
            &resource_signer,
            CoinCap {
                burn_capability: burn_cap,
                freeze_capability: freeze_cap,
                mint_capability: mint_cap
            }
        );
    }

    // #[test(sender = @playground_addr, user1 = @0x100, user2 = @0x101)]
    // fun test_happy_path(sender: &signer, user1: &signer, user2: &signer) {
    //     create_coin(user1);
    // }
}
