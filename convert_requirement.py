import json

def convert_requirements_txt(requirements_txt_path):
    with open(requirements_txt_path, 'r') as file:
        requirements = file.readlines()

    dependencies = []
    for index, requirement in enumerate(requirements, start=1):
        requirement = requirement.strip()
        if requirement:
            name, version = requirement.split("==")
            pkg_id = f"pkg-{index}"
            dependencies.append({
                'name': name,
                'version': version,
                'id': pkg_id
            })

    converted_data = {
        'dependencies': dependencies
    }

    return converted_data

def save_converted_data(converted_data, output_file_path):
    with open(output_file_path, 'w') as file:
        json.dump(converted_data, file, indent=2)

# Example usage
requirements_txt_path = 'requirements.txt'
output_file_path = 'requirements.json'

converted_data = convert_requirements_txt(requirements_txt_path)
save_converted_data(converted_data, output_file_path)
