Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46830C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 17:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjKERmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 12:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjKERmA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 12:42:00 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C0A1CA
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 09:41:56 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, davidson.brian@gmail.com
Subject: [PATCH nft] evaluate: reset statement length context only for set mappings
Date:   Sun,  5 Nov 2023 18:41:48 +0100
Message-Id: <20231105174148.160390-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

map expression needs to consider the statement length context,
otherwise incorrect bytecode is generated when {ct,meta} statement is
generated.

 # nft -f - <<EOF
 add table ip6 t
 add chain ip6 t c
 add map ip6 t mapv6 { typeof ip6 dscp : meta mark; }
 EOF

 # nft -d netlink add rule ip6 t c meta mark set ip6 dscp map @mapv6
 ip6 t c
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   ... missing byteorder conversion here before shift ...
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set mapv6 dreg 1 ]
   [ meta set mark with reg 1 ]

Reset statement length context only for the mapping side for the
elements in the set.

Fixes: edecd58755a8 ("evaluate: support shifts larger than the width of the left operand")
Reported-by: Brian Davidson <davidson.brian@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Missing tests/py, I will add it in a v2 for this patch.

 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 894987df7895..65e4cef9c147 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1918,13 +1918,13 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	}
 
 	expr_set_context(&ctx->ectx, NULL, 0);
-	ctx->stmt_len = 0;
 	if (expr_evaluate(ctx, &map->map) < 0)
 		return -1;
 	if (expr_is_constant(map->map))
 		return expr_error(ctx->msgs, map->map,
 				  "Map expression can not be constant");
 
+	ctx->stmt_len = 0;
 	mappings = map->mappings;
 	mappings->set_flags |= NFT_SET_MAP;
 
-- 
2.30.2

