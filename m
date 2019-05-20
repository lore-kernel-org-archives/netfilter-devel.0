Return-Path: <SRS0=v9tr=TU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D42C04AAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F50214AE
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 May 2019 12:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389389AbfETM1A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 May 2019 08:27:00 -0400
Received: from mail.us.es ([193.147.175.20]:34234 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbfETM07 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 May 2019 08:26:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FAF61D94A3
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3B55DA708
        for <netfilter-devel@vger.kernel.org>; Mon, 20 May 2019 14:26:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E9287DA703; Mon, 20 May 2019 14:26:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6949DA70A;
        Mon, 20 May 2019 14:26:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 20 May 2019 14:26:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ABB744265A5B;
        Mon, 20 May 2019 14:26:54 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 5/6] nft: cache table list
Date:   Mon, 20 May 2019 14:26:45 +0200
Message-Id: <20190520122646.17788-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190520122646.17788-1-pablo@netfilter.org>
References: <20190520122646.17788-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_table_find() uses the table list cache to look up for existing
tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft.c | 102 ++++++++++++++++++++++++++++++++-------------------------
 iptables/nft.h |   1 +
 2 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 8f6f7a41ff33..063637e22fb8 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -865,12 +865,17 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 		nftnl_chain_list_free(c->table[i].chains);
 		c->table[i].chains = NULL;
 	}
+	nftnl_table_list_free(c->tables);
+	c->tables = NULL;
 
 	return 1;
 }
 
 static void flush_chain_cache(struct nft_handle *h, const char *tablename)
 {
+	if (!h->have_cache)
+		return;
+
 	if (flush_cache(h->cache, h->tables, tablename))
 		h->have_cache = false;
 }
@@ -1350,6 +1355,53 @@ err:
 	return MNL_CB_OK;
 }
 
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
+retry:
+	list = nftnl_table_list_alloc();
+	if (list == NULL)
+		return 0;
+
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
+					NLM_F_DUMP, h->seq);
+
+	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
+	if (ret < 0 && errno == EINTR) {
+		assert(nft_restart(h) >= 0);
+		nftnl_table_list_free(list);
+		goto retry;
+	}
+	h->cache->tables = list;
+
+	return 1;
+}
+
 static int fetch_chain_cache(struct nft_handle *h)
 {
 	char buf[16536];
@@ -1357,6 +1409,8 @@ static int fetch_chain_cache(struct nft_handle *h)
 	int i, ret;
 
 retry:
+	fetch_table_cache(h);
+
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -1968,56 +2022,17 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	return ret == 0 ? 1 : 0;
 }
 
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
 static struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
-	char buf[16536];
-	struct nlmsghdr *nlh;
-	struct nftnl_table_list *list;
-	int ret;
-
-retry:
-	list = nftnl_table_list_alloc();
-	if (list == NULL)
-		return 0;
-
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
-					NLM_F_DUMP, h->seq);
-
-	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
-	if (ret < 0 && errno == EINTR) {
-		assert(nft_restart(h) >= 0);
-		nftnl_table_list_free(list);
-		goto retry;
-	}
+	nft_build_cache(h);
 
-	return list;
+	return h->cache->tables;
 }
 
 bool nft_table_find(struct nft_handle *h, const char *tablename)
 {
-	struct nftnl_table_list *list;
 	struct nftnl_table_list_iter *iter;
+	struct nftnl_table_list *list;
 	struct nftnl_table *t;
 	bool ret = false;
 
@@ -2043,7 +2058,6 @@ bool nft_table_find(struct nft_handle *h, const char *tablename)
 	}
 
 	nftnl_table_list_iter_destroy(iter);
-	nftnl_table_list_free(list);
 
 err:
 	return ret;
@@ -2076,7 +2090,6 @@ int nft_for_each_table(struct nft_handle *h,
 	}
 
 	nftnl_table_list_iter_destroy(iter);
-	nftnl_table_list_free(list);
 	return 0;
 }
 
@@ -2148,7 +2161,6 @@ int nft_table_flush(struct nft_handle *h, const char *table)
 	ret = __nft_table_flush(h, table, exists);
 	nftnl_table_list_iter_destroy(iter);
 err_table_list:
-	nftnl_table_list_free(list);
 err_out:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
diff --git a/iptables/nft.h b/iptables/nft.h
index c137c5c6708d..dc0797d302b8 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -28,6 +28,7 @@ struct builtin_table {
 };
 
 struct nft_cache {
+	struct nftnl_table_list		*tables;
 	struct {
 		struct nftnl_chain_list *chains;
 		bool			initialized;
-- 
2.11.0

