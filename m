From: Florian Westphal <fw@strlen.de>
Subject: Re: nft: meta l4proto range printing broken on 32bit
Date: Thu, 16 Jul 2015 22:29:49 +0200
Message-ID: <20150716202949.GM25674@breakpoint.cc>
References: <20150716133929.GK25674@breakpoint.cc>
 <20150716165405.GA4140@salvia>
 <20150716165437.GA6590@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56556 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbbGPU3v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2015 16:29:51 -0400
Content-Disposition: inline
In-Reply-To: <20150716165437.GA6590@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jul 16, 2015 at 06:54:05PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jul 16, 2015 at 03:39:29PM +0200, Florian Westphal wrote:
> > > Hi Pablo
> > > 
> > > 09565a4b1ed4863d44c4509a93c50f44efd12771
> > > (netlink_delinearize: consolidate range printing) causes nft
> > > to segfault on 32bit machine when printing l4proto ranges.
> > > 
> > > The problem is that meta_expr_pctx_update() assumes that
> > > right is a value, but after this change it can also be a value.
> > > 
> > > Thus, expr->value contents are undefined (its union).
> > > On x86_64 this is also broken but by virtue of struct layout
> > > and pointer sizes, value->_mp_size will almost always be 0
> > > so mpz_get_uint8() returns 0.
> > > 
> > > But on x86-32 _mp_size will be huge value (contains expr->right pointer
> > > of range), so we crash in libgmp.
> > 
> > Good catch. Could you give a try to this patch instead?
> > 
> > We shouldn't call pctx_update(), before the transformation we had
> > there a expr->op == { OP_GT, OP_GTE, OP_LT, OP_LTE }. So we never
> > entered that path as the assert in payload_expr_pctx_update()
> > indicates.
> 
> Forgot patch, here it comes.

> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 6d60be3..4226b82 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -983,6 +983,9 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
>  
>  	switch (expr->op) {
>  	case OP_EQ:
> +		if (expr->right->ops->type == EXPR_RANGE)
> +			break;
> +
>  		expr->left->ops->pctx_update(&ctx->pctx, expr);
>  

Right thats better -- and it also avoids the crash.

nft testsuite now passes with a few warnings and no crashes.

Thanks!
