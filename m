Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E6AC05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Jan 2023 12:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjATMSs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Jan 2023 07:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjATMSq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2023 07:18:46 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49C3A7C84D
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2023 04:18:46 -0800 (PST)
Date:   Fri, 20 Jan 2023 13:18:42 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH 1/2 nf,v3] netfilter: nft_set_rbtree: Switch to node list
 walk for overlap detection
Message-ID: <Y8qGopPhPgxVC9Pz@salvia>
References: <20230118111415.208127-1-pablo@netfilter.org>
 <20230118140944.6dad71a7@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118140944.6dad71a7@elisabeth>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 18, 2023 at 02:09:44PM +0100, Stefano Brivio wrote:
> On Wed, 18 Jan 2023 12:14:14 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > ...instead of a tree descent, which became overly complicated in an
> > attempt to cover cases where expired or inactive elements would affect
> > comparisons with the new element being inserted.
> > 
> > Further, it turned out that it's probably impossible to cover all those
> > cases, as inactive nodes might entirely hide subtrees consisting of a
> > complete interval plus a node that makes the current insertion not
> > overlap.
> > 
> > To speed up the overlap check, descent the tree to find a greater
> > element that is closer to the key value to insert. Then walk down the
> > node list for overlap detection. Starting the overlap check from
> > rb_first() unconditionally is slow, it takes 10 times longer due to the
> > full linear traversal of the list.
> > 
> > Moreover, perform garbage collection of expired elements when walking
> > down the node list to avoid bogus overlap reports.
> 
> ...I'm quite convinced it's fine to perform the garbage collection
> *after* we found the first element by descending the tree -- in the
> worst case we include "too many" elements in the tree walk, but never
> too little.

With v4, "the worst case we include too many elements in the tree
walk, but never too little" still stands.

> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

So if you don't mind, I'll carry this tag on v4.

Thanks.
