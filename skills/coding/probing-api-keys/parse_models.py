"""Parse OpenAI / compatible /v1/models response."""
import json, sys

data = json.load(sys.stdin)
if "error" in data:
    print(f"Error: {data}")
    sys.exit(1)

models = sorted([m["id"] for m in data.get("data", [])])
print(f"Total models: {len(models)}")
for m in models:
    print(f"  {m}")
