From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 01/12] IP set core support
Date: Wed, 19 Jan 2011 22:55:29 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101192254460.31954@blackhole.kfki.hu>
References: yes <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu>  <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu> <1295454292.3273.21.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:47224 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab1ASVza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:55:30 -0500
In-Reply-To: <1295454292.3273.21.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 19 Jan 2011, Eric Dumazet wrote:

> Le samedi 15 janvier 2011 ? 00:23 +0100, Jozsef Kadlecsik a ?crit :
> 
> > +/* Allocate members */
> > +static inline void *
> > +ip_set_alloc(size_t size, gfp_t gfp_mask)
> > +{
> > +	void *members = NULL;
> > +
> > +	if (size < KMALLOC_MAX_SIZE)
> > +		members = kzalloc(size, gfp_mask | __GFP_NOWARN);
> > +
> > +	if (members) {
> > +		pr_debug("%p: allocated with kmalloc", members);
> > +		return members;
> > +	}
> > +
> > +	members = __vmalloc(size, gfp_mask | __GFP_ZERO, PAGE_KERNEL);
> > +	if (!members)
> > +		return NULL;
> > +	pr_debug("%p: allocated with vmalloc", members);
> > +
> > +	return members;
> > +}
> > +
> 
> Note : We now have vzalloc(), no need to use __vmalloc() (BTW
> __GFP_HIGHMEM is missing)

Thanks Eric, I'll use vzalloc and add the missing flag.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
