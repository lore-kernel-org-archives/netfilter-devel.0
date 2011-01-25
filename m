From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 00/13] ipset kernel patches v2
Date: Tue, 25 Jan 2011 22:41:45 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252240330.19648@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <4D3EEE74.2010203@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:37599 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab1AYVlq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:41:46 -0500
In-Reply-To: <4D3EEE74.2010203@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Patrick McHardy wrote:

> On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> > Eric suggested to use vzalloc instead of
> > __vmalloc, however the former hasn't got a gfp_t argument, so I kept __vmalloc.
> 
> > +/* Utility functions */
> > +void *
> > +ip_set_alloc(size_t size, gfp_t gfp_mask)
> > +{
> > +	void *members = NULL;
> > +
> > +	if (size < KMALLOC_MAX_SIZE)
> > +		members = kzalloc(size, gfp_mask | __GFP_NOWARN);
> > +
> > +	if (members) {
> > +		pr_debug("%p: allocated with kmalloc\n", members);
> > +		return members;
> > +	}
> > +
> > +	members = __vmalloc(size, gfp_mask | __GFP_ZERO | __GFP_HIGHMEM,
> > +			    PAGE_KERNEL);
> > +	if (!members)
> > +		return NULL;
> > +	pr_debug("%p: allocated with vmalloc\n", members);
> > +
> > +	return members;
> > +}
> 
> The gfp_t argument seems unnecessary since all users use GFP_KERNEL
> and this is also the only reasonable choice since vmalloc() can't
> be used in atomic context. So the only combination of flags that
> is actually used is __GFP_ZERO | __GFP_HIGHMEM | __GFP_KERNEL,
> which is exactly what vzalloc() uses.

All right, I'll remove the gfp_t argument and use vzalloc().

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
