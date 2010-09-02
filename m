From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Resolver behind NetFilter NAT service vulnerable to DNS
 poisoning attack
Date: Thu, 02 Sep 2010 16:04:52 +0200
Message-ID: <1283436292.2454.790.camel@edumazet-laptop>
References: <AANLkTikjFnoh_=PX7YDv18O46JhLFnyXQ9-f2CEumqRd@mail.gmail.com>
	 <AANLkTikVRqRjzzoRyDQzA0AiO1_kBNYiTwEZ2cLnsxhe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Amir Herzberg <amir.herzberg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35758 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0IBOE7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:04:59 -0400
Received: by eyb6 with SMTP id 6so256386eyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2010 07:04:58 -0700 (PDT)
In-Reply-To: <AANLkTikVRqRjzzoRyDQzA0AiO1_kBNYiTwEZ2cLnsxhe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 02 septembre 2010 =C3=A0 15:50 +0200, Amir Herzberg a =C3=A9cr=
it :
> We investigate some issues related to DNS poisoning, and specifically=
,
> an attack that poisons DNS cache, similar to Kaminski's attack, but
> that works even if the resolver selects random ports, as long as
> resolver is connected to the Internet via NAT. In particular, we
> tested the attack for the NetFilter NAT.
>=20
> For obvious reasons, I prefer at this point to share details only wit=
h
> developers of NAT devices. If you are such developer, please contact
> me and I can send you the details (paper).
> Feel also welcome to forward the messages to individuals/forums which
> may be relevant (i.e., developers).
>=20
> I apologize for not being able to promise to respond to requests from
> people who are just curious (i.e., not NAT developers). Thanks for
> your understanding.
> --

Strange, this should be supported since 2007 (port randomization for
nat)

commit 41f4689a7c8cd76b77864461b3c58fde8f322b2c
Author: Eric Leblond <eric@inl.fr>
Date:   Wed Feb 7 15:10:09 2007 -0800

    [NETFILTER]: NAT: optional source port randomization support
   =20
    This patch adds support to NAT to randomize source ports.
   =20
    Signed-off-by: Eric Leblond <eric@inl.fr>
    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

If using MASQUERADE, its a very easy setup :

iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE --random



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
