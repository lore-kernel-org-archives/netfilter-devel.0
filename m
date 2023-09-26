Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF5BE7E649
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 15:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjIZPtT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 11:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjIZPtT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 11:49:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4039E11F
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 08:49:12 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlAJC-0004jl-NH; Tue, 26 Sep 2023 17:49:10 +0200
Date:   Tue, 26 Sep 2023 17:49:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3] netlink_linearize: skip set element expression
 in map statement key
Message-ID: <ZRL9dlPZbt9pVir5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230926152500.30571-1-pablo@netfilter.org>
 <20230926152500.30571-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926152500.30571-3-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 05:25:00PM +0200, Pablo Neira Ayuso wrote:
> This fix is similar to 22d201010919 ("netlink_linearize: skip set element
> expression in set statement key") to fix map statement.
> 
> netlink_gen_map_stmt() relies on the map key, that is expressed as a set
> element. Use the set element key instead to skip the set element wrap,
> otherwise get_register() abort execution:
> 
>   nft: netlink_linearize.c:650: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
> 
> Reported-by: Luci Stanescu <luci@cnix.ro>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds map stmt printing and parsing support to JSON, but not a
word about that in the commit message. Did this slip in by accident
(e.g.  'git commit -a')? Anyway, I think it should go into a separate
patch.

[...]
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 53a318aa2e62..99ed9f387a81 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -1585,13 +1585,13 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
>  	int num_stmts = 0;
>  	struct stmt *this;
>  
> -	sreg_key = get_register(ctx, stmt->map.key);
> -	netlink_gen_expr(ctx, stmt->map.key, sreg_key);
> +	sreg_key = get_register(ctx, stmt->set.key->key);
> +	netlink_gen_expr(ctx, stmt->set.key->key, sreg_key);
>  
>  	sreg_data = get_register(ctx, stmt->map.data);
>  	netlink_gen_expr(ctx, stmt->map.data, sreg_data);
>  
> -	release_register(ctx, stmt->map.key);
> +	release_register(ctx, stmt->set.key->key);
>  	release_register(ctx, stmt->map.data);
>  
>  	nle = alloc_nft_expr("dynset");

Any particular reason why this doesn't just use stmt->map.key->key? The
first two fields in structs set_stmt and map_stmt are identical, so the
above works "by accident".

Cheers, Phil
