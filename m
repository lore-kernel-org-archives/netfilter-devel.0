From: Andreas Herz <andi@geekosphere.org>
Subject: Re: function for getting the source ip defined in the routing table
Date: Thu, 22 May 2014 11:11:29 +0200
Message-ID: <20140522091129.GZ10939@kvmbude>
References: <20140520124634.GM10939@kvmbude>
 <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
 <20140520141828.GO10939@kvmbude>
 <CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
 <20140521083643.GU10939@kvmbude>
 <CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:39409 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaEVJLc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 05:11:32 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-Oozp=_ss7NG=yBQwD2qxjpvKRUwcMa4fJ+gbkMyYuJM6Jw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21/05/14 at 10:06, Maciej =C5=BBenczykowski wrote:
> That's not the way routing works.

Then there is some discrepancy in some special scenarios.

> If you don't specify a source ip, the routing table picks for you,
> if you do already have a source ip specified the routing table will
> use that information to make decisions (ip rule from ...) but will no=
t
> change it.

The old ipt_MASQUERADE used "ip_route_output_key" (until 2.6.10 changed
it) without passing the $SRCIP. But as soon as you have also some "ip
rules" with "from $SRCIP" you have to pass the $SRCIP or the rule won't
match. But in this case the $SRCIP isn't changed although in "ip route"
another $SRCIP is defined.

So i already have a source ip specified and the routing table shall use
that information to make decisions (ip rule from ) but based on that i
_want_ to change it.

> Otherwise TCP wouldn't work.

Well it's SNAT, so changing the SRCIP should be valid.

> So this is working as intended.

Or my scenario is just not on the screen. The module shall do the same
like MASQUERADE but use the information from "ip rule" and "ip route".

1. Look into "ip rule", find a matching rule because of the "from
$SRCIP" and look into the table given via lookup.
2. Then check "ip route" for this table that was called via "ip rule".
3. Use this $SRCIP (and gateway) defined there, so override the $SRCIP.

I will try your hint to use ip_route_output_key twice.

Although i still wonder why my requirement is so special :)

> - Maciej
>=20
> On Wed, May 21, 2014 at 1:36 AM, Andreas Herz <andi@geekosphere.org> =
wrote:
> > On 20/05/14 at 08:38, Maciej =C5=BBenczykowski wrote:
> >> Guessing that after ip_route_output_key(net, &fl4) fl4.saddr will =
have
> >> what you want.
> >
> > Only if the fl4.saddr wasn't set before:
> >
> > if (!fl4->saddr)
> >     fl4->saddr =3D FIB_RES_PREFSRC(net, res);
> >
> > But i have (or need) a fl4->saddr since i want "ip rules" to be
> > inspected as well, and with an ip rule with "from $SRC" i need to c=
all
> > ip_route_output_key(dev_net(dev), &fl4) with an fl4->saddr set or t=
he
> > rule won't match correctly.
> >
> > In the past i could call "ip_route_output_key" and then use "rt->rt=
_src"
> > to get the source ip i needed.
> >
> > --
> > Andreas Herz
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Andreas Herz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
