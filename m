Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1388C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E616214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390260AbfIPQuh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51178 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:37 -0400
Received: from localhost ([::1]:36036 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uCx-0003oP-KW; Mon, 16 Sep 2019 18:50:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/14] nft: Use nftnl_*_set_str() functions
Date:   Mon, 16 Sep 2019 18:49:50 +0200
Message-Id: <20190916165000.18217-5-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Although it doesn't make a difference in practice, they are the correct
API functions to use when assigning string attributes.

While doing so, also drop the needless casts to non-const.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ae3740be6bed5..81d01310c7f8c 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -662,7 +662,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
 	if (t == NULL)
 		return -1;
 
-	nftnl_table_set(t, NFTNL_TABLE_NAME, (char *)_t->name);
+	nftnl_table_set_str(t, NFTNL_TABLE_NAME, _t->name);
 
 	ret = batch_table_add(h, NFT_COMPAT_TABLE_ADD, t) ? 0 : - 1;
 
@@ -679,12 +679,12 @@ nft_chain_builtin_alloc(const struct builtin_table *table,
 	if (c == NULL)
 		return NULL;
 
-	nftnl_chain_set(c, NFTNL_CHAIN_TABLE, (char *)table->name);
-	nftnl_chain_set(c, NFTNL_CHAIN_NAME, (char *)chain->name);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table->name);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain->name);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_HOOKNUM, chain->hook);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_PRIO, chain->prio);
 	nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, policy);
-	nftnl_chain_set(c, NFTNL_CHAIN_TYPE, (char *)chain->type);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TYPE, chain->type);
 
 	return c;
 }
@@ -1250,8 +1250,8 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 		return NULL;
 
 	nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, h->family);
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, (char *)table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, (char *)chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
 	if (h->ops->add(r, data) < 0)
 		goto err;
@@ -1768,8 +1768,8 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 	if (r == NULL)
 		return;
 
-	nftnl_rule_set(r, NFTNL_RULE_TABLE, (char *)table);
-	nftnl_rule_set(r, NFTNL_RULE_CHAIN, (char *)chain);
+	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
+	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
 	obj = batch_rule_add(h, NFT_COMPAT_RULE_FLUSH, r);
 	if (!obj) {
@@ -1850,8 +1850,8 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	if (c == NULL)
 		return 0;
 
-	nftnl_chain_set(c, NFTNL_CHAIN_TABLE, (char *)table);
-	nftnl_chain_set(c, NFTNL_CHAIN_NAME, (char *)chain);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 	if (h->family == NFPROTO_BRIDGE)
 		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
 
@@ -1884,8 +1884,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		if (!c)
 			return -1;
 
-		nftnl_chain_set(c, NFTNL_CHAIN_TABLE, (char *)table);
-		nftnl_chain_set(c, NFTNL_CHAIN_NAME, (char *)chain);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
+		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
 	}
 
@@ -2034,8 +2034,8 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	if (c == NULL)
 		return 0;
 
-	nftnl_chain_set(c, NFTNL_CHAIN_TABLE, (char *)table);
-	nftnl_chain_set(c, NFTNL_CHAIN_NAME, (char *)newname);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
+	nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, newname);
 	nftnl_chain_set_u64(c, NFTNL_CHAIN_HANDLE, handle);
 
 	ret = batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c);
-- 
2.23.0

