Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06C86E784B3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 14:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbjJBOVs convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 10:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbjJBOVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 10:21:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E695A4
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2023 07:21:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnJnp-00020H-Rc; Mon, 02 Oct 2023 16:21:41 +0200
Date:   Mon, 2 Oct 2023 16:21:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <20231002142141.GA7339@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20231002135838.GB30843@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> > You mean, from the preparation phase? Then we need to undo what has
> > been done, in case of --check / abort path is exercised, this might
> > just create a bogus element listing.
> 
> True.  Am I correct that we can't implement the "expand" via
> del+add because of stateful objects?
> 
> I fear we will need to circle back to rbtree then, I'll followup
> there (wrt. on-demand gc).

Found another corner case, lets assume rhash set to not mix it
with the rbtree issue.

Element E exists and has not timed out yet

Userspace generates:
Refresh timeout of E to <bignum>
<other unrelated stuff, time passes, E expires>
Add E again.  As existing E has timed out already,
this passes...

How to prevent an outcome where E now exists twice?

Variant:
Refresh timeout of E to <bignum>
Delete E

Care has to be taken to not add UAF here.

ATM deletion (unlink) would take effect before the sets' commit
hooks are called, so we refresh timeout of an unlinked element.

AFAICS there won't be UAF because the element memory won't be
released until after mutex unlock and synchronize_rcu, but its
not nice either.
