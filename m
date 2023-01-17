Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB09C6379F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 15:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjAQPwJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 10:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjAQPvt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 10:51:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C3241B78
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 07:50:30 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pHoEF-0003Fp-Pd; Tue, 17 Jan 2023 16:50:27 +0100
Date:   Tue, 17 Jan 2023 16:50:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Message-ID: <Y8bDw54jNb6c/CaO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
References: <20230112225517.31560-1-jengelh@inai.de>
 <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
 <Y8U7wlJxOvWK7Vpw@salvia>
 <r841n676-q68o-son2-s819-8p95s57rn8@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r841n676-q68o-son2-s819-8p95s57rn8@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 16, 2023 at 06:18:34PM +0100, Jan Engelhardt wrote:
> 
> On Monday 2023-01-16 12:57, Pablo Neira Ayuso wrote:
> >On Fri, Jan 13, 2023 at 12:47:30PM +0100, Phil Sutter wrote:
> >
> >IIRC ebtables is using a custom ethertype file, because definitions
> >are different there.
> >
> >But is this installed file used in any way these days?
> 
> Probably not; the version I have has this to say:
> 
> # This list could be found on:
> #         http://www.iana.org/assignments/ethernet-numbers
> #         http://www.iana.org/assignments/ieee-802-numbers
> 
> With such official-ness, ebtables's ethertypes has a rather low priority.

This header statement exists even in legacy ebtables repo' version. I
fear the opposite is the case and everyone's rather copying from ebtables
or iptables just to provide /etc/ethertypes without depending on the
tools.

My local Gentoo install at least has /etc/ethertypes exactly as in
ebtables repo and the package source states "File extracted from the
iptables tarball".

Maybe we're the original source?

Cheers, Phil
