Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DB8C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 14:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FD560C3D
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 14:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhDTOMF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhDTOMF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 10:12:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E44C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 07:11:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lYr6B-0000MA-4Q; Tue, 20 Apr 2021 16:11:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: disable defrag once its no longer needed
Date:   Tue, 20 Apr 2021 16:11:25 +0200
Message-Id: <20210420141125.28523-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When I changed defrag hooks to no longer get registered by default I
intentionally made it so that registration can only be un-done by unloading
the nf_defrag_ipv4/6 module.

In hindsight this was too conservative; there is no reason to keep defrag
on while there is no feature dependency anymore.

Moreover, this won't work if user isn't allowed to remove nf_defrag module.

This adds the disable() functions for both ipv4 and ipv6 and calls them
from conntrack, TPROXY and the xtables socket module.

ipvs isn't converted here, it will behave as before this patch and
will need module removal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/ipv4/nf_defrag_ipv4.h |  3 ++-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  3 ++-
 net/ipv4/netfilter/nf_defrag_ipv4.c         | 30 ++++++++++++++++-----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   | 29 +++++++++++++++-----
 net/netfilter/nf_conntrack_proto.c          |  8 ++++--
 net/netfilter/nft_tproxy.c                  | 24 +++++++++++++++++
 net/netfilter/xt_TPROXY.c                   | 13 +++++++++
 net/netfilter/xt_socket.c                   | 14 ++++++++++
 8 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_defrag_ipv4.h b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
index bcbd724cc048..7fda9ce9f694 100644
--- a/include/net/netfilter/ipv4/nf_defrag_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
@@ -3,6 +3,7 @@
 #define _NF_DEFRAG_IPV4_H
 
 struct net;
-int nf_defrag_ipv4_enable(struct net *);
+int nf_defrag_ipv4_enable(struct net *net);
+void nf_defrag_ipv4_disable(struct net *net);
 
 #endif /* _NF_DEFRAG_IPV4_H */
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index ece923e2035b..0fd8a4159662 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -5,7 +5,8 @@
 #include <linux/skbuff.h>
 #include <linux/types.h>
 
-int nf_defrag_ipv6_enable(struct net *);
+int nf_defrag_ipv6_enable(struct net *net);
+void nf_defrag_ipv6_disable(struct net *net);
 
 int nf_ct_frag6_init(void);
 void nf_ct_frag6_cleanup(void);
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index ffdcc2b9360f..613432a36f0a 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -141,14 +141,16 @@ int nf_defrag_ipv4_enable(struct net *net)
 	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
 	int err = 0;
 
-	might_sleep();
-
-	if (nf_defrag->users)
-		return 0;
-
 	mutex_lock(&defrag4_mutex);
-	if (nf_defrag->users)
+	if (nf_defrag->users == UINT_MAX) {
+		err = -EOVERFLOW;
 		goto out_unlock;
+	}
+
+	if (nf_defrag->users) {
+		nf_defrag->users++;
+		goto out_unlock;
+	}
 
 	err = nf_register_net_hooks(net, ipv4_defrag_ops,
 				    ARRAY_SIZE(ipv4_defrag_ops));
@@ -161,6 +163,22 @@ int nf_defrag_ipv4_enable(struct net *net)
 }
 EXPORT_SYMBOL_GPL(nf_defrag_ipv4_enable);
 
+void nf_defrag_ipv4_disable(struct net *net)
+{
+	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
+
+	mutex_lock(&defrag4_mutex);
+	if (nf_defrag->users) {
+		nf_defrag->users--;
+		if (nf_defrag->users == 0)
+			nf_unregister_net_hooks(net, ipv4_defrag_ops,
+						ARRAY_SIZE(ipv4_defrag_ops));
+	}
+
+	mutex_unlock(&defrag4_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_defrag_ipv4_disable);
+
 module_init(nf_defrag_init);
 module_exit(nf_defrag_fini);
 
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 402dc4ca9504..e8a59d8bf2ad 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -137,14 +137,16 @@ int nf_defrag_ipv6_enable(struct net *net)
 	struct nft_ct_frag6_pernet *nf_frag = net_generic(net, nf_frag_pernet_id);
 	int err = 0;
 
-	might_sleep();
-
-	if (nf_frag->users)
-		return 0;
-
 	mutex_lock(&defrag6_mutex);
-	if (nf_frag->users)
+	if (nf_frag->users == UINT_MAX) {
+		err = -EOVERFLOW;
+		goto out_unlock;
+	}
+
+	if (nf_frag->users) {
+		nf_frag->users++;
 		goto out_unlock;
+	}
 
 	err = nf_register_net_hooks(net, ipv6_defrag_ops,
 				    ARRAY_SIZE(ipv6_defrag_ops));
@@ -157,6 +159,21 @@ int nf_defrag_ipv6_enable(struct net *net)
 }
 EXPORT_SYMBOL_GPL(nf_defrag_ipv6_enable);
 
+void nf_defrag_ipv6_disable(struct net *net)
+{
+	struct nft_ct_frag6_pernet *nf_frag = net_generic(net, nf_frag_pernet_id);
+
+	mutex_lock(&defrag6_mutex);
+	if (nf_frag->users) {
+		nf_frag->users--;
+		if (nf_frag->users == 0)
+			nf_unregister_net_hooks(net, ipv6_defrag_ops,
+						ARRAY_SIZE(ipv6_defrag_ops));
+	}
+	mutex_unlock(&defrag6_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_defrag_ipv6_disable);
+
 module_init(nf_defrag_init);
 module_exit(nf_defrag_fini);
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 47e9319d2cf3..89e5bac384d7 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -536,15 +536,19 @@ static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
 	mutex_lock(&nf_ct_proto_mutex);
 	switch (nfproto) {
 	case NFPROTO_IPV4:
-		if (cnet->users4 && (--cnet->users4 == 0))
+		if (cnet->users4 && (--cnet->users4 == 0)) {
 			nf_unregister_net_hooks(net, ipv4_conntrack_ops,
 						ARRAY_SIZE(ipv4_conntrack_ops));
+			nf_defrag_ipv4_disable(net);
+		}
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case NFPROTO_IPV6:
-		if (cnet->users6 && (--cnet->users6 == 0))
+		if (cnet->users6 && (--cnet->users6 == 0)) {
 			nf_unregister_net_hooks(net, ipv6_conntrack_ops,
 						ARRAY_SIZE(ipv6_conntrack_ops));
+			nf_defrag_ipv6_disable(net);
+		}
 		break;
 #endif
 	case NFPROTO_BRIDGE:
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 43a5a780a6d3..accef672088c 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -263,6 +263,29 @@ static int nft_tproxy_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static void nft_tproxy_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	const struct nft_tproxy *priv = nft_expr_priv(expr);
+
+	switch (priv->family) {
+	case NFPROTO_IPV4:
+		nf_defrag_ipv4_disable(ctx->net);
+		break;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case NFPROTO_IPV6:
+		nf_defrag_ipv6_disable(ctx->net);
+		break;
+#endif
+	case NFPROTO_UNSPEC:
+		nf_defrag_ipv4_disable(ctx->net);
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+		nf_defrag_ipv6_disable(ctx->net);
+#endif
+		break;
+	}
+}
+
 static int nft_tproxy_dump(struct sk_buff *skb,
 			   const struct nft_expr *expr)
 {
@@ -288,6 +311,7 @@ static const struct nft_expr_ops nft_tproxy_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_tproxy)),
 	.eval		= nft_tproxy_eval,
 	.init		= nft_tproxy_init,
+	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
 };
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 194dc03341f3..d231cd14e8cf 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -219,6 +219,16 @@ static int tproxy_tg4_check(const struct xt_tgchk_param *par)
 	return -EINVAL;
 }
 
+static void tproxy_tg4_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_defrag_ipv4_disable(par->net);
+}
+
+static void tproxy_tg6_destroy(const struct xt_tgdtor_param *par)
+{
+	nf_defrag_ipv6_disable(par->net);
+}
+
 static struct xt_target tproxy_tg_reg[] __read_mostly = {
 	{
 		.name		= "TPROXY",
@@ -228,6 +238,7 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 		.revision	= 0,
 		.targetsize	= sizeof(struct xt_tproxy_target_info),
 		.checkentry	= tproxy_tg4_check,
+		.destroy	= tproxy_tg4_destroy,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
@@ -239,6 +250,7 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 		.revision	= 1,
 		.targetsize	= sizeof(struct xt_tproxy_target_info_v1),
 		.checkentry	= tproxy_tg4_check,
+		.destroy	= tproxy_tg4_destroy,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
@@ -251,6 +263,7 @@ static struct xt_target tproxy_tg_reg[] __read_mostly = {
 		.revision	= 1,
 		.targetsize	= sizeof(struct xt_tproxy_target_info_v1),
 		.checkentry	= tproxy_tg6_check,
+		.destroy	= tproxy_tg6_destroy,
 		.hooks		= 1 << NF_INET_PRE_ROUTING,
 		.me		= THIS_MODULE,
 	},
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 5f973987265d..5e6459e11605 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -216,6 +216,14 @@ static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static void socket_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	if (par->family == NFPROTO_IPV4)
+		nf_defrag_ipv4_disable(par->net);
+	else if (par->family == NFPROTO_IPV6)
+		nf_defrag_ipv4_disable(par->net);
+}
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name		= "socket",
@@ -231,6 +239,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v1_v2_v3,
+		.destroy	= socket_mt_destroy,
 		.checkentry	= socket_mt_v1_check,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
@@ -245,6 +254,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.match		= socket_mt6_v1_v2_v3,
 		.checkentry	= socket_mt_v1_check,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
+		.destroy	= socket_mt_destroy,
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
@@ -256,6 +266,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v1_v2_v3,
 		.checkentry	= socket_mt_v2_check,
+		.destroy	= socket_mt_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
@@ -268,6 +279,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.match		= socket_mt6_v1_v2_v3,
 		.checkentry	= socket_mt_v2_check,
+		.destroy	= socket_mt_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
@@ -280,6 +292,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt4_v1_v2_v3,
 		.checkentry	= socket_mt_v3_check,
+		.destroy	= socket_mt_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
@@ -292,6 +305,7 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.match		= socket_mt6_v1_v2_v3,
 		.checkentry	= socket_mt_v3_check,
+		.destroy	= socket_mt_destroy,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
 		.hooks		= (1 << NF_INET_PRE_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
-- 
2.26.3

