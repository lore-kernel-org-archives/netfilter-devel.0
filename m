Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED43C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED2F2075D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 08:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfC0IUq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 04:20:46 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfC0IUq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 04:20:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1h93ng-0002bm-Fr; Wed, 27 Mar 2019 09:20:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/6] netfilter: nft_redir: add inet support
Date:   Wed, 27 Mar 2019 09:22:28 +0100
Message-Id: <20190327082229.29399-6-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190327082229.29399-1-fw@strlen.de>
References: <20190327082229.29399-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

allows to redirect both ipv4 and ipv6 with a single rule in an
inet nat table.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_redir.c | 61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index f8092926f704..14deb40dad75 100644
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
2.19.2

