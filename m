From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: function for getting the source ip defined in the routing table
Date: Wed, 21 May 2014 10:06:43 -0700
Message-ID: <CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
References: <20140520124634.GM10939@kvmbude>
	<alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
	<20140520141828.GO10939@kvmbude>
	<CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
	<20140521083643.GU10939@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:50090 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaEURGn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2014 13:06:43 -0400
Received: by mail-qg0-f54.google.com with SMTP id q108so3691150qgd.13
        for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2014 10:06:43 -0700 (PDT)
In-Reply-To: <20140521083643.GU10939@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That's not the way routing works.
If you don't specify a source ip, the routing table picks for you,
if you do already have a source ip specified the routing table will
use that information to make decisions (ip rule from ...) but will not
change it.

Otherwise TCP wouldn't work.

So this is working as intended.

- Maciej

On Wed, May 21, 2014 at 1:36 AM, Andreas Herz <andi@geekosphere.org> wr=
ote:
> On 20/05/14 at 08:38, Maciej =C5=BBenczykowski wrote:
>> Guessing that after ip_route_output_key(net, &fl4) fl4.saddr will ha=
ve
>> what you want.
>
> Only if the fl4.saddr wasn't set before:
>
> if (!fl4->saddr)
>     fl4->saddr =3D FIB_RES_PREFSRC(net, res);
>
> But i have (or need) a fl4->saddr since i want "ip rules" to be
> inspected as well, and with an ip rule with "from $SRC" i need to cal=
l
> ip_route_output_key(dev_net(dev), &fl4) with an fl4->saddr set or the
> rule won't match correctly.
>
> In the past i could call "ip_route_output_key" and then use "rt->rt_s=
rc"
> to get the source ip i needed.
>
> --
> Andreas Herz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
