From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to kernel.
Date: Fri, 20 Sep 2013 09:10:12 +0200
Message-ID: <3633622.RvhfsYxaem@gentoovm>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <2141855.SG6BU49OR8@gentoovm> <alpine.DEB.2.00.1309192042050.24965@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:44770 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3ITHKm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:10:42 -0400
In-Reply-To: <alpine.DEB.2.00.1309192042050.24965@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 19 September 2013 20:58:23 Jozsef Kadlecsik wrote:
> On Thu, 19 Sep 2013, Oliver wrote:
> > On Thursday 19 September 2013 11:30:50 Jozsef Kadlecsik wrote:
> > > On Thu, 19 Sep 2013, Oliver wrote:
> > > > > On Tue, 17 Sep 2013, Oliver wrote:
> > > > <snip>
> > > > 
> > > > > > @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype
> > > > > > *h,
> > > > > > u8
> > > > > > nets_length, size_t dsize)>
> > > > > > 
> > > > > >  	struct mtype_elem *data;
> > > > > >  	u32 i;
> > > > > >  	int j;
> > > > > > 
> > > > > > +#if IPSET_NET_COUNT > 1
> > > > > > +	u8 k;
> > > > > > +#endif
> > > > > 
> > > > > Please get rid of all these #if .. [#else ...] #endif constructions,
> > > > > except in mtype_test_cidrs. The compiler optimizes away the for loop
> > > > > when
> > > > > IPSET_NET_COUNT == 1.
> > > > 
> > > > Yep, there's a couple of other places where I don't currently see a
> > > > way
> > > > around it, but anywhere that it doesn't pose a logical problem to
> > > > existing types, I've removed it.
> > > 
> > > Where do you think it's required, except in mtype_test_cidrs?
> > 
> > Well actually, I've come to the realisation that it's actually required
> > pretty much everywhere that I placed it because of the simple reason
> > that in the existing hash types, data->cidr is not a u8 array, but it is
> > in hash:net,net obviously.
> 
> Yes, you are quite right, I was blind.
> 
> > So now either we can convert all the existing hash types so that the
> > cidr member of their struct is a single-element array, or we keep the
> > preprocessor conditions, your choice.
> 
> I don't really like either of them... What about tweaking the CIDR macro,
> into something like this:
> 
> #ifdef IP_SET_HASH_WITH_NETS
> #if IPSET_NET_COUNT > 1
> #define __CIDR(data, i)		((data)->cidr[i])
> #else
> #define __CIDR(data, i)		((data)->cidr)
> #endif
> #ifdef IP_SET_HASH_WITH_NETS_PACKED
> /* When cidr is packed with nomatch, cidr - 1 is stored in the entry */
> #define CIDR(data, i)		(__CIDR(data, i) + 1)
> #else
> #define CIDR(data, i)		__CIDR(data, i)
> #endif
> #endif
> 
> What do you think?

Yeah, that works for me.

I simplified __CIDR for multiple nets to just the following:

#define __CIDR(cidr, i)         (cidr[i])

So the changes to the rest of the code are pretty minimal :)

I'll patch-bomb the mailing list shortly.

Kind Regards,
Oliver.
