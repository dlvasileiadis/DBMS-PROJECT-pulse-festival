
# Real band names based on LOAD file
band_names = [
    "Brown Inc", "Webb and Sons", "Burgess Group", "Parsons-Stafford", "Le Ltd",
    "Patterson Ltd", "Tanner PLC", "Vazquez-Young", "Harper PLC", "Smith-Montoya",
    "Williams-Torres", "Rivers-Briggs", "Hill Ltd", "Rodriguez-Silva",
    "Lindsey, Martin and Davis", "Orr-Wise", "Ryan, Hayden and Davies", "Wheeler-Thompson",
    "Kramer, Garcia and Miller", "Gonzalez, Rivera and Cruz"
]

TABLE_NAME = "band_image"
OUTPUT_FILENAME = "dummy_data_band_logos.sql"

rows = []

for band_id, band_name in enumerate(band_names, start=1):
    image_url = f"https://example.com/band{band_id}_logo.jpg"
    description = f"Logo of band {band_name}"
    rows.append(f"({band_id}, '{image_url}', '{description}')")

values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    band_id,
    image_url,
    description
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created band logos for {len(band_names)} bands into '{OUTPUT_FILENAME}'")
