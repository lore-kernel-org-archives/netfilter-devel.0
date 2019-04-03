Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F49C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 07:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 201042084B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 07:56:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="fcKDni67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDCH4v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:56:51 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34354 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfDCH4v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 03:56:51 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 8479C25BDFF;
        Wed,  3 Apr 2019 18:56:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554278208; bh=Oq6wIsZ2d9qDJ4bKdNfzqnI7/5woX+cBxnFUiqmL+Aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fcKDni67iyVUGlJsZav6WM59TaIzE7Dy+95zTLU+CuYfIuuKIm+KQNYvby4mLwoXX
         GgZpzp/GRwkmngoHl53GOEKPECHRYw+NEAuHWgV77Y9mFMxS1PvHAmGQ93GQh8MPQR
         VG/QD+jwoL8Ia7Vt4C1G97vvY0MDpV0VjtCKE4Qg=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 7A30A940361; Wed,  3 Apr 2019 09:56:46 +0200 (CEST)
Date:   Wed, 3 Apr 2019 09:56:46 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 2/3] ipvs: add function to find tunnels
Message-ID: <20190403075646.m3yij2qi75yyvsom@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-3-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331102621.7460-3-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 31, 2019 at 01:26:20PM +0300, Julian Anastasov wrote:
> Add ip_vs_find_tunnel() to match tunnel headers
> by family, address and optional port. Use it to
> properly find the tunnel real server used in
> received ICMP errors.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  include/net/ip_vs.h             |  3 +++
>  net/netfilter/ipvs/ip_vs_core.c |  8 ++++++++
>  net/netfilter/ipvs/ip_vs_ctl.c  | 29 +++++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 9a8ac8997e34..b01a94ebfc0e 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1404,6 +1404,9 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
>  struct ip_vs_dest *
>  ip_vs_find_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
>  			const union nf_inet_addr *daddr, __be16 dport);
> +struct ip_vs_dest *ip_vs_find_tunnel(struct netns_ipvs *ipvs, int af,
> +				     const union nf_inet_addr *daddr,
> +				     __be16 tun_port);
>  
>  int ip_vs_use_count_inc(void);
>  void ip_vs_use_count_dec(void);

> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 14457551bcb4..4447ee512b88 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1598,6 +1598,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  	struct ip_vs_proto_data *pd;
>  	unsigned int offset, offset2, ihl, verdict;
>  	bool ipip, new_cp = false;
> +	union nf_inet_addr *raddr;
>  
>  	*related = 1;
>  
> @@ -1636,15 +1637,22 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
>  	if (cih == NULL)
>  		return NF_ACCEPT; /* The packet looks wrong, ignore */
> +	raddr = (union nf_inet_addr *)&cih->daddr;

Hi Julian,

	Could we consider the following instead of casting?

	union nf_inet_addr raddr;

	...

	raddr.ip = cih->daddr;

	...

	est = ip_vs_find_tunnel(ipvs, AF_INET, &raddr, 0);

>  
>  	/* Special case for errors for IPIP packets */
>  	ipip = false;
>  	if (cih->protocol == IPPROTO_IPIP) {
> +		struct ip_vs_dest *dest;
> +
>  		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
>  			return NF_ACCEPT;
>  		/* Error for our IPIP must arrive at LOCAL_IN */
>  		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
>  			return NF_ACCEPT;
> +		dest = ip_vs_find_tunnel(ipvs, AF_INET, raddr, 0);
> +		/* Only for known tunnel */
> +		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
> +			return NF_ACCEPT;
>  		offset += cih->ihl * 4;
>  		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
>  		if (cih == NULL)

...
