
venues = {
    1: "Jensen, Davis and Rice Stage",
    2: "Brown, Harvey and Vasquez Stage",
    3: "Johnson-Shepherd Stage",
    4: "Silva PLC Stage",
    5: "Mason Group Stage",
    6: "Reed and Sons Stage",
    7: "Sanders PLC Stage",
    8: "Garcia-Reyes Stage",
    9: "Meyer, Rice and Evans Stage",
    10: "Dalton PLC Stage",
    11: "Myers Inc Stage",
    12: "Black Inc Stage",
    13: "Smith-King Stage",
    14: "Wong, Pope and Lyons Stage",
    15: "Maxwell LLC Stage",
    16: "Davis-Tyler Stage",
    17: "Thomas, Chang and Bates Stage",
    18: "Hammond-Fry Stage",
    19: "Gutierrez, Lewis and Cook Stage",
    20: "Knox, Davis and Leonard Stage",
    21: "Lee Group Stage",
    22: "Rogers Inc Stage",
    23: "Romero, Whitehead and Parker Stage",
    24: "Rodriguez PLC Stage",
    25: "Bailey-Williams Stage",
    26: "Anderson Group Stage",
    27: "Taylor-Clark Stage",
    28: "Evans-Finley Stage",
    29: "Hamilton-Taylor Stage",
    30: "Deleon-Fry Stage",
}

TABLE_NAME = "venue_image"
OUTPUT_FILENAME = "dummy_data_venue_images.sql"

rows = []

for venue_id, venue_name in venues.items():
    image_url = f"https://example.com/venue{venue_id}.jpg"
    description = f"Photo of {venue_name}"
    rows.append(f"({venue_id}, '{image_url}', '{description}')")

values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    venue_id,
    image_url,
    description
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created venue images for {len(venues)} venues into '{OUTPUT_FILENAME}'")
