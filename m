From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to kernel.
Date: Thu, 19 Sep 2013 11:13:43 +0200
Message-ID: <4983376.CzhlSNdZFQ@gentoovm>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379420818-22541-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309181913300.21599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:40045 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3ISJOT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:14:19 -0400
In-Reply-To: <alpine.DEB.2.00.1309181913300.21599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 18 September 2013 19:23:00 Jozsef Kadlecsik wrote:
> Hi Oliver,
> 
> Please check your patches with checkpatch.pl and fix all errors, warnings.
> 

Of course, sorry about that.

> On Tue, 17 Sep 2013, Oliver wrote:
<snip>
> > @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype *h, u8
> > nets_length, size_t dsize)> 
> >  	struct mtype_elem *data;
> >  	u32 i;
> >  	int j;
> > 
> > +#if IPSET_NET_COUNT > 1
> > +	u8 k;
> > +#endif
> 
> Please get rid of all these #if .. [#else ...] #endif constructions,
> except in mtype_test_cidrs. The compiler optimizes away the for loop when
> IPSET_NET_COUNT == 1.

Yep, there's a couple of other places where I don't currently see a way around 
it, but anywhere that it doesn't pose a logical problem to existing types, 
I've removed it.

> > +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> > +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> > +		return -IPSET_ERR_PROTOCOL;
> > +	if (unlikely(tb[IPSET_ATTR_IP_TO]))
> > +		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
> 
> Check tb[IPSET_ATTR_IP2_TO] in the condition above too.

This is IPv6, I thought ranges weren't even legitimate here, also, if this is 
wrong, hash:net must be too... Or does IP2_TO not mean what I think it means?

Kind Regards,
Oliver
