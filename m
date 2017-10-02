From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH 2/3] evaluate: Place constant on right side in comparison
Date: Mon,  2 Oct 2017 13:02:49 +0530
Message-ID: <9c9100de4d9803aa0e7112592a1fa5a79bd1fd7b.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
In-Reply-To: <cover.1506928244.git.harshasharmaiitr@gmail.com>
References: <cover.1506928244.git.harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Comparisons should place the constant on the right side of the test
as per linux-kernel coding style

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 5624ca2..b783054 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2174,13 +2174,13 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
-			if (NFPROTO_IPV4 == stmt->reject.family)
+			if (stmt->reject.family == NFPROTO_IPV4)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
 				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				  "conflicting protocols specified: ip vs ip6");
 		case __constant_htons(ETH_P_IPV6):
-			if (NFPROTO_IPV6 == stmt->reject.family)
+			if (stmt->reject.family == NFPROTO_IPV6)
 				break;
 			return stmt_binary_error(ctx, stmt->reject.expr,
 				  &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
-- 
1.9.1
