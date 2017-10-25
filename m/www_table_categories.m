%
% Generate the HTML table of all categories.
%
% OUPUT FILES
%	skeleton/categories/table.html
%
% INPUT FILES
%	dat/CATEGORIES
%

[cat_colors cat_vertices cat_edges cat_markers cat_letters cat_longname] = konect_data_category(); 

filename_out = 'skeleton/categories/table.html';
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(sprintf('fopen(%s)', filename_out));  end;

filename_categories = 'dat/CATEGORIES';
CATEGORIES = fopen(filename_categories, 'r');
if CATEGORIES < 0,  error(sprintf('fopen(%s)', filename_categories));  end; 

fprintf(OUT, '<TABLE>\n'); 

while ~((category = fgetl(CATEGORIES)) == -1)
  category
  longname = cat_longname.(category)
  longname = regexprep(longname, ' network$', ''); 
  fprintf(OUT, '<TR><TD><A href="%s/">%s</A> <A href="%s/">%s</A>\n', ...
	  category, www_icon_category(category), category, longname); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(CATEGORIES) < 0,  error(sprintf('fclose(%s)', filename_categories));  end;
if fclose(OUT) < 0,  error(sprintf('fclose(%s)', filename_out));  end;
