import random

NUM_ARTISTS = 100  
NUM_BANDS = 20     
TABLE_NAME = "artist_belongs"
OUTPUT_FILENAME = "dummy_data_artist_belongs.sql"

artist_ids = list(range(1, NUM_ARTISTS + 1))
band_ids = list(range(1, NUM_BANDS + 1))

rows = set()

for artist_id in artist_ids:
    if random.random() < 0.3:  
        # 30% chance that artist joins a band
        if random.random() < 0.8:
            # 80% chance join only 1 band
            band_id = random.choice(band_ids)
            rows.add((artist_id, band_id))
        else:
            # 20% chance join 2 bands
            two_bands = random.sample(band_ids, 2)
            for band_id in two_bands:
                rows.add((artist_id, band_id))

values = ",\n".join([f'({artist_id}, {band_id})' for artist_id, band_id in rows])

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    artist_id,
    band_id
) VALUES
{values};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} artist-band relationships in '{OUTPUT_FILENAME}'")
