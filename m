Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A99C77B62
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjCWQ7M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjCWQ7K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0AF061AE
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 08/12] netlink_delinerize: incorrect byteorder in mark statement listing
Date:   Thu, 23 Mar 2023 17:58:51 +0100
Message-Id: <20230323165855.559837-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323165855.559837-1-pablo@netfilter.org>
References: <20230323165855.559837-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When using ip dscp in combination with bitwise operation:

 # nft --debug=netlink add rule ip x y 'ct mark set ip dscp | 0x4'
 ip x y
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
   [ ct set mark with reg 1 ]

the listing is showing in the incorrect byteorder:

 # nft list ruleset
 table ip x {
        chain y {
		ct mark set ip dscp | 0x4000000
	}
 }

handle and and or operations in host byteorder.

The following command:

 # nft --debug=netlink add rule ip6 x y 'ct mark set ip6 dscp | 0x4'
 ip6 x y
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
   [ ct set mark with reg 1 ]

works fine (without requiring this patch) because there is an explicit
byteorder expression.

However, ip dscp takes only 1-byte, so it does not require the byteorder
expression. Use host byteorder if the rhs of bitwise AND OR is larger
than lhs payload expression and such expression is equal or less than
1-byte.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4dc28ed8e651..7da8e68726cd 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2784,8 +2784,13 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 				      BYTEORDER_HOST_ENDIAN);
 			break;
 		case OP_AND:
-			expr_set_type(expr->right, expr->left->dtype,
-				      expr->left->byteorder);
+			if (expr->right->len > expr->left->len) {
+				expr_set_type(expr->right, expr->left->dtype,
+					      BYTEORDER_HOST_ENDIAN);
+			} else {
+				expr_set_type(expr->right, expr->left->dtype,
+					      expr->left->byteorder);
+			}
 
 			/* Do not process OP_AND in ordinary rule context.
 			 *
@@ -2805,8 +2810,13 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 			}
 			break;
 		default:
-			expr_set_type(expr->right, expr->left->dtype,
-				      expr->left->byteorder);
+			if (expr->right->len > expr->left->len) {
+				expr_set_type(expr->right, expr->left->dtype,
+					      BYTEORDER_HOST_ENDIAN);
+			} else {
+				expr_set_type(expr->right, expr->left->dtype,
+					      expr->left->byteorder);
+			}
 		}
 		expr_postprocess(ctx, &expr->right);
 
-- 
2.30.2

