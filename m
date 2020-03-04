Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07868C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 17:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D868922B48
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 17:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgCDRCn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 12:02:43 -0500
Received: from correo.us.es ([193.147.175.20]:51150 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgCDRCn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 12:02:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2593E11ADC3
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 18:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14F16DA3AB
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 18:02:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 14363DA3A9; Wed,  4 Mar 2020 18:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97012DA7B2;
        Wed,  4 Mar 2020 18:02:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 18:02:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 78E4742EE38E;
        Wed,  4 Mar 2020 18:02:23 +0100 (CET)
Date:   Wed, 4 Mar 2020 18:02:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] nft: cache: Fix nft_release_cache() under
 stress
Message-ID: <20200304170237.nkzhn24cyq7wuchk@salvia>
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-2-phil@nwl.cc>
 <20200302191930.5evt74vfrqd7zura@salvia>
 <20200303010252.GB5627@orbyte.nwl.cc>
 <20200303205554.oc5dwigdvje6whed@salvia>
 <20200304021334.GH5627@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304021334.GH5627@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Mar 04, 2020 at 03:13:34AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Mar 03, 2020 at 09:55:54PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Mar 03, 2020 at 02:02:52AM +0100, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Mon, Mar 02, 2020 at 08:19:30PM +0100, Pablo Neira Ayuso wrote:
> > > > On Mon, Mar 02, 2020 at 06:53:55PM +0100, Phil Sutter wrote:
> > > > > iptables-nft-restore calls nft_action(h, NFT_COMPAT_COMMIT) for each
> > > > > COMMIT line in input. When restoring a dump containing multiple large
> > > > > tables, chances are nft_rebuild_cache() has to run multiple times.
> > 
> > It is true that chances that this code runs multiple times since the
> > new fine-grain caching logic is in place.
> 
> AFAICT, this is not related to granularity of caching logic. The crux is
> that your fix of Florian's concurrency fix in commit f6ad231d698c7
> ("nft: keep original cache in case of ERESTART") ignores the fact that
> cache may have to be rebuilt multiple times. I wasn't aware of it
> either, but knowing that each COMMIT line causes a COMMIT internally
> makes it obvious. Your patch adds code to increment cache_index but none
> to reset it to zero.

Thanks for explaining.

[...]
> > Would this patch still work after this series are applied:
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=151404
> > 
> > That is working and passing tests. It is just missing the code to
> > restore the fine grain dumping, that should be easy to add.
> > 
> > That logic will really reduce the chances to exercise all this cache
> > dump / cache cancel. Bugs in this cache consistency code is usually
> > not that easy to trigger and usually hard to fix.
> > 
> > I just think it would be a pity if that work ends up in the trash can.
> 
> I didn't review those patches yet, but from a quick glance it doesn't
> seem to touch the problematic code around __nft_flush_cache(). Let's
> make a deal: You accept my fix for the existing cache logic and I'll in
> return fix your series if necessary and at least find out what needs to
> be done so it doesn't cause a performance regression.

OK, deal :-)
