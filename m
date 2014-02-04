From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack: don't release a conntrack with
 non-zero refcnt
Date: Tue, 4 Feb 2014 11:21:43 +0100
Message-ID: <20140204102143.GA4711@localhost>
References: <1391465397-3856-1-git-send-email-pablo@netfilter.org>
 <20140203232925.GA3695@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, avagin@parallels.com,
	eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaBDKVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:21:53 -0500
Content-Disposition: inline
In-Reply-To: <20140203232925.GA3695@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 04, 2014 at 12:29:25AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 4d1fb5d..356bef5 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -448,7 +448,9 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
> >  			goto out;
> >  
> >  	add_timer(&ct->timeout);
> > -	nf_conntrack_get(&ct->ct_general);
> > +	smp_wmb();
> > +	/* The caller holds a reference to this object */
> > +	atomic_set(&ct->ct_general.use, 2);
> 
> What happens when the skb is dropped before confirmation?

If you refer to the spot above, conntracks added via ctnetlink are
always confirmed and the refcount will become 1 after insertion into
the hashes. In the packet path, the refcount is 1 for unconfirmed
conntracks, so if you release the skbuff, nf_conntrack_put() is called
and the conntrack is also released (fulfilling that refcount equals 0).

> How is skb_clone etc. solved (it increments refcnt of underlying
> conntrack object?)

I think this works as before, this patch is just delaying the initial
refcount bumping to 1 to make it once the conntrack is inserted in any
of the lists.

Please, let me know if you still see any problematic case. Thanks.
