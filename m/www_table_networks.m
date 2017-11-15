%
% Create the table of all networks
%
% OUTPUT FILES
%	skeleton/networks/table.html
%
% INPUT FILES
%	dat/NETWORKS	List of all networks
%

OUT = fopen('skeleton/networks/table.html', 'w');
if OUT < 0,  error('fopen');  end;
NETWORKS = fopen('dat/NETWORKS', 'r');
if NETWORKS < 0,  error('fopen');  end;

fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><TD><B>Name</B><TD><B>Attributes</B><TD align="right" title="Size – number of nodes"><B>n</B><TD align="right" title="Volume – number of edges"><B>m</B>\n');

%% [consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 

while ~((network = fgetl(NETWORKS)) == -1)
  network
  meta = read_meta(network); 
  code= meta.code;
  name= meta.name;
%%  format= read_statistic('format', network); 
%%  weights= read_statistic('weights', network); 
%%  text_format= int_format{format};
%%  text_weights= int_weights{weights}; 
  size= read_statistic('size', network);  size = size(1);
  volume= read_statistic('volume', network);  volume = volume(1); 
  text_size= www_format_statistic('size', size);
  text_volume= www_format_statistic('volume', volume); 
  check_result = www_icon_check(network);
  text_icon_all = www_icon_all(network, meta); 
  
  fprintf(OUT, '<TR><TD><CODE>%s</CODE><TD><A href="%s/">%s</A><TD>%s %s<TD align="right">%s<TD align="right">%s\n', ...
	  code, network, name, check_result, ...
	  text_icon_all, text_size, text_volume); 
%% <A href="${root}/categories/%s/">%s</A> <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s"> %s
%%	  meta.category, icon_category, text_format, title_format, text_weights, title_weights, text_icons,
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error('fclose');  end;
if fclose(NETWORKS) < 0,  error('fclose');  end;
