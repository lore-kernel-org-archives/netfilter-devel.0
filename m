Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCC9C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 01:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLPBQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 20:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPBQr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 20:16:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A43243862
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 17:16:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p5zL7-0003fe-VH; Fri, 16 Dec 2022 02:16:41 +0100
Date:   Fri, 16 Dec 2022 02:16:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Introduce
 NFTA_RULE_ALT_EXPRESSIONS
Message-ID: <20221216011641.GA574@breakpoint.cc>
References: <20221215204302.8378-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215204302.8378-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> With identical content as NFTA_RULE_EXPRESSIONS, data in this attribute
> is dumped in place of the live expressions, which in turn are dumped as
> NFTA_RULE_ALT_EXPRESSIONS.

This name isn't very descriptive.

Or at least mention that this is for iptables-nft/NFT_COMPAT sake?

Perhaps its better to use two distinct attributes?

NFTA_RULE_EXPRESSIONS_COMPAT  (input)
NFTA_RULE_EXPRESSIONS_ACTUAL  (output)?

The switcheroo of ALT (old crap on input, actual live ruleset on output)
is very unintuitive.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/net/netfilter/nf_tables.h        | 12 ++++++
>  include/uapi/linux/netfilter/nf_tables.h |  3 ++
>  net/netfilter/nf_tables_api.c            | 47 +++++++++++++++++++++---
>  3 files changed, 56 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index e69ce23566eab..b08e01d19e835 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -946,10 +946,21 @@ struct nft_expr_ops {
>  	void				*data;
>  };
>  
> +/**
> + *	struct nft_alt_expr - nft_tables rule alternate expressions
> + *	@dlen: length of @data
> + *	@data: blob used as payload of NFTA_RULE_EXPRESSIONS attribute
> + */
> +struct nft_alt_expr {
> +	int	dlen;
> +	char	data[];
> +};
> +
>  /**
>   *	struct nft_rule - nf_tables rule
>   *
>   *	@list: used internally
> + *	@alt_expr: Expression blob to dump instead of live data
>   *	@handle: rule handle
>   *	@genmask: generation mask
>   *	@dlen: length of expression data
> @@ -958,6 +969,7 @@ struct nft_expr_ops {
>   */
>  struct nft_rule {
>  	struct list_head		list;
> +	struct nft_alt_expr		*alt_expr;
>  	u64				handle:42,
>  					genmask:2,
>  					dlen:12,
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index cfa844da1ce61..2dff92f527429 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -247,6 +247,8 @@ enum nft_chain_attributes {
>   * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
>   * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
>   * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
> + * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
> + * @NFTA_RULE_ALT_EXPRESSIONS: expressions to swap with @NFTA_RULE_EXPRESSIONS for dumps (NLA_NESTED: nft_expr_attributes)
>   */
>  enum nft_rule_attributes {
>  	NFTA_RULE_UNSPEC,
> @@ -261,6 +263,7 @@ enum nft_rule_attributes {
>  	NFTA_RULE_ID,
>  	NFTA_RULE_POSITION_ID,
>  	NFTA_RULE_CHAIN_ID,
> +	NFTA_RULE_ALT_EXPRESSIONS,

You need to update the nla_policy too.

> +		if (nla_put(skb, NFTA_RULE_EXPRESSIONS,
> +			    rule->alt_expr->dlen, rule->alt_expr->data) < 0)
> +			goto nla_put_failure;
> +	} else {
> +		list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
> +		if (!list)
>  			goto nla_put_failure;
> +
> +		nft_rule_for_each_expr(expr, next, rule) {
> +			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
> +				goto nla_put_failure;
> +		}
> +		nla_nest_end(skb, list);
> +	}
> +
> +	if (rule->alt_expr) {
> +		list = nla_nest_start_noflag(skb, NFTA_RULE_ALT_EXPRESSIONS);
> +		if (!list)
> +			goto nla_put_failure;
> +
> +		nft_rule_for_each_expr(expr, next, rule) {
> +			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
> +				goto nla_put_failure;
> +		}
> +		nla_nest_end(skb, list);

How does userspace know if NFTA_RULE_EXPRESSIONS is the backward annotated
kludge or the live/real ruleset?  Check for presence of ALT attribute?

> -	nla_nest_end(skb, list);
>  
>  	if (rule->udata) {
>  		struct nft_userdata *udata = nft_userdata(rule);
> @@ -3366,6 +3385,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
>  		nf_tables_expr_destroy(ctx, expr);
>  		expr = next;
>  	}
> +	kfree(rule->alt_expr);
>  	kfree(rule);
>  }
>  
> @@ -3443,6 +3463,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	struct nft_rule *rule, *old_rule = NULL;
>  	struct nft_expr_info *expr_info = NULL;
>  	u8 family = info->nfmsg->nfgen_family;
> +	struct nft_alt_expr *alt_expr = NULL;
>  	struct nft_flow_rule *flow = NULL;
>  	struct net *net = info->net;
>  	struct nft_userdata *udata;
> @@ -3556,6 +3577,19 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	if (size >= 1 << 12)
>  		goto err_release_expr;
>  
> +	if (nla[NFTA_RULE_ALT_EXPRESSIONS]) {
> +		int dlen = nla_len(nla[NFTA_RULE_ALT_EXPRESSIONS]);
> +		alt_expr = kvmalloc(sizeof(*alt_expr) + dlen, GFP_KERNEL);

Once nla_policy provides a maxlen this is fine.

> +		nla_memcpy(alt_expr->data,
> +			   nla[NFTA_RULE_ALT_EXPRESSIONS], dlen);

Hmm, I wonder if this isn't a problem.
The kernel will now dump arbitrary data to userspace, whereas without
this patch the nla data is generated by kernel, i.e. never malformed.

I wonder if the alt blob needs to go through some type of validation
too?

Also I think that this attribute should always be ignored for
NFT_COMPAT=n builds, we should document this kludge is only for
iptables-nft sake (or rather, incorrect a**umptions by 3rd
party wrappers of iptables userspace...).
