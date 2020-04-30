Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0BEC4724C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F0620731
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgD3P0J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgD3P0I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:26:08 -0400
X-Greylist: delayed 5628 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Apr 2020 08:26:08 PDT
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1CAC035494
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 08:26:08 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jUB4h-0008LY-1L; Thu, 30 Apr 2020 17:26:07 +0200
Date:   Thu, 30 Apr 2020 17:26:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/18] iptables: introduce cache evaluation
 phase
Message-ID: <20200430152606.GM15009@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200428121013.24507-1-phil@nwl.cc>
 <20200429213609.GA24368@salvia>
 <20200430135300.GK15009@orbyte.nwl.cc>
 <20200430150831.GA2267@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430150831.GA2267@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Apr 30, 2020 at 05:08:31PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 03:53:00PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> >
> > On Wed, Apr 29, 2020 at 11:36:09PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Apr 28, 2020 at 02:09:55PM +0200, Phil Sutter wrote:
> > > > Hi Pablo,
> > > >
> > > > As promised, here's a revised version of your cache rework series from
> > > > January. It restores performance according to my tests (which are yet to
> > > > be published somewhere) and passes the testsuites.
> > >
> > > I did not test this yet, and I made a few rounds of quick reviews
> > > alrady, but this series LGTM. Thank you for working on this.
> >
> > Cool! Should I push it or do you want to have a closer look first?
> 
> You already took the time to test this, so I think it's fine if you
> push out. Problems can be fixed from master. It would also good a few
> runs to valgrind.

OK, I'll play a bit with valgrind just to be sure and then push it out.

> BTW, this cache consistency check
> 
> commit 200bc399651499f502ac0de45f4d4aa4c9d37ab6
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Fri Mar 13 13:02:12 2020 +0100
> 
>     nft: cache: Fix iptables-save segfault under stress
> 
> is already restored in this series, right?

Yes, IIRC this was the reason why I got a merge conflict upon rebase.
But the problem shouldn't exist with the new logic: We fetch cache just
once, so there is no cache update (and potential cache free) happening
while iterating through chain lists or anything.

Cheers, Phil
