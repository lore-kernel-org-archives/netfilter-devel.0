Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF944C433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 939532072D
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 10:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgHSKhc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 06:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgHSKha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 06:37:30 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B6EC061343
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2020 03:37:29 -0700 (PDT)
Received: from localhost ([::1]:38134 helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k8LTE-0000EX-8l; Wed, 19 Aug 2020 12:37:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] nft: Extend use of nftnl_chain_list_foreach()
Date:   Wed, 19 Aug 2020 12:37:10 +0200
Message-Id: <20200819103712.12974-3-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200819103712.12974-1-phil@nwl.cc>
References: <20200819103712.12974-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make use of the callback-based iterator in nft_rule_list(),
nft_rule_list_save(), nft_rule_flush() and nft_rule_save().

Callback code for nft_rule_list() and nft_rule_list_save is pretty
similar, so introduce and use a common callback function.

For nft_rule_save(), turn nft_chain_save_rules() into a callback - it is
not used anywhere else, anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 163 ++++++++++++++++++++++++++-----------------------
 1 file changed, 86 insertions(+), 77 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 78dd17739d8f3..8d53d43770f81 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1566,9 +1566,14 @@ int nft_chain_save(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int nft_chain_save_rules(struct nft_handle *h,
-				struct nftnl_chain *c, unsigned int format)
+struct nft_rule_save_data {
+	struct nft_handle *h;
+	unsigned int format;
+};
+
+static int nft_rule_save_cb(struct nftnl_chain *c, void *data)
 {
+	struct nft_rule_save_data *d = data;
 	struct nftnl_rule_iter *iter;
 	struct nftnl_rule *r;
 
@@ -1578,7 +1583,7 @@ static int nft_chain_save_rules(struct nft_handle *h,
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
+		nft_rule_print_save(d->h, r, NFT_RULE_APPEND, d->format);
 		r = nftnl_rule_iter_next(iter);
 	}
 
@@ -1588,29 +1593,18 @@ static int nft_chain_save_rules(struct nft_handle *h,
 
 int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 {
-	struct nftnl_chain_list_iter *iter;
+	struct nft_rule_save_data d = {
+		.h = h,
+		.format = format,
+	};
 	struct nftnl_chain_list *list;
-	struct nftnl_chain *c;
-	int ret = 0;
+	int ret;
 
 	list = nft_chain_list_get(h, table, NULL);
 	if (!list)
 		return 0;
 
-	iter = nftnl_chain_list_iter_create(list);
-	if (!iter)
-		return 0;
-
-	c = nftnl_chain_list_iter_next(iter);
-	while (c) {
-		ret = nft_chain_save_rules(h, c, format);
-		if (ret != 0)
-			break;
-
-		c = nftnl_chain_list_iter_next(iter);
-	}
-
-	nftnl_chain_list_iter_destroy(iter);
+	ret = nftnl_chain_list_foreach(list, nft_rule_save_cb, &d);
 
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -1657,10 +1651,31 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 	obj->implicit = implicit;
 }
 
+struct nft_rule_flush_data {
+	struct nft_handle *h;
+	const char *table;
+	bool verbose;
+};
+
+static int nft_rule_flush_cb(struct nftnl_chain *c, void *data)
+{
+	const char *chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
+	struct nft_rule_flush_data *d = data;
+
+	batch_chain_flush(d->h, d->table, chain);
+	__nft_rule_flush(d->h, d->table, chain, d->verbose, false);
+	flush_rule_cache(d->h, d->table, c);
+	return 0;
+}
+
 int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		   bool verbose)
 {
-	struct nftnl_chain_list_iter *iter;
+	struct nft_rule_flush_data d = {
+		.h = h,
+		.table = table,
+		.verbose = verbose,
+	};
 	struct nftnl_chain_list *list;
 	struct nftnl_chain *c = NULL;
 	int ret = 0;
@@ -1693,22 +1708,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		goto err;
 	}
 
-	iter = nftnl_chain_list_iter_create(list);
-	if (iter == NULL) {
-		ret = 1;
-		goto err;
-	}
-
-	c = nftnl_chain_list_iter_next(iter);
-	while (c != NULL) {
-		chain = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-
-		batch_chain_flush(h, table, chain);
-		__nft_rule_flush(h, table, chain, verbose, false);
-		flush_rule_cache(h, table, c);
-		c = nftnl_chain_list_iter_next(iter);
-	}
-	nftnl_chain_list_iter_destroy(iter);
+	ret = nftnl_chain_list_foreach(list, nft_rule_flush_cb, &d);
 err:
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
@@ -2350,14 +2350,43 @@ static void __nft_print_header(struct nft_handle *h,
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
@@ -2367,12 +2396,12 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
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
 
@@ -2380,25 +2409,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
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
 
@@ -2453,9 +2467,13 @@ nftnl_rule_list_chain_save(struct nft_handle *h, const char *chain,
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
 
@@ -2471,30 +2489,21 @@ int nft_rule_list_save(struct nft_handle *h, const char *chain,
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

