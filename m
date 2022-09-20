Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EADAC6FA82
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 22:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiITWsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 18:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiITWsh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 18:48:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFE04D821
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 15:48:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oam2V-0002qT-Ff; Wed, 21 Sep 2022 00:48:27 +0200
Date:   Wed, 21 Sep 2022 00:48:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Message-ID: <YypDOwT2QaHEgXfS@strlen.de>
References: <20220920212432.4168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920212432.4168-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
> dropping vrf packets by mistake") but for nftables fib expression:
> Add special treatment of VRF devices so that typical reverse path
> filtering via 'fib saddr . iif oif' expression works as expected.
> 
> Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
>  net/ipv6/netfilter/nft_fib_ipv6.c | 7 ++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
> index b75cac69bd7e6..7ade04ff972d7 100644
> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
> @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else
>  		oif = NULL;
>  
> +	if (priv->flags & NFTA_FIB_F_IIF)
> +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
> +
>  	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
>  	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
>  		nft_fib_store_result(dest, priv, nft_in(pkt));
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 8970d0b4faeb4..3f860e331580d 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -170,6 +170,10 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
>  	else if (priv->flags & NFTA_FIB_F_OIF)
>  		oif = nft_out(pkt);
>  
> +	if ((priv->flags & NFTA_FIB_F_IIF) &&
> +	    (netif_is_l3_master(oif) || netif_is_l3_slave(oif)))
> +		fl6.flowi6_oif = oif->ifindex;
> +

I was about to apply this, but this initialisation comes before
nft_fib6_flowi_init(), should this be *after*, or part of
nft_fib6_flowi_init() function instead?
