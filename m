From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 12/14] netfilter: ipset: styles warned by checkpatch.pl
 fixed
Date: Wed, 3 Dec 2014 12:25:52 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031225150.21739@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu> <1417373825-3734-13-git-send-email-kadlec@blackhole.kfki.hu> <20141202184343.GE4504@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34927 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaLCLYx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:24:53 -0500
In-Reply-To: <20141202184343.GE4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:

> > @@ -547,7 +547,7 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
> >  
> >  		if (nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
> >  			htonl(active ? ip_set_timeout_get(timeout)
> > -				: *timeout)))
> > +			      : *timeout)))
> 
> This seems to fit here in the 80-chars line, please recheck.

Yes, I'll do.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
