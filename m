From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] Inter-match communication cache
Date: Mon, 24 Sep 2012 12:25:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209241223170.21788@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu> <20120924095707.GA19084@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39435 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab2IXKZK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:25:10 -0400
In-Reply-To: <20120924095707.GA19084@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 24 Sep 2012, Pablo Neira Ayuso wrote:

> On Tue, Sep 18, 2012 at 11:01:34PM +0200, Jozsef Kadlecsik wrote:
> > 
> > I propose a small cache for inter-match communication purpose:
> > 
> > diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> > index 8d674a7..f07eab2 100644
> > --- a/include/linux/netfilter/x_tables.h
> > +++ b/include/linux/netfilter/x_tables.h
> > @@ -216,6 +216,9 @@ struct xt_action_param {
> >  		const void *matchinfo, *targinfo;
> >  	};
> >  	const struct net_device *in, *out;
> > +#ifdef CONFIG_NETFILTER_XTABLES_CACHE
> > +	u_int32_t cache;
> > +#endif
> 
> I think you can implement this by means of one per-CPU cache inside
> the xt_set match.
> 
> Check the old per-CPU event cache in net/netfilter/nf_conntrack_ecache.c.
> We used to have something similar.

That's a good idea! I'd prefer something encapsulated inside xt_set as 
well, I'm going to check this possibility.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
