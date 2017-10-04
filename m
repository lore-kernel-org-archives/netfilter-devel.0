From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] netlink: Use nftnl_expr_fprintf() in netlink_dump_expr()
Date: Wed,  4 Oct 2017 23:41:11 +0200
Message-ID: <20171004214111.2755-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52950 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750779AbdJDVlX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 17:41:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This gets rid of the temporary buffer.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Please note that this patch depends on the previously submitted libnftnl
patch "expr: Introduce nftnl_expr_fprintf()". Since that patch is
obviously not contained in libnftnl-1.0.8, this one should not be
applied until nftables-v0.8 has been released.
---
 src/netlink.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index d5d410a847624..c9859ef151213 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -520,13 +520,11 @@ void netlink_dump_rule(const struct nftnl_rule *nlr, struct netlink_ctx *ctx)
 void netlink_dump_expr(const struct nftnl_expr *nle,
 		       FILE *fp, unsigned int debug_mask)
 {
-	char buf[4096];
-
 	if (!(debug_mask & DEBUG_NETLINK))
 		return;
 
-	nftnl_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
-	fprintf(fp, "%s\n", buf);
+	nftnl_expr_fprintf(fp, nle, 0, 0);
+	fprintf(fp, "\n");
 }
 
 static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
-- 
2.13.1

