Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B44C04AAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4925120815
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbfETM05 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:26:57 -0400
Received: from mail.us.es ([193.147.175.20]:34190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389429AbfETM04 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:26:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90F34DA707
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F979DA70A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74EE4DA70E; Mon, 20 May 2019 14:26:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 599A0DA70A;
        Mon, 20 May 2019 14:26:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 14:26:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BBEC4265A32;
        Mon, 20 May 2019 14:26:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 1/6] nft: add struct nft_cache
Date:   Mon, 20 May 2019 14:26:41 +0200
Message-Id: <20190520122646.17788-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520122646.17788-1-pablo@netfilter.org>
References: <20190520122646.17788-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new structure that encloses the cache and update the code to use it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 31 ++++++++++++++++---------------
 iptables/nft.h | 13 +++++++++----
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index dab1db59ec97..167237ab45b1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -631,7 +631,7 @@ const struct builtin_table xtables_bridge[NFT_TABLE_MAX] = {
 static bool nft_table_initialized(const struct nft_handle *h,
 				  enum nft_table_type type)
 {
-	return h->table[type].initialized;
+	return h->cache->table[type].initialized;
 }
 
 static int nft_table_builtin_add(struct nft_handle *h,
@@ -685,7 +685,7 @@ static void nft_chain_builtin_add(struct nft_handle *h,
 		return;
 
 	batch_chain_add(h, NFT_COMPAT_CHAIN_ADD, c);
-	nftnl_chain_list_add_tail(c, h->table[table->type].chain_cache);
+	nftnl_chain_list_add_tail(c, h->cache->table[table->type].chains);
 }
 
 /* find if built-in table already exists */
@@ -763,7 +763,7 @@ static int nft_xt_builtin_init(struct nft_handle *h, const char *table)
 
 	nft_chain_builtin_init(h, t);
 
-	h->table[t->type].initialized = true;
+	h->cache->table[t->type].initialized = true;
 
 	return 0;
 }
@@ -805,6 +805,7 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
+	h->cache = &h->__cache;
 
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
@@ -840,9 +841,9 @@ static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 
 	if (tablename) {
 		table = nft_table_builtin_find(h, tablename);
-		if (!table || !h->table[table->type].chain_cache)
+		if (!table || !h->cache->table[table->type].chains)
 			return;
-		nftnl_chain_list_foreach(h->table[table->type].chain_cache,
+		nftnl_chain_list_foreach(h->cache->table[table->type].chains,
 					 __flush_chain_cache, NULL);
 		return;
 	}
@@ -851,11 +852,11 @@ static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 		if (h->tables[i].name == NULL)
 			continue;
 
-		if (!h->table[i].chain_cache)
+		if (!h->cache->table[i].chains)
 			continue;
 
-		nftnl_chain_list_free(h->table[i].chain_cache);
-		h->table[i].chain_cache = NULL;
+		nftnl_chain_list_free(h->cache->table[i].chains);
+		h->cache->table[i].chains = NULL;
 	}
 	h->have_cache = false;
 }
@@ -1326,7 +1327,7 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	if (!t)
 		goto out;
 
-	nftnl_chain_list_add_tail(c, h->table[t->type].chain_cache);
+	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
 
 	return MNL_CB_OK;
 out:
@@ -1348,8 +1349,8 @@ retry:
 		if (!h->tables[i].name)
 			continue;
 
-		h->table[type].chain_cache = nftnl_chain_list_alloc();
-		if (!h->table[type].chain_cache)
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+		if (!h->cache->table[type].chains)
 			return -1;
 	}
 
@@ -1517,7 +1518,7 @@ static int fetch_rule_cache(struct nft_handle *h)
 		if (!h->tables[i].name)
 			continue;
 
-		if (nftnl_chain_list_foreach(h->table[type].chain_cache,
+		if (nftnl_chain_list_foreach(h->cache->table[type].chains,
 					     nft_rule_list_update, h))
 			return -1;
 	}
@@ -1558,7 +1559,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 
 	nft_build_cache(h);
 
-	return h->table[t->type].chain_cache;
+	return h->cache->table[t->type].chains;
 }
 
 static const char *policy_name[NF_ACCEPT+1] = {
@@ -2088,7 +2089,7 @@ static int __nft_table_flush(struct nft_handle *h, const char *table, bool exist
 
 	_t = nft_table_builtin_find(h, table);
 	assert(_t);
-	h->table[_t->type].initialized = false;
+	h->cache->table[_t->type].initialized = false;
 
 	flush_chain_cache(h, table);
 
@@ -3021,7 +3022,7 @@ static void nft_bridge_commit_prepare(struct nft_handle *h)
 		if (!t->name)
 			continue;
 
-		list = h->table[t->type].chain_cache;
+		list = h->cache->table[t->type].chains;
 		if (!list)
 			continue;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 23bd2b79884c..8292a2922d6a 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -27,6 +27,13 @@ struct builtin_table {
 	struct builtin_chain chains[NF_INET_NUMHOOKS];
 };
 
+struct nft_cache {
+	struct {
+		struct nftnl_chain_list *chains;
+		bool			initialized;
+	} table[NFT_TABLE_MAX];
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -40,10 +47,8 @@ struct nft_handle {
 	struct list_head	err_list;
 	struct nft_family_ops	*ops;
 	const struct builtin_table *tables;
-	struct {
-		struct nftnl_chain_list *chain_cache;
-		bool			initialized;
-	} table[NFT_TABLE_MAX];
+	struct nft_cache	__cache;
+	struct nft_cache	*cache;
 	bool			have_cache;
 	bool			restore;
 	bool			noflush;
-- 
2.11.0

