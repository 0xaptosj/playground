script {
    use aptos_framework::object;

    fun transfer_object(sender: &signer) {
        object::transfer(
            sender,
            object::address_to_object<object::ObjectCore>(@0x8187d6d6cc33862b92f7c71e8b3cac13f7b6bd9f8d127167db76cf1550efc10c),
            @0x112e2fd4e290091402f5ab744ad518c1d1d4a163b3485a33f9dc70a314efa281
        );
    }
}