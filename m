Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCB9C6FA99
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCJLFJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCJLFI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:05:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD8DF260
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:05:06 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1paaYa-0001Bp-7O; Fri, 10 Mar 2023 12:05:04 +0100
Date:   Fri, 10 Mar 2023 12:05:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Reject invalid chain priority values in user space
Message-ID: <ZAsO4JDiyBuSIYLf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230310001314.16957-1-phil@nwl.cc>
 <ZAr0hLGgIpc1Cg9o@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAr0hLGgIpc1Cg9o@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 10, 2023 at 10:12:36AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Mar 10, 2023 at 01:13:14AM +0100, Phil Sutter wrote:
> > The kernel doesn't accept nat type chains with a priority of -200 or
> > below. Catch this and provide a better error message than the kernel's
> > EOPNOTSUPP.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/evaluate.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index d24f8b66b0de8..af4844c1ef6cc 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -4842,6 +4842,8 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
> >  	}
> >  
> >  	if (chain->flags & CHAIN_F_BASECHAIN) {
> > +		int priority;
> > +
> >  		chain->hook.num = str2hooknum(chain->handle.family,
> >  					      chain->hook.name);
> >  		if (chain->hook.num == NF_INET_NUMHOOKS)
> > @@ -4854,6 +4856,14 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
> >  			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
> >  						   "invalid priority expression %s in this context.",
> >  						   expr_name(chain->priority.expr));
> > +
> 
> maybe get this here to declutter the branch?
> 
>                 mpz_export_data(&priority, chain->priority.expr->value,
>                                 BYTEORDER_HOST_ENDIAN, sizeof(int)));

Will do. Initially I wanted to use mpz_get_si() but it expects a larger
data size. It even works if one casts the return value to int, but I
guess it won't anymore on Big Endian (and is a hack anyway).

> this is in basechain context, so it should be fine.

Yes, indeed. Also the call to evaluate_priority() ensures
chain->priority.expr is as expected.

> > +		if (!strcmp(chain->type.str, "nat") &&
> > +		    (mpz_export_data(&priority, chain->priority.expr->value,
> > +				    BYTEORDER_HOST_ENDIAN, sizeof(int))) &&
> > +		    priority <= -200)
> > +			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
> > +						   "Nat type chains must have a priority value above -200.");
>                                                     ^^^
> 
> I'd suggest lower case 'nat' which is what the user specifies in the
> chain declaration.

I'll rewrite the sentence.

> Thanks for addressing my feedback.

Thanks for the quick review!
