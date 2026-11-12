["type" "data" "report" "answer" "if" "else" "let" "do"] @keyword
["query" "query_remote" "context" "project" "tree" "as"] @function.macro
(comment) @comment
(string) @string
(escape_sequence) @string.escape
(number) @number
(boolean) @boolean
(null) @constant.builtin
(identifier) @variable
(type_declaration name: (identifier) @type.definition)
(type_identifier) @type
(data_declaration name: (identifier) @variable.definition)
(let_declaration name: (identifier) @variable.definition)
(postfix_binding name: (identifier) @variable.definition)
(report_declaration name: (identifier) @variable.definition)
(call_expression function: (_) @function.call)
(member_expression property: (identifier) @property)
(pair key: (identifier) @property)
(shorthand_property (identifier) @property)
(schema_field name: (identifier) @property)
(node tag: (tag_name) @tag)
((node tag: (tag_name) @constructor) (#match? @constructor "^[A-Z]"))
(attribute name: (identifier) @attribute)
["=" "|>" "::" "&" "||" "&&" "==" "!=" "<" ">" "<=" ">=" "+" "-" "*" "/" "%" "!"] @operator
["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," ";" ":" "."] @punctuation.delimiter
"Some" @constructor
(if_node binding: (identifier) @variable.parameter)
