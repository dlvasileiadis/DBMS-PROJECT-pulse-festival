SELECT 
    a.name AS artist_name,
    TIMESTAMPDIFF(YEAR, a.birth_date, CURDATE()) AS age,
    COUNT(DISTINCT afp.festival_id) AS festivals_participated
FROM 
    artist_festival_participations afp
JOIN 
    artist a ON afp.artist_id = a.artist_id
WHERE 
    TIMESTAMPDIFF(YEAR, a.birth_date, CURDATE()) < 30
GROUP BY 
    a.artist_id, a.name, age
HAVING 
    COUNT(DISTINCT afp.festival_id) = (
        SELECT MAX(festival_count)
        FROM (
            SELECT 
                afp2.artist_id,
                COUNT(DISTINCT afp2.festival_id) AS festival_count
            FROM 
                artist_festival_participations afp2
            JOIN 
                artist a2 ON afp2.artist_id = a2.artist_id
            WHERE 
                TIMESTAMPDIFF(YEAR, a2.birth_date, CURDATE()) < 30
            GROUP BY 
                afp2.artist_id
        ) AS max_counts
    )
ORDER BY 
    artist_name;
