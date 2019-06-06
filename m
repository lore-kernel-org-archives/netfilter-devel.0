Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0114BC04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 08:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17FA207E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 08:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfFFIgT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 04:36:19 -0400
Received: from mail.us.es ([193.147.175.20]:40332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfFFIgS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 04:36:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD866EA46B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 10:36:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF894DA718
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 10:36:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2D7DDA716; Thu,  6 Jun 2019 10:36:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AAA7DA701;
        Thu,  6 Jun 2019 10:36:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Jun 2019 10:36:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E74594265A31;
        Thu,  6 Jun 2019 10:36:12 +0200 (CEST)
Date:   Thu, 6 Jun 2019 10:36:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 00/10] Cache update fix && intra-transaction rule
 references
Message-ID: <20190606083612.fluv4hothjsziyqh@salvia>
References: <20190604173158.1184-1-phil@nwl.cc>
 <20190605170541.g4mhpsn7k72qyeso@salvia>
 <20190605192429.GX31548@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605192429.GX31548@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 05, 2019 at 09:24:29PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Jun 05, 2019 at 07:05:41PM +0200, Pablo Neira Ayuso wrote:
> > Thanks a lot for working on this, I have a few comments.
> > 
> > On Tue, Jun 04, 2019 at 07:31:48PM +0200, Phil Sutter wrote:
> > > Next round of combined cache update fix and intra-transaction rule
> > > reference support.
> > 
> > Patch 1 looks good.
> > 
> > > Patch 2 is new, it avoids accidential cache updates when committing a
> > > transaction containing flush ruleset command and kernel ruleset has
> > > changed meanwhile.
> > 
> > Patch 2: Could you provide an example scenario for this new patch?
> 
> Given the sample nft input:
> 
> | flush ruleset
> | add table t
> | add chain t c
> | ...
> 
> First command causes call of cache_flush(), which updates cache->genid
> from kernel. Third command causes call to cache_update(). If in between
> these two another process has committed a change to kernel, kernel's
> genid has bumped and cache_update() will populate the cache because
> cache_is_updated() returns false.
>
> From the top of my head I don't see where these stray cache entries
> would lead to spurious errors but it is clearly false behaviour in cache
> update logic.

Thanks for explaining, so this is resulting from lack of consistency
in the cache handling.

> > > Patch 3 is also new: If a transaction fails in kernel, local cache is
> > > incorrect - drop it.
> > 
> > Patch 3 looks good!
> > 
> > Regarding patches 4, 5 and 6. I think we can skip them if we follow
> > the approach described by [1], given there is only one single
> > cache_update() call after that patchset, we don't need to do the
> > "Restore local entries after cache update" logic.
> > 
> > [1] https://marc.info/?l=netfilter-devel&m=155975322308042&w=2
> 
> The question is how we want to treat rule reference by index if cache is
> outdated. We could be nice and recalculate the rule reference which
> would require to rebuild the cache including own additions. We could
> also just refer to the warning in nft.8 and do nothing about it. :)

We can set the generation ID of reference that is used for this batch,
the kernel then bails out with ERESTART so we can rebuild the cache.

However, I think the problem with the index is that it is unreliable
itself for concurrent updates. In that case the rule handle should be
used.

> > > Patch 9 is a new requirement for patch 10 due to relocation of new
> > > functions.
> > > 
> > > Patch 10 was changed, changelog included.
> > 
> > Patch 10 looks fine. However, as said, I would like to avoid the patch
> > dependencies 4, 5 and 6, they are adding more cache_update() calls and
> > I think we should go in the opposite direction to end up with a more
> > simple approach.
> 
> OK, so how to proceed from here? I see you've based your patch series
> upon an earlier version of mine. If you provide me with a clean version,
> I could apply the index reference stuff on top. Or something else?

That would be great.

I'm going to send a v2 for:

http://patchwork.ozlabs.org/patch/1110586/

addressing your feedback, then you can rebase on top.

Thanks!
