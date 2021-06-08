Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447ABC47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 09:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E213611BD
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 09:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFHJ6R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 05:58:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56064 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhFHJ6R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 05:58:17 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D411764133;
        Tue,  8 Jun 2021 11:55:11 +0200 (CEST)
Date:   Tue, 8 Jun 2021 11:56:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH v2] netfilter: nft_exthdr: Fix for unsafe packet
 data read
Message-ID: <20210608095621.GA15808@salvia>
References: <20210608094057.24598-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608094057.24598-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 08, 2021 at 11:40:57AM +0200, Phil Sutter wrote:
> While iterating through an SCTP packet's chunks, skb_header_pointer() is
> called for the minimum expected chunk header size. If (that part of) the
> skbuff is non-linear, the following memcpy() may read data past
> temporary buffer '_sch'. Use skb_copy_bits() instead which does the
> right thing in this situation.
> 
> Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - skb_copy_bits() call error handling added
> ---
>  net/netfilter/nft_exthdr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 1b0579cb62d08..7f705b5c09de8 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -327,7 +327,9 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
>  				break;
>  
>  			dest[priv->len / NFT_REG32_SIZE] = 0;
> -			memcpy(dest, (char *)sch + priv->offset, priv->len);
> +			if (skb_copy_bits(pkt->skb, offset + priv->offset,
> +					  dest, priv->len) < 0)
> +				break;

Hm, it looks like tcp exthdt matching has the same problem?

>  			return;
>  		}
>  		offset += SCTP_PAD4(ntohs(sch->length));
> -- 
> 2.31.1
> 
