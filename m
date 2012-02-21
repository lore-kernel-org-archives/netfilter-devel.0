From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Tue, 21 Feb 2012 16:20:01 +0100
Message-ID: <20120221152001.GA25993@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2BUPUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:20:05 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 21, 2012 at 04:06:59PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Tue, 21 Feb 2012, Pablo Neira Ayuso wrote:
> [...]
> > Still one issue, see below.
> > 
> > > @@ -1512,25 +1513,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
> > >  
> > >  	spin_lock_bh(&nf_conntrack_lock);
> > >  	if (cda[CTA_TUPLE_ORIG])
> > > -		h = __nf_conntrack_find(net, zone, &otuple);
> > > +		h = nf_conntrack_find_get(net, zone, &otuple);
> > >  	else if (cda[CTA_TUPLE_REPLY])
> > > -		h = __nf_conntrack_find(net, zone, &rtuple);
> > > +		h = nf_conntrack_find_get(net, zone, &rtuple);
> > > +	spin_unlock_bh(&nf_conntrack_lock);
> > 
> > We still have to keep the lock for the update case. Otherwise we may
> > clash with one update from the kernel.
> 
> By calling nf_conntrack_find_get we are safe to release the lock, because 
> the conntack entry won't be removed behind us. Later in the patch the lock 
> is re-acquired to serialize the updates:
> 
> +               spin_lock_bh(&nf_conntrack_lock);
>                 err = ctnetlink_change_conntrack(ct, cda);
> +               spin_unlock_bh(&nf_conntrack_lock);
> 
> Or do I miss something else here?

Oh, I missed that part of the patch. It's fine.

I'll pass it for mainstream.

Thanks Jozsef!
