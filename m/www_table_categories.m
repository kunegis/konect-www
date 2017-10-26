%
% Generate the HTML table of all categories.
%
% OUPUT FILES
%	skeleton/categories/table.html
%
% INPUT FILES
%	dat-www/CATEGORIES.sorted
%	dat-www/COUNT_CATEGORY_*
%

[cat_colors cat_vertices cat_edges cat_markers cat_letters cat_longname] = konect_data_category(); 

filename_out = 'skeleton/categories/table.html';
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(sprintf('fopen(%s)', filename_out));  end;

filename_categories = 'dat-www/CATEGORIES.sorted';
CATEGORIES = fopen(filename_categories, 'r');
if CATEGORIES < 0,  error(sprintf('fopen(%s)', filename_categories));  end; 

fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><TD><B>Category</B><TD align="right"><B>Count</B>\n'); 

while ~((category = fgetl(CATEGORIES)) == -1)
  category
  longname = cat_longname.(category)
  longname = regexprep(longname, ' network$', ''); 
  count_category = load(sprintf('dat-www/COUNT_CATEGORY_%s', category)); 
  fprintf(OUT, '<TR><TD><A href="%s/">%s</A><TD><A href="%s/">%s</A><TD align="right">%u\n', ...
	  category, www_icon_category(category), category, longname, count_category); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(CATEGORIES) < 0,  error(sprintf('fclose(%s)', filename_categories));  end;
if fclose(OUT) < 0,  error(sprintf('fclose(%s)', filename_out));  end;
