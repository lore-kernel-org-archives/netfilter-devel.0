Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B490C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 16:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjFAQmv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 12:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAQmu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 12:42:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3DD184
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 09:42:48 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1q4lNu-0005BJ-AT; Thu, 01 Jun 2023 18:42:46 +0200
Date:   Thu, 1 Jun 2023 18:42:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: nftables: Writers starve readers
Message-ID: <ZHjKhvWbM5tb/lEh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
 <20230601151105.GB26130@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Each recvmsg() call returns 32KB, grepping for NFT_MSG_NEWRULE returns
4290 lines.

| # time ./src/nft list ruleset | wc -l
| # Warning: table ip filter is managed by iptables-nft, do not touch!
| # Warning: table ip nat is managed by iptables-nft, do not touch!
| # Warning: table ip mangle is managed by iptables-nft, do not touch!
| 100190
| 
| real  0m5.572s
| user  0m1.014s
| sys   0m4.885s 

> If thats rather small, then dumping a chain with 10k rules may
> have to re-iterate the existig list for long time before it finds
> the starting point on where to resume the dump.

To my surprise, the mnl_nft_rule_dump() code-path does not call
mnl_set_rcvbuffer(). Though explicitly calling it from nft_mnl_talk() passing
1<<24 as buffer size does not lead to different behaviour. I seem to recall the
32k was a kernel-side limit in netlink?

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

You're probably right, thanks for spending cycles on it.

Cheers, Phil
