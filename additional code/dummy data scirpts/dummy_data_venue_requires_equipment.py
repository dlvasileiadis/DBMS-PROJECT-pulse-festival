import random

NUM_VENUES = 30  
NUM_EQUIPMENT = 5  #equip items
TABLE_NAME = "venue_requires_equipment"
OUTPUT_FILENAME = "dummy_data_venue_requires_equipment.sql"

venue_ids = list(range(1, NUM_VENUES + 1))
equipment_ids = list(range(1, NUM_EQUIPMENT + 1))

rows = []

for venue_id in venue_ids:
    # Each venue will require 2 to 5 different types of equipment
    required_equipment = random.sample(equipment_ids, random.randint(2, 5))
    
    for equipment_id in required_equipment:
        quantity = random.randint(1, 10)  # Quantity between 1 and 10
        rows.append(f'({venue_id}, {equipment_id}, {quantity})')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    venue_id,
    equipment_id,
    quantity
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} venue-equipment assignments in '{OUTPUT_FILENAME}'")
