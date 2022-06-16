Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 11:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiFPLPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 07:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiFPLPJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 07:15:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95F745C872
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 04:15:08 -0700 (PDT)
Date:   Thu, 16 Jun 2022 13:15:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] intervals: Do not sort cached set elements over and
 over again
Message-ID: <YqsQtYa8afgUdsDB@salvia>
References: <20220615173329.8595-1-phil@nwl.cc>
 <Yqo0q2gh/NSE1QwC@salvia>
 <YqsFkwU/369O5vxQ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YqsFkwU/369O5vxQ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 16, 2022 at 12:27:31PM +0200, Phil Sutter wrote:
> On Wed, Jun 15, 2022 at 09:36:11PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 15, 2022 at 07:33:29PM +0200, Phil Sutter wrote:
> > > When adding element(s) to a non-empty set, code merged the two lists and
> > > sorted the result. With many individual 'add element' commands this
> > > causes substantial overhead. Make use of the fact that
> > > existing_set->init is sorted already, sort only the list of new elements
> > > and use list_splice_sorted() to merge the two sorted lists.
> > > 
> > > A test case adding ~25k elements in individual commands completes in
> > > about 1/4th of the time with this patch applied.
> > 
> > Good.
> > 
> > Do you still like the idea of coalescing set element commands whenever
> > possible?
> 
> Does it mess with error reporting? If not, I don't see a downside of
> doing it.
> 
> With regards to the problem at hand, it seems like a feature to escape
> the actual problem. Please keep in mind that my patch's improvement from
> ~4min down to ~1min is pretty lousy given that v1.0.1 completed the same
> task in 0.3s.

I running this comparison between 1.0.1:

# nft -v
nftables v1.0.1 (Fearless Fosdick #3)
# nft -f dump_sep.nft

real    0m3,867s
user    0m3,651s
sys     0m0,219s

and current 1.0.4 plus pending patches in patchwork:

# nft -v
nftables v1.0.4 (Lester Gooch #3)
# nft -f dump_sep.nft

real    0m3,867s
user    0m3,677s
sys     0m0,190s

For the record, this dump_sep.nft (that you sent me) looks like this:

# cat dump_sep.nft
add table t
add set t s { type ipv4_addr; flags interval; }
add element t s { 1.0.1.0/24 }
add element t s { 1.0.2.0/23 }
[...] more single command to add element [...]

> IMHO the whole overlap detection/auto merging should happen as commit
> preparation and not per command.

Then, this needs to coalesce the commands that update a single set at
a later stage, in such commit preparation phase.

This code also has to deal with deletions coming in the same batch,
which might be happening per command, by a robot generated batch.

Userspace overlap detection is only required by kernels <= 5.7, so
this check could be removed.

For automerging, I don't think I can escape tracking each command to
update the userspace set cache and adjust the existing ranges
accordingly.
