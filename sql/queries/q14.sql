SELECT 
    g1.genre_name,
    g1.year AS year_1,
    g2.year AS year_2,
    g1.total_performances
FROM 
    genre_year_performances g1
JOIN 
    genre_year_performances g2 ON g1.genre_name = g2.genre_name 
        AND g2.year = g1.year + 1 -- consecutive year
WHERE 
    g1.total_performances = g2.total_performances
    AND g1.total_performances >= 3
    AND g2.total_performances >= 3
ORDER BY 
    g1.genre_name, g1.year;



