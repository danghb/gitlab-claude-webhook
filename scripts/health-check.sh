#!/bin/bash

# Health check script for GitLab Claude Webhook Service

set -e

SERVICE_URL="${SERVICE_URL:-http://localhost:3000}"

echo "🔍 Checking GitLab Claude Webhook Service health..."

# Check basic connectivity
echo "Checking service connectivity..."
if curl -f -s "${SERVICE_URL}/health" > /dev/null; then
    echo "✅ Service is responding"
else
    echo "❌ Service is not responding"
    exit 1
fi

# Check service info endpoint
echo "Checking service info..."
SERVICE_INFO=$(curl -s "${SERVICE_URL}/")
echo "Service info: ${SERVICE_INFO}"

# Check if required environment variables are set
echo "Checking environment variables..."
if [ -z "${ANTHROPIC_AUTH_TOKEN}" ]; then
    echo "⚠️  ANTHROPIC_AUTH_TOKEN not set"
    exit 1
fi

if [ -z "${GITLAB_TOKEN}" ]; then
    echo "⚠️  GITLAB_TOKEN not set"
    exit 1
fi

if [ -z "${WEBHOOK_SECRET}" ]; then
    echo "⚠️  WEBHOOK_SECRET not set"
    exit 1
fi

echo "✅ All environment variables are set"

# Check if Claude CLI is available (optional - SDK bundles it internally)
if command -v claude &> /dev/null; then
    echo "✅ Claude CLI is available in PATH"
    claude --version
else
    echo "ℹ️  Claude CLI not found in PATH (this is normal — the SDK bundles the binary internally)"
fi

echo "🎉 Health check completed successfully!"