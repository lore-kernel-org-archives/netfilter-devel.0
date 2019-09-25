Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6F7C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BDAB2054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfIYV0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:26:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45794 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfIYV0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:26:20 -0400
Received: from localhost ([::1]:58884 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEnj-0005CH-Li; Wed, 25 Sep 2019 23:26:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 15/24] nft: Optimize flushing all chains of a table
Date:   Wed, 25 Sep 2019 23:25:56 +0200
Message-Id: <20190925212605.1005-16-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
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
 iptables/nft.c | 54 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 17 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index b2b15f08c1637..b50ec12ae9d42 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -837,7 +837,7 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 	return 0;
 }
 
-static int __flush_rule_cache(struct nftnl_rule *r, void *data)
+static int ____flush_rule_cache(struct nftnl_rule *r, void *data)
 {
 	nftnl_rule_list_del(r);
 	nftnl_rule_free(r);
@@ -845,9 +845,25 @@ static int __flush_rule_cache(struct nftnl_rule *r, void *data)
 	return 0;
 }
 
-static void flush_rule_cache(struct nftnl_chain *c)
+static int __flush_rule_cache(struct nftnl_chain *c, void *data)
 {
-	nftnl_rule_foreach(c, __flush_rule_cache, NULL);
+	return nftnl_rule_foreach(c, ____flush_rule_cache, NULL);
+}
+
+static int flush_rule_cache(struct nft_handle *h, const char *table,
+			    struct nftnl_chain *c)
+{
+	const struct builtin_table *t;
+
+	if (c)
+		return __flush_rule_cache(c, NULL);
+
+	t = nft_table_builtin_find(h, table);
+	if (!t|| !h->cache->table[t->type].chains)
+		return 0;
+
+	return nftnl_chain_list_foreach(h->cache->table[t->type].chains,
+					__flush_rule_cache, NULL);
 }
 
 static int __flush_chain_cache(struct nftnl_chain *c, void *data)
@@ -1842,7 +1858,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 	struct obj_update *obj;
 	struct nftnl_rule *r;
 
-	if (verbose)
+	if (verbose && chain)
 		fprintf(stdout, "Flushing chain `%s'\n", chain);
 
 	r = nftnl_rule_alloc();
@@ -1850,7 +1866,8 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 		return;
 
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
+	if (chain)
+		nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
 	obj = batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r);
 	if (!obj) {
@@ -1864,19 +1881,21 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
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
@@ -1885,9 +1904,11 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
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
 
@@ -1899,11 +1920,10 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
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

