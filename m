From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] nftables: ct: add byte/packet counter support
Date: Fri, 8 Jan 2016 01:47:27 +0100
Message-ID: <20160108004727.GF23789@breakpoint.cc>
References: <1452198864-10134-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47149 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbcAHAr3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 19:47:29 -0500
Content-Disposition: inline
In-Reply-To: <1452198864-10134-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> If the accounting extension isn't present, we'll return a counter
> value of 0.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  WARNING: It doesn't work, but AFAIU the bug is in nft_cmp which
>  doesn't work with u64 and gt/lt test.  Following is true after 1st packet
>  is sent with enabled accounting:
> 
>  nft add rule filter input ct original packets gt 10
> 
>  Seems like it only works for mark, skuid etc because those are u32 and
>  thus use the _fast_ops version.

I take that back -- nft_cmp is fine, the culprit is lack of cpu_to_be64
in nft.  This works fine with a local patch to nft + nft_byteorder.c.

Problem was nft generated two htonl() calls for upper and lower half of
the counter which then makes nft_cmp behave a bit random ;)

I'll submit fixes soon.
