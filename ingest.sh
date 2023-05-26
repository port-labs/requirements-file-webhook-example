#!/bin/sh

# Get environment variables
WEBHOOK_URL="$WEBHOOK_URL"
SERVICE_ID="$SERVICE_ID"
PATH_TO_PACKAGE_JSON_FILE="$PATH_TO_PACKAGE_JSON_FILE"

add_entity_to_port() {
    local entity_object="$1"
    local headers="Accept: application/json"
    local response=$(curl -X POST -H "$headers" -H "Content-Type: application/json" -d "$entity_object" "$WEBHOOK_URL")
    echo "$response"
}

# This function takes a package.json file path, converts the "dependencies" property into a 
# JSON array using three keys (name, version, and id). It then sends this data to Port
convert_package_json() {
    local package_json_path="$1"
    local data=$(cat "$package_json_path")
    local dependencies=$(echo "$data" | jq -r '.dependencies // {}')

    local converted_dependencies=""
    local index=1
    while IFS="=" read -r dep_name version; do
        pkg_id="pkg-$index"
        converted_dependencies="$converted_dependencies{\"name\":\"$dep_name\",\"version\":\"$version\",\"id\":\"$pkg_id\"},"
        index=$((index + 1))
    done <<EOF
$(echo "$dependencies" | jq -r 'to_entries[] | .key + "=" + .value')
EOF

    local entity_object="{\"service\":\"$SERVICE_ID\",\"dependencies\":[${converted_dependencies%,}]}"
    echo "$entity_object"
    local webhook_response=$(add_entity_to_port "$entity_object")
    echo "$webhook_response"
}

converted_data=$(convert_package_json "$PATH_TO_PACKAGE_JSON_FILE")
echo "$converted_data"