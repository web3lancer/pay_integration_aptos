#[test_only]
module paylancer_addr::test_payment_request {
    use std::string;
    use paylancer_addr::payment_request;
    use std::option;

    #[test(sender = @paylancer_addr)]
    public fun test_create_payment_request(sender: &signer) {
        payment_request::create_payment_request(
            sender,
            string::utf8(b"request1"),
            string::utf8(b"user1"),
            string::utf8(b"token1"),
            1000,
            string::utf8(b"pending"),
            1710000000
        );
        let opt_req = payment_request::get_payment_request(signer::address_of(sender));
        assert!(option::is_some(&opt_req), 200);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_update_payment_status(sender: &signer) {
        payment_request::create_payment_request(
            sender,
            string::utf8(b"request2"),
            string::utf8(b"user2"),
            string::utf8(b"token2"),
            2000,
            string::utf8(b"pending"),
            1710000000
        );
        payment_request::update_payment_status(sender, string::utf8(b"paid"));
        let opt_req = payment_request::get_payment_request(signer::address_of(sender));
        assert!(option::is_some(&opt_req), 201);
        let req = option::extract(opt_req);
        assert!(req.status == string::utf8(b"paid"), 202);
    }

    #[test(sender = @paylancer_addr)]
    public fun test_delete_payment_request(sender: &signer) {
        payment_request::create_payment_request(
            sender,
            string::utf8(b"request3"),
            string::utf8(b"user3"),
            string::utf8(b"token3"),
            3000,
            string::utf8(b"pending"),
            1710000000
        );
        payment_request::delete_payment_request(sender);
        let opt_req = payment_request::get_payment_request(signer::address_of(sender));
        assert!(!option::is_some(&opt_req), 203);
    }
}
