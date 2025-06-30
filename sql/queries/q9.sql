SELECT 
    p1.person_id,
    per.first_name,
    per.last_name,
    p1.year_attended,
    p1.performance_count
FROM 
    performances_per_year p1
JOIN 
    performances_per_year p2
  ON p1.performance_count = p2.performance_count
 AND p1.person_id <> p2.person_id
JOIN 
    person per ON p1.person_id = per.person_id
ORDER BY 
    p1.performance_count DESC, p1.person_id;
