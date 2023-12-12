Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2949111
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 06:01:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rD3KA-000073-Bq; Tue, 12 Dec 2023 15:01:26 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] expr: fix buffer overflows in data value setters
Date: Tue, 12 Dec 2023 15:01:17 +0100
Message-ID: <20231212140121.10357-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The data value setters memcpy() to a fixed-size buffer, but its very easy
to make nft pass too-larger values.

Example: @th,160,1272 gt 0

==21204==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x60b000000630 at pc 0x7f91dca74b73 bp 0x7ffdf10f4620 sp 0x7ffdf10f3dc8
...


Truncate the copy instead of corrupting the heap.
This needs additional fixes on nft side to reject such
statements with a proper error message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/data_reg.h   |  2 ++
 src/expr/bitwise.c   | 12 +++---------
 src/expr/cmp.c       |  4 +---
 src/expr/data_reg.c  | 14 ++++++++++++++
 src/expr/immediate.c |  4 +---
 src/expr/range.c     |  8 ++------
 6 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 6d2dc66858bf..5ee7080daef0 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -37,4 +37,6 @@ struct nlattr;
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
 void nftnl_free_verdict(const union nftnl_data_reg *data);
 
+int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len);
+
 #endif
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 2d272335e377..e5dba827f3d9 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -51,17 +51,11 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->len, data, sizeof(bitwise->len));
 		break;
 	case NFTNL_EXPR_BITWISE_MASK:
-		memcpy(&bitwise->mask.val, data, data_len);
-		bitwise->mask.len = data_len;
-		break;
+		return nftnl_data_cpy(&bitwise->mask, data, data_len);
 	case NFTNL_EXPR_BITWISE_XOR:
-		memcpy(&bitwise->xor.val, data, data_len);
-		bitwise->xor.len = data_len;
-		break;
+		return nftnl_data_cpy(&bitwise->xor, data, data_len);
 	case NFTNL_EXPR_BITWISE_DATA:
-		memcpy(&bitwise->data.val, data, data_len);
-		bitwise->data.len = data_len;
-		break;
+		return nftnl_data_cpy(&bitwise->data, data, data_len);
 	default:
 		return -1;
 	}
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f9d15bba3b0f..1d396e83411a 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -42,9 +42,7 @@ nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&cmp->op, data, sizeof(cmp->op));
 		break;
 	case NFTNL_EXPR_CMP_DATA:
-		memcpy(&cmp->data.val, data, data_len);
-		cmp->data.len = data_len;
-		break;
+		return nftnl_data_cpy(&cmp->data, data, data_len);
 	default:
 		return -1;
 	}
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 2633a775c90c..690b23dbad6c 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -217,3 +217,17 @@ void nftnl_free_verdict(const union nftnl_data_reg *data)
 		break;
 	}
 }
+
+int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len)
+{
+	int ret = 0;
+
+	if (len > sizeof(dreg->val)) {
+		len = sizeof(dreg->val);
+		ret = -1;
+	}
+
+	memcpy(dreg->val, src, len);
+	dreg->len = len;
+	return ret;
+}
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 5d477a8b4217..f56aa8fd6999 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -36,9 +36,7 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&imm->dreg, data, sizeof(imm->dreg));
 		break;
 	case NFTNL_EXPR_IMM_DATA:
-		memcpy(&imm->data.val, data, data_len);
-		imm->data.len = data_len;
-		break;
+		return nftnl_data_cpy(&imm->data, data, data_len);
 	case NFTNL_EXPR_IMM_VERDICT:
 		memcpy(&imm->data.verdict, data, sizeof(imm->data.verdict));
 		break;
diff --git a/src/expr/range.c b/src/expr/range.c
index 473add86e4b4..5a30e48fde92 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -40,13 +40,9 @@ static int nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&range->op, data, sizeof(range->op));
 		break;
 	case NFTNL_EXPR_RANGE_FROM_DATA:
-		memcpy(&range->data_from.val, data, data_len);
-		range->data_from.len = data_len;
-		break;
+		return nftnl_data_cpy(&range->data_from, data, data_len);
 	case NFTNL_EXPR_RANGE_TO_DATA:
-		memcpy(&range->data_to.val, data, data_len);
-		range->data_to.len = data_len;
-		break;
+		return nftnl_data_cpy(&range->data_to, data, data_len);
 	default:
 		return -1;
 	}
-- 
2.41.0

