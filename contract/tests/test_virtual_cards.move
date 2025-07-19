#[test_only]
module paylancer_addr::test_virtual_cards {
    use std::string;
    use std::option;
    use paylancer_addr::virtual_cards;

    #[test(sender = @paylancer_addr)]
    public fun test_create_virtual_card(sender: &signer) {
        virtual_cards::create_virtual_card(
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
        assert!(option::is_some(&opt_card), 400);
        let card = option::extract(opt_card);
        assert!(card.card_number == string::utf8(b"4111111111111111"), 401);
    }
}
