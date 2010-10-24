From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 22:44:12 +0200
Message-ID: <20101024204412.GN15247@Chamillionaire.breakpoint.cc>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
 <20101024182508.GM15247@Chamillionaire.breakpoint.cc>
 <1287947511.2658.1678.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, Changli Gao <xiaosuo@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36559 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932872Ab0JXUoN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:44:13 -0400
Content-Disposition: inline
In-Reply-To: <1287947511.2658.1678.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le dimanche 24 octobre 2010 =E0 20:25 +0200, Florian Westphal a =E9cr=
it :
> > I'd imagine that the result of ((hash * total) >> 32) is (almost)
> > always zero, especially if total is small (which it is usually).
> >=20
>=20
> Absolutely not. total is a 32bit number, using full range.
>=20
> > Did you test that this change does not affect distribution average?
>=20
> That would be shocking actually, given we use jhash()
>=20
> I did same tricks in various parts of network stack in the past, and =
its
> fine.

Yes, you are right.  I tested this change and it is OK.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
