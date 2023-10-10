Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698FBCD80C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 12:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjJJMsI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 08:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjJJMsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 08:48:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB6D99
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 05:48:05 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qqC9b-0002qP-El; Tue, 10 Oct 2023 14:48:03 +0200
Date:   Tue, 10 Oct 2023 14:48:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZSVIA7v8EyF1cDOx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <ZRxU3+ZWP5JQVm3I@orbyte.nwl.cc>
 <ZRxXXr5H0grbSb9j@calendula>
 <ZRx1omPdNIq5UdRN@orbyte.nwl.cc>
 <ZR0b693BiY6KzD3k@calendula>
 <20231004080702.GD15013@breakpoint.cc>
 <ZR0hFIIqdTixdPi4@calendula>
 <20231004084623.GA9350@breakpoint.cc>
 <ZR0v54xJwllozQhR@calendula>
 <20231004124845.GA3974@breakpoint.cc>
 <ZR13ejv1iBzrzEor@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZR13ejv1iBzrzEor@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 04, 2023 at 04:32:26PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 04, 2023 at 02:48:45PM +0200, Florian Westphal wrote:
> > I also think we need to find a different strategy for the
> > dump-and-reset part when the reset could be interrupted
> > by a transaction.
> 
> I think it should be possible to deal with this from userspace.
> 
> The idea would be to keep the old cache. Then, from the new cache, if
> EINTR happened before, iterate over the list of objects in the new
> cache and then lookup for the old objects, then pour the stats from
> the old to the new objects, then release old cache. Then only one old
> cache is kept around in worst case. This needs a lookup function for
> each stateful object type on the old cache based on the handle.

In case of EINTR, user space will reset multiple times, right? So
returned state from generation X must be combined with that from
generation X+1. Easy with counters (val1 + val2) but funny and/or
inconsistent with quotas (val1 - val2 might be < 0).

I'd still just declare reset command for multiple items unreliable and
point out the need for scripts to use a combination of list command and
a number of reset commands for the individual items if the actual values
matter.

I just noticed, for the above to be viable 'reset rule' command must be
changed - it is silent right now.

Cheers, Phil
