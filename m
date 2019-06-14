Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164DAC31E44
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 12:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F57208CA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 12:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfFNMRH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 08:17:07 -0400
Received: from mail.us.es ([193.147.175.20]:40602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727378AbfFNMRH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 08:17:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF77D120825
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 14:17:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2EC0DA703
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2019 14:17:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B866CDA714; Fri, 14 Jun 2019 14:17:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F6F8DA70F;
        Fri, 14 Jun 2019 14:17:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Jun 2019 14:17:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7498940705C3;
        Fri, 14 Jun 2019 14:17:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft] cache: do not populate the cache in case of flush ruleset command
Date:   Fri, 14 Jun 2019 14:16:59 +0200
Message-Id: <20190614121659.29041-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__CMD_FLUSH_RULESET is a dummy definition that used to skip the netlink
dump to populate the cache. This patch is a workaround until we have a
better infrastructure to track the state of the cache objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 1 +
 src/cache.c    | 3 +++
 src/rule.c     | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index dd9df9ec6dd8..b41825d000d6 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -462,6 +462,7 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
+	__CMD_FLUSH_RULESET,
 };
 
 /**
diff --git a/src/cache.c b/src/cache.c
index 532ef425906a..d7153f6f6b8f 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -54,6 +54,9 @@ static unsigned int evaluate_cache_flush(struct cmd *cmd)
 	unsigned int completeness = CMD_INVALID;
 
 	switch (cmd->obj) {
+	case CMD_OBJ_RULESET:
+		completeness = __CMD_FLUSH_RULESET;
+		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 	case CMD_OBJ_METER:
diff --git a/src/rule.c b/src/rule.c
index 8de5aa62b94f..3dba8b991e12 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -155,6 +155,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
 	struct set *set;
 	int ret;
 
+	if (cmd == __CMD_FLUSH_RULESET)
+		return 0;
+
 	list_for_each_entry(table, &ctx->nft->cache.list, list) {
 		ret = netlink_list_sets(ctx, &table->handle);
 		list_splice_tail_init(&ctx->list, &table->sets);
-- 
2.11.0

