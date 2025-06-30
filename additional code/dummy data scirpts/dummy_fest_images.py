
festivals = {
    1: 2017,
    2: 2018,
    3: 2019,
    4: 2020,
    5: 2021,
    6: 2022,
    7: 2023,
    8: 2024,
    9: 2025,
    10: 2026,
}

TABLE_NAME = "festival_image"
OUTPUT_FILENAME = "dummy_data_festival_images.sql"

rows = []

for festival_id, year in festivals.items():
    image_url = f"https://example.com/festival{festival_id}.jpg"
    description = f"Poster for Festival Year {year}"
    rows.append(f"({festival_id}, '{image_url}', '{description}')")

values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    festival_id,
    image_url,
    description
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created festival images for {len(festivals)} festivals into '{OUTPUT_FILENAME}'")
