#[test_only]
module paylancer_addr::test_user {
    use std::string;
    use paylancer_addr::user;

    #[test(sender = @paylancer_addr)]
    public fun test_create_user(sender: &signer) {
        user::create_user(
            sender,
            string::utf8(b"user1"),
            string::utf8(b"user1@example.com"),
            string::utf8(b"user1"),
            string::utf8(b"User One"),
            string::utf8(b"USD"),
            1710000000
        );
        // No assert, just ensure no abort
    }

    #[test(sender = @paylancer_addr)]
    public fun test_update_user_email(sender: &signer) {
        user::create_user(
            sender,
            string::utf8(b"user2"),
            string::utf8(b"user2@example.com"),
            string::utf8(b"user2"),
            string::utf8(b"User Two"),
            string::utf8(b"USD"),
            1710000000
        );
        user::update_user_email(sender, string::utf8(b"newuser2@example.com"));
    }

    #[test(sender = @paylancer_addr)]
    public fun test_delete_user(sender: &signer) {
        user::create_user(
            sender,
            string::utf8(b"user3"),
            string::utf8(b"user3@example.com"),
            string::utf8(b"user3"),
            string::utf8(b"User Three"),
            string::utf8(b"USD"),
            1710000000
        );
        user::delete_user(sender);
    }
}
