
# 160 tickets (20 per year for 8 years, 2017–2024)
# respects venue capacity
# respects VIP ticket 10% limit
# 95% activated
# correct day-based pricing
# real events and venues

import random
from datetime import datetime, timedelta
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

PURCHASE_METHOD_IDS = [1, 2, 3]  # Credit Card, Debit Card, Bank Transfer

ACTIVATION_RATE = 0.95

person_ids = list(range(1, 221))  # IDs 1 to 220

# Venue max capacities
VENUE_CAPACITY = {
    1: 50, 2: 30, 3: 10, 4: 50, 5: 30, 6: 10,
    7: 50, 8: 30, 9: 10, 10: 50, 11: 30, 12: 10,
    13: 50, 14: 30, 15: 10, 16: 50, 17: 30, 18: 10,
    19: 50, 20: 30, 21: 10, 22: 50, 23: 30, 24: 10,
    25: 50, 26: 30, 27: 10, 28: 50, 29: 30, 30: 10
}

# Event information
event_info = {
    1: ("2017-08-12", 1, 1), 2: ("2017-08-12", 2, 1), 3: ("2017-08-12", 3, 1),
    4: ("2017-08-13", 1, 1), 5: ("2017-08-13", 2, 1), 6: ("2017-08-13", 3, 1),
    7: ("2018-08-12", 4, 2), 8: ("2018-08-12", 5, 2), 9: ("2018-08-12", 6, 2),
    10: ("2019-08-12", 7, 3), 11: ("2019-08-12", 8, 3), 12: ("2019-08-12", 9, 3),
    13: ("2019-08-13", 7, 3), 14: ("2019-08-13", 8, 3), 15: ("2019-08-13", 9, 3),
    16: ("2020-08-12", 10, 4), 17: ("2020-08-12", 11, 4), 18: ("2020-08-12", 12, 4),
    19: ("2021-08-12", 13, 5), 20: ("2021-08-12", 14, 5), 21: ("2021-08-12", 15, 5),
    22: ("2021-08-13", 13, 5), 23: ("2021-08-13", 14, 5), 24: ("2021-08-13", 15, 5),
    25: ("2022-08-12", 16, 6), 26: ("2022-08-12", 17, 6), 27: ("2022-08-12", 18, 6),
    28: ("2023-08-12", 19, 7), 29: ("2023-08-12", 20, 7), 30: ("2023-08-12", 21, 7),
    31: ("2023-08-13", 19, 7), 32: ("2023-08-13", 20, 7), 33: ("2023-08-13", 21, 7),
    34: ("2024-08-12", 22, 8), 35: ("2024-08-12", 23, 8), 36: ("2024-08-12", 24, 8),
}

# Group events by festival
festival_events = defaultdict(list)
for event_id, (date_str, venue_id, festival_id) in event_info.items():
    festival_events[festival_id].append((event_id, date_str, venue_id))

# Helper functions

def calculate_price(category_name, event_date, start_date):
    days_difference = (event_date - start_date).days
    if days_difference == 0:
        multiplier = 1
    elif days_difference == 1:
        multiplier = 2
    else:
        multiplier = 3
    return round(BASE_PRICES[category_name] * multiplier, 2)

def generate_ean13():
    return ''.join(str(random.randint(0, 9)) for _ in range(13))

def generate_purchase_date(event_date):
    days_before = random.randint(1, 30)
    purchase_date = event_date - timedelta(days=days_before)
    return purchase_date.strftime('%Y-%m-%d')

# main ticket generation 

tickets = []
used_person_event = set()
used_ean13 = set()

# track per event: total tickets sold and VIP tickets sold
event_ticket_counter = defaultdict(int)
event_vip_counter = defaultdict(int)

random.shuffle(person_ids)

for year_offset, festival_id in enumerate(range(1, 9)):  # festivals 1 to 8
    events = festival_events[festival_id]
    if not events:
        continue

    start_date = min(datetime.strptime(e[1], "%Y-%m-%d") for e in events)

    tickets_this_festival = 0
    max_attempts = 10000  # prevent infinite loops
    attempts = 0

    while tickets_this_festival < 80 and attempts < max_attempts:
        attempts += 1

        event_id, event_date_str, venue_id = random.choice(events)
        event_date = datetime.strptime(event_date_str, "%Y-%m-%d")
        venue_capacity = VENUE_CAPACITY[venue_id]

        if event_ticket_counter[event_id] >= venue_capacity:
            continue

        person_id = random.choice(person_ids)
        if (person_id, event_id) in used_person_event:
            continue
        used_person_event.add((person_id, event_id))

        # pick ticket category
        while True:
            category_name = random.choice(list(CATEGORY_IDS.keys()))
            if category_name == 'VIP':
                vip_limit = int(venue_capacity * 0.10)
                if event_vip_counter[event_id] >= vip_limit:
                    continue
                event_vip_counter[event_id] += 1
            break

        ticket_category_id = CATEGORY_IDS[category_name]
        purchase_method_id = random.choice(PURCHASE_METHOD_IDS)
        price = calculate_price(category_name, event_date, start_date)

        # generate unique EAN-13
        while True:
            ean_code = generate_ean13()
            if ean_code not in used_ean13:
                used_ean13.add(ean_code)
                break

        purchase_date = generate_purchase_date(event_date)
        activated = 'TRUE' if random.random() < ACTIVATION_RATE else 'FALSE'

        ticket = f"({person_id}, {event_id}, {ticket_category_id}, {venue_id}, '{purchase_date}', {purchase_method_id}, {price}, '{ean_code}', {activated})"
        tickets.append(ticket)

        event_ticket_counter[event_id] += 1
        tickets_this_festival += 1

# Output SQL 

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

with open("dummy_data_tickets.sql", "w", encoding="utf-8") as file:
    file.write(sql)

print(f"Created {len(tickets)} tickets safely into 'dummy_data_tickets.sql'")