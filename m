Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021F1C10F03
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB181217D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfDWUrN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:47:13 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59638 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfDWUrN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:47:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hJ2Jr-0003ls-LB; Tue, 23 Apr 2019 22:47:11 +0200
Date:   Tue, 23 Apr 2019 22:47:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: Add ct id support
Message-ID: <20190423204711.iqp5n3meadc3grj5@breakpoint.cc>
References: <20190423201751.8447-1-bmastbergen@untangle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423201751.8447-1-bmastbergen@untangle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 7b717fad6cdc..418a17d2df31 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -178,6 +178,9 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
>  		return;
>  	}
>  #endif
> +	case NFT_CT_ID:
> +		*dest = nf_ct_get_id(ct);
> +		return;

This should perhaps be

if (!nfct_is_confirmed(ct))
	goto err;
*dest = ...

Otherwise we'll need to change nf_ct_get_id() to only
consider immutable properties of nf_conn.

ctnetlink never generates events until conntrack confirmation,
so I think the nfct_is_confirmed() check would be ok.

Other than this this looks great.
