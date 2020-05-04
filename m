Return-Path: <SRS0=zdgi=6S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D92C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 12:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F57206D9
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 May 2020 12:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgEDMx4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 May 2020 08:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDMx4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 May 2020 08:53:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129DC061A0E
        for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2020 05:53:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jVabY-000797-FJ; Mon, 04 May 2020 14:53:52 +0200
Date:   Mon, 4 May 2020 14:53:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Merge get_set_interval_find() and
 get_set_interval_end()
Message-ID: <20200504125352.GA11061@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200430151408.32283-1-phil@nwl.cc>
 <20200430151408.32283-4-phil@nwl.cc>
 <20200430153729.GA3602@salvia>
 <20200430154113.GB3602@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430154113.GB3602@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Apr 30, 2020 at 05:41:13PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 05:37:29PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Apr 30, 2020 at 05:14:07PM +0200, Phil Sutter wrote:
> > > Both functions were very similar already. Under the assumption that they
> > > will always either see a range (or start of) that matches exactly or not
> > > at all, reduce complexity and make get_set_interval_find() accept NULL
> > > (left or) right values. This way it becomes a full replacement for
> > > get_set_interval_end().
> > 
> > I have to go back to the commit log of this patch, IIRC my intention
> > here was to allow users to ask for a single element, then return the
> > range that contains it.

[...]

> BTW, are get commands to the pipapo set working like this too?

Yes, indeed they do. I added some lines to cover concatenated ranges in
sets/0034get_element_0 shell test, will push it out along with this
series.

Thanks, Phil
