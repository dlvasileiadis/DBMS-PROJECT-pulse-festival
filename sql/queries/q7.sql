SELECT 
    f.festival_id,
    f.year,
    AVG(el.level_id) AS avg_experience_level
FROM 
    festival f
JOIN 
    venue v ON v.festival_id = f.festival_id
JOIN 
    venue_staff_assignment vsa ON vsa.venue_id = v.venue_id
JOIN 
    staff s ON s.staff_id = vsa.staff_id
JOIN 
    staff_role sr ON sr.role_id = s.role_id
JOIN 
    experience_level el ON el.level_id = s.level_id
WHERE 
    sr.role_name = 'technician'
    AND f.year <= 2024
GROUP BY 
    f.festival_id, f.year
ORDER BY 
    avg_experience_level ASC
LIMIT 1;
