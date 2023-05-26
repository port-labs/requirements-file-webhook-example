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
convert_requirements_txt() {
    local requirements_txt_path="$1"
    local requirements=$(cat "$requirements_txt_path")

    local dependencies=""
    local index=1
    IFS=$'\n'  # Set IFS to newline to properly handle requirements with spaces
    for requirement in $(echo "$requirements"); do
        requirement=$(echo "$requirement" | tr -d '[:space:]')  # Remove whitespace characters
        if [ -n "$requirement" ]; then
            name=$(echo "$requirement" | cut -d'=' -f1)
            version=$(echo "$requirement" | cut -d'=' -f2)
            pkg_id="pkg-$index"
            dependencies="$dependencies{\"name\":\"$name\",\"version\":\"$version\",\"id\":\"pkg-$index\",\"zope.interface\":\"$zope.interface\"},"
            index=$((index + 1))
        fi
    done

    local converted_data="{\"service\":\"$SERVICE_ID\",\"dependencies\":[${dependencies%,}]}"
    echo "$converted_data"
}

converted_data=$(convert_requirements_txt "$PATH_TO_REQUIREMENTS_TXT_FILE")
echo "$converted_data"