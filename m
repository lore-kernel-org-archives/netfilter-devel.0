From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: wrap tracing with a
 static key
Date: Tue, 24 Nov 2015 10:13:32 +0000
Message-ID: <20151124101332.GC2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44466 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752744AbbKXKNg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:13:36 -0500
Content-Disposition: inline
In-Reply-To: <1448359331-12692-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 29a6ca9..dabf5ed 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -138,7 +144,8 @@ next_rule:
>  		if (unlikely(rule->genmask & (1 << gencursor)))
>  			continue;
>  
> -		rulenum++;
> +		if (static_key_false(&nft_trace_enabled))
> +			rulenum++;

This API is deprecated, see Documentation/static-keys.txt.

I'm also wondering if this introduces a race condition on architectures
that don't support jump labels. static_key_slow_inc() simply increases
the ->enabled counter without further synchronization, so this might
happen while we're executing this function and some of the increments
might be skipped.
