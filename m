Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B163EE7849A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 08:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbjJBIVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbjJBIVB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 04:21:01 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53CAC
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 01:20:55 -0700 (PDT)
Received: from [78.30.34.192] (port=57142 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qnEAb-00CRDo-Nt; Mon, 02 Oct 2023 10:20:52 +0200
Date:   Mon, 2 Oct 2023 10:20:48 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <ZRp9YLffVWrb1Wn0@calendula>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231001210816.GA15564@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

Looking at your series, I don't think we are that far each other, see
below.

On Sun, Oct 01, 2023 at 11:08:16PM +0200, Florian Westphal wrote:
> I've pushed a (not very much tested) version of gc overhaul
> to passive lookups based on expiry candidates, this removes
> the need for gc sequence counters.

This patch ("netfilter: nft_set_rbtree: prefer sync gc to async
worker")

https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/commit/?h=nft_set_gc_query_08&id=edfeb02d758d6a96a3c1c9a483b69e43e5528e87

goes in the same direction I would like to go with my incomplete patch
I posted. However:

+static void nft_rbtree_commit(struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+
+	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
+		nft_rbtree_gc(set);
+}

I don't think this time_after_eq() to postpone element removal will
work. According to Stefano, you cannot store in the rbtree tree
duplicated elements. Same problem already exists for this set backend
in case a transaction add and delete elements in the same batch.
Unless we maintain two copies. I understand you don't want to maintain
the two copies but then this time_after_eq() needs to go away.

This patch above to add .commit interface to rbtree basically undoes:

https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/commit/?h=nft_set_gc_query_08&id=ee48e86518d62db058efafb6ec1b9f426c441a9d

so better fix it by adding the .commit interface to the rbtree in
first place?

According to what I read it seems we agree on that, the only subtle
difference between your patch and my incomplete patch is this
time_after_eq().

> Its vs. nf.git but really should be re-targetted to nf-next, I'll
> try to do this next week:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/fwestphal/nf.git/log/?h=nft_set_gc_query_08

Thanks. The gc sequence removal is a different topic we have been
discussing for a while. Would it be possible to incorrect zap an entry
with the transaction semantics? I mean:

#1 transaction to remove element k in set x y
#2 flush set x y (removes dead element k)
#3 add element k to set x y expires 3 minutes
#4 gc transaction freshly added new element

In this case, no dead flag is set on in this new element k on so GC
transaction will skip it.

As for the element timeout update semantics, I will catch up in a
separated email renaming this thread, as this is a new feature and I
prefer to re-focus the conversation on your branch, it has been me
that has been mixing up different topics anyway.
