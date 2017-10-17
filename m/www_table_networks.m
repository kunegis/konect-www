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

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 
colors = konect_data_category(); 

while ~((network = fgetl(NETWORKS)) == -1)
  meta = read_meta(network); 
  code= meta.code;
  name= meta.name;
  category= meta.category;
  c = floor(colors.(category) * 255); 
  color_category= sprintf('%02X%02X%02X', c(1), c(2), c(3));
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  size= read_statistic('size', network);  size = size(1);
  volume= read_statistic('volume', network);  volume = volume(1); 
  text_size= www_format_statistic('size', size);
  text_volume= www_format_statistic('volume', volume); 

  if exist(sprintf('dat/check.%s', network), 'file') == 2
    check_value = load(sprintf('dat/check.%s', network));
    if check_value
      check_result = '<IMG class="icon" src="${root}/ic/icon-check-success.png" title="Dataset passed all tests">';
    else
      check_result = '<IMG class="icon" src="${root}/ic/icon-check-failure.png" title="Dataset failed tests">';
    end
  else
    check_result = '<IMG class="icon" src="${root}/ic/icon-unknown.png" title="Check was not executed">';
  end

  fprintf(OUT, '<TR><TD><CODE>%s</CODE><TD><A href="%s/">%s</A><TD>%s <DIV class="category-circle" style="background-color:#%s;" title="%s network"></DIV> <IMG class="icon" src="${root}/ic/icon-format-%s.png"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png"><TD align="right">%s<TD align="right">%s\n', ...
	  code, network, name, check_result, color_category, category, text_format, text_weights, text_size, text_volume); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error('fclose');  end;
if fclose(NETWORKS) < 0,  error('fclose');  end;
