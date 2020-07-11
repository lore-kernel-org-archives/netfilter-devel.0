Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02C3C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70C7206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGKKTO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F76AC08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:14 -0700 (PDT)
Received: from localhost ([::1]:59442 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbA-0007Fp-Un; Sat, 11 Jul 2020 12:19:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/18] nft: Use nftnl_chain_list_foreach in nft_rule_list{,_save}
Date:   Sat, 11 Jul 2020 12:18:22 +0200
Message-Id: <20200711101831.29506-10-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a common callback function and data structure to pass via
opaque pointer since chain printing in both functions is pretty similar.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 89 +++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index cc1260dc627d0..66746818f5e0c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2424,14 +2424,43 @@ static void __nft_print_header(struct nft_handle *h,
 			&ctrs, basechain, refs - entries, entries);
 }
 
+struct nft_rule_list_cb_data {
+	struct nft_handle *h;
+	unsigned int format;
+	int rulenum;
+	bool found;
+	bool save_fmt;
+	void (*cb)(struct nft_handle *h, struct nftnl_rule *r,
+		   unsigned int num, unsigned int format);
+};
+
+static int nft_rule_list_cb(struct nftnl_chain *c, void *data)
+{
+	struct nft_rule_list_cb_data *d = data;
+
+	if (!d->save_fmt) {
+		if (d->found)
+			printf("\n");
+		d->found = true;
+
+		__nft_print_header(d->h, c, d->format);
+	}
+
+	return __nft_rule_list(d->h, c, d->rulenum, d->format, d->cb);
+}
+
 int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		  int rulenum, unsigned int format)
 {
 	const struct nft_family_ops *ops = h->ops;
+	struct nft_rule_list_cb_data d = {
+		.h = h,
+		.format = format,
+		.rulenum = rulenum,
+		.cb = ops->print_rule,
+	};
 	struct nftnl_chain_list *list;
-	struct nftnl_chain_list_iter *iter;
 	struct nftnl_chain *c;
-	bool found = false;
 
 	nft_xt_builtin_init(h, table);
 	nft_assert_table_compatible(h, table, chain);
@@ -2441,12 +2470,12 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		if (!c)
 			return 0;
 
-		if (!rulenum) {
-			if (ops->print_table_header)
-				ops->print_table_header(table);
-			__nft_print_header(h, c, format);
-		}
-		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
+		if (rulenum)
+			d.save_fmt = true;	/* skip header printing */
+		else if (ops->print_table_header)
+			ops->print_table_header(table);
+
+		nft_rule_list_cb(c, &d);
 		return 1;
 	}
 
@@ -2454,25 +2483,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	if (!list)
 		return 0;
 
-	iter = nftnl_chain_list_iter_create(list);
-	if (iter == NULL)
-		return 0;
-
 	if (ops->print_table_header)
 		ops->print_table_header(table);
 
-	c = nftnl_chain_list_iter_next(iter);
-	while (c != NULL) {
-		if (found)
-			printf("\n");
-
-		__nft_print_header(h, c, format);
-		__nft_rule_list(h, c, rulenum, format, ops->print_rule);
-
-		found = true;
-		c = nftnl_chain_list_iter_next(iter);
-	}
-	nftnl_chain_list_iter_destroy(iter);
+	nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
 	return 1;
 }
 
@@ -2527,9 +2541,13 @@ nftnl_rule_list_chain_save(struct nft_handle *h, const char *chain,
 int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		       const char *table, int rulenum, int counters)
 {
+	struct nft_rule_list_cb_data d = {
+		.h = h,
+		.rulenum = rulenum,
+		.save_fmt = true,
+		.cb = list_save,
+	};
 	struct nftnl_chain_list *list;
-	struct nftnl_chain_list_iter *iter;
-	unsigned int format = 0;
 	struct nftnl_chain *c;
 	int ret = 0;
 
@@ -2545,30 +2563,21 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
 		nftnl_rule_list_chain_save(h, chain, list, counters);
 
 	if (counters < 0)
-		format = FMT_C_COUNTS;
+		d.format = FMT_C_COUNTS;
 	else if (counters == 0)
-		format = FMT_NOCOUNTS;
+		d.format = FMT_NOCOUNTS;
 
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
 		if (!c)
 			return 0;
 
-		return __nft_rule_list(h, c, rulenum, format, list_save);
+		return nft_rule_list_cb(c, &d);
 	}
 
 	/* Now dump out rules in this table */
-	iter = nftnl_chain_list_iter_create(list);
-	if (iter == NULL)
-		return 0;
-
-	c = nftnl_chain_list_iter_next(iter);
-	while (c != NULL) {
-		ret = __nft_rule_list(h, c, rulenum, format, list_save);
-		c = nftnl_chain_list_iter_next(iter);
-	}
-	nftnl_chain_list_iter_destroy(iter);
-	return ret;
+	ret = nftnl_chain_list_foreach(list, nft_rule_list_cb, &d);
+	return ret == 0 ? 1 : 0;
 }
 
 int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
-- 
2.27.0

