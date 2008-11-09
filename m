From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: [PATCH 1/2] New netfilter target to trigger LED devices
Date: Sun, 09 Nov 2008 23:19:43 +1000
Message-ID: <4916E36F.6000502@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Purdie <rpurdie@openedhand.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2656 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbYKINen (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:34:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new "LED" target to iptables, which allows LEDs to blink in
response to matching rules.

Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>

---

Hi all,

This is my first attempt at a proper patch, so please be nice :-)

The patch below (and the kernel module coming shortly) adds support
for a LED target in netfilter.  This allows netfilter to blink LEDs
on your system in response to certain packets passing through the
machine.  For example, you could have an LED flashing to indicate
how much HTTP traffic is coming into a server, or you might have an
LED light up for a few minutes whenever someone connects to your
machine via SSH.

It uses the "led" class of hardware to provide the interface to the
LEDs themselves, so you'll need at least one device that appears in
/sys/class/leds/ to test this (and unfortunately keyboard LEDs don't
appear there...yet.)

The patch here is against iptables git as of a couple of hours ago,
but it only adds two new files so it should apply without problems.

I'll post the kernel module in the next e-mail.

There are however a couple of outstanding issues I'd appreciate some
advice with:

Firstly, I've declared xt_led_info in both the iptables library and the
kernel module.  This probably isn't ideal, but I wanted to avoid having
to create another header file, which presumably needs to be installed on
the user's system before iptables can be compiled.  Please let me know
what the preferred solution to this might be.

Secondly, I'm not sure whether setting xtables_target.family to
PF_UNSPEC is correct.  Given that the process of blinking lights isn't
related to any particular network protocol, I wanted the LED target to
be available in as many cases as possible.  I think PF_UNSPEC does this,
but please advise if there is a more suitable alternative.

I hope these patches are at least suitable for your consideration!

Cheers,
Adam.

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
new file mode 100644
index 0000000..f59c42e
--- /dev/null
+++ b/extensions/libxt_LED.c
@@ -0,0 +1,182 @@
+/*
+ * libxt_LED.c - shared library add-on to iptables to add customized LED
+ *               trigger support.
+ *
+ * (C) 2008 Adam Nielsen <a.nielsen@shikadi.net>
+ *
+ * This allows you to blink LEDs on your system in response to incoming
+ * network packets.
+ *
+ * Create a LED trigger for incoming SSH traffic:
+ *   iptables -A INPUT -p tcp --dport 22 -j LED --led-trigger-id ssh
+ *
+ * Then attach the new trigger to a LED on your system:
+ *   echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
+ *
+ * See /usr/src/linux/Documentation/leds-class.txt for LED details.
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
+
+#include <xtables.h>
+
+struct xt_led_info {
+	char id[26];  /* Unique ID for this trigger in the LED class */
+	int delay;    /* Delay until LED is switched off again after trigger */
+
+	void *internal_data; /* Kernel data used in the module */
+};
+
+static const struct option LED_opts[] = {
+	{ .name = "led-trigger-id", .has_arg = 1, .val = 'i' },
+	{ .name = "led-delay", .has_arg = 1, .val = 'd' },
+	{ .name = NULL }
+};
+
+static void LED_help(void)
+{
+	printf(
+"LED target options:\n"
+"--led-trigger-id name           suffix for led trigger name\n"
+"--led-delay ms                  leave the LED on for this number of\n"
+"                                milliseconds after triggering.  Defaults\n"
+"                                to 0ms (blink as fast as possible.)\n"
+"                                Set to \"inf\" to stay on.  Incoming\n"
+"                                packets while the LED is on will still\n"
+"                                cause it to briefly blink off.\n");
+}
+
+static void LED_init(struct xt_entry_target *t)
+{
+	struct xt_led_info *led = (struct xt_led_info *)t->data;
+
+	/* defaults */
+	led->id[0] = 0;
+	led->delay = 0;
+
+	return;
+}
+
+static int LED_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, struct xt_entry_target **target)
+{
+	struct xt_led_info *led = (struct xt_led_info *)(*target)->data;
+
+	switch (c) {
+	case 'i':
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				"Unexpected `!' after --led-trigger-id");
+
+		if (strlen(optarg) > 15)
+			exit_error(PARAMETER_PROBLEM,
+				"--led-trigger-id must be 16 chars or less");
+
+		if (optarg[0] == 0)
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
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				"Unexpected `!' after --led-delay");
+
+		if (strncasecmp(optarg, "inf", 3) == 0)
+			led->delay = -1;
+		else
+			led->delay = atoi(optarg);
+
+		return 1;
+
+	default:
+		break;
+
+	}
+	return 0;
+}
+
+static void LED_final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "--led-trigger-id must be specified");
+	return;
+}
+
+/* Print our config data, e.g. with iptables -L -v */
+static void LED_print(const void *ip, const struct xt_entry_target *target,
+                      int numeric)
+{
+	const struct xt_led_info *led = (const struct xt_led_info *)target->data;
+	const char *id = led->id + 10; /* trim off "netfilter-" prefix */
+	printf("led-trigger-id:'");
+	/* Some not so great code to escape single quotes in the ID */
+	while (*id) {
+		if (*id == '\'')
+			printf("\\'");
+		else
+			printf("%c", *id);
+		id++;
+	}
+	if (led->delay == -1) printf("' led-delay:inf ");
+	else printf("' led-delay:%dms ", led->delay);
+	return;
+}
+
+static void LED_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_led_info *led = (const struct xt_led_info *)target->data;
+	const char *id = led->id + 10; /* trim off "netfilter-" prefix */
+
+	/* The same not so great code to escape single quotes in the ID */
+	printf("--led-trigger-id '");
+	while (*id) {
+		if (*id == '\'')
+			printf("\\'");
+		else
+			printf("%c", *id);
+		id++;
+	}
+	printf("' ");
+
+	/* Only print the delay if it's not zero (the default) */
+	if (led->delay > 0)
+		printf("--led-delay %d ", led->delay);
+	else if (led->delay == -1)
+		printf("--led-delay inf ");
+
+	return;
+}
+
+static struct xtables_target led_tg_reg = {
+	.family		= PF_UNSPEC,
+	.name		= "LED",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_led_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_led_info)),
+	.help		= LED_help,
+	.init		= LED_init,
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
index 0000000..96dd17c
--- /dev/null
+++ b/extensions/libxt_LED.man
@@ -0,0 +1,19 @@
+This creates an LED-trigger that can then be attached to system indicator
+lights, to blink or illuminate them when certain packets pass through the
+system.  One example might be to light up an LED for a few minutes every time
+an SSH connection is made to the local machine.  The following options control
+the trigger behaviour:
+.TP
+.BI "--led-trigger-id " "name"
+This is the name given to the LED trigger.  The actual name of the trigger
+will have the prefix "netfilter-".
+.TP
+.BI "--led-delay " "ms"
+This indicates how long (in milliseconds) the LED should be left illuminated
+when a packet arrives before being switched off again.  The default is 0
+(blink as fast as possible.)  The special value
+.I inf
+can be given to leave the LED on permanently once activated.  (In this case
+the trigger will need to be manually detached and reattached to the LED device
+to switch it off again.)
+.PP
