select * from imdb_top_movies;

1) Fetch all data from imdb table 

select * from imdb_top_movies;

2) Fetch only the name and release year for all movies.

select series_title,released_year
from imdb_top_movies;

3) Fetch the name, release year and imdb rating of movies which are UA certified.

select series_title,released_year,imdb_rating
from imdb_top_movies
where certificate='UA'

4) Fetch the name and genre of movies which are UA certified and have a Imdb rating of over 8.
select series_title,genre
from imdb_top_movies
where certificate='UA' and imdb_rating > 8

5) Find out how many movies are of Drama genre.
select genre,count(*) as no_of_movies
from imdb_top_movies
where lower(genre) like '%drama%'
group by 1

6) How many movies are directed by 
"Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and "Rajkumar Hirani".

select director,count(*) total_no_of_movies
from imdb_top_movies
where director in ('Quentin Tarantino','Steven Spielberg','Christopher Nolan','Rajkumar Hirani')
group by 1

7) What is the highest imdb rating given so far?
select max(imdb_rating) as highest_rating
from imdb_top_movies

8) What is the highest and lowest imdb rating given so far?
select max(imdb_rating) as highest_rating,min(imdb_rating) as lowest_rating
from imdb_top_movies

8a) Solve the above problem but display the results in different rows.
select max(imdb_rating) as rating
from imdb_top_movies
union
select min(imdb_rating) as rating
from imdb_top_movies

8b) Solve the above problem but display the results in different rows. 
And have a column which indicates the value as lowest and highest.

select max(imdb_rating) as rating,'Highest rating' as rating
from imdb_top_movies
union
select min(imdb_rating) as rating, 'Lowest rating' as rating
from imdb_top_movies

9) Find out the total business done by movies staring "Aamir Khan".

select sum(gross) as total_business
from imdb_top_movies
where 'Aamir Khan' in (director,star1,star2,star3,star4)

10) Find out the average imdb rating of movies which are neither directed 
	by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" 
	and are not acted by any of these stars "Christian Bale", "Liam Neeson"
		, "Heath Ledger", "Leonardo DiCaprio", "Anne Hathaway".

select avg(imdb_rating) as avg_rating
from imdb_top_movies
where director not in ('Quentin Tarantino', 'Steven Spielberg', 'Christopher Nolan')
and (star1 not in ('Christian Bale', 'Liam Neeson'
		, 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
		and star2 not in ('Christian Bale', 'Liam Neeson'
		, 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
		and star3 not in ('Christian Bale', 'Liam Neeson'
		, 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
		and star4 not in ('Christian Bale', 'Liam Neeson'
		, 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway'))

11) Mention the movies involving both "Steven Spielberg" and "Tom Cruise".

select *
from imdb_top_movies
where director in ('Steven Spielberg')
and (star1 in ('Tom Cruise')
or star2 in ('Tom Cruise')
or star3 in ('Tom Cruise')
or star4 in ('Tom Cruise'))

12) Display the movie name and watch time (in both mins and hours) which have over 9 imdb rating.

select series_title,runtime,round((replace(runtime,'min',' ')::decimal)/60,2) as hourly_runtime
from imdb_top_movies
where imdb_rating > 9

13) What is the average imdb rating of movies 
which are released in the last 10 years and have less than 2 hrs of runtime.

select avg(imdb_rating) as avg_rating
from imdb_top_movies
where released_year <> 'PG'
and extract(year from current_date) - released_year::int <=10
and round((replace(runtime,'min',' ')::decimal)/60,2) < 2

14) Identify the Batman movie which is not directed by "Christopher Nolan".

select *
from imdb_top_movies
where lower(series_title) like '%batman%'
and director <> 'Christopher Nolan'

15) Display all the A and UA certified movies which are either directed by 
"Steven Spielberg", "Christopher Nolan" or which are directed by other directors but have a rating of over 8.

select *
from imdb_top_movies
where certificate in ('A','UA')
and director = 'Steven Spielbery' and director = 'Christopher Nolan'
or (director not in ('Steven Spielbery','Christopher Nolan')
and imdb_rating > 8)

16) What are the different certificates given to movies?

select distinct certificate
from imdb_top_movies
order by 1

17) Display all the movies acted by Tom Cruise in the order of their release. 
Consider only movies which have a meta score.

select *
from imdb_top_movies
where meta_score is not null
and (star1 = 'Tom Cruise'
     or star2 = 'Tom Cruise'
     or star3 = 'Tom Cruise'
     or star4 = 'Tom Cruise')
order by released_year

18) Segregate all the Drama and Comedy movies released in the last 10 years as per their runtime. 
	Movies shorter than 1 hour should be termed as short film. 
	Movies longer than 2 hrs should be termed as longer movies. 
	All others can be termed as Good watch time.

select series_title as movies,genre,
case when round((replace(runtime,'min',' ')::decimal)/60,2) < 1 then 'Short Film'
     when round((replace(runtime,'min',' ')::decimal)/60,2) > 2 then 'Longer Film'
	 else 'Good Watch Time' end as Movie_Review
	 from imdb_top_movies
	 where released_year <> 'PG'
	 and extract(year from current_date) - released_year::int <=10
	 and (lower(genre) like '%drama'
	 or lower(genre)like '%comedy')
	 order by movie_review

19) Write a query to display the "Christian Bale" movies which released in odd year and even year. 
Sort the data as per Odd year at the top.

select series_title,
case when released_year::int%2=0 then 'Even Year'
else 'Odd_Year' end as Odd_Even
from imdb_top_movies
where released_year <> 'PG'
order by odd_even desc

20) Re-write problem #18 without using case statement.

select series_title, 'Short Film' as Category,
round(replace(runtime,'min','')::decimal/60,2) as runtime
from imdb_top_movies
where released_year <> 'PG'
	 and extract(year from current_date) - released_year::int <=10
	 and (lower(genre) like '%drama'
	      or lower(genre)like '%comedy')
	 and round(replace(runtime,'min','')::decimal/60,2) < 1
union all
select series_title, 'Good Time Watch' as Category,
round(replace(runtime,'min','')::decimal/60,2) as runtime
from imdb_top_movies
where released_year <> 'PG'
	 and extract(year from current_date) - released_year::int <=10
	 and (lower(genre) like '%drama'
	      or lower(genre)like '%comedy')
	 and round(replace(runtime,'min','')::decimal/60,2) between 1 and 2
union all
select series_title, 'Longer Films' as Category,
round(replace(runtime,'min','')::decimal/60,2) as runtime
from imdb_top_movies
where released_year <> 'PG'
	 and extract(year from current_date) - released_year::int <=10
	 and (lower(genre) like '%drama'
	      or lower(genre)like '%comedy')
	 and round(replace(runtime,'min','')::decimal/60,2) > 2

1) Split the value '1234_1234' into 2 seperate columns having 1234 each.

select substring('1234_1234',1,position('_' in '1234_1234')-1) as part_1,
substring('1234_1234',position('_' in '1234_1234')+1) as part_2
