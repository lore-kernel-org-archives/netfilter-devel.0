Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914C7C7EE2A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 15:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbjFAPLo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 11:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbjFAPLh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 11:11:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472ABE5F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 08:11:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q4jxB-0004Up-7i; Thu, 01 Jun 2023 17:11:05 +0200
Date:   Thu, 1 Jun 2023 17:11:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nftables: Writers starve readers
Message-ID: <20230601151105.GB26130@breakpoint.cc>
References: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> A call to 'nft list ruleset' in a second terminal hangs without output.
> It apparently hangs in nft_cache_update() because rule_cache_dump()
> returns EINTR. On kernel side, I guess it stems from
> nl_dump_check_consistent() in __nf_tables_dump_rules(). I haven't
> checked, but the generation counter likely increases while dumping the
> 100k rules.

Yes.

> One may deem this scenario unrealistic, but I had to insert a 'sleep 5'
> into the while-loop to unblock 'nft list ruleset' again. A new rule
> every 4s especially in such a large ruleset is not that unrealistic IMO.

Several seconds is very strange indeed, how is the data that needs
to be transferred to userspace and how large is the buffer provided
during dumps? strace would help here.

If thats rather small, then dumping a chain with 10k rules may
have to re-iterate the existig list for long time before it finds
the starting point on where to resume the dump.

> I wonder if we can provide some fairness to readers? Ideally a reader
> would just see the ruleset as it was when it started dumping, but
> keeping a copy of the large ruleset is probably not feasible.

I can't think of a good solution.  We could add a
"--allow-inconsistent-dump" flag to nftables that disables the restart
logic for -EINTR case, but we can't make that the default unfortunately.

Or we could experiment with serializing the remaining rules into a
private kernel-side kmalloc'd buffer once the userspace buffer is
full, then copy from that buffer on resume without the inconsistency check.

I don't think that we can solve this, slowing down writers when there
are dumpers will load to the same issue, just in the oppostite direction.
