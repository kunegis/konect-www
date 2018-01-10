%
% Format the "node meaning" and "edge meaning" fields.
%
% Spaces around commas are formatted, and capitalization is set.
%
% The input string may be empty, in which case the empty string is
% returned. 
%
% PARAMETERS
%	text	Text as given in the meta.* file, in the fields
% 		"entity_names" and "relationship_names"
%
% RESULT
%	text	The formatted text 
%

function text = www_format_entrel_names(text)

text= regexprep(text, ',', ', '); 
text= regexprep(text, '^\s*', '');
if length(text) >= 1 && text(1) >= 'a' && text(1) <= 'z'
  text(1) = text(1) + ('A' - 'a'); 
end
