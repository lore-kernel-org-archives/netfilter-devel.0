Return-Path: <SRS0=xF+Z=3Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6BFC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 13:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BFD520702
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jan 2020 13:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgA0NYu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 08:24:50 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:50086 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgA0NYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 08:24:50 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iw4Nk-0004XC-FR; Mon, 27 Jan 2020 14:24:48 +0100
Date:   Mon, 27 Jan 2020 14:24:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Fix for potential NULL-pointer deref in
 ei_insert()
Message-ID: <20200127132448.GC28318@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200120162540.9699-1-phil@nwl.cc>
 <20200120162540.9699-4-phil@nwl.cc>
 <20200121125612.6kmvuazs6bmarhir@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121125612.6kmvuazs6bmarhir@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jan 21, 2020 at 01:56:12PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 20, 2020 at 05:25:39PM +0100, Phil Sutter wrote:
> > Covscan complained about potential deref of NULL 'lei' pointer,
> > Interestingly this can't happen as the relevant goto leading to that
> > (in line 260) sits in code checking conflicts between new intervals and
> > since those are sorted upon insertion, only the lower boundary may
> > conflict (or both, but that's covered before).
> > 
> > Given the needed investigation to proof covscan wrong and the actually
> > wrong (but impossible) code, better fix this as if element ordering was
> > arbitrary to avoid surprises if at some point it really becomes that.
> > 
> > Fixes: 4d6ad0f310d6c ("segtree: check for overlapping elements at insertion")
> 
> Not fixing anything. Tell them to fix covscan :-)

Well, I guess covscan is simply not intelligent enough to detect the
impact of previous element sorting. :)

Please see my follow-up series which changes the code to actually make
use of the sorted input data. As noted in its cover letter, the code may
change again if we implement merging new with existing elements.
Depending on actual implementation, a completely different logic may be
required then since "changed" existing elements have to be recorded (so
their original version is removed from kernel).

Cheers, Phil
