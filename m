Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5778ECD4F49
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Sep 2023 10:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIVK1u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 06:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjIVK1t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 06:27:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0888ABB
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 03:27:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qjdNu-0004yK-N1; Fri, 22 Sep 2023 12:27:42 +0200
Date:   Fri, 22 Sep 2023 12:27:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf] netfilter: nf_tables: nft_set_rbtree: invalidate
 greater range element on removal
Message-ID: <20230922102742.GE17533@breakpoint.cc>
References: <20230921135212.31288-1-fw@strlen.de>
 <ZQ1ohTAB/u2XZRpV@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQ1ohTAB/u2XZRpV@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Main agenda here is to not just fix the spurious failure but to
> > get rid of the async gc worker.
> 
> I would like to move this sync GC collection from insert() path, it is
> sloppy and zapping entries that we hold references to as in this case.
> I would like to move to use the .commit phase just like pipapo.

I can experiment with this next week.

I already have a patch that converts async to sync gc similar to
pipapo but it currently keeps the limited on-demand cycle too.

> The only solution I can see right now is to maintain two copies of the
> rbtree, just like pipapo, then use the .commit phase, I started
> sketching this updates.

I would like to avoid this, see below.

> Meanwhile setting rbe_ge and rbe_le to NULL if the element that is
> referenced is removed makes sense to me.

Great, I will submit this patch formally with a slightly updated
commit message.

> The current GC sync inlined in insert() is also making it hard to
> support for timeout refresh (element update command) without
> reintroducing the _BUSY bit, which is something I would like to skip.

Ugh, yes, no busy bit please.

> Then, there is another possibility that is to provide a hint to
> userspace to use pipapo instead rbtree, via _GENMSG, but there is a
> need to update pipapo to allow for singleton sets (with no
> concatenation), which requires a oneliner in the kernel.
>
> The rbtree set backend is the corner that holds more technical debt
> IMO.

I'm all in favor of getting rid of rbtree where possible.
So we can keep it in-tree with 'acceptable' shortcomings (= no crashes)
but userspace would no longer use it.
