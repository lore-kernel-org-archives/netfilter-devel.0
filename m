From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 5/5] netfilter: nft_nat: fix family validation
Date: Fri,  7 Mar 2014 19:08:33 +0100
Message-ID: <1394215713-32049-6-git-send-email-kaber@trash.net>
References: <1394215713-32049-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39705 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCGSIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:08:36 -0500
In-Reply-To: <1394215713-32049-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The family in the NAT expression is basically completely useless since
we have it available during runtime anyway. Nevertheless it is used to
decide the NAT family, so at least validate it properly. As we don't
support cross-family NAT, it needs to match the family of the table the
expression exists in.

Unfortunately we can't remove it completely since we need to dump it for
userspace (*sigh*), so at least reduce the memory waste.

Additionally clean up the module init function by removing useless
temporary variables.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_nat.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index d3b1ffe..a0195d2 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -31,8 +31,8 @@ struct nft_nat {
 	enum nft_registers      sreg_addr_max:8;
 	enum nft_registers      sreg_proto_min:8;
 	enum nft_registers      sreg_proto_max:8;
-	int                     family;
-	enum nf_nat_manip_type  type;
+	enum nf_nat_manip_type  type:8;
+	u8			family;
 };
 
 static void nft_nat_eval(const struct nft_expr *expr,
@@ -88,6 +88,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			const struct nlattr * const tb[])
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
+	u32 family;
 	int err;
 
 	if (tb[NFTA_NAT_TYPE] == NULL)
@@ -107,9 +108,12 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (tb[NFTA_NAT_FAMILY] == NULL)
 		return -EINVAL;
 
-	priv->family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
-	if (priv->family != AF_INET && priv->family != AF_INET6)
-		return -EINVAL;
+	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
+	if (family != AF_INET && family != AF_INET6)
+		return -EAFNOSUPPORT;
+	if (family != ctx->afi->family)
+		return -EOPNOTSUPP;
+	priv->family = family;
 
 	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
 		priv->sreg_addr_min = ntohl(nla_get_be32(
@@ -202,13 +206,7 @@ static struct nft_expr_type nft_nat_type __read_mostly = {
 
 static int __init nft_nat_module_init(void)
 {
-	int err;
-
-	err = nft_register_expr(&nft_nat_type);
-	if (err < 0)
-		return err;
-
-	return 0;
+	return nft_register_expr(&nft_nat_type);
 }
 
 static void __exit nft_nat_module_exit(void)
-- 
1.8.5.3

