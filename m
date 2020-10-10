Return-Path: <SRS0=0qAu=DR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF358C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Oct 2020 06:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780732067D
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Oct 2020 06:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgJJGma (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Oct 2020 02:42:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60528 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgJJGmL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Oct 2020 02:42:11 -0400
Received: from madeliefje.horms.nl (tulip.horms.nl [83.161.246.101])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 3A9C725B7E4;
        Sat, 10 Oct 2020 17:42:08 +1100 (AEDT)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 4633E1399; Sat, 10 Oct 2020 08:42:06 +0200 (CEST)
Date:   Sat, 10 Oct 2020 08:42:06 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Evgeny B <abt-admin@mail.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] ipvs: clear skb->tstamp in forwarding path
Message-ID: <20201010064206.GC22339@vergenet.net>
References: <20201009182425.9050-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009182425.9050-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 09, 2020 at 09:24:25PM +0300, Julian Anastasov wrote:
> fq qdisc requires tstamp to be cleared in forwarding path
> 
> Reported-by: Evgeny B <abt-admin@mail.ru>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=209427
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths")
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Reviewed-by: Simon Horman <horms@verge.net.au>

Pablo, could you consider this for nf ?

> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index b00866d777fe..d2e5a8f644b8 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -609,6 +609,8 @@ static inline int ip_vs_tunnel_xmit_prepare(struct sk_buff *skb,
>  	if (ret == NF_ACCEPT) {
>  		nf_reset_ct(skb);
>  		skb_forward_csum(skb);
> +		if (skb->dev)
> +			skb->tstamp = 0;
>  	}
>  	return ret;
>  }
> @@ -649,6 +651,8 @@ static inline int ip_vs_nat_send_or_cont(int pf, struct sk_buff *skb,
>  
>  	if (!local) {
>  		skb_forward_csum(skb);
> +		if (skb->dev)
> +			skb->tstamp = 0;
>  		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
>  			NULL, skb_dst(skb)->dev, dst_output);
>  	} else
> @@ -669,6 +673,8 @@ static inline int ip_vs_send_or_cont(int pf, struct sk_buff *skb,
>  	if (!local) {
>  		ip_vs_drop_early_demux_sk(skb);
>  		skb_forward_csum(skb);
> +		if (skb->dev)
> +			skb->tstamp = 0;
>  		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
>  			NULL, skb_dst(skb)->dev, dst_output);
>  	} else
> -- 
> 2.26.2
> 
> 
