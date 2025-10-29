import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

/**
 * Database schema for Taivel App Clip
 *
 * Stores location data sent from the iOS App Clip
 */
export default defineSchema({
  locations: defineTable({
    // Optional because location may not be available on subsequent requests
    latitude: v.optional(v.number()),
    longitude: v.optional(v.number()),
    // Timestamp when the location was received
    timestamp: v.number(),
    // Additional metadata
    isFirstUse: v.optional(v.boolean()),
  }).index("by_timestamp", ["timestamp"]),
});
