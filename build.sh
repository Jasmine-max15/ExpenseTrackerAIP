#!/bin/bash

echo "🚀 Compiling Java source files..."
mkdir -p WebContent/WEB-INF/classes
javac --release 21 -cp "/opt/homebrew/opt/tomcat/libexec/lib/servlet-api.jar:WebContent/WEB-INF/lib/*" -d WebContent/WEB-INF/classes $(find src -name "*.java")

if [ $? -eq 0 ]; then
    echo "✅ Compilation successful!"
    echo "📦 Deploying to Tomcat..."
    
    # Create the app directory in Tomcat if it doesn't exist
    mkdir -p /opt/homebrew/opt/tomcat/libexec/webapps/ExpenseTracker
    
    # Sync WebContent to Tomcat webapps
    rsync -av --delete WebContent/ /opt/homebrew/opt/tomcat/libexec/webapps/ExpenseTracker/ > /dev/null
    
    echo "🎉 Deployment complete!"
    echo "👉 You can view your app at: http://localhost:8080/ExpenseTracker/"
    echo "Note: If Tomcat is not running, start it using: brew services start tomcat"
else
    echo "❌ Compilation failed. Please check the Java errors above."
fi
