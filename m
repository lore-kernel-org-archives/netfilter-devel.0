From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] evaluate: fix crash if we add an error format rule
Date: Sat, 14 May 2016 22:05:04 +0200
Message-ID: <20160514200504.GE29941@breakpoint.cc>
References: <1463229815-39269-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44012 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932399AbcENUFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2016 16:05:19 -0400
Content-Disposition: inline
In-Reply-To: <1463229815-39269-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> If we add a such nft rule:
>   nft add rule filter input ip protocol icmp tcp dport 0
> 
> we will always meet the assert condition:
>   nft: evaluate.c:536: resolve_protocol_conflict: Assertion `base < (__PROTO_BASE_MAX - 1)' failed.
>   Aborted (core dumped)
> ---
>  src/evaluate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 53f19b2..c317761 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -533,7 +533,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
>  		list_add_tail(&nstmt->list, &ctx->stmt->list);
>  	}
>  
> -	assert(base < PROTO_BASE_MAX);
> +	assert(base <= PROTO_BASE_MAX);

Right, BASE_MAX is in fact the transport header base.

Applied, thanks!
