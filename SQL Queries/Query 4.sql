with x as (
select category,`quantity_sold(before_promo)` as bef,
	case 
		when promo_type = "BOGOF" then `quantity_sold(after_promo)`*2
        else `quantity_sold(after_promo)`
        end as aft
from fact_events e
join dim_products p on p.product_code = e.product_code
where campaign_id = "CAMP_DIW_01"),
y as (
	select category, sum(aft)-sum(bef) as isu,(sum(aft)-sum(bef))/sum(bef)*100 as isu_pct
	from x 
    group by category)
select category,isu_pct,
dense_rank () over (order by isu_pct desc) as rnk
from y    