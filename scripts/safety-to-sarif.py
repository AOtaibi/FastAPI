
import json
import sys

def convert_safety_to_sarif(json_report, sarif_report):
    with open(json_report, 'r') as f:
        data = json.load(f)

    rules = []
    results = []

    for vuln_id, vuln in data['vulnerabilities'].items():
        rule = {
            "id": vuln_id,
            "name": vuln['package_name'],
            "shortDescription": {
                "text": f"{vuln['package_name']} {vuln['vulnerable_spec']} - {vuln['advisory']}"
            },
            "fullDescription": {
                "text": f"Vulnerability found in {vuln['package_name']}. Installed version: {vuln['installed_version']}. Vulnerable spec: {vuln['vulnerable_spec']}. Advisory: {vuln['advisory']}."
            },
            "help": {
                "text": f"More info: {vuln['more_info_url']}"
            }
        }
        rules.append(rule)

        result = {
            "ruleId": vuln_id,
            "message": {
                "text": f"Vulnerable package: {vuln['package_name']}"
            },
            "locations": [
                {
                    "physicalLocation": {
                        "artifactLocation": {
                            "uri": "requirements.txt"
                        }
                    }
                }
            ]
        }
        results.append(result)

    sarif = {
        "$schema": "https://schemastore.azurewebsites.net/schemas/json/sarif-2.1.0-rtm.5.json",
        "version": "2.1.0",
        "runs": [
            {
                "tool": {
                    "driver": {
                        "name": "Safety",
                        "rules": rules
                    }
                },
                "results": results
            }
        ]
    }

    with open(sarif_report, 'w') as f:
        json.dump(sarif, f, indent=2)

if __name__ == "__main__":
    convert_safety_to_sarif(sys.argv[1], sys.argv[2])
