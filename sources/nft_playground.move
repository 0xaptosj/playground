module playgrouund_addr::nft_playground {
    use std::option;
    use std::signer;
    use std::string;
    use aptos_framework::object;
    use aptos_token_objects::collection;
    use aptos_token_objects::royalty;
    use aptos_token_objects::token;

    const CONFIG_OBJ_SEED: vector<u8> = b"nft_playground_config";

    const DESCRIPTION: vector<u8> = b"description";
    const MAX_SUPPLY: u64 = 1000;
    const NAME: vector<u8> = b"Counter";
    const URI: vector<u8> = b"www.counter.com";

    struct NftData has key {
        msg: string::String
    }

    struct Config has key {
        extend_ref: object::ExtendRef
    }

    fun init_module(sender: &signer) {
        let sender_addr = signer::address_of(sender);

        let config_obj = object::create_named_object(sender, CONFIG_OBJ_SEED);
        let config_signer = object::generate_signer(&config_obj);
        let config_extend_ref = object::generate_extend_ref(&config_obj);
        let config = Config { extend_ref: config_extend_ref };
        move_to(&config_signer, config);

        let collection_royalty = option::some(royalty::create(10, 100, sender_addr));
        let _collection_constructor_ref = collection::create_fixed_collection(
            &config_signer,
            string::utf8(DESCRIPTION),
            MAX_SUPPLY,
            string::utf8(NAME),
            collection_royalty,
            string::utf8(URI),
        );
    }

    public entry fun mint(sender: &signer) acquires Config {
        let _nft_address = mint_inner(sender);
    }

    fun mint_inner(sender: &signer): address acquires Config {
        let sender_addr = signer::address_of(sender);
        let collection_creator = get_config_signer();
        let token_royalty = option::some(royalty::create(15, 100, sender_addr));
        let nft_constructor_ref = token::create_numbered_token(
            &collection_creator,
            string::utf8(NAME),
            string::utf8(DESCRIPTION),
            string::utf8(b"abc"),
            string::utf8(b"def"),
            token_royalty,
            string::utf8(URI),
        );

        let nft_signer = object::generate_signer(&nft_constructor_ref);
        let nft_transfer_ref = object::generate_transfer_ref(&nft_constructor_ref);

        let nft_data = NftData { msg: string::utf8(b"Hello, World!") };
        move_to(&nft_signer, nft_data);

        let sender_addr = signer::address_of(sender);
        object::transfer_with_ref(object::generate_linear_transfer_ref(&nft_transfer_ref), sender_addr);

        signer::address_of(&nft_signer)
    }

    public entry fun transfer_by_nft_token(sender: &signer, nft_addr: address, recipient_addr: address) {
        let nft_token_obj = object::address_to_object<token::Token>(nft_addr);
        object::transfer(sender, nft_token_obj, recipient_addr);
    }

    public entry fun transfer_by_nft_data(sender: &signer, nft_addr: address, recipient_addr: address) {
        let nft_data_obj = object::address_to_object<NftData>(nft_addr);
        object::transfer(sender, nft_data_obj, recipient_addr);
    }

    #[view]
    public fun get_collection_addr(): (address) {
        collection::create_collection_address(&get_config_signer_addr(), &string::utf8(NAME))
    }

    #[view]
    public fun get_collection_royalty(collection_addr: address): (option::Option<u64>, option::Option<u64>, option::Option<address>) {
        let collection_obj = object::address_to_object<collection::Collection>(collection_addr);
        let maybe_royalty = royalty::get(collection_obj);
        if (option::is_none(&maybe_royalty)) {
            (option::none(), option::none(), option::none())
        } else {
            let royalty = option::extract(&mut maybe_royalty);
            let numerator = royalty::numerator(&royalty);
            let denominator = royalty::denominator(&royalty);
            let payee_address = royalty::payee_address(&royalty);
            (option::some(numerator), option::some(denominator), option::some(payee_address))
        }
    }

    #[view]
    public fun get_token_royalty(token_addr: address): (option::Option<u64>, option::Option<u64>, option::Option<address>) {
        let token_obj = object::address_to_object<token::Token>(token_addr);
        let maybe_royalty = royalty::get(token_obj);
        if (option::is_none(&maybe_royalty)) {
            (option::none(), option::none(), option::none())
        } else {
            let royalty = option::extract(&mut maybe_royalty);
            let numerator = royalty::numerator(&royalty);
            let denominator = royalty::denominator(&royalty);
            let payee_address = royalty::payee_address(&royalty);
            (option::some(numerator), option::some(denominator), option::some(payee_address))
        }
    }

    #[view]
    public fun get_token_royalty2(token_addr: address): (option::Option<royalty::Royalty>) {
        let token_obj = object::address_to_object<token::Token>(token_addr);
        let maybe_royalty = royalty::get(token_obj);
        if (option::is_none(&maybe_royalty)) {
            // (option::none(), option::none(), option::none())
            (option::none())
        } else {
            let royalty = option::extract(&mut maybe_royalty);
            // let numerator = royalty::numerator(&royalty);
            // let denominator = royalty::denominator(&royalty);
            // let payee_address = royalty::payee_address(&royalty);
            // (option::some(numerator), option::some(denominator), option::some(payee_address))
            (option::some(royalty))
        }
    }

    fun get_config_signer_addr(): address {
        object::create_object_address(&@playgrouund_addr, CONFIG_OBJ_SEED)
    }

    fun get_config_signer(): signer acquires Config {
        object::generate_signer_for_extending(&borrow_global<Config>(get_config_signer_addr()).extend_ref)
    }

    #[test(sender = @playgrouund_addr, user1 = @0x100, user2 = @0x101)]
    fun test_happy_path(sender: &signer, user1: &signer, user2: &signer) acquires Config {
        init_module(sender);
        let user1_addr = signer::address_of(user1);
        let collection_addr = get_collection_addr();
        let nft_addr = mint_inner(user1);
        let (numerator, denominator, payee_address) = get_collection_royalty(collection_addr);
        assert!(numerator == option::some(10), 1);
        assert!(denominator == option::some(100), 1);
        assert!(payee_address == option::some(@playgrouund_addr), 1);

        let (numerator, denominator, payee_address) = get_token_royalty(nft_addr);
        assert!(numerator == option::some(15), 1);
        assert!(denominator == option::some(100), 1);
        assert!(payee_address == option::some(user1_addr), 1);
    }
}
