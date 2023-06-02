Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392A5C77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 22:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbjFBWLk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 18:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbjFBWLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 18:11:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4D5B1B7
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 15:11:36 -0700 (PDT)
Date:   Sat, 3 Jun 2023 00:11:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nftables: Writers starve readers
Message-ID: <ZHppFIkf6IXNkiBN@calendula>
References: <ZHhm1dn6L1BUAQKK@orbyte.nwl.cc>
 <20230601151105.GB26130@breakpoint.cc>
 <ZHj6QAzAhUtfFO+g@calendula>
 <ZHnfWaJJTI9Qmqbt@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9JMZ/R30WY29JwuZ"
Content-Disposition: inline
In-Reply-To: <ZHnfWaJJTI9Qmqbt@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9JMZ/R30WY29JwuZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Jun 02, 2023 at 02:23:53PM +0200, Phil Sutter wrote:
> On Thu, Jun 01, 2023 at 10:06:24PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 01, 2023 at 05:11:05PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > A call to 'nft list ruleset' in a second terminal hangs without output.
> > > > It apparently hangs in nft_cache_update() because rule_cache_dump()
> > > > returns EINTR. On kernel side, I guess it stems from
> > > > nl_dump_check_consistent() in __nf_tables_dump_rules(). I haven't
> > > > checked, but the generation counter likely increases while dumping the
> > > > 100k rules.
> > > 
> > > Yes.
> > > 
> > > > One may deem this scenario unrealistic, but I had to insert a 'sleep 5'
> > > > into the while-loop to unblock 'nft list ruleset' again. A new rule
> > > > every 4s especially in such a large ruleset is not that unrealistic IMO.
> > > 
> > > Several seconds is very strange indeed, how is the data that needs
> > > to be transferred to userspace and how large is the buffer provided
> > > during dumps? strace would help here.
> > > 
> > > If thats rather small, then dumping a chain with 10k rules may
> > > have to re-iterate the existig list for long time before it finds
> > > the starting point on where to resume the dump.
> > > 
> > > > I wonder if we can provide some fairness to readers? Ideally a reader
> > > > would just see the ruleset as it was when it started dumping, but
> > > > keeping a copy of the large ruleset is probably not feasible.
> > > 
> > > I can't think of a good solution.  We could add a
> > > "--allow-inconsistent-dump" flag to nftables that disables the restart
> > > logic for -EINTR case, but we can't make that the default unfortunately.
> > > 
> > > Or we could experiment with serializing the remaining rules into a
> > > private kernel-side kmalloc'd buffer once the userspace buffer is
> > > full, then copy from that buffer on resume without the inconsistency check.
> > > 
> > > I don't think that we can solve this, slowing down writers when there
> > > are dumpers will load to the same issue, just in the oppostite direction.
> > 
> > There are currently two pending issues that, if addressed, could
> > improve things:
> > 
> > NLM_F_INTR is set on in case writer infers with a reader, currently
> > forcing userspace to read all of the remaining messages to leave
> > things in consistent state, otherwise next dump request hits EILSEQ in
> > libmnl. Before 6d085b22a8b5 ("table: support for the table owner
> > flag"), the socket was closed and reopen to workaround this issue.
> > There should be a way to discard the ongoing netlink dump without
> > having to read the remaining messages, that should also improve
> > things.
> 
> I tried restoring the immediate return from nft_mnl_recv() adding socket
> close and open calls to sanitize things. Assuming my changes are
> correct, they don't have a noticeable effect: The same test-case still
> allows for a 4s delay in the rule add'n'delete loop to starve 'nft list
> ruleset'.

Not for this particular torture test, but for some other usercases, it
might be useful.

> > It should be possible to add generation counters per object type, so
> > userspace does not have to ditch all what it has in its cache, only
> > what it has changed. Currently the generation counter is global.
> 
> I guess the added complexity is probably not worth it. Kernel-side could
> be pretty simple, but user space could no longer rely upon
> nft_cache::genid but had to fetch each object's genid to check if the
> local cache is outdated, plus I have no idea how one would detect that a
> new table was added.

I made a patch to add a fall back, it displays a warning:

# Warning: ruleset has been updated while listing

it falls back to this mode if it takes more than 5 seconds to fetch a
consistent ruleset.

I think I still need a new function to make consistency check, in case
rule refering to unexisting chain, ie. top-level object in the
hierarchy is missing, to avoid crashes. Such code would only exercised
in case this fallback mode is enabled.

See attachment.

--9JMZ/R30WY29JwuZ
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/cache.h b/include/cache.h
index 934c3a74fa95..c5c585bacaf7 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -136,6 +136,7 @@ struct nft_cache {
 	struct cache		table_cache;
 	uint32_t		seqnum;
 	uint32_t		flags;
+	bool			eintr;
 };
 
 void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
diff --git a/include/netlink.h b/include/netlink.h
index d52434c72bc2..d3e828f270e1 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -85,6 +85,7 @@ struct netlink_ctx {
 	uint32_t		seqnum;
 	struct nftnl_batch	*batch;
 	int			maybe_emsgsize;
+	bool			ignore_eintr;
 };
 
 extern struct nftnl_expr *alloc_nft_expr(const char *name);
diff --git a/src/cache.c b/src/cache.c
index 95adee7f8ac1..9237397d2d3e 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -15,6 +15,7 @@
 #include <netlink.h>
 #include <mnl.h>
 #include <libnftnl/chain.h>
+#include <sys/time.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 
@@ -1175,10 +1176,14 @@ bool nft_cache_needs_update(struct nft_cache *cache)
 	return cache->flags & NFT_CACHE_UPDATE;
 }
 
+/* display inconsistent ruleset after 5 seconds of retries. */
+#define MAX_RETRY_TIME 5
+
 int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
 		     struct list_head *msgs,
 		     const struct nft_cache_filter *filter)
 {
+	struct timeval tv_start, tv_last, tv_diff;
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
 		.nft		= nft,
@@ -1187,7 +1192,14 @@ int nft_cache_update(struct nft_ctx *nft, unsigned int flags,
 	struct nft_cache *cache = &nft->cache;
 	uint32_t genid, genid_stop, oldflags;
 	int ret;
+
+	gettimeofday(&tv_start, NULL);
 replay:
+	gettimeofday(&tv_last, NULL);
+	timersub(&tv_diff, &tv_last, &tv_start);
+	if (tv_diff.tv_sec > MAX_RETRY_TIME)
+		ctx.ignore_eintr = true;
+
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
 	if (!nft_cache_needs_refresh(cache) &&
@@ -1223,12 +1235,16 @@ replay:
 
 	genid_stop = mnl_genid_get(&ctx);
 	if (genid != genid_stop) {
-		nft_cache_release(cache);
-		goto replay;
+		if (!ctx.ignore_eintr) {
+			nft_cache_release(cache);
+			goto replay;
+		}
+		cache->eintr = true;
 	}
 skip:
 	cache->genid = genid;
 	cache->flags = flags;
+
 	return 0;
 }
 
diff --git a/src/mnl.c b/src/mnl.c
index 91775c41b246..f985e90c5926 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -706,8 +706,13 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
 	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nlr_list;
 err:
@@ -1029,8 +1034,13 @@ struct nftnl_chain_list *mnl_nft_chain_dump(struct netlink_ctx *ctx,
 	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
-	if (ret < 0 && errno != ENOENT)
-		goto err;
+	if (ret < 0 && errno != ENOENT) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nlc_list;
 err:
@@ -1174,8 +1184,13 @@ struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
 	}
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, table_cb, nlt_list);
-	if (ret < 0 && errno != ENOENT)
-		goto err;
+	if (ret < 0 && errno != ENOENT) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nlt_list;
 err:
@@ -1428,8 +1443,13 @@ mnl_nft_set_dump(struct netlink_ctx *ctx, int family,
 		memory_allocation_error();
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, set_cb, nls_list);
-	if (ret < 0 && errno != ENOENT)
-		goto err;
+	if (ret < 0 && errno != ENOENT) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nls_list;
 err:
@@ -1653,8 +1673,13 @@ mnl_nft_obj_dump(struct netlink_ctx *ctx, int family,
 		memory_allocation_error();
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, obj_cb, nln_list);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nln_list;
 err:
@@ -1967,8 +1992,13 @@ mnl_nft_flowtable_dump(struct netlink_ctx *ctx, int family,
 		memory_allocation_error();
 
 	ret = nft_mnl_talk(ctx, nlh, nlh->nlmsg_len, flowtable_cb, nln_list);
-	if (ret < 0 && errno != ENOENT)
-		goto err;
+	if (ret < 0 && errno != ENOENT) {
+		if (errno != EINTR)
+			goto err;
+
+		if (!ctx->ignore_eintr)
+			goto err;
+	}
 
 	return nln_list;
 err:
diff --git a/src/rule.c b/src/rule.c
index 633a5a12486d..3f984ea1fec5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2192,6 +2192,9 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 	unsigned int family = cmd->handle.family;
 	struct table *table;
 
+	if (ctx->nft->cache.eintr)
+		nft_print(&ctx->nft->output, "# Warning: ruleset has been updated while listing\n");
+
 	list_for_each_entry(table, &ctx->nft->cache.table_cache.list, cache.list) {
 		if (family != NFPROTO_UNSPEC &&
 		    table->handle.family != family)

--9JMZ/R30WY29JwuZ--
