Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804D4CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 12:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbjJQMAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbjJQMAf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 08:00:35 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867CFF1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 05:00:33 -0700 (PDT)
Received: from [78.30.34.192] (port=58246 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qsikO-005Epa-Ug; Tue, 17 Oct 2023 14:00:31 +0200
Date:   Tue, 17 Oct 2023 14:00:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,RFC] netfilter: nf_tables: shrink memory
 consumption of set elements
Message-ID: <ZS53W0G86lv0XFT2@calendula>
References: <20231013160924.119273-1-pablo@netfilter.org>
 <20231013193050.GC2875@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231013193050.GC2875@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 13, 2023 at 09:30:50PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Instead of copying struct nft_set_elem into struct nft_trans_elem, store
> > the pointer to the opaque set element object in the transaction. Adapt
> > set backend API (and set backend implementations) to take the pointer to
> > opaque set element representation whenever required.
> > 
> > This patch deconstifies .remove() and .activate() set backend API since these
> > modify the set element opaque object. And it also constify nft_set_elem_ext()
> > since this provides access to the nft_set_ext struct without updating the
> > object.
> > 
> > According to pahole on x86_64, this patch shrinks struct nft_trans_elem
> > size from 216 to 24 bytes.
> > 
> > This patch also reduces stack memory consumption by removing the
> > template struct nft_set_elem object which consumes 200 bytes of stack
> > memory according to pahole. Use the opaque set element object instead
> > from the set iterator API, catchall elements and the get element
> > command paths to benefit from this memory consumption reduction.
> 
> Is there a request for this? Or is the memory consumption a concern
> on your end?

This takes element transaction from kmalloc-512 pool to kmalloc-128,
elements use a lot of this temporary objects.

> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I tagged this as RFC because it based on nf.git, but targeted at
> > nf-next.git, because of missing dependencies, I have kept in here for a
> > while in my local pile waiting for the dependencies to land, but I
> > prefer to post it now for review. So it cannot be considered for
> > integration into the nf-next.git tree yet because of these details.
> > 
> > This patch depends on ("netfilter: nf_tables: do not remove elements if
> > set backend implements .abort") which will take time to propagate to
> > nf-next. This also slightly clashes with a other existing pending
> > patches for nf-next floating in the mailing list, but that should be
> > easy to fix with a rebase.
> > 
> > I started with an initial patch to make the const updates, but it is
> > triggering more churning than expected (since follow up patch will again
> > update the same line when changing from struct nft_set_elem to void).
> > I believe this patch should be relatively easy to review, but maybe
> > that is just my bias.
> > 
> > Main issue is (and it was still before patch) is that this opaque
> > object from the nf_tables frontend is void *, which makes it harder for
> > the compiler to catch stupid mistakes such as passing elem instead of
> > elem.priv or even &trans->elem, that is, type checking is defeated so
> > careful inspection is needed. Instrumention and existing tests also help
> > catch issues of course.
> 
> The void * is bad, and I dislike that this gets spread.
> Could you add a "struct nft_set_elem_priv" that serves
> as a proxy object?
> 
> All the priv elements would include it as first member,
> so we can pass that around instead of void *?

This is a great idea, I am preparing a v2.
