Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1064DC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCFE52054F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387798AbfIMLbS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:31:18 -0400
Received: from correo.us.es ([193.147.175.20]:42540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387687AbfIMLbS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 703744FFE28
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AF87A7D66
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4ED49A7D63; Fri, 13 Sep 2019 13:31:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ED13A7E2C;
        Fri, 13 Sep 2019 13:31:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 127E642EE38F;
        Fri, 13 Sep 2019 13:31:12 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/27] netfilter: nf_tables_offload: avoid excessive stack usage
Date:   Fri, 13 Sep 2019 13:30:37 +0200
Message-Id: <20190913113102.15776-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The nft_offload_ctx structure is much too large to put on the
stack:

net/netfilter/nf_tables_offload.c:31:23: error: stack frame size of 1200 bytes in function 'nft_flow_rule_create' [-Werror,-Wframe-larger-than=]

Use dynamic allocation here, as we do elsewhere in the same
function.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 3c2725ade61b..fabe2997188b 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -30,11 +30,7 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 
 struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 {
-	struct nft_offload_ctx ctx = {
-		.dep	= {
-			.type	= NFT_OFFLOAD_DEP_UNSPEC,
-		},
-	};
+	struct nft_offload_ctx *ctx;
 	struct nft_flow_rule *flow;
 	int num_actions = 0, err;
 	struct nft_expr *expr;
@@ -52,21 +48,31 @@ struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 		return ERR_PTR(-ENOMEM);
 
 	expr = nft_expr_first(rule);
+
+	ctx = kzalloc(sizeof(struct nft_offload_ctx), GFP_KERNEL);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
+
 	while (expr->ops && expr != nft_expr_last(rule)) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
 			goto err_out;
 		}
-		err = expr->ops->offload(&ctx, flow, expr);
+		err = expr->ops->offload(ctx, flow, expr);
 		if (err < 0)
 			goto err_out;
 
 		expr = nft_expr_next(expr);
 	}
-	flow->proto = ctx.dep.l3num;
+	flow->proto = ctx->dep.l3num;
+	kfree(ctx);
 
 	return flow;
 err_out:
+	kfree(ctx);
 	nft_flow_rule_destroy(flow);
 
 	return ERR_PTR(err);
-- 
2.11.0

