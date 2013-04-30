From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: support package fragments for IPv4
 protos without ports
Date: Tue, 30 Apr 2013 10:23:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304301017430.20765@blackhole.kfki.hu>
References: <20130428100936.60D0815759E@homer.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Anders K. Pedersen" <akp@surftown.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52045 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758952Ab3D3IXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:23:13 -0400
In-Reply-To: <20130428100936.60D0815759E@homer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sun, 28 Apr 2013, Anders K. Pedersen wrote:

> From: Anders K. Pedersen <akp@surftown.com>
> 
> Enable ipset port set types to match IPv4 package fragments for protocols
> that doesn't have ports (or the port information isn't supported by ipset).
> 
> For example this allows a hash:ip,port ipset containing the entry
> 192.168.0.1,gre:0 to match all package fragments for PPTP VPN tunnels
> to/from the host. Without this patch only the first package fragment (with
> fragment offset 0) was matched, while subsequent fragments wasn't.
> 
> This is not possible for IPv6, where the protocol is in the fragmented part
> of the package unlike IPv4, where the protocol is in the IP header.
> 
> Signed-off-by: Anders K. Pedersen <akp@surftown.com>
> 
> ---
> 
> The patch was implemented and tested on linux-3.8.10 and I have verified that
> it applies cleanly to current linux.git and nf-next.git.
> 
> I have tried to make it as simple as possible, but if you feel that something
> should be done differently, I will do my best to implement it.

It'd better to add it directly to ip_set_get_ip4_port, thus the fragment 
checking is not scattered everywhere. Something like this:

	...
	if (ntohs(iph->frag_off) & IP_OFFSET) {
		switch (protocol) {
		case IPPROTO_TCP:
		...
			return false;
		default:
			...

Best regards,
Jozsef
 
> --- linux-3.8.10/net/netfilter/ipset/ip_set_getport.c.orig	2013-02-19 00:58:34.000000000 +0100
> +++ linux-3.8.10/net/netfilter/ipset/ip_set_getport.c	2013-04-28 10:27:50.291663937 +0200
> @@ -22,13 +22,17 @@
>  /* We must handle non-linear skbs */
>  static bool
>  get_port(const struct sk_buff *skb, int protocol, unsigned int protooff,
> -	 bool src, __be16 *port, u8 *proto)
> +	 int fragoff, bool src, __be16 *port, u8 *proto)
>  {
>  	switch (protocol) {
>  	case IPPROTO_TCP: {
>  		struct tcphdr _tcph;
>  		const struct tcphdr *th;
>  
> +		if (fragoff)
> +			/* Port info not available in subsequent fragments */
> +			return false;
> +
>  		th = skb_header_pointer(skb, protooff, sizeof(_tcph), &_tcph);
>  		if (th == NULL)
>  			/* No choice either */
> @@ -41,6 +45,10 @@ get_port(const struct sk_buff *skb, int
>  		sctp_sctphdr_t _sh;
>  		const sctp_sctphdr_t *sh;
>  
> +		if (fragoff)
> +			/* Port info not available in subsequent fragments */
> +			return false;
> +
>  		sh = skb_header_pointer(skb, protooff, sizeof(_sh), &_sh);
>  		if (sh == NULL)
>  			/* No choice either */
> @@ -54,6 +62,10 @@ get_port(const struct sk_buff *skb, int
>  		struct udphdr _udph;
>  		const struct udphdr *uh;
>  
> +		if (fragoff)
> +			/* Port info not available in subsequent fragments */
> +			return false;
> +
>  		uh = skb_header_pointer(skb, protooff, sizeof(_udph), &_udph);
>  		if (uh == NULL)
>  			/* No choice either */
> @@ -66,6 +78,10 @@ get_port(const struct sk_buff *skb, int
>  		struct icmphdr _ich;
>  		const struct icmphdr *ic;
>  
> +		if (fragoff)
> +			/* Port info not available in subsequent fragments */
> +			return false;
> +
>  		ic = skb_header_pointer(skb, protooff, sizeof(_ich), &_ich);
>  		if (ic == NULL)
>  			return false;
> @@ -77,6 +93,10 @@ get_port(const struct sk_buff *skb, int
>  		struct icmp6hdr _ich;
>  		const struct icmp6hdr *ic;
>  
> +		if (fragoff)
> +			/* Port info not available in subsequent fragments */
> +			return false;
> +
>  		ic = skb_header_pointer(skb, protooff, sizeof(_ich), &_ich);
>  		if (ic == NULL)
>  			return false;
> @@ -100,12 +120,13 @@ ip_set_get_ip4_port(const struct sk_buff
>  	const struct iphdr *iph = ip_hdr(skb);
>  	unsigned int protooff = ip_hdrlen(skb);
>  	int protocol = iph->protocol;
> +	int fragoff = (ntohs(iph->frag_off) & IP_OFFSET);
>  
>  	/* See comments at tcp_match in ip_tables.c */
> -	if (protocol <= 0 || (ntohs(iph->frag_off) & IP_OFFSET))
> +	if (protocol <= 0)
>  		return false;
>  
> -	return get_port(skb, protocol, protooff, src, port, proto);
> +	return get_port(skb, protocol, protooff, fragoff, src, port, proto);
>  }
>  EXPORT_SYMBOL_GPL(ip_set_get_ip4_port);
>  
> @@ -124,7 +145,7 @@ ip_set_get_ip6_port(const struct sk_buff
>  	if (protoff < 0)
>  		return false;
>  
> -	return get_port(skb, nexthdr, protoff, src, port, proto);
> +	return get_port(skb, nexthdr, protoff, 0, src, port, proto);
>  }
>  EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
>  #endif
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
