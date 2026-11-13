import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {readdirSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {resolve} from 'node:path';
const root=fileURLToPath(new URL('..',import.meta.url));
const cli=process.env.TREE_SITTER_CLI || resolve(root,'node_modules/tree-sitter-cli/cli.js');
function run(args) {
  const r=spawnSync(process.execPath,[cli,...args],{cwd:root,encoding:'utf8'});
  if(r.error)throw r.error;
  return r;
}
function parse(path,extra=[]) {
  const r=run(['parse','--quiet','--json-summary',path,...extra]);
  const start=r.stdout.indexOf('{\n  \"parse_summaries\"');
  assert(start>=0,r.stderr+r.stdout);
  return {result:JSON.parse(r.stdout.slice(start)),status:r.status};
}
const samples=readdirSync(resolve(root,'test/examples')).filter(x=>x.endsWith('.dari')).map(x=>resolve(root,'test/examples',x));
for(const path of [...samples,...process.argv.slice(2).map(x=>resolve(x))]) {
  const {result,status}=parse(path);
  assert.equal(status,0,JSON.stringify(result));
  assert.equal(result.cumulative_stats.successful_parses,1,path);
}
for(const fixture of readdirSync(resolve(root,'test/fixtures'))) {
  const path=resolve(root,'test/fixtures',fixture);
  const {result,status}=parse(path);
  assert.notEqual(status,0,fixture);
  assert.equal(result.cumulative_stats.successful_parses,0,fixture);
}
const recovery=run(['parse','test/fixtures/missing-value.dari']);
assert.match(recovery.stdout,/MISSING|ERROR/);
assert.equal((recovery.stdout.match(/data_declaration/g)||[]).length,2,'recover next declaration');
const edited=parse(samples[0],['--edits','0,0 0 # incremental edit\n']);
assert.equal(edited.status,0,JSON.stringify(edited.result));
const highlights=run(['query','queries/highlights.scm',samples[0]]);
assert.equal(highlights.status,0,highlights.stderr);
for(const capture of ['keyword','function.call','tag','attribute'])assert(highlights.stdout.includes(capture),capture);
for (const [query, capture] of [['textobjects', 'entry.around'], ['indents', 'indent']]) {
  const result = run(['query', `queries/${query}.scm`, samples[0]]);
  assert.equal(result.status, 0, result.stderr);
  assert(result.stdout.includes(capture), `${query}: ${capture}`);
}
console.log(`Parsed ${samples.length} bundled drafts plus ${process.argv.length-2} external drafts; invalid syntax, recovery, incremental edit and highlight/textobject/indent queries passed`);

const roles = run(['query', 'queries/highlights.scm', 'test/examples/highlight-roles.dari']);
assert.equal(roles.status, 0, roles.stderr);
const captures = [...roles.stdout.matchAll(/capture: \d+ - ([\w.]+),[^\n]*text: `([^`]*)`/g)].map(([, capture, text]) => ({capture, text}));
for (const [text, capture] of [
 ['Schema','type.builtin'], ['Option','type'], ['Float','type'],
 ['Context','type'], ['Now','constant'], ['CalendarUnit','type'], ['Week','constant'],
 ['ic','namespace'], ['device_kpi','namespace'], ['Percent','constructor'],
 ['map_opt','function.call'], ['Answer','constructor'], ['p','tag'],
 ['data','attribute'], ['b','property'], ['ctx','variable.definition'],
]) assert(captures.some(c => c.text === text && c.capture === capture), text + ': ' + capture);
for (const text of ['Answer', 'Table']) assert(!captures.some(c => c.text === text && c.capture === 'tag'), text + ' must be a component');
const branches = run(['query', 'queries/textobjects.scm', 'test/examples/highlight-roles.dari']);
assert.equal(branches.status, 0, branches.stderr);
assert.match(branches.stdout, /class.inside[^\n]*text: `\[p \["no"\]\]`/);
