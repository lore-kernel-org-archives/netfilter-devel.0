Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48730C35280
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D1D8205C9
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfJHQP4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:15:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48538 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJHQP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 12:15:56 -0400
Received: from localhost ([::1]:33396 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iHs9S-0004Yv-OC; Tue, 08 Oct 2019 18:15:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 03/11] nft: Extract cache routines into nft-cache.c
Date:   Tue,  8 Oct 2019 18:14:39 +0200
Message-Id: <20191008161447.6595-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008161447.6595-1-phil@nwl.cc>
References: <20191008161447.6595-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The amount of code dealing with caching only is considerable and hence
deserves an own source file.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am       |   2 +-
 iptables/nft-cache.c       | 376 +++++++++++++++++++++++++++++++++++++
 iptables/nft-cache.h       |  17 ++
 iptables/nft.c             | 360 +----------------------------------
 iptables/nft.h             |   8 +-
 iptables/xtables-restore.c |   1 +
 iptables/xtables-save.c    |   1 +
 7 files changed, 404 insertions(+), 361 deletions(-)
 create mode 100644 iptables/nft-cache.c
 create mode 100644 iptables/nft-cache.h

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 21ac7f08b7c1f..fc834e0f7b89e 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -36,7 +36,7 @@ xtables_nft_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
 xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
-				xtables-monitor.c \
+				xtables-monitor.c nft-cache.c \
 				xtables-arp-standalone.c xtables-arp.c \
 				nft-bridge.c \
 				xtables-eb-standalone.c xtables-eb.c \
diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
new file mode 100644
index 0000000000000..5444419a5cc3b
--- /dev/null
+++ b/iptables/nft-cache.c
@@ -0,0 +1,376 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
+ */
+
+#include <assert.h>
+#include <errno.h>
+#include <xtables.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/gen.h>
+#include <libnftnl/table.h>
+
+#include "nft.h"
+#include "nft-cache.h"
+
+static int genid_cb(const struct nlmsghdr *nlh, void *data)
+{
+	uint32_t *genid = data;
+	struct nftnl_gen *gen;
+
+	gen = nftnl_gen_alloc();
+	if (!gen)
+		return MNL_CB_ERROR;
+
+	if (nftnl_gen_nlmsg_parse(nlh, gen) < 0)
+		goto out;
+
+	*genid = nftnl_gen_get_u32(gen, NFTNL_GEN_ID);
+
+	nftnl_gen_free(gen);
+	return MNL_CB_STOP;
+out:
+	nftnl_gen_free(gen);
+	return MNL_CB_ERROR;
+}
+
+static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, 0, 0, h->seq);
+	ret = mnl_talk(h, nlh, genid_cb, genid);
+	if (ret == 0)
+		return;
+
+	xtables_error(RESOURCE_PROBLEM,
+		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
+}
+
+static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_table *t;
+	struct nftnl_table_list *list = data;
+
+	t = nftnl_table_alloc();
+	if (t == NULL)
+		goto err;
+
+	if (nftnl_table_nlmsg_parse(nlh, t) < 0)
+		goto out;
+
+	nftnl_table_list_add_tail(t, list);
+
+	return MNL_CB_OK;
+out:
+	nftnl_table_free(t);
+err:
+	return MNL_CB_OK;
+}
+
+static int fetch_table_cache(struct nft_handle *h)
+{
+	char buf[16536];
+	struct nlmsghdr *nlh;
+	struct nftnl_table_list *list;
+	int ret;
+
+	list = nftnl_table_list_alloc();
+	if (list == NULL)
+		return 0;
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
+					NLM_F_DUMP, h->seq);
+
+	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
+	if (ret < 0 && errno == EINTR)
+		assert(nft_restart(h) >= 0);
+
+	h->cache->tables = list;
+
+	return 1;
+}
+
+static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_handle *h = data;
+	const struct builtin_table *t;
+	struct nftnl_chain *c;
+
+	c = nftnl_chain_alloc();
+	if (c == NULL)
+		goto err;
+
+	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
+		goto out;
+
+	t = nft_table_builtin_find(h,
+			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+	if (!t)
+		goto out;
+
+	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
+
+	return MNL_CB_OK;
+out:
+	nftnl_chain_free(c);
+err:
+	return MNL_CB_OK;
+}
+
+static int fetch_chain_cache(struct nft_handle *h)
+{
+	char buf[16536];
+	struct nlmsghdr *nlh;
+	int i, ret;
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+		if (!h->cache->table[type].chains)
+			return -1;
+	}
+
+	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
+					NLM_F_DUMP, h->seq);
+
+	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
+	if (ret < 0 && errno == EINTR)
+		assert(nft_restart(h) >= 0);
+
+	return ret;
+}
+
+static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nftnl_chain *c = data;
+	struct nftnl_rule *r;
+
+	r = nftnl_rule_alloc();
+	if (r == NULL)
+		return MNL_CB_OK;
+
+	if (nftnl_rule_nlmsg_parse(nlh, r) < 0) {
+		nftnl_rule_free(r);
+		return MNL_CB_OK;
+	}
+
+	nftnl_chain_rule_add_tail(r, c);
+	return MNL_CB_OK;
+}
+
+static int nft_rule_list_update(struct nftnl_chain *c, void *data)
+{
+	struct nft_handle *h = data;
+	char buf[16536];
+	struct nlmsghdr *nlh;
+	struct nftnl_rule *rule;
+	int ret;
+
+	rule = nftnl_rule_alloc();
+	if (!rule)
+		return -1;
+
+	nftnl_rule_set_str(rule, NFTNL_RULE_TABLE,
+			   nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+	nftnl_rule_set_str(rule, NFTNL_RULE_CHAIN,
+			   nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
+					NLM_F_DUMP, h->seq);
+	nftnl_rule_nlmsg_build_payload(nlh, rule);
+
+	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, c);
+	if (ret < 0 && errno == EINTR)
+		assert(nft_restart(h) >= 0);
+
+	nftnl_rule_free(rule);
+
+	if (h->family == NFPROTO_BRIDGE)
+		nft_bridge_chain_postprocess(h, c);
+
+	return 0;
+}
+
+static int fetch_rule_cache(struct nft_handle *h)
+{
+	int i;
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
+					     nft_rule_list_update, h))
+			return -1;
+	}
+	return 0;
+}
+
+static void __nft_build_cache(struct nft_handle *h)
+{
+	uint32_t genid_start, genid_stop;
+
+retry:
+	mnl_genid_get(h, &genid_start);
+	fetch_table_cache(h);
+	fetch_chain_cache(h);
+	fetch_rule_cache(h);
+	h->have_cache = true;
+	mnl_genid_get(h, &genid_stop);
+
+	if (genid_start != genid_stop) {
+		flush_chain_cache(h, NULL);
+		goto retry;
+	}
+
+	h->nft_genid = genid_start;
+}
+
+void nft_build_cache(struct nft_handle *h)
+{
+	if (!h->have_cache)
+		__nft_build_cache(h);
+}
+
+void nft_fake_cache(struct nft_handle *h)
+{
+	int i;
+
+	fetch_table_cache(h);
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+	}
+	h->have_cache = true;
+	mnl_genid_get(h, &h->nft_genid);
+}
+
+static void __nft_flush_cache(struct nft_handle *h)
+{
+	if (!h->cache_index) {
+		h->cache_index++;
+		h->cache = &h->__cache[h->cache_index];
+	} else {
+		flush_chain_cache(h, NULL);
+	}
+}
+
+static int __flush_rule_cache(struct nftnl_rule *r, void *data)
+{
+	nftnl_rule_list_del(r);
+	nftnl_rule_free(r);
+
+	return 0;
+}
+
+void flush_rule_cache(struct nftnl_chain *c)
+{
+	nftnl_rule_foreach(c, __flush_rule_cache, NULL);
+}
+
+static int __flush_chain_cache(struct nftnl_chain *c, void *data)
+{
+	nftnl_chain_list_del(c);
+	nftnl_chain_free(c);
+
+	return 0;
+}
+
+static int flush_cache(struct nft_handle *h, struct nft_cache *c,
+		       const char *tablename)
+{
+	const struct builtin_table *table;
+	int i;
+
+	if (tablename) {
+		table = nft_table_builtin_find(h, tablename);
+		if (!table || !c->table[table->type].chains)
+			return 0;
+		nftnl_chain_list_foreach(c->table[table->type].chains,
+					 __flush_chain_cache, NULL);
+		return 0;
+	}
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		if (h->tables[i].name == NULL)
+			continue;
+
+		if (!c->table[i].chains)
+			continue;
+
+		nftnl_chain_list_free(c->table[i].chains);
+		c->table[i].chains = NULL;
+	}
+	nftnl_table_list_free(c->tables);
+	c->tables = NULL;
+
+	return 1;
+}
+
+void flush_chain_cache(struct nft_handle *h, const char *tablename)
+{
+	if (!h->have_cache)
+		return;
+
+	if (flush_cache(h, h->cache, tablename))
+		h->have_cache = false;
+}
+
+void nft_rebuild_cache(struct nft_handle *h)
+{
+	if (h->have_cache)
+		__nft_flush_cache(h);
+
+	__nft_build_cache(h);
+}
+
+void nft_release_cache(struct nft_handle *h)
+{
+	if (h->cache_index)
+		flush_cache(h, &h->__cache[0], NULL);
+}
+
+struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
+{
+	if (!h->cache->tables)
+		fetch_table_cache(h);
+
+	return h->cache->tables;
+}
+
+struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
+					    const char *table)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	nft_build_cache(h);
+
+	return h->cache->table[t->type].chains;
+}
+
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
new file mode 100644
index 0000000000000..423c6516de9bb
--- /dev/null
+++ b/iptables/nft-cache.h
@@ -0,0 +1,17 @@
+#ifndef _NFT_CACHE_H_
+#define _NFT_CACHE_H_
+
+struct nft_handle;
+
+void nft_fake_cache(struct nft_handle *h);
+void nft_build_cache(struct nft_handle *h);
+void nft_rebuild_cache(struct nft_handle *h);
+void nft_release_cache(struct nft_handle *h);
+void flush_chain_cache(struct nft_handle *h, const char *tablename);
+void flush_rule_cache(struct nftnl_chain *c);
+
+struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
+					    const char *table);
+struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h);
+
+#endif /* _NFT_CACHE_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 3228842cd3c8b..81de10d8a0892 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -55,47 +55,12 @@
 
 #include "nft.h"
 #include "xshared.h" /* proto_to_name */
+#include "nft-cache.h"
 #include "nft-shared.h"
 #include "nft-bridge.h" /* EBT_NOPROTO */
 
 static void *nft_fn;
 
-static int genid_cb(const struct nlmsghdr *nlh, void *data)
-{
-	uint32_t *genid = data;
-	struct nftnl_gen *gen;
-
-	gen = nftnl_gen_alloc();
-	if (!gen)
-		return MNL_CB_ERROR;
-
-	if (nftnl_gen_nlmsg_parse(nlh, gen) < 0)
-		goto out;
-
-	*genid = nftnl_gen_get_u32(gen, NFTNL_GEN_ID);
-
-	nftnl_gen_free(gen);
-	return MNL_CB_STOP;
-out:
-	nftnl_gen_free(gen);
-	return MNL_CB_ERROR;
-}
-
-static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
-{
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	int ret;
-
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, 0, 0, h->seq);
-	ret = mnl_talk(h, nlh, genid_cb, genid);
-	if (ret == 0)
-		return;
-
-	xtables_error(RESOURCE_PROBLEM,
-		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
-}
-
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data),
 	     void *data)
@@ -791,7 +756,7 @@ static bool nft_chain_builtin(struct nftnl_chain *c)
 	return nftnl_chain_get(c, NFTNL_CHAIN_HOOKNUM) != NULL;
 }
 
-static int nft_restart(struct nft_handle *h)
+int nft_restart(struct nft_handle *h)
 {
 	mnl_socket_close(h->nl);
 
@@ -830,67 +795,6 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 	return 0;
 }
 
-static int __flush_rule_cache(struct nftnl_rule *r, void *data)
-{
-	nftnl_rule_list_del(r);
-	nftnl_rule_free(r);
-
-	return 0;
-}
-
-static void flush_rule_cache(struct nftnl_chain *c)
-{
-	nftnl_rule_foreach(c, __flush_rule_cache, NULL);
-}
-
-static int __flush_chain_cache(struct nftnl_chain *c, void *data)
-{
-	nftnl_chain_list_del(c);
-	nftnl_chain_free(c);
-
-	return 0;
-}
-
-static int flush_cache(struct nft_handle *h, struct nft_cache *c,
-		       const char *tablename)
-{
-	const struct builtin_table *table;
-	int i;
-
-	if (tablename) {
-		table = nft_table_builtin_find(h, tablename);
-		if (!table || !c->table[table->type].chains)
-			return 0;
-		nftnl_chain_list_foreach(c->table[table->type].chains,
-					 __flush_chain_cache, NULL);
-		return 0;
-	}
-
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		if (h->tables[i].name == NULL)
-			continue;
-
-		if (!c->table[i].chains)
-			continue;
-
-		nftnl_chain_list_free(c->table[i].chains);
-		c->table[i].chains = NULL;
-	}
-	nftnl_table_list_free(c->tables);
-	c->tables = NULL;
-
-	return 1;
-}
-
-static void flush_chain_cache(struct nft_handle *h, const char *tablename)
-{
-	if (!h->have_cache)
-		return;
-
-	if (flush_cache(h, h->cache, tablename))
-		h->have_cache = false;
-}
-
 void nft_fini(struct nft_handle *h)
 {
 	flush_chain_cache(h, NULL);
@@ -1337,104 +1241,6 @@ nft_rule_print_save(const struct nftnl_rule *r, enum nft_rule_print type,
 		ops->clear_cs(&cs);
 }
 
-static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nft_handle *h = data;
-	const struct builtin_table *t;
-	struct nftnl_chain *c;
-
-	c = nftnl_chain_alloc();
-	if (c == NULL)
-		goto err;
-
-	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
-		goto out;
-
-	t = nft_table_builtin_find(h,
-			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
-	if (!t)
-		goto out;
-
-	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
-
-	return MNL_CB_OK;
-out:
-	nftnl_chain_free(c);
-err:
-	return MNL_CB_OK;
-}
-
-static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nftnl_table *t;
-	struct nftnl_table_list *list = data;
-
-	t = nftnl_table_alloc();
-	if (t == NULL)
-		goto err;
-
-	if (nftnl_table_nlmsg_parse(nlh, t) < 0)
-		goto out;
-
-	nftnl_table_list_add_tail(t, list);
-
-	return MNL_CB_OK;
-out:
-	nftnl_table_free(t);
-err:
-	return MNL_CB_OK;
-}
-
-static int fetch_table_cache(struct nft_handle *h)
-{
-	char buf[16536];
-	struct nlmsghdr *nlh;
-	struct nftnl_table_list *list;
-	int ret;
-
-	list = nftnl_table_list_alloc();
-	if (list == NULL)
-		return 0;
-
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
-					NLM_F_DUMP, h->seq);
-
-	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
-	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
-
-	h->cache->tables = list;
-
-	return 1;
-}
-
-static int fetch_chain_cache(struct nft_handle *h)
-{
-	char buf[16536];
-	struct nlmsghdr *nlh;
-	int i, ret;
-
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
-
-		if (!h->tables[i].name)
-			continue;
-
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[type].chains)
-			return -1;
-	}
-
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
-					NLM_F_DUMP, h->seq);
-
-	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
-	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
-
-	return ret;
-}
-
 static bool nft_rule_is_policy_rule(struct nftnl_rule *r)
 {
 	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
@@ -1473,8 +1279,8 @@ static struct nftnl_rule *nft_chain_last_rule(struct nftnl_chain *c)
 	return last;
 }
 
-static void nft_bridge_chain_postprocess(struct nft_handle *h,
-					 struct nftnl_chain *c)
+void nft_bridge_chain_postprocess(struct nft_handle *h,
+				  struct nftnl_chain *c)
 {
 	struct nftnl_rule *last = nft_chain_last_rule(c);
 	struct nftnl_expr_iter *iter;
@@ -1515,156 +1321,6 @@ static void nft_bridge_chain_postprocess(struct nft_handle *h,
 out_iter:
 	nftnl_expr_iter_destroy(iter);
 }
-
-static int nftnl_rule_list_cb(const struct nlmsghdr *nlh, void *data)
-{
-	struct nftnl_chain *c = data;
-	struct nftnl_rule *r;
-
-	r = nftnl_rule_alloc();
-	if (r == NULL)
-		return MNL_CB_OK;
-
-	if (nftnl_rule_nlmsg_parse(nlh, r) < 0) {
-		nftnl_rule_free(r);
-		return MNL_CB_OK;
-	}
-
-	nftnl_chain_rule_add_tail(r, c);
-	return MNL_CB_OK;
-}
-
-static int nft_rule_list_update(struct nftnl_chain *c, void *data)
-{
-	struct nft_handle *h = data;
-	char buf[16536];
-	struct nlmsghdr *nlh;
-	struct nftnl_rule *rule;
-	int ret;
-
-	rule = nftnl_rule_alloc();
-	if (!rule)
-		return -1;
-
-	nftnl_rule_set_str(rule, NFTNL_RULE_TABLE,
-			   nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
-	nftnl_rule_set_str(rule, NFTNL_RULE_CHAIN,
-			   nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
-
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, h->family,
-					NLM_F_DUMP, h->seq);
-	nftnl_rule_nlmsg_build_payload(nlh, rule);
-
-	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, c);
-	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
-
-	nftnl_rule_free(rule);
-
-	if (h->family == NFPROTO_BRIDGE)
-		nft_bridge_chain_postprocess(h, c);
-
-	return 0;
-}
-
-static int fetch_rule_cache(struct nft_handle *h)
-{
-	int i;
-
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
-
-		if (!h->tables[i].name)
-			continue;
-
-		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
-					     nft_rule_list_update, h))
-			return -1;
-	}
-	return 0;
-}
-
-static void __nft_build_cache(struct nft_handle *h)
-{
-	uint32_t genid_start, genid_stop;
-
-retry:
-	mnl_genid_get(h, &genid_start);
-	fetch_table_cache(h);
-	fetch_chain_cache(h);
-	fetch_rule_cache(h);
-	h->have_cache = true;
-	mnl_genid_get(h, &genid_stop);
-
-	if (genid_start != genid_stop) {
-		flush_chain_cache(h, NULL);
-		goto retry;
-	}
-
-	h->nft_genid = genid_start;
-}
-
-void nft_fake_cache(struct nft_handle *h)
-{
-	int i;
-
-	fetch_table_cache(h);
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
-
-		if (!h->tables[i].name)
-			continue;
-
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-	}
-	h->have_cache = true;
-	mnl_genid_get(h, &h->nft_genid);
-}
-
-void nft_build_cache(struct nft_handle *h)
-{
-	if (!h->have_cache)
-		__nft_build_cache(h);
-}
-
-static void __nft_flush_cache(struct nft_handle *h)
-{
-	if (!h->cache_index) {
-		h->cache_index++;
-		h->cache = &h->__cache[h->cache_index];
-	} else {
-		flush_chain_cache(h, NULL);
-	}
-}
-
-static void nft_rebuild_cache(struct nft_handle *h)
-{
-	if (h->have_cache)
-		__nft_flush_cache(h);
-
-	__nft_build_cache(h);
-}
-
-static void nft_release_cache(struct nft_handle *h)
-{
-	if (h->cache_index)
-		flush_cache(h, &h->__cache[0], NULL);
-}
-
-struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table)
-{
-	const struct builtin_table *t;
-
-	t = nft_table_builtin_find(h, table);
-	if (!t)
-		return NULL;
-
-	nft_build_cache(h);
-
-	return h->cache->table[t->type].chains;
-}
-
 static const char *policy_name[NF_ACCEPT+1] = {
 	[NF_DROP] = "DROP",
 	[NF_ACCEPT] = "ACCEPT",
@@ -2054,14 +1710,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	return ret == 0 ? 1 : 0;
 }
 
-static struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
-{
-	if (!h->cache->tables)
-		fetch_table_cache(h);
-
-	return h->cache->tables;
-}
-
 bool nft_table_find(struct nft_handle *h, const char *tablename)
 {
 	struct nftnl_table_list_iter *iter;
diff --git a/iptables/nft.h b/iptables/nft.h
index bcac8e228c787..451c266016d8d 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -73,8 +73,7 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     void *data);
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
-void nft_fake_cache(struct nft_handle *h);
-void nft_build_cache(struct nft_handle *h);
+int nft_restart(struct nft_handle *h);
 
 /*
  * Operations with tables.
@@ -95,8 +94,6 @@ const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const c
 struct nftnl_chain;
 
 int nft_chain_set(struct nft_handle *h, const char *table, const char *chain, const char *policy, const struct xt_counters *counters);
-struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
-					    const char *table);
 int nft_chain_save(struct nft_handle *h, struct nftnl_chain_list *list);
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table, bool verbose);
@@ -105,6 +102,9 @@ int nft_chain_user_rename(struct nft_handle *h, const char *chain, const char *t
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain, const char *table, bool verbose);
 const struct builtin_chain *nft_chain_builtin_find(const struct builtin_table *t, const char *chain);
 bool nft_chain_exists(struct nft_handle *h, const char *table, const char *chain);
+void nft_bridge_chain_postprocess(struct nft_handle *h,
+				  struct nftnl_chain *c);
+
 
 /*
  * Operations with rule-set.
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 7f28a05c68619..7641955d1ce53 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -18,6 +18,7 @@
 #include "xtables-multi.h"
 #include "nft.h"
 #include "nft-bridge.h"
+#include "nft-cache.h"
 #include <libnftnl/chain.h>
 
 static int counters, verbose;
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 77b13f7ffbcdd..3741888f9af44 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -21,6 +21,7 @@
 #include "iptables.h"
 #include "xtables-multi.h"
 #include "nft.h"
+#include "nft-cache.h"
 
 #include <libnftnl/chain.h>
 
-- 
2.23.0

