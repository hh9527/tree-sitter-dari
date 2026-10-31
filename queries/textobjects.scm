; Functions and declaration values.
(lambda_expression body: (_) @function.inside) @function.around
(data_declaration value: (_) @entry.inside) @entry.around
(figure_declaration value: (_) @class.inside) @class.around
(report_declaration value: (_) @class.inside) @class.around
(node (children) @class.inside) @class.around
(node) @class.around
; Parameters include an optional trailing comma in the outer selection.
(parameters ((identifier) @parameter.inside . ","? @parameter.around) @parameter.around)
(arguments ((_) @parameter.inside . ","? @parameter.around) @parameter.around)
(attributes ((attribute) @parameter.inside . ","? @parameter.around) @parameter.around)
(pair value: (_) @entry.inside) @entry.around
(shorthand_property) @entry.around
(array (_) @entry.around)
(children (_) @entry.around)
(comment) @comment.inside
(comment)+ @comment.around
