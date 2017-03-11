From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCHv2] fib: Add support for NFTA_FIB_F_PRESENT flag
Date: Sat, 11 Mar 2017 14:27:16 +0100
Message-ID: <20170311132716.7762-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50027 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755554AbdCKN13 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2017 08:27:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reflect existence of flag in debug output so testsuite can check for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Print 'present' keyword if flag is set instead of ignoring it.
---
 include/linux/netfilter/nf_tables.h | 1 +
 src/expr/fib.c                      | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4f7d75682c591..a9280a6541ac6 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1257,6 +1257,7 @@ enum nft_fib_flags {
 	NFTA_FIB_F_MARK		= 1 << 2,	/* use skb->mark */
 	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+	NFTA_FIB_F_PRESENT	= 1 << 5,	/* check existence only */
 };
 
 #define NFT_OBJECT_UNSPEC	0
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 9e63621e72877..f3be0810d3250 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -173,7 +173,8 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
 	int len = size, offset = 0, ret, i;
-	uint32_t flags = fib->flags;
+	uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
+	uint32_t present_flag = fib->flags & NFTA_FIB_F_PRESENT;
 	static const struct {
 		int bit;
 		const char *name;
@@ -203,7 +204,10 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf + offset, len, "%s => reg %d ", fib_type_str(fib->result), fib->dreg);
+	ret = snprintf(buf + offset, len, "%s%s => reg %d ",
+		       fib_type_str(fib->result),
+		       present_flag ? " present" : "",
+		       fib->dreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	return offset;
-- 
2.11.0

