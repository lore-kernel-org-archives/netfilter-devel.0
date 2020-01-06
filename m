Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF9CC33C9E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5D22072E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAFMUh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:20:37 -0500
Received: from correo.us.es ([193.147.175.20]:43684 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgAFMUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:20:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CFB6F2DF3
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FEFADA710
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 13:20:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EE8C5DA70E; Mon,  6 Jan 2020 13:20:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1CC3DA70E;
        Mon,  6 Jan 2020 13:20:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 13:20:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C1DDA41E4800;
        Mon,  6 Jan 2020 13:20:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 4/7] nft: restore among support
Date:   Mon,  6 Jan 2020 13:20:15 +0100
Message-Id: <20200106122018.14090-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200106122018.14090-1-pablo@netfilter.org>
References: <20200106122018.14090-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update among support to work again with the new parser and cache logic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-bridge.c | 13 +++++++++++--
 iptables/nft.c        | 15 +++++++++++++++
 iptables/nft.h        |  6 ++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index a5aaa3f87187..80d7f91710c1 100644
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
index 1ff2e93c3a3e..a1e38cbafcbe 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1588,6 +1588,20 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
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
@@ -3055,6 +3069,7 @@ static int nft_prepare(struct nft_handle *h)
 			ret = 1;
 			break;
 		case NFT_COMPAT_SET_ADD:
+			nft_xt_builtin_init(h, cmd->table);
 			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
 			ret = 1;
 			break;
diff --git a/iptables/nft.h b/iptables/nft.h
index a9c133934b9e..86f19169e645 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -144,6 +144,12 @@ void nft_bridge_chain_postprocess(struct nft_handle *h,
 
 
 /*
+ * Operations with sets.
+ */
+struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
+					    uint32_t set_id);
+
+/*
  * Operations with rule-set.
  */
 struct nftnl_rule;
-- 
2.11.0

