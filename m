Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6068C10F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C20F22075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfDORBW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:01:22 -0400
Received: from mail.us.es ([193.147.175.20]:50438 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfDORAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0999D1C4430
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE4C8DA711
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED998DA715; Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEE4CDA711;
        Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B3BB84265A31;
        Mon, 15 Apr 2019 19:00:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/22] netfilter: nft_redir: add inet support
Date:   Mon, 15 Apr 2019 19:00:17 +0200
Message-Id: <20190415170028.3470-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

allows to redirect both ipv4 and ipv6 with a single rule in an
inet nat table.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_redir.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 02f4b4a6f887..da74fdc4a684 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -202,6 +202,55 @@ static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
 };
 #endif
 
+#ifdef CONFIG_NF_TABLES_INET
+static void nft_redir_inet_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	switch (nft_pf(pkt)) {
+	case NFPROTO_IPV4:
+		return nft_redir_ipv4_eval(expr, regs, pkt);
+	case NFPROTO_IPV6:
+		return nft_redir_ipv6_eval(expr, regs, pkt);
+	}
+
+	WARN_ON_ONCE(1);
+}
+
+static void
+nft_redir_inet_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	nf_ct_netns_put(ctx->net, NFPROTO_INET);
+}
+
+static struct nft_expr_type nft_redir_inet_type;
+static const struct nft_expr_ops nft_redir_inet_ops = {
+	.type		= &nft_redir_inet_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_redir)),
+	.eval		= nft_redir_inet_eval,
+	.init		= nft_redir_init,
+	.destroy	= nft_redir_inet_destroy,
+	.dump		= nft_redir_dump,
+	.validate	= nft_redir_validate,
+};
+
+static struct nft_expr_type nft_redir_inet_type __read_mostly = {
+	.family		= NFPROTO_INET,
+	.name		= "redir",
+	.ops		= &nft_redir_inet_ops,
+	.policy		= nft_redir_policy,
+	.maxattr	= NFTA_MASQ_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_redir_module_init_inet(void)
+{
+	return nft_register_expr(&nft_redir_inet_type);
+}
+#else
+static inline int nft_redir_module_init_inet(void) { return 0; }
+#endif
+
 static int __init nft_redir_module_init(void)
 {
 	int ret = nft_register_expr(&nft_redir_ipv4_type);
@@ -217,6 +266,15 @@ static int __init nft_redir_module_init(void)
 	}
 #endif
 
+	ret = nft_redir_module_init_inet();
+	if (ret < 0) {
+		nft_unregister_expr(&nft_redir_ipv4_type);
+#ifdef CONFIG_NF_TABLES_IPV6
+		nft_unregister_expr(&nft_redir_ipv6_type);
+#endif
+		return ret;
+	}
+
 	return ret;
 }
 
@@ -226,6 +284,9 @@ static void __exit nft_redir_module_exit(void)
 #ifdef CONFIG_NF_TABLES_IPV6
 	nft_unregister_expr(&nft_redir_ipv6_type);
 #endif
+#ifdef CONFIG_NF_TABLES_INET
+	nft_unregister_expr(&nft_redir_inet_type);
+#endif
 }
 
 module_init(nft_redir_module_init);
-- 
2.11.0

