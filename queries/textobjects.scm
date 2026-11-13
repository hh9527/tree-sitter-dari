(data_declaration value: (_) @entry.inside) @entry.around
(let_declaration value: (_) @entry.inside) @entry.around
(type_declaration value: (_) @class.inside) @class.around
(answer_declaration value: (_) @class.inside) @class.around
(report_declaration value: (_) @class.inside) @class.around
(node (children) @class.inside) @class.around
(node) @class.around
(arguments ((_) @parameter.inside . ","? @parameter.around) @parameter.around)
(attributes ((attribute) @parameter.inside . ","? @parameter.around) @parameter.around)
(pair value: (_) @entry.inside) @entry.around
(shorthand_property) @entry.around
(array (_) @entry.around)
(children (_) @entry.around)
(comment) @comment.inside
(comment)+ @comment.around
(if_node consequence: (children) @class.inside) @class.around
(if_node alternative: (children) @class.inside)
