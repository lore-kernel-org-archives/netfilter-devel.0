Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AB8C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 23:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC0C061059
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 23:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhERXTq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 19:19:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44032 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237928AbhERXTq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 19:19:46 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D41356414A;
        Wed, 19 May 2021 01:17:31 +0200 (CEST)
Date:   Wed, 19 May 2021 01:18:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH nf] netfilter: nftables: accept all dummy chain when
 table is dormant
Message-ID: <20210518231824.GA27217@salvia>
References: <20210518224730.317215-1-pablo@netfilter.org>
 <20210518225619.GA8317@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210518225619.GA8317@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 19, 2021 at 12:56:19AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The dormant flag need to be updated from the preparation phase,
> > otherwise, two consecutive requests to dorm a table in the same batch
> > might try to remove the same hooks twice, resulting in the following
> > warning:
> > 
> >  hook not found, pf 3 num 0
> >  WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> >  Modules linked in:
> >  CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
> >  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >  Workqueue: netns cleanup_net
> >  RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> 
> Would it be possible to reject such a batch instead of having to add
> rely on dummy hooking instead?

That's a simple way to fix it, yes, ie. hit EBUSY.

> I don't think we should try to be clever with nonsensical yes-no-yes-yes-no
> type commits.

Note that no such EBUSY limitation exists so far in the transaction
semantics that I know [*]. We already discussed that robots might do
non-sensical stuff when creating a batches, and reporting EBUSY for
this add-del-add case might just break them.

This also removes the conditional hook registration, so hooks are
registered once at chain creation. This simplifies interaction with
the netfilter core at the cost of adding complexity to
nf_tables_commit_chain_prepare() path.

[*] Well, you might still hit EBUSY from a batch, but that happens if
the object is really in use, not because of the add-del-add sequence.
