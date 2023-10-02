Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC77E784A4
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 08:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbjJBIry (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 04:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbjJBIrx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 04:47:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48D9D9
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 01:47:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnEag-0007qa-RG; Mon, 02 Oct 2023 10:47:46 +0200
Date:   Mon, 2 Oct 2023 10:47:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <20231002084746.GA19898@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRp9YLffVWrb1Wn0@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRp9YLffVWrb1Wn0@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Looking at your series, I don't think we are that far each other, see
> below.

Agree.

> On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> > I've pushed a (not very much tested) version of gc overhaul
> > to passive lookups based on expiry candidates, this removes
> > the need for gc sequence counters.
> 
> This patch ("netfilter: nft_set_rbtree: prefer sync gc to async
> worker")
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/commit/?h=nft_set_gc_query_08&id=edfeb02d758d6a96a3c1c9a483b69e43e5528e87
> 
> goes in the same direction I would like to go with my incomplete patch
> I posted. However:
> 
> +static void nft_rbtree_commit(struct nft_set *set)
> +{
> +	struct nft_rbtree *priv = nft_set_priv(set);
> +
> +	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
> +		nft_rbtree_gc(set);
> +}
> 
> I don't think this time_after_eq() to postpone element removal will
> work. According to Stefano, you cannot store in the rbtree tree
> duplicated elements.

Note that in this series the on-demand part is still in place,
there will be no duplicate elements.

> Same problem already exists for this set backend
> in case a transaction add and delete elements in the same batch.
> Unless we maintain two copies. I understand you don't want to maintain
> the two copies but then this time_after_eq() needs to go away.

I can remove it, I don't think a full traversal (without doing
anything) will be too costly.

> According to what I read it seems we agree on that, the only subtle
> difference between your patch and my incomplete patch is this
> time_after_eq().

Yes, your patch gets rid of on-demand gc, I agree that we cannot
postpone full run in that case.

> > Its vs. nf.git but really should be re-targetted to nf-next, I'll
> > try to do this next week:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/log/?h=nft_set_gc_query_08
> 
> Thanks. The gc sequence removal is a different topic we have been
> discussing for a while.

Yup.  I wanted to explore how much work this is, and it turns
out it gets a lot less ugly of we don't have to hande rbtree and
its end elements.

> Would it be possible to incorrect zap an entry
> with the transaction semantics? I mean:

Nope, should not happen.

> #1 transaction to remove element k in set x y
> #2 flush set x y (removes dead element k)
> #3 add element k to set x y expires 3 minutes
> #4 gc transaction freshly added new element
>
> In this case, no dead flag is set on in this new element k on so GC
> transaction will skip it.

The GC will do lookup, will find the element, will
see its neither dead nor expired so it will be skipped.

At least thats the idea, entries get zapped only
if they are expired or dead (to handle packet path deletion).

> As for the element timeout update semantics, I will catch up in a
> separated email renaming this thread

Thanks!
