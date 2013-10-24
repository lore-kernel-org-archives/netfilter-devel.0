From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] bridge: netfilter: orphan skb before invoking ip
 netfilter hooks
Date: Thu, 24 Oct 2013 23:00:23 +0200
Message-ID: <20131024210023.GA6543@breakpoint.cc>
References: <1382643162-20009-1-git-send-email-fw@strlen.de>
 <1382645650.7572.68.camel@edumazet-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43218 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab3JXVA0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 17:00:26 -0400
Content-Disposition: inline
In-Reply-To: <1382645650.7572.68.camel@edumazet-glaptop.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2013-10-24 at 21:32 +0200, Florian Westphal wrote:
> > Pekka Pietik=E4inen reports xt_socket behavioural change after comm=
it
>=20
> behavioral maybe ? ;)

AE vs. BE i guess.  I grep'd /usr/share/dict/* before, i swear ;)

> > 00028aa37098o (netfilter: xt_socket: use IP early demux).
> >=20
> > Reason is xt_socket now no longer does an unconditional sk lookup -
> > it re-uses existing skb->sk if possible, assuming ->sk was set by
> > tcp early demux.
>=20
> s/tcp/ip/ since it also can work for UDP sockets in net-next

True.  Pablo, could you amend this bit if you decide to apply this
to -next tree (i guess -next is fine)?

Thanks for reviewing this Eric!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
