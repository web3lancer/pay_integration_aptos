module paylancer_addr::user {
    use std::string::{String, utf8};
    use std::vector;
    use std::option::{Self, Option};

    struct User has key {
        user_id: String,
        email: String,
        username: String,
        display_name: String,
        profile_image: Option<String>,
        phone_number: Option<String>,
        kyc_status: String,
        kyc_level: u64,
        two_factor_enabled: bool,
        is_active: bool,
        country: Option<String>,
        timezone: Option<String>,
        preferred_currency: String,
        created_at: u64,
        updated_at: u64,
        wallet_ids: vector<String>,
        transaction_ids: vector<String>,
        payment_request_ids: vector<String>,
        security_log_ids: vector<String>,
        api_key_ids: vector<String>,
    }

    public entry fun create_user(
        account: &signer,
        user_id: String,
        email: String,
        username: String,
        display_name: String,
        preferred_currency: String,
        created_at: u64
    ) {
        let user = User {
            user_id,
            email,
            username,
            display_name,
            profile_image: option::none<String>(),
            phone_number: option::none<String>(),
            kyc_status: utf8(b"pending"),
            kyc_level: 0,
            two_factor_enabled: false,
            is_active: true,
            country: option::none<String>(),
            timezone: option::none<String>(),
            preferred_currency,
            created_at,
            updated_at: created_at,
            wallet_ids: vector::empty<String>(),
            transaction_ids: vector::empty<String>(),
            payment_request_ids: vector::empty<String>(),
            security_log_ids: vector::empty<String>(),
            api_key_ids: vector::empty<String>(),
        };
        move_to(account, user);
    }

    public entry fun update_user_email(account: &signer, new_email: String) acquires User {
        let user = borrow_global_mut<User>(signer::address_of(account));
        user.email = new_email;
        user.updated_at = 0; // Set to current timestamp in production
    }

    public entry fun delete_user(account: &signer) acquires User {
        move_from<User>(signer::address_of(account));
    }

    #[view]
    public fun get_user(addr: address): Option<User> {
        if (exists<User>(addr)) {
            option::some(borrow_global<User>(addr))
        } else {
            option::none<User>()
        }
    }
}
