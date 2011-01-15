From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter: add a typedef for the recurring okfn use
Date: Sat, 15 Jan 2011 16:52:47 +0100
Message-ID: <1295106767.3977.26.camel@edumazet-laptop>
References: <alpine.LNX.2.01.1101142253330.15697@obet.zrqbmnf.qr>
	 <4D31B08A.4020101@netfilter.org>  <4D31B322.2070305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55276 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1AOPwy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:52:54 -0500
Received: by wwi17 with SMTP id 17so701534wwi.1
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2011 07:52:53 -0800 (PST)
In-Reply-To: <4D31B322.2070305@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le samedi 15 janvier 2011 =C3=A0 15:45 +0100, Patrick McHardy a =C3=A9c=
rit :
> Am 15.01.2011 15:34, schrieb Pablo Neira Ayuso:
> > On 14/01/11 22:54, Jan Engelhardt wrote:

> >> =20
> >> +typedef int (*nf_okfn_t)(struct sk_buff *);
> >>  typedef unsigned int nf_hookfn(unsigned int hooknum,
> >>  			       struct sk_buff *skb,
> >>  			       const struct net_device *in,
> >>  			       const struct net_device *out,
> >> -			       int (*okfn)(struct sk_buff *));
> >> +			       nf_okfn_t okfn);
> >=20
> > This typedef makes the source code less readable in my opinion. You=
 have
> > to look for nf_okfn_t to look what it actually is.
>=20
> I agree. This also violates the CodingStyle rules for use of typedefs=
=2E
>=20

I had to add typedefs only because of the __rcu game, in apparent
violation of Linus rule (not adding typedefs), because of sparse or
compiler limitations.

int br_should_route_hook_t(struct sk_buff *skb);=20
br_should_route_hook_t __rcu *br_should_route_hook __read_mostly;

I also prefer to read :

int (*okfn)(struct sk_buff *)=20

instead of=20

nf_okfn_t okfn



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
