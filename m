Return-Path: <SRS0=c7vx=XW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BA1C4360C
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC6B5217D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Sep 2019 14:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfI0OFA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:05:00 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49986 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 10:05:00 -0400
Received: from localhost ([::1]:34844 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDqrj-0006tz-9S; Fri, 27 Sep 2019 16:04:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/12] nft: Fetch sets when updating rule cache
Date:   Fri, 27 Sep 2019 16:04:28 +0200
Message-Id: <20190927140433.9504-8-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927140433.9504-1-phil@nwl.cc>
References: <20190927140433.9504-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support anonymous sets, cache them along with their
elements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix cache flushing: Since set fetching happens only if rules are
  fetched, too, set list may be NULL so call nftnl_set_list_free() and
  nftnl_set_list_foreach() conditionally.
- Support fetching only a specific set from kernel. Make sure no
  duplicate element fetches happen by checking set element count. (If
  non-zero, don't fetch elements.)
- When fetching rules for a single chain, fetch only that table's sets.
---
 iptables/nft.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++--
 iptables/nft.h |   8 ++
 2 files changed, 211 insertions(+), 5 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 6977b8946d08f..f46f13c2501e2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -874,6 +874,14 @@ static int __flush_chain_cache(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
+static int __flush_set_cache(struct nftnl_set *s, void *data)
+{
+	nftnl_set_list_del(s);
+	nftnl_set_free(s);
+
+	return 0;
+}
+
 static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 		       const char *tablename)
 {
@@ -882,10 +890,14 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 
 	if (tablename) {
 		table = __nft_table_builtin_find(tables, tablename);
-		if (!table || !c->table[table->type].chains)
+		if (!table)
 			return 0;
-		nftnl_chain_list_foreach(c->table[table->type].chains,
-					 __flush_chain_cache, NULL);
+		if (c->table[table->type].chains)
+			nftnl_chain_list_foreach(c->table[table->type].chains,
+						 __flush_chain_cache, NULL);
+		if (c->table[table->type].sets)
+			nftnl_set_list_foreach(c->table[table->type].sets,
+					       __flush_set_cache, NULL);
 		return 0;
 	}
 
@@ -898,6 +910,9 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 
 		nftnl_chain_list_free(c->table[i].chains);
 		c->table[i].chains = NULL;
+		if (c->table[i].sets)
+			nftnl_set_list_free(c->table[i].sets);
+		c->table[i].sets = NULL;
 	}
 	nftnl_table_list_free(c->tables);
 	c->tables = NULL;
@@ -1457,6 +1472,159 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+struct nftnl_set_list_cb_data {
+	struct nft_handle *h;
+	const struct builtin_table *t;
+};
+
+static int nftnl_set_list_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_set_list_cb_data *d = data;
+	const struct builtin_table *t = d->t;
+	struct nftnl_set_list *list;
+	struct nft_handle *h = d->h;
+	const char *tname, *sname;
+	struct nftnl_set *s;
+
+	s = nftnl_set_alloc();
+	if (s == NULL)
+		return MNL_CB_OK;
+
+	if (nftnl_set_nlmsg_parse(nlh, s) < 0)
+		goto out_free;
+
+	tname = nftnl_set_get_str(s, NFTNL_SET_TABLE);
+
+	if (!t)
+		t = nft_table_builtin_find(h, tname);
+	else if (strcmp(t->name, tname))
+		goto out_free;
+
+	if (!t)
+		goto out_free;
+
+	list = h->cache->table[t->type].sets;
+	sname = nftnl_set_get_str(s, NFTNL_SET_NAME);
+
+	if (nftnl_set_list_lookup_byname(list, sname))
+		goto out_free;
+
+	nftnl_set_list_add_tail(s, list);
+
+	return MNL_CB_OK;
+out_free:
+	nftnl_set_free(s);
+	return MNL_CB_OK;
+}
+
+static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return nftnl_set_elems_nlmsg_parse(nlh, data) ? -1 : MNL_CB_OK;
+}
+
+static bool set_has_elements(struct nftnl_set *s)
+{
+	struct nftnl_set_elems_iter *iter;
+	bool ret = false;
+
+	iter = nftnl_set_elems_iter_create(s);
+	if (iter) {
+		ret = !!nftnl_set_elems_iter_cur(iter);
+		nftnl_set_elems_iter_destroy(iter);
+	}
+	return ret;
+}
+
+static int set_fetch_elem_cb(struct nftnl_set *s, void *data)
+{
+        char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nft_handle *h = data;
+        struct nlmsghdr *nlh;
+
+	if (set_has_elements(s))
+		return 0;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, h->family,
+				    NLM_F_DUMP, h->seq);
+        nftnl_set_elems_nlmsg_build_payload(nlh, s);
+
+	return mnl_talk(h, nlh, set_elem_cb, s);
+}
+
+static int fetch_set_cache(struct nft_handle *h,
+			   const struct builtin_table *t, const char *set)
+{
+	struct nftnl_set_list_cb_data d = {
+		.h = h,
+		.t = t,
+	};
+	struct nlmsghdr *nlh;
+	char buf[16536];
+	int i, ret;
+
+	if (!t) {
+		fetch_table_cache(h);
+
+		for (i = 0; i < NFT_TABLE_MAX; i++) {
+			enum nft_table_type type = h->tables[i].type;
+
+			if (!h->tables[i].name)
+				continue;
+
+			h->cache->table[type].sets = nftnl_set_list_alloc();
+			if (!h->cache->table[type].sets)
+				return -1;
+		}
+	} else if (!h->cache->table[t->type].sets) {
+		h->cache->table[t->type].sets = nftnl_set_list_alloc();
+	}
+
+	if (t && set) {
+		struct nftnl_set *s = nftnl_set_alloc();
+
+		if (!s)
+			return -1;
+
+		nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, h->family,
+						NLM_F_ACK, h->seq);
+		nftnl_set_set_str(s, NFTNL_SET_TABLE, t->name);
+		nftnl_set_set_str(s, NFTNL_SET_NAME, set);
+		nftnl_set_nlmsg_build_payload(nlh, s);
+		nftnl_set_free(s);
+	} else {
+		nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, h->family,
+						NLM_F_DUMP, h->seq);
+	}
+
+	ret = mnl_talk(h, nlh, nftnl_set_list_cb, &d);
+	if (ret < 0 && errno == EINTR) {
+		assert(nft_restart(h) >= 0);
+		return ret;
+	}
+
+	if (t && set) {
+		struct nftnl_set *s;
+
+		s = nftnl_set_list_lookup_byname(h->cache->table[t->type].sets,
+						 set);
+		set_fetch_elem_cb(s, h);
+	} else if (t) {
+		nftnl_set_list_foreach(h->cache->table[t->type].sets,
+				       set_fetch_elem_cb, h);
+	} else {
+		for (i = 0; i < NFT_TABLE_MAX; i++) {
+			enum nft_table_type type = h->tables[i].type;
+
+			if (!h->tables[i].name)
+				continue;
+
+			nftnl_set_list_foreach(h->cache->table[type].sets,
+					       set_fetch_elem_cb, h);
+		}
+	}
+	return ret;
+}
+
 static int fetch_chain_cache(struct nft_handle *h,
 			     const struct builtin_table *t, const char *chain)
 {
@@ -1651,15 +1819,29 @@ static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c)
 	if (h->have_cache)
 		return 0;
 
-	if (c)
-		return nft_rule_list_update(c, h);
+	if (c) {
+		const struct builtin_table *t;
+		const char *tname;
+
+		tname = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
+		t = nft_table_builtin_find(h, tname);
+		if (!t)
+			return -1;
 
+		if (fetch_set_cache(h, t, NULL))
+			return -1;
+
+		return nft_rule_list_update(c, h);
+	}
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
 		if (!h->tables[i].name)
 			continue;
 
+		if (fetch_set_cache(h, &h->tables[i], NULL))
+			return -1;
+
 		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
 					     nft_rule_list_update, h))
 			return -1;
@@ -1749,6 +1931,22 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	return h->cache->table[t->type].chains;
 }
 
+struct nftnl_set_list *nft_set_list_get(struct nft_handle *h,
+					const char *table,
+					const char *set)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	if (!h->have_cache)
+		fetch_set_cache(h, t, set);
+
+	return h->cache->table[t->type].sets;
+}
+
 static const char *policy_name[NF_ACCEPT+1] = {
 	[NF_DROP] = "DROP",
 	[NF_ACCEPT] = "ACCEPT",
diff --git a/iptables/nft.h b/iptables/nft.h
index bb88f0b796f02..bfee7ba727eaa 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -31,6 +31,7 @@ struct nft_cache {
 	struct nftnl_table_list		*tables;
 	struct {
 		struct nftnl_chain_list *chains;
+		struct nftnl_set_list	*sets;
 		bool			initialized;
 	} table[NFT_TABLE_MAX];
 };
@@ -89,6 +90,13 @@ int nft_table_flush(struct nft_handle *h, const char *table);
 void nft_table_new(struct nft_handle *h, const char *table);
 const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
 
+/*
+ * Operations with sets.
+ */
+struct nftnl_set_list *nft_set_list_get(struct nft_handle *h,
+					const char *table,
+					const char *set);
+
 /*
  * Operations with chains.
  */
-- 
2.23.0

