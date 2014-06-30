From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [BUG] nf: xt_LED: led-always-blink invisible
Date: Mon, 30 Jun 2014 12:54:19 +0200
Message-ID: <20140630105419.GA7671@localhost>
References: <53A2AABD.8000109@aksignal.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60134 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbaF3Ky2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:54:28 -0400
Content-Disposition: inline
In-Reply-To: <53A2AABD.8000109@aksignal.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing LED subsystem developers.

On Thu, Jun 19, 2014 at 11:17:49AM +0200, Ji=C5=99=C3=AD Prchal wrote:
> Hi all,
> probably I found bug in kernel 3.14.0 in xt_LED module when set
> led-always-blink. If it is set, then between switch led OFF and ON
> is almost zero time. So blink is invisible. I did some fix, but I'm
> not sure if this way would be good. Please, help to direct me. This
> is not final patch so don't punish me for coding style.

Yes, coding style needs to be fixed.

On top of that, I need a second opinion on this since I'm not familiar
with the led subsystem.

@Richard, Bryan: Would you comment on this, please?

Thanks.

> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 993de2b..430584b 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -54,30 +54,32 @@ static unsigned int
>  led_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct xt_led_info *ledinfo =3D par->targinfo;
>  	struct xt_led_info_internal *ledinternal =3D ledinfo->internal_data=
;
> +        unsigned long t=3D50;
>=20
>  	/*
>  	 * If "always blink" is enabled, and there's still some time until =
the
>  	 * LED will switch off, briefly switch it off now.
>  	 */
>  	if ((ledinfo->delay > 0) && ledinfo->always_blink &&
>  	    timer_pending(&ledinternal->timer))
> -		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
> -
> -	led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FULL);
> +		//led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
> +          led_trigger_blink_oneshot(&ledinternal->netfilter_led_trig=
ger, &t, &t, 1);
> +        else
> +                led_trigger_event(&ledinternal->netfilter_led_trigge=
r, LED_FULL);
>=20
>  	/* If there's a positive delay, start/update the timer */
>  	if (ledinfo->delay > 0) {
>  		mod_timer(&ledinternal->timer,
>  			  jiffies + msecs_to_jiffies(ledinfo->delay));
>=20
>  	/* Otherwise if there was no delay given, blink as fast as possible=
 */
>  	} else if (ledinfo->delay =3D=3D 0) {
>  		led_trigger_event(&ledinternal->netfilter_led_trigger, LED_OFF);
>  	}
>=20
>  	/* else the delay is negative, which means switch on and stay on */
>=20
>  	return XT_CONTINUE;
>  }
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
