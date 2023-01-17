Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E72CC6379F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 16:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjAQQEu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 11:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjAQQEp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 11:04:45 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCF303CE15
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 08:04:43 -0800 (PST)
Date:   Tue, 17 Jan 2023 17:04:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Message-ID: <Y8bHGL+CIfiuvpAr@salvia>
References: <20230112225517.31560-1-jengelh@inai.de>
 <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
 <Y8U7wlJxOvWK7Vpw@salvia>
 <r841n676-q68o-son2-s819-8p95s57rn8@vanv.qr>
 <Y8bDw54jNb6c/CaO@orbyte.nwl.cc>
 <Y8bFM/p4gWvdJMaM@salvia>
 <Y8bGxk6lfqtLUfQR@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8bGxk6lfqtLUfQR@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 17, 2023 at 05:03:18PM +0100, Phil Sutter wrote:
> On Tue, Jan 17, 2023 at 04:56:35PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 17, 2023 at 04:50:27PM +0100, Phil Sutter wrote:
> > > On Mon, Jan 16, 2023 at 06:18:34PM +0100, Jan Engelhardt wrote:
> > > > 
> > > > On Monday 2023-01-16 12:57, Pablo Neira Ayuso wrote:
> > > > >On Fri, Jan 13, 2023 at 12:47:30PM +0100, Phil Sutter wrote:
> > > > >
> > > > >IIRC ebtables is using a custom ethertype file, because definitions
> > > > >are different there.
> > > > >
> > > > >But is this installed file used in any way these days?
> > > > 
> > > > Probably not; the version I have has this to say:
> > > > 
> > > > # This list could be found on:
> > > > #         http://www.iana.org/assignments/ethernet-numbers
> > > > #         http://www.iana.org/assignments/ieee-802-numbers
> > > > 
> > > > With such official-ness, ebtables's ethertypes has a rather low priority.
> > > 
> > > This header statement exists even in legacy ebtables repo' version. I
> > > fear the opposite is the case and everyone's rather copying from ebtables
> > > or iptables just to provide /etc/ethertypes without depending on the
> > > tools.
> > > 
> > > My local Gentoo install at least has /etc/ethertypes exactly as in
> > > ebtables repo and the package source states "File extracted from the
> > > iptables tarball".
> > > 
> > > Maybe we're the original source?
> > 
> > In ebtables, there _PATH_ETHERTYPES which is indirectly used by
> > getethertypebyname() by a few extensions.
> > 
> > In iptables, this code exists too, using a different definition:
> > 
> > include/xtables.h:#define XT_PATH_ETHERTYPES     "/etc/ethertypes"
> > 
> > extensions/libebt_arp.c:                        ent = xtables_getethertypebyname(argv[optind - 1]);
> > extensions/libebt_vlan.c:                       ethent = xtables_getethertypebyname(optarg);
> > 
> > It seems this file is required by a few extensions and the translation
> > infrastructure.
> 
> Thanks for investigating. I guess dropping a file we depend on to exist
> *and* introduced in the first place is shooting one's own foot with
> extra steps. Also packagers are used to ignore the file (if not needed)
> already. :)

TBH, I thought this was too a left-over, it is good to revisit stuff.
