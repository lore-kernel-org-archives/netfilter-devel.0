Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E9CCE7B08
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 18:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjI1Stk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 14:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjI1Stj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 14:49:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423419D
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 11:49:37 -0700 (PDT)
Received: from [78.30.34.192] (port=36400 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlw4r-003rbY-Lw; Thu, 28 Sep 2023 20:49:35 +0200
Date:   Thu, 28 Sep 2023 20:49:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 1/8] netfilter: nf_tables: Don't allocate
 nft_rule_dump_ctx
Message-ID: <ZRXKvYUATXz1cIDG@calendula>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230928165244.7168-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 06:52:37PM +0200, Phil Sutter wrote:
[...]

This whole chunk below looks like a cleanup to remove one indentation
level? Please add an initial patch for this.

>  static int nf_tables_dump_rules_start(struct netlink_callback *cb)
>  {
> +	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
>  	const struct nlattr * const *nla = cb->data;
> -	struct nft_rule_dump_ctx *ctx = NULL;
>  
> -	if (nla[NFTA_RULE_TABLE] || nla[NFTA_RULE_CHAIN]) {
> -		ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
> -		if (!ctx)
> -			return -ENOMEM;
> +	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
>  
> -		if (nla[NFTA_RULE_TABLE]) {
> -			ctx->table = nla_strdup(nla[NFTA_RULE_TABLE],
> -							GFP_ATOMIC);
> -			if (!ctx->table) {
> -				kfree(ctx);
> -				return -ENOMEM;
> -			}
> -		}
> -		if (nla[NFTA_RULE_CHAIN]) {
> -			ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN],
> -						GFP_ATOMIC);
> -			if (!ctx->chain) {
> -				kfree(ctx->table);
> -				kfree(ctx);
> -				return -ENOMEM;
> -			}
> +	if (nla[NFTA_RULE_TABLE]) {
> +		ctx->table = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
> +		if (!ctx->table)
> +			return -ENOMEM;
> +	}
> +	if (nla[NFTA_RULE_CHAIN]) {
> +		ctx->chain = nla_strdup(nla[NFTA_RULE_CHAIN], GFP_ATOMIC);
> +		if (!ctx->chain) {
> +			kfree(ctx->table);
> +			return -ENOMEM;
>  		}
>  	}
> +	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETRULE_RESET)
> +		ctx->reset = true;
>  
> -	cb->data = ctx;
>  	return 0;
>  }
>  
>  static int nf_tables_dump_rules_done(struct netlink_callback *cb)
>  {
> -	struct nft_rule_dump_ctx *ctx = cb->data;
> +	struct nft_rule_dump_ctx *ctx = (void *)cb->ctx;
>  
> -	if (ctx) {
> -		kfree(ctx->table);
> -		kfree(ctx->chain);
> -		kfree(ctx);
> -	}
> +	kfree(ctx->table);
> +	kfree(ctx->chain);
>  	return 0;
>  }
>  
> -- 
> 2.41.0
> 
