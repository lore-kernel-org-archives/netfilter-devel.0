From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Tue, 4 Feb 2014 13:46:37 +0100
Message-ID: <20140204124637.GA9881@breakpoint.cc>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
 <20140203232925.GA3695@breakpoint.cc>
 <20140204102143.GA4711@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	avagin@parallels.com, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35373 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbaBDMqj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:46:39 -0500
Content-Disposition: inline
In-Reply-To: <20140204102143.GA4711@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Feb 04, 2014 at 12:29:25AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > > index 4d1fb5d..356bef5 100644
> > > --- a/net/netfilter/nf_conntrack_core.c
> > > +++ b/net/netfilter/nf_conntrack_core.c
> > > @@ -448,7 +448,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
> > >  			goto out;
> > >  
> > >  	add_timer(&ct->timeout);
> > > -	nf_conntrack_get(&ct->ct_general);
> > > +	smp_wmb();
> > > +	/* The caller holds a reference to this object */
> > > +	atomic_set(&ct->ct_general.use, 2);
> > 
> > What happens when the skb is dropped before confirmation?
> 
> If you refer to the spot above, conntracks added via ctnetlink are
> always confirmed and the refcount will become 1 after insertion into
> the hashes. In the packet path, the refcount is 1 for unconfirmed
> conntracks,

Right, sorry.  I missed this.  You only want to delay the init-to-1
until the conntrack is inserted into the unconfirmed list.

However, I think there is still a problem with the atomic_set to 2
above.

What about e.g.
Prerouting -> set refcnt to 1
(clone)
(clone)
(refcnt is 3)
forward/postrouting -> confirmation (refcnt reset to two)

I think this could happen at least with netfilter on-top-of bridge
when dealing with e.g. udp mcast. (i am looking at br_forward and
deliver_clone in particular).

I think you could just leave hash_check_insert() alone?
