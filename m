Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA3C366
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 21:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750798900; cv=none; b=krR4NQzcbmFxfBx/kTQQkf5PifOUXMfI3DVzm8fJTX5ZybeyJtrHsc6Drmej0b53EcdcmtjuwNa6R83HYbSob2vzbg/g85LJ8aV3hiHia9H2FE6u7CXcK9HmQUQavyVqKTYgTNK9UBkwYRllZurU8U8ABl0DMbeEoxus+T67x4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750798900; c=relaxed/simple;
	bh=QcQCaxqEXnuk8e2yMQtybtUduiB6FOtB7ERaXy37Ixo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j3+7DbnwBqYI76bs1mVtVSyPl5i9RYIX9WXG5Ney/OCT8YW4r7jFWTE2X5eoTeTDGbcBXi+fzXKWup1Zg+GiTKmzr5ULQiRhz70MPxzhUpCCerRef3kh+Kxye6hKbPvmkN2zmKlSRBd2NrtPMrDC1KzfCm4CZ4WYjH8DBXZJUPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7945F60A73; Tue, 24 Jun 2025 23:01:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: make sure chain jump name comes with a null byte
Date: Tue, 24 Jun 2025 23:01:13 +0200
Message-ID: <20250624210118.27029-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a stack oob read access in netlink_gen_chain():

	mpz_export_data(chain, expr->chain->value,
			BYTEORDER_HOST_ENDIAN, len);
	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);

There is no guarantee that chain[] is null terminated, so snprintf
can read past chain[] array.  ASAN report is:

AddressSanitizer: stack-buffer-overflow on address 0x7ffff5f00520 at ..
READ of size 257 at 0x7ffff5f00520 thread T0
    #0 0x00000032ffb6 in printf_common(void*, char const*, __va_list_tag*) (src/nft+0x32ffb6)
    #1 0x00000033055d in vsnprintf (src/nft+0x33055d)
    #2 0x000000332071 in snprintf (src/nft+0x332071)
    #3 0x0000004eef03 in netlink_gen_chain src/netlink.c:454:2
    #4 0x0000004eef03 in netlink_gen_verdict src/netlink.c:467:4

Reject chain jumps that exceed 255 characters, which matches the netlink
policy on the kernel side.

The included reproducer fails without asan too because the kernel will
reject the too-long chain name. But that happens after the asan detected
bogus read.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 26 +++++++++++++++----
 .../asan_out_of_bounds_read_with_long_chain   |  3 +++
 2 files changed, 24 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/asan_out_of_bounds_read_with_long_chain

diff --git a/src/evaluate.c b/src/evaluate.c
index 3c091748f786..699891106cb9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3040,16 +3040,32 @@ static int expr_evaluate_xfrm(struct eval_ctx *ctx, struct expr **exprp)
 	return expr_evaluate_primary(ctx, exprp);
 }
 
-static int verdict_validate_chainlen(struct eval_ctx *ctx,
+static int verdict_validate_chain(struct eval_ctx *ctx,
 				     struct expr *chain)
 {
-	if (chain->len > NFT_CHAIN_MAXNAMELEN * BITS_PER_BYTE)
+	char buf[NFT_CHAIN_MAXNAMELEN];
+	unsigned int len;
+
+	len = chain->len / BITS_PER_BYTE;
+	if (len > NFT_CHAIN_MAXNAMELEN)
 		return expr_error(ctx->msgs, chain,
 				  "chain name too long (%u, max %u)",
 				  chain->len / BITS_PER_BYTE,
 				  NFT_CHAIN_MAXNAMELEN);
 
-	return 0;
+	if (!len)
+		return expr_error(ctx->msgs, chain,
+				  "chain name length 0 not allowed");
+
+	memset(buf, 0, sizeof(buf));
+	mpz_export_data(buf, chain->value, BYTEORDER_HOST_ENDIAN, len);
+
+	if (strnlen(buf, sizeof(buf)) < sizeof(buf))
+		return 0;
+
+	return expr_error(ctx->msgs, chain,
+			  "chain name must be smaller than %u",
+			  NFT_CHAIN_MAXNAMELEN);
 }
 
 static int expr_evaluate_verdict(struct eval_ctx *ctx, struct expr **exprp)
@@ -3060,7 +3076,7 @@ static int expr_evaluate_verdict(struct eval_ctx *ctx, struct expr **exprp)
 	case NFT_GOTO:
 	case NFT_JUMP:
 		if (expr->chain->etype == EXPR_VALUE &&
-		    verdict_validate_chainlen(ctx, expr->chain))
+		    verdict_validate_chain(ctx, expr->chain))
 			return -1;
 
 		break;
@@ -3296,7 +3312,7 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 						  "not a value expression");
 			}
 
-			if (verdict_validate_chainlen(ctx, stmt->expr->chain))
+			if (verdict_validate_chain(ctx, stmt->expr->chain))
 				return -1;
 		}
 		break;
diff --git a/tests/shell/testcases/bogons/nft-f/asan_out_of_bounds_read_with_long_chain b/tests/shell/testcases/bogons/nft-f/asan_out_of_bounds_read_with_long_chain
new file mode 100644
index 000000000000..e166a0304f75
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/asan_out_of_bounds_read_with_long_chain
@@ -0,0 +1,3 @@
+add table t
+add chain t eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
+add rule  t eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee jump   eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 
2.49.0

