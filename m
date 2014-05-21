From: Andreas Herz <andi@geekosphere.org>
Subject: Re: function for getting the source ip defined in the routing table
Date: Wed, 21 May 2014 10:36:43 +0200
Message-ID: <20140521083643.GU10939@kvmbude>
References: <20140520124634.GM10939@kvmbude>
 <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
 <20140520141828.GO10939@kvmbude>
 <CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:36120 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaEUIgr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2014 04:36:47 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OozhUDnEJX3AZFTdWAx+trKhT9m=hKjj0Kr32aZm+Q_u=g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/05/14 at 08:38, Maciej =C5=BBenczykowski wrote:
> Guessing that after ip_route_output_key(net, &fl4) fl4.saddr will hav=
e
> what you want.

Only if the fl4.saddr wasn't set before:

if (!fl4->saddr)
    fl4->saddr =3D FIB_RES_PREFSRC(net, res);

But i have (or need) a fl4->saddr since i want "ip rules" to be
inspected as well, and with an ip rule with "from $SRC" i need to call
ip_route_output_key(dev_net(dev), &fl4) with an fl4->saddr set or the
rule won't match correctly.

In the past i could call "ip_route_output_key" and then use "rt->rt_src=
"
to get the source ip i needed.

--=20
Andreas Herz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
