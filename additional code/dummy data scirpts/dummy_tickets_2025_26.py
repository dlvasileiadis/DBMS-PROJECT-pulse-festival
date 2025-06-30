
# Generates tickets for 2025 and 2026:
# 30 tickets per year (sold out the small venue)
# Activated = FALSE
# Venue capacity and VIP limits respected
# Prises increase depeanding on the day

import random
from datetime import datetime
from collections import defaultdict



BASE_PRICES = {
    'General Admission': 5.00,
    'VIP': 10.00,
    'Backstage': 15.00
}

CATEGORY_IDS = {
    'General Admission': 1,
    'VIP': 2,
    'Backstage': 3
}

PURCHASE_METHOD_IDS = [1, 2, 3]  # credit, debit, transfer

# person ids (1–250)
person_ids = list(range(1, 251))

# Venue capacities
VENUE_CAPACITY = {
    1: 50, 2: 30, 3: 10, 4: 50, 5: 30, 6: 10,
    7: 50, 8: 30, 9: 10, 10: 50, 11: 30, 12: 10,
    13: 50, 14: 30, 15: 10, 16: 50, 17: 30, 18: 10,
    19: 50, 20: 30, 21: 10, 22: 50, 23: 30, 24: 10,
    25: 50, 26: 30, 27: 10, 28: 50, 29: 30, 30: 10
}

# events (ONLY for festivals 9 and 10 = years 2025, 2026)
event_info = {
    37: ("2025-08-12", 25, 9),
    38: ("2025-08-12", 26, 9),
    39: ("2025-08-12", 27, 9),
    40: ("2025-08-13", 25, 9),
    41: ("2025-08-13", 26, 9),
    42: ("2025-08-13", 27, 9),
    43: ("2026-08-12", 28, 10),
    44: ("2026-08-12", 29, 10),
    45: ("2026-08-12", 30, 10)
}

# Group events by festival
festival_events = defaultdict(list)
for event_id, (date_str, venue_id, festival_id) in event_info.items():
    festival_events[festival_id].append((event_id, date_str, venue_id))

# Helpers

def calculate_price(category_name, event_date, start_date):
    """Calculate ticket price depending on the day difference."""
    days_difference = (event_date - start_date).days
    if days_difference == 0:
        multiplier = 1
    elif days_difference == 1:
        multiplier = 2
    else:
        multiplier = 3
    return round(BASE_PRICES[category_name] * multiplier, 2)

def generate_ean13():
    """Generate unique 13-digit EAN code."""
    return ''.join(str(random.randint(0, 9)) for _ in range(13))

# ticket generation

tickets = []
used_person_event = set()
used_ean13 = set()

# track tickets per event and VIP per event
event_ticket_counter = defaultdict(int)
event_vip_counter = defaultdict(int)

random.shuffle(person_ids)
person_pool = person_ids.copy()

for festival_id in [9, 10]:  # 2025 and 2026
    events = festival_events[festival_id]
    if not events:
        continue

    start_date = min(datetime.strptime(e[1], "%Y-%m-%d") for e in events)

    # *** 1. SOLD OUT SMALL VENUE FIRST ***
    # find event with small venue (capacity 10)
    small_event = None
    for event_id, date_str, venue_id in events:
        if VENUE_CAPACITY[venue_id] == 10:
            small_event = (event_id, date_str, venue_id)
            break

    if not small_event:
        raise Exception(f"No small venue (capacity 10) found for festival {festival_id}")

    event_id, date_str, venue_id = small_event
    event_date = datetime.strptime(date_str, "%Y-%m-%d")
    vip_limit = max(1, int(VENUE_CAPACITY[venue_id] * 0.10))

    for _ in range(10):
        while True:
            person_id = random.choice(person_pool)
            if (person_id, event_id) not in used_person_event:
                used_person_event.add((person_id, event_id))
                person_pool.remove(person_id)
                break

        # category
        while True:
            category_name = random.choice(list(CATEGORY_IDS.keys()))
            if category_name == 'VIP':
                if event_vip_counter[event_id] >= vip_limit:
                    continue
                event_vip_counter[event_id] += 1
            break

        ticket_category_id = CATEGORY_IDS[category_name]
        purchase_method_id = random.choice(PURCHASE_METHOD_IDS)
        price = calculate_price(category_name, event_date, start_date)

        while True:
            ean_code = generate_ean13()
            if ean_code not in used_ean13:
                used_ean13.add(ean_code)
                break

        activated = 'FALSE'  # tickets not activated

        ticket = f"({person_id}, {event_id}, {ticket_category_id}, {venue_id}, CURRENT_DATE, {purchase_method_id}, {price}, '{ean_code}', {activated})"
        tickets.append(ticket)

        event_ticket_counter[event_id] += 1

    # RANDOM 20 TICKETS 
    for _ in range(20):
        while True:
            random_event_id, date_str, venue_id = random.choice(events)
            venue_capacity = VENUE_CAPACITY[venue_id]
            event_date = datetime.strptime(date_str, "%Y-%m-%d")

            if event_ticket_counter[random_event_id] >= venue_capacity:
                continue  # venue full

            person_id = random.choice(person_pool)
            if (person_id, random_event_id) in used_person_event:
                continue  # already has ticket for this event

            used_person_event.add((person_id, random_event_id))
            person_pool.remove(person_id)

            vip_limit = max(1, int(venue_capacity * 0.10))

            # category
            while True:
                category_name = random.choice(list(CATEGORY_IDS.keys()))
                if category_name == 'VIP':
                    if event_vip_counter[random_event_id] >= vip_limit:
                        continue
                    event_vip_counter[random_event_id] += 1
                break

            ticket_category_id = CATEGORY_IDS[category_name]
            purchase_method_id = random.choice(PURCHASE_METHOD_IDS)
            price = calculate_price(category_name, event_date, start_date)

            while True:
                ean_code = generate_ean13()
                if ean_code not in used_ean13:
                    used_ean13.add(ean_code)
                    break

            activated = 'FALSE'

            ticket = f"({person_id}, {random_event_id}, {ticket_category_id}, {venue_id}, CURRENT_DATE, {purchase_method_id}, {price}, '{ean_code}', {activated})"
            tickets.append(ticket)

            event_ticket_counter[random_event_id] += 1
            break  # move to next ticket



sql = f"""USE pulse_festival;

INSERT INTO ticket (
    person_id,
    event_id,
    ticket_category_id,
    venue_id,
    purchase_date,
    purchase_method_id,
    price,
    EAN_13_code,
    activated
) VALUES
{',\n'.join(tickets)};
"""

with open("dummy_data_tickets_2025_2026.sql", "w", encoding="utf-8") as file:
    file.write(sql)

print(f"Created {len(tickets)} tickets for 2025–2026 into 'dummy_data_tickets_2025_2026.sql'")
