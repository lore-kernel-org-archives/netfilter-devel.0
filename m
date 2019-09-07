Return-Path: <SRS0=QWtc=XC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C0FC43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 16:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94E35218AE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 16:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="orzCm0r/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394838AbfIGQEo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Sep 2019 12:04:44 -0400
Received: from mx1.riseup.net ([198.252.153.129]:57960 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392003AbfIGQEo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 12:04:44 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 4DE291A11C1
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 09:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567872283; bh=zI+FlUvAw5fEC9QslviQyCaTPv6cL9WVml60lGR9+Sw=;
        h=From:To:Cc:Subject:Date:From;
        b=orzCm0r/rwagbr0pRDWevfA//vAvAJqRibIlxWu0hwP/NeJuEm9DO/LKI8tynsJHl
         f3j66trl1ad1clkP1d54vOChRK4y8bYnVTSf2hDltPxb6DAKKGpjGopzN+eST/MDvN
         qNQFpZTxaP63V1CdDhKNpOj4XgtIr6waQzb7naQw=
X-Riseup-User-ID: FA8526682E5BA832560C6B2C3547F461B2730FD5CE8B4F103F45E2C808F4A37B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id BB80E1207D0;
        Sat,  7 Sep 2019 09:04:41 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next] netfilter: nft_synproxy: add synproxy stateful object support
Date:   Sat,  7 Sep 2019 18:04:26 +0200
Message-Id: <20190907160425.7595-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Register a new synproxy stateful object type into the stateful object
infrastructure.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/uapi/linux/netfilter/nf_tables.h |   3 +-
 net/netfilter/nft_synproxy.c             | 143 +++++++++++++++++++----
 2 files changed, 124 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0ff932dadc8e..ed8881ad18ed 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1481,7 +1481,8 @@ enum nft_ct_expectation_attributes {
 #define NFT_OBJECT_CT_TIMEOUT	7
 #define NFT_OBJECT_SECMARK	8
 #define NFT_OBJECT_CT_EXPECT	9
-#define __NFT_OBJECT_MAX	10
+#define NFT_OBJECT_SYNPROXY	10
+#define __NFT_OBJECT_MAX	11
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index db4c23f5dfcb..e2c1fc608841 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -24,7 +24,7 @@ static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 				     const struct tcphdr *tcp,
 				     struct synproxy_net *snet,
 				     struct nf_synproxy_info *info,
-				     struct nft_synproxy *priv)
+				     const struct nft_synproxy *priv)
 {
 	this_cpu_inc(snet->stats->syn_received);
 	if (tcp->ece && tcp->cwr)
@@ -41,14 +41,13 @@ static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 				   NF_SYNPROXY_OPT_ECN);
 }
 
-static void nft_synproxy_eval_v4(const struct nft_expr *expr,
+static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt,
 				 const struct tcphdr *tcp,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nft_synproxy *priv = nft_expr_priv(expr);
 	struct nf_synproxy_info info = priv->info;
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
@@ -73,14 +72,13 @@ static void nft_synproxy_eval_v4(const struct nft_expr *expr,
 }
 
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
-static void nft_synproxy_eval_v6(const struct nft_expr *expr,
+static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt,
 				 const struct tcphdr *tcp,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nft_synproxy *priv = nft_expr_priv(expr);
 	struct nf_synproxy_info info = priv->info;
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
@@ -105,9 +103,9 @@ static void nft_synproxy_eval_v6(const struct nft_expr *expr,
 }
 #endif /* CONFIG_NF_TABLES_IPV6*/
 
-static void nft_synproxy_eval(const struct nft_expr *expr,
-			      struct nft_regs *regs,
-			      const struct nft_pktinfo *pkt)
+static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
 {
 	struct synproxy_options opts = {};
 	struct sk_buff *skb = pkt->skb;
@@ -140,23 +138,22 @@ static void nft_synproxy_eval(const struct nft_expr *expr,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		nft_synproxy_eval_v4(expr, regs, pkt, tcp, &_tcph, &opts);
+		nft_synproxy_eval_v4(priv, regs, pkt, tcp, &_tcph, &opts);
 		return;
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 	case htons(ETH_P_IPV6):
-		nft_synproxy_eval_v6(expr, regs, pkt, tcp, &_tcph, &opts);
+		nft_synproxy_eval_v6(priv, regs, pkt, tcp, &_tcph, &opts);
 		return;
 #endif
 	}
 	regs->verdict.code = NFT_BREAK;
 }
 
-static int nft_synproxy_init(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nlattr * const tb[])
+static int nft_synproxy_do_init(const struct nft_ctx *ctx,
+				const struct nlattr * const tb[],
+				struct nft_synproxy *priv)
 {
 	struct synproxy_net *snet = synproxy_pernet(ctx->net);
-	struct nft_synproxy *priv = nft_expr_priv(expr);
 	u32 flags;
 	int err;
 
@@ -206,8 +203,7 @@ static int nft_synproxy_init(const struct nft_ctx *ctx,
 	return err;
 }
 
-static void nft_synproxy_destroy(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr)
+static void nft_synproxy_do_destroy(const struct nft_ctx *ctx)
 {
 	struct synproxy_net *snet = synproxy_pernet(ctx->net);
 
@@ -229,10 +225,8 @@ static void nft_synproxy_destroy(const struct nft_ctx *ctx,
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_synproxy_do_dump(struct sk_buff *skb, struct nft_synproxy *priv)
 {
-	const struct nft_synproxy *priv = nft_expr_priv(expr);
-
 	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, htons(priv->info.mss)) ||
 	    nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->info.wscale) ||
 	    nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, htonl(priv->info.options)))
@@ -244,6 +238,15 @@ static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static void nft_synproxy_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	const struct nft_synproxy *priv = nft_expr_priv(expr);
+
+	nft_synproxy_do_eval(priv, regs, pkt);
+}
+
 static int nft_synproxy_validate(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nft_data **data)
@@ -252,6 +255,28 @@ static int nft_synproxy_validate(const struct nft_ctx *ctx,
 						    (1 << NF_INET_FORWARD));
 }
 
+static int nft_synproxy_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+
+	return nft_synproxy_do_init(ctx, tb, priv);
+}
+
+static void nft_synproxy_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	nft_synproxy_do_destroy(ctx);
+}
+
+static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+
+	return nft_synproxy_do_dump(skb, priv);
+}
+
 static struct nft_expr_type nft_synproxy_type;
 static const struct nft_expr_ops nft_synproxy_ops = {
 	.eval		= nft_synproxy_eval,
@@ -271,14 +296,89 @@ static struct nft_expr_type nft_synproxy_type __read_mostly = {
 	.maxattr	= NFTA_SYNPROXY_MAX,
 };
 
+static int nft_synproxy_obj_init(const struct nft_ctx *ctx,
+				 const struct nlattr * const tb[],
+				 struct nft_object *obj)
+{
+	struct nft_synproxy *priv = nft_obj_data(obj);
+
+	return nft_synproxy_do_init(ctx, tb, priv);
+}
+
+static void nft_synproxy_obj_destroy(const struct nft_ctx *ctx,
+				     struct nft_object *obj)
+{
+	nft_synproxy_do_destroy(ctx);
+}
+
+static int nft_synproxy_obj_dump(struct sk_buff *skb,
+				 struct nft_object *obj, bool reset)
+{
+	struct nft_synproxy *priv = nft_obj_data(obj);
+
+	return nft_synproxy_do_dump(skb, priv);
+}
+
+static void nft_synproxy_obj_eval(struct nft_object *obj,
+				  struct nft_regs *regs,
+				  const struct nft_pktinfo *pkt)
+{
+	const struct nft_synproxy *priv = nft_obj_data(obj);
+
+	nft_synproxy_do_eval(priv, regs, pkt);
+}
+
+static void nft_synproxy_obj_update(struct nft_object *obj,
+				    struct nft_object *newobj)
+{
+	struct nft_synproxy *newpriv = nft_obj_data(newobj);
+	struct nft_synproxy *priv = nft_obj_data(obj);
+
+	priv->info = newpriv->info;
+}
+
+static struct nft_object_type nft_synproxy_obj_type;
+static const struct nft_object_ops nft_synproxy_obj_ops = {
+	.type		= &nft_synproxy_obj_type,
+	.size		= sizeof(struct nft_synproxy),
+	.init		= nft_synproxy_obj_init,
+	.destroy	= nft_synproxy_obj_destroy,
+	.dump		= nft_synproxy_obj_dump,
+	.eval		= nft_synproxy_obj_eval,
+	.update		= nft_synproxy_obj_update,
+};
+
+static struct nft_object_type nft_synproxy_obj_type __read_mostly = {
+	.type		= NFT_OBJECT_SYNPROXY,
+	.ops		= &nft_synproxy_obj_ops,
+	.maxattr	= NFTA_SYNPROXY_MAX,
+	.policy		= nft_synproxy_policy,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nft_synproxy_module_init(void)
 {
-	return nft_register_expr(&nft_synproxy_type);
+	int err;
+
+	err = nft_register_obj(&nft_synproxy_obj_type);
+	if (err < 0)
+		return err;
+
+	err = nft_register_expr(&nft_synproxy_type);
+	if (err < 0)
+		goto err;
+
+	return 0;
+
+err:
+	nft_unregister_obj(&nft_synproxy_obj_type);
+	return err;
 }
 
 static void __exit nft_synproxy_module_exit(void)
 {
-	return nft_unregister_expr(&nft_synproxy_type);
+	nft_unregister_expr(&nft_synproxy_type);
+	nft_unregister_obj(&nft_synproxy_obj_type);
 }
 
 module_init(nft_synproxy_module_init);
@@ -287,3 +387,4 @@ module_exit(nft_synproxy_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
 MODULE_ALIAS_NFT_EXPR("synproxy");
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_SYNPROXY);
-- 
2.20.1

