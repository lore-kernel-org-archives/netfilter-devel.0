Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54C8C433E6
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798AC206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGKKTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7560C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:24 -0700 (PDT)
Received: from localhost ([::1]:59454 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbL-0007GT-GL; Sat, 11 Jul 2020 12:19:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/18] nft: cache: Fetch only interesting tables from kernel
Date:   Sat, 11 Jul 2020 12:18:21 +0200
Message-Id: <20200711101831.29506-9-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the builtin_table array nft_handle->tables points at to gather a
list of table names the calling tool is interested in and fetch only
those instead of requesting a dump of all tables. This increases caching
overhead due to the individual sendmsg() calls but leads to a table list
in defined ordering.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 059f0a7f7891e..f8bb2d09c6434 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -133,7 +133,8 @@ static int fetch_table_cache(struct nft_handle *h)
 	char buf[16536];
 	struct nlmsghdr *nlh;
 	struct nftnl_table_list *list;
-	int i, ret;
+	struct nftnl_table *t;
+	int i, rc, ret = 1;
 
 	if (h->cache->tables)
 		return 0;
@@ -142,14 +143,9 @@ static int fetch_table_cache(struct nft_handle *h)
 	if (list == NULL)
 		return 0;
 
-	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, h->family,
-					NLM_F_DUMP, h->seq);
-
-	ret = mnl_talk(h, nlh, nftnl_table_list_cb, list);
-	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
-
-	h->cache->tables = list;
+	t = nftnl_table_alloc();
+	if (t == NULL)
+		return 0;
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
@@ -157,16 +153,32 @@ static int fetch_table_cache(struct nft_handle *h)
 		if (!h->tables[i].name)
 			continue;
 
+		nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
+						 h->family, NLM_F_ACK, h->seq);
+		nftnl_table_set_str(t, NFTNL_TABLE_NAME, h->tables[i].name);
+		nftnl_table_nlmsg_build_payload(nlh, t);
+
+		rc = mnl_talk(h, nlh, nftnl_table_list_cb, list);
+		if (rc < 0 && errno == EINTR)
+			assert(nft_restart(h) >= 0);
+
 		h->cache->table[type].chains = nftnl_chain_list_alloc();
-		if (!h->cache->table[type].chains)
-			return 0;
+		if (!h->cache->table[type].chains) {
+			ret = 0;
+			break;
+		}
 
 		h->cache->table[type].sets = nftnl_set_list_alloc();
-		if (!h->cache->table[type].sets)
-			return 0;
+		if (!h->cache->table[type].sets) {
+			ret = 0;
+			break;
+		}
 	}
 
-	return 1;
+	if (ret == 1)
+		h->cache->tables = list;
+	nftnl_table_free(t);
+	return ret;
 }
 
 struct nftnl_chain_list_cb_data {
-- 
2.27.0

