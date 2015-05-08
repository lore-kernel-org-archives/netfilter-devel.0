From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 10/34] netfilter: ipset: Missing rcu protection in
 mtype_list() fixed
Date: Fri, 8 May 2015 21:55:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505082149220.16001@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu> <1430587703-3387-11-git-send-email-kadlec@blackhole.kfki.hu> <20150507181918.GA3654@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:51413 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbbEHTym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2015 15:54:42 -0400
In-Reply-To: <20150507181918.GA3654@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 May 2015, Pablo Neira Ayuso wrote:

> On Sat, May 02, 2015 at 07:27:59PM +0200, Jozsef Kadlecsik wrote:
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  net/netfilter/ipset/ip_set_hash_gen.h | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> > index 91e5327..69f2b25 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -1095,10 +1095,12 @@ mtype_list(const struct ip_set *set,
> >  
> >  	pr_debug("list hash set %s\n", set->name);
> >  	t = (const struct htable *) cb->args[IPSET_CB_PRIVATE];
> > +	/* Expire may replace a hbucket with another one */
> > +	rcu_read_lock();
> 
> You should have rebase the previous patches to fix this from the
> original patchset.

Yes, you are right: there were several fixes integrated into the RCU 
patches, this one was forgotten somehow.

> I don't think it was good idea to keep this large patchset in the
> queue, specially with the RCU patches. They are rather critical, and
> many follow up not so important patches follow up later on.
> 
> I will come back to review the rcu patches, I still have concerns
> there.
> 
> If you're OK, I'll take as much as I can that is independent your RCU
> changes, so you don't need to resend this large patchset, but you will
> need to rebase though.
> 
> Sorry.

OK. Too much patch queued up, that's right.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
