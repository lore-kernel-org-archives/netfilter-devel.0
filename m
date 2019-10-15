Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44EBECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8277D21848
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 11:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfJOLmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 07:42:39 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36604 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbfJOLmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 07:42:39 -0400
Received: from localhost ([::1]:49694 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKLDp-00010h-UK; Tue, 15 Oct 2019 13:42:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v4 8/8] nft: Optimize flushing all chains of a table
Date:   Tue, 15 Oct 2019 13:41:52 +0200
Message-Id: <20191015114152.25254-9-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015114152.25254-1-phil@nwl.cc>
References: <20191015114152.25254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Leverage nftables' support for flushing all chains of a table by
omitting NFTNL_RULE_CHAIN attribute in NFT_MSG_DELRULE payload.

The only caveat is with verbose output, as that still requires to have a
list of (existing) chains to iterate over. Apart from that, implementing
this shortcut is pretty straightforward: Don't retrieve a chain list and
just call __nft_rule_flush() directly which doesn't set above attribute
if chain name pointer is NULL.

A bigger deal is keeping rule cache consistent: Instead of just clearing
rule list for each flushed chain, flush_rule_cache() is updated to
iterate over all cached chains of the given table, clearing their rule
lists if not called for a specific chain.

While being at it, sort local variable declarations in nft_rule_flush()
from longest to shortest and drop the loop-local 'chain_name' variable
(but instead use 'chain' function parameter which is not used at that
point).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 22 +++++++++++++++++++---
 iptables/nft-cache.h |  3 ++-
 iptables/nft.c       | 32 ++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 64dcda578a163..c55970d074a76 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -384,7 +384,7 @@ static void __nft_flush_cache(struct nft_handle *h)
 	}
 }
 
-static int __flush_rule_cache(struct nftnl_rule *r, void *data)
+static int ____flush_rule_cache(struct nftnl_rule *r, void *data)
 {
 	nftnl_rule_list_del(r);
 	nftnl_rule_free(r);
@@ -392,9 +392,25 @@ static int __flush_rule_cache(struct nftnl_rule *r, void *data)
 	return 0;
 }
 
-void flush_rule_cache(struct nftnl_chain *c)
+static int __flush_rule_cache(struct nftnl_chain *c, void *data)
 {
-	nftnl_rule_foreach(c, __flush_rule_cache, NULL);
+	return nftnl_rule_foreach(c, ____flush_rule_cache, NULL);
+}
+
+int flush_rule_cache(struct nft_handle *h, const char *table,
+		     struct nftnl_chain *c)
+{
+	const struct builtin_table *t;
+
+	if (c)
+		return __flush_rule_cache(c, NULL);
+
+	t = nft_table_builtin_find(h, table);
+	if (!t || !h->cache->table[t->type].chains)
+		return 0;
+
+	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
+					__flush_rule_cache, NULL);
 }
 
 static int __flush_chain_cache(struct nftnl_chain *c, void *data)
diff --git a/iptables/nft-cache.h b/iptables/nft-cache.h
index 793a85f453ffc..cb7a7688be37a 100644
--- a/iptables/nft-cache.h
+++ b/iptables/nft-cache.h
@@ -8,7 +8,8 @@ void nft_build_cache(struct nft_handle *h, struct nftnl_chain *c);
 void nft_rebuild_cache(struct nft_handle *h);
 void nft_release_cache(struct nft_handle *h);
 void flush_chain_cache(struct nft_handle *h, const char *tablename);
-void flush_rule_cache(struct nftnl_chain *c);
+int flush_rule_cache(struct nft_handle *h, const char *table,
+		     struct nftnl_chain *c);
 
 struct nftnl_chain_list *
 nft_chain_list_get(struct nft_handle *h, const char *table, const char *chain);
diff --git a/iptables/nft.c b/iptables/nft.c
index 12cc423c87bbb..89b1c7a808f57 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1437,7 +1437,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 	struct obj_update *obj;
 	struct nftnl_rule *r;
 
-	if (verbose)
+	if (verbose && chain)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
 
 	r = nftnl_rule_alloc();
@@ -1445,7 +1445,8 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 		return;
 
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
+	if (chain)
+		nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
 	obj = batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r);
 	if (!obj) {
@@ -1459,19 +1460,21 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		   bool verbose)
 {
-	int ret = 0;
-	struct nftnl_chain_list *list;
 	struct nftnl_chain_list_iter *iter;
-	struct nftnl_chain *c;
+	struct nftnl_chain_list *list;
+	struct nftnl_chain *c = NULL;
+	int ret = 0;
 
 	nft_xt_builtin_init(h, table);
 
 	nft_fn = nft_rule_flush;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list == NULL) {
-		ret = 1;
-		goto err;
+	if (chain || verbose) {
+		list = nft_chain_list_get(h, table, chain);
+		if (list == NULL) {
+			ret = 1;
+			goto err;
+		}
 	}
 
 	if (chain) {
@@ -1480,9 +1483,11 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 			errno = ENOENT;
 			return 0;
 		}
+	}
 
+	if (chain || !verbose) {
 		__nft_rule_flush(h, table, chain, verbose, false);
-		flush_rule_cache(c);
+		flush_rule_cache(h, table, c);
 		return 1;
 	}
 
@@ -1494,11 +1499,10 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	c = nftnl_chain_list_iter_next(iter);
 	while (c != NULL) {
-		const char *chain_name =
-			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+		chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 
-		__nft_rule_flush(h, table, chain_name, verbose, false);
-		flush_rule_cache(c);
+		__nft_rule_flush(h, table, chain, verbose, false);
+		flush_rule_cache(h, table, c);
 		c = nftnl_chain_list_iter_next(iter);
 	}
 	nftnl_chain_list_iter_destroy(iter);
-- 
2.23.0

