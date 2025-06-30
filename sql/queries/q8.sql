SELECT 
    s.staff_id,
    s.name,
    s.age
FROM 
    staff s
WHERE 
    s.role_id = 2 -- support staff
    AND s.staff_id NOT IN (
        SELECT DISTINCT vsa.staff_id
        FROM 
            venue_staff_assignment vsa
        JOIN 
            venue v ON vsa.venue_id = v.venue_id
        JOIN 
            festival f ON v.festival_id = f.festival_id
        WHERE 
            '2021-08-12' BETWEEN f.start_date AND f.end_date
    )
ORDER BY 
    s.staff_id;
