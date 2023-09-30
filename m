Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F8BE77361
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Sep 2023 08:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbjI3IKn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Sep 2023 04:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbjI3IKm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Sep 2023 04:10:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673501B3
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Sep 2023 01:10:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qmV3e-0003DY-UZ; Sat, 30 Sep 2023 10:10:38 +0200
Date:   Sat, 30 Sep 2023 10:10:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_rbtree: move sync GC from
 insert path to set->ops->commit
Message-ID: <20230930081038.GB23327@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRdOxs+i1EuC+zoS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> - read spin lock is required for the sync GC to make sure this does
>   not zap entries that are being used from the datapath.

It needs to grab the write spinlock for each rb_erase, plus
the seqcount increase to make sure that parallel lookup doesn't
miss an element in the tree.

> - the full GC batch could be used to amortize the memory allocation
>   (not only two slots as it happens now, I am recycling an existing
>    function).

Yes.

> - ENOMEM on GC sync commit path could be an issue. It is too late to
>   fail. The tree would start collecting expired elements that might
>   duplicate existing, triggering bogus mismatches. In this path the
>   commit_mutex is held, and this set backend does not support for
>   lockless read,

It does.  If lockless doesn't return a match it falls back to readlock.

>   it might be possible to simply grab the spinlock
>   in write mode and release entries inmediately, without requiring the
>   sync GC batch infrastructure that pipapo is using.

Is there evidence that the on-demand GC is a problem?
It only searches in the relevant subtree, it should rarely, if ever,
encounter any expired element.
