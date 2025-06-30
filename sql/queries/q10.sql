/* 
QUERY 10 : 
To find the top 3 genre pairs among artists 
who performed at festivals and cover multiple genres
*/

WITH festival_artists AS (
    -- Artists who performed solo or in bands at festivals
    SELECT DISTINCT a.artist_id
    FROM artist a
    JOIN performer p ON a.artist_id = p.artist_id
    JOIN performances pf ON p.performer_id = pf.performer_id
    JOIN event e ON pf.event_id = e.event_id
    JOIN festival f ON e.festival_id = f.festival_id
    UNION
    SELECT ab.artist_id
    FROM artist_belongs ab
    JOIN band b ON ab.band_id = b.band_id
    JOIN performer p ON b.band_id = p.band_id
    JOIN performances pf ON p.performer_id = pf.performer_id
    JOIN event e ON pf.event_id = e.event_id
    JOIN festival f ON e.festival_id = f.festival_id
),
artist_genres AS (
    -- Genres from artists' solo work and bands
    SELECT 
        fa.artist_id,
        g.name AS genre
    FROM festival_artists fa
    JOIN artist a ON fa.artist_id = a.artist_id
    JOIN subgenre s ON a.subgenre_id = s.subgenre_id
    JOIN genre g ON s.genre_id = g.genre_id
    UNION
    SELECT 
        fa.artist_id,
        g.name AS genre
    FROM festival_artists fa
    JOIN artist_belongs ab ON fa.artist_id = ab.artist_id
    JOIN band b ON ab.band_id = b.band_id
    JOIN subgenre s ON b.subgenre_id = s.subgenre_id
    JOIN genre g ON s.genre_id = g.genre_id
),
genre_pairs AS (
    -- Generate unique genre pairs per artist
    SELECT
        ag1.genre AS genre1,
        ag2.genre AS genre2
    FROM artist_genres ag1
    JOIN artist_genres ag2 ON ag1.artist_id = ag2.artist_id
    WHERE ag1.genre < ag2.genre  -- Avoid duplicates like (Rock, Jazz) vs (Jazz, Rock)
)
SELECT 
    genre1,
    genre2,
    COUNT(*) AS pair_count
FROM genre_pairs
GROUP BY genre1, genre2
ORDER BY pair_count DESC
LIMIT 3;