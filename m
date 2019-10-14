Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2011C4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 10:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17862084B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 10:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfJNKA7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 06:00:59 -0400
Received: from correo.us.es ([193.147.175.20]:42004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbfJNKA7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 06:00:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 151C0DE392
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 12:00:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 041418E1C0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 12:00:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDBDF4C3C3; Mon, 14 Oct 2019 12:00:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCE7EDA4CA;
        Mon, 14 Oct 2019 12:00:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 14 Oct 2019 12:00:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AAC8342EE38F;
        Mon, 14 Oct 2019 12:00:51 +0200 (CEST)
Date:   Mon, 14 Oct 2019 12:00:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 04/11] nft-cache: Introduce cache levels
Message-ID: <20191014100053.ioovsw2w6pyhzxtb@salvia>
References: <20191011102052.77s5ujrdb3ficddo@salvia>
 <20191011092823.dfzjjxmmgqx63eae@salvia>
 <20191011112452.GS12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011112452.GS12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 11, 2019 at 01:24:52PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Oct 11, 2019 at 11:28:23AM +0200, Pablo Neira Ayuso wrote:
> [...]
> > You could also just parse the ruleset twice in userspace, once to
> > calculate the cache you need and another to actually create the
> > transaction batch and push it into the kernel. That's a bit poor man
> > approach, but it might work. You would need to invoke
> > xtables_restore_parse() twice.
> 
> The problem with parsing twice is having to cache input which may be
> huge for xtables-restore.
> 
> On Fri, Oct 11, 2019 at 12:20:52PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Oct 11, 2019 at 12:09:11AM +0200, Phil Sutter wrote:
> > [...]
> > > Maybe we could go with a simpler solution for now, which is to check
> > > kernel genid again and drop the local cache if it differs from what's
> > > stored. If it doesn't, the current cache is still up to date and we may
> > > just fetch what's missing. Or does that leave room for a race condition?
> > 
> > My concern with this approach is that, in the dynamic ruleset update
> > scenarios, assuming very frequent updates, you might lose race when
> > building the cache in stages. Hence, forcing you to restart from
> > scratch in the middle of the transaction handling.
> 
> In a very busy environment there's always trouble, simply because we
> can't atomically fetch ruleset from kernel and adjust and submit our
> batch. Dealing with that means we're back at xtables-lock.
> 
> > I prefer to calculate the cache that is needed in one go by analyzing
> > the batch, it's simpler. Note that we might lose race still since
> > kernel might tell us we're working on an obsolete generation number ID
> > cache, forcing us to restart.
> 
> My idea for conditional cache reset is based on the assumption that
> conflicts are rare and we want to optimize for non-conflict case. So
> core logic would be:
> 
> 1) fetch kernel genid into genid_start
> 2) if cache level > NFT_CL_NONE and cache genid != genid_start:
>    2a) drop local caches
>    2b) set cache level to NFT_CL_NONE
> 3) call cache fetchers based on cache level and desired level
> 4) fetch kernel genid into genid_end
> 5) if genid_start != genid_end goto 1
> 
> So this is basically the old algorithm but with (2) added. What do you
> think?

Please, make testcases to validate that races don't happen. Debugging
cache inconsistencies is not easy, that's why I like the idea of
calculating the cache first, then build it in one go. I'm fine with
starting with a more simple approach in the short term. Note that
reports from users on these cache inconsistency problems are usually
sparse, which is usually a bit frustrating. I understand a larger
rework might to accomodate the more simple approach will take more
time.
