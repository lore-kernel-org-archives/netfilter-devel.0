Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1772AC49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E900B206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390261AbfIPQvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:51:20 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51226 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQvU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:51:20 -0400
Received: from localhost ([::1]:36084 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDe-0003rY-TP; Mon, 16 Sep 2019 18:51:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 14/14] nft: Reduce impact of nft_chain_builtin_init()
Date:   Mon, 16 Sep 2019 18:50:00 +0200
Message-Id: <20190916165000.18217-15-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When initializing builtin chains, fetch only the chain to add from
kernel to reduce overhead in case kernel ruleset contains many chains.

Given the flexibility of nft_chain_list_get() this is not a problem, but
care has to be taken when updating the table's chain list: Since a
command like 'iptables-nft -F INPUT' causes two invocations of
nft_chain_list_get() with same arguments, the same chain will be fetched
from kernel twice. To handle this, simply clearing chain list from
fetch_chain_cache() is not an option as list elements might be
referenced by pending batch jobs. Instead abort in nftnl_chain_list_cb()
if a chain with same name already exists in the list. Also, the call to
fetch_table_cache() must happen conditionally to avoid leaking existing
table list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 5eb129461dab2..66011a8066ed9 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -750,15 +750,15 @@ nft_chain_builtin_find(const struct builtin_table *t, const char *chain)
 static void nft_chain_builtin_init(struct nft_handle *h,
 				   const struct builtin_table *table)
 {
-	struct nftnl_chain_list *list = nft_chain_list_get(h, table->name, NULL);
+	struct nftnl_chain_list *list;
 	struct nftnl_chain *c;
 	int i;
 
-	if (!list)
-		return;
-
 	/* Initialize built-in chains if they don't exist yet */
 	for (i=0; i < NF_INET_NUMHOOKS && table->chains[i].name != NULL; i++) {
+		list = nft_chain_list_get(h, table->name, table->chains[i].name);
+		if (!list)
+			continue;
 
 		c = nftnl_chain_list_lookup_byname(list, table->chains[i].name);
 		if (c != NULL)
@@ -1374,7 +1374,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nft_handle *h = data;
 	const struct builtin_table *t;
-	struct nftnl_chain *c;
+	struct nftnl_chain *c, *c2;
+	const char *tname, *cname;
 
 	c = nftnl_chain_alloc();
 	if (c == NULL)
@@ -1383,11 +1384,17 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
 		goto out;
 
-	t = nft_table_builtin_find(h,
-			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE));
+	tname = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
+	t = nft_table_builtin_find(h, tname);
 	if (!t)
 		goto out;
 
+	cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+	c2 = nftnl_chain_list_lookup_byname(h->cache->table[t->type].chains,
+					    cname);
+	if (c2)
+		goto out;
+
 	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
 
 	return MNL_CB_OK;
@@ -1447,7 +1454,8 @@ static int fetch_chain_cache(struct nft_handle *h, const char *table, const char
 	struct nlmsghdr *nlh;
 	int i, ret;
 
-	fetch_table_cache(h);
+	if (!h->cache->tables)
+		fetch_table_cache(h);
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
@@ -1462,10 +1470,9 @@ static int fetch_chain_cache(struct nft_handle *h, const char *table, const char
 		if (chain && table && strcmp(table, h->tables[i].name))
 			continue;
 
-		if (h->cache->table[type].chains)
-			nftnl_chain_list_free(h->cache->table[type].chains);
+		if (!h->cache->table[type].chains)
+			h->cache->table[type].chains = nftnl_chain_list_alloc();
 
-		h->cache->table[type].chains = nftnl_chain_list_alloc();
 		if (!h->cache->table[type].chains)
 			return -1;
 	}
-- 
2.23.0

