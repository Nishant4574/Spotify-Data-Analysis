-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
select * from spotify;
select  max(duration_min) from spotify;

\\ to delete the data\\

delete from spotify 
where duration_min=0
select * from spotify where duration_min=0


select distinct channel from spotify;

select distinct most_played_on from spotify;

----------------------------------
-- Data Analsysis Category---
----------------------------------
/*
1)Retrieve the names of all tracks that have more than 1 billion streams.
2)List all albums along with their respective artists.
3)et the total number of comments for tracks where licensed = TRUE.
4)Find all tracks that belong to the album type single.
5)Count the total number of tracks by each artist
*/
----------------------------------------
1)
select * from spotify
where stream>1000000000

2)
select  distinct album,artist from spotify

3)
select sum(comments)as total from spotify where licensed='true'


4)

select * from spotify where album_type ilike 'single'

5)
select artist,count(track) from spotify
group by artist
order by 2

--------------------------------------------------------
/*
1)Calculate the average danceability of tracks in each album.
2)Find the top 5 tracks with the highest energy values.
3)List all tracks along with their views and likes where official_video = TRUE.
4)For each album, calculate the total views of all associated tracks.
5)Retrieve the track names that have been streamed on Spotify more than YouTube.
*/
------------------------------------------------

1)
select album,avg(danceability) from spotify
group by 1

2)
select 
 track, max(energy)
from spotify
group by 1
order by 2 desc
limit 5

3)
select 
 track, sum(views),sum(likes)
from spotify
where official_video=true
group by 1
order by 2 desc

4)
select 
album,track, sum(views)
from spotify
where official_video=true
group by 1,2
order by 2 desc

5)
--- sub query
select * from
(select track,
coalesce(sum(case when most_played_on ='Youtube'then stream end),0)as youtube,
coalesce(sum(case when most_played_on ='Spotify'then stream end),0) as spotify 
from spotify
group by 1) as t1
where youtube<spotify and youtube!=0

------------------------------------------------------------------------------
/*
Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.*/

------------------------------------------------------------------------------

1)
with ranking_artist as(select artist,track,sum(views) as total_views,
--Window Function
dense_rank() over(Partition by artist order by sum(views)desc)as rank
from spotify
group by 1,2 
order by 1,3 desc)

select * from ranking_artist
where rank <=3


2)
-- sub query
select * from spotify
where liveness> (select avg(liveness)from spotify)


3)
-- with clause
with cte as(
select 
album,max(energy) as highest,
min(energy) as lowest
from spotify
group by 1
)
select album,highest-lowest as avg_energy
from cte
order by 2 desc
