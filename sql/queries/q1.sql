SELECT 
    f.year AS festival_year,
    pm.method_name AS payment_method,
    SUM(t.price) AS total_income
FROM 
    ticket t
JOIN 
    event e ON t.event_id = e.event_id
JOIN 
    festival f ON e.festival_id = f.festival_id
JOIN 
    purchase_method pm ON t.purchase_method_id = pm.purchase_method_id
WHERE
    f.year <= 2026  
GROUP BY 
    f.year, pm.method_name
ORDER BY 
    f.year, pm.method_name;
