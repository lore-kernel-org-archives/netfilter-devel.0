From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] extensions: add the LED target
Date: Sun,  6 Jun 2010 13:23:55 +0200
Message-ID: <1275823437-12089-4-git-send-email-jengelh@medozas.de>
References: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45400 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab0FFLYD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Jun 2010 07:24:03 -0400
In-Reply-To: <1275823437-12089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Adam Nielsen <a.nielsen@shikadi.net>

For the xt_LED target introduced in Linux 2.6.31.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_LED.c   |  155 ++++++++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_LED.man |   30 +++++++++
 2 files changed, 185 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_LED.c
 create mode 100644 extensions/libxt_LED.man

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
new file mode 100644
index 0000000..af0e091
--- /dev/null
+++ b/extensions/libxt_LED.c
@@ -0,0 +1,155 @@
+/*
+ * libxt_LED.c - shared library add-on to iptables to add customized LED
+ *               trigger support.
+ *
+ * (C) 2008 Adam Nielsen <a.nielsen@shikadi.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <stddef.h>
+
+#include <xtables.h>
+
+#include <linux/netfilter/xt_LED.h>
+
+static const struct option LED_opts[] = {
+	{.name = "led-trigger-id",   .has_arg = true,  .val = 'i'},
+	{.name = "led-delay",        .has_arg = true,  .val = 'd'},
+	{.name = "led-always-blink", .has_arg = false, .val = 'a'},
+	{.name = NULL},
+};
+
+static void LED_help(void)
+{
+	printf(
+"LED target options:\n"
+"--led-trigger-id name           suffix for led trigger name\n"
+"--led-delay ms                  leave the LED on for this number of\n"
+"                                milliseconds after triggering.\n"
+"--led-always-blink              blink on arriving packets, even if\n"
+"                                the LED is already on.\n"
+	);
+}
+
+static int LED_parse(int c, char **argv, int invert, unsigned int *flags,
+		     const void *entry, struct xt_entry_target **target)
+{
+	struct xt_led_info *led = (void *)(*target)->data;
+
+	switch (c) {
+	case 'i':
+		xtables_param_act(XTF_NO_INVERT, "LED",
+			"--led-trigger-id", invert);
+		if (strlen("netfilter-") + strlen(optarg) > sizeof(led->id))
+			xtables_error(PARAMETER_PROBLEM,
+				"--led-trigger-id must be 16 chars or less");
+		if (optarg[0] == '\0')
+			xtables_error(PARAMETER_PROBLEM,
+				"--led-trigger-id cannot be blank");
+
+		/* "netfilter-" + 16 char id == 26 == sizeof(led->id) */
+		strcpy(led->id, "netfilter-");
+		strcat(led->id, optarg);
+		*flags = 1;
+		return true;
+
+	case 'd':
+		xtables_param_act(XTF_NO_INVERT, "LED", "--led-delay", invert);
+		if (strncasecmp(optarg, "inf", 3) == 0)
+			led->delay = -1;
+		else
+			led->delay = strtoul(optarg, NULL, 0);
+
+		return true;
+
+	case 'a':
+		if (!invert)
+			led->always_blink = 1;
+		return true;
+	}
+	return false;
+}
+
+static void LED_final_check(unsigned int flags)
+{
+	if (flags == 0)
+		xtables_error(PARAMETER_PROBLEM,
+			"--led-trigger-id must be specified");
+}
+
+static void LED_print(const void *ip, const struct xt_entry_target *target,
+		      int numeric)
+{
+	const struct xt_led_info *led = (void *)target->data;
+	const char *id = led->id + strlen("netfilter-"); /* trim off prefix */
+
+	printf("led-trigger-id:\"");
+	/* Escape double quotes and backslashes in the ID */
+	while (*id != '\0') {
+		if (*id == '"' || *id == '\\')
+			printf("\\");
+		printf("%c", *id++);
+	}
+	printf("\" ");
+
+	if (led->delay == -1)
+		printf("led-delay:inf ");
+	else
+		printf("led-delay:%dms ", led->delay);
+
+	if (led->always_blink)
+		printf("led-always-blink ");
+}
+
+static void LED_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_led_info *led = (void *)target->data;
+	const char *id = led->id + strlen("netfilter-"); /* trim off prefix */
+
+	printf("--led-trigger-id \"");
+	/* Escape double quotes and backslashes in the ID */
+	while (*id != '\0') {
+		if (*id == '"' || *id == '\\')
+			printf("\\");
+		printf("%c", *id++);
+	}
+	printf("\" ");
+
+	/* Only print the delay if it's not zero (the default) */
+	if (led->delay > 0)
+		printf("--led-delay %d ", led->delay);
+	else if (led->delay == -1)
+		printf("--led-delay inf ");
+
+	/* Only print always_blink if it's not set to the default */
+	if (led->always_blink)
+		printf("--led-always-blink ");
+}
+
+static struct xtables_target led_tg_reg = {
+	.version       = XTABLES_VERSION,
+	.name          = "LED",
+	.family        = PF_UNSPEC,
+	.revision      = 0,
+	.size          = XT_ALIGN(sizeof(struct xt_led_info)),
+	.userspacesize = offsetof(struct xt_led_info, internal_data),
+	.help          = LED_help,
+	.parse         = LED_parse,
+	.final_check   = LED_final_check,
+	.extra_opts    = LED_opts,
+	.print         = LED_print,
+	.save          = LED_save,
+};
+
+void _init(void)
+{
+	xtables_register_target(&led_tg_reg);
+}
diff --git a/extensions/libxt_LED.man b/extensions/libxt_LED.man
new file mode 100644
index 0000000..0226f10
--- /dev/null
+++ b/extensions/libxt_LED.man
@@ -0,0 +1,30 @@
+This creates an LED-trigger that can then be attached to system indicator
+lights, to blink or illuminate them when certain packets pass through the
+system. One example might be to light up an LED for a few minutes every time
+an SSH connection is made to the local machine. The following options control
+the trigger behavior:
+.TP
+\fB--led-trigger-id\fP \fIname\fP
+This is the name given to the LED trigger. The actual name of the trigger
+will be prefixed with "netfilter-".
+.TP
+\fB--led-delay\fP \fIms\fP
+This indicates how long (in milliseconds) the LED should be left illuminated
+when a packet arrives before being switched off again. The default is 0
+(blink as fast as possible.) The special value \fIinf\fP can be given to
+leave the LED on permanently once activated. (In this case the trigger will
+need to be manually detached and reattached to the LED device to switch it
+off again.)
+.TP
+\fB--led-always-blink\fP
+Always make the LED blink on packet arrival, even if the LED is already on.
+This allows notification of new packets even with long delay values (which
+otherwise would result in a silent prolonging of the delay time.)
+.TP
+Example:
+.TP
+Create an LED trigger for incoming SSH traffic:
+iptables -A INPUT -p tcp --dport 22 -j LED --led-trigger-id ssh
+.TP
+Then attach the new trigger to an LED:
+echo netfilter-ssh >/sys/class/leds/\fIledname\fP/trigger
-- 
1.7.1

