"""Parse Anthropic /v1/models response."""
import json, sys

data = json.load(sys.stdin)
if "error" in data:
    print(f'Error: {data["error"].get("message", data)}')
    sys.exit(1)

models = data.get("data", [])
print(f"Total models: {len(models)}")
for m in sorted(models, key=lambda x: x.get("created_at", ""), reverse=True):
    mid = m["id"]
    name = m.get("display_name", mid)
    print(f"  {mid}  ({name})")
