["type" "data" "report" "answer" "if" "else" "let" "do"] @keyword
["query" "query_remote" "context" "tree" "as" "unwrap_or"] @function.macro
(comment) @comment
(string) @string
(escape_sequence) @string.escape
(number) @number
(boolean) @constant.builtin.boolean
(null) @constant.builtin

; Qualified paths use namespaces for snake_case segments, types and variants
; for PascalCase segments. More specific syntactic contexts follow below.
(type_declaration name: (identifier) @type.definition)
(type_identifier (identifier) @type)
(type_identifier (scoped_identifier (identifier) @type .))
"Schema" @type.builtin
(data_declaration name: (identifier) @variable.definition)
(let_declaration name: (identifier) @variable.definition)
(postfix_binding name: (identifier) @variable.definition)
(report_declaration name: (identifier) @variable.definition)
(call_expression function: (identifier) @function.call)
(call_expression function: (scoped_identifier (identifier) @function.call .))
((call_expression function: (identifier) @constructor) (#match? @constructor "^[A-Z]"))
((call_expression function: (scoped_identifier (identifier) @constructor .)) (#match? @constructor "^[A-Z]"))
(member_expression property: (identifier) @property)
(pair key: (identifier) @property)
(shorthand_property (identifier) @property)
(schema_field name: (identifier) @property)
((node tag: (tag_name) @tag) (#match? @tag "^[a-z]"))
((node tag: (tag_name) @constructor) (#match? @constructor "^[A-Z]"))
(attribute name: (identifier) @attribute)
["=" "|>" "::" "&" "||" "&&" "==" "!=" "<" ">" "<=" ">=" "+" "-" "*" "/" "%" "!"] @operator
["(" ")" "[" "]" "{" "}"] @punctuation.bracket
["," ";" ":" "."] @punctuation.delimiter
"Some" @constructor
(if_node binding: (identifier) @variable.parameter)

"$" @variable.builtin
(projection_expression field: (identifier) @property)

"?" @operator

; Specific roles precede fallbacks at the same range.
((scoped_identifier (identifier) @constant .) (#match? @constant "^[A-Z]"))
((scoped_identifier (identifier) @type) (#match? @type "^[A-Z]"))
(scoped_identifier (identifier) @namespace)
(identifier) @variable
