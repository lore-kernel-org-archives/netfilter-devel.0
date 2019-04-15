Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE32C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE13A2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfDORAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:43 -0400
Received: from mail.us.es ([193.147.175.20]:50474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfDORAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0D66B1C4435
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE20CDA704
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED1FFDA716; Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5416DA704;
        Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 795104265A31;
        Mon, 15 Apr 2019 19:00:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/22] netfilter: nat: add inet family nat support
Date:   Mon, 15 Apr 2019 19:00:13 +0200
Message-Id: <20190415170028.3470-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We need minimal support from the nat core for this, as we do not
want to register additional base hooks.

When an inet hook is registered, interally register ipv4 and ipv6
hooks for them and unregister those when inet hooks are removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h |  7 +++--
 net/netfilter/nf_nat_core.c    | 16 +++++-------
 net/netfilter/nf_nat_proto.c   | 43 ++++++++++++++++++++++++++-----
 net/netfilter/nft_chain_nat.c  | 36 ++++++++++++++++++++++++++
 net/netfilter/nft_nat.c        | 58 ++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 141 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index cf332c4e0b32..423cda2c6542 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -69,9 +69,9 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 #endif
 }
 
-int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
+int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *nat_ops, unsigned int ops_count);
-void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
+void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 			  unsigned int ops_count);
 
 unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
@@ -98,6 +98,9 @@ void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 int nf_nat_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
+int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops);
+void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af7dc6537758..a9ec49edd7f4 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1009,7 +1009,7 @@ static struct nf_ct_helper_expectfn follow_master_nat = {
 	.expectfn	= nf_nat_follow_master,
 };
 
-int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
+int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *orig_nat_ops, unsigned int ops_count)
 {
 	struct nat_net *nat_net = net_generic(net, nat_net_id);
@@ -1019,14 +1019,12 @@ int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
 	struct nf_hook_ops *nat_ops;
 	int i, ret;
 
-	if (WARN_ON_ONCE(ops->pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
+	if (WARN_ON_ONCE(pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
 		return -EINVAL;
 
-	nat_proto_net = &nat_net->nat_proto_net[ops->pf];
+	nat_proto_net = &nat_net->nat_proto_net[pf];
 
 	for (i = 0; i < ops_count; i++) {
-		if (WARN_ON(orig_nat_ops[i].pf != ops->pf))
-			return -EINVAL;
 		if (orig_nat_ops[i].hooknum == hooknum) {
 			hooknum = i;
 			break;
@@ -1086,8 +1084,8 @@ int nf_nat_register_fn(struct net *net, const struct nf_hook_ops *ops,
 	return ret;
 }
 
-void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
-		          unsigned int ops_count)
+void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
+			  unsigned int ops_count)
 {
 	struct nat_net *nat_net = net_generic(net, nat_net_id);
 	struct nf_nat_hooks_net *nat_proto_net;
@@ -1096,10 +1094,10 @@ void nf_nat_unregister_fn(struct net *net, const struct nf_hook_ops *ops,
 	int hooknum = ops->hooknum;
 	int i;
 
-	if (ops->pf >= ARRAY_SIZE(nat_net->nat_proto_net))
+	if (pf >= ARRAY_SIZE(nat_net->nat_proto_net))
 		return;
 
-	nat_proto_net = &nat_net->nat_proto_net[ops->pf];
+	nat_proto_net = &nat_net->nat_proto_net[pf];
 
 	mutex_lock(&nf_nat_proto_mutex);
 	if (WARN_ON(nat_proto_net->users == 0))
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 62743da3004f..606d0a740615 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -725,7 +725,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
+const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv4_in,
@@ -758,13 +758,14 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 
 int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_nat_register_fn(net, ops, nf_nat_ipv4_ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+	return nf_nat_register_fn(net, ops->pf, ops, nf_nat_ipv4_ops,
+				  ARRAY_SIZE(nf_nat_ipv4_ops));
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv4_register_fn);
 
 void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+	nf_nat_unregister_fn(net, ops->pf, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv4_unregister_fn);
 
@@ -977,7 +978,7 @@ nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
 	return ret;
 }
 
-static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
+const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_ipv6_in,
@@ -1010,14 +1011,44 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 
 int nf_nat_ipv6_register_fn(struct net *net, const struct nf_hook_ops *ops)
 {
-	return nf_nat_register_fn(net, ops, nf_nat_ipv6_ops,
+	return nf_nat_register_fn(net, ops->pf, ops, nf_nat_ipv6_ops,
 				  ARRAY_SIZE(nf_nat_ipv6_ops));
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv6_register_fn);
 
 void nf_nat_ipv6_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
 {
-	nf_nat_unregister_fn(net, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
+	nf_nat_unregister_fn(net, ops->pf, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
 }
 EXPORT_SYMBOL_GPL(nf_nat_ipv6_unregister_fn);
 #endif /* CONFIG_IPV6 */
+
+#if defined(CONFIG_NF_TABLES_INET) && IS_ENABLED(CONFIG_NFT_NAT)
+int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(ops->pf != NFPROTO_INET))
+		return -EINVAL;
+
+	ret = nf_nat_register_fn(net, NFPROTO_IPV6, ops, nf_nat_ipv6_ops,
+				 ARRAY_SIZE(nf_nat_ipv6_ops));
+	if (ret)
+		return ret;
+
+	ret = nf_nat_register_fn(net, NFPROTO_IPV4, ops, nf_nat_ipv4_ops,
+				 ARRAY_SIZE(nf_nat_ipv4_ops));
+	if (ret)
+		nf_nat_ipv6_unregister_fn(net, ops);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_inet_register_fn);
+
+void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops)
+{
+	nf_nat_unregister_fn(net, NFPROTO_IPV4, ops, ARRAY_SIZE(nf_nat_ipv4_ops));
+	nf_nat_unregister_fn(net, NFPROTO_IPV6, ops, ARRAY_SIZE(nf_nat_ipv6_ops));
+}
+EXPORT_SYMBOL_GPL(nf_nat_inet_unregister_fn);
+#endif /* NFT INET NAT */
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index ee4852088d50..2f89bde3c61c 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -74,6 +74,36 @@ static const struct nft_chain_type nft_chain_nat_ipv6 = {
 };
 #endif
 
+#ifdef CONFIG_NF_TABLES_INET
+static int nft_nat_inet_reg(struct net *net, const struct nf_hook_ops *ops)
+{
+	return nf_nat_inet_register_fn(net, ops);
+}
+
+static void nft_nat_inet_unreg(struct net *net, const struct nf_hook_ops *ops)
+{
+	nf_nat_inet_unregister_fn(net, ops);
+}
+
+static const struct nft_chain_type nft_chain_nat_inet = {
+	.name		= "nat",
+	.type		= NFT_CHAIN_T_NAT,
+	.family		= NFPROTO_INET,
+	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_IN]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_nat_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
+	},
+	.ops_register		= nft_nat_inet_reg,
+	.ops_unregister		= nft_nat_inet_unreg,
+};
+#endif
+
 static int __init nft_chain_nat_init(void)
 {
 #ifdef CONFIG_NF_TABLES_IPV6
@@ -82,6 +112,9 @@ static int __init nft_chain_nat_init(void)
 #ifdef CONFIG_NF_TABLES_IPV4
 	nft_register_chain_type(&nft_chain_nat_ipv4);
 #endif
+#ifdef CONFIG_NF_TABLES_INET
+	nft_register_chain_type(&nft_chain_nat_inet);
+#endif
 
 	return 0;
 }
@@ -94,6 +127,9 @@ static void __exit nft_chain_nat_exit(void)
 #ifdef CONFIG_NF_TABLES_IPV6
 	nft_unregister_chain_type(&nft_chain_nat_ipv6);
 #endif
+#ifdef CONFIG_NF_TABLES_INET
+	nft_unregister_chain_type(&nft_chain_nat_inet);
+#endif
 }
 
 module_init(nft_chain_nat_init);
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index e93aed9bda88..d90d421826aa 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -140,7 +140,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
-	if (family != ctx->family)
+	if (ctx->family != NFPROTO_INET && ctx->family != family)
 		return -EOPNOTSUPP;
 
 	switch (family) {
@@ -278,13 +278,67 @@ static struct nft_expr_type nft_nat_type __read_mostly = {
 	.owner          = THIS_MODULE,
 };
 
+#ifdef CONFIG_NF_TABLES_INET
+static void nft_nat_inet_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_nat *priv = nft_expr_priv(expr);
+
+	if (priv->family == nft_pf(pkt))
+		nft_nat_eval(expr, regs, pkt);
+}
+
+static const struct nft_expr_ops nft_nat_inet_ops = {
+	.type           = &nft_nat_type,
+	.size           = NFT_EXPR_SIZE(sizeof(struct nft_nat)),
+	.eval           = nft_nat_inet_eval,
+	.init           = nft_nat_init,
+	.destroy        = nft_nat_destroy,
+	.dump           = nft_nat_dump,
+	.validate	= nft_nat_validate,
+};
+
+static struct nft_expr_type nft_inet_nat_type __read_mostly = {
+	.name           = "nat",
+	.family		= NFPROTO_INET,
+	.ops            = &nft_nat_inet_ops,
+	.policy         = nft_nat_policy,
+	.maxattr        = NFTA_NAT_MAX,
+	.owner          = THIS_MODULE,
+};
+
+static int nft_nat_inet_module_init(void)
+{
+	return nft_register_expr(&nft_inet_nat_type);
+}
+
+static void nft_nat_inet_module_exit(void)
+{
+	nft_unregister_expr(&nft_inet_nat_type);
+}
+#else
+static int nft_nat_inet_module_init(void) { return 0; }
+static void nft_nat_inet_module_exit(void) { }
+#endif
+
 static int __init nft_nat_module_init(void)
 {
-	return nft_register_expr(&nft_nat_type);
+	int ret = nft_nat_inet_module_init();
+
+	if (ret)
+		return ret;
+
+	ret = nft_register_expr(&nft_nat_type);
+	if (ret)
+		nft_nat_inet_module_exit();
+
+	return ret;
 }
 
 static void __exit nft_nat_module_exit(void)
 {
+	nft_nat_inet_module_exit();
 	nft_unregister_expr(&nft_nat_type);
 }
 
-- 
2.11.0

