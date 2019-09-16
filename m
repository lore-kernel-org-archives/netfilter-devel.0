Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B5DC4CECD
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E82206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390245AbfIPQvO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:51:14 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51220 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQvO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:51:14 -0400
Received: from localhost ([::1]:36078 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDZ-0003rD-GX; Mon, 16 Sep 2019 18:51:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/14] xtables-restore: Avoid cache population when flushing
Date:   Mon, 16 Sep 2019 18:49:54 +0200
Message-Id: <20190916165000.18217-9-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When called without --noflush, don't fetch full ruleset from kernel but
merely list of tables and the current genid. Locally, initialize chain
lists and set have_cache to simulate an empty ruleset.

Doing so reduces execution time significantly if a large ruleset exists
in kernel space. A simple test case consisting of a dump with 100,000
rules can be restored within 15s on my testing VM. Restoring it a second
time took 21s before this patch and only 17s after it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 27 ++++++++++++++++++++++++++-
 iptables/nft.h             |  1 +
 iptables/xtables-restore.c |  7 +++++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 7f0f9e1234ae4..820f3392dd495 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -882,7 +882,8 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 		nftnl_chain_list_free(c->table[i].chains);
 		c->table[i].chains = NULL;
 	}
-	nftnl_table_list_free(c->tables);
+	if (c->tables)
+		nftnl_table_list_free(c->tables);
 	c->tables = NULL;
 
 	return 1;
@@ -1617,6 +1618,30 @@ void nft_build_cache(struct nft_handle *h)
 		__nft_build_cache(h);
 }
 
+void nft_fake_cache(struct nft_handle *h)
+{
+	int i;
+
+	if (h->have_cache)
+		return;
+
+	/* fetch tables so conditional table delete logic works */
+	if (!h->cache->tables)
+		fetch_table_cache(h);
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name ||
+		    h->cache->table[type].chains)
+			continue;
+
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+	}
+	mnl_genid_get(h, &h->nft_genid);
+	h->have_cache = true;
+}
+
 static void __nft_flush_cache(struct nft_handle *h)
 {
 	if (!h->cache_index) {
diff --git a/iptables/nft.h b/iptables/nft.h
index 43463d7f262e8..d9eb30a2a2413 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -74,6 +74,7 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h);
+void nft_fake_cache(struct nft_handle *h);
 
 /*
  * Operations with tables.
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index f930f5ba2d167..d1486afedc480 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -96,6 +96,11 @@ void xtables_restore_parse(struct nft_handle *h,
 
 	line = 0;
 
+	if (h->noflush)
+		nft_build_cache(h);
+	else
+		nft_fake_cache(h);
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), p->in)) {
 		int ret = 0;
@@ -146,8 +151,6 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (p->tablename && (strcmp(p->tablename, table) != 0))
 				continue;
 
-			nft_build_cache(h);
-
 			if (h->noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-- 
2.23.0

