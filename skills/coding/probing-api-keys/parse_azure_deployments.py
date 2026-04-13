"""Parse Azure OpenAI /deployments response."""
import json, sys

data = json.load(sys.stdin)
if "error" in data:
    print(f'Error: {data["error"].get("message", data["error"])}')
    print("Note: deployments endpoint may require management-plane access.")
    print("The models endpoint above shows what the region supports.")
    sys.exit(0)

deployments = data.get("data", [])
print(f"Deployed models: {len(deployments)}")
for d in deployments:
    model = d.get("model", "unknown")
    name = d.get("id", "unknown")
    status = d.get("status", "unknown")
    print(f"  {name} -> {model} [{status}]")
