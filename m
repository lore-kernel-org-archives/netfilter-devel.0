Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3FAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiAOS1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 13:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiAOS1v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 13:27:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F71C06173E
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1T4zceRVnz+CxiS/l7+/PtIxlGR+fq3uDxVw51NUCms=; b=YsBnubHu/SxZ/oUaccGgHdwgdT
        Fz8y2Oi1oz3Gf1KKKoHdyN3Zl4KQV3BeHyevmgndYUsYoetgSdQHo2XJGLlj0MDptRtZWFtys8z42
        tG4xvrvRKfUaEOo2Bgd/KAVIkzv1StTMRJkKnLU11NWzhqKCMyNXdJCOCRYHfHqUUFzuOcOsggaaO
        9jFA3pcHfxAGb0hbJzUAibYvAdb9fU0JeeipXM7y+SIbouJ017AhOerv7RygHD5F2iuNnHv9zle8y
        j5FCqVb6mUOQO5IHYUHTMF+RsY7ZT4VyI2Jsfw/RkrtV/Oungk637uyS/I0wj0UldNkOCLoddnP9o
        uwGWQo+w==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8nmH-008OQb-DZ; Sat, 15 Jan 2022 18:27:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 2/5] src: add a helper that returns a payload dependency for a particular base
Date:   Sat, 15 Jan 2022 18:27:06 +0000
Message-Id: <20220115182709.1999424-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220115182709.1999424-1-jeremy@azazel.net>
References: <20220115182709.1999424-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, with only one base and dependency stored this is superfluous,
but it will become more useful when the next commit adds support for
storing a payload for every base.

Remove redundant `ctx->pbase` check.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c |  4 ++--
 src/payload.c             | 31 +++++++++++++++++++++++++++----
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 8bc3fb9a8a54..af6fa4782706 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -47,6 +47,8 @@ extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     enum proto_bases base);
 extern bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
+extern struct expr *payload_dependency_get(struct payload_dep_ctx *ctx,
+					   enum proto_bases base);
 extern void payload_dependency_release(struct payload_dep_ctx *ctx);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr, unsigned int family);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fd81e07151c2..5e474b321379 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2060,9 +2060,9 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 				     const struct expr *expr)
 {
 	uint8_t l4proto, nfproto = NFPROTO_UNSPEC;
-	struct expr *dep = ctx->pdep->expr;
+	struct expr *dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR);
 
-	if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
+	if (!dep)
 		return true;
 
 	if (__meta_dependency_may_kill(dep, &nfproto))
diff --git a/src/payload.c b/src/payload.c
index 576eb149f71d..accbe0ab6066 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -631,6 +631,27 @@ bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 	       (ctx->pbase == base || (base == PROTO_BASE_TRANSPORT_HDR && ctx->pbase == base + 1));
 }
 
+/**
+ * payload_dependency_get - return a payload dependency if available
+ * @ctx: payload dependency context
+ * @base: payload protocol base
+ *
+ * If we have seen a protocol key payload expression for this base, we return
+ * it.
+ */
+struct expr *payload_dependency_get(struct payload_dep_ctx *ctx,
+				    enum proto_bases base)
+{
+	if (ctx->pbase == base)
+		return ctx->pdep->expr;
+
+	if (base == PROTO_BASE_TRANSPORT_HDR &&
+	    ctx->pbase == PROTO_BASE_INNER_HDR)
+		return ctx->pdep->expr;
+
+	return NULL;
+}
+
 void payload_dependency_release(struct payload_dep_ctx *ctx)
 {
 	list_del(&ctx->pdep->list);
@@ -661,7 +682,7 @@ static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
 
 static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct expr *expr)
 {
-	const struct expr *dep = ctx->pdep->expr;
+	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
 	uint8_t icmp_type;
 
 	icmp_type = expr->payload.tmpl->icmp_dep;
@@ -678,9 +699,11 @@ static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct
 
 static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct expr *expr)
 {
-	const struct expr *dep = ctx->pdep->expr;
+	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
 
-	/* Never remove a 'vlan type 0x...' expression, they are never added implicitly */
+	/* Never remove a 'vlan type 0x...' expression, they are never added
+	 * implicitly
+	 */
 	if (dep->left->payload.desc == &proto_vlan)
 		return false;
 
@@ -697,7 +720,7 @@ static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct e
 static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 					unsigned int family, struct expr *expr)
 {
-	struct expr *dep = ctx->pdep->expr;
+	struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
 
 	/* Protocol key payload expression at network base such as 'ip6 nexthdr'
 	 * need to be left in place since it implicitly restricts matching to
-- 
2.34.1

