module paylancer_addr::virtual_cards {
    use std::string::{String};
    use std::option::{Self, Option};

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

    public entry fun create_virtual_card(
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
    }

    public entry fun update_card_status(account: &signer, new_status: String) acquires VirtualCard {
        let card = borrow_global_mut<VirtualCard>(signer::address_of(account));
        card.status = new_status;
        // card.updated_at = Timestamp::now_seconds(); // TODO: set timestamp in production
        card.updated_at = option::none<u64>();
    }

    #[view]
    public fun get_virtual_card(addr: address): Option<VirtualCard> {
        if (exists<VirtualCard>(addr)) {
            option::some(borrow_global<VirtualCard>(addr))
        } else {
            option::none<VirtualCard>()
        }
    }
}
