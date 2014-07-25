From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf: xt_LED: fix too short led-always-blink
Date: Fri, 25 Jul 2014 14:22:12 +0200
Message-ID: <20140725122212.GA5347@salvia>
References: <53A2AABD.8000109@aksignal.cz>
 <20140630105419.GA7671@localhost>
 <CAK5ve-Kc_Kv_EnenJSNA9J60QoTtH-zEjPowrOPuUrsWkh3ACQ@mail.gmail.com>
 <53D2055D.3040200@aksignal.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bryan Wu <cooloney@gmail.com>, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, Richard Purdie <rpurdie@rpsys.net>,
	linux-leds@vger.kernel.org
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51358 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYMWL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:22:11 -0400
Content-Disposition: inline
In-Reply-To: <53D2055D.3040200@aksignal.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jul 25, 2014 at 09:21:01AM +0200, Ji=C5=99=C3=AD Prchal wrote:
> If led-always-blink is set, then between switch led OFF and ON
> is almost zero time. So blink is invisible. This use oneshot led trig=
ger
> with fixed time 50ms witch is enough to see blink.
>=20
> Signed-off-by: Jiri <jiri.prchal@aksignal.cz>
> ---
>  net/netfilter/xt_LED.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 993de2b..29b5af4 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -55,6 +55,7 @@ led_tg(struct sk_buff *skb, const struct xt_action_=
param *par)
>  {
>  	const struct xt_led_info *ledinfo =3D par->targinfo;
>  	struct xt_led_info_internal *ledinternal =3D ledinfo->internal_data=
;
> +	unsigned long t=3D50; /* always blink 50ms */

Please, define:

#define XT_LED_BLINK_DELAY 50 /* ms */

And use it in this way:

        unsigned long led_delay =3D XT_LED_BLINK_DELAY;

so it's consistent with what we have in net/mac80211/led.c

>  	/*
>  	 * If "always blink" is enabled, and there's still some time until =
the
> @@ -62,9 +63,10 @@ led_tg(struct sk_buff *skb, const struct xt_action=
_param *par)
>  	 */
>  	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
>  	    timer_pending(&ledinternal->timer))
> -		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
> -
> -	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
> +		led_trigger_blink_oneshot(&ledinternal->netfilter_led_trigger,
> +					  &t, &t, 1);
> +        else
   ^^^^^^^^

Make sure you use tab identations of 8-chars. I see spaces there :-)

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
