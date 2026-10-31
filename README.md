# tree-sitter-dari

DARI 分析稿的 Tree-sitter grammar，提供增量语法树和高亮查询。语法依据 dsh-oks 的 `draft/dom.ts` 与 `draft/typed-syntax.ts`，支持当前 DOM-like 写法。

```dari
data rows := table([{name:"CPU",value:42.5}]);
data spec := {x:"name",value:"value"};
figure usage := BarChart(spec=spec,data=rows);
report answer := Report(title="资源概览") [
  h1 ["资源概览"],
  figure [Figure(ref=usage),figcaption ["平均使用率"]],
];
```

## 使用与验证

需要 Node.js、npm 和 C 编译器。Tree-sitter CLI 固定为 0.27.1；生成 parser 使用语言 ABI 15。

```sh
npm ci
npm run check
npx tree-sitter parse path/to/answer.dari
npx tree-sitter query queries/highlights.scm path/to/answer.dari
```

生成的 `src/parser.c`、`src/node-types.json`、`src/grammar.json` 和 C headers 一并提交，编辑器可直接编译加载；无需在运行时依赖 Node.js。编辑器应将 `.dari` 关联到语言 `dari`，并加载 `queries/highlights.scm`。

## 语法树

- 根为 `source_file`，包含 `data_declaration`、`figure_declaration` 和 `report_declaration`
- 声明提供 `name` 和 `value` 字段；DOM `node` 提供 `tag`，以及可选 `attributes`、`children`
- 数据表达式支持 JSON 字面值、记录与简写属性、数组、调用、lambda、括号、字段访问、可选访问与静态下标
- 运算符优先级与当前 DARI 一致，`??` 也采用左结合
- 节点子项使用方括号和逗号；对象记录使用花括号；声明以分号结束
- 支持行注释、块注释和 JSON 字符串转义

Tree-sitter 负责语法结构和编辑过程中的错误恢复；函数白名单、重复或前向绑定、重复键、静态下标的非负整数约束、节点属性合法性及类型推导由 DARI 的语义检查负责。空文档可解析，便于编辑器从空文件开始工作。XML 风格、旧 pipeline 文本和 jq assets 不属于本 grammar。

## 测试

Corpus 固定语法树结构，覆盖优先级、lambda、DOM、注释与投影。额外测试解析 IC/NS 真实分析稿，并验证非法输入、不完整声明后的恢复、增量编辑及高亮查询。可附加外部样本：

```sh
node scripts/test-parser.mjs /absolute/path/to/example.dari
```
