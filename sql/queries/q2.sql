/*for 2024 rock*/

SELECT 
    rock_artists.name AS artist_name,
    CASE
        WHEN (
            EXISTS (
                SELECT 1
                FROM performances p
                JOIN performer perf ON p.performer_id = perf.performer_id
                JOIN event e ON p.event_id = e.event_id
                JOIN festival f ON e.festival_id = f.festival_id
                WHERE 
                    perf.artist_id = rock_artists.artist_id
                    AND f.year = 2024
            )
            OR
            EXISTS (
                SELECT 1
                FROM artist_belongs ab
                JOIN performer perf_band ON ab.band_id = perf_band.band_id
                JOIN performances p2 ON perf_band.performer_id = p2.performer_id
                JOIN event e2 ON p2.event_id = e2.event_id
                JOIN festival f2 ON e2.festival_id = f2.festival_id
                WHERE 
                    ab.artist_id = rock_artists.artist_id
                    AND f2.year = 2024
            )
        ) THEN 'Yes'
        ELSE 'No'
    END AS participated_in_2024
FROM 
    (
        SELECT 
            a.artist_id,
            a.name
        FROM 
            artist a
        JOIN subgenre sg ON a.subgenre_id = sg.subgenre_id
        JOIN genre g ON sg.genre_id = g.genre_id
        WHERE 
            g.name = 'Rock'
    ) AS rock_artists
ORDER BY 
    rock_artists.name;
