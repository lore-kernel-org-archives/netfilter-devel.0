From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] Add hash:net,net ipset for storage of v4/v6 CIDR pairs.
Date: Fri, 30 Aug 2013 02:56:09 +0200
Message-ID: <7121481.vIdJUAPkhx@gentoovm>
References: <1377231303-6926-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1377231303-6926-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1308252132160.12225@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:45403 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H3A42 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:56:28 -0400
In-Reply-To: <alpine.DEB.2.00.1308252132160.12225@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Thanks for the feedback, a new patch will follow this e-mail.

On Sunday 25 August 2013 22:01:32 you wrote:
> Hi Oliver,
> 
> On Fri, 23 Aug 2013, Oliver wrote:
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
> Please see my comments below and at the end of this mail.
> 
> > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

*snip*

> > -obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o
> > +obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o
> > ip_set_hash_netnet.o> 
> >  obj-m += ip_set_list_set.o
> 
> Start a new line, don't exceed the line limit.

Done.

> 
> Rearrange the structure so that no new hole is created, i.e. put cidr2
> next to cidr;
> 
> I don't really fancy the "DUONETS" naming, call it SECONDARY_NET or
> TWO_NETWORKS.

Agreed, I feel that IP_SET_HASH_WITH_TWO_NETS is better in keeping with the 
style of the existing IP_SET_HASH_WITH_NETS

> > @@ -760,7 +825,11 @@ mtype_test_cidrs(struct ip_set *set, struct
> > mtype_elem *d,> 
> >  	pr_debug("test by nets\n");
> >  	for (; j < nets_length && h->nets[j].nets && !multi; j++) {
> > 
> > +#ifdef IP_SET_HASH_WITH_DUONETS
> > +		mtype_data_netmask(d, h->nets[j].cidr, h->nets[j].cidr2);
> > +#else
> > 
> >  		mtype_data_netmask(d, h->nets[j].cidr);
> > 
> > +#endif
> 
> This looks to incomplete: you have to add a second for loop to test nets2
> too. And that makes the type about twice slower than any other *net* types
> in the worst case.

Yes, you are right, there should be a second for loop, which I have 
implemented. However, due to the way in which data_netmask works, we also have 
to restore ip2 when doing a fresh loop of the first arg (subnet), so I've added 
mtype_data_reset_elem to resolve that.


> > +#define IPSET_TYPE_REV_MIN	0
> > +/*				1    Range as input support for IPv4 added */
> > +/*				2    nomatch flag support added */
> > +#define IPSET_TYPE_REV_MAX	3 /* Counters support added */
> 
> You can start with revision number 0, because there's no previous revision
> for the type.

Yes, I figured this was probably unnecessary but wasn't sure, I've reduced it 
down to just revision 0 now and got rid of the unnecessary compatiblity stuff.

> > +	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] &&
> > tb[IPSET_ATTR_IP2_TO])) { +		printk(KERN_INFO "UADT ipset test");
> 
> The debug printing must of course be removed.

That was definitely uh... unintentional :)

> > +	ip2_to = ip2;
> > +	if (tb[IPSET_ATTR_IP2_TO]) {
> > +		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
> > +		if (ret)
> > +			return ret;
> > +		if (ip2_to < ip2)
> > +			swap(ip2, ip2_to);
> > +		if (ip2 + UINT_MAX == ip2_to)
> > +			return -IPSET_ERR_HASH_RANGE;
> > +
> > +	}
> > +
> > +	if (retried)
> > +		ip = ntohl(h->next.ip);
> 
> The initialization of ip2 is missing above.

It's there, but I actually had to rework this because the range handling 
wasn't quite working properly, it does now.

> 
> The manpage part is missing, where it must be stated that the first
> network part has got a higher precedence than the second when looking for
> the matching networks. Also, new test files must be added to the testsuite
> in which you verify that the different input syntaxes indeed work,
> non-matching elements are not matched, matching elements are matched, and
> so on (check out the existing tests).

I've added the manpage section and tests (also ran them and they all pass for 
me)

As said above, patch will follow.

Kind Regards,
Oliver.
