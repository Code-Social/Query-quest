#1.a Movie & Director
SELECT M.title, M.release_date, D.name AS director_name
FROM Movies M
JOIN Directors D ON M.director_id = D.director_id;

#1.b Original Content
SELECT title
FROM Movies
WHERE is_original = TRUE;

#1.c Series Overview
SELECT title, start_date, seasons
FROM WebSeries;

#2.a Actor Film Counts
SELECT A.actor_id, A.name, COUNT(MC.movie_id) AS movie_count
FROM Actors A
LEFT JOIN MovieCast MC ON A.actor_id = MC.actor_id
GROUP BY A.actor_id, A.name
ORDER BY movie_count DESC;

#2.b Genre Popularity
SELECT G.genre_id, G.name, COUNT(MG.movie_id) AS movie_count
FROM Genres G
LEFT JOIN MovieGenres MG ON G.genre_id = MG.genre_id
GROUP BY G.genre_id, G.name;

#2.c Series Reviews
SELECT WS.series_id, WS.title, AVG(R.rating) AS average_rating
FROM Reviews R
JOIN WebSeries WS ON R.content_id = WS.series_id
WHERE R.content_type = 'SERIES'
GROUP BY WS.series_id, WS.title
HAVING COUNT(R.review_id) >= 2;

#2.d Episode Listing
SELECT season_number, episode_number, title, air_date
FROM Episodes
WHERE series_id = 101
ORDER BY season_number, episode_number;

#3.a Top-Rated Movies
WITH MovieRatings AS (
  SELECT M.movie_id, M.title, AVG(R.rating) AS average_rating
  FROM Movies M
  JOIN Reviews R ON M.movie_id = R.content_id
  WHERE R.content_type = 'MOVIE'
  GROUP BY M.movie_id, M.title
)
SELECT movie_id, title, average_rating,
       RANK() OVER (ORDER BY average_rating DESC) AS rank
FROM MovieRatings;

#3.b Cross-Type Top Content
WITH MovieAvg AS (
  SELECT 'MOVIE' AS content_type, M.title, AVG(R.rating) AS avg_rating
  FROM Movies M
  JOIN Reviews R ON M.movie_id = R.content_id
  WHERE R.content_type = 'MOVIE'
  GROUP BY M.title
),
SeriesAvg AS (
  SELECT 'SERIES' AS content_type, S.title, AVG(R.rating) AS avg_rating
  FROM WebSeries S
  JOIN Reviews R ON S.series_id = R.content_id
  WHERE R.content_type = 'SERIES'
  GROUP BY S.title
)
SELECT * FROM (
  SELECT * FROM MovieAvg
  UNION
  SELECT * FROM SeriesAvg
) AS Combined
WHERE avg_rating >= 9.0;

#3.c Director Impact
SELECT D.name AS director_name, AVG(R.rating) AS average_movie_rating
FROM Directors D
JOIN Movies M ON D.director_id = M.director_id
JOIN Reviews R ON M.movie_id = R.content_id
WHERE R.content_type = 'MOVIE'
GROUP BY D.name
HAVING AVG(R.rating) >= 8.5;

