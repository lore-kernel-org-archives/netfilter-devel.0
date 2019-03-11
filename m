Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CABCC10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648F82087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 22:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfCKWur (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:50:47 -0400
Received: from mail.us.es ([193.147.175.20]:34612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfCKWur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 18:50:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73C4D209925
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61424F731A
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6062DC21AF; Mon, 11 Mar 2019 23:50:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ED92DA84C;
        Mon, 11 Mar 2019 23:50:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 23:50:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5FB614265A2F;
        Mon, 11 Mar 2019 23:50:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: nf_tables: use-after-free in dynamic operations
Date:   Mon, 11 Mar 2019 23:50:34 +0100
Message-Id: <20190311225035.21250-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190311225035.21250-1-pablo@netfilter.org>
References: <20190311225035.21250-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Smatch reports:

       net/netfilter/nf_tables_api.c:2167 nf_tables_expr_destroy()
        error: dereferencing freed memory 'expr->ops'

net/netfilter/nf_tables_api.c
    2162 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
    2163                                   struct nft_expr *expr)
    2164 {
    2165        if (expr->ops->destroy)
    2166                expr->ops->destroy(ctx, expr);
                                                ^^^^
--> 2167        module_put(expr->ops->type->owner);
                           ^^^^^^^^^
    2168 }

Smatch says there are three functions which free expr->ops.

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca09ef037ca5..9d8f51dfc593 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2162,9 +2162,11 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 				   struct nft_expr *expr)
 {
+	const struct nft_expr_type *type = expr->ops->type;
+
 	if (expr->ops->destroy)
 		expr->ops->destroy(ctx, expr);
-	module_put(expr->ops->type->owner);
+	module_put(type->owner);
 }
 
 struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
-- 
2.11.0

