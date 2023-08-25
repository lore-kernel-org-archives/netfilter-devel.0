Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD40C71153
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjHYDLT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 23:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbjHYDLO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 23:11:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79271995
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 20:11:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qZNE6-0003Gy-C7; Fri, 25 Aug 2023 05:11:10 +0200
Date:   Fri, 25 Aug 2023 05:11:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xiao Liang <shaw.leon@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_exthdr: Fix non-linear header
 modification
Message-ID: <20230825031110.GA9265@breakpoint.cc>
References: <20230825021432.6053-1-shaw.leon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825021432.6053-1-shaw.leon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xiao Liang <shaw.leon@gmail.com> wrote:
> nft_tcp_header_pointer() may copy TCP header if it's not linear.
> In that case, we should modify the packet rather than the buffer, after
> proper skb_ensure_writable().

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")

I do not understand this changelog.

The bug is that skb_ensure_writable() size is too small, hence
nft_tcp_header_pointer() may return a pointer to local stack
buffer.

> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
>  net/netfilter/nft_exthdr.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 7f856ceb3a66..2189ccc1119c 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -254,13 +254,12 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
>  			goto err;
>  
>  		if (skb_ensure_writable(pkt->skb,
> -					nft_thoff(pkt) + i + priv->len))
> +					nft_thoff(pkt) + i + priv->offset +
> +					priv->len))

[..]

> -		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
> -					      &tcphdr_len);
> -		if (!tcph)
> -			goto err;
> +		tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
> +		opt = (u8 *)tcph;

This modification is not related to the bug?

If you think this is better, then please say that the 'do not use
nft_tcp_header_pointer' is an unrelated cleanup in the commit message.

But I would prefer to not mix functional and non-functional changes.
Also, the use of the nft_tcp_header_pointer() helper is the reason why
this doesn't result in memory corruption.

> @@ -325,9 +324,9 @@ static void nft_exthdr_tcp_strip_eval(const struct nft_expr *expr,
>  	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))

Just use the above in nft_exthdr_tcp_set_eval and place it before the loop?
