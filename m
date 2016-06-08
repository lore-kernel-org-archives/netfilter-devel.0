From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 4/4] netfilter: nft_meta: add explicitly nf_logger_find_get call
Date: Wed,  8 Jun 2016 20:43:20 +0800
Message-ID: <1465389800-27842-5-git-send-email-zlpnobody@163.com>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:33426 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422765AbcFHMoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:44:15 -0400
In-Reply-To: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Like xt_TRACE do, we should request related nf_log module appropriately.
Otherwise, if the nf_log_ipv4 kernel module is not installed, and the
user add the following nft rule:
  # nft add rule filter input nftrace set 1

There will be no trace log generated until we install nf_log_ipv4 module
manually.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_meta.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f4bad9d..abeb2ef 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -24,6 +24,7 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_log.h>
 #include <net/netfilter/nft_meta.h>
 
 #include <uapi/linux/netfilter_bridge.h> /* NF_BR_PRE_ROUTING */
@@ -348,8 +349,13 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (priv->key == NFT_META_NFTRACE)
+	if (priv->key == NFT_META_NFTRACE) {
+		err = nf_logger_find_get(ctx->afi->family, NF_LOG_TYPE_LOG);
+		if (err < 0)
+			return err;
+
 		static_branch_inc(&nft_trace_enabled);
+	}
 
 	return 0;
 }
@@ -393,8 +399,10 @@ void nft_meta_set_destroy(const struct nft_ctx *ctx,
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
-	if (priv->key == NFT_META_NFTRACE)
+	if (priv->key == NFT_META_NFTRACE) {
 		static_branch_dec(&nft_trace_enabled);
+		nf_logger_put(ctx->afi->family, NF_LOG_TYPE_LOG);
+	}
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
 
-- 
2.5.5


