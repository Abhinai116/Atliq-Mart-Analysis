with x as (
select *,(base_price*`quantity_sold(before_promo)`) as rev_bef,
	case
		when promo_type = "25% OFF" then (base_price*0.75)*`quantity_sold(after_promo)`
        when promo_type = "33% OFF" then (base_price*0.67)*`quantity_sold(after_promo)`
        when promo_type = "50% OFF" then (base_price*0.50)*`quantity_sold(after_promo)`
        when promo_type = "500 Cashback" then (base_price-500)*`quantity_sold(after_promo)`
        when promo_type = "BOGOF" then (base_price/2)*`quantity_sold(after_promo)`*2
        end as rev_aft
from fact_events e
),
y as (
select category,product_name,sum(rev_aft)-sum(rev_bef) as ir ,
round(((sum(rev_aft)-sum(rev_bef))/sum(rev_bef)*100),2) as ir_pct
from x
join dim_products using (product_code)
group by product_code)
select product_name,category,ir_pct
from y
order by ir_pct desc
limit 5
