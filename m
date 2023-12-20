Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B33B1B0
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFxks-0000fF-3U; Wed, 20 Dec 2023 15:41:02 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: fix stack overflow due to erroneous rounding
Date: Wed, 20 Dec 2023 15:40:54 +0100
Message-ID: <20231220144057.10616-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Byteorder switch in this function may undersize the conversion
buffer by one byte, this needs to use div_round_up().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c                                         | 11 ++++++++---
 .../bogons/nft-f/byteorder_switch_stack_overflow      |  6 ++++++
 2 files changed, 14 insertions(+), 3 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/byteorder_switch_stack_overflow

diff --git a/src/netlink.c b/src/netlink.c
index 32b189952aa3..3d685b575e64 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -254,6 +254,11 @@ static int netlink_export_pad(unsigned char *data, const mpz_t v,
 	return netlink_padded_len(i->len) / BITS_PER_BYTE;
 }
 
+static void byteorder_switch_expr_value(mpz_t v, const struct expr *e)
+{
+	mpz_switch_byteorder(v, div_round_up(e->len, BITS_PER_BYTE));
+}
+
 static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 				    unsigned char *data)
 {
@@ -268,7 +273,7 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 
 		if (expr_basetype(expr)->type == TYPE_INTEGER &&
 		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+			byteorder_switch_expr_value(expr->value, expr);
 
 		i = expr;
 		break;
@@ -280,7 +285,7 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			mpz_init_bitmask(v, i->len - i->prefix_len);
 
 			if (i->byteorder == BYTEORDER_HOST_ENDIAN)
-				mpz_switch_byteorder(v, i->len / BITS_PER_BYTE);
+				byteorder_switch_expr_value(v, i);
 
 			mpz_add(v, i->prefix->value, v);
 			count = netlink_export_pad(data, v, i);
@@ -298,7 +303,7 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 		expr = (struct expr *)i;
 		if (expr_basetype(expr)->type == TYPE_INTEGER &&
 		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
-			mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
+			byteorder_switch_expr_value(expr->value, expr);
 		break;
 	default:
 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
diff --git a/tests/shell/testcases/bogons/nft-f/byteorder_switch_stack_overflow b/tests/shell/testcases/bogons/nft-f/byteorder_switch_stack_overflow
new file mode 100644
index 000000000000..0164052877b7
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/byteorder_switch_stack_overflow
@@ -0,0 +1,6 @@
+table inet x {
+	chain nat_dns_acme {
+		udp length . @th,260,118 vmap { 47-63 . 0xe373135363130333131303735353203 : goto nat_dns_dnstc, }
+		drop
+	}
+}
-- 
2.41.0

