with x as(
select c.campaign_name,c.campaign_id,e.base_price,`quantity_sold(before_promo)` as quantiy_sold_before_promo,
`quantity_sold(after_promo)` as quantity_sold_after_promo,
case 
WHEN promo_type = "25% off" THEN base_price * (1 - 0.25)
WHEN promo_type = "33% off" THEN base_price * (1 - 0.33)
WHEN promo_type = "50% off" THEN base_price * (1 - 0.50)
WHEN promo_type = "bogof" THEN base_price/2
WHEN promo_type = "500 cashback" THEN (base_price - 500)
else base_price
end as new_price_after_promotion
from fact_events e
join dim_campaigns c on c.campaign_id=e.campaign_id),
 y as ( 
select campaign_name,
round(sum(base_price * `quantiy_sold_before_promo`)/1000000,2) as total_revenue_before_promo,
round(sum((new_price_after_promotion * `quantity_sold_after_promo`))/1000000,2) as total_revenue_after_promo
from x
group by campaign_name)
select * 
from y