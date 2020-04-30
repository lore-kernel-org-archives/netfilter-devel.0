Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA381C4724C
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 16:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAEF2076D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 16:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD3QBW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgD3QBW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 12:01:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23CC035494
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 09:01:21 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jUBcm-0000eJ-KX; Thu, 30 Apr 2020 18:01:20 +0200
Date:   Thu, 30 Apr 2020 18:01:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Merge get_set_interval_find() and
 get_set_interval_end()
Message-ID: <20200430160120.GT15009@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200430151408.32283-1-phil@nwl.cc>
 <20200430151408.32283-4-phil@nwl.cc>
 <20200430153729.GA3602@salvia>
 <20200430154841.GP15009@orbyte.nwl.cc>
 <20200430155218.GA4214@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430155218.GA4214@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 05:52:18PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 05:48:42PM +0200, Phil Sutter wrote:
> > On Thu, Apr 30, 2020 at 05:37:29PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 30, 2020 at 05:14:07PM +0200, Phil Sutter wrote:
> > > > Both functions were very similar already. Under the assumption that they
> > > > will always either see a range (or start of) that matches exactly or not
> > > > at all, reduce complexity and make get_set_interval_find() accept NULL
> > > > (left or) right values. This way it becomes a full replacement for
> > > > get_set_interval_end().
> > > 
> > > I have to go back to the commit log of this patch, IIRC my intention
> > > here was to allow users to ask for a single element, then return the
> > > range that contains it.
> > 
> > That was my suspicion as well, but while testing I found out that no
> > matter what I passed to 'get element', I couldn't provoke a situation in
> > which get_set_interval_find() would have left and right elements which
> > didn't match exactly (or not at all).
> > 
> > There must be some preparation happening before the call to
> > get_set_decompose() which normalizes things. And still, If I disable the
> > call to get_set_decompose() entirely, tests start failing.
> 
> Hm, so the approximate or exact matching is broken? Or you mean they
> fail because you didn't expect the approximate matching?

It's the opposite: Things are working fine even after my
simplifications. get_set_interval_find() expected left/right values
which sit within a range, e.g. left/right of 22/23 and a set with
element 20-30. But to my surprise, this doesn't happen. With these
example values, left/right are 20/30, i.e. match the range in the set.

That's why I extended tests/shell/testcases/sets/0034get_element_0.
Please have a look if there's a use-case I missed.

Cheers, Phil
