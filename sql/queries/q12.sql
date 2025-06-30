/*assuming 2 technicians per venue*/

SELECT 
    e.date AS festival_date,
    sr.role_name AS staff_category,
    COUNT(vsa.staff_id) AS required_staff_count
FROM 
    event e
JOIN 
    venue v ON e.venue_id = v.venue_id
JOIN 
    venue_staff_assignment vsa ON v.venue_id = vsa.venue_id
JOIN 
    staff s ON vsa.staff_id = s.staff_id
JOIN 
    staff_role sr ON s.role_id = sr.role_id
WHERE 
    sr.role_name IN ('Technician','Assistant','Security') -- Filter key categories
GROUP BY 
    e.date,
    sr.role_name
ORDER BY 
    e.date ASC,
    sr.role_name;