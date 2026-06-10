import { describe, expect, test } from "vitest";
import { add, divide } from "../../src/math.js";

describe("math", () => {
  test("adds two numbers", () => {
    expect(add(2, 3)).toBe(5);
  });

  test("divides two numbers", () => {
    expect(divide(10, 2)).toBe(5);
  });

  test("rejects division by zero", () => {
    expect(() => divide(10, 0)).toThrow("cannot divide by zero");
  });
});