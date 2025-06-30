
# Real artist names based on LOAD file 
artist_names = [
    "Tanner Esparza", "William Leblanc", "Jason Lawson", "Megan Scott", "Caroline Keith",
    "Sandra Williams", "Gary Anderson", "Anthony Gonzalez", "Carlos Howell", "Dana Kim",
    "Shannon Pittman", "Jennifer Fuller", "Patricia Christensen", "Christopher Rocha", "Mary Brown",
    "Brooke Smith", "Leslie Caldwell", "Gloria Roman", "Timothy Pham", "Debbie Bishop",
    "John Hunt", "Carrie Harrington", "David Woodard", "Alex Cruz", "Whitney Henry",
    "Dawn Wheeler", "Maria Salas", "Kevin Johnson", "Richard Buckley", "Maria Ramirez",
    "Tammy Campbell", "Brenda Griffin", "Jessica Reid", "Lisa Carter", "Alicia Edwards",
    "Jack Sutton", "Todd Thomas", "Jessica Miller", "Frances Torres", "Andrew Stone",
    "Timothy Browning", "Linda Hester", "Joshua Young", "Kaylee Wyatt", "Thomas Williams",
    "Danielle Bartlett", "Brianna Wright", "Michael Howell", "Matthew Rodriguez", "Nicholas Bailey IV",
    "Christopher Smith", "Deborah Sellers", "Paul Miles", "Jeffrey Harris", "Brittney Alvarez",
    "Christopher Silva", "Karen Smith", "Pamela Martinez", "Jeffrey Rios", "Jacob Guerrero",
    "Courtney Morris", "Brandon Arnold", "Rebecca Shelton", "John Lopez", "Marcus Moore",
    "Casey Bailey", "Alexis Floyd", "Daniel Olson", "Jacob Alvarez", "Kelly Thomas",
    "David Escobar", "John Petersen", "Michael Taylor", "Stacy Cook", "Brett Parks",
    "Sierra Smith", "Jonathan Wagner", "Scott Keith", "Kristina Mitchell", "Johnny Mclaughlin",
    "Monica Martin", "Amanda Doyle", "Jeffrey Guzman", "Lisa Henderson", "Shelby Walker",
    "Jose Fox", "John Chavez", "Steven Mathews", "Christopher Lewis", "Joseph Serrano",
    "Yvonne Zhang", "William Conley", "Kimberly Reed", "Krista Flores", "Thomas Peterson",
    "Julia Fuller", "Scott Haley", "Timothy Everett", "Victoria Campbell", "James Burton"
]

TABLE_NAME = "artist_image"
OUTPUT_FILENAME = "dummy_data_artist_images.sql"

rows = []

for artist_id, artist_name in enumerate(artist_names, start=1):
    image_url = f"https://example.com/artist{artist_id}.jpg"
    description = f"Photo of artist {artist_name}"
    rows.append(f"({artist_id}, '{image_url}', '{description}')")


values_str = ",\n".join(rows)

sql = f"""USE pulse_festival;

INSERT INTO {TABLE_NAME} (
    artist_id,
    image_url,
    description
) VALUES
{values_str};
"""


with open(OUTPUT_FILENAME, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"Created artist images for {len(artist_names)} artists into '{OUTPUT_FILENAME}'")
