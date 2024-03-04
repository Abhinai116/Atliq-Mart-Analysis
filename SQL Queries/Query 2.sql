SELECT city,COUNT(store_id) as count
FROM dim_stores
group by city
order by count DESC