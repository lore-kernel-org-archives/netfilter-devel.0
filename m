Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D0BC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F3D20673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfIYV1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45860 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV1V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:21 -0400
Received: from localhost ([::1]:58950 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEoh-0005G5-Tm; Wed, 25 Sep 2019 23:27:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 09/24] nft: Support fetch_chain_cache() per table
Date:   Wed, 25 Sep 2019 23:25:50 +0200
Message-Id: <20190925212605.1005-10-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to pass a builtin_table for which to fetch chains. If given,
initialize only that table's chain list in cache and pass the table
along to nftnl_chain_list_cb() which will filter received chains by
table name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 55 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 16 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 729b88d990f9f..6ed05e77008c4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1352,11 +1352,18 @@ nft_rule_print_save(const struct nftnl_rule *r, enum nft_rule_print type,
 		ops->clear_cs(&cs);
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
+	struct nft_handle *h = d->h;
 	struct nftnl_chain *c;
+	const char *tname;
 
 	c = nftnl_chain_alloc();
 	if (c == NULL)
@@ -1365,8 +1372,13 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
 		goto out;
 
-	t = nft_table_builtin_find(h,
-			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+	tname = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
+
+	if (!t)
+		t = nft_table_builtin_find(h, tname);
+	else if (strcmp(t->name, tname))
+		goto out;
+
 	if (!t)
 		goto out;
 
@@ -1423,29 +1435,40 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
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
 
-	fetch_table_cache(h);
+	if (!t) {
+		fetch_table_cache(h);
 
-	for (i = 0; i < NFT_TABLE_MAX; i++) {
-		enum nft_table_type type = h->tables[i].type;
+		for (i = 0; i < NFT_TABLE_MAX; i++) {
+			enum nft_table_type type = h->tables[i].type;
 
-		if (!h->tables[i].name)
-			continue;
+			if (!h->tables[i].name)
+				continue;
 
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[type].chains)
-			return -1;
+			h->cache->table[type].chains = nftnl_chain_list_alloc();
+			if (!h->cache->table[type].chains)
+				return -1;
+		}
+	} else if (!h->cache->table[t->type].chains) {
+		h->cache->table[t->type].chains = nftnl_chain_list_alloc();
+	} else {
+		return 0;
 	}
 
 	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, h->family,
 					NLM_F_DUMP, h->seq);
 
-	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, h);
+	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
 		assert(nft_restart(h) >= 0);
 
@@ -1616,7 +1639,7 @@ static void __nft_build_cache(struct nft_handle *h)
 
 retry:
 	mnl_genid_get(h, &genid_start);
-	fetch_chain_cache(h);
+	fetch_chain_cache(h, NULL);
 	fetch_rule_cache(h, NULL);
 	h->have_cache = true;
 	mnl_genid_get(h, &genid_stop);
@@ -1686,7 +1709,7 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 		return NULL;
 
 	if (!h->have_cache && !h->cache->table[t->type].chains)
-		fetch_chain_cache(h);
+		fetch_chain_cache(h, t);
 
 	return h->cache->table[t->type].chains;
 }
-- 
2.23.0

