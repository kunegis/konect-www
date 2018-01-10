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
%	uni/meta.[dat/NETWORKS_CATEGORY_$category]
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
fprintf(OUT, '<TR><TD><B>Name</B><TD class="padleft"><B>Attributes</B><TD align="right" title="Size – number of nodes"><B>n</B><TD align="right" title="Volume – number of edges"><B>m</B><TD class="padleft"><B>Node meaning</B><TD class="padleft"><B>Edge meaning</B>\n'); 

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
  text_icon_all = www_icon_all(network, meta); 

  size= read_statistic('size', network);  size = size(1);
  volume= read_statistic('volume', network);  volume = volume(1); 
  text_size= www_format_statistic('size', size);
  text_volume= www_format_statistic('volume', volume); 

  text_node_meaning= '';
  text_edge_meaning= '';
  if isfield(meta, 'entity_names')
    text_node_meaning= www_format_entrel_names(meta.entity_names);
  end
  if isfield(meta, 'relationship_names')
    text_edge_meaning= www_format_entrel_names(meta.relationship_names);
  end
  
  fprintf(OUT, '<TR><TD><A href="../../networks/%s/">%s</A><TD class="padleft">%s<TD align="right">%s<TD align="right">%s<TD class="padleft">%s<TD class="padleft">%s\n', ...
	  network, name, text_icon_all, ...
	  text_size, text_volume, ...
	  text_node_meaning, text_edge_meaning); 

  count = count + 1; 
end

%% <A href="${root}/categories/%s/">%s</A> <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s">\n'

assert(count >= 1); 

fprintf(OUT, '</TABLE>\n'); 

if fclose(NETWORKS) < 0,  error(filename_networks);  end;
if fclose(OUT) < 0,  error(filename_out);  end;
