Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF75C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55E8D20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgETSXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:23:48 -0400
Received: from correo.us.es ([193.147.175.20]:46610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726799AbgETSXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:23:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 95F73ED5BF
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88298DA70E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DD62DA703; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 921F9DA705
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:23:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7CF1E42EF42B
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] src: allow flowtable definitions with no devices
Date:   Wed, 20 May 2020 20:23:37 +0200
Message-Id: <20200520182337.31295-4-pablo@netfilter.org>
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

 # nft add flowtable x y { hook ingress priority 0\; }

The listing shows no devices:

 # nft list ruleset
 table ip x {
        flowtable y {
                hook ingress priority filter
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c  | 10 ++++++----
 src/rule.c | 14 ++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 759ae41ceb01..19f666416909 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1652,10 +1652,12 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
 	}
 
-	dev_array = nft_flowtable_dev_array(cmd);
-	nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
-				 dev_array, 0);
-	nft_flowtable_dev_array_free(dev_array);
+	if (cmd->flowtable->dev_expr) {
+		dev_array = nft_flowtable_dev_array(cmd);
+		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
+					 dev_array, 0);
+		nft_flowtable_dev_array_free(dev_array);
+	}
 
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FLAGS,
 				cmd->flowtable->flags);
diff --git a/src/rule.c b/src/rule.c
index 1f56faeb5c3c..21a52157391d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2272,13 +2272,15 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 			   flowtable->hook.num, flowtable->priority.expr),
 		  opts->stmt_separator);
 
-	nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
-	for (i = 0; i < flowtable->dev_array_len; i++) {
-		nft_print(octx, "%s", flowtable->dev_array[i]);
-		if (i + 1 != flowtable->dev_array_len)
-			nft_print(octx, ", ");
+	if (flowtable->dev_array_len > 0) {
+		nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
+		for (i = 0; i < flowtable->dev_array_len; i++) {
+			nft_print(octx, "%s", flowtable->dev_array[i]);
+			if (i + 1 != flowtable->dev_array_len)
+				nft_print(octx, ", ");
+		}
+		nft_print(octx, " }%s", opts->stmt_separator);
 	}
-	nft_print(octx, " }%s", opts->stmt_separator);
 
 	if (flowtable->flags & NFT_FLOWTABLE_COUNTER)
 		nft_print(octx, "%s%scounter%s", opts->tab, opts->tab,
-- 
2.20.1

