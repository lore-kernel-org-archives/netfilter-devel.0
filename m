Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4EAC31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 15:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5E2206C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 15:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbfFJPe4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 11:34:56 -0400
Received: from mail.us.es ([193.147.175.20]:36174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390414AbfFJPe4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 11:34:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4442B20A528
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35DBCDA708
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B8F7DA706; Mon, 10 Jun 2019 17:34:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 102E5DA702
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Jun 2019 17:34:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EC74D4265A31
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2019 17:34:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] netlink_delinearize: release expressions in context registers
Date:   Mon, 10 Jun 2019 17:34:48 +0200
Message-Id: <20190610153449.9199-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_release_registers() needs to go a bit further to release the
expressions in the register array. This should be safe since
netlink_get_register() clones expressions in the context registers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h         | 4 +++-
 src/netlink_delinearize.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index a20ebbe4740c..0c08b1abbf6a 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -14,12 +14,14 @@
 
 #include <rule.h>
 
+#define MAX_REGS	(1 + NFT_REG32_15 - NFT_REG32_00)
+
 struct netlink_parse_ctx {
 	struct list_head	*msgs;
 	struct table		*table;
 	struct rule		*rule;
 	struct stmt		*stmt;
-	struct expr		*registers[1 + NFT_REG32_15 - NFT_REG32_00 + 1];
+	struct expr		*registers[MAX_REGS + 1];
 	unsigned int		debug_mask;
 };
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index c018e78b0292..a1c775e679e4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -63,7 +63,7 @@ static void netlink_set_register(struct netlink_parse_ctx *ctx,
 				 enum nft_registers reg,
 				 struct expr *expr)
 {
-	if (reg == NFT_REG_VERDICT || reg > 1 + NFT_REG32_15 - NFT_REG32_00) {
+	if (reg == NFT_REG_VERDICT || reg > MAX_REGS) {
 		netlink_error(ctx, &expr->location,
 			      "Invalid destination register %u", reg);
 		expr_free(expr);
@@ -82,7 +82,7 @@ static struct expr *netlink_get_register(struct netlink_parse_ctx *ctx,
 {
 	struct expr *expr;
 
-	if (reg == NFT_REG_VERDICT || reg > 1 + NFT_REG32_15 - NFT_REG32_00) {
+	if (reg == NFT_REG_VERDICT || reg > MAX_REGS) {
 		netlink_error(ctx, loc, "Invalid source register %u", reg);
 		return NULL;
 	}
@@ -98,7 +98,7 @@ static void netlink_release_registers(struct netlink_parse_ctx *ctx)
 {
 	int i;
 
-	for (i = 0; i <= NFT_REG_MAX; i++)
+	for (i = 0; i < MAX_REGS; i++)
 		expr_free(ctx->registers[i]);
 }
 
-- 
2.11.0

