import random


NUM_VENUES = 30
TABLE_NAME = "venue_staff_assignment"
OUTPUT_FILENAME = "dummy_data_all_staff_assignment.sql"

# Staff IDs based on your clean setup:
#  security: 1–96
#  assistant: 97–159
#  technician: 160–192

security_staff_ids = list(range(1, 97))    # 96 security
assistant_staff_ids = list(range(97, 160)) # 63 assistants
technician_staff_ids = list(range(160, 193)) # 33 technicians

# Shuffle and select exact numbers needed
selected_security = random.sample(security_staff_ids, 90)  # 3 per venue x 30 venues = 90
selected_assistants = random.sample(assistant_staff_ids, 60)  # 2 per venue x 30 venues = 60
selected_technicians = random.sample(technician_staff_ids, 30)  # 1 per venue x 30 venues = 30

rows = []
venue_ids = list(range(1, NUM_VENUES + 1))

# Assign 3 security, 2 assistants, 1 technician per venue
for venue_id in venue_ids:
    # Pick staff
    sec1 = selected_security.pop()
    sec2 = selected_security.pop()
    sec3 = selected_security.pop()
    
    assistant1 = selected_assistants.pop()
    assistant2 = selected_assistants.pop()
    
    technician = selected_technicians.pop()
    
    # Insert all 6 in one block
    rows.append(f'({venue_id}, {sec1})')
    rows.append(f'({venue_id}, {sec2})')
    rows.append(f'({venue_id}, {sec3})')
    rows.append(f'({venue_id}, {assistant1})')
    rows.append(f'({venue_id}, {assistant2})')
    rows.append(f'({venue_id}, {technician})')


values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    venue_id,
    staff_id
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} staff assignments (3 security + 2 assistants + 1 technician per venue) in '{OUTPUT_FILENAME}'")
