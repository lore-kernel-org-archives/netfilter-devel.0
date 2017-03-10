From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] fib: Add support for NFTA_FIB_F_PRESENT flag
Date: Fri, 10 Mar 2017 18:08:28 +0100
Message-ID: <20170310170828.27949-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48457 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755049AbdCJRIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:08:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Actually it is just to be ignored so it's presence doesn't mess up the
op printer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nf_tables.h | 1 +
 src/expr/fib.c                      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index 9e63621e72877..ad78f830f15a2 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -173,7 +173,7 @@ nftnl_expr_fib_snprintf_default(char *buf, size_t size,
 {
 	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
 	int len = size, offset = 0, ret, i;
-	uint32_t flags = fib->flags;
+	uint32_t flags = fib->flags & ~NFTA_FIB_F_PRESENT;
 	static const struct {
 		int bit;
 		const char *name;
-- 
2.11.0

