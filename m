Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1790C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 12:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85CD82086A
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 12:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgGWMQC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:16:02 -0400
Received: from correo.us.es ([193.147.175.20]:36804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbgGWMQB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 08:16:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C08D3C2FE5
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:15:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0157DA78E
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:15:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A5B0EDA789; Thu, 23 Jul 2020 14:15:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50562DA722
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:15:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 Jul 2020 14:15:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3D4CE42EE38E
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 14:15:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] iptables: replace libnftnl table list by linux list
Date:   Thu, 23 Jul 2020 14:15:53 +0200
Message-Id: <20200723121553.7400-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch removes the libnftnl table list by linux list. This comes
with an extra memory allocation to store the nft_table object. Probably,
there is no need to cache the entire nftnl_table in the near future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-cache.c | 72 ++++++++++++++++++++++++++++--------------
 iptables/nft-cache.h | 10 +++++-
 iptables/nft.c       | 74 +++++++++++---------------------------------
 iptables/nft.h       |  2 +-
 4 files changed, 77 insertions(+), 81 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 638b18bc7e38..a35e06d736fa 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -107,50 +107,78 @@ static void mnl_genid_get(struct nft_handle *h, uint32_t *genid)
 		      "Could not fetch rule set generation id: %s\n", nft_strerror(errno));
 }
 
+static struct nft_table *nft_table_alloc(void)
+{
+	struct nftnl_table *nftnl;
+	struct nft_table *table;
+
+	table = malloc(sizeof(struct nft_table));
+	if (!table)
+		return NULL;
+
+	nftnl = nftnl_table_alloc();
+	if (!nftnl) {
+		free(table);
+		return NULL;
+	}
+	table->nftnl = nftnl;
+
+	return table;
+}
+
+static void nft_table_free(struct nft_table *table)
+{
+	nftnl_table_free(table->nftnl);
+	free(table);
+}
+
+static void nft_table_list_free(struct list_head *table_list)
+{
+	struct nft_table *table, *next;
+
+	list_for_each_entry_safe(table, next, table_list, list) {
+		list_del(&table->list);
+		nft_table_free(table);
+	}
+}
+
 static int nftnl_table_list_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nftnl_table *t;
-	struct nftnl_table_list *list = data;
+	struct list_head *list = data;
+	struct nft_table *t;
 
-	t = nftnl_table_alloc();
-	if (t == NULL)
+	t = nft_table_alloc();
+	if (!t)
 		goto err;
 
-	if (nftnl_table_nlmsg_parse(nlh, t) < 0)
+	if (nftnl_table_nlmsg_parse(nlh, t->nftnl) < 0)
 		goto out;
 
-	nftnl_table_list_add_tail(t, list);
+	list_add_tail(&t->list, list);
 
 	return MNL_CB_OK;
 out:
-	nftnl_table_free(t);
+	nft_table_free(t);
 err:
 	return MNL_CB_OK;
 }
 
 static int fetch_table_cache(struct nft_handle *h)
 {
-	char buf[16536];
 	struct nlmsghdr *nlh;
-	struct nftnl_table_list *list;
+	char buf[16536];
 	int i, ret;
 
-	if (h->cache->tables)
-		return 0;
-
-	list = nftnl_table_list_alloc();
-	if (list == NULL)
+	if (!list_empty(&h->cache->tables))
 		return 0;
 
 	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
+	ret = mnl_talk(h, nlh, nftnl_table_list_cb, &h->cache->tables);
 	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
 
-	h->cache->tables = list;
-
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -613,10 +641,8 @@ static int flush_cache(struct nft_handle *h, struct nft_cache *c,
 			c->table[i].sets = NULL;
 		}
 	}
-	if (c->tables) {
-		nftnl_table_list_free(c->tables);
-		c->tables = NULL;
-	}
+	if (!list_empty(&c->tables))
+		nft_table_list_free(&c->tables);
 
 	return 1;
 }
@@ -689,9 +715,9 @@ void nft_release_cache(struct nft_handle *h)
 	}
 }
 
-struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
+struct list_head *nft_table_list_get(struct nft_handle *h)
 {
-	return h->cache->tables;
+	return &h->cache->tables;
 }
 
 struct nftnl_set_list *
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index f429118041be..aeab4bdef904 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -1,6 +1,8 @@
 #ifndef _NFT_CACHE_H_
 #define _NFT_CACHE_H_
 
+#include <libiptc/linux_list.h>
+
 struct nft_handle;
 struct nft_cmd;
 
@@ -17,6 +19,12 @@ struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
 struct nftnl_set_list *
 nft_set_list_get(struct nft_handle *h, const char *table, const char *set);
-struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h);
+struct list_head *nft_table_list_get(struct nft_handle *h);
+
+struct nft_table {
+	struct list_head        list;
+	struct nftnl_table      *nftnl;
+};
+
 
 #endif /* _NFT_CACHE_H_ */
diff --git a/iptables/nft.c b/iptables/nft.c
index 0c5a74fc232c..ee4ce6f2fc68 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -843,6 +843,8 @@ int nft_init(struct nft_handle *h, int family, const struct builtin_table *t)
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
 	INIT_LIST_HEAD(&h->cmd_list);
+	INIT_LIST_HEAD(&h->__cache[0].tables);
+	INIT_LIST_HEAD(&h->__cache[1].tables);
 	INIT_LIST_HEAD(&h->cache_req.chain_list);
 
 	return 0;
@@ -1964,35 +1966,22 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 
 bool nft_table_find(struct nft_handle *h, const char *tablename)
 {
-	struct nftnl_table_list_iter *iter;
-	struct nftnl_table_list *list;
-	struct nftnl_table *t;
+	struct list_head *list;
+	struct nft_table *t;
 	bool ret = false;
 
-	list = nftnl_table_list_get(h);
-	if (list == NULL)
-		goto err;
-
-	iter = nftnl_table_list_iter_create(list);
-	if (iter == NULL)
-		goto err;
+	list = nft_table_list_get(h);
 
-	t = nftnl_table_list_iter_next(iter);
-	while (t != NULL) {
+	list_for_each_entry(t, list, list) {
 		const char *this_tablename =
-			nftnl_table_get(t, NFTNL_TABLE_NAME);
+			nftnl_table_get(t->nftnl, NFTNL_TABLE_NAME);
 
 		if (strcmp(tablename, this_tablename) == 0) {
 			ret = true;
 			break;
 		}
-
-		t = nftnl_table_list_iter_next(iter);
 	}
 
-	nftnl_table_list_iter_destroy(iter);
-
-err:
 	return ret;
 }
 
@@ -2000,29 +1989,18 @@ int nft_for_each_table(struct nft_handle *h,
 		       int (*func)(struct nft_handle *h, const char *tablename, void *data),
 		       void *data)
 {
-	struct nftnl_table_list *list;
-	struct nftnl_table_list_iter *iter;
-	struct nftnl_table *t;
+	struct list_head *list;
+	struct nft_table *t;
 
-	list = nftnl_table_list_get(h);
-	if (list == NULL)
-		return -1;
+	list = nft_table_list_get(h);
 
-	iter = nftnl_table_list_iter_create(list);
-	if (iter == NULL)
-		return -1;
-
-	t = nftnl_table_list_iter_next(iter);
-	while (t != NULL) {
+	list_for_each_entry(t, list, list) {
 		const char *tablename =
-			nftnl_table_get(t, NFTNL_TABLE_NAME);
+			nftnl_table_get(t->nftnl, NFTNL_TABLE_NAME);
 
 		func(h, tablename, data);
-
-		t = nftnl_table_list_iter_next(iter);
 	}
 
-	nftnl_table_list_iter_destroy(iter);
 	return 0;
 }
 
@@ -2058,43 +2036,27 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 
 int nft_table_flush(struct nft_handle *h, const char *table)
 {
-	struct nftnl_table_list_iter *iter;
-	struct nftnl_table_list *list;
-	struct nftnl_table *t;
+	struct list_head *list;
+	struct nft_table *t;
 	bool exists = false;
 	int ret = 0;
 
 	nft_fn = nft_table_flush;
 
-	list = nftnl_table_list_get(h);
-	if (list == NULL) {
-		ret = -1;
-		goto err_out;
-	}
+	list = nft_table_list_get(h);
 
-	iter = nftnl_table_list_iter_create(list);
-	if (iter == NULL) {
-		ret = -1;
-		goto err_table_list;
-	}
-
-	t = nftnl_table_list_iter_next(iter);
-	while (t != NULL) {
+	list_for_each_entry(t, list, list) {
 		const char *table_name =
-			nftnl_table_get_str(t, NFTNL_TABLE_NAME);
+			nftnl_table_get_str(t->nftnl, NFTNL_TABLE_NAME);
 
 		if (strcmp(table_name, table) == 0) {
 			exists = true;
 			break;
 		}
-
-		t = nftnl_table_list_iter_next(iter);
 	}
 
 	ret = __nft_table_flush(h, table, exists);
-	nftnl_table_list_iter_destroy(iter);
-err_table_list:
-err_out:
+
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index bd783231156b..4b83dca09609 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -38,7 +38,7 @@ enum nft_cache_level {
 };
 
 struct nft_cache {
-	struct nftnl_table_list		*tables;
+	struct list_head		tables;
 	struct {
 		struct nftnl_chain_list *chains;
 		struct nftnl_set_list	*sets;
-- 
2.20.1

