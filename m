Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5866DC5B57D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 07:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A6E0216C8
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 07:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGBHTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 03:19:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52280 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfGBHTI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 03:19:08 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id ED07225AF0F;
        Tue,  2 Jul 2019 17:19:05 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id E81F8940476; Tue,  2 Jul 2019 09:19:03 +0200 (CEST)
Date:   Tue, 2 Jul 2019 09:19:03 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>
Subject: Re: [PATCH net-next] ipvs: strip gre tunnel headers from icmp errors
Message-ID: <20190702071903.4qrs2laft57smz7m@verge.net.au>
References: <20190701193415.5366-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701193415.5366-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:34:15PM +0300, Julian Anastasov wrote:
> Recognize GRE tunnels in received ICMP errors and
> properly strip the tunnel headers.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Thanks Julian,

this looks good to me.

Signed-off-by: Simon Horman <horms@verge.net.au>

Pablo, please consider including this in nf-next
along with the dependency listed below.

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 45 ++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
>  This patch is based on:
>  "[PATCH v3] ipvs: allow tunneling with gre encapsulation"
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index e8651fd621ef..c2c51bdb889d 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1610,6 +1610,38 @@ static int ipvs_udp_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  	return 0;
>  }
>  
> +/* Check the GRE tunnel and return its header length */
> +static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
> +			  unsigned int offset, __u16 af,
> +			  const union nf_inet_addr *daddr, __u8 *proto)
> +{
> +	struct gre_base_hdr _greh, *greh;
> +	struct ip_vs_dest *dest;
> +
> +	greh = skb_header_pointer(skb, offset, sizeof(_greh), &_greh);
> +	if (!greh)
> +		goto unk;
> +	dest = ip_vs_find_tunnel(ipvs, af, daddr, 0);
> +	if (!dest)
> +		goto unk;
> +	if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		__be16 type;
> +
> +		/* Only support version 0 and C (csum) */
> +		if ((greh->flags & ~GRE_CSUM) != 0)
> +			goto unk;
> +		type = greh->protocol;
> +		/* Later we can support also IPPROTO_IPV6 */
> +		if (type != htons(ETH_P_IP))
> +			goto unk;
> +		*proto = IPPROTO_IPIP;
> +		return gre_calc_hlen(gre_flags_to_tnl_flags(greh->flags));
> +	}
> +
> +unk:
> +	return 0;
> +}
> +
>  /*
>   *	Handle ICMP messages in the outside-to-inside direction (incoming).
>   *	Find any that might be relevant, check against existing connections,
> @@ -1689,7 +1721,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  		if (cih == NULL)
>  			return NF_ACCEPT; /* The packet looks wrong, ignore */
>  		ipip = true;
> -	} else if (cih->protocol == IPPROTO_UDP &&	/* Can be UDP encap */
> +	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
> +		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
>  		   /* Error for our tunnel must arrive at LOCAL_IN */
>  		   (skb_rtable(skb)->rt_flags & RTCF_LOCAL)) {
>  		__u8 iproto;
> @@ -1699,10 +1732,14 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
>  			return NF_ACCEPT;
>  		offset2 = offset + cih->ihl * 4;
> -		ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET, raddr,
> -				      &iproto);
> +		if (cih->protocol == IPPROTO_UDP)
> +			ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET,
> +					      raddr, &iproto);
> +		else
> +			ulen = ipvs_gre_decap(ipvs, skb, offset2, AF_INET,
> +					      raddr, &iproto);
>  		if (ulen > 0) {
> -			/* Skip IP and UDP tunnel headers */
> +			/* Skip IP and UDP/GRE tunnel headers */
>  			offset = offset2 + ulen;
>  			/* Now we should be at the original IP header */
>  			cih = skb_header_pointer(skb, offset, sizeof(_ciph),
> -- 
> 2.21.0
> 
