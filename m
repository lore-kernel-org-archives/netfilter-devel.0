Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E16BC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 02:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 518952073B
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 02:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgCDCNg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:13:36 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:56646 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgCDCNg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 21:13:36 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j9JXS-0007wU-ME; Wed, 04 Mar 2020 03:13:34 +0100
Date:   Wed, 4 Mar 2020 03:13:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] nft: cache: Fix nft_release_cache() under
 stress
Message-ID: <20200304021334.GH5627@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-2-phil@nwl.cc>
 <20200302191930.5evt74vfrqd7zura@salvia>
 <20200303010252.GB5627@orbyte.nwl.cc>
 <20200303205554.oc5dwigdvje6whed@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303205554.oc5dwigdvje6whed@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Mar 03, 2020 at 09:55:54PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2020 at 02:02:52AM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Mon, Mar 02, 2020 at 08:19:30PM +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Mar 02, 2020 at 06:53:55PM +0100, Phil Sutter wrote:
> > > > iptables-nft-restore calls nft_action(h, NFT_COMPAT_COMMIT) for each
> > > > COMMIT line in input. When restoring a dump containing multiple large
> > > > tables, chances are nft_rebuild_cache() has to run multiple times.
> 
> It is true that chances that this code runs multiple times since the
> new fine-grain caching logic is in place.

AFAICT, this is not related to granularity of caching logic. The crux is
that your fix of Florian's concurrency fix in commit f6ad231d698c7
("nft: keep original cache in case of ERESTART") ignores the fact that
cache may have to be rebuilt multiple times. I wasn't aware of it
either, but knowing that each COMMIT line causes a COMMIT internally
makes it obvious. Your patch adds code to increment cache_index but none
to reset it to zero.

> > > Then, fix nft_rebuild_cache() please.
> > 
> > This is not the right place to fix the problem: nft_rebuild_cache()
> > simply rebuilds the cache, switching to a secondary instance if not done
> > so before to avoid freeing objects referenced from batch jobs.
> > 
> > When creating batch jobs (e.g., adding a rule or chain), code is not
> > aware of which cache instance is currently in use. It will just add
> > those objects to nft_handle->cache pointer.
> > 
> > It is the job of nft_release_cache() to return things back to normal
> > after each COMMIT line, which includes restoring nft_handle->cache
> > pointer to point at first cache instance.
> > 
> > If you see a flaw in my reasoning, I'm all ears. Also, if you see a
> > better solution, please elaborate - IMO, nft_release_cache() should undo
> > what nft_rebuild_cache() may have done. From nft_action() perspective,
> > they are related.
> 
> Would this patch still work after this series are applied:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=151404
> 
> That is working and passing tests. It is just missing the code to
> restore the fine grain dumping, that should be easy to add.
> 
> That logic will really reduce the chances to exercise all this cache
> dump / cache cancel. Bugs in this cache consistency code is usually
> not that easy to trigger and usually hard to fix.
> 
> I just think it would be a pity if that work ends up in the trash can.

I didn't review those patches yet, but from a quick glance it doesn't
seem to touch the problematic code around __nft_flush_cache(). Let's
make a deal: You accept my fix for the existing cache logic and I'll in
return fix your series if necessary and at least find out what needs to
be done so it doesn't cause a performance regression.

I don't veto against or sabotage your approach of separating caching
from parsing, but completing your series regarding performance as an
alternative assuming it fixes the existing bug at all is not feasible.
Therefore please let's go with a fix first and commit to cache logic
rewrite as illustrated in your patches.

Cheers, Phil
