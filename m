Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0754BC432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 15:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E59206D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 15:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfKNPDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 10:03:10 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52898 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfKNPDK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 10:03:10 -0500
Received: from localhost ([::1]:37756 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iVGeK-0004ja-KY; Thu, 14 Nov 2019 16:03:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] cache: Reduce caching for get command
Date:   Thu, 14 Nov 2019 16:03:05 +0100
Message-Id: <20191114150305.18704-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a function to distinguish which command object was given and
request only the necessary bits to have sets and their elements
available for 'get element' command.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index a778650ac133a..0c28a28d3b554 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -63,6 +63,21 @@ static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 	return flags;
 }
 
+static unsigned int evaluate_cache_get(struct cmd *cmd, unsigned int flags)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_SETELEM:
+		flags |= NFT_CACHE_TABLE |
+			 NFT_CACHE_SET |
+			 NFT_CACHE_SETELEM;
+		break;
+	default:
+		break;
+	}
+
+	return flags;
+}
+
 static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 {
 	switch (cmd->obj) {
@@ -121,6 +136,8 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 			flags = evaluate_cache_del(cmd, flags);
 			break;
 		case CMD_GET:
+			flags = evaluate_cache_get(cmd, flags);
+			break;
 		case CMD_LIST:
 		case CMD_RESET:
 		case CMD_EXPORT:
-- 
2.24.0

