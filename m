Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13549C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 11:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E2A20851
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 11:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfCALAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:00:03 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:32772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727932AbfCALAD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 06:00:03 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gzftY-0002be-6Q; Fri, 01 Mar 2019 12:00:00 +0100
Date:   Fri, 1 Mar 2019 12:00:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     pablo@netfilter.org, arturo@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for
 NFT_META_TSTAMP_NS
Message-ID: <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
References: <20190301104331.GA26805@nebula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301104331.GA26805@nebula>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Karuna Grewal <karunagrewal98@gmail.com> wrote:
> Meta evaluation function is extended to suport NFT_META_TSTAMP_NS option
> by exposing the 64 bit timestamp of the packet to two 32 bit registers.

Please test patches first, see below.

> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 987d2d6ce624..adfa1f221946 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -254,6 +254,13 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  			goto err;
>  		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
>  		break;
> +	case NFT_META_TSTAMP_NS:
> +		if (skb->tstamp == 0)
> +			__net_timestamp((struct sk_buff *)skb);
> +		u64 timestamp = ktime_to_ns(skb->tstamp);
> +		*dest = (u32)(timestamp >> 32);
> +		*(dest + 1) = (u32) timestamp;
> +		break;

Please consider using u64 *dest64 or similar to avoid the need for
shifting.

>  	default:
>  		WARN_ON(1);
>  		goto err;
> @@ -371,6 +378,8 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>  		len = IFNAMSIZ;
>  		break;
>  #endif
> +	case NFT_META_TSTAMP_NS:
> +		len = sizeof(u64);
>  	default:
>  		return -EOPNOTSUPP;

This is missing a break statement after len assignment.

Other than this, this patch looks good.  Please consider sending v3 once
you have nftables patches ready as well.
