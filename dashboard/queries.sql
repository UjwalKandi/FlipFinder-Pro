-- Top 20 Flip Opportunities
SELECT 
    vehicle_full as Vehicle,
    flip_score as Score,
    flip_profit as Profit,
    risk_level as Risk,
    mileage_category as Mileage
FROM flipfinder_dashboard_data
ORDER BY flip_score DESC
LIMIT 20


-- Hot Deals Count
SELECT 
    COUNT(CASE WHEN flip_score > 80 THEN 1 END) as hot_deals,
    '🔥 Hot Deals' as metric
FROM flipfinder_dashboard_data
  

-- Fastest Profitable Flip
SELECT 
    MIN(daysonmarket) as fastest_flip,
    '⚡ Fastest Flip' as metric,
    'days' as unit
FROM flipfinder_dashboard_data
WHERE flip_profit > 5000

-- Risk Distribution 
SELECT 
    risk_level,
    COUNT(*) as count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) as percentage
FROM flipfinder_dashboard_data
GROUP BY risk_level


-- Profit Distribution 
SELECT 
    CASE 
        WHEN flip_profit < 0 THEN 'Loss'
        WHEN flip_profit < 5000 THEN '$0-5k'
        WHEN flip_profit < 10000 THEN '$5k-10k'
        WHEN flip_profit < 20000 THEN '$10k-20k'
        ELSE '$20k+'
    END as profit_range,
    COUNT(*) as count
FROM flipfinder_dashboard_data
GROUP BY profit_range
ORDER BY 
    CASE profit_range
        WHEN 'Loss' THEN 1
        WHEN '$0-5k' THEN 2
        WHEN '$5k-10k' THEN 3
        WHEN '$10k-20k' THEN 4
        ELSE 5
    END

  
-- Days on Market Analysis
SELECT 
    risk_level,
    AVG(daysonmarket) as Avg_Days,
    MIN(daysonmarket) as Min_Days,
    MAX(daysonmarket) as Max_Days
FROM flipfinder_dashboard_data
GROUP BY risk_level
ORDER BY Avg_Days


-- Score vs Profit
SELECT 
    flip_profit as Profit,
    flip_score as Score,
    risk_level as Risk,
    CONCAT(make_name, ' ', model_name) as Vehicle
FROM flipfinder_dashboard_data
WHERE flip_profit BETWEEN -20000 AND 50000
  AND flip_score IS NOT NULL
LIMIT 1000


-- Top Manufacturers
SELECT 
    make_name as Manufacturer,
    ROUND(AVG(flip_score), 1) as Avg_Score,
    COUNT(*) as Vehicles,
    ROUND(AVG(flip_profit), 0) as Avg_Profit
FROM flipfinder_dashboard_data
GROUP BY make_name
HAVING COUNT(*) >= 10
ORDER BY Avg_Score DESC
LIMIT 10


-- Top 20 Opportunities
SELECT 
    CONCAT(make_name, ' ', model_name, ' (', year, ')') as Vehicle,
    flip_score as Score,
    flip_profit as Profit,
    risk_level as Risk
FROM flipfinder_dashboard_data
ORDER BY flip_score DESC
LIMIT 20


-- Average ROI (Top 20)
SELECT 
    ROUND(AVG((flip_profit / price) * 100), 1) as avg_roi,
    '📈 Avg ROI' as metric,
    '%' as unit
FROM (
    SELECT * FROM flipfinder_dashboard_data
    ORDER BY flip_score DESC
    LIMIT 20
)
