# tree-sitter-dari

注释使用 `#`，延续到行尾。

DARI 类型化数据流语言的增量解析、高亮、缩进与文本对象。语法依据 lab-ontology/dari/src/syntax.ts，扩展名为 .dari。

支持 type/Schema/Option/newtype、data/report/answer、query!/query_remote!、context!、do、let 顺序绑定、|> 管线、.as! 后置绑定及 tree! 条件节点。表达式使用 snake_case 标识和 PascalCase 类型／组件；节点属性使用 =，记录字段使用冒号。声明式语言不开放 lambda、循环或任意代码。

```dari
data rows = query_remote! {
  from(ic::device_kpi).as!(a)
    |> project({cpu:a.cpu_usage}).as!(a)
    |> order_by(desc(a.cpu)) |> take(10)
};
answer tree! {Answer [ColumnChart(data=rows,spec={x:$.cpu,value:$.cpu})]};
```

## 验证

```sh
npm ci
npm run check
npx tree-sitter parse path/to/answer.dari
```

生成的 parser.c、grammar.json、node-types.json 与 C headers 随源码提交。编辑器将 .dari 关联到 dari，并加载 queries 中的高亮、缩进和文本对象。语义、作用域及业务能力由 DARI 检查器证明，Tree-sitter 负责语法。
