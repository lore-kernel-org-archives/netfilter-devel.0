Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA34C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88B42068D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKURg5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:36:57 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41622 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfKURg5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:36:57 -0500
Received: from localhost ([::1]:54712 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iXqNy-0006IM-Kh; Thu, 21 Nov 2019 18:36:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 07/12] nft: Introduce NFT_CL_SETS cache level
Date:   Thu, 21 Nov 2019 18:36:42 +0100
Message-Id: <20191121173647.31488-8-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121173647.31488-1-phil@nwl.cc>
References: <20191121173647.31488-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support anonymous sets, introduce an intermediate cache
level between NFT_CL_CHAINS and NFT_CL_RULES. Actually chains are not
needed to fetch sets, but given that sets are only needed for rules, put
it late to not slow down fetching chains.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Whitespace fixup.

Changes since v2:
- Introduce NFT_CL_SETS and integrate fetch_set_cache() into
  __nft_build_cache() instead of calling from fetch_rule_cache().
- Extend __nft_build_cache() parameters to optionally take a set name to
  fetch.
- Don't fetch tables from fetch_set_cache(), cache leveling takes care
  of that.

Changes since v1:
- Fix cache flushing: Since set fetching happens only if rules are
  fetched, too, set list may be NULL so call nftnl_set_list_free() and
  nftnl_set_list_foreach() conditionally.
- Support fetching only a specific set from kernel. Make sure no
  duplicate element fetches happen by checking set element count. (If
  non-zero, don't fetch elements.)
- When fetching rules for a single chain, fetch only that table's sets.
---
 iptables/nft-cache.c | 205 +++++++++++++++++++++++++++++++++++++++++--
 iptables/nft-cache.h |   2 +
 iptables/nft.h       |   2 +
 3 files changed, 200 insertions(+), 9 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index c55970d074a76..7345a27e2894b 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -18,6 +18,7 @@
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
+#include <libnftnl/set.h>
 #include <libnftnl/table.h>
 
 #include "nft.h"
@@ -152,6 +153,157 @@ err:
 	return MNL_CB_OK;
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
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nft_handle *h = data;
+	struct nlmsghdr *nlh;
+
+	if (set_has_elements(s))
+		return 0;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, h->family,
+				    NLM_F_DUMP, h->seq);
+	nftnl_set_elems_nlmsg_build_payload(nlh, s);
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
 			     const struct builtin_table *t,
 			     const char *chain)
@@ -297,7 +449,8 @@ static int fetch_rule_cache(struct nft_handle *h,
 
 static void
 __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
-		  const struct builtin_table *t, const char *chain)
+		  const struct builtin_table *t, const char *set,
+		  const char *chain)
 {
 	uint32_t genid_start, genid_stop;
 
@@ -321,6 +474,11 @@ retry:
 			break;
 		/* fall through */
 	case NFT_CL_CHAINS:
+		fetch_set_cache(h, t, set);
+		if (level == NFT_CL_SETS)
+			break;
+		/* fall through */
+	case NFT_CL_SETS:
 		fetch_rule_cache(h, t, chain);
 		if (level == NFT_CL_RULES)
 			break;
@@ -349,12 +507,12 @@ void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c)
 	const char *table, *chain;
 
 	if (!c)
-		return __nft_build_cache(h, NFT_CL_RULES, NULL, NULL);
+		return __nft_build_cache(h, NFT_CL_RULES, NULL, NULL, NULL);
 
 	table = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
 	chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	t = nft_table_builtin_find(h, table);
-	__nft_build_cache(h, NFT_CL_RULES, t, chain);
+	__nft_build_cache(h, NFT_CL_RULES, t, NULL, chain);
 }
 
 void nft_fake_cache(struct nft_handle *h)
@@ -421,6 +579,14 @@ static int __flush_chain_cache(struct nftnl_chain *c, void *data)
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
 static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 		       const char *tablename)
 {
@@ -429,10 +595,14 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
 	if (tablename) {
 		table = nft_table_builtin_find(h, tablename);
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
 
@@ -445,6 +615,9 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 
 		nftnl_chain_list_free(c->table[i].chains);
 		c->table[i].chains = NULL;
+		if (c->table[i].sets)
+			nftnl_set_list_free(c->table[i].sets);
+		c->table[i].sets = NULL;
 	}
 	nftnl_table_list_free(c->tables);
 	c->tables = NULL;
@@ -469,7 +642,7 @@ void nft_rebuild_cache(struct nft_handle *h)
 		__nft_flush_cache(h);
 
 	h->cache_level = NFT_CL_NONE;
-	__nft_build_cache(h, level, NULL, NULL);
+	__nft_build_cache(h, level, NULL, NULL, NULL);
 }
 
 void nft_release_cache(struct nft_handle *h)
@@ -480,11 +653,25 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	__nft_build_cache(h, NFT_CL_TABLES, NULL, NULL);
+	__nft_build_cache(h, NFT_CL_TABLES, NULL, NULL, NULL);
 
 	return h->cache->tables;
 }
 
+struct nftnl_set_list *
+nft_set_list_get(struct nft_handle *h, const char *table, const char *set)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	__nft_build_cache(h, NFT_CL_RULES, t, set, NULL);
+
+	return h->cache->table[t->type].sets;
+}
+
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
 {
@@ -494,7 +681,7 @@ nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain)
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_CHAINS, t, chain);
+	__nft_build_cache(h, NFT_CL_CHAINS, t, NULL, chain);
 
 	return h->cache->table[t->type].chains;
 }
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index cb7a7688be37a..ed498835676e2 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -13,6 +13,8 @@ int flush_rule_cache(struct nft_handle *h, const char *table,
 
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
+struct nftnl_set_list *
+nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h);
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/iptables/nft.h b/iptables/nft.h
index e157b525cffdc..51b5660314c0c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -31,6 +31,7 @@ enum nft_cache_level {
 	NFT_CL_NONE,
 	NFT_CL_TABLES,
 	NFT_CL_CHAINS,
+	NFT_CL_SETS,
 	NFT_CL_RULES
 };
 
@@ -38,6 +39,7 @@ struct nft_cache {
 	struct nftnl_table_list		*tables;
 	struct {
 		struct nftnl_chain_list *chains;
+		struct nftnl_set_list	*sets;
 		bool			initialized;
 	} table[NFT_TABLE_MAX];
 };
-- 
2.24.0

