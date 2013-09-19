From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to
 kernel.
Date: Thu, 19 Sep 2013 11:30:50 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309191123460.23327@blackhole.kfki.hu>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379420818-22541-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309181913300.21599@blackhole.kfki.hu> <4983376.CzhlSNdZFQ@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:54044 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3ISJaw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:30:52 -0400
In-Reply-To: <4983376.CzhlSNdZFQ@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Sep 2013, Oliver wrote:

> > On Tue, 17 Sep 2013, Oliver wrote:
> <snip>
> > > @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype *h, u8
> > > nets_length, size_t dsize)> 
> > >  	struct mtype_elem *data;
> > >  	u32 i;
> > >  	int j;
> > > 
> > > +#if IPSET_NET_COUNT > 1
> > > +	u8 k;
> > > +#endif
> > 
> > Please get rid of all these #if .. [#else ...] #endif constructions,
> > except in mtype_test_cidrs. The compiler optimizes away the for loop when
> > IPSET_NET_COUNT == 1.
> 
> Yep, there's a couple of other places where I don't currently see a way 
> around it, but anywhere that it doesn't pose a logical problem to 
> existing types, I've removed it.

Where do you think it's required, except in mtype_test_cidrs?
 
> > > +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> > > +		return -IPSET_ERR_PROTOCOL;
> > > +	if (unlikely(tb[IPSET_ATTR_IP_TO]))
> > > +		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
> > 
> > Check tb[IPSET_ATTR_IP2_TO] in the condition above too.
> 
> This is IPv6, I thought ranges weren't even legitimate here, also, if 
> this is wrong, hash:net must be too... Or does IP2_TO not mean what I 
> think it means?

IPSET_ATTR_IP2_TO carries the endpoint of the range of the second IP type 
of element and ranges are not allowed in either IP type of element part 
for IPv6. It is not valid for hash:net at all, but messages for 
hash:net,net types may carry it. ipset itself does not allow the syntax, 
but the library is free to use for anyone and therefore the kernel must 
handle the case.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
