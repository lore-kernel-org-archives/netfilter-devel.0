Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F8AC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 May 2022 16:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378196AbiEMQDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 May 2022 12:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381602AbiEMQDV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 May 2022 12:03:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F67EB87
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2022 09:03:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: release last register on exit
Date:   Fri, 13 May 2022 18:03:16 +0200
Message-Id: <20220513160316.792537-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

netlink_release_registers() does not release the expression in the last
32-bit register.

struct netlink_parse_ctx {
	...
        struct expr             *registers[MAX_REGS + 1];

This array is MAX_REGS + 1 (verdict register + 16 32-bit registers).

Fixes: 371c3a0bc3c2 ("netlink_delinearize: release expressions in context registers")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a1b00dee209a..068c3bba1159 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -100,7 +100,7 @@ static void netlink_release_registers(struct netlink_parse_ctx *ctx)
 {
 	int i;
 
-	for (i = 0; i < MAX_REGS; i++)
+	for (i = 0; i <= MAX_REGS; i++)
 		expr_free(ctx->registers[i]);
 }
 
-- 
2.30.2

