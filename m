From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Thu, 12 Feb 2009 21:51:52 +1000
Message-ID: <49940D58.3040404@shikadi.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, rpurdie@linux.intel.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2569 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbZBLLwB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:52:01 -0500
In-Reply-To: <4993B34C.1020307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kernel module providing implementation of LED netfilter target.  Each
instance of the target appears as a led-trigger device, which can be
associated with one or more LEDs in /sys/class/leds/

Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>

---

Thanks for the feedback Patrick - here is the updated version with
your suggestions:

  - Mutexes removed - I concede that missing a blink here and there
    is acceptable :-)
  - KERN_ERR used for non-critical errors, all KERN_NOTICEs removed
  - Split assignment out from comparison in kzalloc()

Hope this one's okay!


diff -urN linux-2.6.28.3-orig/drivers/leds/Kconfig linux-2.6.28.3/drivers/leds/Kconfig
--- linux-2.6.28.3-orig/drivers/leds/Kconfig	2009-02-03 04:12:10.000000000 +1000
+++ linux-2.6.28.3/drivers/leds/Kconfig	2009-02-08 22:46:06.844626971 +1000
@@ -217,4 +217,7 @@
  	  This allows LEDs to be initialised in the ON state.
  	  If unsure, say Y.

+comment "iptables trigger is under Netfilter config (LED target)"
+    depends on LEDS_TRIGGERS
+
  endif # NEW_LEDS
diff -urN linux-2.6.28.3-orig/include/linux/netfilter/Kbuild linux-2.6.28.3/include/linux/netfilter/Kbuild
--- linux-2.6.28.3-orig/include/linux/netfilter/Kbuild	2009-02-03 04:12:10.000000000 +1000
+++ linux-2.6.28.3/include/linux/netfilter/Kbuild	2009-02-08 22:46:06.911560913 +1000
@@ -7,6 +7,7 @@
  header-y += xt_CONNMARK.h
  header-y += xt_CONNSECMARK.h
  header-y += xt_DSCP.h
+header-y += xt_LED.h
  header-y += xt_MARK.h
  header-y += xt_NFLOG.h
  header-y += xt_NFQUEUE.h
diff -urN linux-2.6.28.3-orig/include/linux/netfilter/xt_LED.h linux-2.6.28.3/include/linux/netfilter/xt_LED.h
--- linux-2.6.28.3-orig/include/linux/netfilter/xt_LED.h	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.28.3/include/linux/netfilter/xt_LED.h	2009-02-12 07:29:19.033631735 +1000
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
diff -urN linux-2.6.28.3-orig/net/netfilter/Kconfig linux-2.6.28.3/net/netfilter/Kconfig
--- linux-2.6.28.3-orig/net/netfilter/Kconfig	2009-02-03 04:12:10.000000000 +1000
+++ linux-2.6.28.3/net/netfilter/Kconfig	2009-02-08 22:46:06.982631079 +1000
@@ -357,6 +357,30 @@

  	  To compile it as a module, choose M here.  If unsure, say N.

+config NETFILTER_XT_TARGET_LED
+    tristate '"LED" target support'
+    depends on LEDS_CLASS
+    depends on NETFILTER_ADVANCED
+    help
+      This option adds a `LED' target, which allows you to blink LEDs in
+      response to particular packets passing through your machine.
+
+      This can be used to turn a spare LED into a network activity LED,
+      which only flashes in response to FTP transfers, for example.  Or
+      you could have an LED which lights up for a minute or two every time
+      somebody connects to your machine via SSH.
+
+      You will need support for the "led" class to make this work.
+
+      To create an LED trigger for incoming SSH traffic:
+        iptables -A INPUT -p tcp --dport 22 -j LED --led-trigger-id ssh --led-delay 1000
+
+      Then attach the new trigger to an LED on your system:
+        echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
+
+      For more information on the LEDs available on your system, see
+      Documentation/leds-class.txt
+
  config NETFILTER_XT_TARGET_MARK
  	tristate '"MARK" target support'
  	default m if NETFILTER_ADVANCED=n
diff -urN linux-2.6.28.3-orig/net/netfilter/Makefile linux-2.6.28.3/net/netfilter/Makefile
--- linux-2.6.28.3-orig/net/netfilter/Makefile	2009-02-03 04:12:10.000000000 +1000
+++ linux-2.6.28.3/net/netfilter/Makefile	2009-02-08 22:46:07.031632072 +1000
@@ -45,6 +45,7 @@
  obj-$(CONFIG_NETFILTER_XT_TARGET_CONNMARK) += xt_CONNMARK.o
  obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
  obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
  obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
  obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
  obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
diff -urN linux-2.6.28.3-orig/net/netfilter/xt_LED.c linux-2.6.28.3/net/netfilter/xt_LED.c
--- linux-2.6.28.3-orig/net/netfilter/xt_LED.c	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.28.3/net/netfilter/xt_LED.c	2009-02-12 21:23:42.081990028 +1000
@@ -0,0 +1,162 @@
+/*
+ * xt_LED.c - netfilter target to make LEDs blink upon packet matches
+ *
+ * Copyright (C) 2008 Adam Nielsen <a.nielsen@shikadi.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301 USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/leds.h>
+#include <linux/mutex.h>
+
+#include <linux/netfilter/xt_LED.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
+MODULE_DESCRIPTION("Xtables: trigger LED devices on packet match");
+
+/*
+ * This is declared in here (the kernel module) only, to avoid having these
+ * dependencies in userspace code.  This is what xt_led_info.internal_data
+ * points to.
+ */
+struct xt_led_info_internal {
+	struct led_trigger netfilter_led_trigger;
+	struct timer_list timer;
+};
+
+static unsigned int
+led_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_led_info *ledinfo = par->targinfo;
+	/*noconst*/struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+
+	/*
+	 * If "always blink" is enabled, and there's still some time until the
+	 * LED will switch off, briefly switch it off now.
+	 */
+	if ((ledinfo->delay > 0) && ledinfo->always_blink
+		&& timer_pending(&ledinternal->timer))
+			led_trigger_event(&ledinternal->netfilter_led_trigger,
+				LED_OFF);
+
+	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+
+	/* If there's a positive delay, start/update the timer */
+	if (ledinfo->delay > 0) {
+		mod_timer(&ledinternal->timer,
+			jiffies + msecs_to_jiffies(ledinfo->delay));
+
+	/* Otherwise if there was no delay given, blink as fast as possible */
+	} else if (ledinfo->delay == 0) {
+		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
+	}
+
+	/* else the delay is negative, which means switch on and stay on */
+
+	return XT_CONTINUE;
+}
+
+static void led_timeout_callback(unsigned long data)
+{
+	struct xt_led_info *ledinfo = (struct xt_led_info *)data;
+	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+
+	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
+}
+
+static bool led_tg_check(const struct xt_tgchk_param *par)
+{
+	/*noconst*/ struct xt_led_info *ledinfo = par->targinfo;
+	struct xt_led_info_internal *ledinternal;
+	int err;
+
+	if (ledinfo->id[0] == '\0') {
+		printk(KERN_ERR KBUILD_MODNAME ": No 'id' parameter given.\n");
+		return false;
+	}
+
+	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
+	if (!ledinternal) {
+		printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
+		return false;
+	}
+
+	ledinternal->netfilter_led_trigger.name = ledinfo->id;
+
+	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
+	if (err) {
+		printk(KERN_CRIT KBUILD_MODNAME
+			": led_trigger_register() failed\n");
+		if (err == -EEXIST)
+			printk(KERN_ERR KBUILD_MODNAME
+				": Trigger name is already in use.\n");
+		goto exit_alloc;
+	}
+
+	/* See if we need to set up a timer */
+	if (ledinfo->delay > 0)
+		setup_timer(&ledinternal->timer, led_timeout_callback,
+			(unsigned long) ledinfo);
+
+	ledinfo->internal_data = ledinternal;
+
+	return true;
+
+exit_alloc:
+	kfree(ledinternal);
+
+	return false;
+}
+
+static void led_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	const struct xt_led_info *ledinfo = par->targinfo;
+	/*noconst*/struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+
+	if (ledinfo->delay > 0)
+		del_timer_sync(&ledinternal->timer);
+
+	led_trigger_unregister(&ledinternal->netfilter_led_trigger);
+	kfree(ledinternal);
+}
+
+static struct xt_target led_tg_reg __read_mostly = {
+	.name		= "LED",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.target		= led_tg,
+	.targetsize	= XT_ALIGN(sizeof(struct xt_led_info)),
+	.checkentry	= led_tg_check,
+	.destroy	= led_tg_destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init led_tg_init(void)
+{
+	return xt_register_target(&led_tg_reg);
+}
+
+static void __exit led_tg_exit(void)
+{
+	xt_unregister_target(&led_tg_reg);
+}
+
+module_init(led_tg_init);
+module_exit(led_tg_exit);
