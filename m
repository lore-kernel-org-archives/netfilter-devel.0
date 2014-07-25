From: Jiri Prchal <jiri.prchal@aksignal.cz>
Subject: [PATCH resend] nf: xt_LED: fix too short led-always-blink
Date: Fri, 25 Jul 2014 15:58:33 +0200
Message-ID: <945bac3162d5842491848f3d3ab43ba4c5fac157.1406291927.git.jiri.prchal@aksignal.cz>
Cc: Jiri <jiri.prchal@aksignal.cz>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net, kaber@trash.net,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, cooloney@gmail.com, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from router.aksignal.cz ([188.175.113.102]:33220 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGYN7J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:59:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jiri <jiri.prchal@aksignal.cz>

If led-always-blink is set, then between switch led OFF and ON
is almost zero time. So blink is invisible. This use oneshot led trigger
with fixed time 50ms witch is enough to see blink.

Signed-off-by: Jiri <jiri.prchal@aksignal.cz>

v2:
defined constant XT_LED_BLINK_DELAY and use it instead of number
Hope this time sould be OK.
---
 net/netfilter/xt_LED.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..9c12f16 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -28,6 +28,8 @@

 #include <linux/netfilter/xt_LED.h>

+#define XT_LED_BLINK_DELAY 50 /* ms */
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Adam Nielsen <a.nielsen@shikadi.net>");
 MODULE_DESCRIPTION("Xtables: trigger LED devices on packet match");
@@ -55,6 +57,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_led_info *ledinfo = par->targinfo;
 	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+	unsigned long led_delay = XT_LED_BLINK_DELAY;

 	/*
 	 * If "always blink" is enabled, and there's still some time until the
@@ -62,9 +65,10 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	 */
 	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
 	    timer_pending(&ledinternal->timer))
-		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
-
-	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+		led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger,
+					  &led_delay, &led_delay, 1);
+	else
+		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);

 	/* If there's a positive delay, start/update the timer */
 	if (ledinfo->delay > 0) {
--
1.9.1

