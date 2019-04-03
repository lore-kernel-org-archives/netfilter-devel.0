Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384B5C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 08:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F442084C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 08:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="RGd9wj3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfDCIPQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:15:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34629 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfDCIPQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 04:15:16 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id B338925BDFF;
        Wed,  3 Apr 2019 19:15:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554279314; bh=JvUXNO+KLgc0J83OrqTXgq+xEuTnu5M5i0gThnjjZAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGd9wj3fSF0LouI++43QxtGArkDX/a/Z61zWo0nZ1DN4Z1ykwvv4y85k4N7SXopJg
         RgK8OR07bH3xWqTM8Bqls5ybqYqxJpjiG2isUeyPb1ngRuZDpBX5zv46Qpavx6pRjd
         sqxCkHWyDn2GSyXZOfz6F+DjKaZVCVjAH6/Ee0ts=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id AB576940361; Wed,  3 Apr 2019 10:15:11 +0200 (CEST)
Date:   Wed, 3 Apr 2019 10:15:11 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 3/3] ipvs: strip udp tunnel headers from icmp
 errors
Message-ID: <20190403081511.ltjmuudpxdz3xxmf@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-4-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331102621.7460-4-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Julian,

On Sun, Mar 31, 2019 at 01:26:21PM +0300, Julian Anastasov wrote:
> Recognize UDP tunnels in received ICMP errors and
> properly strip the tunnel headers. GUE is what we
> have for now.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 58 +++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 4447ee512b88..0b624e8e7982 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -39,6 +39,7 @@
>  #include <net/tcp.h>
>  #include <net/udp.h>
>  #include <net/icmp.h>                   /* for icmp_send */
> +#include <net/gue.h>
>  #include <net/route.h>
>  #include <net/ip6_checksum.h>
>  #include <net/netns/generic.h>		/* net_generic() */
> @@ -1579,6 +1580,34 @@ ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
>  	return 1;
>  }
>  
> +/* Check the UDP tunnel and return its header length */
> +static int ipvs_udp_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
> +			  unsigned int offset, __u16 af, __be16 dport,
> +			  const union nf_inet_addr *daddr, __u8 *proto)
> +{
> +	struct ip_vs_dest *dest = ip_vs_find_tunnel(ipvs, af, daddr, dport);
> +
> +	if (!dest)
> +		goto unk;
> +	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
> +		struct guehdr _gueh, *gueh;
> +
> +		gueh = skb_header_pointer(skb, offset, sizeof(_gueh), &_gueh);
> +		if (!gueh)
> +			goto unk;
> +		if (gueh->control != 0 || gueh->version != 0)
> +			goto unk;
> +		/* Later we can support also IPPROTO_IPV6 */
> +		if (gueh->proto_ctype != IPPROTO_IPIP)
> +			goto unk;
> +		*proto = gueh->proto_ctype;
> +		return sizeof(struct guehdr) + (gueh->hlen << 2);

I think that the gue-specific portions of the above, which is most of
ipvs_udp_decap() should be a separate helper which is part of net/gue.h or
net/ipv4/fou.c - this seems to be a subset of the logic in gue_udp_recv().

> +	}
> +
> +unk:
> +	return -1;
> +}
> +
>  /*
>   *	Handle ICMP messages in the outside-to-inside direction (incoming).
>   *	Find any that might be relevant, check against existing connections,
> @@ -1658,8 +1687,37 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  		if (cih == NULL)
>  			return NF_ACCEPT; /* The packet looks wrong, ignore */
>  		ipip = true;
> +	} else if (cih->protocol == IPPROTO_UDP) {	/* Can be UDP encap */

Can we consider factoring out the logic in this else-if clause
out into a function to avoid the use of goto?

> +		struct udphdr _udph, *udph;
> +		__u8 iproto;
> +		int ulen;
> +
> +		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
> +			return NF_ACCEPT;

I think a comment is warranted regarding the behaviour implemented
for fragments.

> +		/* Error for our tunnel must arrive at LOCAL_IN */
> +		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
> +			return NF_ACCEPT;
> +		offset2 = offset + cih->ihl * 4;
> +		udph = skb_header_pointer(skb, offset2, sizeof(_udph), &_udph);
> +		if (!udph)
> +			goto check;

> +		offset2 += sizeof(struct udphdr);
> +		ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET, udph->dest,
> +				      raddr, &iproto);
> +		if (ulen < 0)
> +			goto check;
> +		/* Skip IP + UDP + ulen */
> +		offset = offset2 + ulen;
> +		/* Now we should be at the original IP header */
> +		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
> +		if (cih && cih->version == 4 && cih->ihl >= 5 &&
> +		    iproto == IPPROTO_IPIP)
> +			ipip = true;
> +		else
> +			return NF_ACCEPT;

Skipping over tunnel headers and determining the inner IP protocol really
feels like something that should be handled code common to other UDP
encapsulation implementations.

>  	}
>  
> +check:
>  	pd = ip_vs_proto_data_get(ipvs, cih->protocol);
>  	if (!pd)
>  		return NF_ACCEPT;
> -- 
> 2.17.1
> 
