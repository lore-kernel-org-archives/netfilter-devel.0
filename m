From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: [PATCH 1/2 v4] New netfilter target to trigger LED devices
Date: Thu, 12 Feb 2009 07:44:58 +1000
Message-ID: <499346DA.6060807@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rpurdie@linux.intel.com
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1748 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZBKVpH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:45:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new "LED" target to iptables, which allows LEDs to blink in
response to matching rules.

Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>

---

Proper structure packing this time.

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
new file mode 100644
index 0000000..c76a38a
--- /dev/null
+++ b/extensions/libxt_LED.c
@@ -0,0 +1,158 @@
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
+	{ .name = "led-trigger-id",	.has_arg = 1, .val = 'i' },
+	{ .name = "led-delay",		.has_arg = 1, .val = 'd' },
+	{ .name = "led-always-blink",	.has_arg = 0, .val = 'a' },
+	{ .name = NULL }
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
+                     const void *entry, struct xt_entry_target **target)
+{
+	struct xt_led_info *led = (struct xt_led_info *)(*target)->data;
+
+	switch (c) {
+	case 'i':
+		param_act(P_NO_INVERT, "LED", "--led-trigger-id", invert);
+
+		if (strlen("netfilter-") + strlen(optarg) > sizeof(led->id))
+			exit_error(PARAMETER_PROBLEM,
+				"--led-trigger-id must be 16 chars or less");
+
+		if (optarg[0] == '\0')
+			exit_error(PARAMETER_PROBLEM,
+				"--led-trigger-id cannot be blank");
+
+		/* "netfilter-" + 16 char id == 26 == sizeof(led->id) */
+		strcpy(led->id, "netfilter-");
+		strcat(led->id, optarg);
+		*flags = 1;
+		return 1;
+
+	case 'd':
+		param_act(P_NO_INVERT, "LED", "--led-delay", invert);
+
+		if (strncasecmp(optarg, "inf", 3) == 0)
+			led->delay = -1;
+		else
+			led->delay = strtoul(optarg, NULL, 0);
+
+		return 1;
+
+	case 'a':
+		if (!invert)
+			led->always_blink = 1;
+
+		return 1;
+
+	}
+	return 0;
+}
+
+static void LED_final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			"--led-trigger-id must be specified");
+}
+
+static void LED_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
+{
+	const struct xt_led_info *led = (const struct xt_led_info *)target->data;
+	const char *id = led->id + strlen("netfilter-"); /* trim off prefix */
+
+	printf("led-trigger-id:\"");
+	/* Escape double quotes and backslashes in the ID */
+	while (*id) {
+		if ((*id == '"') || (*id == '\\'))
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
+	const struct xt_led_info *led = (const struct xt_led_info *)target->data;
+	const char *id = led->id + strlen("netfilter-"); /* trim off prefix */
+
+	printf("--led-trigger-id \"");
+	/* Escape double quotes and backslashes in the ID */
+	while (*id) {
+		if ((*id == '"') || (*id == '\\'))
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
+	.family		= PF_UNSPEC,
+	.name		= "LED",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_led_info)),
+	.userspacesize	= offsetof(struct xt_led_info, internal_data),
+	.help		= LED_help,
+	.parse		= LED_parse,
+	.final_check	= LED_final_check,
+	.extra_opts	= LED_opts,
+	.print		= LED_print,
+	.save		= LED_save,
+};
+
+void _init(void)
+{
+	xtables_register_target(&led_tg_reg);
+}
diff --git a/extensions/libxt_LED.man b/extensions/libxt_LED.man
new file mode 100644
index 0000000..b65b3c2
--- /dev/null
+++ b/extensions/libxt_LED.man
@@ -0,0 +1,30 @@
+This creates an LED-trigger that can then be attached to system indicator
+lights, to blink or illuminate them when certain packets pass through the
+system.  One example might be to light up an LED for a few minutes every time
+an SSH connection is made to the local machine.  The following options control
+the trigger behaviour:
+.TP
+\fB--led-trigger-id\fP \fIname\fP
+This is the name given to the LED trigger.  The actual name of the trigger
+will be prefixed with "netfilter-".
+.TP
+\fB--led-delay\fP \fIms\fP
+This indicates how long (in milliseconds) the LED should be left illuminated
+when a packet arrives before being switched off again.  The default is 0
+(blink as fast as possible.)  The special value \fIinf\fP can be given to
+leave the LED on permanently once activated.  (In this case the trigger will
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
+echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
diff --git a/include/linux/netfilter/xt_LED.h b/include/linux/netfilter/xt_LED.h
new file mode 100644
index 0000000..4c91a0d
--- /dev/null
+++ b/include/linux/netfilter/xt_LED.h
@@ -0,0 +1,13 @@
+#ifndef _XT_LED_H
+#define _XT_LED_H
+
+struct xt_led_info {
+	char id[27];        /* Unique ID for this trigger in the LED class */
+	__u8 always_blink;  /* Blink even if the LED is already on */
+	__u32 delay;        /* Delay until LED is switched off after trigger */
+
+	/* Kernel data used in the module */
+	void *internal_data __attribute__((aligned(8)));
+};
+
+#endif /* _XT_LED_H */
