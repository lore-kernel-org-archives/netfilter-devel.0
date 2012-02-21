From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Tue, 21 Feb 2012 16:06:59 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:53353 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab2BUPHC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 10:07:02 -0500
In-Reply-To: <20120221145234.GB25826@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tue, 21 Feb 2012, Pablo Neira Ayuso wrote:
[...]
> Still one issue, see below.
> 
> > @@ -1512,25 +1513,22 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
> >  
> >  	spin_lock_bh(&nf_conntrack_lock);
> >  	if (cda[CTA_TUPLE_ORIG])
> > -		h = __nf_conntrack_find(net, zone, &otuple);
> > +		h = nf_conntrack_find_get(net, zone, &otuple);
> >  	else if (cda[CTA_TUPLE_REPLY])
> > -		h = __nf_conntrack_find(net, zone, &rtuple);
> > +		h = nf_conntrack_find_get(net, zone, &rtuple);
> > +	spin_unlock_bh(&nf_conntrack_lock);
> 
> We still have to keep the lock for the update case. Otherwise we may
> clash with one update from the kernel.

By calling nf_conntrack_find_get we are safe to release the lock, because 
the conntack entry won't be removed behind us. Later in the patch the lock 
is re-acquired to serialize the updates:

+               spin_lock_bh(&nf_conntrack_lock);
                err = ctnetlink_change_conntrack(ct, cda);
+               spin_unlock_bh(&nf_conntrack_lock);

Or do I miss something else here?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
