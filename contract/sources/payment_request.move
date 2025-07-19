module paylancer_addr::payment_request {
    use std::string::{String};
    use std::option::{Self, Option};

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
    }

    public entry fun update_payment_status(account: &signer, new_status: String) acquires PaymentRequest {
        let req = borrow_global_mut<PaymentRequest>(signer::address_of(account));
        req.status = new_status;
    }

    public entry fun delete_payment_request(account: &signer) acquires PaymentRequest {
        move_from<PaymentRequest>(signer::address_of(account));
    }

    #[view]
    public fun get_payment_request(addr: address): Option<PaymentRequest> {
        if (exists<PaymentRequest>(addr)) {
            option::some(borrow_global<PaymentRequest>(addr))
        } else {
            option::none<PaymentRequest>()
        }
    }
}
