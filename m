From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_queue: fix NF_STOLEN skb leak redux
Date: Fri, 12 Aug 2011 10:19:09 +0200
Message-ID: <20110812081909.GC28510@Chamillionaire.breakpoint.cc>
References: <1313095621-2015-1-git-send-email-fw@strlen.de>
 <CAHXqBFJ=Z=uhgyxUYJ=j1xp6NvhkY6wUYxjNCx6YTTnr_gDsbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Julian Anastasov <ja@ssi.bg>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Micha? Miros?aw <mirqus@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36307 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab1HLITK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:19:10 -0400
Content-Disposition: inline
In-Reply-To: <CAHXqBFJ=Z=uhgyxUYJ=j1xp6NvhkY6wUYxjNCx6YTTnr_gDsbg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Micha? Miros?aw <mirqus@gmail.com> wrote:
> 2011/8/11 Florian Westphal <fw@strlen.de>:
> > A userspace listener may send (bogus) NF_STOLEN verdict, which caus=
es
> > skb leak.
> >
> > This problem was previously fixed via
> > 64507fdbc29c3a622180378210ecea8659b14e40 (netfilter:
> > nf_queue: fix NF_STOLEN skb leak) but this had to be reverted
> > because NF_STOLEN can also be returned by a netfilter hook when
> > iterating the rules in nf_reinject.
> >
> > This is complementary to commit fad54440438a7c231a6ae347738423cbabc=
936d9
> > (netfilter: avoid double free in nf_reinject).
> >
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> > =A0One alternative would be to change ip(6)queue and nfqueue
> > =A0to fail with -EINVAL if userspace gives NF_STOLEN verdict.
> > =A0Thoughts?
>=20
> Since userspace is not supposed to pass NF_STOLEN, this would be the
> correct fix.
>=20
> Just a hint, no guarantees attached. ;)

Agreed, it makes more sense to reject it.

I'll wait for a few hours before submitting a patch.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
