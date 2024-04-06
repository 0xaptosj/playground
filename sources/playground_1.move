module playground_addr::playground_1 {
    use aptos_framework::event;

    #[event]
    struct MyEvent has store, drop {
        bools: vector<bool>,
    }

    public entry fun my_function(bools: vector<bool>) {
        event::emit(MyEvent {
            bools
        })
    }
}
