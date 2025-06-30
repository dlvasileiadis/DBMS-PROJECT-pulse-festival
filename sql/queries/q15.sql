/*same issue with query 4
/* based on our structure of the review table an artist_review is about artists, only
if the performance is solo.If the performance is a band we have a problem because 
the artist_rating is going to refer to the band. therefore in order to be accurate
we will intentionally  choose solo performances only.
*/




SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS visitor_name,
    a.name AS artist_name,
    SUM(
        r.artist_rating + r.sound_light_rating + r.stage_presence + r.organization_rating + r.overall_impression
    ) AS total_score
FROM 
    review r
JOIN 
    ticket t ON r.ticket_id = t.ticket_id
JOIN 
    person p ON r.person_id = p.person_id
JOIN 
    performances pf ON r.performance_id = pf.performance_id
JOIN 
    performer pr ON pf.performer_id = pr.performer_id
JOIN 
    artist a ON pr.artist_id = a.artist_id
WHERE 
    t.activated = TRUE
    AND pr.artist_id IS NOT NULL
    AND pr.band_id IS NULL
GROUP BY 
    p.person_id, a.artist_id, p.first_name, p.last_name, a.name
ORDER BY 
    total_score DESC
LIMIT 5;


/* this one includes bands too

SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS visitor_name,
    COALESCE(a.name, b.name) AS performer_name,
    SUM(
        r.artist_rating + r.sound_light_rating + r.stage_presence + r.organization_rating + r.overall_impression
    ) AS total_score
FROM 
    review r
JOIN 
    ticket t ON r.ticket_id = t.ticket_id
JOIN 
    person p ON r.person_id = p.person_id
JOIN 
    performances pf ON r.performance_id = pf.performance_id
JOIN 
    performer pr ON pf.performer_id = pr.performer_id
LEFT JOIN 
    artist a ON pr.artist_id = a.artist_id
LEFT JOIN 
    band b ON pr.band_id = b.band_id
WHERE 
    t.activated = TRUE
GROUP BY 
    p.person_id, performer_name
ORDER BY 
    total_score DESC
LIMIT 5;*/
