Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404DFC61DB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 10:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjALKPu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 05:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjALKPP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 05:15:15 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750EE322
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 02:15:13 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pFuc2-0004At-QE; Thu, 12 Jan 2023 11:15:10 +0100
Date:   Thu, 12 Jan 2023 11:15:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y7/drsGvc8MkQiTY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20221221142221.27211-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221142221.27211-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bump?

On Wed, Dec 21, 2022 at 03:22:21PM +0100, Phil Sutter wrote:
> Allow for user space to provide an improved variant of the rule for
> actual use. The variant in NFTA_RULE_EXPRESSIONS may provide maximum
> compatibility for old user space tools (e.g. in outdated containers).
> 
> The new attribute is also dumped back to user space, e.g. for comparison
> against the compatible variant.
> 
> While being at it, improve nft_rule_policy for NFTA_RULE_EXPRESSIONS.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Rename the new attribute as suggested
> - Avoid the changing attribute meaning - ACTUAL_EXPR will always contain
>   the new variant, both on input and output
> - Rename the new struct nft_rule field accordingly
> - Add the new attribute to nft_rule_policy
> ---
>  include/net/netfilter/nf_tables.h        | 13 ++++++++
>  include/uapi/linux/netfilter/nf_tables.h |  3 ++
>  net/netfilter/nf_tables_api.c            | 38 ++++++++++++++++++++----
>  3 files changed, 49 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index e69ce23566eab..e8446abb7620c 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -946,10 +946,22 @@ struct nft_expr_ops {
>  	void				*data;
>  };
>  
> +/**
> + *	struct nft_dump_expr - compat expression blob for rule dumps
> + *
> + *	@dlen: length of @data
> + *	@data: blob used as payload of NFTA_RULE_EXPRESSIONS attribute
> + */
> +struct nft_dump_expr {
> +	int	dlen;
> +	char	data[];
> +};
> +
>  /**
>   *	struct nft_rule - nf_tables rule
>   *
>   *	@list: used internally
> + *	@dump_expr: Expression blob to dump instead of live data
>   *	@handle: rule handle
>   *	@genmask: generation mask
>   *	@dlen: length of expression data
> @@ -958,6 +970,7 @@ struct nft_expr_ops {
>   */
>  struct nft_rule {
>  	struct list_head		list;
> +	struct nft_dump_expr		*dump_expr;
>  	u64				handle:42,
>  					genmask:2,
>  					dlen:12,
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index cfa844da1ce61..3e0fc9e8784cb 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -247,6 +247,8 @@ enum nft_chain_attributes {
>   * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
>   * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
>   * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
> + * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
> + * @NFTA_RULE_ACTUAL_EXPR: list of expressions to really use if @NFTA_RULE_EXPRESSIONS must contain a compatible representation of the rule (NLA_NESTED: nft_expr_attributes)
>   */
>  enum nft_rule_attributes {
>  	NFTA_RULE_UNSPEC,
> @@ -261,6 +263,7 @@ enum nft_rule_attributes {
>  	NFTA_RULE_ID,
>  	NFTA_RULE_POSITION_ID,
>  	NFTA_RULE_CHAIN_ID,
> +	NFTA_RULE_ACTUAL_EXPR,
>  	__NFTA_RULE_MAX
>  };
>  #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 6269b0d9977c6..b3a14819f91f8 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3019,7 +3019,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
>  	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
>  				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
>  	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
> -	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
> +	[NFTA_RULE_EXPRESSIONS]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
>  	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
>  	[NFTA_RULE_POSITION]	= { .type = NLA_U64 },
>  	[NFTA_RULE_USERDATA]	= { .type = NLA_BINARY,
> @@ -3027,6 +3027,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
>  	[NFTA_RULE_ID]		= { .type = NLA_U32 },
>  	[NFTA_RULE_POSITION_ID]	= { .type = NLA_U32 },
>  	[NFTA_RULE_CHAIN_ID]	= { .type = NLA_U32 },
> +	[NFTA_RULE_ACTUAL_EXPR]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
>  };
>  
>  static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
> @@ -3064,9 +3065,18 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
>  	if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
>  		nft_flow_rule_stats(chain, rule);
>  
> -	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
> -	if (list == NULL)
> +	if (rule->dump_expr) {
> +		if (nla_put(skb, NFTA_RULE_EXPRESSIONS,
> +			    rule->dump_expr->dlen, rule->dump_expr->data) < 0)
> +			goto nla_put_failure;
> +
> +		list = nla_nest_start_noflag(skb, NFTA_RULE_ACTUAL_EXPR);
> +	} else {
> +		list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
> +	}
> +	if (!list)
>  		goto nla_put_failure;
> +
>  	nft_rule_for_each_expr(expr, next, rule) {
>  		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
>  			goto nla_put_failure;
> @@ -3366,6 +3376,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
>  		nf_tables_expr_destroy(ctx, expr);
>  		expr = next;
>  	}
> +	kfree(rule->dump_expr);
>  	kfree(rule);
>  }
>  
> @@ -3443,7 +3454,9 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	struct nft_rule *rule, *old_rule = NULL;
>  	struct nft_expr_info *expr_info = NULL;
>  	u8 family = info->nfmsg->nfgen_family;
> +	struct nft_dump_expr *dump_expr = NULL;
>  	struct nft_flow_rule *flow = NULL;
> +	const struct nlattr *expr_nla;
>  	struct net *net = info->net;
>  	struct nft_userdata *udata;
>  	struct nft_table *table;
> @@ -3529,14 +3542,15 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  
>  	n = 0;
>  	size = 0;
> -	if (nla[NFTA_RULE_EXPRESSIONS]) {
> +	expr_nla = nla[NFTA_RULE_ACTUAL_EXPR] ?: nla[NFTA_RULE_EXPRESSIONS];
> +	if (expr_nla) {
>  		expr_info = kvmalloc_array(NFT_RULE_MAXEXPRS,
>  					   sizeof(struct nft_expr_info),
>  					   GFP_KERNEL);
>  		if (!expr_info)
>  			return -ENOMEM;
>  
> -		nla_for_each_nested(tmp, nla[NFTA_RULE_EXPRESSIONS], rem) {
> +		nla_for_each_nested(tmp, expr_nla, rem) {
>  			err = -EINVAL;
>  			if (nla_type(tmp) != NFTA_LIST_ELEM)
>  				goto err_release_expr;
> @@ -3556,6 +3570,19 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	if (size >= 1 << 12)
>  		goto err_release_expr;
>  
> +	if (nla[NFTA_RULE_ACTUAL_EXPR]) {
> +		int dlen = nla_len(nla[NFTA_RULE_EXPRESSIONS]);
> +
> +		/* store unused NFTA_RULE_EXPRESSIONS for later */
> +		dump_expr = kvmalloc(sizeof(*dump_expr) + dlen, GFP_KERNEL);
> +		if (!dump_expr) {
> +			err = -ENOMEM;
> +			goto err_release_expr;
> +		}
> +		dump_expr->dlen = dlen;
> +		nla_memcpy(dump_expr->data, nla[NFTA_RULE_EXPRESSIONS], dlen);
> +	}
> +
>  	if (nla[NFTA_RULE_USERDATA]) {
>  		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
>  		if (ulen > 0)
> @@ -3572,6 +3599,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
>  	rule->handle = handle;
>  	rule->dlen   = size;
>  	rule->udata  = ulen ? 1 : 0;
> +	rule->dump_expr = dump_expr;
>  
>  	if (ulen) {
>  		udata = nft_userdata(rule);
> -- 
> 2.38.0
> 
> 
