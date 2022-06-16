Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04556C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 10:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiFPK1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 06:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiFPK1f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 06:27:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245D1238
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 03:27:33 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o1mip-0006DA-AK; Thu, 16 Jun 2022 12:27:31 +0200
Date:   Thu, 16 Jun 2022 12:27:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] intervals: Do not sort cached set elements over and
 over again
Message-ID: <YqsFkwU/369O5vxQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220615173329.8595-1-phil@nwl.cc>
 <Yqo0q2gh/NSE1QwC@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yqo0q2gh/NSE1QwC@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 15, 2022 at 09:36:11PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 15, 2022 at 07:33:29PM +0200, Phil Sutter wrote:
> > When adding element(s) to a non-empty set, code merged the two lists and
> > sorted the result. With many individual 'add element' commands this
> > causes substantial overhead. Make use of the fact that
> > existing_set->init is sorted already, sort only the list of new elements
> > and use list_splice_sorted() to merge the two sorted lists.
> > 
> > A test case adding ~25k elements in individual commands completes in
> > about 1/4th of the time with this patch applied.
> 
> Good.
> 
> Do you still like the idea of coalescing set element commands whenever
> possible?

Does it mess with error reporting? If not, I don't see a downside of
doing it.

With regards to the problem at hand, it seems like a feature to escape
the actual problem. Please keep in mind that my patch's improvement from
~4min down to ~1min is pretty lousy given that v1.0.1 completed the same
task in 0.3s.

IMHO the whole overlap detection/auto merging should happen as commit
preparation and not per command.

Cheers, Phil
