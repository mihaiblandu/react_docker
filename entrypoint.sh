#!/bin/sh
# entrypoint.sh - No jq dependency version

set -e

echo "Generating env.js with environment variables..."

# Function to escape JSON strings manually
escape_json() {
    # Escape backslashes, quotes, and control characters
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g; s/$//' | tr -d '\n\r'
}

# Create env.js file
echo "window.env = {" > /usr/share/nginx/html/env.js

# Get environment variables, filter for VITE_ and REACT_APP_, and remove duplicates
env | grep -E '^(VITE_|REACT_APP_)' | sort -u | while IFS='=' read -r key value; do
    # Skip if key is empty
    [ -z "$key" ] && continue
    
    # Escape the value for JSON
    escaped_value=$(escape_json "$value")
    
    # Add to the JavaScript object
    echo "  \"$key\": \"$escaped_value\"," >> /usr/share/nginx/html/env.js
done

# Remove trailing comma from the last entry and close the object
sed -i '$ s/,$//' /usr/share/nginx/html/env.js 2>/dev/null || true
echo "};" >> /usr/share/nginx/html/env.js

# Make readable
chmod 644 /usr/share/nginx/html/env.js

echo "Generated env.js:"
cat /usr/share/nginx/html/env.js

# Start nginx
exec nginx -g "daemon off;"