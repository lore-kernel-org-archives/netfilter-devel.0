Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F302C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 20:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A60A20842
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 20:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732028AbgCCUz7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:55:59 -0500
Received: from correo.us.es ([193.147.175.20]:37206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731339AbgCCUz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 15:55:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51968D28C7
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 21:55:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 421A9FC5E9
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2020 21:55:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3732BDA72F; Tue,  3 Mar 2020 21:55:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E344CDA72F;
        Tue,  3 Mar 2020 21:55:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 21:55:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C50D642EE38E;
        Tue,  3 Mar 2020 21:55:40 +0100 (CET)
Date:   Tue, 3 Mar 2020 21:55:54 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] nft: cache: Fix nft_release_cache() under
 stress
Message-ID: <20200303205554.oc5dwigdvje6whed@salvia>
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-2-phil@nwl.cc>
 <20200302191930.5evt74vfrqd7zura@salvia>
 <20200303010252.GB5627@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303010252.GB5627@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 03, 2020 at 02:02:52AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Mar 02, 2020 at 08:19:30PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Mar 02, 2020 at 06:53:55PM +0100, Phil Sutter wrote:
> > > iptables-nft-restore calls nft_action(h, NFT_COMPAT_COMMIT) for each
> > > COMMIT line in input. When restoring a dump containing multiple large
> > > tables, chances are nft_rebuild_cache() has to run multiple times.

It is true that chances that this code runs multiple times since the
new fine-grain caching logic is in place.

> > Then, fix nft_rebuild_cache() please.
> 
> This is not the right place to fix the problem: nft_rebuild_cache()
> simply rebuilds the cache, switching to a secondary instance if not done
> so before to avoid freeing objects referenced from batch jobs.
> 
> When creating batch jobs (e.g., adding a rule or chain), code is not
> aware of which cache instance is currently in use. It will just add
> those objects to nft_handle->cache pointer.
> 
> It is the job of nft_release_cache() to return things back to normal
> after each COMMIT line, which includes restoring nft_handle->cache
> pointer to point at first cache instance.
> 
> If you see a flaw in my reasoning, I'm all ears. Also, if you see a
> better solution, please elaborate - IMO, nft_release_cache() should undo
> what nft_rebuild_cache() may have done. From nft_action() perspective,
> they are related.

Would this patch still work after this series are applied:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=151404

That is working and passing tests. It is just missing the code to
restore the fine grain dumping, that should be easy to add.

That logic will really reduce the chances to exercise all this cache
dump / cache cancel. Bugs in this cache consistency code is usually
not that easy to trigger and usually hard to fix.

I just think it would be a pity if that work ends up in the trash can.
