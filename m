From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes
 behavioural change in userspace?
Date: Thu, 24 Oct 2013 21:14:41 +0200
Message-ID: <20131024191441.GD993@breakpoint.cc>
References: <52667EBC.5010709@ee.oulu.fi>
 <20131024095212.GA4422@localhost>
 <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>
 <526902D1.50803@ee.oulu.fi>
 <1382616307.7572.56.camel@edumazet-glaptop.roam.corp.google.com>
 <5269121A.3040104@ee.oulu.fi>
 <20131024125135.GA993@breakpoint.cc>
 <52691D4F.4080903@ee.oulu.fi>
 <20131024132936.GC993@breakpoint.cc>
 <52695011.2060902@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com,
	netfilter-devel@vger.kernel.org
To: Pekka =?iso-8859-15?Q?Pietik=E4inen?= <pp@ee.oulu.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42980 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207Ab3JXTOr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:47 -0400
Content-Disposition: inline
In-Reply-To: <52695011.2060902@ee.oulu.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pekka Pietik=E4inen <pp@ee.oulu.fi> wrote:
> On 24/10/13 16:29, Florian Westphal wrote:

[ restored nf-devel cc ]

> >I don't understand. The packet seen by xt_socket is arriving from
> >a remote machine, right?
> Virtual machine that's on virbr0 yep, and packet that used to match
> should be a synack to a connection initiated from the host.

Ah.  Now the picture is clear.  Underlying tun device in bridge,
which uses a socket internally (this is why skb->sk->sk_state is
TCP_CLOSE).

> bridge-nf-call-iptables =3D 0 and your patch + bridge-nf-call-iptable
> =3D 1 both made my test work with unmodified xt_socket (and adding
> debug prints shows sk_state is now sane)
>=20
> Oh. Adding some more debug prints it's the
> "inet_sk(sk)->inet_rcv_saddr =3D=3D 0" part that triggered.
>=20
> Before 3.11 sk=3Dnf_tproxy_get_sock_v4() was always done, so I suppos=
e
> it was always working on sane data.

Yep.  When called from bridge netfilter the skb is not orphaned
properly, so the tun sk is still around by the time xt_socket is
consulted.

Thanks for reporting!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
