#[test_only]
module paylancer_addr::test_wallet {
    use std::string;
    use std::option;
    use paylancer_addr::wallet;

    #[test(sender = @paylancer_addr)]
    public fun test_create_wallet(sender: &signer) {
        wallet::create_wallet(
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
    }

    #[test(sender = @paylancer_addr)]
    public fun test_update_wallet_name(sender: &signer) {
        wallet::create_wallet(
            sender,
            string::utf8(b"wallet2"),
            string::utf8(b"user2"),
            string::utf8(b"Secondary Wallet"),
            string::utf8(b"crypto"),
            string::utf8(b"aptos"),
            string::utf8(b"publickey456"),
            string::utf8(b"walletaddress456"),
            false,
            1710000000,
            option::some(string::utf8(b"imported"))
        );
        wallet::update_wallet_name(sender, string::utf8(b"Updated Wallet Name"));
        let opt_wallet = wallet::get_wallet(signer::address_of(sender));
        assert!(option::is_some(&opt_wallet), 100);
        let w = option::extract(opt_wallet);
        assert!(w.wallet_name == string::utf8(b"Updated Wallet Name"), 101);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_delete_wallet(sender: &signer) {
        wallet::create_wallet(
            sender,
            string::utf8(b"wallet3"),
            string::utf8(b"user3"),
            string::utf8(b"Delete Wallet"),
            string::utf8(b"crypto"),
            string::utf8(b"aptos"),
            string::utf8(b"publickey789"),
            string::utf8(b"walletaddress789"),
            false,
            1710000000,
            option::none<string::String>()
        );
        wallet::delete_wallet(sender);
        let opt_wallet = wallet::get_wallet(signer::address_of(sender));
        assert!(!option::is_some(&opt_wallet), 102);
    }
}
