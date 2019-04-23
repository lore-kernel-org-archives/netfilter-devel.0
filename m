Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAF1C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869AC20645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfDWNWe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:34 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57322 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNY-0000pp-Dn; Tue, 23 Apr 2019 15:22:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 4/6] xtables: add and set "implict" flag on transaction objects
Date:   Tue, 23 Apr 2019 15:16:23 +0200
Message-Id: <20190423131625.23377-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Its used to flag the rule flushes that get added in user-defined-chains
that get redefined with --noflush.

IOW, those objects that are added not by explicit instruction but
to keep semantics.

With --noflush, iptables-legacy-restore will behave as if
-F USERCHAIN was given, in case USERCHAIN exists and USERCHAIN gets
redefined, i.e.:

 iptables-save v1.8.2 on Thu Apr 18 17:11:05 2019
*filter
:USERCHAIN - [0:0]
COMMIT

... will remove all existing rules from USERCHAIN.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4c9ce1a29383..da73e87011db 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -266,6 +266,7 @@ struct obj_update {
 	struct list_head	head;
 	enum obj_update_type	type:8;
 	uint8_t			skip:1;
+	uint8_t			implicit:1;
 	unsigned int		seq;
 	union {
 		struct nftnl_table	*table;
@@ -373,10 +374,11 @@ static int batch_chain_add(struct nft_handle *h, enum obj_update_type type,
 	return batch_add(h, type, c) ? 0 : -1;
 }
 
-static int batch_rule_add(struct nft_handle *h, enum obj_update_type type,
+static struct obj_update *
+batch_rule_add(struct nft_handle *h, enum obj_update_type type,
 			  struct nftnl_rule *r)
 {
-	return batch_add(h, type, r) ? 0 : -1;
+	return batch_add(h, type, r);
 }
 
 const struct builtin_table xtables_ipv4[NFT_TABLE_MAX] = {
@@ -1215,7 +1217,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	} else
 		type = NFT_COMPAT_RULE_APPEND;
 
-	if (batch_rule_add(h, type, r) < 0) {
+	if (batch_rule_add(h, type, r) == NULL) {
 		nftnl_rule_free(r);
 		return 0;
 	}
@@ -1402,7 +1404,7 @@ static void nft_bridge_chain_postprocess(struct nft_handle *h,
 	}
 
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, verdict);
-	if (batch_rule_add(h, NFT_COMPAT_RULE_DELETE, last) < 0)
+	if (batch_rule_add(h, NFT_COMPAT_RULE_DELETE, last) == NULL)
 		fprintf(stderr, "Failed to delete old policy rule\n");
 	nftnl_chain_rule_del(last);
 out_iter:
@@ -1623,8 +1625,9 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 static void
 __nft_rule_flush(struct nft_handle *h, const char *table,
-		 const char *chain, bool verbose)
+		 const char *chain, bool verbose, bool implicit)
 {
+	struct obj_update *obj;
 	struct nftnl_rule *r;
 
 	if (verbose)
@@ -1637,8 +1640,13 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 	nftnl_rule_set(r, NFTNL_RULE_TABLE, (char *)table);
 	nftnl_rule_set(r, NFTNL_RULE_CHAIN, (char *)chain);
 
-	if (batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r) < 0)
+	obj = batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r);
+	if (!obj) {
 		nftnl_rule_free(r);
+		return;
+	}
+
+	obj->implicit = 1;
 }
 
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
@@ -1665,7 +1673,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		if (!c)
 			return 0;
 
-		__nft_rule_flush(h, table, chain, verbose);
+		__nft_rule_flush(h, table, chain, verbose, false);
 		flush_rule_cache(c);
 		return 1;
 	}
@@ -1681,7 +1689,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		const char *chain_name =
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 
-		__nft_rule_flush(h, table, chain_name, verbose);
+		__nft_rule_flush(h, table, chain_name, verbose, false);
 		flush_rule_cache(c);
 		c = nftnl_chain_list_iter_next(iter);
 	}
@@ -1740,7 +1748,7 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		 * chains that are redefined.
 		 */
 		if (h->noflush)
-			__nft_rule_flush(h, table, chain, false);
+			__nft_rule_flush(h, table, chain, false, true);
 	} else {
 		c = nftnl_chain_alloc();
 		if (!c)
@@ -2102,12 +2110,12 @@ void nft_table_new(struct nft_handle *h, const char *table)
 
 static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 {
-	int ret;
+	struct obj_update *obj;
 
 	nftnl_rule_list_del(r);
 
-	ret = batch_rule_add(h, NFT_COMPAT_RULE_DELETE, r);
-	if (ret < 0) {
+	obj = batch_rule_add(h, NFT_COMPAT_RULE_DELETE, r);
+	if (!obj) {
 		nftnl_rule_free(r);
 		return -1;
 	}
@@ -2223,7 +2231,7 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 		}
 	}
 
-	if (batch_rule_add(h, NFT_COMPAT_RULE_INSERT, r) < 0) {
+	if (!batch_rule_add(h, NFT_COMPAT_RULE_INSERT, r)) {
 		nftnl_rule_free(r);
 		return NULL;
 	}
@@ -2848,7 +2856,7 @@ static int ebt_add_policy_rule(struct nftnl_chain *c, void *data)
 			    nftnl_udata_buf_len(udata));
 	nftnl_udata_buf_free(udata);
 
-	if (batch_rule_add(h, NFT_COMPAT_RULE_APPEND, r) < 0) {
+	if (!batch_rule_add(h, NFT_COMPAT_RULE_APPEND, r)) {
 		nftnl_rule_free(r);
 		return -1;
 	}
@@ -3191,7 +3199,6 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 	struct nft_handle *h = d->handle;
 	struct nftnl_rule_iter *iter;
 	struct nftnl_rule *r;
-	int ret = 0;
 
 	if (d->verbose)
 		fprintf(stdout, "Zeroing chain `%s'\n",
@@ -3202,8 +3209,7 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_PACKETS, 0);
 		nftnl_chain_set_u64(c, NFTNL_CHAIN_BYTES, 0);
 		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
-		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c);
-		if (ret)
+		if (batch_chain_add(h, NFT_COMPAT_CHAIN_ZERO, c))
 			return -1;
 	}
 
@@ -3245,8 +3251,7 @@ static int __nft_chain_zero_counters(struct nftnl_chain *c, void *data)
 			 * rule based on its handle only.
 			 */
 			nftnl_rule_unset(r, NFTNL_RULE_POSITION);
-			ret = batch_rule_add(h, NFT_COMPAT_RULE_REPLACE, r);
-			if (ret)
+			if (!batch_rule_add(h, NFT_COMPAT_RULE_REPLACE, r))
 				return -1;
 		}
 		r = nftnl_rule_iter_next(iter);
-- 
2.21.0

