Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223A8C7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCVVxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVVxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0196C33CFD
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:09 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/8] netlink_delinearize: correct type and byte-order of shifts
Date:   Wed, 22 Mar 2023 22:52:56 +0100
Message-Id: <20230322215303.239763-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Downgrade to base type integer instead of the specific type from the
expression that is used in the shift operation.

Without this, listing a rule like:

  ct mark set ip dscp lshift 2 or 0x10

will return:

  ct mark set ip dscp << 2 | cs2

because the type of the OR's right operand will be transitively derived
from `ip dscp`.  However, this is not valid syntax:

  # nft add rule t c ct mark set ip dscp '<<' 2 '|' cs2
  Error: Could not parse integer
  add rule t c ct mark set ip dscp << 2 | cs2
                                          ^^^

Use xinteger_type to print the output in hexadecimal.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 60350cd6cd96..c1b4c1148d33 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2810,8 +2810,17 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		}
 		expr_postprocess(ctx, &expr->right);
 
-		expr_set_type(expr, expr->left->dtype,
-			      expr->left->byteorder);
+		switch (expr->op) {
+		case OP_LSHIFT:
+		case OP_RSHIFT:
+			expr_set_type(expr, &xinteger_type,
+				      BYTEORDER_HOST_ENDIAN);
+			break;
+		default:
+			expr_set_type(expr, expr->left->dtype,
+				      expr->left->byteorder);
+		}
+
 		break;
 	case EXPR_RELATIONAL:
 		switch (expr->left->etype) {
-- 
2.30.2

