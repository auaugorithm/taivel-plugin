//
//  ConvexConfig.swift
//  TaivelAppClip
//
//  Configuration for Convex deployment
//

import Foundation

struct ConvexConfig {
    /// Your Convex deployment URL
    /// Get this from your Convex dashboard at https://dashboard.convex.dev
    /// Format: https://your-deployment-name.convex.cloud
    static let deploymentURL = "https://your-deployment.convex.cloud"

    /// The mutation path for sending location data
    /// This should match your Convex function path
    static let locationMutationPath = "location:send"

    /// API endpoint (usually /api/mutation for mutations)
    static let apiEndpoint = "/api/mutation"

    /// Request timeout in seconds
    static let requestTimeout: TimeInterval = 3.0
}

// MARK: - Usage Instructions
/*
 To configure your Convex backend:

 1. Sign up at https://www.convex.dev
 2. Create a new project
 3. Deploy the backend functions (see convex/ folder for example)
 4. Copy your deployment URL from the dashboard
 5. Update ConvexConfig.deploymentURL above

 Example Convex function (convex/location.ts):

 ```typescript
 import { mutation } from "./_generated/server";
 import { v } from "convex/values";

 export const send = mutation({
   args: {
     latitude: v.optional(v.number()),
     longitude: v.optional(v.number()),
   },
   handler: async (ctx, args) => {
     const { latitude, longitude } = args;

     // Store in database
     const locationId = await ctx.db.insert("locations", {
       latitude,
       longitude,
       timestamp: Date.now(),
     });

     console.log(`Received location: ${latitude}, ${longitude}`);

     return {
       id: locationId,
       message: "Location received successfully",
     };
   },
 });
 ```

 Database schema (convex/schema.ts):

 ```typescript
 import { defineSchema, defineTable } from "convex/server";
 import { v } from "convex/values";

 export default defineSchema({
   locations: defineTable({
     latitude: v.optional(v.number()),
     longitude: v.optional(v.number()),
     timestamp: v.number(),
   }),
 });
 ```
 */
