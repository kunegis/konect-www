%
% Create the table of all networks
%
% OUTPUT FILES
%	skeleton/networks/table.html
%
% INPUT FILES
%	dat/NETWORKS	List of all networks
%

[tag_list tag_text] = konect_data_tag(); 

OUT = fopen('skeleton/networks/table.html', 'w');
if OUT < 0,  error('fopen');  end;
NETWORKS = fopen('dat/NETWORKS', 'r');
if NETWORKS < 0,  error('fopen');  end;

fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><TD><B>Name</B><TD><B>Attributes</B><TD align="right" title="Size – number of nodes"><B>n</B><TD align="right" title="Volume – number of edges"><B>m</B>\n');

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 

while ~((network = fgetl(NETWORKS)) == -1)
  network
  meta = read_meta(network); 
  tags = get_tags(meta); 
  code= meta.code;
  name= meta.name;
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  size= read_statistic('size', network);  size = size(1);
  volume= read_statistic('volume', network);  volume = volume(1); 
  text_size= www_format_statistic('size', size);
  text_volume= www_format_statistic('volume', volume); 
  icon_category = www_icon_category(meta.category); 
  check_result = www_icon_check(network);
  title_format = labels_format{format};
  title_weights = labels_weights{weights};
  
  text_icons = ''; % Additional icons
  if has_timestamps(network)
    text_icons = [text_icons ' <IMG class="icon" src="${root}/ic/icon-timestamps.png" title="Edges are annotated with timestamps">'];
  end
  for j = 1 : length(tag_list)
    tag = tag_list{j}; 
    if isfield(tags, tag)
      text_icons = sprintf('%s <IMG class="icon" src="${root}/ic/icon-tag-%s.png" title="%s">', ...
			   text_icons, tag, tag_text.(tag)); 
    end
  end

  fprintf(OUT, '<TR><TD><CODE>%s</CODE><TD><A href="%s/">%s</A><TD>%s <A href="${root}/categories/%s/">%s</A> <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s"> %s<TD align="right">%s<TD align="right">%s\n', ...
	  code, network, name, check_result, meta.category, icon_category, text_format, title_format, text_weights, title_weights, text_icons, text_size, text_volume); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error('fclose');  end;
if fclose(NETWORKS) < 0,  error('fclose');  end;
