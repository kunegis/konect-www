%
% HTML code for the category icon.
%

function [icon_category] = www_icon_category(category)

  colors = konect_data_category(); 
  c = floor(colors.(category) * 255); 
  color_category= sprintf('%02X%02X%02X', c(1), c(2), c(3));
  icon_category = sprintf('<DIV class="category-circle" style="background-color:#%s;" title="%s network"></DIV>', ...
			  color_category, category); 
