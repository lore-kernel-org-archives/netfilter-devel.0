From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 5/6] payload: add payload_may_dependency_kill()
Date: Wed, 14 Feb 2018 16:22:28 +0100
Message-ID: <20180214152229.11830-6-pablo@netfilter.org>
References: <20180214152229.11830-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031168AbeBNPWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 10:22:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42E9C117732
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27DB6DA787
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39FAFDA3A0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:38 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 05C4341E4817
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 16:22:37 +0100 (CET)
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Payload protocol key expressions at network base are meaningful in the
netdev, bridge and inet families, do not exercise the redundant
dependency removal in those cases since it breaks rule semantics.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 383aed039a5e..15d055b6be7e 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -456,6 +456,31 @@ void payload_dependency_release(struct payload_dep_ctx *ctx)
 	ctx->pdep  = NULL;
 }
 
+static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
+					unsigned int family, struct expr *expr)
+{
+	struct expr *dep = ctx->pdep->expr;
+
+	/* Protocol key payload expression at network base such as 'ip6 nexthdr'
+	 * need to be left in place since it implicitly restricts matching to
+	 * IPv6 for the bridge, inet and netdev families.
+	 */
+	switch (family) {
+	case NFPROTO_BRIDGE:
+	case NFPROTO_NETDEV:
+	case NFPROTO_INET:
+		if (dep->left->ops->type == EXPR_PAYLOAD &&
+		    dep->left->payload.base == PROTO_BASE_NETWORK_HDR &&
+		    (dep->left->payload.desc == &proto_ip ||
+		     dep->left->payload.desc == &proto_ip6) &&
+		    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
+			return false;
+		break;
+	}
+
+	return true;
+}
+
 /**
  * payload_dependency_kill - kill a redundant payload depedency
  *
@@ -463,12 +488,14 @@ void payload_dependency_release(struct payload_dep_ctx *ctx)
  * @expr: higher layer payload expression
  *
  * Kill a redundant payload expression if a higher layer payload expression
- * implies its existance.
+ * implies its existance. Skip this if the dependency is a network payload and
+ * we are in bridge, netdev and inet families.
  */
 void payload_dependency_kill(struct payload_dep_ctx *ctx, struct expr *expr,
 			     unsigned int family)
 {
-	if (payload_dependency_exists(ctx, expr->payload.base))
+	if (payload_dependency_exists(ctx, expr->payload.base) &&
+	    payload_may_dependency_kill(ctx, family, expr))
 		payload_dependency_release(ctx);
 }
 
-- 
2.11.0

