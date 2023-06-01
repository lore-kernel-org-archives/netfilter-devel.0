Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6548EC77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 20:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjFAUHH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjFAUHG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 16:07:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1968DE4A
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 13:06:45 -0700 (PDT)
Date:   Thu, 1 Jun 2023 22:06:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: nftables: Writers starve readers
Message-ID: <ZHj6QAzAhUtfFO+g@calendula>
References: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
 <20230601151105.GB26130@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230601151105.GB26130@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 01, 2023 at 05:11:05PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > A call to 'nft list ruleset' in a second terminal hangs without output.
> > It apparently hangs in nft_cache_update() because rule_cache_dump()
> > returns EINTR. On kernel side, I guess it stems from
> > nl_dump_check_consistent() in __nf_tables_dump_rules(). I haven't
> > checked, but the generation counter likely increases while dumping the
> > 100k rules.
> 
> Yes.
> 
> > One may deem this scenario unrealistic, but I had to insert a 'sleep 5'
> > into the while-loop to unblock 'nft list ruleset' again. A new rule
> > every 4s especially in such a large ruleset is not that unrealistic IMO.
> 
> Several seconds is very strange indeed, how is the data that needs
> to be transferred to userspace and how large is the buffer provided
> during dumps? strace would help here.
> 
> If thats rather small, then dumping a chain with 10k rules may
> have to re-iterate the existig list for long time before it finds
> the starting point on where to resume the dump.
> 
> > I wonder if we can provide some fairness to readers? Ideally a reader
> > would just see the ruleset as it was when it started dumping, but
> > keeping a copy of the large ruleset is probably not feasible.
> 
> I can't think of a good solution.  We could add a
> "--allow-inconsistent-dump" flag to nftables that disables the restart
> logic for -EINTR case, but we can't make that the default unfortunately.
> 
> Or we could experiment with serializing the remaining rules into a
> private kernel-side kmalloc'd buffer once the userspace buffer is
> full, then copy from that buffer on resume without the inconsistency check.
> 
> I don't think that we can solve this, slowing down writers when there
> are dumpers will load to the same issue, just in the oppostite direction.

There are currently two pending issues that, if addressed, could
improve things:

NLM_F_INTR is set on in case writer infers with a reader, currently
forcing userspace to read all of the remaining messages to leave
things in consistent state, otherwise next dump request hits EILSEQ in
libmnl. Before 6d085b22a8b5 ("table: support for the table owner
flag"), the socket was closed and reopen to workaround this issue.
There should be a way to discard the ongoing netlink dump without
having to read the remaining messages, that should also improve
things.

It should be possible to add generation counters per object type, so
userspace does not have to ditch all what it has in its cache, only
what it has changed. Currently the generation counter is global.
