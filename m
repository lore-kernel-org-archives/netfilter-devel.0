Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAFAC10F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB80B2075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfDORBV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:01:21 -0400
Received: from mail.us.es ([193.147.175.20]:50504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfDORAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 83BD01C4442
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7484FDA715
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 72B0DDA70D; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56EC9DA701;
        Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 26D3B4265A31;
        Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/22] netfilter: nft_masq: add inet support
Date:   Mon, 15 Apr 2019 19:00:16 +0200
Message-Id: <20190415170028.3470-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows use of a single masquerade rule in nat inet family
to handle both ipv4 and ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_masq.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index bee156eaa400..35a1794acf4c 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -218,6 +218,61 @@ static inline int nft_masq_module_init_ipv6(void) { return 0; }
 static inline void nft_masq_module_exit_ipv6(void) {}
 #endif
 
+#ifdef CONFIG_NF_TABLES_INET
+static void nft_masq_inet_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		return nft_masq_ipv4_eval(expr, regs, pkt);
+	case NFPROTO_IPV6:
+		return nft_masq_ipv6_eval(expr, regs, pkt);
+	}
+
+	WARN_ON_ONCE(1);
+}
+
+static void
+nft_masq_inet_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_INET);
+}
+
+static struct nft_expr_type nft_masq_inet_type;
+static const struct nft_expr_ops nft_masq_inet_ops = {
+	.type		= &nft_masq_inet_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_masq)),
+	.eval		= nft_masq_inet_eval,
+	.init		= nft_masq_init,
+	.destroy	= nft_masq_inet_destroy,
+	.dump		= nft_masq_dump,
+	.validate	= nft_masq_validate,
+};
+
+static struct nft_expr_type nft_masq_inet_type __read_mostly = {
+	.family		= NFPROTO_INET,
+	.name		= "masq",
+	.ops		= &nft_masq_inet_ops,
+	.policy		= nft_masq_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_masq_module_init_inet(void)
+{
+	return nft_register_expr(&nft_masq_inet_type);
+}
+
+static void nft_masq_module_exit_inet(void)
+{
+	nft_unregister_expr(&nft_masq_inet_type);
+}
+#else
+static inline int nft_masq_module_init_inet(void) { return 0; }
+static inline void nft_masq_module_exit_inet(void) {}
+#endif
+
 static int __init nft_masq_module_init(void)
 {
 	int ret;
@@ -226,8 +281,15 @@ static int __init nft_masq_module_init(void)
 	if (ret < 0)
 		return ret;
 
+	ret = nft_masq_module_init_inet();
+	if (ret < 0) {
+		nft_masq_module_exit_ipv6();
+		return ret;
+	}
+
 	ret = nft_register_expr(&nft_masq_ipv4_type);
 	if (ret < 0) {
+		nft_masq_module_exit_inet();
 		nft_masq_module_exit_ipv6();
 		return ret;
 	}
@@ -235,6 +297,7 @@ static int __init nft_masq_module_init(void)
 	ret = nf_nat_masquerade_ipv4_register_notifier();
 	if (ret < 0) {
 		nft_masq_module_exit_ipv6();
+		nft_masq_module_exit_inet();
 		nft_unregister_expr(&nft_masq_ipv4_type);
 		return ret;
 	}
@@ -245,6 +308,7 @@ static int __init nft_masq_module_init(void)
 static void __exit nft_masq_module_exit(void)
 {
 	nft_masq_module_exit_ipv6();
+	nft_masq_module_exit_inet();
 	nft_unregister_expr(&nft_masq_ipv4_type);
 	nf_nat_masquerade_ipv4_unregister_notifier();
 }
-- 
2.11.0

