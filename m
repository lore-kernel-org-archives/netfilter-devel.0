From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 19/28] libxt_LED: use guided option parser
Date: Tue, 12 Apr 2011 16:23:34 +0200
Message-ID: <1302618224-9449-20-git-send-email-jengelh@medozas.de>
References: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54678 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756352Ab1DLOYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:24:07 -0400
In-Reply-To: <1302618224-9449-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_LED.c |   84 +++++++++++++++++++-----------------------------
 1 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
index 9e8b9b0..9d68fa2 100644
--- a/extensions/libxt_LED.c
+++ b/extensions/libxt_LED.c
@@ -9,23 +9,30 @@
  * published by the Free Software Foundation.
  *
  */
-#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
-#include <getopt.h>
-#include <stddef.h>
-
 #include <xtables.h>
-
 #include <linux/netfilter/xt_LED.h>
 
-static const struct option LED_opts[] = {
-	{.name = "led-trigger-id",   .has_arg = true,  .val = 'i'},
-	{.name = "led-delay",        .has_arg = true,  .val = 'd'},
-	{.name = "led-always-blink", .has_arg = false, .val = 'a'},
-	XT_GETOPT_TABLEEND,
+enum {
+	O_LED_TRIGGER_ID = 0,
+	O_LED_DELAY,
+	O_LED_ALWAYS_BLINK,
+};
+
+#define s struct xt_led_info
+static const struct xt_option_entry LED_opts[] = {
+	{.name = "led-trigger-id", .id = O_LED_TRIGGER_ID,
+	 .flags = XTOPT_MAND, .type = XTTYPE_STRING, .min = 0,
+	 .max = sizeof(((struct xt_led_info *)NULL)->id) -
+	        sizeof("netfilter-")},
+	{.name = "led-delay", .id = O_LED_DELAY, .type = XTTYPE_STRING},
+	{.name = "led-always-blink", .id = O_LED_ALWAYS_BLINK,
+	 .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void LED_help(void)
 {
@@ -39,50 +46,26 @@ static void LED_help(void)
 	);
 }
 
-static int LED_parse(int c, char **argv, int invert, unsigned int *flags,
-		     const void *entry, struct xt_entry_target **target)
+static void LED_parse(struct xt_option_call *cb)
 {
-	struct xt_led_info *led = (void *)(*target)->data;
-
-	switch (c) {
-	case 'i':
-		xtables_param_act(XTF_NO_INVERT, "LED",
-			"--led-trigger-id", invert);
-		if (strlen("netfilter-") + strlen(optarg) > sizeof(led->id))
-			xtables_error(PARAMETER_PROBLEM,
-				"--led-trigger-id must be 16 chars or less");
-		if (optarg[0] == '\0')
-			xtables_error(PARAMETER_PROBLEM,
-				"--led-trigger-id cannot be blank");
+	struct xt_led_info *led = cb->data;
 
-		/* "netfilter-" + 16 char id == 26 == sizeof(led->id) */
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LED_TRIGGER_ID:
 		strcpy(led->id, "netfilter-");
-		strcat(led->id, optarg);
-		*flags = 1;
-		return true;
-
-	case 'd':
-		xtables_param_act(XTF_NO_INVERT, "LED", "--led-delay", invert);
-		if (strncasecmp(optarg, "inf", 3) == 0)
+		strcat(led->id, cb->arg);
+		break;
+	case O_LED_DELAY:
+		if (strncasecmp(cb->arg, "inf", 3) == 0)
 			led->delay = -1;
 		else
-			led->delay = strtoul(optarg, NULL, 0);
-
-		return true;
-
-	case 'a':
-		if (!invert)
-			led->always_blink = 1;
-		return true;
+			led->delay = strtoul(cb->arg, NULL, 0);
+		break;
+	case O_LED_ALWAYS_BLINK:
+		led->always_blink = 1;
+		break;
 	}
-	return false;
-}
-
-static void LED_final_check(unsigned int flags)
-{
-	if (flags == 0)
-		xtables_error(PARAMETER_PROBLEM,
-			"--led-trigger-id must be specified");
 }
 
 static void LED_print(const void *ip, const struct xt_entry_target *target,
@@ -142,11 +125,10 @@ static struct xtables_target led_tg_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_led_info)),
 	.userspacesize = offsetof(struct xt_led_info, internal_data),
 	.help          = LED_help,
-	.parse         = LED_parse,
-	.final_check   = LED_final_check,
-	.extra_opts    = LED_opts,
 	.print         = LED_print,
 	.save          = LED_save,
+	.x6_parse      = LED_parse,
+	.x6_options    = LED_opts,
 };
 
 void _init(void)
-- 
1.7.1

