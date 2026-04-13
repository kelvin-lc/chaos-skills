"""Parse Azure OpenAI /models response and group by capability."""
import json, sys

data = json.load(sys.stdin)
if "error" in data:
    print(f'Error: {data["error"].get("message", data["error"])}')
    sys.exit(1)

models = data.get("data", [])

chat = [m["id"] for m in models if m.get("capabilities", {}).get("chat_completion")]
embed = [m["id"] for m in models if m.get("capabilities", {}).get("embeddings")]
completion = [
    m["id"]
    for m in models
    if m.get("capabilities", {}).get("completion")
    and not m.get("capabilities", {}).get("chat_completion")
]
other = [
    m["id"]
    for m in models
    if not m.get("capabilities", {}).get("chat_completion")
    and not m.get("capabilities", {}).get("embeddings")
    and not m.get("capabilities", {}).get("completion")
]

print(f"Total models available in region: {len(models)}")
print(f"\nChat models ({len(chat)}):")
for m in sorted(chat):
    print(f"  {m}")
print(f"\nEmbedding models ({len(embed)}):")
for m in sorted(embed):
    print(f"  {m}")
print(f"\nCompletion-only models ({len(completion)}):")
for m in sorted(completion):
    print(f"  {m}")
print(f"\nOther models (image/audio/etc) ({len(other)}):")
for m in sorted(other):
    print(f"  {m}")
