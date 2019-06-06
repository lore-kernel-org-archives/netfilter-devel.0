Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114D4C28D1D
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D2920874
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfFFJmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 05:42:39 -0400
Received: from mail.us.es ([193.147.175.20]:52294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbfFFJmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 05:42:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DEB2CC32CE
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:42:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0E1BDA70A
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:42:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C69E7DA70E; Thu,  6 Jun 2019 11:42:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C70B6DA704;
        Thu,  6 Jun 2019 11:42:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Jun 2019 11:42:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A4A844265A2F;
        Thu,  6 Jun 2019 11:42:34 +0200 (CEST)
Date:   Thu, 6 Jun 2019 11:42:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 00/10] Cache update fix && intra-transaction rule
 references
Message-ID: <20190606094234.3w7denuy7jnmzaoi@salvia>
References: <20190604173158.1184-1-phil@nwl.cc>
 <20190605170541.g4mhpsn7k72qyeso@salvia>
 <20190605192429.GX31548@orbyte.nwl.cc>
 <20190606083612.fluv4hothjsziyqh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606083612.fluv4hothjsziyqh@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 06, 2019 at 10:36:12AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 05, 2019 at 09:24:29PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Jun 05, 2019 at 07:05:41PM +0200, Pablo Neira Ayuso wrote:
> > > Thanks a lot for working on this, I have a few comments.
> > > 
> > > On Tue, Jun 04, 2019 at 07:31:48PM +0200, Phil Sutter wrote:
> > > > Next round of combined cache update fix and intra-transaction rule
> > > > reference support.
> > > 
> > > Patch 1 looks good.
> > > 
> > > > Patch 2 is new, it avoids accidential cache updates when committing a
> > > > transaction containing flush ruleset command and kernel ruleset has
> > > > changed meanwhile.
> > > 
> > > Patch 2: Could you provide an example scenario for this new patch?
> > 
> > Given the sample nft input:
> > 
> > | flush ruleset
> > | add table t
> > | add chain t c
> > | ...
> > 
> > First command causes call of cache_flush(), which updates cache->genid
> > from kernel. Third command causes call to cache_update(). If in between
> > these two another process has committed a change to kernel, kernel's
> > genid has bumped and cache_update() will populate the cache because
> > cache_is_updated() returns false.
> >
> > From the top of my head I don't see where these stray cache entries
> > would lead to spurious errors but it is clearly false behaviour in cache
> > update logic.
> 
> Thanks for explaining, so this is resulting from lack of consistency
> in the cache handling.

Now that there is a single cache_update() call, fetching a consistent
cache like iptables-nft is doing should not too hard, I think this
will be sufficient to fix this scenario.
