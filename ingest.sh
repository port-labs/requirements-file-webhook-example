#!/bin/sh

# Get environment variables
WEBHOOK_URL="$WEBHOOK_URL"
SERVICE_ID="$SERVICE_ID"
PATH_TO_REQUIREMENTS_TXT_FILE="$PATH_TO_REQUIREMENTS_TXT_FILE"

add_entity_to_port() {
    local entity_object="$1"
    local headers="Accept: application/json"
    local response=$(curl -X POST -H "$headers" -H "Content-Type: application/json" -d "$entity_object" "$WEBHOOK_URL")
    echo "$response"
}

# This function takes a requirements.txt file path, converts all the dependencies into a 
# JSON array using three keys (name, version, and id). It then sends this data to Port

#!/bin/sh

convert_requirements_txt() {
    requirements_txt_path="$1"

    # Initialize variables
    index=1
    dependencies=""

    # Read the requirements.txt file line by line
    while IFS= read -r line || [ -n "$line" ]; do
        # Trim leading and trailing whitespace
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        # Skip empty lines or lines starting with #
        if [ -z "$line" ] || [ "$(printf %.1s "$line")" = "#" ]; then
            continue
        fi

        # Extract the name and version using awk
        name=$(echo "$line" | awk -F'==' '{print $1}')
        version=$(echo "$line" | awk -F'==' '{print $2}')

        # Generate the ID with the format "pkg-<ID>"
        pkg_id="pkg-$index"

        # Add the dependency to the JSON array
        dependencies="$dependencies{\"name\":\"$name\",\"version\":\"$version\",\"id\":\"$pkg_id\"},"

        # Increment the index
        index=$((index + 1))
    done < "$requirements_txt_path"

    # Remove the trailing comma from the dependencies string
    dependencies=$(echo "$dependencies" | sed 's/,$//')

    # Generate the final JSON object and send it to Port
    local entity_object="{\"service\":\"$SERVICE_ID\",\"dependencies\":[${dependencies}]}"
    
    local webhook_response=$(add_entity_to_port "$entity_object")
    echo "$webhook_response"

}
# Example usage

converted_data=$(convert_requirements_txt "$PATH_TO_REQUIREMENTS_TXT_FILE")
echo "$converted_data"