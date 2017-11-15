%
% The HTML for all icons, except the "check" icon, which is normally not
% shown except on the Networks page. 
%

function text = www_icon_all(network, meta) 

  [tag_list tag_text] = konect_data_tag(); 
  [consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 

  icon_category = www_icon_category(meta.category); 
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  title_format = labels_format{format};
  title_weights = labels_weights{weights};
  tags = get_tags(meta); 

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

  text = ...
  sprintf('<A href="${root}/categories/%s/">%s</A> <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s"> %s', ...
	 meta.category, icon_category, text_format, title_format, text_weights, title_weights, text_icons);  
