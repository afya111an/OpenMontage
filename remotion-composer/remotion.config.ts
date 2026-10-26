import { Config } from "@remotion/cli/config";

// Use a pre-installed Chrome/Chromium instead of downloading Remotion's
// headless shell (needed in sandboxed/offline environments, e.g. Claude Code
// cloud sessions). No-op when the variable is unset.
if (process.env.REMOTION_BROWSER_EXECUTABLE) {
  Config.setBrowserExecutable(process.env.REMOTION_BROWSER_EXECUTABLE);
}
