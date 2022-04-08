Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50713C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 23:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiDHX3O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 19:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiDHX3N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 19:29:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7EA3982E
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 16:27:08 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ncy0N-00050g-Ei; Sat, 09 Apr 2022 01:27:04 +0200
Date:   Sat, 9 Apr 2022 01:27:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next PATCH v2 1/5] netfilter: bitwise: keep track of
 bit-length of expressions
Message-ID: <20220408232703.GG7920@breakpoint.cc>
References: <20220404120417.188410-1-jeremy@azazel.net>
 <20220404120417.188410-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404120417.188410-2-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index f590ee1c8a1b..cdace40c6ba0 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -23,6 +23,7 @@ struct nft_bitwise {
>  	struct nft_data		mask;
>  	struct nft_data		xor;
>  	struct nft_data		data;
> +	u8                      nbits;
>  };
>  
>  static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
> @@ -88,6 +89,7 @@ static const struct nla_policy nft_bitwise_policy[NFTA_BITWISE_MAX + 1] = {
>  	[NFTA_BITWISE_XOR]	= { .type = NLA_NESTED },
>  	[NFTA_BITWISE_OP]	= { .type = NLA_U32 },
>  	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
> +	[NFTA_BITWISE_NBITS]	= { .type = NLA_U32 },

NLA_U8?

Atm values > 255 are accepted but silently truncated to u8.
