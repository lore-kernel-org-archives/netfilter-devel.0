Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9436EC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8122E20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgETSXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:23:48 -0400
Received: from correo.us.es ([193.147.175.20]:46604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgETSXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:23:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A479CED5C0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95C07DA703
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B006DA70F; Wed, 20 May 2020 20:23:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0C2ADA703
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:23:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8D5CD42EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] src: add devices to an existing flowtable
Date:   Wed, 20 May 2020 20:23:35 +0200
Message-Id: <20200520182337.31295-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520182337.31295-1-pablo@netfilter.org>
References: <20200520182337.31295-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to add new devices to an existing flowtables.

 # nft add flowtable x y { devices = { eth0 } \; }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 21 ++++++++++-----------
 src/mnl.c      | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 506f2c6a257e..9b7232d9148c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3624,17 +3624,16 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	if (table == NULL)
 		return table_not_found(ctx);
 
-	ft->hook.num = str2hooknum(NFPROTO_NETDEV, ft->hook.name);
-	if (ft->hook.num == NF_INET_NUMHOOKS)
-		return chain_error(ctx, ft, "invalid hook %s", ft->hook.name);
-
-	if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hook.num))
-		return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
-					   "invalid priority expression %s.",
-					   expr_name(ft->priority.expr));
-
-	if (!ft->dev_expr)
-		return chain_error(ctx, ft, "Unbound flowtable not allowed (must specify devices)");
+	if (ft->hook.name) {
+		ft->hook.num = str2hooknum(NFPROTO_NETDEV, ft->hook.name);
+		if (ft->hook.num == NF_INET_NUMHOOKS)
+			return chain_error(ctx, ft, "invalid hook %s",
+					   ft->hook.name);
+		if (!evaluate_priority(ctx, &ft->priority, NFPROTO_NETDEV, ft->hook.num))
+			return __stmt_binary_error(ctx, &ft->priority.loc, NULL,
+						   "invalid priority expression %s.",
+						   expr_name(ft->priority.expr));
+	}
 
 	return 0;
 }
diff --git a/src/mnl.c b/src/mnl.c
index 2890014ebf3d..8f8fcc2c7ae0 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1640,11 +1640,17 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
-	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
-				cmd->flowtable->hook.num);
-	mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
-			BYTEORDER_HOST_ENDIAN, sizeof(int));
-	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
+
+	if (cmd->flowtable->hook.name) {
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM,
+					cmd->flowtable->hook.num);
+		mpz_export_data(&priority, cmd->flowtable->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
+	} else {
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM, 0);
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
+	}
 
 	dev_array = nft_flowtable_dev_array(cmd);
 	nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
-- 
2.20.1

