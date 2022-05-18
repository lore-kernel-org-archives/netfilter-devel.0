Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD33AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 21:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243133AbiERVVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243158AbiERVVg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 17:21:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CD17338A5
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 14:21:34 -0700 (PDT)
Date:   Wed, 18 May 2022 23:21:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: use get_random_u32 instead of prandom
Message-ID: <YoVjWp5NhWIyK7gu@salvia>
References: <20220518181531.92593-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518181531.92593-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 18, 2022 at 08:15:31PM +0200, Florian Westphal wrote:
[...]
> @@ -389,7 +381,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  		break;
>  #endif
>  	case NFT_META_PRANDOM:
> -		*dest = nft_prandom_u32();
> +		*dest = get_random_u32();

get_random_u32() uses a spinlock and it disables irq while my patch
uses per-cpu and bh.

spinlock ok, but disabling irq is not necessary. Also this function is
called from control plane path by most users?
