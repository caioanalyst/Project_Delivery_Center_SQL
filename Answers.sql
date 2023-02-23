# 1- What is the number of hubs per city?


select hub_city, count(distinct hub_id) as 'Amount'
from exec4.hubs
group by hub_city
order by contagem desc;

# or

select hub_city, count(distinct hub_id) as 'Amount'
from exec4.hubs
group by hub_city
order by amount desc;



# 2- What is the number of requests (orders) per status?

select count(order_id) as 'amount_orders', order_status
from exec4.orders
group by order_status
order by amount_orders desc;



# 3- What is the number of stores per hub city?

select count(distinct S.store_id) 'Amount', H.hub_city
from exec4.stores S inner join exec4.hubs H
            on S.hub_id = H.hub_id
group by H.hub_city
order by amount desc;


# 4- What is the highest and lowest payment amount (payment_amount) registered?

select max(payment_amount) as 'Maximum', min(payment_amount) as 'Minimum'
from exec4.payments;



# 5- What type of driver (driver_type) made the most deliveries?

select driver_type, count(delivery_id) as 'Amount_delivery'
from exec4.drivers DR inner join exec4.deliveries DE
						on DR.driver_id = DE.driver_id
group by driver_type
order by Amount_delivery desc;



# 6- What is the average distance of deliveries by type of driver (driver_modal)?

select driver_modal, avg(delivery_distance_meters) as 'distance_average'
from exec4.drivers DR inner join exec4.deliveries DE
					on DR.driver_id = DE.driver_id
group by driver_modal
order by distance_average desc;



# 7- What is the average order value (order_amount) per store, in descending order?


select  store_name, round(avg(order_amount), 4) as media
from exec4.orders O inner join exec4.stores S
               on O.store_id = S.store_id
group by store_name
order by media desc;



# 8- Are there orders that are not associated with stores? If so, how many?


select coalesce(store_name, 'sem loja'), count(order_id) as amount
from exec4.orders O left join exec4.stores S
               on S.store_id = O.store_id
group by store_name
order by amount desc;


# 9- What is the total order value (order_amount) in channel 'FOOD PLACE'?


select round(sum(order_amount), 4) as 'amount_money', channel_name
from exec4.orders O inner join exec4.channels C
					on O.channel_id = C.channel_id
where channel_name = 'FOOD PLACE';



# 10- How many payments were canceled (chargeback)?


select count(payment_status) as 'status', payment_status
from exec4.payments
group by payment_status;

# Or

select count(payment_status) as 'status', payment_status
from exec4.payments
group by payment_status
HAVING payment_status = 'CHARGEBACK';



# 11- What was the average amount of canceled payments (chargeback)?


select round(avg(payment_amount), 4) as 'amount_money', payment_status
from exec4.payments
group by payment_status;

# Or

select round(avg(payment_amount), 4) as 'amount_money', payment_status
from exec4.payments
group by payment_status
having payment_status = 'CHARGEBACK';



# 12- What is the average payment amount per payment method (payment_method) in descending order?

select payment_method, round(avg(payment_amount), 4) as 'amount_money'
from exec4.payments
group by payment_method
order by amount_money desc;


# 13- Which payment methods had an average value greater than 100?


select  payment_method, round(avg(payment_amount), 4) as 'amount_money'
from exec4.payments
group by payment_method
having amount_money > 100
order by amount_money desc;



# 14- What is the average order value (order_amount) per hub state (hub_state), store segment (store_segment) and channel type (channel_type)?


select hub_state, store_segment, C.channel_type, round(avg(O.order_amount), 4) as 'amount_money'
from exec4.orders O inner join exec4.channels C inner join exec4.stores S inner join exec4.hubs H
               on O.channel_id = C.channel_id
                    and O.store_id = S.store_id
                    and H.hub_id = S.hub_id
group by H.hub_state, S.store_segment, C.channel_type
order by hub_state;



# 15- Which hub state (hub_state), store segment (store_segment) and channel type (channel_type) had an average order value (order_amount) greater than 450?


select H.hub_state, S.store_segment, C.channel_type, round(avg(O.order_amount), 4) as 'amount_money'
from exec4.orders O inner join exec4.channels C inner join exec4.stores S inner join exec4.hubs H
               on O.channel_id = C.channel_id
                    and O.store_id = S.store_id
                    and H.hub_id = S.hub_id
group by H.hub_state, S.store_segment, C.channel_type
having amount_money > 450;


# 16- What is the total order amount (order_amount) per hub state (hub_state), store segment (store_segment) and channel type (channel_type)? Show intermediate totals and format the result.


select
   if(grouping(H.hub_state), 'Amount Hub State', hub_state) as hub_state,
   if(grouping(S.store_segment), 'Amount Store Segment', store_segment) as store_segment,
   if(grouping(C.channel_type), 'Amount Channel Type', channel_type) as channel_type,
round(sum(O.order_amount),2) as 'amount_money'
from exec4.orders O inner join exec4.channels C inner join exec4.stores S inner join exec4.hubs H
               on O.channel_id = C.channel_id
                    and O.store_id = S.store_id
                    and H.hub_id = S.hub_id
group by H.hub_state, S.store_segment, C.channel_type with rollup;