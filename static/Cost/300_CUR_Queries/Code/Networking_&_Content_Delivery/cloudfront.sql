SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
  product_region,
  product_product_family, -- NOTE: product_product_family used in place of large line_item_usage_type CASE
  line_item_operation,
  SPLIT_PART(line_item_resource_id, 'distribution/', 2) as split_line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) as sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND line_item_product_code = 'AmazonCloudFront'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
  product_region,
  product_product_family,
  line_item_operation,
  line_item_resource_id
ORDER BY
  sum_line_item_unblended_cost DESC;

      