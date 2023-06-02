Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C3FC7EE2C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 22:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbjFBWyy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbjFBWyx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 18:54:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7242419B
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 15:54:52 -0700 (PDT)
Date:   Sat, 3 Jun 2023 00:54:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nftables: Writers starve readers
Message-ID: <ZHpzOUdffIPn4d8R@calendula>
References: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
 <20230601151105.GB26130@breakpoint.cc>
 <ZHj6QAzAhUtfFO+g@calendula>
 <ZHnfWaJJTI9Qmqbt@orbyte.nwl.cc>
 <ZHppFIkf6IXNkiBN@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHppFIkf6IXNkiBN@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 03, 2023 at 12:11:34AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 02, 2023 at 02:23:53PM +0200, Phil Sutter wrote:
> > On Thu, Jun 01, 2023 at 10:06:24PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Jun 01, 2023 at 05:11:05PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > A call to 'nft list ruleset' in a second terminal hangs without output.
> > > > > It apparently hangs in nft_cache_update() because rule_cache_dump()
> > > > > returns EINTR. On kernel side, I guess it stems from
> > > > > nl_dump_check_consistent() in __nf_tables_dump_rules(). I haven't
> > > > > checked, but the generation counter likely increases while dumping the
> > > > > 100k rules.
> > > > 
> > > > Yes.
> > > > 
> > > > > One may deem this scenario unrealistic, but I had to insert a 'sleep 5'
> > > > > into the while-loop to unblock 'nft list ruleset' again. A new rule
> > > > > every 4s especially in such a large ruleset is not that unrealistic IMO.
> > > > 
> > > > Several seconds is very strange indeed, how is the data that needs
> > > > to be transferred to userspace and how large is the buffer provided
> > > > during dumps? strace would help here.
> > > > 
> > > > If thats rather small, then dumping a chain with 10k rules may
> > > > have to re-iterate the existig list for long time before it finds
> > > > the starting point on where to resume the dump.
> > > > 
> > > > > I wonder if we can provide some fairness to readers? Ideally a reader
> > > > > would just see the ruleset as it was when it started dumping, but
> > > > > keeping a copy of the large ruleset is probably not feasible.
> > > > 
> > > > I can't think of a good solution.  We could add a
> > > > "--allow-inconsistent-dump" flag to nftables that disables the restart
> > > > logic for -EINTR case, but we can't make that the default unfortunately.
> > > > 
> > > > Or we could experiment with serializing the remaining rules into a
> > > > private kernel-side kmalloc'd buffer once the userspace buffer is
> > > > full, then copy from that buffer on resume without the inconsistency check.
> > > > 
> > > > I don't think that we can solve this, slowing down writers when there
> > > > are dumpers will load to the same issue, just in the oppostite direction.
> > > 
> > > There are currently two pending issues that, if addressed, could
> > > improve things:
> > > 
> > > NLM_F_INTR is set on in case writer infers with a reader, currently
> > > forcing userspace to read all of the remaining messages to leave
> > > things in consistent state, otherwise next dump request hits EILSEQ in
> > > libmnl. Before 6d085b22a8b5 ("table: support for the table owner
> > > flag"), the socket was closed and reopen to workaround this issue.
> > > There should be a way to discard the ongoing netlink dump without
> > > having to read the remaining messages, that should also improve
> > > things.
> > 
> > I tried restoring the immediate return from nft_mnl_recv() adding socket
> > close and open calls to sanitize things. Assuming my changes are
> > correct, they don't have a noticeable effect: The same test-case still
> > allows for a 4s delay in the rule add'n'delete loop to starve 'nft list
> > ruleset'.
> 
> Not for this particular torture test, but for some other usercases, it
> might be useful.
> 
> > > It should be possible to add generation counters per object type, so
> > > userspace does not have to ditch all what it has in its cache, only
> > > what it has changed. Currently the generation counter is global.
> > 
> > I guess the added complexity is probably not worth it. Kernel-side could
> > be pretty simple, but user space could no longer rely upon
> > nft_cache::genid but had to fetch each object's genid to check if the
> > local cache is outdated, plus I have no idea how one would detect that a
> > new table was added.
> 
> I made a patch to add a fall back, it displays a warning:
> 
> # Warning: ruleset has been updated while listing
> 
> it falls back to this mode if it takes more than 5 seconds to fetch a
> consistent ruleset.
> 
> I think I still need a new function to make consistency check, in case
> rule refering to unexisting chain, ie. top-level object in the
> hierarchy is missing, to avoid crashes. Such code would only exercised
> in case this fallback mode is enabled.

At least this chunk to discard rules that are orphaned, is needed:

@@ -986,8 +987,13 @@ static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
                if (!chain)
                        chain = chain_binding_lookup(table,
                                                     rule->handle.chain.name);
-               if (!chain)
-                       goto err_ctx_list;
+               if (!chain) {
+                       if (!ctx->ignore_eintr)
+                               goto err_ctx_list;
+
+                       list_del(&rule->list);
+                       rule_free(rule);
+               }
 
                list_move_tail(&rule->list, &chain->rules);
        }

I remember we used to have a script to check for crashes when writers
race with readers, I cannot find it in tests/shell.
