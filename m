Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCEBC433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4696864F42
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCBXfC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:35:02 -0500
Received: from correo.us.es ([193.147.175.20]:40246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350055AbhCBLuG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 06:50:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E794381400
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D40D6DA78E
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8F18DA78A; Tue,  2 Mar 2021 12:48:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C05ADA792
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Mar 2021 12:48:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5898142DF561
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 12:48:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cache: memleak list of chain
Date:   Tue,  2 Mar 2021 12:48:47 +0100
Message-Id: <20210302114847.3865-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210302114847.3865-1-pablo@netfilter.org>
References: <20210302114847.3865-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release chain list from the error path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 367c5c8be952..cf4d2cbef27b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -170,32 +170,42 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 		if (flags & NFT_CACHE_SET_BIT) {
 			ret = netlink_list_sets(ctx, &table->handle);
 			list_splice_tail_init(&ctx->list, &table->sets);
-			if (ret < 0)
-				return -1;
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
 		}
 		if (flags & NFT_CACHE_SETELEM_BIT) {
 			list_for_each_entry(set, &table->sets, list) {
 				ret = netlink_list_setelems(ctx, &set->handle,
 							    set);
-				if (ret < 0)
-					return -1;
+				if (ret < 0) {
+					ret = -1;
+					goto cache_fails;
+				}
 			}
 		}
 		if (flags & NFT_CACHE_CHAIN_BIT) {
 			ret = chain_cache_init(ctx, table, chain_list);
-			if (ret < 0)
-				return -1;
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
 			ret = netlink_list_flowtables(ctx, &table->handle);
-			if (ret < 0)
-				return -1;
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
 			list_splice_tail_init(&ctx->list, &table->flowtables);
 		}
 		if (flags & NFT_CACHE_OBJECT_BIT) {
 			ret = netlink_list_objs(ctx, &table->handle);
-			if (ret < 0)
-				return -1;
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
 			list_splice_tail_init(&ctx->list, &table->objs);
 		}
 
@@ -208,15 +218,18 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 							rule->handle.chain.name);
 				list_move_tail(&rule->list, &chain->rules);
 			}
-			if (ret < 0)
-				return -1;
+			if (ret < 0) {
+				ret = -1;
+				goto cache_fails;
+			}
 		}
 	}
 
+cache_fails:
 	if (flags & NFT_CACHE_CHAIN_BIT)
 		nftnl_chain_list_free(chain_list);
 
-	return 0;
+	return ret;
 }
 
 static int cache_init(struct netlink_ctx *ctx, unsigned int flags)
-- 
2.20.1

