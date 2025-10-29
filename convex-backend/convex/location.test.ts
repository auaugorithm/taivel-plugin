/**
 * Unit tests for location mutations and queries
 *
 * Run with: npm test
 */

import { describe, it, expect, beforeEach } from 'vitest';
import { convexTest } from 'convex-test';
import { api } from './_generated/api';
import schema from './schema';

describe('location mutations', () => {
  let t: any;

  beforeEach(() => {
    t = convexTest(schema);
  });

  describe('send mutation', () => {
    it('should store location data on first use', async () => {
      // Given: First use with location data
      const latitude = 37.7749;
      const longitude = -122.4194;

      // When: Sending location
      const result = await t.mutation(api.location.send, {
        latitude,
        longitude,
      });

      // Then: Should return success response
      expect(result).toBeDefined();
      expect(result.id).toBeDefined();
      expect(result.message).toBe('Location received successfully');
      expect(result.latitude).toBe(latitude);
      expect(result.longitude).toBe(longitude);
      expect(result.isFirstUse).toBe(true);
      expect(result.timestamp).toBeDefined();
    });

    it('should store empty location on subsequent use', async () => {
      // Given: Subsequent use without location
      // When: Sending without location
      const result = await t.mutation(api.location.send, {});

      // Then: Should return success response without coordinates
      expect(result).toBeDefined();
      expect(result.id).toBeDefined();
      expect(result.message).toBe('Location received successfully');
      expect(result.latitude).toBeUndefined();
      expect(result.longitude).toBeUndefined();
      expect(result.isFirstUse).toBe(false);
    });

    it('should handle partial coordinates gracefully', async () => {
      // Given: Only latitude provided (edge case)
      const latitude = 37.7749;

      // When: Sending partial data
      const result = await t.mutation(api.location.send, {
        latitude,
      } as any);

      // Then: Should store what's provided
      expect(result).toBeDefined();
      expect(result.latitude).toBe(latitude);
    });
  });

  describe('listRecent query', () => {
    beforeEach(async () => {
      // Setup: Insert some test data
      await t.mutation(api.location.send, {
        latitude: 37.7749,
        longitude: -122.4194,
      });
      await t.mutation(api.location.send, {
        latitude: 40.7128,
        longitude: -74.0060,
      });
      await t.mutation(api.location.send, {});
    });

    it('should return recent locations', async () => {
      // When: Querying recent locations
      const locations = await t.query(api.location.listRecent, {});

      // Then: Should return all locations
      expect(locations).toBeDefined();
      expect(locations.length).toBe(3);
    });

    it('should respect limit parameter', async () => {
      // When: Querying with limit
      const locations = await t.query(api.location.listRecent, {
        limit: 2,
      });

      // Then: Should return only 2 locations
      expect(locations.length).toBe(2);
    });

    it('should return locations in descending order', async () => {
      // When: Querying locations
      const locations = await t.query(api.location.listRecent, {});

      // Then: Should be ordered by timestamp (newest first)
      expect(locations[0].timestamp).toBeGreaterThanOrEqual(
        locations[1].timestamp
      );
    });
  });

  describe('getStats query', () => {
    beforeEach(async () => {
      // Setup: Insert test data
      await t.mutation(api.location.send, {
        latitude: 37.7749,
        longitude: -122.4194,
      });
      await t.mutation(api.location.send, {});
      await t.mutation(api.location.send, {});
    });

    it('should return correct statistics', async () => {
      // When: Getting stats
      const stats = await t.query(api.location.getStats, {});

      // Then: Should return accurate counts
      expect(stats).toBeDefined();
      expect(stats.total).toBe(3);
      expect(stats.firstUse).toBe(1);
      expect(stats.subsequentUse).toBe(2);
      expect(stats.latest).toBeDefined();
    });

    it('should handle empty database', async () => {
      // Given: Fresh test instance
      const freshTest = convexTest(schema);

      // When: Getting stats with no data
      const stats = await freshTest.query(api.location.getStats, {});

      // Then: Should return zero counts
      expect(stats.total).toBe(0);
      expect(stats.firstUse).toBe(0);
      expect(stats.subsequentUse).toBe(0);
    });
  });
});

describe('location data validation', () => {
  let t: any;

  beforeEach(() => {
    t = convexTest(schema);
  });

  it('should accept valid coordinates', async () => {
    const validCases = [
      { latitude: 0, longitude: 0 }, // Equator
      { latitude: 90, longitude: 180 }, // North Pole, Date Line
      { latitude: -90, longitude: -180 }, // South Pole, Date Line
      { latitude: 37.7749, longitude: -122.4194 }, // San Francisco
    ];

    for (const coords of validCases) {
      const result = await t.mutation(api.location.send, coords);
      expect(result.latitude).toBe(coords.latitude);
      expect(result.longitude).toBe(coords.longitude);
    }
  });

  it('should store timestamp correctly', async () => {
    const before = Date.now();
    const result = await t.mutation(api.location.send, {
      latitude: 37.7749,
      longitude: -122.4194,
    });
    const after = Date.now();

    expect(result.timestamp).toBeGreaterThanOrEqual(before);
    expect(result.timestamp).toBeLessThanOrEqual(after);
  });
});
