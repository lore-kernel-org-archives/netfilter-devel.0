Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2701C4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbhLUThT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241815AbhLUThR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0458C061751
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jAFXjaQLRNRSyjnWppIhtTA92QjaB1xVw2ehcR4tdqs=; b=hv99stZTVknzX72/zMx8W5VfVA
        T62RP199GxCXzyt53+jhfmGlfqfDzh/kzHsjZkdZFVCvxsfkKoxh8HsyQxQcBvXePhGHxZ2cn/Cca
        vUVqGK4bO14ZP56dGrVGO2UfEAc0Tpopz0rL5QMq8RyB38kz7wj1aCzCZ+JftRuq/2WMa2HsxMgA5
        w4jUc15uIT1frtY60sHJ1Gm6u2tDh0sNf6Jm/lLAzjiqulbbad9wuHJx6sTGlD2D+49py98BiVNMY
        DuAf9XYe1FQnR2qLSHM6mrPaJEHn3fYOrcl6BTRBV+Nm0H7rRCpYn+oZyulDIkzeSbMWqgiudIznT
        oSa0CHzw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwk-0019T9-6L
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 08/11] src: add a helper that returns a payload dependency for a particular base
Date:   Tue, 21 Dec 2021 19:36:54 +0000
Message-Id: <20211221193657.430866-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221193657.430866-1-jeremy@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/payload.h         |  2 ++
 src/netlink_delinearize.c |  4 +++-
 src/payload.c             | 31 +++++++++++++++++++++++++++----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 8bc3fb9a8a54..10ae9fe4f9c5 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -47,6 +47,8 @@ extern void payload_dependency_store(struct payload_dep_ctx *ctx,
 				     enum proto_bases base);
 extern bool payload_dependency_exists(const struct payload_dep_ctx *ctx,
 				      enum proto_bases base);
+extern struct stmt *payload_dependency_get(struct payload_dep_ctx *ctx,
+					   enum proto_bases base);
 extern void payload_dependency_release(struct payload_dep_ctx *ctx);
 extern void payload_dependency_kill(struct payload_dep_ctx *ctx,
 				    struct expr *expr, unsigned int family);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fd81e07151c2..2a62b309be1d 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2060,11 +2060,13 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 				     const struct expr *expr)
 {
 	uint8_t l4proto, nfproto = NFPROTO_UNSPEC;
-	struct expr *dep = ctx->pdep->expr;
+	struct expr *dep;
 
 	if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
 		return true;
 
+	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
+
 	if (__meta_dependency_may_kill(dep, &nfproto))
 		return true;
 
diff --git a/src/payload.c b/src/payload.c
index 576eb149f71d..902b318ae23a 100644
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
+struct stmt *payload_dependency_get(struct payload_dep_ctx *ctx,
+				    enum proto_bases base)
+{
+	if (ctx->pbase == base)
+		return ctx->pdep;
+
+	if (base == PROTO_BASE_TRANSPORT_HDR &&
+	    ctx->pbase == PROTO_BASE_INNER_HDR)
+		return ctx->pdep;
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
+	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base)->expr;
 	uint8_t icmp_type;
 
 	icmp_type = expr->payload.tmpl->icmp_dep;
@@ -678,9 +699,11 @@ static bool payload_may_dependency_kill_icmp(struct payload_dep_ctx *ctx, struct
 
 static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct expr *expr)
 {
-	const struct expr *dep = ctx->pdep->expr;
+	const struct expr *dep = payload_dependency_get(ctx, expr->payload.base)->expr;
 
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
+	struct expr *dep = payload_dependency_get(ctx, expr->payload.base)->expr;
 
 	/* Protocol key payload expression at network base such as 'ip6 nexthdr'
 	 * need to be left in place since it implicitly restricts matching to
-- 
2.34.1

