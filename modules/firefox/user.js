/// Something about the first line having to be a comment?
// Some weird advertising tracking
lockPref("dom.private-attribution.submission.enabled", false);
lockPref("app.shield.optoutstudies.enabled", false);
lockPref("toolkit.telemetry.pioneer-new-studies-available", false);
lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
lockPref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

/* 0320: disable recommendation pane in about:addons (uses Google Analytics) ***/
lockPref("extensions.getAddons.showPane", false); // [HIDDEN PREF]
lockPref("datareporting.policy.dataSubmissionEnabled", false);
lockPref("app.shield.optoutstudies.enabled", false);

lockPref("app.normandy.enabled", false);
lockPref("app.normandy.api_url", "");
lockPref("network.prefetch-next", false);
