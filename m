Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D0DCA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451D620867
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfJZLZh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:25:37 -0400
Received: from correo.us.es ([193.147.175.20]:42904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfJZLZh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:25:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 67313DA73F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:25:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 538BCB7FF6
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:25:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 48A1BCA0F3; Sat, 26 Oct 2019 13:25:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57770DA4CA
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:25:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:25:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 31DB442EE38F
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:25:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: remove artifical cap on 8 devices per flowtable
Date:   Sat, 26 Oct 2019 13:25:30 +0200
Message-Id: <20191026112530.6140-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Currently assuming a maximum of 8 devices, remove this artificial cap.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 492381da7417..960c55746980 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1411,11 +1411,11 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			  unsigned int flags)
 {
 	struct nftnl_flowtable *flo;
-	const char *dev_array[8];
+	const char **dev_array;
 	struct nlmsghdr *nlh;
+	int i = 0, len = 1;
 	struct expr *expr;
 	int priority;
-	int i = 0;
 
 	flo = nftnl_flowtable_alloc();
 	if (!flo)
@@ -1434,10 +1434,15 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, priority);
 
 	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
+		len++;
+
+	dev_array = calloc(len, sizeof(char *));
+	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
 		dev_array[i++] = expr->identifier;
 
 	dev_array[i] = NULL;
 	nftnl_flowtable_set(flo, NFTNL_FLOWTABLE_DEVICES, dev_array);
+	free(dev_array);
 
 	netlink_dump_flowtable(flo, ctx);
 
-- 
2.11.0

