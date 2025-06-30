SELECT 
    a.name AS artist_name,
    f.year AS festival_year,
    COUNT(*) AS warmup_performances
FROM 
    performances p
JOIN 
    performance_type pt ON p.type_id = pt.type_id
JOIN 
    performer perf ON p.performer_id = perf.performer_id
JOIN 
    artist a ON perf.artist_id = a.artist_id
JOIN 
    event e ON p.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id
WHERE 
    pt.type_name = 'Warm-Up'
GROUP BY 
    a.artist_id, a.name, f.festival_id, f.year
HAVING 
    COUNT(*) > 2
ORDER BY 
    artist_name, festival_year;


 