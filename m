Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C25C677F1
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 13:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjARNJT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 08:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjARNJB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 08:09:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FA459756;
        Wed, 18 Jan 2023 04:33:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cd-00075o-0x; Wed, 18 Jan 2023 13:32:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 7/9] netfilter: nf_tables: avoid retpoline overhead for objref calls
Date:   Wed, 18 Jan 2023 13:32:06 +0100
Message-Id: <20230118123208.17167-8-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

objref expression is builtin, so avoid calls to it for
RETOLINE=y builds.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h |  4 ++++
 net/netfilter/nf_tables_core.c         |  2 ++
 net/netfilter/nft_objref.c             | 12 ++++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 3e825381ac5c..bedef373ec21 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -164,4 +164,8 @@ void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt,
 			    struct nft_inner_tun_ctx *ctx);
 
+void nft_objref_eval(const struct nft_expr *expr, struct nft_regs *regs,
+		     const struct nft_pktinfo *pkt);
+void nft_objref_map_eval(const struct nft_expr *expr, struct nft_regs *regs,
+			 const struct nft_pktinfo *pkt);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 0f26d002d8b3..d9992906199f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -234,6 +234,8 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 	X(e, nft_dynset_eval);
 	X(e, nft_rt_get_eval);
 	X(e, nft_bitwise_eval);
+	X(e, nft_objref_eval);
+	X(e, nft_objref_map_eval);
 #undef  X
 indirect_call:
 #endif /* CONFIG_RETPOLINE */
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7b01aa2ef653..cb37169608ba 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -13,9 +13,9 @@
 
 #define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
 
-static void nft_objref_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+void nft_objref_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs,
+		     const struct nft_pktinfo *pkt)
 {
 	struct nft_object *obj = nft_objref_priv(expr);
 
@@ -100,9 +100,9 @@ struct nft_objref_map {
 	struct nft_set_binding	binding;
 };
 
-static void nft_objref_map_eval(const struct nft_expr *expr,
-				struct nft_regs *regs,
-				const struct nft_pktinfo *pkt)
+void nft_objref_map_eval(const struct nft_expr *expr,
+			 struct nft_regs *regs,
+			 const struct nft_pktinfo *pkt)
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
-- 
2.38.2

