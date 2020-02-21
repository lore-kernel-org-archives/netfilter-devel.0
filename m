Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605E7C35666
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 22:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29E53207FD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 22:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgBUWHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 17:07:36 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57826 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgBUWHf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 17:07:35 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j5GSL-0007Yn-SM; Fri, 21 Feb 2020 23:07:33 +0100
Date:   Fri, 21 Feb 2020 23:07:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Fix for potential NULL-pointer deref in
 ei_insert()
Message-ID: <20200221220733.GN20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200120162540.9699-1-phil@nwl.cc>
 <20200120162540.9699-4-phil@nwl.cc>
 <20200121125612.6kmvuazs6bmarhir@salvia>
 <20200127132448.GC28318@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127132448.GC28318@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 02:24:48PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Jan 21, 2020 at 01:56:12PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Jan 20, 2020 at 05:25:39PM +0100, Phil Sutter wrote:
> > > Covscan complained about potential deref of NULL 'lei' pointer,
> > > Interestingly this can't happen as the relevant goto leading to that
> > > (in line 260) sits in code checking conflicts between new intervals and
> > > since those are sorted upon insertion, only the lower boundary may
> > > conflict (or both, but that's covered before).
> > > 
> > > Given the needed investigation to proof covscan wrong and the actually
> > > wrong (but impossible) code, better fix this as if element ordering was
> > > arbitrary to avoid surprises if at some point it really becomes that.
> > > 
> > > Fixes: 4d6ad0f310d6c ("segtree: check for overlapping elements at insertion")
> > 
> > Not fixing anything. Tell them to fix covscan :-)
> 
> Well, I guess covscan is simply not intelligent enough to detect the
> impact of previous element sorting. :)

Or maybe I am not intelligent enough to read and comprehend the sorting
function. ;)

Meanwhile I managed to find a reproducer for covscan's complaint:

With a ruleset of:

| table ip t {
| 	set s {
| 		type inet_service
| 		flags interval
| 	}
| }

The following command segfaults:

| # nft add element t s '{ 10-40, 5-15 }'

According to gdb it happens the line above
'return expr_binary_error(...)' in ei_insert(), namely segtree.c:279. No
idea why it's in the wrong line, but it seems to be just the reported
issue as 'lei' is NULL.

Interestingly, adding a rule with an anonymous set and the same elements
works fine, no idea why.

What do you think, should I continue investigating or can we just go
with my original fix (for now at least)?

Cheers, Phil
