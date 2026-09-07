"""Run: python3 test_config_sync.py /path/to/private_modify_config.toml"""
import pathlib, subprocess, sys, tomllib
p=pathlib.Path(sys.argv[1])
def render(s,extra=()):
 r=subprocess.run(['chezmoi','execute-template','--with-stdin','--file',str(p),*extra],input=s,text=True,capture_output=True)
 if r.returncode: raise RuntimeError('Template rendering failed')
 return r.stdout
live=(pathlib.Path.home()/'.codex/config.toml').read_text()
assert render(live)==live, 'Live settings unexpectedly changed'
empty=render('')
assert tomllib.loads(empty)['model']=='gpt-6-astra'
assert render(empty)==empty
fixture='''# local configuration
model = "old"
[projects."/local/project"]
trust_level = "untrusted"
[mcp_servers.notion.http_headers]
Authorization = "FAKE_LOCAL_SECRET"
[mcp_servers.node_repl]
command = "/local/runtime"
[plugins."github@openai-curated"]
local_extra = "keep"
[hooks.state.custom]
trusted_hash = "LOCAL"
'''
merged=render(fixture)
d=tomllib.loads(merged)
assert d['projects']['/local/project']['trust_level']=='untrusted'
assert d['mcp_servers']['notion']['http_headers']['Authorization']=='FAKE_LOCAL_SECRET'
assert d['mcp_servers']['node_repl']['command']=='/local/runtime'
assert d['plugins']['github@openai-curated']['local_extra']=='keep'
assert d['hooks']['state']['custom']['trusted_hash']=='LOCAL'
assert d['model']=='gpt-6-astra' and render(merged)==merged
r=subprocess.run(['chezmoi','execute-template','--with-stdin','--file',str(p)],input='broken = [',text=True,capture_output=True)
assert r.returncode!=0, 'Malformed TOML accepted'
alt=tomllib.loads(render('',('--override-data','{"chezmoi":{"homeDir":"/Users/other","os":"darwin"}}')))
assert alt['mcp_servers']['apple-reminders']['command'].startswith('/Users/other/')
linux=tomllib.loads(render('',('--override-data','{"chezmoi":{"os":"linux"}}')))
assert 'apple-reminders' not in linux['mcp_servers'] and 'desktop' not in linux
print('PASS: unchanged live config, empty initialization, preservation, idempotency, invalid input, alternate home and OS')
