module playground_addr::ans_playground {
    use std::option;
    use std::string;
    use std::vector;
    use router::router;


    /// Domain names and subdomain names must have same length
    const ENAME_LENGTH_NOT_THE_SAME: u64 = 1;

    #[view]
    public fun bulk_resolve_ans_name(
        domain_names: vector<string::String>,
        subdomain_names: vector<option::Option<string::String>>
    ): vector<option::Option<address>> {
        assert!(vector::length(&domain_names) == vector::length(&subdomain_names), ENAME_LENGTH_NOT_THE_SAME);
        let target_addresses = vector[];
        let idx = 0;
        while (idx < vector::length(&domain_names)) {
            let domain = *vector::borrow(&domain_names, idx);
            let subdomain= *vector::borrow(&subdomain_names, idx);
            let target_address = router::get_target_addr(domain, subdomain);
            vector::push_back(&mut target_addresses, target_address);
            idx = idx + 1
        };
        target_addresses
    }
}