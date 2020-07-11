Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA385C433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A647B206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGKKTU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C29C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:19 -0700 (PDT)
Received: from localhost ([::1]:59448 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbG-0007G8-7b; Sat, 11 Jul 2020 12:19:18 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/18] nft: Use nft_chain_find() in two more places
Date:   Sat, 11 Jul 2020 12:18:19 +0200
Message-Id: <20200711101831.29506-7-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This doesn't really increase functions' readability but prepares for
later changes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c6cfecda1846a..cc1260dc627d0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1678,20 +1678,13 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_flush;
 
-	if (chain || verbose) {
+	if (chain || verbose)
 		nft_xt_builtin_init(h, table);
-
-		list = nft_chain_list_get(h, table, chain);
-		if (list == NULL) {
-			ret = 1;
-			goto err;
-		}
-	} else if (!nft_table_find(h, table)) {
+	else if (!nft_table_find(h, table))
 		return 1;
-	}
 
 	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
+		c = nft_chain_find(h, table, chain);
 		if (!c) {
 			errno = ENOENT;
 			return 0;
@@ -1705,6 +1698,12 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
+	list = nft_chain_list_get(h, table, chain);
+	if (list == NULL) {
+		ret = 1;
+		goto err;
+	}
+
 	iter = nftnl_chain_list_iter_create(list);
 	if (iter == NULL) {
 		ret = 1;
@@ -2437,12 +2436,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	nft_xt_builtin_init(h, table);
 	nft_assert_table_compatible(h, table, chain);
 
-	list = nft_chain_list_get(h, table, chain);
-	if (!list)
-		return 0;
-
 	if (chain) {
-		c = nftnl_chain_list_lookup_byname(list, chain);
+		c = nft_chain_find(h, table, chain);
 		if (!c)
 			return 0;
 
@@ -2455,6 +2450,10 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 		return 1;
 	}
 
+	list = nft_chain_list_get(h, table, chain);
+	if (!list)
+		return 0;
+
 	iter = nftnl_chain_list_iter_create(list);
 	if (iter == NULL)
 		return 0;
-- 
2.27.0

