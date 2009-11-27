From: Patrick McHardy <kaber@trash.net>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Fri, 27 Nov 2009 12:47:43 +0100
Message-ID: <4B0FBC5F.8030108@trash.net>
References: <4B0FA3AA.4070702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44136 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZK0Lri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:47:38 -0500
In-Reply-To: <4B0FA3AA.4070702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> It is not easy to spoof in both directions. Routers won't forward it =
if the destination is at the same side.

Please don't top post.

They don't need to forward anything, conntrack handles the packet befor=
e
routing.

> Patrick McHardy <kaber@trash.net>=E5=86=99=E9=81=93=EF=BC=9A
>=20
>> Changli Gao wrote:
>>> On Fri, Nov 27, 2009 at 5:42 PM, Jozsef Kadlecsik
>>> <kadlec@blackhole.kfki.hu> wrote:
>>>> On Fri, 27 Nov 2009, Changli Gao wrote:
>>>>
>>>>> Yes, as nf_conntrack_tcp_timeout_loose_unreply implied, it is for
>>>>> picked up connections.
>>>> Connection pickup can be disabled by proper rules or by setting
>>>> nf_ct_tcp_loose to zero. So in which environment this third method=
 is
>>>> required? I'm curious what triggered you to write your patch.
>>>>
>>> In some condition, you can't disable it. It's why we export
>>> nf_ct_tcp_loose. As a bridge, if its booting breaks connections, us=
ers
>>> won't happy, so we must allow loose mode.
>> That won't help much. If you're able to spoof packets, you might
>> as well spoof packets for both direction so SEEN_REPLY is set.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
