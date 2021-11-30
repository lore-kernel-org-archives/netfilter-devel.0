Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F83C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 21:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhK3Vxl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 16:53:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:51864 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344653AbhK3VwF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 16:52:05 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F6D860022;
        Tue, 30 Nov 2021 22:46:28 +0100 (CET)
Date:   Tue, 30 Nov 2021 22:48:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nft_fwd_netdev: Support egress hook
Message-ID: <YaacOHx7Gxp2cxlq@salvia>
References: <af1325c0c71ad2786b7fba282a4b21c8fc0cf53c.1636461297.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af1325c0c71ad2786b7fba282a4b21c8fc0cf53c.1636461297.git.lukas@wunner.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

I'm sorry, I just noticed something below.

On Tue, Nov 09, 2021 at 01:42:01PM +0100, Lukas Wunner wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Allow packet redirection to another interface upon egress.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [lukas: set skb_iif, add commit message]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  net/netfilter/nft_fwd_netdev.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index cd59afde5b2f..fa9301ca6033 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -27,9 +27,11 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
>  {
>  	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
>  	int oif = regs->data[priv->sreg_dev];
> +	struct sk_buff *skb = pkt->skb;
>  
>  	/* This is used by ifb only. */
> -	skb_set_redirected(pkt->skb, true);
> +	skb->skb_iif = skb->dev->ifindex;

Probably good to set skb->skb_iif only for NF_NETDEV_EGRESS?

> +	skb_set_redirected(skb, nft_hook(pkt) == NF_NETDEV_INGRESS);
>  
>  	nf_fwd_netdev_egress(pkt, oif);
>  	regs->verdict.code = NF_STOLEN;
> @@ -198,7 +200,8 @@ static int nft_fwd_validate(const struct nft_ctx *ctx,
>  			    const struct nft_expr *expr,
>  			    const struct nft_data **data)
>  {
> -	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
> +	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
> +						    (1 << NF_NETDEV_EGRESS));
>  }
>  
>  static struct nft_expr_type nft_fwd_netdev_type;
> -- 
> 2.33.0
> 
