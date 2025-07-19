#[test_only]
module paylancer_addr::test_paylancer {
    use std::string;
    use std::option;
    use paylancer_addr::paylancer;
    use paylancer_addr::user;
    use paylancer_addr::wallet;
    use paylancer_addr::payment_request;
    use paylancer_addr::virtual_cards;
    use paylancer_addr::virtual_accounts;

    #[test(sender = @paylancer_addr)]
    public fun test_create_user(sender: &signer) {
        paylancer::init_events(sender);
        paylancer::create_user(
            sender,
            string::utf8(b"user1"),
            string::utf8(b"user1@example.com"),
            string::utf8(b"user1"),
            string::utf8(b"User One"),
            string::utf8(b"USD"),
            1710000000
        );
        let opt_user = user::get_user(signer::address_of(sender));
        assert!(option::is_some(&opt_user), 300);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_create_wallet(sender: &signer) {
        paylancer::init_events(sender);
        paylancer::create_wallet(
            sender,
            string::utf8(b"wallet1"),
            string::utf8(b"user1"),
            string::utf8(b"Main Wallet"),
            string::utf8(b"crypto"),
            string::utf8(b"aptos"),
            string::utf8(b"publickey123"),
            string::utf8(b"walletaddress123"),
            true,
            1710000000,
            option::some(string::utf8(b"inbuilt"))
        );
        let opt_wallet = wallet::get_wallet(signer::address_of(sender));
        assert!(option::is_some(&opt_wallet), 301);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_create_payment_request(sender: &signer) {
        paylancer::init_events(sender);
        paylancer::create_payment_request(
            sender,
            string::utf8(b"request1"),
            string::utf8(b"user1"),
            string::utf8(b"token1"),
            1000,
            string::utf8(b"pending"),
            1710000000
        );
        let opt_req = payment_request::get_payment_request(signer::address_of(sender));
        assert!(option::is_some(&opt_req), 302);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_mint_virtual_card(sender: &signer) {
        paylancer::init_events(sender);
        paylancer::mint_virtual_card(
            sender,
            string::utf8(b"card1"),
            string::utf8(b"user1"),
            string::utf8(b"4111111111111111"),
            string::utf8(b"12/30"),
            string::utf8(b"123"),
            string::utf8(b"debit"),
            string::utf8(b"active"),
            1710000000
        );
        let opt_card = virtual_cards::get_virtual_card(signer::address_of(sender));
        assert!(option::is_some(&opt_card), 303);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_mint_virtual_account(sender: &signer) {
        paylancer::init_events(sender);
        paylancer::mint_virtual_account(
            sender,
            string::utf8(b"account1"),
            string::utf8(b"user1"),
            string::utf8(b"ACCT123456"),
            string::utf8(b"USD"),
            string::utf8(b"active"),
            1710000000
        );
        let opt_account = virtual_accounts::get_virtual_account(signer::address_of(sender));
        assert!(option::is_some(&opt_account), 304);
    }
}
