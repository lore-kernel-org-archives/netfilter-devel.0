Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACFC1E503D
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2025 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259429; cv=none; b=YpGNADWg9b2jm0fp9ZJ//uN7GxxdLzoZOYdzoV6Aj3MYikkxtrsb+vHfM82Fm4CII3NZyjFTb7Mcp/hZYWupYh0m4oxxS2qE2uw5v/KwdL5hLAi0FeJp65YbvvBF0Rf0q7dK9RuVa7E6LmGVlfxR7hjcQwvDVBU33ktPRf+Ty7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259429; c=relaxed/simple;
	bh=+yILWXFRMXf2uJpa9nAhny1Lr5Zrdxl8t7bPATK9Oro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j9ONyZdybYl226hwRN4iNSQTTfJgLaoQ4kQhcZX0M/VPFzQrIXa5OKrEXUQUN+vm4ULzd41pFeC8+ahhRZNVoIXnyLpW5wOHY0ZxwCP/TOoEC+YK7z9by+cwU3bEKcWaOx+/yeWY/m/nDioqO/e6fUEVrCr/bg4XNpugEfbp8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tdYgE-00018y-PC; Thu, 30 Jan 2025 18:50:18 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Sunny73Cr <Sunny73Cr@protonmail.com>
Subject: [PATCH nft 1/3] netlink_delinarize: fix bogus munging of mask value
Date: Thu, 30 Jan 2025 18:47:12 +0100
Message-ID: <20250130174718.6644-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given following input:
table ip t {
 chain c {
  @ih,58,6 set 0 @ih,86,6 set 0 @ih,170,22 set 0
 }
}

nft will produce following output:
chain c {
 @ih,48,16 set @ih,48,16 & 0x3f @ih,80,16 set @ih,80,16 & 0x3f0 @ih,160,32 set @ih,160,32 & 0x3fffff
}

The input side is correct, the generated expressions sent to kernel are:

1  [ payload load 2b @ inner header + 6 => reg 1 ]
2  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
3  [ payload write reg 1 => 2b @ inner header + 6 .. ]
4  [ payload load 2b @ inner header + 10 => reg 1 ]
5  [ bitwise reg 1 = ( reg 1 & 0x00000ffc ) ^ 0x00000000 ]
6  [ payload write reg 1 => 2b @ inner header + 10 .. ]
7  [ payload load 4b @ inner header + 20 => reg 1 ]
8  [ bitwise reg 1 = ( reg 1 & 0x0000c0ff ) ^ 0x00000000 ]
9  [ payload write reg 1 => 4b @ inner header + 20 .. ]

@ih,58,6 set 0 <- Zero 6 bits, starting with bit 58

Changes to inner header mandate a checksum update, which only works for
even byte counts (except for last byte in the payload).

Thus, we load 2b at offet 6. (16bits, offset 48).

Because we want to zero 6 bits, we need a mask that retains 10 bits and
clears 6: b1111111111000000 (first 8 bit retains 48-57, last 6 bit clear
58-63).  The '0xc0ff' is not correct, but thats because debug output comes
from libnftnl which prints values in host byte order, the value will be
interpreted as big endian on kernel side, so this will do the right thing.

Next, same problem:

@ih,86,6 set 0 <- Zero 6 bits, starting with bit 86.

nft needs to round down to even-sized byte offset, 10, then retain first
6 bits (80 + 6 == 86), then clear 6 bits (86-91), then keep 4 more as-is
(92-95).

So mask is 0xfc0f (in big endian) would be correct (b1111110000001111).

Last expression, @ih,170,22 set 0, asks to clear 22 bits starting with bit
170, nft correctly rounds this down to a 32 bit read at offset 160.

Required mask keeps first 10 bits, then clears 22
(b11111111110000000000000000000000).  Required mask would be 0xffc00000,
which corresponds to the wrong-endian-printed value in line 8 above.

Now that we convinced ourselves that the input side is correct, fix up
netlink delinearize to undo the mask alterations if we can't find a
template to print a human-readable payload expression.

With this patch, we get this output:

  @ih,48,16 set @ih,48,16 & 0xffc0 @ih,80,16 set @ih,80,16 & 0xfc0f @ih,160,32 set @ih,160,32 & 0xffc00000

... which isn't ideal.  We should fixup the payload expression to display
the same output as the input, i.e. adjust payload->len and offset as per
mask and discard the mask instead.

This will be done in a followup patch.

Fixes: 50ca788ca4d0 ("netlink: decode payload statment")
Reported-by: Sunny73Cr <Sunny73Cr@protonmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c | 57 ++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 22 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index db8b6bbe13e8..046e7a472b8d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3226,41 +3226,54 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 		break;
 	}
 	case EXPR_PAYLOAD: /* II? */
-		value = expr->right;
-		if (value->etype != EXPR_VALUE)
+		payload = expr->left;
+		mask = expr->right;
+
+		if (mask->etype != EXPR_VALUE)
+			return;
+
+		if (!payload_expr_cmp(stmt->payload.expr, payload))
 			return;
 
 		switch (expr->op) {
-		case OP_AND: /* IIa */
-			payload = expr->left;
+		case OP_AND: { /* IIa */
+			mpz_t tmp;
+
+			mpz_init(tmp);
+			mpz_set(tmp, mask->value);
+
 			mpz_init_bitmask(bitmask, payload->len);
-			mpz_xor(bitmask, bitmask, value->value);
-			mpz_set(value->value, bitmask);
+			mpz_xor(bitmask, bitmask, mask->value);
+			mpz_set(mask->value, bitmask);
 			mpz_clear(bitmask);
-			break;
-		case OP_OR: /* IIb */
-			break;
-		default: /* No idea */
-			return;
-		}
 
-		stmt_payload_binop_pp(ctx, expr);
-		if (!payload_is_known(expr->left))
-			return;
+			stmt_payload_binop_pp(ctx, expr);
+			if (!payload_is_known(expr->left)) {
+				mpz_set(mask->value, tmp);
+				mpz_clear(tmp);
+				return;
+			}
 
-		expr_free(stmt->payload.expr);
+			mpz_clear(tmp);
 
-		switch (expr->op) {
-		case OP_AND:
-			/* Mask was used to match payload, i.e.
-			 * user asked to set zero value.
+			/* Mask was used to match payload, i.e. user asked to
+			 * clear the payload expression.
+			 * The "mask" value becomes new stmt->payload.value
+			 * so set this to 0.
 			 */
-			mpz_set_ui(value->value, 0);
+			mpz_set_ui(mask->value, 0);
 			break;
-		default:
+		}
+		case OP_OR:  /* IIb */
+			stmt_payload_binop_pp(ctx, expr);
+			if (!payload_is_known(expr->left))
+				return;
 			break;
+		default: /* No idea what to do */
+			return;
 		}
 
+		expr_free(stmt->payload.expr);
 		stmt->payload.expr = expr_get(expr->left);
 		stmt->payload.val = expr_get(expr->right);
 		expr_free(expr);
-- 
2.45.3

