From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v2] Add hash:net,net ipset for storage of v4/v6 CIDR pairs.
Date: Tue, 03 Sep 2013 01:25:01 +0200
Message-ID: <1456379.dYSmDFJkLx@gentoovm>
References: <7121481.vIdJUAPkhx@gentoovm> <1377825634-20308-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309022104310.1199@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:59261 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3IBXZ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 19:25:56 -0400
In-Reply-To: <alpine.DEB.2.00.1309022104310.1199@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 02 September 2013 21:46:06 Jozsef Kadlecsik wrote:
> Hi Oliver,
> 
> On Fri, 30 Aug 2013, Oliver wrote:
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > This adds a new set that provides the ability to configure pairs of
> > subnets.
> > 
> > In order to achieve this, additional handling code has been
> > added to deal with the fact that both parameters accept an arbitrary
> > CIDR range. A preprocessor symbol is used to conditionally enable this
> > extra code.
> 
> The patch is a good step forward, but see my comments.
> 

<snip>

> > +#ifdef IP_SET_HASH_WITH_TWO_NETS
> > +	u8 cidr2;
> > +#endif
> > 
> >  	u32 nets;		/* number of elements per cidr */
> > 
> > +#ifdef IP_SET_HASH_WITH_TWO_NETS
> > +	u32 nets2;		/* number of elements per secondary cidr */
> > +#endif
> > 
> >  };
> 
> The code can further be simplified by introducing the array of cidr and
> nets struct elements and the single a double net types just set the
> array length.

Yes, I like this idea, I will refactor it - I also foresee a comparison saving 
since I can union the types in the netnet code itself.
 
> 
> If the arrays of cidr and nets introduced, then mtype_add_cidr,
> mtype_add_cidr2 and mtype_del_cidr, mtype_del_cidr2 can be unified. That
> way you can get rid of the the functions duplications.

Yep, as above, will simplify and merge this.


> > +static inline void
> > +hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem, struct
> > hash_netnet4_elem *orig) +{
> > +	elem->ip2 = orig->ip2;
> > +}
> 
> Shouldn't elem->cidr2 be reset to the original value too?

No, that's not necessary since cidr2 is never overwritten. The reason this 
function was added is because when we iterate over ip2, it is successively 
ANDed in-place with each CIDR we test, which means that the address bits are  
destroyed. Once we do a new iteration of ip1, we have to first restore ip2, the 
cidr values don't get touched so they're fine.

> > +0 ipset add test 192.168.68.69/27,192.168.129.69/27
> > +# Test first random value
> > +0 ipset test test "2.0.0.255,2.0.1.255"
> 
> Why are the quotation marks required?

They're not, not sure how that snuck in there, although of course, it doesn't 
cause a problem, I'll clean it out.

> 
> Please add tests (for the IPv6 variant too), where the precedence of the
> first network over the second one is demonstrated and verified, i.e. there
> are intersecting networks like "10.0.0.0/16,192.168.0.0/24",
> 10.0.0.0/24,192.168.0.0/16" nomatch", "10.0.0.0/30,192.168.0.0/24" and all
> the different match/non-match cases are checked/tested. In the tests above
> there's no such a case and it's important, for documentation purposes too.
> 
> Otherwise the patch looks just fine.

Excellent, will do, thanks!

Kind Regards,
Oliver.
