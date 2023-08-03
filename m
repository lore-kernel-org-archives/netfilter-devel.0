Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4DEEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 14:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjHCOsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 10:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbjHCOsG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 10:48:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF9230DA
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Uf7ZI6KLDDb8usp30b2pKmR71sUo1jhX76XZv+0hO0A=; b=kSAbECyY5TG7r3mdFfgW06qNE5
        IXpQuA5LqRSQ5+PuQaRkdghj9z4u60xOrVuL4rYncaF/VwVN4vm8uDQUgNiOHu7JmTK0/M+VVnTw6
        xcw9+vx68gCRJDzk7GJdt8+7gHC4vVvWqjo4p6lxwoOqXVBH5ZN5DHB2i1gwVSV/GybZAg91oUJtQ
        2A2oEU6Fwu0poUTpwUtGq9QIk5nsdtjBqpLWgpcH5JpHS+jaliVLt2yYyhFpxvwtPmJyi63Ik8/AM
        CLXvgeSXyGea+3KIHSy9oPhv8iJvV58J4VJER2Jt77lk1GFOF/KhPMvOPx3XxASl/5EHCyVk9Ynqk
        fsPxAE7w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qRZcQ-0006Cd-19; Thu, 03 Aug 2023 16:48:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Palus <atler@pld-linux.org>
Subject: [iptables PATCH] nft: move processing logic out of asserts
Date:   Thu,  3 Aug 2023 16:47:53 +0200
Message-Id: <20230803144753.27070-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jan Palus <atler@pld-linux.org>

[Phil: Introduce assert_nft_restart() to keep things clean, also add
       fallback returns to nft_action() and nft_prepare(), sanitizing
       things at least a bit.]

Signed-off-by: Jan Palus <atler@pld-linux.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 16 ++++++++++++----
 iptables/nft.c       |  7 +++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index fabb577903f28..91d296709b9de 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -26,6 +26,14 @@
 #include "nft-cache.h"
 #include "nft-chain.h"
 
+/* users may define NDEBUG */
+static void assert_nft_restart(struct nft_handle *h)
+{
+	int rc = nft_restart(h);
+
+	assert(rc >= 0);
+}
+
 static void cache_chain_list_insert(struct list_head *list, const char *name)
 {
 	struct cache_chain *pos = NULL, *new;
@@ -147,7 +155,7 @@ static int fetch_table_cache(struct nft_handle *h)
 
 	ret = mnl_talk(h, nlh, nftnl_table_list_cb, h);
 	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
+		assert_nft_restart(h);
 
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
@@ -472,7 +480,7 @@ static int fetch_set_cache(struct nft_handle *h,
 
 	ret = mnl_talk(h, nlh, nftnl_set_list_cb, &d);
 	if (ret < 0 && errno == EINTR) {
-		assert(nft_restart(h) >= 0);
+		assert_nft_restart(h);
 		return ret;
 	}
 
@@ -512,7 +520,7 @@ static int __fetch_chain_cache(struct nft_handle *h,
 
 	ret = mnl_talk(h, nlh, nftnl_chain_list_cb, &d);
 	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
+		assert_nft_restart(h);
 
 	return ret;
 }
@@ -606,7 +614,7 @@ static int nft_rule_list_update(struct nft_chain *nc, void *data)
 
 	ret = mnl_talk(h, nlh, nftnl_rule_list_cb, &rld);
 	if (ret < 0 && errno == EINTR)
-		assert(nft_restart(h) >= 0);
+		assert_nft_restart(h);
 
 	nftnl_rule_free(rule);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index b702c65ae49aa..326dc20b21d65 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -109,7 +109,9 @@ static struct nftnl_batch *mnl_batch_init(void)
 
 static void mnl_nft_batch_continue(struct nftnl_batch *batch)
 {
-	assert(nftnl_batch_update(batch) >= 0);
+	int ret = nftnl_batch_update(batch);
+
+	assert(ret >= 0);
 }
 
 static uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t genid, uint32_t seqnum)
@@ -3227,6 +3229,7 @@ static int nft_action(struct nft_handle *h, int action)
 		case NFT_COMPAT_RULE_ZERO:
 		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
 			assert(0);
+			return 0;
 		}
 
 		mnl_nft_batch_continue(h->batch);
@@ -3504,7 +3507,7 @@ static int nft_prepare(struct nft_handle *h)
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 			assert(0);
-			break;
+			return 0;
 		}
 
 		nft_cmd_free(cmd);
-- 
2.40.0

