["data" "figure" "report"] @keyword
(comment) @comment
(string) @string
(escape_sequence) @string.escape
(number) @number
(boolean) @boolean
(null) @constant.builtin
(identifier) @variable
(data_declaration name: (identifier) @variable.definition)
(figure_declaration name: (identifier) @variable.definition)
(report_declaration name: (identifier) @variable.definition)
(call_expression function: (identifier) @function.call)
(parameters (identifier) @variable.parameter)
(lambda_expression parameters: (identifier) @variable.parameter)
(member_expression property: (identifier) @property)
(pair key: (identifier) @property)
(shorthand_property (identifier) @property)
(node tag: (tag_name) @tag)
(attribute name: (tag_name) @attribute)
[":=" "=>" "=" "?." "??" "||" "&&" "==" "!=" "<" ">" "<=" ">=" "+" "-" "*" "/" "%" "!"] @operator
["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," ";" ":" "."] @punctuation.delimiter
