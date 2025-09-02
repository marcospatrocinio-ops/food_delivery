begin

   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_qty_greater_zero CHECK (NVL(tax_avg_qty,0) >= 0)
   
   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_unit_base_greater_zero CHECK (tax_avg_unit_base >= 0)
   
   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_value_greater_zero CHECK (tax_avg_value >= 0)
   
   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_unit_value_greater_zero CHECK (tax_avg_unit_value >= 0)
   
   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_rate_greater_zero CHECK (tax_avg_rate >= 0)
   
   ALTER TABLE tax_history_avg_cost ADD CONSTRAINT check_tax_avg_base_base_greater_zero CHECK (tax_avg_base >= 0)
   
end;
/