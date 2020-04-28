Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D43C83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1ABB206D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgD1MKo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MKo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5C6C03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:44 -0700 (PDT)
Received: from localhost ([::1]:38632 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4V-00085c-C7; Tue, 28 Apr 2020 14:10:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 08/18] nft: restore among support
Date:   Tue, 28 Apr 2020 14:10:03 +0200
Message-Id: <20200428121013.24507-9-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Update among support to work again with the new parser and cache logic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 13 +++++++++++--
 iptables/nft.c        | 15 +++++++++++++++
 iptables/nft.h        |  6 ++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index a5aaa3f87187e..80d7f91710c16 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -421,11 +421,20 @@ static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
 					      const struct nftnl_expr *e)
 {
 	const char *set_name = nftnl_expr_get_str(e, NFTNL_EXPR_LOOKUP_SET);
+	uint32_t set_id = nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_SET_ID);
 	struct nftnl_set_list *slist;
+	struct nftnl_set *set;
 
 	slist = nft_set_list_get(ctx->h, ctx->table, set_name);
-	if (slist)
-		return nftnl_set_list_lookup_byname(slist, set_name);
+	if (slist) {
+		set = nftnl_set_list_lookup_byname(slist, set_name);
+		if (set)
+			return set;
+
+		set = nft_set_batch_lookup_byid(ctx->h, set_id);
+		if (set)
+			return set;
+	}
 
 	return NULL;
 }
diff --git a/iptables/nft.c b/iptables/nft.c
index f069396a05190..9771bcc9add02 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1613,6 +1613,20 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 	return ret == 0 ? 1 : 0;
 }
 
+struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
+					    uint32_t set_id)
+{
+	struct obj_update *n;
+
+	list_for_each_entry(n, &h->obj_list, head) {
+		if (n->type == NFT_COMPAT_SET_ADD &&
+		    nftnl_set_get_u32(n->set, NFTNL_SET_ID) == set_id)
+			return n->set;
+	}
+
+	return NULL;
+}
+
 static void
 __nft_rule_flush(struct nft_handle *h, const char *table,
 		 const char *chain, bool verbose, bool implicit)
@@ -3092,6 +3106,7 @@ static int nft_prepare(struct nft_handle *h)
 			ret = 1;
 			break;
 		case NFT_COMPAT_SET_ADD:
+			nft_xt_builtin_init(h, cmd->table);
 			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
 			ret = 1;
 			break;
diff --git a/iptables/nft.h b/iptables/nft.h
index d61a40979d5bc..89c3620e7b7d7 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -144,6 +144,12 @@ void nft_bridge_chain_postprocess(struct nft_handle *h,
 				  struct nftnl_chain *c);
 
 
+/*
+ * Operations with sets.
+ */
+struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
+					    uint32_t set_id);
+
 /*
  * Operations with rule-set.
  */
-- 
2.25.1

