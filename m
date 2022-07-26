Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E38C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 13:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiGZN3U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 09:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbiGZN3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 09:29:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCBCD25C78
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 06:29:18 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:29:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_queue: only allow supported families
Message-ID: <Yt/sKPSv8K1gD1oX@salvia>
References: <20220726104348.2125-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220726104348.2125-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 26, 2022 at 12:43:48PM +0200, Florian Westphal wrote:
> Trying to use 'queue' statement in ingress (for example)
> triggers a splat on reinject:
> 
> WARNING: CPU: 3 PID: 1345 at net/netfilter/nf_queue.c:291
> 
> ... because nf_reinject cannot find the ruleset head, so all
> "reinject" attempts result in packet drop.
> 
> Ingress/egress do not support async resume at the moment anyway,
> so disallow loading such rulesets with a more appropriate error
> message.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_queue.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> index 15e4b7640dc0..cb54a0a4b424 100644
> --- a/net/netfilter/nft_queue.c
> +++ b/net/netfilter/nft_queue.c
> @@ -75,6 +75,24 @@ static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
>  	[NFTA_QUEUE_SREG_QNUM]	= { .type = NLA_U32 },
>  };
>  
> +static bool nft_queue_family_supported(const struct nft_ctx *ctx)
> +{
> +	switch (ctx->family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +	case NFPROTO_INET:

there is a special inet/ingress, maybe it requires a sanity check here?

> +	case NFPROTO_BRIDGE:
> +		return true;
> +	case NFPROTO_ARP:
> +	case NFPROTO_DECNET:
> +	case NFPROTO_NETDEV:
> +	default:
> +		break;
> +	}
> +
> +	return false;
> +}
> +
>  static int nft_queue_init(const struct nft_ctx *ctx,
>  			  const struct nft_expr *expr,
>  			  const struct nlattr * const tb[])
> @@ -82,6 +100,9 @@ static int nft_queue_init(const struct nft_ctx *ctx,

Maybe .validate is a better place for this?

>  	struct nft_queue *priv = nft_expr_priv(expr);
>  	u32 maxid;
>  
> +	if (!nft_queue_family_supported(ctx))
> +		return -EOPNOTSUPP;
> +
>  	priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
>  
>  	if (tb[NFTA_QUEUE_TOTAL])
> @@ -111,6 +132,9 @@ static int nft_queue_sreg_init(const struct nft_ctx *ctx,
>  	struct nft_queue *priv = nft_expr_priv(expr);
>  	int err;
>  
> +	if (!nft_queue_family_supported(ctx))
> +		return -EOPNOTSUPP;
> +
>  	err = nft_parse_register_load(tb[NFTA_QUEUE_SREG_QNUM],
>  				      &priv->sreg_qnum, sizeof(u32));
>  	if (err < 0)
> -- 
> 2.35.1
> 
