
SELECT 
    AVG(r.artist_rating) AS avg_artist_rating,
    AVG(r.overall_impression) AS avg_overall_impression
FROM 
    review r FORCE INDEX (idx_review_performance_id)
JOIN 
    performances p FORCE INDEX (idx_performances_performance_id) ON r.performance_id = p.performance_id
JOIN 
    performer perf FORCE INDEX (idx_performer_artist_band) ON p.performer_id = perf.performer_id
WHERE 
    perf.artist_id = 1
    AND perf.band_id IS NULL;
