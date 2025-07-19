module paylancer_addr::virtual_accounts {
    use std::string::{String};
    use std::option::{Self, Option};

    struct VirtualAccount has key {
        account_id: String,
        user_id: String,
        account_number: String,
        currency: String,
        balance: u64,
        status: String,
        linked_wallet_id: Option<String>,
        created_at: u64,
        updated_at: Option<u64>,
    }

    public entry fun create_virtual_account(
        account: &signer,
        account_id: String,
        user_id: String,
        account_number: String,
        currency: String,
        status: String,
        created_at: u64
    ) {
        let vaccount = VirtualAccount {
            account_id,
            user_id,
            account_number,
            currency,
            balance: 0,
            status,
            linked_wallet_id: option::none<String>(),
            created_at,
            updated_at: option::none<u64>(),
        };
        move_to(account, vaccount);
    }

    public entry fun update_account_status(account: &signer, new_status: String) acquires VirtualAccount {
        let vaccount = borrow_global_mut<VirtualAccount>(signer::address_of(account));
        vaccount.status = new_status;
        // vaccount.updated_at = Timestamp::now_seconds(); // TODO: set timestamp in production
        vaccount.updated_at = option::none<u64>();
    }

    #[view]
    public fun get_virtual_account(addr: address): Option<VirtualAccount> {
        if (exists<VirtualAccount>(addr)) {
            option::some(borrow_global<VirtualAccount>(addr))
        } else {
            option::none<VirtualAccount>()
        }
    }
}
