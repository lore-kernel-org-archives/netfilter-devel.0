From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/6] netlink: readability fixes
Date: Sun, 11 Jan 2015 08:09:40 +0000
Message-ID: <1420963782-21189-5-git-send-email-kaber@trash.net>
References: <1420963782-21189-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54795 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbAKIJt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:09:49 -0500
In-Reply-To: <1420963782-21189-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Improve readability by using local variables for netlink attributes,
ordering variables more logically, don't arbitrarily initialize
some variables in the definition section and in the body and generally
make similar functions look similar.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/netlink.c | 127 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 56 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index af56d22..84d9d27 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -432,11 +432,16 @@ static int list_rule_cb(struct nft_rule *nlr, void *arg)
 	struct netlink_ctx *ctx = arg;
 	const struct handle *h = ctx->data;
 	struct rule *rule;
+	const char *table, *chain;
+	uint32_t family;
+
+	family = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
+	table  = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE);
+	chain  = nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN);
 
-	if ((h->family != nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY)) ||
-	    strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE), h->table) != 0 ||
-	    (h->chain &&
-	     strcmp(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN), h->chain) != 0))
+	if (h->family != family ||
+	    strcmp(table, h->table) != 0 ||
+	    (h->chain && strcmp(chain, h->chain) != 0))
 		return 0;
 
 	netlink_dump_rule(nlr);
@@ -677,14 +682,17 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 {
 	struct netlink_ctx *ctx = arg;
 	const struct handle *h = ctx->data;
-	const char *table = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE);
-	const char *name = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME);
+	const char *table;
+	const char *name;
 	struct chain *chain;
+	uint32_t family;
 
-	if ((h->family != nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY)) ||
-	    strcmp(table, h->table) != 0)
-		return 0;
+	table  = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE);
+	name   = nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME);
+	family = nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
 
+	if (h->family != family || strcmp(table, h->table) != 0)
+		return 0;
 	if (h->chain && strcmp(name, h->chain) != 0)
 		return 0;
 
@@ -740,16 +748,16 @@ int netlink_get_chain(struct netlink_ctx *ctx, const struct handle *h,
 	nlc = alloc_nft_chain(h);
 	err = mnl_nft_chain_get(nf_sock, nlc, 0);
 	if (err < 0) {
-		nft_chain_free(nlc);
-		return netlink_io_error(ctx, loc,
-					"Could not receive chain from kernel: %s",
-					strerror(errno));
+		netlink_io_error(ctx, loc,
+				 "Could not receive chain from kernel: %s",
+				 strerror(errno));
+		goto out;
 	}
 
 	chain = netlink_delinearize_chain(ctx, nlc);
 	list_add_tail(&chain->list, &ctx->list);
+out:
 	nft_chain_free(nlc);
-
 	return err;
 }
 
@@ -925,9 +933,9 @@ int netlink_get_table(struct netlink_ctx *ctx, const struct handle *h,
 	nft_table_free(nlt);
 
 	if (err < 0)
-		return netlink_io_error(ctx, loc,
-					"Could not receive table from kernel: %s",
-					strerror(errno));
+		netlink_io_error(ctx, loc,
+				 "Could not receive table from kernel: %s",
+				 strerror(errno));
 	return err;
 }
 
@@ -1015,10 +1023,10 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		xstrdup(nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME));
 
 	set->keytype = keytype;
-	set->keylen        =
+	set->keylen  =
 		nft_set_attr_get_u32(nls, NFT_SET_ATTR_KEY_LEN) * BITS_PER_BYTE;
 
-	set->flags         = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
+	set->flags   = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
 
 	set->datatype = datatype;
 	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DATA_LEN)) {
@@ -1434,13 +1442,11 @@ int netlink_batch_send(struct list_head *err_list)
 int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
 			  const struct location *loc)
 {
-	int err;
 	struct nft_table *nlt;
+	int err;
 
-	if (!ctx->batch_supported) {
-		netlink_io_error(ctx, loc, "Operation not supported.");
-		return -1;
-	}
+	if (!ctx->batch_supported)
+		return netlink_io_error(ctx, loc, "Operation not supported");
 
 	nlt = alloc_nft_table(h);
 	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
@@ -1559,12 +1565,12 @@ static void nlr_for_each_set(struct nft_rule *nlr,
 			     void (*cb)(struct set *s, void *data),
 			     void *data)
 {
-	struct set *s;
-	uint32_t family;
-	const char *set_name, *table;
-	struct nft_rule_expr *nlre;
 	struct nft_rule_expr_iter *nlrei;
+	struct nft_rule_expr *nlre;
+	const char *set_name, *table;
 	const char *name;
+	struct set *s;
+	uint32_t family;
 
 	nlrei = nft_rule_expr_iter_create(nlr);
 	if (nlrei == NULL)
@@ -1594,8 +1600,10 @@ next:
 static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 				   struct netlink_mon_handler *monh)
 {
+	struct nft_table *nlt;
 	uint32_t family;
-	struct nft_table *nlt = netlink_table_alloc(nlh);
+
+	nlt = netlink_table_alloc(nlh);
 
 	switch (monh->format) {
 	case NFT_OUTPUT_DEFAULT:
@@ -1628,9 +1636,11 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 				   struct netlink_mon_handler *monh)
 {
+	struct nft_chain *nlc;
 	struct chain *c;
 	uint32_t family;
-	struct nft_chain *nlc = netlink_chain_alloc(nlh);
+
+	nlc = netlink_chain_alloc(nlh);
 
 	switch (monh->format) {
 	case NFT_OUTPUT_DEFAULT:
@@ -1671,10 +1681,11 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 				 struct netlink_mon_handler *monh)
 {
+	struct nft_set *nls;
 	struct set *set;
 	uint32_t family, flags;
-	struct nft_set *nls = netlink_set_alloc(nlh);
 
+	nls = netlink_set_alloc(nlh);
 	flags = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FLAGS);
 	if (flags & SET_F_ANONYMOUS)
 		goto out;
@@ -1718,14 +1729,15 @@ out:
 static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				     struct netlink_mon_handler *monh)
 {
-	struct nft_set_elem *nlse;
 	struct nft_set_elems_iter *nlsei;
+	struct nft_set_elem *nlse;
+	struct nft_set *nls;
 	struct set *dummyset;
 	struct set *set;
 	const char *setname, *table;
 	uint32_t family;
-	struct nft_set *nls = netlink_setelem_alloc(nlh);
 
+	nls = netlink_setelem_alloc(nlh);
 	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
 	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
 	family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
@@ -1803,14 +1815,15 @@ static void rule_map_decompose_cb(struct set *s, void *data)
 static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 				  struct netlink_mon_handler *monh)
 {
-	struct rule *r;
-	uint32_t fam;
+	struct nft_rule *nlr;
 	const char *family;
 	const char *table;
 	const char *chain;
+	struct rule *r;
 	uint64_t handle;
-	struct nft_rule *nlr = netlink_rule_alloc(nlh);
+	uint32_t fam;
 
+	nlr = netlink_rule_alloc(nlh);
 	switch (monh->format) {
 	case NFT_OUTPUT_DEFAULT:
 		fam = nft_rule_attr_get_u32(nlr, NFT_RULE_ATTR_FAMILY);
@@ -1851,53 +1864,54 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 static void netlink_events_cache_addtable(struct netlink_mon_handler *monh,
 					  const struct nlmsghdr *nlh)
 {
+	struct nft_table *nlt;
 	struct table *t;
-	struct nft_table *nlt = netlink_table_alloc(nlh);
 
+	nlt = netlink_table_alloc(nlh);
 	t = netlink_delinearize_table(monh->ctx, nlt);
-	table_add_hash(t);
-
 	nft_table_free(nlt);
+
+	table_add_hash(t);
 }
 
 static void netlink_events_cache_deltable(struct netlink_mon_handler *monh,
 					  const struct nlmsghdr *nlh)
 {
+	struct nft_table *nlt;
 	struct table *t;
 	struct handle h;
-	struct nft_table *nlt = netlink_table_alloc(nlh);
 
+	nlt      = netlink_table_alloc(nlh);
 	h.family = nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY);
-	h.table = nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME);
+	h.table  = nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME);
+	nft_table_free(nlt);
 
 	t = table_lookup(&h);
 	if (t == NULL)
-		goto out;
+		return;
 
 	list_del(&t->list);
 	table_free(t);
-
-out:
-	nft_table_free(nlt);
 }
 
 static void netlink_events_cache_addset(struct netlink_mon_handler *monh,
 					const struct nlmsghdr *nlh)
 {
+	struct netlink_ctx set_tmpctx;
+	struct nft_set *nls;
+	struct table *t;
 	struct set *s;
 	LIST_HEAD(msgs);
-	struct table *t;
-	struct netlink_ctx set_tmpctx;
-	struct nft_set *nls = netlink_set_alloc(nlh);
 
 	memset(&set_tmpctx, 0, sizeof(set_tmpctx));
 	init_list_head(&set_tmpctx.list);
 	init_list_head(&msgs);
 	set_tmpctx.msgs = &msgs;
 
+	nls = netlink_set_alloc(nlh);
 	s = netlink_delinearize_set(&set_tmpctx, nls);
 	if (s == NULL)
-		return;
+		goto out;
 	s->init = set_expr_alloc(monh->loc);
 
 	t = table_lookup(&s->handle);
@@ -1915,17 +1929,19 @@ out:
 static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 					    const struct nlmsghdr *nlh)
 {
-	struct set *set;
-	struct nft_set_elem *nlse;
 	struct nft_set_elems_iter *nlsei;
+	struct nft_set_elem *nlse;
+	struct nft_set *nls;
+	struct set *set;
 	const char *table, *setname;
-	struct nft_set *nls = netlink_setelem_alloc(nlh);
+	uint32_t family;
 
-	table = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
+	nls     = netlink_setelem_alloc(nlh);
+	family  = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	table   = nft_set_attr_get_str(nls, NFT_SET_ATTR_TABLE);
 	setname = nft_set_attr_get_str(nls, NFT_SET_ATTR_NAME);
 
-	set = set_lookup_global(nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY),
-				table, setname);
+	set = set_lookup_global(family, table, setname);
 	if (set == NULL) {
 		fprintf(stderr,
 			"W: Unable to cache set_elem. Set not found.\n");
@@ -1948,7 +1964,6 @@ static void netlink_events_cache_addsetelem(struct netlink_mon_handler *monh,
 		nlse = nft_set_elems_iter_next(nlsei);
 	}
 	nft_set_elems_iter_destroy(nlsei);
-
 out:
 	nft_set_free(nls);
 }
-- 
2.1.0

