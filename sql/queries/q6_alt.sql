
SELECT 
    e.event_id,
    e.name AS event_name,
    e.date AS event_date,
    COUNT(r.review_id) AS total_reviews_made,
    COALESCE(ROUND(AVG(
        (r.artist_rating + r.sound_light_rating + r.stage_presence + r.organization_rating + r.overall_impression) / 5.0
    ), 1), 0) AS avg_review_score
FROM 
    ticket t FORCE INDEX (idx_ticket_activated, idx_ticket_event_id)
JOIN 
    event e FORCE INDEX (PRIMARY) ON t.event_id = e.event_id
LEFT JOIN 
    performances pf FORCE INDEX (idx_performances_event_id) ON e.event_id = pf.event_id
LEFT JOIN 
    review r FORCE INDEX (idx_review_performance_person) ON pf.performance_id = r.performance_id 
    AND r.person_id = t.person_id
WHERE 
    t.person_id = 37
    AND t.activated = TRUE
GROUP BY 
    e.event_id, e.name, e.date
ORDER BY 
    e.date DESC;
