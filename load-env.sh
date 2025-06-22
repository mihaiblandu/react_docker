#!/bin/sh

# Simple script to create env.js from all VITE_* environment variables

# Start the env.js file
cat > /usr/share/nginx/html/env.js << 'EOF'
window.env = {
EOF

# Get all environment variables that start with VITE_
env | grep '^VITE_' | while IFS='=' read -r name value; do
    # Escape quotes in the value
    escaped_value=$(echo "$value" | sed 's/"/\\"/g')
    echo "  $name: \"$escaped_value\"," >> /usr/share/nginx/html/env.js
done

# Close the JavaScript object
cat >> /usr/share/nginx/html/env.js << 'EOF'
};
Object.freeze(window.env);
EOF

echo "✅ env.js created with all VITE_* variables"

exit 0