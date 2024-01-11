Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D215AC3
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jan 2024 12:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rNtuE-0007f1-K1; Thu, 11 Jan 2024 13:11:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] payload: only assert if l2 header base has no length
Date: Thu, 11 Jan 2024 13:11:22 +0100
Message-ID: <20240111121126.6624-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftables will assert in some cases because the sanity check is done even
for network and transport header bases.

However, stacked headers are only supported for the link layer.
Move the assertion around and add a test case for this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c                                                  | 3 +--
 .../testcases/bogons/nft-f/payload_expr_pctx_update_assert     | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/payload_expr_pctx_update_assert

diff --git a/src/payload.c b/src/payload.c
index 5de3d320758a..44aa834cc07b 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -118,11 +118,10 @@ static void payload_expr_pctx_update(struct proto_ctx *ctx,
 
 	assert(desc->base <= PROTO_BASE_MAX);
 	if (desc->base == base->base) {
-		assert(base->length > 0);
-
 		if (!left->payload.is_raw) {
 			if (desc->base == PROTO_BASE_LL_HDR &&
 			    ctx->stacked_ll_count < PROTO_CTX_NUM_PROTOS) {
+				assert(base->length > 0);
 				ctx->stacked_ll[ctx->stacked_ll_count] = base;
 				ctx->stacked_ll_count++;
 			}
diff --git a/tests/shell/testcases/bogons/nft-f/payload_expr_pctx_update_assert b/tests/shell/testcases/bogons/nft-f/payload_expr_pctx_update_assert
new file mode 100644
index 000000000000..64bd596ad8b4
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/payload_expr_pctx_update_assert
@@ -0,0 +1 @@
+x x comp nexthdr comp
-- 
2.41.0

