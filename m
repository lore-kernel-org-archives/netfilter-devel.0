From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to kernel.
Date: Thu, 19 Sep 2013 17:00:46 +0200
Message-ID: <2141855.SG6BU49OR8@gentoovm>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <4983376.CzhlSNdZFQ@gentoovm> <alpine.DEB.2.00.1309191123460.23327@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:41213 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3ISPA4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:00:56 -0400
In-Reply-To: <alpine.DEB.2.00.1309191123460.23327@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 19 September 2013 11:30:50 Jozsef Kadlecsik wrote:
> On Thu, 19 Sep 2013, Oliver wrote:
> > > On Tue, 17 Sep 2013, Oliver wrote:
> > <snip>
> > 
> > > > @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype *h,
> > > > u8
> > > > nets_length, size_t dsize)>
> > > > 
> > > >  	struct mtype_elem *data;
> > > >  	u32 i;
> > > >  	int j;
> > > > 
> > > > +#if IPSET_NET_COUNT > 1
> > > > +	u8 k;
> > > > +#endif
> > > 
> > > Please get rid of all these #if .. [#else ...] #endif constructions,
> > > except in mtype_test_cidrs. The compiler optimizes away the for loop
> > > when
> > > IPSET_NET_COUNT == 1.
> > 
> > Yep, there's a couple of other places where I don't currently see a way
> > around it, but anywhere that it doesn't pose a logical problem to
> > existing types, I've removed it.
> 
> Where do you think it's required, except in mtype_test_cidrs?

Well actually, I've come to the realisation that it's actually required pretty 
much everywhere that I placed it because of the simple reason that in the 
existing hash types, data->cidr is not a u8 array, but it is in hash:net,net 
obviously.

So now either we can convert all the existing hash types so that the cidr 
member of their struct is a single-element array, or we keep the preprocessor 
conditions, your choice.

> 
> > > > +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> > > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> > > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> > > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> > > > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> > > > +		return -IPSET_ERR_PROTOCOL;
> > > > +	if (unlikely(tb[IPSET_ATTR_IP_TO]))
> > > > +		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
> > > 
> > > Check tb[IPSET_ATTR_IP2_TO] in the condition above too.
> > 
> > This is IPv6, I thought ranges weren't even legitimate here, also, if
> > this is wrong, hash:net must be too... Or does IP2_TO not mean what I
> > think it means?
> 
> IPSET_ATTR_IP2_TO carries the endpoint of the range of the second IP type
> of element and ranges are not allowed in either IP type of element part
> for IPv6. It is not valid for hash:net at all, but messages for
> hash:net,net types may carry it. ipset itself does not allow the syntax,
> but the library is free to use for anyone and therefore the kernel must
> handle the case.

OK, I see what you mean now, for some reason I didn't see the IPSET_ATTR_IP_TO 
check, obviously TO2 is needed, I will fix that before sending v2.

Thanks,
Oliver.
