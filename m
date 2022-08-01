Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C56C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 11:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiHAL2k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 07:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiHAL2j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 07:28:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04C5226
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 04:28:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oITb9-0007vD-GV; Mon, 01 Aug 2022 13:28:35 +0200
Date:   Mon, 1 Aug 2022 13:28:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/7] netlink_delinearize: postprocess binary ands in
 set expressions
Message-ID: <20220801112835.GB29493@breakpoint.cc>
References: <20220727112003.26022-1-fw@strlen.de>
 <20220727112003.26022-3-fw@strlen.de>
 <YuekXoqvZkGdQJRJ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuekXoqvZkGdQJRJ@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Wed, Jul 27, 2022 at 01:19:58PM +0200, Florian Westphal wrote:
> [..]
> > diff --git a/include/netlink.h b/include/netlink.h
> > index e8e0f68ae1a4..2d5532387c0c 100644
> > --- a/include/netlink.h
> > +++ b/include/netlink.h
> [...]
> > @@ -2569,6 +2582,24 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
> >  			expr_set_type(expr->right, &integer_type,
> >  				      BYTEORDER_HOST_ENDIAN);
> >  			break;
> > +		case OP_AND:
> > +			expr_set_type(expr->right, expr->left->dtype,
> > +				      expr->left->byteorder);
> > +
> > +			/* Only process OP_AND if we are inside a concatenation.
> > +			 *
> > +			 * Else, we remove it too early, for normal contect OP_AND
> > +			 * removal needs to be performed as part of the relational
> > +			 * operation because the RHS constant might need to be adjusted
> > +			 * (shifted).
> > +			 */
> > +			if ((ctx->flags & RULE_PP_IN_CONCATENATION) &&
> > +			    expr->left->etype == EXPR_PAYLOAD &&
> > +			    expr->right->etype == EXPR_VALUE) {
> > +				__binop_postprocess(ctx, expr, expr->left, expr->right, exprp);
> > +				return;
> > +			}
> > +			break;
> 
> Not sure this flag is enough. If I load this ruleset
> 
>  table netdev nt {
>        set macset {
>                typeof vlan id
>                size 1024
>                flags dynamic,timeout
>        }
>         chain y {
>         }
>  }
>  add rule netdev nt y update @macset { vlan id timeout 5s }
> 
> listing still shows the raw expression:
> 
>  table netdev nt {
>         set macset {
>                 typeof vlan id
>                 size 1024
>                 flags dynamic,timeout
>         }
> 
>         chain y {
>                 update @macset { @ll,112,16 & 0xfff timeout 5s }
>         }
>  }
> 
> looks like the problem is related to expressions in set statements?

Good catch, I added a patch to the series that also enabled OP_AND
removal for the set elem key case.

I took the above and added it to the test case.
