Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD14C19F2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiG2Jid (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiG2Jic (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:38:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0803983F07
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:38:32 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl RFC 3/3] examples: update nft-rule-add to match on string
Date:   Fri, 29 Jul 2022 11:38:23 +0200
Message-Id: <20220729093823.3441-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729093823.3441-1-pablo@netfilter.org>
References: <20220729093823.3441-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An example to match on existing sets from rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Note: Not intended to be merged upstream, I posted as sample.

 examples/nft-rule-add.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 77ee4805f4a4..5dc77354ed0b 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -29,21 +29,22 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 
-static void add_payload(struct nftnl_rule *r, uint32_t base, uint32_t dreg,
-			uint32_t offset, uint32_t len)
+static void add_string(struct nftnl_rule *r)
 {
 	struct nftnl_expr *e;
 
-	e = nftnl_expr_alloc("payload");
+	e = nftnl_expr_alloc("string");
 	if (e == NULL) {
-		perror("expr payload oom");
+		perror("expr string oom");
 		exit(EXIT_FAILURE);
 	}
 
-	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_BASE, base);
-	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, dreg);
-	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
-	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_LEN, len);
+	nftnl_expr_set_str(e, NFTNL_EXPR_STR_NAME, "y");
+	nftnl_expr_set_u32(e, NFTNL_EXPR_STR_BASE, NFT_PAYLOAD_INNER_HEADER);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_STR_FROM, 0);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_STR_TO, ~0U);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_STR_FLAGS, NFT_STR_F_PRESENT);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_STR_DREG, NFT_REG_1);
 
 	nftnl_rule_add_expr(r, e);
 }
@@ -83,9 +84,8 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 				   const char *chain, const char *handle)
 {
 	struct nftnl_rule *r = NULL;
-	uint8_t proto;
-	uint16_t dport;
 	uint64_t handle_num;
+	uint32_t v;
 
 	r = nftnl_rule_alloc();
 	if (r == NULL) {
@@ -102,15 +102,9 @@ static struct nftnl_rule *setup_rule(uint8_t family, const char *table,
 		nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle_num);
 	}
 
-	proto = IPPROTO_TCP;
-	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
-		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
-	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &proto, sizeof(uint8_t));
-
-	dport = htons(22);
-	add_payload(r, NFT_PAYLOAD_TRANSPORT_HEADER, NFT_REG_1,
-		    offsetof(struct tcphdr, dest), sizeof(uint16_t));
-	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &dport, sizeof(uint16_t));
+	v = 1;
+	add_string(r);
+	add_cmp(r, NFT_REG_1, NFT_CMP_EQ, &v, sizeof(uint32_t));
 
 	add_counter(r);
 
-- 
2.30.2

