Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C6DC433EA
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D938206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgGKKTm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECDDC08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:41 -0700 (PDT)
Received: from localhost ([::1]:59472 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbc-0007HO-55; Sat, 11 Jul 2020 12:19:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/18] nft: Use nftnl_chain_list_foreach in nft_rule_flush
Date:   Sat, 11 Jul 2020 12:18:23 +0200
Message-Id: <20200711101831.29506-11-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 66746818f5e0c..809957c6daeb0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1668,10 +1668,31 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
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
@@ -1704,22 +1725,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
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
-- 
2.27.0

