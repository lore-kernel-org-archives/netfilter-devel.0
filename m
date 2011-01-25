From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 03/13] bitmap:ip set type support
Date: Tue, 25 Jan 2011 22:34:28 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101252229250.19648@blackhole.kfki.hu>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu>
 <4D3EE6B6.8090008@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53209 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1AYVea (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:34:30 -0500
In-Reply-To: <4D3EE6B6.8090008@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 25 Jan 2011, Patrick McHardy wrote:

> On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> > diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> > new file mode 100644
> > index 0000000..4fbb360
> > --- /dev/null
> > +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> 
> > +static const struct nla_policy bitmap_ip_adt_policy[IPSET_ATTR_ADT_MAX+1] = {
> > +	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
> > +	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
> > +	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
> > +	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
> > +	[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
> > +};
> > +
> > +static int
> > +bitmap_ip_uadt(struct ip_set *set, struct nlattr *head, int len,
> > +	       enum ipset_adt adt, u32 *lineno, u32 flags)
> > +{
> > +	struct bitmap_ip *map = set->data;
> > +	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
> > +	u32 ip, ip_to, id;
> > +	int ret = 0;
> > +
> > +	if (nla_parse(tb, IPSET_ATTR_ADT_MAX, head, len,
> > +		      bitmap_ip_adt_policy))
> 
> You can simply pass the container attribute instead of the
> contents and length from ip_set_core.c and use nla_parse_nested().
> 
> This could even be done centrally in ip_set_core.c and you
> just hand a set of parsed and validated attributes to this
> function. Basically what you would do is:
> 
> - add nla_policy member to the ip_set_type_variant structure
> - add type/variant specific max_attribute member to the
>   ip_set_type_variant structure
> 
> initialize both appropriately for each set type variant.
> 
> In ip_set_core.c, do:
> 
> 	struct nlattr *nla[set->variant->maxattr + 1];
> 
> 	err = nla_parse_nested(nla, set->variant->maxattr,
> 			       attr[IPSET_ATTR_DATA],
> 			       set->variant->policy);
> 	if (err < 0)
> 		return err;
> 
> 	set->variant->uadt(..., nla, ...)
> 
> That way you avoid duplicating the parsing in every set type.

Nice, I'll do this.
 
> > +			} else
> > +				goto nla_put_failure;
> > +		}
> > +		NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP,
> > +				htonl(map->first_ip + id * map->hosts));
> > +		ipset_nest_end(skb, nested);
> > +	}
> > +	ipset_nest_end(skb, atd);
> > +	/* Set listing finished */
> > +	cb->args[2] = 0;
> > +	return 0;
> > +
> > +nla_put_failure:
> > +	nla_nest_cancel(skb, nested);
> > +	ipset_nest_end(skb, atd);
> > +	return 0;
> 
> Doesn't this need to return an errno value to indicate that the
> dump is incomplete?

Yes, better report the incompete dumping.
 
> > +/* Timeout variant */
> > +
> > +struct bitmap_ip_timeout {
> > +	unsigned long *members;	/* the set members */
> > +	u32 first_ip;		/* host byte order, included in range */
> > +	u32 last_ip;		/* host byte order, included in range */
> > +	u32 elements;		/* number of max elements in the set */
> > +	u32 hosts;		/* number of hosts in a subnet */
> > +	size_t memsize;		/* members size */
> > +	u8 netmask;		/* subnet netmask */
> > +
> > +	u32 timeout;		/* timeout parameter */
> > +	struct timer_list gc;	/* garbage collection */
> 
> There's a lot of duplicated code just because the structures are
> different. It seems this could be avoided if the common members
> were in a common structure and just the timeout and timer_list
> members were specific to the timeout variant.

At least the userspace parsing can be unified, as it's done for the 
bitmap:ip,mac type. I'll do similarly here.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
