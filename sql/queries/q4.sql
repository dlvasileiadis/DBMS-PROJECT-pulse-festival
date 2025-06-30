/* based on our structure of the review table an artist_review is about artists only
if the performance is solo.If the performance is a band we have a problem because 
the artist_rating is going to refer to the band. therefore in order to be accurate
we will intentionally a solo performance*/

/*we will choose the artist_id=1*/
SELECT 
    AVG(r.artist_rating) AS avg_artist_rating,
    AVG(r.overall_impression) AS avg_overall_impression
FROM 
    review r
JOIN 
    performances p ON r.performance_id = p.performance_id
JOIN 
    performer perf ON p.performer_id = perf.performer_id
WHERE 
    perf.artist_id = 1
    AND perf.band_id IS NULL;
    /*AND t.activated = TRUE;    optional*/








