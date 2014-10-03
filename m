From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next PATCH] netfilter: nft_masq: fix register/unregister
 notifier on module _init and _exit
Date: Fri, 03 Oct 2014 14:13:36 +0200
Message-ID: <20141003121335.2864.5519.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34626 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751548AbaJCMNu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:13:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's mimic the behaviour of ipt_MASQUERADE and ip6t_MASQUERADE and
register/unregister the masquerade notifiers on module _init and _exit.

The configuration previous to this patch may lead to spurious kernel crashes.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/ipv4/netfilter/nft_masq_ipv4.c |   32 +++++++++-----------------------
 net/ipv6/netfilter/nft_masq_ipv6.c |   32 +++++++++-----------------------
 2 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index 6ea1d20..e143edb 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -32,33 +32,12 @@ static void nft_masq_ipv4_eval(const struct nft_expr *expr,
 	data[NFT_REG_VERDICT].verdict = verdict;
 }
 
-static int nft_masq_ipv4_init(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nlattr * const tb[])
-{
-	int err;
-
-	err = nft_masq_init(ctx, expr, tb);
-	if (err < 0)
-		return err;
-
-	nf_nat_masquerade_ipv4_register_notifier();
-	return 0;
-}
-
-static void nft_masq_ipv4_destroy(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
-{
-	nf_nat_masquerade_ipv4_unregister_notifier();
-}
-
 static struct nft_expr_type nft_masq_ipv4_type;
 static const struct nft_expr_ops nft_masq_ipv4_ops = {
 	.type		= &nft_masq_ipv4_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
 	.eval		= nft_masq_ipv4_eval,
-	.init		= nft_masq_ipv4_init,
-	.destroy	= nft_masq_ipv4_destroy,
+	.init		= nft_masq_init,
 	.dump		= nft_masq_dump,
 };
 
@@ -73,12 +52,19 @@ static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
 
 static int __init nft_masq_ipv4_module_init(void)
 {
-	return nft_register_expr(&nft_masq_ipv4_type);
+	int ret;
+
+	ret = nft_register_expr(&nft_masq_ipv4_type);
+	if (ret == 0)
+		nf_nat_masquerade_ipv4_register_notifier();
+
+	return ret;
 }
 
 static void __exit nft_masq_ipv4_module_exit(void)
 {
 	nft_unregister_expr(&nft_masq_ipv4_type);
+	nf_nat_masquerade_ipv4_unregister_notifier();
 }
 
 module_init(nft_masq_ipv4_module_init);
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 4e51334..ed1c8dc 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -32,33 +32,12 @@ static void nft_masq_ipv6_eval(const struct nft_expr *expr,
 	data[NFT_REG_VERDICT].verdict = verdict;
 }
 
-static int nft_masq_ipv6_init(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nlattr * const tb[])
-{
-	int err;
-
-	err = nft_masq_init(ctx, expr, tb);
-	if (err < 0)
-		return err;
-
-	nf_nat_masquerade_ipv6_register_notifier();
-	return 0;
-}
-
-static void nft_masq_ipv6_destroy(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
-{
-	nf_nat_masquerade_ipv6_unregister_notifier();
-}
-
 static struct nft_expr_type nft_masq_ipv6_type;
 static const struct nft_expr_ops nft_masq_ipv6_ops = {
 	.type		= &nft_masq_ipv6_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
 	.eval		= nft_masq_ipv6_eval,
-	.init		= nft_masq_ipv6_init,
-	.destroy	= nft_masq_ipv6_destroy,
+	.init		= nft_masq_init,
 	.dump		= nft_masq_dump,
 };
 
@@ -73,12 +52,19 @@ static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
 
 static int __init nft_masq_ipv6_module_init(void)
 {
-	return nft_register_expr(&nft_masq_ipv6_type);
+	int ret;
+
+	ret = nft_register_expr(&nft_masq_ipv6_type);
+	if (ret == 0)
+		nf_nat_masquerade_ipv6_register_notifier();
+
+	return ret;
 }
 
 static void __exit nft_masq_ipv6_module_exit(void)
 {
 	nft_unregister_expr(&nft_masq_ipv6_type);
+	nf_nat_masquerade_ipv6_unregister_notifier();
 }
 
 module_init(nft_masq_ipv6_module_init);

