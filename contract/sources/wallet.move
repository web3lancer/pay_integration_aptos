module paylancer_addr::wallet {
    use std::string::{String};
    use std::option::{Self, Option};

    struct Wallet has key {
        wallet_id: String,
        user_id: String,
        wallet_name: String,
        wallet_type: String,
        blockchain: String,
        public_key: String,
        encrypted_private_key: Option<String>,
        wallet_address: String,
        derivation_path: Option<String>,
        is_default: bool,
        is_active: bool,
        balance: u64,
        last_sync_at: Option<u64>,
        created_at: u64,
        creation_method: Option<String>,
    }

    public entry fun create_wallet(
        account: &signer,
        wallet_id: String,
        user_id: String,
        wallet_name: String,
        wallet_type: String,
        blockchain: String,
        public_key: String,
        wallet_address: String,
        is_default: bool,
        created_at: u64,
        creation_method: Option<String>
    ) {
        let wallet = Wallet {
            wallet_id,
            user_id,
            wallet_name,
            wallet_type,
            blockchain,
            public_key,
            encrypted_private_key: option::none<String>(),
            wallet_address,
            derivation_path: option::none<String>(),
            is_default,
            is_active: true,
            balance: 0,
            last_sync_at: option::none<u64>(),
            created_at,
            creation_method,
        };
        move_to(account, wallet);
    }

    public entry fun update_wallet_name(account: &signer, new_name: String) acquires Wallet {
        let wallet = borrow_global_mut<Wallet>(signer::address_of(account));
        wallet.wallet_name = new_name;
    }

    public entry fun delete_wallet(account: &signer) acquires Wallet {
        move_from<Wallet>(signer::address_of(account));
    }

    #[view]
    public fun get_wallet(addr: address): Option<Wallet> {
        if (exists<Wallet>(addr)) {
            option::some(borrow_global<Wallet>(addr))
        } else {
            option::none<Wallet>()
        }
    }
}
