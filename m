Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB42E75436
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 09:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239434AbjJCJEQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 05:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239412AbjJCJEP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 05:04:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BED9E
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 02:04:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnbK6-0000S3-2Q; Tue, 03 Oct 2023 11:04:10 +0200
Date:   Tue, 3 Oct 2023 11:04:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: update element timeout support [was Re: [PATCH nf 1/2]
 netfilter: nft_set_rbtree: move sync GC from insert path to
 set->ops->commit]
Message-ID: <20231003090410.GA446@breakpoint.cc>
References: <20230929164404.172081-1-pablo@netfilter.org>
 <ZRdOxs+i1EuC+zoS@calendula>
 <20230930081038.GB23327@breakpoint.cc>
 <ZRnSGwk40jpUActD@calendula>
 <20231001210816.GA15564@breakpoint.cc>
 <ZRq6oP2/hns1qoaq@calendula>
 <20231002135838.GB30843@breakpoint.cc>
 <20231002142141.GA7339@breakpoint.cc>
 <ZRvPSw5PGFyt7S10@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRvPSw5PGFyt7S10@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> I am collecting here your comments for the model we are defining for
> set elements:
> 
> https://people.netfilter.org/pablo/setelems-timeout.txt

LGTM.  I think your proposal to snapshot current time and
remove the "moving target" is key.

> Let me know if you have more possible scenarios that you think that
> might not be address by this model:
> 
> - Annotate current time at the beginning of the transaction, use it
>   in _expired() check (=> timeout is not a moving target anymore).
> - Annotate element timeout update in transaction, update timeout from
>   _commit() path not to refresh it.

Right, I think that will work.
For rbtree, sync gc is kept in place, elements are not zapped,
they get tagged as DEAD, including the end element.

Then from commit, do full scan and remove any and all elements
that are flagged as DEAD or have expired.
