Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ED3C76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 09:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCQJ6n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCQJ6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 05:58:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB86F19C
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 02:58:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/9] netlink_delinearize: correct type and byte-order of shifts
Date:   Fri, 17 Mar 2023 10:58:26 +0100
Message-Id: <20230317095833.1225401-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317095833.1225401-1-pablo@netfilter.org>
References: <20230317095833.1225401-1-pablo@netfilter.org>
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

