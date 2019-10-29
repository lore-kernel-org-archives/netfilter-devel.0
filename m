Return-Path: <SRS0=pwfE=YW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B0ACA9EAE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 12:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40E721479
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 12:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfJ2Myb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:54:31 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42260 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729253AbfJ2Myb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Oct 2019 08:54:31 -0400
Received: from localhost ([::1]:55350 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPR13-0005dT-Bn; Tue, 29 Oct 2019 13:54:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] mnl: Replace use of untyped nftnl data setters
Date:   Tue, 29 Oct 2019 13:54:20 +0100
Message-Id: <20191029125420.26178-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Setting strings won't make a difference, but passing data length to
*_set_data() functions allows for catching accidental changes on either
side.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 75ab07b045aa5..5b0569f37b27e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -695,7 +695,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		memory_allocation_error();
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
-	nftnl_table_set(nlt, NFTNL_TABLE_NAME, cmd->handle.table.name);
+	nftnl_table_set_str(nlt, NFTNL_TABLE_NAME, cmd->handle.table.name);
 	if (cmd->table)
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
 	else
@@ -724,7 +724,8 @@ int mnl_nft_table_del(struct netlink_ctx *ctx, const struct cmd *cmd)
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
 	if (cmd->handle.table.name)
-		nftnl_table_set(nlt, NFTNL_TABLE_NAME, cmd->handle.table.name);
+		nftnl_table_set_str(nlt, NFTNL_TABLE_NAME,
+				    cmd->handle.table.name);
 	else if (cmd->handle.handle.id)
 		nftnl_table_set_u64(nlt, NFTNL_TABLE_HANDLE,
 				    cmd->handle.handle.id);
@@ -1016,8 +1017,9 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		if (obj->ct_timeout.l3proto)
 			nftnl_obj_set_u16(nlo, NFTNL_OBJ_CT_TIMEOUT_L3PROTO,
 					  obj->ct_timeout.l3proto);
-		nftnl_obj_set(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY,
-			      obj->ct_timeout.timeout);
+		nftnl_obj_set_data(nlo, NFTNL_OBJ_CT_TIMEOUT_ARRAY,
+				   obj->ct_timeout.timeout,
+				   sizeof(obj->ct_timeout.timeout));
 		break;
 	case NFT_OBJECT_CT_EXPECT:
 		if (obj->ct_expect.l3proto)
@@ -1418,7 +1420,8 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		dev_array[i++] = expr->identifier;
 
 	dev_array[i] = NULL;
-	nftnl_flowtable_set(flo, NFTNL_FLOWTABLE_DEVICES, dev_array);
+	nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
+				 dev_array, sizeof(dev_array));
 
 	netlink_dump_flowtable(flo, ctx);
 
-- 
2.23.0

