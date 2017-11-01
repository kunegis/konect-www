%
% Generate one "category" page.
%
% PARAMETERS
%	$category	Internal name of the category
%
% OUTPUT FILES
%	skeleton/categories/$category/base.html
%
% INPUT FILES
%	dat/NETWORKS_CATEGORY_$category
%	dat-www/COUNT_CATEGORY_$category
%

category = getenv('category')

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 
[colors vertices edges markers letters longname] = konect_data_category(); 

filename_out = sprintf('skeleton/categories/%s/base.html', category); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_networks = sprintf('dat/NETWORKS_CATEGORY_%s', category); 
NETWORKS = fopen(filename_networks, 'r');
if NETWORKS < 0,  error(filename_networks);  end; 

label_category = longname.(category);
label_category = sprintf('%ss', label_category);
label_category_lc = label_category;
label_category_lc(1) = label_category_lc(1) + ('a' - 'A'); 

count = load(sprintf('dat-www/COUNT_CATEGORY_%s', category)); 

fprintf(OUT, '#nav:<A href="../../">KONECT</A> ‣ <A href="../">Categories</A> ‣\n'); 
fprintf(OUT, '<H1>%s</H1>\n', label_category); 
fprintf(OUT, '<P>This is the category <B>%s</B>.  It contains <B>%u</B> networks. ${description}</P>\n', label_category_lc, count); 
fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><B>Name</B><TD class="padleft"><B>Attributes</B>\n'); 

count = 0;
while ~((network = fgetl(NETWORKS)) == -1)
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  meta= read_meta(network); 
  name= meta.name;
  icon_category = www_icon_category(meta.category); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  title_format = labels_format{format};
  title_weights = labels_weights{weights};
  fprintf(OUT, '<TR><TD><A href="../../networks/%s/">%s</A><TD class="padleft"><A href="${root}/categories/%s/">%s</A> <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s">\n', ...
	  network, name, meta.category, icon_category, text_format, title_format, text_weights, title_weights);
  count = count + 1; 
end

assert(count >= 1); 

fprintf(OUT, '</TABLE>\n'); 

if fclose(NETWORKS) < 0,  error(filename_networks);  end;
if fclose(OUT) < 0,  error(filename_out);  end;
