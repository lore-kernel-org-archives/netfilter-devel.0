From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: meta: secpath support
Date: Fri, 1 Dec 2017 13:40:43 +0100
Message-ID: <20171201124043.GC27820@breakpoint.cc>
References: <20171201124021.20973-1-fw@strlen.de>
 <20171201124021.20973-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40886 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752124AbdLAMl5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 07:41:57 -0500
Content-Disposition: inline
In-Reply-To: <20171201124021.20973-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> +int nft_meta_get_validate(const struct nft_ctx *ctx,
> +			  const struct nft_expr *expr,
> +			  const struct nft_data **data)

Sigh, this should be static of course.
I will not send a v2 for now.
