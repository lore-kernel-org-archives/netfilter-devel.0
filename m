Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F450C4708D
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 20:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLGUzv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 15:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLGUzu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 15:55:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBA7117D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 12:55:49 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p31SE-0002Qu-Pv; Wed, 07 Dec 2022 21:55:46 +0100
Date:   Wed, 7 Dec 2022 21:55:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 08/11] Makefile: Generate .tar.bz2 archive with
 'make dist'
Message-ID: <Y5D90jEMuoGhuiSx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20221207174430.4335-1-phil@nwl.cc>
 <20221207174430.4335-9-phil@nwl.cc>
 <p1286pq3-rprq-p2pq-3172-22p6s42pq3r1@vanv.qr>
 <Y5DhxWh+2qpixI5O@orbyte.nwl.cc>
 <1845617o-3434-5r8r-o0p8-sp96q83rno51@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1845617o-3434-5r8r-o0p8-sp96q83rno51@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 07, 2022 at 08:13:56PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2022-12-07 19:56, Phil Sutter wrote:
> >On Wed, Dec 07, 2022 at 07:45:30PM +0100, Jan Engelhardt wrote:
> >
> >| 984K	iptables-1.8.8.tar.gz
> >| 772K	iptables-1.8.8.tar.bz2
> >| 636K	iptables-1.8.8.tar.xz
> >
> >Moving to LZMA is trivial from a Makefile's point of view, but
> >most packagers will have extra work adjusting for the new file name
> 
> How hard could it be? Surely they'll manage to change _three
> characters_ (or perhaps even ten, to manually run /usr/bin/<thing> if
> there's no suffix autodetection) in their build recipe, right?

Hey, if we're discussing almost negligible size reduction, I want to
discuss almost negligible extra effort, too! :D

Pablo, you're doing the legwork when it comes to releases, what's your
opinion?

Cheers, Phil
