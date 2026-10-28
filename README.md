# ux_doctrine

**One capability bit from GBT V8, packaged standalone.** No. 289 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **交互铁律**（主人令 2026-10-09）：「在框架里面出来必须要用户求助帮忙的其他全部禁止掉……你开口要求用户的时候你就输了」「可以跟用户商量项目架构和排布，严禁要求用户帮助」「每次停下要么是项目部署完成，要么就是真正需要用户来操作的可以停下，其他时候你停下干嘛」。移植自 V9 core/ux_doctrine.py（教义照搬，危险清单按 V8 真门重写）。op=doctrine 读全部规则 · ask **不开口闸**（14 条正则抓「要用户做事」，唯一例外=身份登录）· dismissal **敷衍闸**（不影响/忽略即可/下次再说 全禁）· triage **报警闭环闸**（{现象→根因→处置→证据} 四件齐才算闭环）· owner 判要不要停人要授权 · stop **停点闸**（只有「部署完成带证据」与「危险清单授权」两种理由合法，其余一律不许停）。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-ux-doctrine.git
cd gbt-ux-doctrine
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_ux_doctrine info                  # capability card
python -m gbt_ux_doctrine spec --json           # machine-readable contract
python -m gbt_ux_doctrine check --payload '{}'
python -m gbt_ux_doctrine run   --payload '{}'
```

Real `info` output from this machine:

```text
ux_doctrine  (system)  v1.0.0
----------------------------------------
**交互铁律**（主人令 2026-10-09）：「在框架里面出来必须要用户求助帮忙的其他全部禁止掉……你开口要求用户的时候你就输了」「可以跟用户商量项目架构和排布，严禁要求用户帮助」「每次停下要么是项目部署完成，要么就是真正需要用户来操作的可以停下，其他时候你停下干嘛」。移植自 V9 core/ux_doctrine.py（教义照搬，危险清单按 V8 真门重写）。op=doctrine 读全部规则 · ask **不开口闸**（14 条正则抓「要用户做事」，唯一例外=身份登录）· dismissal **敷衍闸**（不影响/忽略即可/下次再说 全禁）· triage **报警闭环闸**（{现象→根因→处置→证据} 四件齐才算闭环）· owner 判要不要停人要授权 · stop **停点闸**（只有「部署完成带证据」与「危险清单授权」两种理由合法，其余一律不许停）。

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_ux_doctrine import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `ux_doctrine` |
| domain | `system` |
| handler | `ux_doctrine` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/ux_doctrine](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/ux_doctrine.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
