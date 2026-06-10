import { expect, test } from "@playwright/test";

test("home page loads", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "BrikByteOS Phase 1 Example" })).toBeVisible();
  await expect(page.getByTestId("status")).toContainText("Evidence project is running");
});