SELECT 
    a.name AS artist_name,
    COUNT(DISTINCT acp.continent) AS continent_count,
    GROUP_CONCAT(DISTINCT acp.continent ORDER BY acp.continent SEPARATOR ', ') AS continents_participated
FROM 
    artist_continent_participations acp
JOIN 
    artist a ON acp.artist_id = a.artist_id
GROUP BY 
    acp.artist_id, a.name
HAVING 
    COUNT(DISTINCT acp.continent) >= 3
ORDER BY 
    artist_name;
