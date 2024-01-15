Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFA171BC
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rPMkZ-0005sN-Cs; Mon, 15 Jan 2024 14:11:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: error out when store needs more than one 128bit register of align fixup
Date: Mon, 15 Jan 2024 14:11:17 +0100
Message-ID: <20240115131120.2007-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Else this gives:
nft: evaluate.c:2983: stmt_evaluate_payload: Assertion `sizeof(data) * BITS_PER_BYTE >= masklen' failed.

For loads, this is already prevented via expr_evaluate_bits() which has:

  if (masklen > NFT_REG_SIZE * BITS_PER_BYTE)
      return expr_error(ctx->msgs, expr, "mask length %u exceeds allowed maximum of %u\n",
                        masklen, NFT_REG_SIZE * BITS_PER_BYTE);

But for the store path this isn't called.
The reproducer asks to store a 128 bit integer at bit offset 1, i.e.
17 bytes would need to be munged, but we can only handle up to 16 bytes
(one pseudo-register).

Fixes: 78936d50f306 ("evaluate: add support to set IPv6 non-byte header fields")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                               | 5 +++++
 .../testcases/bogons/nft-f/payload_expr_unaligned_store      | 1 +
 2 files changed, 6 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/payload_expr_unaligned_store

diff --git a/src/evaluate.c b/src/evaluate.c
index 5576b56ece67..1adec037b04b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3188,6 +3188,11 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	payload_byte_size = div_round_up(payload->len + extra_len,
 					 BITS_PER_BYTE);
 
+	if (payload_byte_size > sizeof(data))
+		return expr_error(ctx->msgs, stmt->payload.expr,
+				  "uneven load cannot span more than %u bytes, got %u",
+				  sizeof(data), payload_byte_size);
+
 	if (need_csum && payload_byte_size & 1) {
 		payload_byte_size++;
 
diff --git a/tests/shell/testcases/bogons/nft-f/payload_expr_unaligned_store b/tests/shell/testcases/bogons/nft-f/payload_expr_unaligned_store
new file mode 100644
index 000000000000..c1358df45e93
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/payload_expr_unaligned_store
@@ -0,0 +1 @@
+add rule f i @th,1,128 set 1
-- 
2.43.0

