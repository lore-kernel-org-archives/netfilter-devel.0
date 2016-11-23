From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_fib: convert htonl to ntohl properly
Date: Wed, 23 Nov 2016 22:12:20 +0800
Message-ID: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:35819 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935052AbcKWONT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2016 09:13:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Acctually ntohl and htonl are identical, so this doesn't affect
anything, but it is conceptually wrong.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c | 2 +-
 net/netfilter/nft_fib.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 1b49966..bfffa74 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -198,7 +198,7 @@ nft_fib4_select_ops(const struct nft_ctx *ctx,
 	if (!tb[NFTA_FIB_RESULT])
 		return ERR_PTR(-EINVAL);
 
-	result = htonl(nla_get_be32(tb[NFTA_FIB_RESULT]));
+	result = ntohl(nla_get_be32(tb[NFTA_FIB_RESULT]));
 
 	switch (result) {
 	case NFT_FIB_RESULT_OIF:
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index d526bb5..c947aad 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -235,7 +235,7 @@ nft_fib6_select_ops(const struct nft_ctx *ctx,
 	if (!tb[NFTA_FIB_RESULT])
 		return ERR_PTR(-EINVAL);
 
-	result = htonl(nla_get_be32(tb[NFTA_FIB_RESULT]));
+	result = ntohl(nla_get_be32(tb[NFTA_FIB_RESULT]));
 
 	switch (result) {
 	case NFT_FIB_RESULT_OIF:
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 249c9b8..29a4906 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -86,7 +86,7 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if ((priv->flags & (NFTA_FIB_F_SADDR | NFTA_FIB_F_DADDR)) == 0)
 		return -EINVAL;
 
-	priv->result = htonl(nla_get_be32(tb[NFTA_FIB_RESULT]));
+	priv->result = ntohl(nla_get_be32(tb[NFTA_FIB_RESULT]));
 	priv->dreg = nft_parse_register(tb[NFTA_FIB_DREG]);
 
 	switch (priv->result) {
-- 
2.5.5


