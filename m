From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Tue, 4 Mar 2014 08:50:29 +0000
Message-ID: <20140304085029.GC5094@macbook.localnet>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38100 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbaCDIud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:50:33 -0500
Content-Disposition: inline
In-Reply-To: <1393881146-12967-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 03, 2014 at 10:12:26PM +0100, Florian Westphal wrote:
> reject did not allow to use tcp reset instead of icmp unreach.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  After this patch its possibe to do something like
> 
>  rule filter output reject reset

Actually this looks a lot like "iptables thinking" :) Why not simply use
"reset" as keyword?

>  Which makes kernel generate bogus tcp resets in repsonse
>  to non-tcp packets.
> 
>  In iptables this is avoided by making checkentry fail if -p tcp is not
>  specified when tcp-reset is requested.
> 
>  How should this be handled in nft?

We could either add some infrastructure to the kernel to mimic the iptables
check, add runtime fallback to ICMP for non-TCP packets or simply ignore them.

It shouldn't be difficult to check within the rule for the required matches,
however I'm not so sure this is really the way to go since it precludes
optimizations that spawn over multiple rules, f.i. checking for TCP before
a chain jump and have only TCP-specific rules in that chain.

I'm tending towards simply ignoring non-TCP packets at runtime.

>  %token _REJECT			"reject"
> +%token REJECT_RESET		"reset"
> +%token REJECT_UNREACH		"unreach"

Please don't use expression/statement-specific token names. We're simply
dealing with tokens, how they're used depends on the remaining grammar.
