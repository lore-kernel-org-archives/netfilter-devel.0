Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0352C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 08:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA9161355
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 08:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245105AbhESIcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 04:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245062AbhESIcE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 04:32:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E9AC06175F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 01:30:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ljHb2-00053c-6n; Wed, 19 May 2021 10:30:28 +0200
Date:   Wed, 19 May 2021 10:30:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        dvyukov@google.com
Subject: Re: [PATCH nf] netfilter: nftables: accept all dummy chain when
 table is dormant
Message-ID: <20210519083028.GB8317@breakpoint.cc>
References: <20210518224730.317215-1-pablo@netfilter.org>
 <20210518225619.GA8317@breakpoint.cc>
 <20210518231824.GA27217@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518231824.GA27217@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 19, 2021 at 12:56:19AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > The dormant flag need to be updated from the preparation phase,
> > > otherwise, two consecutive requests to dorm a table in the same batch
> > > might try to remove the same hooks twice, resulting in the following
> > > warning:
> > > 
> > >  hook not found, pf 3 num 0
> > >  WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> > >  Modules linked in:
> > >  CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
> > >  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > >  Workqueue: netns cleanup_net
> > >  RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> > 
> > Would it be possible to reject such a batch instead of having to add
> > rely on dummy hooking instead?
> 
> That's a simple way to fix it, yes, ie. hit EBUSY.
> 
> > I don't think we should try to be clever with nonsensical yes-no-yes-yes-no
> > type commits.
> 
> Note that no such EBUSY limitation exists so far in the transaction
> semantics that I know [*]. We already discussed that robots might do
> non-sensical stuff when creating a batches, and reporting EBUSY for
> this add-del-add case might just break them.

I don't think this breaks existing users, noone except syzbot
reported such WARN splat so far.

> This also removes the conditional hook registration, so hooks are
> registered once at chain creation. This simplifies interaction with
> the netfilter core at the cost of adding complexity to
> nf_tables_commit_chain_prepare() path.

It also adds side effect (hook registration) during preparation phase.

I think its similar to

add table foo
delete table foo
delete table foo

... and that gives -ENOENT.
