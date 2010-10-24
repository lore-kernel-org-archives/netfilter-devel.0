From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Sun, 24 Oct 2010 20:25:08 +0200
Message-ID: <20101024182508.GM15247@Chamillionaire.breakpoint.cc>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39701 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab0JXSZK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 14:25:10 -0400
Content-Disposition: inline
In-Reply-To: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao <xiaosuo@gmail.com> wrote:
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  net/netfilter/xt_NFQUEUE.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
> index 039cce1..3962770 100644
> --- a/net/netfilter/xt_NFQUEUE.c
> +++ b/net/netfilter/xt_NFQUEUE.c
> @@ -72,10 +72,12 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
>  
>  	if (info->queues_total > 1) {
>  		if (par->family == NFPROTO_IPV4)
> -			queue = hash_v4(skb) % info->queues_total + queue;
> +			queue = (((u64) hash_v4(skb) * info->queues_total) >>
> +				 32) + queue;

I'd imagine that the result of ((hash * total) >> 32) is (almost)
always zero, especially if total is small (which it is usually).

Did you test that this change does not affect distribution average?
