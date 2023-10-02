Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7CEE784AF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 10:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbjJBKY1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 06:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbjJBKY1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 06:24:27 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C11B0
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 03:24:23 -0700 (PDT)
Received: from [78.30.34.192] (port=38632 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnG67-00D62L-1L; Mon, 02 Oct 2023 12:24:21 +0200
Date:   Mon, 2 Oct 2023 12:24:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <ZRqaUeeYYKm4Eis1@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRp9YLffVWrb1Wn0@calendula>
 <20231002084746.GA19898@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231002084746.GA19898@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 02, 2023 at 10:47:46AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Looking at your series, I don't think we are that far each other, see
> > below.
> 
> Agree.
> 
> > On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> > > I've pushed a (not very much tested) version of gc overhaul
> > > to passive lookups based on expiry candidates, this removes
> > > the need for gc sequence counters.
> > 
> > This patch ("netfilter: nft_set_rbtree: prefer sync gc to async
> > worker")
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/commit/?h=nft_set_gc_query_08&id=edfeb02d758d6a96a3c1c9a483b69e43e5528e87
> > 
> > goes in the same direction I would like to go with my incomplete patch
> > I posted. However:
> > 
> > +static void nft_rbtree_commit(struct nft_set *set)
> > +{
> > +	struct nft_rbtree *priv = nft_set_priv(set);
> > +
> > +	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
> > +		nft_rbtree_gc(set);
> > +}
> > 
> > I don't think this time_after_eq() to postpone element removal will
> > work. According to Stefano, you cannot store in the rbtree tree
> > duplicated elements.
> 
> Note that in this series the on-demand part is still in place,
> there will be no duplicate elements.

Right.

> > Same problem already exists for this set backend
> > in case a transaction add and delete elements in the same batch.
> > Unless we maintain two copies. I understand you don't want to maintain
> > the two copies but then this time_after_eq() needs to go away.
> 
> I can remove it, I don't think a full traversal (without doing
> anything) will be too costly.

OK, so what is your proposal to move on?

> > According to what I read it seems we agree on that, the only subtle
> > difference between your patch and my incomplete patch is this
> > time_after_eq().
> 
> Yes, your patch gets rid of on-demand gc, I agree that we cannot
> postpone full run in that case.

Yes.

> > > Its vs. nf.git but really should be re-targetted to nf-next, I'll
> > > try to do this next week:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/log/?h=nft_set_gc_query_08
> > 
> > Thanks. The gc sequence removal is a different topic we have been
> > discussing for a while.
> 
> Yup.  I wanted to explore how much work this is, and it turns
> out it gets a lot less ugly of we don't have to hande rbtree and
> its end elements.

OK.

> > Would it be possible to incorrect zap an entry
> > with the transaction semantics? I mean:
> 
> Nope, should not happen.
> 
> > #1 transaction to remove element k in set x y
> > #2 flush set x y (removes dead element k)
> > #3 add element k to set x y expires 3 minutes
> > #4 gc transaction freshly added new element
> >
> > In this case, no dead flag is set on in this new element k on so GC
> > transaction will skip it.
> 
> The GC will do lookup, will find the element, will
> see its neither dead nor expired so it will be skipped.
>
> At least thats the idea, entries get zapped only
> if they are expired or dead (to handle packet path deletion).

Agreed, it is an extra lookup, but it is safer approach.

Thanks.
