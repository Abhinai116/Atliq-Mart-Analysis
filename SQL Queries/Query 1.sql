SELECT distinct p.product_name,e.base_price
FROM dim_products p 
join fact_events e on e.product_code = p.product_code
where e.base_price>500 and promo_type="BOGOF"
order by e.base_price DESC