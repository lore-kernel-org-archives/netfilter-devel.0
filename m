Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19C8CE7B1B
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 18:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjI1SxS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 14:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjI1SxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 14:53:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2EB195
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 11:53:15 -0700 (PDT)
Received: from [78.30.34.192] (port=36408 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlw8N-003uHx-Rk; Thu, 28 Sep 2023 20:53:13 +0200
Date:   Thu, 28 Sep 2023 20:53:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 7/8] netfilter: nf_tables: Pass reset bit in
 nft_set_dump_ctx
Message-ID: <ZRXLlwkeCBWgXqGZ@calendula>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-8-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230928165244.7168-8-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 06:52:43PM +0200, Phil Sutter wrote:
> Relieve the dump callback from having to check nlmsg_type upon each
> call. Prep work for set element reset locking.

Maybe add this as a preparation patch first place in this series,
rather making this cleanup at this late stage of the batch.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - New patch
> ---
>  net/netfilter/nf_tables_api.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f154fcc341421..1491d4c65fed9 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5731,6 +5731,7 @@ static void audit_log_nft_set_reset(const struct nft_table *table,
>  struct nft_set_dump_ctx {
>  	const struct nft_set	*set;
>  	struct nft_ctx		ctx;
> +	bool			reset;
>  };
>  
>  static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
> @@ -5770,7 +5771,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  	bool set_found = false;
>  	struct nlmsghdr *nlh;
>  	struct nlattr *nest;
> -	bool reset = false;
>  	u32 portid, seq;
>  	int event;
>  
> @@ -5818,12 +5818,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  	if (nest == NULL)
>  		goto nla_put_failure;
>  
> -	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
> -		reset = true;
> -
>  	args.cb			= cb;
>  	args.skb		= skb;
> -	args.reset		= reset;
> +	args.reset		= dump_ctx->reset;
>  	args.iter.genmask	= nft_genmask_cur(net);
>  	args.iter.skip		= cb->args[0];
>  	args.iter.count		= 0;
> @@ -5833,11 +5830,11 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
>  
>  	if (!args.iter.err && args.iter.count == cb->args[0])
>  		args.iter.err = nft_set_catchall_dump(net, skb, set,
> -						      reset, cb->seq);
> +						      dump_ctx->reset, cb->seq);
>  	nla_nest_end(skb, nest);
>  	nlmsg_end(skb, nlh);
>  
> -	if (reset && args.iter.count > args.iter.skip)
> +	if (dump_ctx->reset && args.iter.count > args.iter.skip)
>  		audit_log_nft_set_reset(table, cb->seq,
>  					args.iter.count - args.iter.skip);
>  
> @@ -6088,6 +6085,9 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  
>  	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
>  
> +	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
> +		reset = true;
> +
>  	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
>  		struct netlink_dump_control c = {
>  			.start = nf_tables_dump_set_start,
> @@ -6098,6 +6098,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  		struct nft_set_dump_ctx dump_ctx = {
>  			.set = set,
>  			.ctx = ctx,
> +			.reset = reset,
>  		};
>  
>  		c.data = &dump_ctx;
> @@ -6107,9 +6108,6 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
>  	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
>  		return -EINVAL;
>  
> -	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETSETELEM_RESET)
> -		reset = true;
> -
>  	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
>  		err = nft_get_set_elem(&ctx, set, attr, reset);
>  		if (err < 0) {
> -- 
> 2.41.0
> 
