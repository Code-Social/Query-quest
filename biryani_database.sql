-- Project 3 - Biryani Database Assignment
-- File: biryani_database.sql
-- Name: Sree Sai Vaishnavi Mahendra
-- Date: July 2025

-- setting up the database first
create database if not exists biryani_db;
use biryani_db;

-- creating all the tables as per requirements

create table BiryaniVarieties (
  biryani_id    int primary key,
  name          varchar(100) not null,
  region        varchar(50),
  spice_level   tinyint check (spice_level between 1 and 10),
  vegetarian    boolean not null
);

create table Ingredients (
  ingredient_id  int primary key,
  name           varchar(50) not null,
  category       varchar(20),
  is_allergen    boolean default false
);

create table Recipes (
  recipe_id     int primary key,
  biryani_id    int,
  ingredient_id int,
  quantity      decimal(5,2),
  unit          varchar(20),
  foreign key (biryani_id) references BiryaniVarieties(biryani_id),
  foreign key (ingredient_id) references Ingredients(ingredient_id)
);

create table Restaurants (
  restaurant_id     int primary key,
  name               varchar(100) not null,
  city               varchar(50),
  established_date   date
);

create table Menu (
  menu_id        int primary key,
  restaurant_id  int,
  biryani_id     int,
  price          decimal(6,2),
  available      boolean default true,
  foreign key (restaurant_id) references Restaurants(restaurant_id),
  foreign key (biryani_id) references BiryaniVarieties(biryani_id)
);

create table Reviews (
  review_id      int primary key,
  restaurant_id  int,
  biryani_id     int,
  rating         tinyint check (rating between 1 and 5),
  comments       text,
  review_date    date,
  foreign key (restaurant_id) references Restaurants(restaurant_id),
  foreign key (biryani_id) references BiryaniVarieties(biryani_id)
);

create table Sales (
  sale_id        int primary key,
  restaurant_id  int,
  biryani_id     int,
  sale_date      date,
  quantity_sold  int,
  total_amount   decimal(8,2),
  foreign key (restaurant_id) references Restaurants(restaurant_id),
  foreign key (biryani_id) references BiryaniVarieties(biryani_id)
);

-- now inserting all the data

insert into BiryaniVarieties values
 (1, 'Hyderabadi Chicken', 'Hyderabad', 8, false),
 (2, 'Lucknowi (Awadhi)', 'Lucknow', 6, false),
 (3, 'Kolkata Biryani', 'Kolkata', 5, false),
 (4, 'Malabar Biryani', 'Kerala', 7, false),
 (5, 'Ambur Biryani', 'Tamil Nadu', 7, false),
 (6, 'Veg Dum Biryani', 'Delhi', 4, true),
 (7, 'Tehari (Veg)', 'Lucknow', 3, true),
 (8, 'Sindhi Biryani', 'Sindh', 9, false);

insert into Ingredients values
 (10, 'Basmati Rice', 'Grain', false),
 (11, 'Chicken', 'Protein', false),
 (12, 'Potato', 'Vegetable', false),
 (13, 'Yogurt', 'Dairy', true),
 (14, 'Onion', 'Vegetable', false),
 (15, 'Tomato', 'Vegetable', false),
 (16, 'Saffron', 'Spice', false),
 (17, 'Ginger-Garlic Paste', 'Spice', false),
 (18, 'Garam Masala', 'Spice', false),
 (19, 'Green Chili', 'Spice', false),
 (20, 'Cashews', 'Nut', true),
 (21, 'Mint Leaves', 'Herb', false),
 (22, 'Bay Leaf', 'Spice', false);

insert into Recipes values
 (100, 1, 10, 500.00, 'g'),
 (101, 1, 11, 400.00, 'g'),
 (102, 1, 13, 100.00, 'ml'),
 (103, 1, 16, 1.00, 'g'),
 (104, 1, 18, 2.00, 'tbsp'),
 (105, 2, 10, 450.00, 'g'),
 (106, 2, 11, 350.00, 'g'),
 (107, 2, 14, 150.00, 'g'),
 (108, 2, 18, 1.50, 'tbsp'),
 (109, 3, 10, 500.00, 'g'),
 (110, 3, 12, 200.00, 'g'),
 (111, 3, 14, 100.00, 'g'),
 (112, 3, 17, 50.00, 'g'),
 (113, 4, 10, 550.00, 'g'),
 (114, 4, 11, 300.00, 'g'),
 (115, 4, 15, 100.00, 'g'),
 (116, 4, 21, 20.00, 'g'),
 (117, 5, 10, 480.00, 'g'),
 (118, 5, 11, 380.00, 'g'),
 (119, 5, 20, 30.00, 'g'),
 (120, 5, 18, 2.00, 'tbsp'),
 (121, 6, 10, 500.00, 'g'),
 (122, 6, 13, 200.00, 'ml'),
 (123, 6, 14, 100.00, 'g'),
 (124, 6, 19, 2.00, 'pcs'),
 (125, 7, 10, 450.00, 'g'),
 (126, 7, 12, 150.00, 'g'),
 (127, 7, 21, 15.00, 'g'),
 (128, 8, 10, 500.00, 'g'),
 (129, 8, 11, 400.00, 'g'),
 (130, 8, 17, 60.00, 'g');

insert into Restaurants values
 (201, 'Spice Route', 'Chicago', '2018-05-10'),
 (202, 'Royal Biryani', 'Houston', '2020-11-20'),
 (203, 'Biryani Junction', 'New York', '2017-03-15'),
 (204, 'Dum House', 'Atlanta', '2019-08-08'),
 (205, 'Urban Biryani Bar', 'San Jose', '2021-01-25');

insert into Menu values
 (301, 201, 1, 12.50, true),
 (302, 201, 6, 10.00, true),
 (303, 202, 2, 11.00, true),
 (304, 202, 7, 9.50, false),
 (305, 203, 3, 13.25, true),
 (306, 203, 8, 14.00, true),
 (307, 204, 4, 12.75, true),
 (308, 204, 5, 11.50, true),
 (309, 205, 1, 13.00, true),
 (310, 205, 2, 12.00, true),
 (311, 205, 6, 10.50, true),
 (312, 205, 7, 9.75, true);

insert into Reviews values
 (401, 201, 1, 5, 'Authentic flavor, loved the spice!', '2025-05-10'),
 (402, 201, 6, 4, 'Good veg option but could use more flavor.', '2025-06-01'),
 (403, 202, 2, 3, 'A bit dry for Lucknowi style.', '2025-06-03'),
 (404, 202, 7, 4, 'Comforting and mild.', '2025-06-05'),
 (405, 203, 3, 5, 'Perfect balance of meat and rice.', '2025-05-15'),
 (406, 203, 8, 4, 'Rich and spicy but slightly oily.', '2025-05-20'),
 (407, 204, 4, 5, 'Malabar aroma was spot on!', '2025-06-10'),
 (408, 204, 5, 4, 'Tender chicken, nice cashews.', '2025-06-12'),
 (409, 205, 1, 4, 'Well seasoned, good portion.', '2025-06-15'),
 (410, 205, 2, 3, 'Too tangy for my taste.', '2025-06-18'),
 (411, 205, 6, 4, 'Veg biryani was flavorful.', '2025-06-20'),
 (412, 201, 1, 5, 'Best chicken biryani in town!', '2025-06-22'),
 (413, 203, 3, 2, 'Rice was undercooked.', '2025-06-25'),
 (414, 204, 4, 4, 'Loved the coconut notes.', '2025-06-28'),
 (415, 202, 2, 5, 'Exactly like homemade Lucknowi.', '2025-07-01');

insert into Sales values
 (501, 201, 1, '2025-05-10', 25, 312.50),
 (502, 201, 6, '2025-06-01', 10, 100.00),
 (503, 202, 2, '2025-06-03', 15, 165.00),
 (504, 202, 7, '2025-06-05', 8, 76.00),
 (505, 203, 3, '2025-05-15', 20, 265.00),
 (506, 203, 8, '2025-05-20', 12, 168.00),
 (507, 204, 4, '2025-06-10', 18, 229.50),
 (508, 204, 5, '2025-06-12', 22, 253.00),
 (509, 205, 1, '2025-06-15', 30, 390.00),
 (510, 205, 2, '2025-06-18', 16, 192.00),
 (511, 205, 6, '2025-06-20', 14, 147.00),
 (512, 201, 1, '2025-06-22', 28, 350.00),
 (513, 203, 3, '2025-06-25', 10, 132.50),
 (514, 204, 4, '2025-06-28', 9, 114.75),
 (515, 202, 2, '2025-07-01', 17, 187.00);

-- Query Solutions

-- 1. Easy Questions

-- 1a. Getting all biryani varieties with their details
select biryani_id, name, region, vegetarian
from BiryaniVarieties;

-- 1b. Finding spicy non-veg biryanis
select name, spice_level
from BiryaniVarieties
where vegetarian = false and spice_level >= 7;

-- 1c. Showing available menu items
select r.name as restaurant_name, b.name as biryani_name
from Restaurants r
join Menu m on r.restaurant_id = m.restaurant_id
join BiryaniVarieties b on m.biryani_id = b.biryani_id
where m.available = true;

-- 2. Medium Questions

-- 2a. Counting ingredients for each biryani
select b.biryani_id, b.name, count(r.ingredient_id) as ingredient_count
from BiryaniVarieties b
left join Recipes r on b.biryani_id = r.biryani_id
group by b.biryani_id, b.name;

-- 2b. Total sales for each biryani
select b.biryani_id, b.name, 
       sum(s.quantity_sold) as total_quantity_sold,
       sum(s.total_amount) as total_sales_amount
from BiryaniVarieties b
left join Sales s on b.biryani_id = s.biryani_id
group by b.biryani_id, b.name
order by total_quantity_sold desc;

-- 2c. Restaurants with good average ratings
select r.restaurant_id, r.name, avg(rv.rating) as average_rating
from Restaurants r
join Reviews rv on r.restaurant_id = rv.restaurant_id
group by r.restaurant_id, r.name
having avg(rv.rating) >= 4;

-- 2d. Biryanis that have allergen ingredients
select distinct b.name
from BiryaniVarieties b
join Recipes r on b.biryani_id = r.biryani_id
join Ingredients i on r.ingredient_id = i.ingredient_id
where i.is_allergen = true;

-- 3. Hard Questions

-- 3a. Monthly best selling biryani (this was tricky!)
-- first i need to get monthly sales, then rank them
with monthly_sales as (
    select 
        date_format(sale_date, '%Y-%m') as sales_month,
        s.biryani_id,
        b.name,
        sum(s.quantity_sold) as month_quantity,
        rank() over (partition by date_format(sale_date, '%Y-%m') 
                     order by sum(s.quantity_sold) desc) as sales_rank
    from Sales s
    join BiryaniVarieties b on s.biryani_id = b.biryani_id
    where year(sale_date) = 2025
    group by date_format(sale_date, '%Y-%m'), s.biryani_id, b.name
)
select sales_month, biryani_id, name, month_quantity
from monthly_sales
where sales_rank = 1
order by sales_month;

-- 3b. Menu price vs actual sale price differences
-- need to calculate average sale price and compare with menu price
select 
    m.restaurant_id,
    m.biryani_id,
    m.price as menu_price,
    avg(s.total_amount / s.quantity_sold) as actual_avg_price,
    round(((avg(s.total_amount / s.quantity_sold) - m.price) / m.price) * 100, 2) as price_difference_percent
from Menu m
join Sales s on m.restaurant_id = s.restaurant_id and m.biryani_id = s.biryani_id
group by m.restaurant_id, m.biryani_id, m.price
having abs(((avg(s.total_amount / s.quantity_sold) - m.price) / m.price) * 100) > 10;

-- 3c. Summer vs winter ratings comparison
-- summer months: 6,7,8 and winter months: 12,1,2
select 
    b.biryani_id,
    b.name,
    avg(case when month(r.review_date) in (6, 7, 8) then r.rating end) as summer_rating,
    avg(case when month(r.review_date) in (12, 1, 2) then r.rating end) as winter_rating,
    avg(case when month(r.review_date) in (6, 7, 8) then r.rating end) - 
    avg(case when month(r.review_date) in (12, 1, 2) then r.rating end) as rating_difference
from BiryaniVarieties b
left join Reviews r on b.biryani_id = r.biryani_id
where year(r.review_date) = 2025
group by b.biryani_id, b.name
having summer_rating is not null or winter_rating is not null;