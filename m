From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Fri, 25 Nov 2005 00:33:27 +0100
Message-ID: <43864DC7.6060109@trash.net>
References: <4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net> <43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net> <43843ACE.4050808@trash.net>
	<Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>
	<20051124200736.GW31478@sunbeam.de.gnumonks.org>
	<20051124202125.GX31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051124202125.GX31478@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> Sorry, forget that other patch.
> 
> The only way how we can thoroughly solve (and avoid) this problem, also
> for future cases, is to behave like 'real' TLV parsers (e.g. ASN1).
> 
> That is, for any kind of numeric values, we don't make an assumption
> that the attribute has a certain fixed size.  Instead, we derive the
> (u8/u16/u32/u64) size from the length of the attribute, i.e.
> NFA_PAYLOAD() is 1/2/4/8 bytes long.
> 
> This is a quick and dirty patch to demonstrate what I mean:
> 
> =====
> 
> diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
> --- a/net/ipv4/netfilter/ip_conntrack_netlink.c
> +++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
> @@ -502,12 +502,13 @@ ctnetlink_parse_tuple_ip(struct nfattr *
>  }
>  
>  static const size_t cta_min_proto[CTA_PROTO_MAX] = {
> -	[CTA_PROTO_NUM-1]	= sizeof(u_int16_t),
> +	[CTA_PROTO_NUM-1]	= sizeof(u_int8_t),
>  	[CTA_PROTO_SRC_PORT-1]	= sizeof(u_int16_t),
>  	[CTA_PROTO_DST_PORT-1]	= sizeof(u_int16_t),
>  	[CTA_PROTO_ICMP_TYPE-1]	= sizeof(u_int8_t),
>  	[CTA_PROTO_ICMP_CODE-1]	= sizeof(u_int8_t),
>  	[CTA_PROTO_ICMP_ID-1]	= sizeof(u_int16_t),
> +	[CTA_PROTO-1]		= sizeof(u_int8_t),
>  };
>  
>  static inline int
> @@ -527,7 +528,18 @@ ctnetlink_parse_tuple_proto(struct nfatt
>  
>  	if (!tb[CTA_PROTO_NUM-1])
>  		return -EINVAL;
> -	tuple->dst.protonum = *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +
> +	switch (NFA_PAYLOAD(tb[CTA_PROTO_NUM-1]))
> +	case sizeof(u_int8_t):
> +		tuple->dst.protonum = 
> +				*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +		break;
> +	case sizeof(u_int16_t):
> +		tuple->dst.protonum = 
> +				*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
> +	default:
> +		return -EINVAL;
> +	}
>  
>  	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
> 
> =====
> 
> Obviously, this needs to be moved into a nfnetlink core funciton,
> something like a function nfattr_parse_number() that would then be
> called from all places that parse a number.
> 
> Userspace parsers (libnetfilter_conntrack) would have to introduce the
> same semantics.

That won't work for this case since usually u_int16_t's are encoded
in network byte order but in this case its always host byte order.

> It might be a bit too much overhead, I'm not really decided yet.  But in
> the end, if everybody plays according to that rule, we don't have any
> such issues in the future.
> 
> Comments?

I think just the first patch is fine. I really hope we don't find
more of these.
