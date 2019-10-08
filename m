Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A67C4360C
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD0B2070B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 16:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfJHQPY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 12:15:24 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48502 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbfJHQPY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 12:15:24 -0400
Received: from localhost ([::1]:33360 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iHs8w-0004WH-UC; Tue, 08 Oct 2019 18:15:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 07/11] nft-cache: Support partial cache per table
Date:   Tue,  8 Oct 2019 18:14:43 +0200
Message-Id: <20191008161447.6595-8-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191008161447.6595-1-phil@nwl.cc>
References: <20191008161447.6595-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept a builtin_table pointer in __nft_build_cache() and pass it along
when fetching chains and rules to operate on that table only (unless the
pointer is NULL).

Make use of it in nft_chain_list_get() since that accepts a table name
and performs a builtin table lookup internally already.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 82 ++++++++++++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 25 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index a2cfb6ef6dbcf..3cb397c805a9a 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -11,6 +11,7 @@
 
 #include <assert.h>
 #include <errno.h>
+#include <string.h>
 #include <xtables.h>
 
 #include <linux/netfilter/nf_tables.h>
@@ -105,13 +106,19 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+struct nftnl_chain_list_cb_data {
+	struct nft_handle *h;
+	const struct builtin_table *t;
+};
+
 static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_handle *h = data;
-	const struct builtin_table *t;
+	struct nftnl_chain_list_cb_data *d = data;
+	const struct builtin_table *t = d->t;
 	struct nftnl_chain_list *list;
+	struct nft_handle *h = d->h;
+	const char *tname, *cname;
 	struct nftnl_chain *c;
-	const char *cname;
 
 	c = nftnl_chain_alloc();
 	if (c == NULL)
@@ -120,10 +127,15 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
 		goto out;
 
-	t = nft_table_builtin_find(h,
-			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
-	if (!t)
+	tname = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
+
+	if (!t) {
+		t = nft_table_builtin_find(h, tname);
+		if (!t)
+			goto out;
+	} else if (strcmp(t->name, tname)) {
 		goto out;
+	}
 
 	list = h->cache->table[t->type].chains;
 	cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
@@ -140,30 +152,41 @@ err:
 	return MNL_CB_OK;
 }
 
-static int fetch_chain_cache(struct nft_handle *h)
+static int fetch_chain_cache(struct nft_handle *h,
+			     const struct builtin_table *t)
 {
+	struct nftnl_chain_list_cb_data d = {
+		.h = h,
+		.t = t,
+	};
 	char buf[16536];
 	struct nlmsghdr *nlh;
 	int i, ret;
 
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
+	if (!t) {
+		for (i = 0; i < NFT_TABLE_MAX; i++) {
+			enum nft_table_type type = h->tables[i].type;
 
-		if (!h->tables[i].name)
-			continue;
+			if (!h->tables[i].name)
+				continue;
 
-		if (h->cache->table[type].chains)
-			continue;
+			if (h->cache->table[type].chains)
+				continue;
 
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[type].chains)
+			h->cache->table[type].chains = nftnl_chain_list_alloc();
+			if (!h->cache->table[type].chains)
+				return -1;
+		}
+	} else if (!h->cache->table[t->type].chains) {
+		h->cache->table[t->type].chains = nftnl_chain_list_alloc();
+		if (!h->cache->table[t->type].chains)
 			return -1;
 	}
 
 	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
+	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
 
@@ -224,10 +247,14 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int fetch_rule_cache(struct nft_handle *h)
+static int fetch_rule_cache(struct nft_handle *h, const struct builtin_table *t)
 {
 	int i;
 
+	if (t)
+		return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
+						nft_rule_list_update, h);
+
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -241,7 +268,8 @@ static int fetch_rule_cache(struct nft_handle *h)
 	return 0;
 }
 
-static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level)
+static void __nft_build_cache(struct nft_handle *h, enum nft_cache_level level,
+			      const struct builtin_table *t)
 {
 	uint32_t genid_start, genid_stop;
 
@@ -257,12 +285,12 @@ retry:
 			break;
 		/* fall through */
 	case NFT_CL_TABLES:
-		fetch_chain_cache(h);
+		fetch_chain_cache(h, t);
 		if (level == NFT_CL_CHAINS)
 			break;
 		/* fall through */
 	case NFT_CL_CHAINS:
-		fetch_rule_cache(h);
+		fetch_rule_cache(h, t);
 		if (level == NFT_CL_RULES)
 			break;
 		/* fall through */
@@ -276,14 +304,18 @@ retry:
 		goto retry;
 	}
 
-	h->cache_level = level;
+	if (!t)
+		h->cache_level = level;
+	else if (h->cache_level < NFT_CL_TABLES)
+		h->cache_level = NFT_CL_TABLES;
+
 	h->nft_genid = genid_start;
 }
 
 void nft_build_cache(struct nft_handle *h)
 {
 	if (h->cache_level < NFT_CL_RULES)
-		__nft_build_cache(h, NFT_CL_RULES);
+		__nft_build_cache(h, NFT_CL_RULES, NULL);
 }
 
 void nft_fake_cache(struct nft_handle *h)
@@ -382,7 +414,7 @@ void nft_rebuild_cache(struct nft_handle *h)
 		__nft_flush_cache(h);
 
 	h->cache_level = NFT_CL_NONE;
-	__nft_build_cache(h, level);
+	__nft_build_cache(h, level, NULL);
 }
 
 void nft_release_cache(struct nft_handle *h)
@@ -393,7 +425,7 @@ void nft_release_cache(struct nft_handle *h)
 
 struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	__nft_build_cache(h, NFT_CL_TABLES);
+	__nft_build_cache(h, NFT_CL_TABLES, NULL);
 
 	return h->cache->tables;
 }
@@ -407,7 +439,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	if (!t)
 		return NULL;
 
-	__nft_build_cache(h, NFT_CL_CHAINS);
+	__nft_build_cache(h, NFT_CL_CHAINS, t);
 
 	return h->cache->table[t->type].chains;
 }
-- 
2.23.0

