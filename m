From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Subject: [PATCH] nf: xt_LED: fix too short led-always-blink
Date: Fri, 25 Jul 2014 09:21:01 +0200
Message-ID: <53D2055D.3040200@aksignal.cz>
References: <53A2AABD.8000109@aksignal.cz> <20140630105419.GA7671@localhost> <CAK5ve-Kc_Kv_EnenJSNA9J60QoTtH-zEjPowrOPuUrsWkh3ACQ@mail.gmail.com>
Reply-To: jiri.prchal@aksignal.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net,
	Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
To: Bryan Wu <cooloney@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-leds-owner@vger.kernel.org>
In-Reply-To: <CAK5ve-Kc_Kv_EnenJSNA9J60QoTtH-zEjPowrOPuUrsWkh3ACQ@mail.gmail.com>
Sender: linux-leds-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If led-always-blink is set, then between switch led OFF and ON
is almost zero time. So blink is invisible. This use oneshot led trigger
with fixed time 50ms witch is enough to see blink.

Signed-off-by: Jiri <jiri.prchal@aksignal.cz>
---
  net/netfilter/xt_LED.c | 8 +++++---
  1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 993de2b..29b5af4 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -55,6 +55,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
  {
  	const struct xt_led_info *ledinfo = par->targinfo;
  	struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
+	unsigned long t=50; /* always blink 50ms */

  	/*
  	 * If "always blink" is enabled, and there's still some time until the
@@ -62,9 +63,10 @@ led_tg(struct sk_buff *skb, const struct xt_action_param *par)
  	 */
  	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
  	    timer_pending(&ledinternal->timer))
-		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
-
-	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
+		led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger,
+					  &t, &t, 1);
+        else
+		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);

  	/* If there's a positive delay, start/update the timer */
  	if (ledinfo->delay > 0) {
-- 
1.9.1
