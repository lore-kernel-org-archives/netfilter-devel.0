From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] expr: imm: Fix immediate verdict comparison
Date: Thu, 25 Aug 2016 16:56:58 +0200
Message-ID: <20160825145658.29391-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:34275 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755971AbcHYO5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 10:57:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
or goto), in this cases we must compare its 'union nftnl_data_reg' using
'DATA_CHAIN' flag instead of 'DATA_VERDICT'

Before this patch compare expressions "jump -> chain_a" and
"jump -> chain_b" returns they are equals.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/immediate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index cb8a81b..b26fc8d 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -329,10 +329,16 @@ static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
 
 	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
 		eq &= (i1->dreg == i2->dreg);
-	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
-		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
-	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
+	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
+		if (e1->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
+			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
+						 DATA_CHAIN);
+		else
+			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
+						 DATA_VERDICT);
+	} else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
 		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VALUE);
+	}
 
 	return eq;
 }
-- 
2.9.3

