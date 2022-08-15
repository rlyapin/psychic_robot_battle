TRUNCATE click_probs;
INSERT INTO click_probs 
SELECT prefix, click, COUNT(*)
FROM (
	SELECT click, 
	COALESCE(STRING_AGG(click::varchar, '') OVER 
	(PARTITION BY session_id ORDER BY event_time ROWS BETWEEN 15 PRECEDING AND 1 PRECEDING), '') AS prefix
	FROM events
	WHERE event_time > NOW() - interval '1 month'
) t
GROUP BY (prefix, click);
