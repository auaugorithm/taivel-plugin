import { mutation, query } from "./_generated/server";
import { v } from "convex/values";

/**
 * Mutation to receive location data from the iOS App Clip
 *
 * This is called via HTTP API POST to /api/mutation with:
 * {
 *   "path": "location:send",
 *   "args": {
 *     "latitude": 37.7749,
 *     "longitude": -122.4194
 *   },
 *   "format": "json"
 * }
 */
export const send = mutation({
  args: {
    latitude: v.optional(v.number()),
    longitude: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const { latitude, longitude } = args;

    // Determine if this is first use (has location data)
    const isFirstUse = latitude !== undefined && longitude !== undefined;

    // Store in database
    const locationId = await ctx.db.insert("locations", {
      latitude,
      longitude,
      timestamp: Date.now(),
      isFirstUse,
    });

    // Log for debugging
    if (isFirstUse) {
      console.log(`📍 First use - Received location: lat=${latitude}, lng=${longitude}`);
    } else {
      console.log(`📍 Subsequent use - No location data`);
    }

    return {
      id: locationId,
      message: "Location received successfully",
      latitude,
      longitude,
      isFirstUse,
      timestamp: Date.now(),
    };
  },
});

/**
 * Query to retrieve recent locations
 *
 * Useful for viewing the data in the Convex dashboard or building a web dashboard
 */
export const listRecent = query({
  args: {
    limit: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    const limit = args.limit ?? 100;

    const locations = await ctx.db
      .query("locations")
      .order("desc")
      .take(limit);

    return locations;
  },
});

/**
 * Query to get location statistics
 */
export const getStats = query({
  handler: async (ctx) => {
    const allLocations = await ctx.db.query("locations").collect();

    const firstUseCount = allLocations.filter((loc) => loc.isFirstUse).length;
    const subsequentUseCount = allLocations.length - firstUseCount;

    return {
      total: allLocations.length,
      firstUse: firstUseCount,
      subsequentUse: subsequentUseCount,
      latest: allLocations[0],
    };
  },
});
