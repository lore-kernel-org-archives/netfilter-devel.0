Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A2FCDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Oct 2023 19:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbjJMTa4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 15:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbjJMTaz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 15:30:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2569195
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 12:30:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qrNs2-0001cF-Pn; Fri, 13 Oct 2023 21:30:50 +0200
Date:   Fri, 13 Oct 2023 21:30:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,RFC] netfilter: nf_tables: shrink memory
 consumption of set elements
Message-ID: <20231013193050.GC2875@breakpoint.cc>
References: <20231013160924.119273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013160924.119273-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Instead of copying struct nft_set_elem into struct nft_trans_elem, store
> the pointer to the opaque set element object in the transaction. Adapt
> set backend API (and set backend implementations) to take the pointer to
> opaque set element representation whenever required.
> 
> This patch deconstifies .remove() and .activate() set backend API since these
> modify the set element opaque object. And it also constify nft_set_elem_ext()
> since this provides access to the nft_set_ext struct without updating the
> object.
> 
> According to pahole on x86_64, this patch shrinks struct nft_trans_elem
> size from 216 to 24 bytes.
> 
> This patch also reduces stack memory consumption by removing the
> template struct nft_set_elem object which consumes 200 bytes of stack
> memory according to pahole. Use the opaque set element object instead
> from the set iterator API, catchall elements and the get element
> command paths to benefit from this memory consumption reduction.

Is there a request for this? Or is the memory consumption a concern
on your end?

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I tagged this as RFC because it based on nf.git, but targeted at
> nf-next.git, because of missing dependencies, I have kept in here for a
> while in my local pile waiting for the dependencies to land, but I
> prefer to post it now for review. So it cannot be considered for
> integration into the nf-next.git tree yet because of these details.
> 
> This patch depends on ("netfilter: nf_tables: do not remove elements if
> set backend implements .abort") which will take time to propagate to
> nf-next. This also slightly clashes with a other existing pending
> patches for nf-next floating in the mailing list, but that should be
> easy to fix with a rebase.
> 
> I started with an initial patch to make the const updates, but it is
> triggering more churning than expected (since follow up patch will again
> update the same line when changing from struct nft_set_elem to void).
> I believe this patch should be relatively easy to review, but maybe
> that is just my bias.
> 
> Main issue is (and it was still before patch) is that this opaque
> object from the nf_tables frontend is void *, which makes it harder for
> the compiler to catch stupid mistakes such as passing elem instead of
> elem.priv or even &trans->elem, that is, type checking is defeated so
> careful inspection is needed. Instrumention and existing tests also help
> catch issues of course.

The void * is bad, and I dislike that this gets spread.
Could you add a "struct nft_set_elem_priv" that serves
as a proxy object?

All the priv elements would include it as first member,
so we can pass that around instead of void *?
