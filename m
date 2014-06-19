From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Subject: [BUG] nf: xt_LED: led-always-blink invisible
Date: Thu, 19 Jun 2014 11:17:49 +0200
Message-ID: <53A2AABD.8000109@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: coreteam@netfilter.org, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from router.aksignal.cz ([188.175.113.102]:53199 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSJ0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:26:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
probably I found bug in kernel 3.14.0 in xt_LED module when set led-always-blink. If it is set, then between switch led 
OFF and ON is almost zero time. So blink is invisible. I did some fix, but I'm not sure if this way would be good. 
Please, help to direct me. This is not final patch so don't punish me for coding style.

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..430584b 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -54,30 +54,32 @@ static unsigned int
  led_tg(struct sk_buff *skb, const struct xt_action_param *par)
  {
  	const struct xt_led_info *ledinfo = par->targinfo;
  	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+        unsigned long t=50;

  	/*
  	 * If "always blink" is enabled, and there's still some time until the
  	 * LED will switch off, briefly switch it off now.
  	 */
  	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
  	    timer_pending(&ledinternal->timer))
-		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
-
-	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+		//led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
+          led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger, &t, &t, 1);
+        else
+                led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);

  	/* If there's a positive delay, start/update the timer */
  	if (ledinfo->delay > 0) {
  		mod_timer(&ledinternal->timer,
  			  jiffies + msecs_to_jiffies(ledinfo->delay));

  	/* Otherwise if there was no delay given, blink as fast as possible */
  	} else if (ledinfo->delay == 0) {
  		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
  	}

  	/* else the delay is negative, which means switch on and stay on */

  	return XT_CONTINUE;
  }

