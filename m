From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/7] libxt_LED: guard against negative numbers
Date: Sat, 28 Jul 2012 19:21:08 +0200
Message-ID: <1343496069-5442-7-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34350 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2G1RVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:17 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_LED.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
index 9d68fa2..e6cf849 100644
--- a/extensions/libxt_LED.c
+++ b/extensions/libxt_LED.c
@@ -49,6 +49,7 @@ static void LED_help(void)
 static void LED_parse(struct xt_option_call *cb)
 {
 	struct xt_led_info *led = cb->data;
+	unsigned int delay;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
@@ -59,8 +60,10 @@ static void LED_parse(struct xt_option_call *cb)
 	case O_LED_DELAY:
 		if (strncasecmp(cb->arg, "inf", 3) == 0)
 			led->delay = -1;
-		else
-			led->delay = strtoul(cb->arg, NULL, 0);
+		else if (!xtables_strtoui(cb->arg, NULL, &delay, 0, UINT32_MAX))
+			xtables_error(PARAMETER_PROBLEM,
+				"Delay value must be within range 0..%u",
+				UINT32_MAX);
 		break;
 	case O_LED_ALWAYS_BLINK:
 		led->always_blink = 1;
-- 
1.7.7

