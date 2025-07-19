#[test_only]
module paylancer_addr::test_virtual_accounts {
    use std::string;
    use std::option;
    use paylancer_addr::virtual_accounts;

    #[test(sender = @paylancer_addr)]
    public fun test_create_virtual_account(sender: &signer) {
        virtual_accounts::create_virtual_account(
            sender,
            string::utf8(b"account1"),
            string::utf8(b"user1"),
            string::utf8(b"ACCT123456"),
            string::utf8(b"USD"),
            string::utf8(b"active"),
            1710000000
        );
        let opt_account = virtual_accounts::get_virtual_account(signer::address_of(sender));
        assert!(option::is_some(&opt_account), 500);
        let account = option::extract(opt_account);
        assert!(account.account_number == string::utf8(b"ACCT123456"), 501);
    }
}
