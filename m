Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A52FC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07ABF20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgETSXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:23:48 -0400
Received: from correo.us.es ([193.147.175.20]:46608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbgETSXr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:23:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35B1FDA722
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27304DA703
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 185AADA70F; Wed, 20 May 2020 20:23:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2571DDA711
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 May 2020 20:23:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 11CB342EF42A
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 20:23:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] src: delete devices to an existing flowtable
Date:   Wed, 20 May 2020 20:23:36 +0200
Message-Id: <20200520182337.31295-3-pablo@netfilter.org>
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

This patch allows you to remove a device to an existing flowtable:

 # nft delete flowtable x y { devices = { eth0 } \;  }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c          | 11 +++++++++++
 src/parser_bison.y |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 8f8fcc2c7ae0..759ae41ceb01 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1682,6 +1682,7 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_flowtable *flo;
+	const char **dev_array;
 	struct nlmsghdr *nlh;
 
 	flo = nftnl_flowtable_alloc();
@@ -1691,6 +1692,16 @@ int mnl_nft_flowtable_del(struct netlink_ctx *ctx, struct cmd *cmd)
 	nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_FAMILY,
 				cmd->handle.family);
 
+	if (cmd->flowtable && cmd->flowtable->dev_expr) {
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_HOOKNUM, 0);
+		nftnl_flowtable_set_u32(flo, NFTNL_FLOWTABLE_PRIO, 0);
+
+		dev_array = nft_flowtable_dev_array(cmd);
+		nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
+					 dev_array, 0);
+		nft_flowtable_dev_array_free(dev_array);
+	}
+
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_DELFLOWTABLE, cmd->handle.family,
 				    0, ctx->seqnum);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8e937ca305d1..461d9bf24d95 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1179,6 +1179,13 @@ delete_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, NULL);
 			}
+			|	FLOWTABLE	flowtable_spec	flowtable_block_alloc
+						'{'	flowtable_block	'}'
+			{
+				$5->location = @5;
+				handle_merge(&$3->handle, &$2);
+				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_FLOWTABLE, &$2, &@$, $5);
+			}
 			|	COUNTER		obj_spec
 			{
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_COUNTER, &$2, &@$, NULL);
-- 
2.20.1

