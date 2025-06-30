import random

NUM_ARTISTS = 100
NUM_BANDS = 20
TABLE_NAME = "performer"
OUTPUT_FILENAME = "dummy_data_performers.sql"

# real artist-belongs data
artists_in_band = {
    55, 86, 70, 41, 9, 99, 2, 10, 8, 65,
    24, 48, 18, 23, 92, 77, 44, 57, 20, 40,
    60, 37, 94, 1, 42, 51, 25, 31
}

artist_ids = list(range(1, NUM_ARTISTS + 1))
band_ids = list(range(1, NUM_BANDS + 1))

rows = []

# solo artists
for artist_id in artist_ids:
    if artist_id not in artists_in_band:
        rows.append(f"({artist_id}, NULL)")

# bands
for band_id in band_ids:
    rows.append(f"(NULL, {band_id})")

values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    artist_id,
    band_id
) VALUES
{values_str};
"""

with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created {len(rows)} performer entries in '{OUTPUT_FILENAME}' without manual performer_id (auto-incremented by database)")
