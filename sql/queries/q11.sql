WITH ArtistParticipations AS (
    /*solo performances*/
    SELECT 
        a.artist_id,
        a.name AS artist_name,
        COUNT(*) AS participation_count
    FROM artist a
    JOIN performer p ON a.artist_id = p.artist_id
    JOIN performances pf ON p.performer_id = pf.performer_id
    JOIN event e ON pf.event_id = e.event_id
    GROUP BY a.artist_id, a.name
    
    UNION ALL
    
    /* Band performances */
    SELECT 
        ab.artist_id,
        a.name AS artist_name,
        COUNT(*) AS participation_count
    FROM artist_belongs ab
    JOIN band b ON ab.band_id = b.band_id
    JOIN performer p ON b.band_id = p.band_id
    JOIN performances pf ON p.performer_id = pf.performer_id
    JOIN event e ON pf.event_id = e.event_id
    JOIN artist a ON ab.artist_id = a.artist_id
    GROUP BY ab.artist_id, a.name
),

TotalParticipations AS (
    SELECT 
        artist_id,
        artist_name,
        SUM(participation_count) AS total_participations
    FROM ArtistParticipations
    GROUP BY artist_id, artist_name
),

MaxParticipation AS (
    SELECT MAX(total_participations) AS max_count
    FROM TotalParticipations
)

SELECT 
    tp.artist_id,
    tp.artist_name,
    tp.total_participations
FROM 
    TotalParticipations tp
CROSS JOIN 
    MaxParticipation mp
WHERE 
    tp.total_participations <= (mp.max_count - 5)
ORDER BY 
    tp.total_participations DESC,
    tp.artist_id;