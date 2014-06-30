From: Bryan Wu <cooloney@gmail.com>
Subject: Re: [BUG] nf: xt_LED: led-always-blink invisible
Date: Mon, 30 Jun 2014 16:36:11 -0700
Message-ID: <CAK5ve-Kc_Kv_EnenJSNA9J60QoTtH-zEjPowrOPuUrsWkh3ACQ@mail.gmail.com>
References: <53A2AABD.8000109@aksignal.cz> <20140630105419.GA7671@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net,
	Richard Purdie <rpurdie@rpsys.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:32918 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaF3Xgc convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:36:32 -0400
Received: by mail-lb0-f182.google.com with SMTP id c11so6459688lbj.27
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 16:36:31 -0700 (PDT)
In-Reply-To: <20140630105419.GA7671@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 30, 2014 at 3:54 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> Cc'ing LED subsystem developers.
>
> On Thu, Jun 19, 2014 at 11:17:49AM +0200, Ji=C5=99=C3=AD Prchal wrote=
:
>> Hi all,
>> probably I found bug in kernel 3.14.0 in xt_LED module when set
>> led-always-blink. If it is set, then between switch led OFF and ON
>> is almost zero time. So blink is invisible. I did some fix, but I'm
>> not sure if this way would be good. Please, help to direct me. This
>> is not final patch so don't punish me for coding style.
>
> Yes, coding style needs to be fixed.
>
> On top of that, I need a second opinion on this since I'm not familia=
r
> with the led subsystem.
>
> @Richard, Bryan: Would you comment on this, please?
>
> Thanks.
>
>> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
>> index 993de2b..430584b 100644
>> --- a/net/netfilter/xt_LED.c
>> +++ b/net/netfilter/xt_LED.c
>> @@ -54,30 +54,32 @@ static unsigned int
>>  led_tg(struct sk_buff *skb, const struct xt_action_param *par)
>>  {
>>       const struct xt_led_info *ledinfo =3D par->targinfo;
>>       struct xt_led_info_internal *ledinternal =3D ledinfo->internal=
_data;
>> +        unsigned long t=3D50;
>>
>>       /*
>>        * If "always blink" is enabled, and there's still some time u=
ntil the
>>        * LED will switch off, briefly switch it off now.
>>        */
>>       if ((ledinfo->delay > 0) && ledinfo->always_blink &&
>>           timer_pending(&ledinternal->timer))
>> -             led_trigger_event(&ledinternal->netfilter_led_trigger,=
 LED_OFF);
>> -
>> -     led_trigger_event(&ledinternal->netfilter_led_trigger, LED_FUL=
L);
>> +             //led_trigger_event(&ledinternal->netfilter_led_trigge=
r, LED_OFF);
>> +          led_trigger_blink_oneshot(&ledinternal->netfilter_led_tri=
gger, &t, &t, 1);

=46or this kind of package activity trigger. led_trigger_blink_oneshot(=
)
is the right API to use.
And what's always_blink for? I think for each package event we detects
here we blink once LED.

Thanks,
-Bryan

>> +        else
>> +                led_trigger_event(&ledinternal->netfilter_led_trigg=
er, LED_FULL);
>>
>>       /* If there's a positive delay, start/update the timer */
>>       if (ledinfo->delay > 0) {
>>               mod_timer(&ledinternal->timer,
>>                         jiffies + msecs_to_jiffies(ledinfo->delay));
>>
>>       /* Otherwise if there was no delay given, blink as fast as pos=
sible */
>>       } else if (ledinfo->delay =3D=3D 0) {
>>               led_trigger_event(&ledinternal->netfilter_led_trigger,=
 LED_OFF);
>>       }
>>
>>       /* else the delay is negative, which means switch on and stay =
on */
>>
>>       return XT_CONTINUE;
>>  }
>>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
