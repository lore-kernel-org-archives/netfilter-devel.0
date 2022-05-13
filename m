Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8962C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 May 2022 17:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351939AbiEMRB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 May 2022 13:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382643AbiEMRAp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 May 2022 13:00:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A66FA546A0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2022 10:00:43 -0700 (PDT)
Date:   Fri, 13 May 2022 19:00:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: do not disable bh during
 destruction
Message-ID: <Yn6OuIAJpz23ns75@salvia>
References: <20220510205324.10160-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220510205324.10160-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 10, 2022 at 10:53:24PM +0200, Florian Westphal wrote:
> After commit
> 12b0b21dc2241 ("netfilter: conntrack: remove unconfirmed list")
> the extra local_bh disable/enable pair is no longer needed.

Squashed into original commit.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0db9c5c94b5b..082a2fd8d85b 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -596,7 +596,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
>  	if (unlikely(nf_ct_protonum(ct) == IPPROTO_GRE))
>  		destroy_gre_conntrack(ct);
>  
> -	local_bh_disable();
>  	/* Expectations will have been removed in clean_from_lists,
>  	 * except TFTP can create an expectation on the first packet,
>  	 * before connection is in the list, so we need to clean here,
> @@ -604,8 +603,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
>  	 */
>  	nf_ct_remove_expectations(ct);
>  
> -	local_bh_enable();
> -
>  	if (ct->master)
>  		nf_ct_put(ct->master);
>  
> -- 
> 2.35.1
> 
