From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_nat: fix crash in nf_nat_csum
Date: Tue, 07 Jun 2011 15:07:48 +0200
Message-ID: <4DEE22A4.8060202@trash.net>
References: <alpine.LFD.2.00.1105292335220.1429@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52381 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1FGNH4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:07:56 -0400
In-Reply-To: <alpine.LFD.2.00.1105292335220.1429@ja.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.05.2011 22:42, Julian Anastasov wrote:
> 
> 	Fix crash in nf_nat_csum when mangling packets
> in OUTPUT hook where skb->dev is not defined, it is set
> later before POSTROUTING. Problem happens for CHECKSUM_NONE.
> We can check device from rt but using CHECKSUM_PARTIAL
> should be safe (skb_checksum_help).

We don't call helpers in LOCAL_OUT, how can this happen?

> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
> 
> diff -urp v2.6.39/linux/net/ipv4/netfilter/nf_nat_helper.c linux/net/ipv4/netfilter/nf_nat_helper.c
> --- v2.6.39/linux/net/ipv4/netfilter/nf_nat_helper.c	2011-01-06 00:01:22.000000000 +0200
> +++ linux/net/ipv4/netfilter/nf_nat_helper.c	2011-05-29 23:14:40.166245897 +0300
> @@ -160,7 +160,7 @@ static void nf_nat_csum(struct sk_buff *
>  
>  	if (skb->ip_summed != CHECKSUM_PARTIAL) {
>  		if (!(rt->rt_flags & RTCF_LOCAL) &&
> -		    skb->dev->features & NETIF_F_V4_CSUM) {
> +		    (!skb->dev || skb->dev->features & NETIF_F_V4_CSUM)) {
>  			skb->ip_summed = CHECKSUM_PARTIAL;
>  			skb->csum_start = skb_headroom(skb) +
>  					  skb_network_offset(skb) +
> 

