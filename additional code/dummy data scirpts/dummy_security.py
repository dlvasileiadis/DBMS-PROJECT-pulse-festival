import faker
import random

fake = faker.Faker()
NUMBER_OF_SECURITY_STAFF = 30
TABLE_NAME = "staff"
OUTPUT_FILENAME = "dummy_data_security_staff.sql"

# Fixed IDs
security_role_id = 1  # security role_id
experience_level_ids = [1, 2, 3, 4, 5]  # level_ids from trainee to expert

rows = []

for _ in range(NUMBER_OF_SECURITY_STAFF):
    full_name = fake.name().replace('"', '\\"')
    age = fake.random_int(min=18, max=60)
    level_id = random.choice(experience_level_ids)

    rows.append(f'("{full_name}", {age}, {security_role_id}, {level_id})')

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

print(f"Created {NUMBER_OF_SECURITY_STAFF} dummy security staff entries in '{OUTPUT_FILENAME}'")
