From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] expr: imm: Fix immediate verdict comparison
Date: Fri, 26 Aug 2016 15:49:22 +0200
Message-ID: <20160826134922.15496-1-carlosfg@riseup.net>
References: <20160825151930.GA3482@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:60090 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751168AbcHZN5W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2016 09:57:22 -0400
In-Reply-To: <20160825151930.GA3482@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
or goto), in this cases we must compare its 'union nftnl_data_reg' using
'DATA_CHAIN' flag instead of 'DATA_VERDICT'

Before this patch compare expressions "jump -> chain_a" and
"jump -> chain_b" returns they are equals.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
V2: Chosen a clearest code structure
 src/expr/immediate.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index cb8a81b..41fd9c4 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -326,13 +326,19 @@ static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
 	struct nftnl_expr_immediate *i1 = nftnl_expr_data(e1);
 	struct nftnl_expr_immediate *i2 = nftnl_expr_data(e2);
 	bool eq = true;
+	int type = DATA_NONE;
 
 	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
 		eq &= (i1->dreg == i2->dreg);
 	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
-		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
+		if (e1->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
+			type = DATA_CHAIN;
+		else
+			type = DATA_VERDICT;
 	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
-		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VALUE);
+			type = DATA_VALUE;
+	if (type != DATA_NONE)
+		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, type);
 
 	return eq;
 }
-- 
2.9.3

