Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D63C433E1
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169C9206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgGKKTr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB480C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:46 -0700 (PDT)
Received: from localhost ([::1]:59478 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbh-0007Hg-Du; Sat, 11 Jul 2020 12:19:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/18] nft: Use nftnl_chain_foreach in nft_rule_save
Date:   Sat, 11 Jul 2020 12:18:24 +0200
Message-Id: <20200711101831.29506-12-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To do so, turn nft_chain_save_rules() into a suitable callback. It is
not used outside of nft_rule_save anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 809957c6daeb0..51716ff70108d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1577,9 +1577,14 @@ int nft_chain_save(struct nftnl_chain *c, void *data)
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
 
@@ -1589,7 +1594,7 @@ static int nft_chain_save_rules(struct nft_handle *h,
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		nft_rule_print_save(h, r, NFT_RULE_APPEND, format);
+		nft_rule_print_save(d->h, r, NFT_RULE_APPEND, d->format);
 		r = nftnl_rule_iter_next(iter);
 	}
 
@@ -1599,29 +1604,18 @@ static int nft_chain_save_rules(struct nft_handle *h,
 
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
-- 
2.27.0

