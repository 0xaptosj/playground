module playground_addr::legacy_token_playground {
    use std::string;
    use aptos_token::token;

    fun init_module(sender: &signer) {
        // this code is broken!!!
        // token::create_collection_script(
        //     sender,
        //     string::utf8(b"name"),
        //     string::utf8(b"description"),
        //     string::utf8(b"uri"),
        //     123,
        //     vector[true, true, true]
        // )
    }

    // ================================= Tests ================================== //

    #[test_only]
    use std::signer;
    #[test_only]
    use aptos_framework::account;

    #[test(sender = @playground_addr)]
    fun test_happy_path(sender: &signer) {
        let sender_addr = signer::address_of(sender);
        account::create_account_for_test(sender_addr);
        init_module(sender);
    }
}
