From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to
 kernel.
Date: Thu, 19 Sep 2013 20:58:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309192042050.24965@blackhole.kfki.hu>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <4983376.CzhlSNdZFQ@gentoovm> <alpine.DEB.2.00.1309191123460.23327@blackhole.kfki.hu> <2141855.SG6BU49OR8@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:46660 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3ISS6Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:58:25 -0400
In-Reply-To: <2141855.SG6BU49OR8@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Sep 2013, Oliver wrote:

> On Thursday 19 September 2013 11:30:50 Jozsef Kadlecsik wrote:
> > On Thu, 19 Sep 2013, Oliver wrote:
> > > > On Tue, 17 Sep 2013, Oliver wrote:
> > > <snip>
> > > 
> > > > > @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype *h,
> > > > > u8
> > > > > nets_length, size_t dsize)>
> > > > > 
> > > > >  	struct mtype_elem *data;
> > > > >  	u32 i;
> > > > >  	int j;
> > > > > 
> > > > > +#if IPSET_NET_COUNT > 1
> > > > > +	u8 k;
> > > > > +#endif
> > > > 
> > > > Please get rid of all these #if .. [#else ...] #endif constructions,
> > > > except in mtype_test_cidrs. The compiler optimizes away the for loop
> > > > when
> > > > IPSET_NET_COUNT == 1.
> > > 
> > > Yep, there's a couple of other places where I don't currently see a way
> > > around it, but anywhere that it doesn't pose a logical problem to
> > > existing types, I've removed it.
> > 
> > Where do you think it's required, except in mtype_test_cidrs?
> 
> Well actually, I've come to the realisation that it's actually required 
> pretty much everywhere that I placed it because of the simple reason 
> that in the existing hash types, data->cidr is not a u8 array, but it is 
> in hash:net,net obviously.

Yes, you are quite right, I was blind.
 
> So now either we can convert all the existing hash types so that the 
> cidr member of their struct is a single-element array, or we keep the 
> preprocessor conditions, your choice.

I don't really like either of them... What about tweaking the CIDR macro,
into something like this:

#ifdef IP_SET_HASH_WITH_NETS
#if IPSET_NET_COUNT > 1
#define __CIDR(data, i)		((data)->cidr[i])
#else
#define __CIDR(data, i)		((data)->cidr)
#endif
#ifdef IP_SET_HASH_WITH_NETS_PACKED
/* When cidr is packed with nomatch, cidr - 1 is stored in the entry */
#define CIDR(data, i)		(__CIDR(data, i) + 1)
#else
#define CIDR(data, i)		__CIDR(data, i)
#endif
#endif

What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
