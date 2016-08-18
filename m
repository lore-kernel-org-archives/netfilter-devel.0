From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] expr: hash: Add comparator to hash expression
Date: Thu, 18 Aug 2016 07:24:15 +0200
Message-ID: <20160818052415.22524-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:36296 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbcHRFY0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Aug 2016 01:24:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Comparators are mandatory so hash expression must have one.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/hash.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/src/expr/hash.c b/src/expr/hash.c
index 7309907..01f362f 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -280,10 +280,32 @@ nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
 	return -1;
 }
 
+static bool nftnl_expr_hash_cmp(const struct nftnl_expr *e1,
+				const struct nftnl_expr *e2)
+{
+	struct nftnl_expr_hash *h1 = nftnl_expr_data(e1);
+	struct nftnl_expr_hash *h2 = nftnl_expr_data(e2);
+	bool eq = true;
+
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_SREG))
+		eq &= h1->sreg == h2->sreg;
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_DREG))
+		eq &= h1->dreg == h2->dreg;
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_LEN))
+		eq &= h1->len == h2->len;
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_MODULUS))
+		eq &= h1->modulus == h2->modulus;
+	if (e1->flags & (1 << NFTNL_EXPR_HASH_SEED))
+		eq &= h1->seed == h2->seed;
+
+	return eq;
+}
+
 struct expr_ops expr_ops_hash = {
 	.name		= "hash",
 	.alloc_len	= sizeof(struct nftnl_expr_hash),
 	.max_attr	= NFTA_HASH_MAX,
+	.cmp		= nftnl_expr_hash_cmp,
 	.set		= nftnl_expr_hash_set,
 	.get		= nftnl_expr_hash_get,
 	.parse		= nftnl_expr_hash_parse,
-- 
2.8.3

