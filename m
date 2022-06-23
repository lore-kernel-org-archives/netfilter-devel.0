Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78919CCA47C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 18:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiFWSIt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbiFWSIO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 14:08:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2727CBB01D
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:19:41 -0700 (PDT)
Date:   Thu, 23 Jun 2022 19:19:36 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2,v2] intervals: Do not sort cached set elements
 over and over again
Message-ID: <YrSgqN1mkVOUZdZa@salvia>
References: <20220616090446.275985-1-pablo@netfilter.org>
 <20220616090446.275985-2-pablo@netfilter.org>
 <YrSPQJy7+IjLeQvA@orbyte.nwl.cc>
 <YrSSDGNNSbrHCKdf@salvia>
 <YrST/2ypRG/KACfz@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrST/2ypRG/KACfz@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 06:25:35PM +0200, Phil Sutter wrote:
> On Thu, Jun 23, 2022 at 06:17:16PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 23, 2022 at 06:05:20PM +0200, Phil Sutter wrote:
> > > On Thu, Jun 16, 2022 at 11:04:46AM +0200, Pablo Neira Ayuso wrote:
> > > > From: Phil Sutter <phil@nwl.cc>
> > > > 
> > > > When adding element(s) to a non-empty set, code merged the two lists and
> > > > sorted the result. With many individual 'add element' commands this
> > > > causes substantial overhead. Make use of the fact that
> > > > existing_set->init is sorted already, sort only the list of new elements
> > > > and use list_splice_sorted() to merge the two sorted lists.
> > > > 
> > > > Add set_sort_splice() and use it for set element overlap detection and
> > > > automerge.
> > > > 
> > > > A test case adding ~25k elements in individual commands completes in
> > > > about 1/4th of the time with this patch applied.
> > > > 
> > > > Joint work with Pablo.
> > > > 
> > > > Fixes: 3da9643fb9ff9 ("intervals: add support to automerge with kernel elements")
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > Thanks for picking it up, I missed the automerge code being very
> > > similar.
> > > 
> > > I worked on a patch to move the whole set adjustment to a separate step
> > > after evaluating commands, but it's a bit larger effort as it requires
> > > to combine overlap detection, auto merge and element deletion. With
> > > simple appending new elements in eval phase and reacting upon
> > > EXPR_F_KERNEL and EXPR_F_REMOVE flags, I guess it's possible to update
> > > the whole set in one go.
> > 
> > You mean, appending if they come in order as in your test ruleset? Not
> > sure what you are suggesting.
> 
> It was merely loud thinking - combining repeated 'add element' commands
> is fine with me for avoiding the problem. I have an alternative in mind
> where added elements are appended to the set without EXPR_F_KERNEL and
> removed ones also with EXPR_F_REMOVE. So after nft_evaluate() one could
> do all the overlap detection / auto merging / element removing once for
> each changed set.

I have pushed out this coalesce approach to tackle this regression.
Feel free to revisit this approach.
