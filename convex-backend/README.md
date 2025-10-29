# Taivel Convex Backend

This is the Convex backend for the Taivel iOS App Clip. It receives location data via HTTP API and stores it in the Convex database.

## Quick Start

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start development server**:
   ```bash
   npm run dev
   ```
   This will:
   - Start a local Convex development server
   - Open the Convex dashboard in your browser
   - Watch for changes and hot reload

3. **Deploy to production**:
   ```bash
   npm run deploy
   ```

## Project Structure

```
convex-backend/
├── convex/
│   ├── location.ts    # Location mutation and query functions
│   └── schema.ts      # Database schema definition
├── package.json       # Node.js dependencies
└── README.md         # This file
```

## API Endpoints

### Send Location (Mutation)

**HTTP POST**: `https://your-deployment.convex.cloud/api/mutation`

**Request Body**:
```json
{
  "path": "location:send",
  "args": {
    "latitude": 37.7749,
    "longitude": -122.4194
  },
  "format": "json"
}
```

**Response (Success)**:
```json
{
  "status": "success",
  "value": {
    "id": "...",
    "message": "Location received successfully",
    "latitude": 37.7749,
    "longitude": -122.4194,
    "isFirstUse": true,
    "timestamp": 1234567890
  },
  "logLines": []
}
```

### List Recent Locations (Query)

**HTTP POST**: `https://your-deployment.convex.cloud/api/query`

**Request Body**:
```json
{
  "path": "location:listRecent",
  "args": {
    "limit": 10
  },
  "format": "json"
}
```

### Get Statistics (Query)

**HTTP POST**: `https://your-deployment.convex.cloud/api/query`

**Request Body**:
```json
{
  "path": "location:getStats",
  "args": {},
  "format": "json"
}
```

## Database Schema

### locations table

| Field | Type | Description |
|-------|------|-------------|
| `latitude` | `number?` | User's latitude (optional) |
| `longitude` | `number?` | User's longitude (optional) |
| `timestamp` | `number` | Unix timestamp when received |
| `isFirstUse` | `boolean?` | Whether this was first use (has location) |

## Development

### View Data in Dashboard

After running `npm run dev`, open the Convex dashboard to:
- View stored locations
- Test mutations and queries
- Monitor logs
- See real-time updates

### Testing the API

You can test the HTTP API using curl:

```bash
# Send location (first use)
curl -X POST https://your-deployment.convex.cloud/api/mutation \
  -H "Content-Type: application/json" \
  -d '{
    "path": "location:send",
    "args": {
      "latitude": 37.7749,
      "longitude": -122.4194
    },
    "format": "json"
  }'

# Send request without location (subsequent use)
curl -X POST https://your-deployment.convex.cloud/api/mutation \
  -H "Content-Type: application/json" \
  -d '{
    "path": "location:send",
    "args": {},
    "format": "json"
  }'
```

## Deployment

1. **Login to Convex** (first time only):
   ```bash
   npx convex login
   ```

2. **Deploy**:
   ```bash
   npm run deploy
   ```

3. **Get your deployment URL**:
   - Check the terminal output after deployment
   - Or find it in the Convex dashboard
   - Format: `https://your-deployment-name.convex.cloud`

4. **Update iOS app**:
   - Copy the deployment URL
   - Update `ConvexAPIClient.swift` in the iOS app
   - Replace `https://your-deployment.convex.cloud` with your actual URL

## Environment Variables

Convex manages environment configuration automatically. For advanced use cases, you can set environment variables in the Convex dashboard.

## Documentation

- [Convex Documentation](https://docs.convex.dev)
- [HTTP API Reference](https://docs.convex.dev/http-api/)
- [Database Guide](https://docs.convex.dev/database)

## Support

- Convex Discord: https://convex.dev/community
- Documentation: https://docs.convex.dev
