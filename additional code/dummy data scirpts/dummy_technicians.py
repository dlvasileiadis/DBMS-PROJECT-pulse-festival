import faker
import random

fake = faker.Faker()
NUMBER_OF_TECHNICIANS = 33
TABLE_NAME = "staff"
OUTPUT_FILENAME = "dummy_data_technician_staff.sql"

# fixed IDs
technician_role_id = 3  # assistant role_id from staff_role
experience_level_ids = [1, 2, 3, 4, 5]  # level_ids from trainee to expert

rows = []

for _ in range(NUMBER_OF_TECHNICIANS):
    full_name = fake.name().replace('"', '\\"')
    age = fake.random_int(min=18, max=60)
    level_id = random.choice(experience_level_ids)

    rows.append(f'("{full_name}", {age}, {technician_role_id}, {level_id})')

values_str = ",\n".join(rows)

sql = f"""INSERT INTO {TABLE_NAME} (
    name,
    age,
    role_id,
    level_id
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {NUMBER_OF_TECHNICIANS} dummy technicians staff entries in '{OUTPUT_FILENAME}'")
