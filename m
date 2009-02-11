From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: [PATCH 2/2 v4] New netfilter target to trigger LED devices
Date: Thu, 12 Feb 2009 07:45:38 +1000
Message-ID: <49934702.9060909@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rpurdie@linux.intel.com
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2226 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZBKVpr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:45:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kernel module providing implementation of LED netfilter target.  Each
instance of the target appears as a led-trigger device, which can be
associated with one or more LEDs in /sys/class/leds/

Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>

---

Kernel module.  Proper structure packing this time.

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
+++ linux-2.6.28.3/net/netfilter/xt_LED.c	2009-02-08 18:52:01.357351972 +1000
@@ -0,0 +1,199 @@
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
+	struct mutex led_changing_state;
+};
+
+static unsigned int
+led_tg(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_led_info *ledinfo = par->targinfo;
+	/*noconst*/struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+
+	/*
+	 * Make sure the timer callback doesn't go switching the LED off while
+	 * we're figuring out what to do
+	 */
+	if (ledinfo->delay > 0) {
+		mutex_lock(&ledinternal->led_changing_state);
+
+		/*
+		 * If the LED is currently on, it could be some time before it
+		 * switches off again.  Another matching packet has arrived
+		 * though, so if always_blink is on, the code below will
+		 * briefly turn the LED off to signal the new packet.  It will
+		 * be switched on again below, then stay on for the full
+		 * timeout again.
+		 */
+		if (ledinfo->always_blink && timer_pending(&ledinternal->timer))
+			led_trigger_event(&ledinternal->netfilter_led_trigger,
+			                  LED_OFF);
+	}
+
+	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+
+	/* If there's a positive delay, start/update the timer */
+	if (ledinfo->delay > 0) {
+		mod_timer(&ledinternal->timer,
+			jiffies + msecs_to_jiffies(ledinfo->delay));
+		/*
+		 * If there's a *huge* delay right here (enough for the timer
+		 * to expire), it could cause the LED to remain stuck on until
+		 * the next packet, but it's probably not worth worrying
+		 * about...
+		 */
+		mutex_unlock(&ledinternal->led_changing_state);
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
+	/*
+	 * If the timer has expired while we're changing the state, then don't
+	 * interfere.  We also don't want to twiddle with anything after the
+	 * mutex is unlocked, because by then a new timeout will have been
+	 * set.
+	 */
+	if (mutex_is_locked(&ledinternal->led_changing_state))
+		return;
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
+		printk(KERN_CRIT KBUILD_MODNAME ": No 'id' parameter given.\n");
+		return false;
+	}
+
+	if (!(ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL))) {
+		printk(KERN_CRIT KBUILD_MODNAME ": out of memory\n");
+		return false;
+	}
+
+	ledinternal->netfilter_led_trigger.name = ledinfo->id;
+	mutex_init(&ledinternal->led_changing_state);
+
+	printk(KERN_NOTICE KBUILD_MODNAME ": Adding led trigger \"%s\"\n",
+		ledinfo->id);
+
+	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
+	if (err) {
+		printk(KERN_CRIT KBUILD_MODNAME
+			": led_trigger_register() failed\n");
+		if (err == -EEXIST) {
+			printk(KERN_CRIT KBUILD_MODNAME
+				": Trigger name is already in use.\n");
+		}
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
+	printk(KERN_NOTICE KBUILD_MODNAME ": Removing led trigger \"%s\"\n",
+		ledinternal->netfilter_led_trigger.name);
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
+	printk(KERN_NOTICE KBUILD_MODNAME ": Registering LED netfilter target\n");
+	return xt_register_target(&led_tg_reg);
+}
+
+static void __exit led_tg_exit(void)
+{
+	printk(KERN_NOTICE KBUILD_MODNAME ": Unregistering LED netfilter target\n");
+	xt_unregister_target(&led_tg_reg);
+}
+
+module_init(led_tg_init);
+module_exit(led_tg_exit);
