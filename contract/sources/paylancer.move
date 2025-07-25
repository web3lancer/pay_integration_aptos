module paylancer_addr::paylancer {
    use std::string::{String, utf8};
    use std::vector;
    use std::option::{Self, Option};
    use aptos_framework::event::{EventHandle, emit_event};
    use paylancer_addr::user;
    use paylancer_addr::wallet;
    use paylancer_addr::payment_request;

    /// Events for logging actions
    struct PaylancerEvents has key {
        user_created: EventHandle<User>,
        wallet_created: EventHandle<Wallet>,
        transaction_created: EventHandle<Transaction>,
        payment_request_created: EventHandle<PaymentRequest>,
        virtual_card_created: EventHandle<VirtualCard>,
        virtual_account_created: EventHandle<VirtualAccount>,
    }

    /// Initialize events for the module
    public entry fun init_events(account: &signer) {
        move_to(account, PaylancerEvents {
            user_created: aptos_framework::event::new_event_handle<User>(account),
            wallet_created: aptos_framework::event::new_event_handle<Wallet>(account),
            transaction_created: aptos_framework::event::new_event_handle<Transaction>(account),
            payment_request_created: aptos_framework::event::new_event_handle<PaymentRequest>(account),
            virtual_card_created: aptos_framework::event::new_event_handle<VirtualCard>(account),
            virtual_account_created: aptos_framework::event::new_event_handle<VirtualAccount>(account),
        });
    }

    /// Example: Forward create_user to user module
    public entry fun create_user(
        account: &signer,
        user_id: std::string::String,
        email: std::string::String,
        username: std::string::String,
        display_name: std::string::String,
        preferred_currency: std::string::String,
        created_at: u64
    ) {
        user::create_user(account, user_id, email, username, display_name, preferred_currency, created_at);
    }

    /// Example: Forward create_wallet to wallet module
    public entry fun create_wallet(
        account: &signer,
        wallet_id: std::string::String,
        user_id: std::string::String,
        wallet_name: std::string::String,
        wallet_type: std::string::String,
        blockchain: std::string::String,
        public_key: std::string::String,
        wallet_address: std::string::String,
        is_default: bool,
        created_at: u64,
        creation_method: std::option::Option<std::string::String>
    ) {
        wallet::create_wallet(account, wallet_id, user_id, wallet_name, wallet_type, blockchain, public_key, wallet_address, is_default, created_at, creation_method);
    }

    /// Example: Forward create_payment_request to payment_request module
    public entry fun create_payment_request(
        account: &signer,
        request_id: std::string::String,
        from_user_id: std::string::String,
        token_id: std::string::String,
        amount: u64,
        status: std::string::String,
        created_at: u64
    ) {
        payment_request::create_payment_request(account, request_id, from_user_id, token_id, amount, status, created_at);
    }

    // ...add similar forwarding for other resources/modules...
}
        to_address: String,
        token_id: String,
        amount: u64,
        fee_amount: u64,
        gas_price: Option<u64>,
        gas_used: Option<u64>,
        status: String,
        tx_type: String,
        description: Option<String>,
        metadata: Option<String>,
        block_number: Option<u64>,
        confirmations: u64,
        created_at: u64,
        confirmed_at: Option<u64>,
        payment_request_id: Option<String>,
    }

    /// Payment Request resource
    struct PaymentRequest has key {
        request_id: String,
        from_user_id: String,
        to_user_id: Option<String>,
        to_email: Option<String>,
        token_id: String,
        amount: u64,
        description: Option<String>,
        due_date: Option<u64>,
        status: String,
        payment_tx_id: Option<String>,
        invoice_number: Option<String>,
        metadata: Option<String>,
        created_at: u64,
        paid_at: Option<u64>,
    }

    /// Virtual Card resource
    struct VirtualCard has key {
        card_id: String,
        user_id: String,
        card_number: String,
        expiry: String,
        cvv: String,
        card_type: String,
        status: String,
        linked_wallet_id: Option<String>,
        created_at: u64,
        updated_at: Option<u64>,
    }

    /// Virtual Account resource
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

    /// Events for logging actions
    struct PaylancerEvents has key {
        user_created: EventHandle<User>,
        wallet_created: EventHandle<Wallet>,
        transaction_created: EventHandle<Transaction>,
        payment_request_created: EventHandle<PaymentRequest>,
        virtual_card_created: EventHandle<VirtualCard>,
        virtual_account_created: EventHandle<VirtualAccount>,
    }

    /// Initialize events for the module
    public entry fun init_events(account: &signer) {
        move_to(account, PaylancerEvents {
            user_created: aptos_framework::event::new_event_handle<User>(account),
            wallet_created: aptos_framework::event::new_event_handle<Wallet>(account),
            transaction_created: aptos_framework::event::new_event_handle<Transaction>(account),
            payment_request_created: aptos_framework::event::new_event_handle<PaymentRequest>(account),
            virtual_card_created: aptos_framework::event::new_event_handle<VirtualCard>(account),
            virtual_account_created: aptos_framework::event::new_event_handle<VirtualAccount>(account),
        });
    }

    /// Entry function: Create a new user
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
        emit_event(&mut borrow_global_mut<PaylancerEvents>(signer::address_of(account)).user_created, user);
    }

    /// Entry function: Create a new wallet for a user
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
        emit_event(&mut borrow_global_mut<PaylancerEvents>(signer::address_of(account)).wallet_created, wallet);
    }

    /// Entry function: Create a payment request
    public entry fun create_payment_request(
        account: &signer,
        request_id: String,
        from_user_id: String,
        token_id: String,
        amount: u64,
        status: String,
        created_at: u64
    ) {
        let payment_request = PaymentRequest {
            request_id,
            from_user_id,
            to_user_id: option::none<String>(),
            to_email: option::none<String>(),
            token_id,
            amount,
            description: option::none<String>(),
            due_date: option::none<u64>(),
            status,
            payment_tx_id: option::none<String>(),
            invoice_number: option::none<String>(),
            metadata: option::none<String>(),
            created_at,
            paid_at: option::none<u64>(),
        };
        move_to(account, payment_request);
        emit_event(&mut borrow_global_mut<PaylancerEvents>(signer::address_of(account)).payment_request_created, payment_request);
    }

    /// Entry function: Mint a virtual card
    public entry fun mint_virtual_card(
        account: &signer,
        card_id: String,
        user_id: String,
        card_number: String,
        expiry: String,
        cvv: String,
        card_type: String,
        status: String,
        created_at: u64
    ) {
        let card = VirtualCard {
            card_id,
            user_id,
            card_number,
            expiry,
            cvv,
            card_type,
            status,
            linked_wallet_id: option::none<String>(),
            created_at,
            updated_at: option::none<u64>(),
        };
        move_to(account, card);
        emit_event(&mut borrow_global_mut<PaylancerEvents>(signer::address_of(account)).virtual_card_created, card);
    }

    /// Entry function: Mint a virtual account
    public entry fun mint_virtual_account(
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
        emit_event(&mut borrow_global_mut<PaylancerEvents>(signer::address_of(account)).virtual_account_created, vaccount);
    }

    // ...add more entry functions for transactions, tokens, security logs, api keys, etc...

    // ...add view functions for reading resources, e.g. get_user, get_wallet, get_payment_request, etc...

    // ...add helper functions for business logic, e.g. transfer, pay, update status, etc...
}
