From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 2/4] ipset: add "inner" flag implementation
Date: Fri, 07 Jun 2013 02:13:42 +0100
Message-ID: <51B133C5.5020303@googlemail.com>
References: <51A54267.8050402-git-send-email-mr.dash.four@googlemail.com> <51A5482C.9020603@googlemail.com> <alpine.DEB.2.00.1306011129590.30306@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:44146 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3FGBNw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:13:52 -0400
Received: by mail-we0-f177.google.com with SMTP id m19so2508582wev.8
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 18:13:50 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1306011129590.30306@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Jozsef Kadlecsik wrote:
> There are a few problems with your patch: some things are duplicated, 
> already existing function is reimplemented.
Agreed. That will be addressed in the next version of patches.

>  There is no error path when 
> the inner IPv4/6 header is broken: the returned zero IP address is valid 
> for example in the case of the hash:net,iface type.
I was unaware of that. If that is indeed the case, then yes, error code 
handling must be implemented in a different way.

>  Also, I'd prefer a 
> single new function (or two inline functions if their size permits), 
> which'd return the success code and in pointers the inner IP header and
> the offset to the header (for proto/ports). Read my comments below.
>   
It has to be 2 functions - one dealing with ipv4 headers and another 
implementing ipv6 header handling. Further comments and questions follow 
below.

>> +static inline __be32
>> +ip4inneraddr(const struct sk_buff *skb, bool src)
>> +{
>> +	struct iphdr _iph;
>> +	struct icmphdr _icmph;
>> +	u8 type;
>> +	const struct iphdr *ih;
>> +	const struct icmphdr *ich;
>> +	static const size_t len = 8 + sizeof(struct iphdr);
>> +
>> +	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
>> +	if (ih == NULL || ih->protocol != IPPROTO_ICMP ||
>> +	    ntohs(ih->frag_off) & IP_OFFSET)
>> +		goto err;
>> +
>> +	ich = skb_header_pointer(skb, ih->ihl*4,
>> +				 sizeof(_icmph), &_icmph);
>> +	if (ich == NULL ||
>> +	    (ich->type <= NR_ICMP_TYPES && skb->len - ih->ihl*4 < len))
>> +		goto err;
>> +
>> +	type = ich->type;
>> +	if (type == ICMP_DEST_UNREACH ||
>> +	    type == ICMP_SOURCE_QUENCH ||
>> +	    type == ICMP_TIME_EXCEEDED) {
>> +		ih = skb_header_pointer(skb, ih->ihl*4 + sizeof(_icmph),
>> +					sizeof(_iph), &_iph);
>> +		if (ih == NULL || ntohs(ih->frag_off) & IP_OFFSET)
>> +			goto err;
>> +
>> +		return src ? ih->saddr : ih->daddr;
>> +	}
>> +err:
>> +	return 0;
>> +}
>>     
>
> ip4inneraddr is a duplication of ip4inneraddrptr: if this were the way, 
> then ip4inneraddr should simply wrap and call ip4inneraddrptr.
>   
Indeed, I'll address this in the next version of patches.

>> +static inline void
>> +ip4inneraddrptr(const struct sk_buff *skb, bool src, __be32 *addr)
>> +{
>> +	struct iphdr _iph;
>> +	struct icmphdr _icmph;
>> +	u8 type;
>> +	const struct iphdr *ih;
>> +	const struct icmphdr *ich;
>> +	static const size_t len = 8 + sizeof(struct iphdr);
>>     
>
> I don't like bare numbers as magic constants.
>   
That's the size of a "standard" header (the "magic" number 8 is also 
used in ipv6_skip_exthdr as well). I can use some more meaningful 
constant if you wish - let me know.

>> +#define ip6_ext_hdr(hdr)  ((hdr == IPPROTO_HOPOPTS) || \
>> +			   (hdr == IPPROTO_ROUTING) || \
>> +			   (hdr == IPPROTO_FRAGMENT) || \
>> +			   (hdr == IPPROTO_ESP) || \
>> +			   (hdr == IPPROTO_AH) || \
>> +			   (hdr == IPPROTO_NONE) || \
>> +			   (hdr == IPPROTO_DSTOPTS))
>> +static inline void
>> +ip6inneraddrptr(const struct sk_buff *skb, bool src, struct in6_addr *addr)
>> +{
>> +	u8 type, currenthdr;
>> +	bool fragment = false;
>> +	unsigned int ptr, hdrlen = 0;
>> +	struct ipv6hdr _ip6h;
>> +	struct icmp6hdr _icmp6h;
>> +	const struct ipv6hdr *ih;
>> +	const struct icmp6hdr *ic;
>> +
>> +	ih = skb_header_pointer(skb, 0, sizeof(_ip6h), &_ip6h);
>> +	if (ih == NULL)
>> +		goto err;
>> +
>> +	ptr = sizeof(struct ipv6hdr);
>> +	currenthdr = ih->nexthdr;
>> +	while (currenthdr != NEXTHDR_NONE && ip6_ext_hdr(currenthdr)) {
>> +		struct ipv6_opt_hdr _hdr;
>> +		const struct ipv6_opt_hdr *hp;
>> +
>> +		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
>> +		if (hp == NULL)
>> +			goto err;
>> +
>> +		switch (currenthdr) {
>> +		case IPPROTO_FRAGMENT: {
>> +			struct frag_hdr _fhdr;
>> +			const struct frag_hdr *fh;
>> +
>> +			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
>> +						&_fhdr);
>> +			if (fh == NULL)
>> +				goto err;
>> +			if (ntohs(fh->frag_off) & 0xFFF8)
>> +				fragment = true;
>> +
>> +			hdrlen = 8;
>> +			break;
>> +		}
>> +		case IPPROTO_DSTOPTS:
>> +		case IPPROTO_ROUTING:
>> +		case IPPROTO_HOPOPTS:
>> +			if (fragment)
>> +				goto err;
>> +
>> +			hdrlen = ipv6_optlen(hp);
>> +			break;
>> +		case IPPROTO_AH:
>> +			hdrlen = (hp->hdrlen+2)<<2;
>> +			break;
>> +		case IPPROTO_ESP:
>> +		default:
>> +			goto err;
>> +		} /* switch IPPROTO */
>> +
>> +		currenthdr = hp->nexthdr;
>> +		ptr += hdrlen;
>> +	}
>>     
>
> The code segment above is the reimplementation of ipv6_skip_exthdr.
>   
No, not really. Even though there are similarities between the two 
fucntions, there are 2 differences - one is that ipv6_skip_exthdr wasn't 
dealing properly (from ipset's point of view) with fragments, "frag_off" 
is not present in kernel versions < 3.3 and the other is that 
ipv6_skip_exthdr doesn't return an error when either an unknown or ESP 
header type is encountered ("case IPPROTO_ESP" and "default" above).

That is the reason for implementing a separate function. I see that you 
have amended the ipset code to handle frag_off, but I am not sure that 
would work in the case of kernel versions < 3.3. Again, though, I have 
limited knowledge of IPv6 as we don't use it here, so if you think it is 
better for me to replace the above code and use ipv6_skip_exthdr 
instead, then I'll do it in the next version of patches.

>> +	if (fragment || currenthdr != IPPROTO_ICMPV6)
>> +		goto err;
>> +
>> +	ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
>> +	if (ic == NULL)
>> +		goto err;
>> +
>> +	type = ic->icmp6_type;
>> +	if (type == ICMPV6_DEST_UNREACH ||
>> +	    type == ICMPV6_PKT_TOOBIG ||
>> +	    type == ICMPV6_TIME_EXCEED) {
>> +		ih = skb_header_pointer(skb, ptr + sizeof(_icmp6h),
>> +					sizeof(_ip6h), &_ip6h);
>> +		if (ih == NULL)
>> +			goto err;
>> +
>> +		memcpy(addr, src ? &ih->saddr : &ih->daddr,
>> +		       sizeof(*addr));
>> +		return;
>> +	}
>> +
>> +err:
>> +	memset(addr, 0, sizeof(*addr));
>> +}
>>     
>
> Zero valued IP addresses are valid, so it's not a proper error handling in 
> the ip[46]inneraddrptr functions.
>   
I was unaware of this and error-handling will be implemented differently 
in the next version of the patches.

> These all can be replaced by a function which skips the external header 
> and points to the inner one, something like:
>
> int
> ipset_inner_header(const struct sk_buff *skb, u8 pf, u8 *offset,
> 		   void *inner)
> {
> 	/* IPv4 */
> 	...
> 	/* IPv6 */
> 	nexthdr = ipv6_hdr(skb)->nexthdr;
> 	*offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), 
> 				   &nexthdr, &frag_off);
> 	/* Validate offset and frag_off */
> 	/* Check ICMPv6, update offset */
> 	/* Copy inner IPv6 header to *inner by skb_header_pointer */
>
> 	return success/error;
> }
>   
IPv4 and IPv6 should be treated as separate cases, so I'll create two 
separate functions for that.

One other thing - this type of operation is not going to be confined 
just to ipset (I plan to do the same thing when submit the changes to 
the AUDIT iptables target, which logs these attributes as well), so I am 
thinking of offloading these two functions and moving everything to 
ip[v6].h so that they can be used not just by ipset. What do you think?

> Please note, I updated the ipset git tree with a patch which adds the 
> a missing verification of frag_off to ip_set_get_ip6_port().
>   
I did see that, though I am not sure this can work in kernel versions < 3.3.

>> diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
>> b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
>> index ce99d26..7552d6d 100644
>> --- a/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
>> +++ b/kernel/net/netfilter/ipset/ip_set_bitmap_ip.c
>> @@ -116,7 +116,9 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff
>> *skb,
>>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, map);
>>  	u32 ip;
>>
>> -	ip = ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
>> +	ip = opt->cmdflags & IPSET_FLAG_INNER ?
>> +		ntohl(ip4inneraddr(skb, opt->flags & IPSET_DIM_ONE_SRC)) :
>> +		ntohl(ip4addr(skb, opt->flags & IPSET_DIM_ONE_SRC));
>>  	if (ip < map->first_ip || ip > map->last_ip)
>>  		return -IPSET_ERR_BITMAP_RANGE;
>>     
>
> With the ipset_inner_header function, all these looks like this: we need 
> new variables for the IP header, pointer to it and offset. If the 
> IPSET_FLAG_INNER is true, ipset_inner_header is called and the returned 
> error code handled or the pointer to IP header is updated. Something like 
> this:
>
> 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, map);
> 	u32 ip;
> 	struct iphdr _iphdr, *iphdr = ip_hdr(skb);
> 	u8 offset = 0;
>
> 	if (opt->cmdflags & IPSET_FLAG_INNER) {
> 		if (ipset_inner_header(skb, NFPROTO_IPV4, &offset, &_iphdr))
> 			return -EINVAL;
> 		iphdr = &_iphdr;
> 	}
> 	....
>
> Current ip[46]addr[ptr] functions of course need to be modified to use the 
> IP header structures instead of the skbuff one.
>   
I am not sure there should be one function for this - IPv6 and IPv4 are 
two separate cases (what if I don't have IPv6 - the whole IPv6 code will 
never be executed/needed, so there isn't any reason to be there at all), 
so I think there should be two separate functions for these.

>> diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
>> b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
>> index b220489..d29395b 100644
>> --- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
>> +++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
>> @@ -110,9 +110,17 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff
>> *skb,
>>  	__be16 __port;
>>  	u16 port = 0;
>>
>> -	if (!ip_set_get_ip_port(skb, opt->family,
>> -				opt->flags & IPSET_DIM_ONE_SRC, &__port))
>> -		return -EINVAL;
>> +	if (opt->cmdflags & IPSET_FLAG_INNER) {
>> +		if (!ip_set_get_inner_ip_port(skb, opt->family,
>> +					opt->flags & IPSET_DIM_ONE_SRC,
>> +					&__port))
>> +			return -EINVAL;
>> +	} else {
>> +		if (!ip_set_get_ip_port(skb, opt->family,
>> +					opt->flags & IPSET_DIM_ONE_SRC,
>> +					&__port))
>> +			return -EINVAL;
>> +	}
>>
>>  	port = ntohs(__port);
>>     
>
> The ip_set_get*port functions need the new offset argument too.
>   
Yep, that's another change which I need to implement.

>> @@ -413,12 +423,21 @@ hash_netport6_kadt(struct ip_set *set, const struct
>> sk_buff *skb,
>>
>>  	if (adt == IPSET_TEST)
>>  		e.cidr = HOST_MASK - 1;
>> -
>> -	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>> -				 &e.port, &e.proto))
>> -		return -EINVAL;
>> -
>> -	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
>> +	if (opt->cmdflags & IPSET_FLAG_INNER) {
>> +		if (!ip_set_get_inner_ip6_port(skb,
>> +					opt->flags & IPSET_DIM_TWO_SRC,
>> +					&e.port, &e.proto))
>> +			return -EINVAL;
>> +
>> +		ip6inneraddrptr(skb, opt->flags & IPSET_DIM_ONE_SRC,
>> +				&e.ip.in6);
>> +	} else {
>> +		if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>> +					 &e.port, &e.proto))
>> +			return -EINVAL;
>> +
>> +		ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
>> +	}
>>  	ip6_netmask(&e.ip, e.cidr + 1);
>>
>>  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
>>     
>
> I'd prefer the patch to be split into two parts: the first which 
> implements the new functions and changes in the core and the second which 
> applies them to the set types. Thanks.
>   
Noted.

