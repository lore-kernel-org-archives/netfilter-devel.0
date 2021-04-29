Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ED9C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D969F613DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 23:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhD2Xn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:43:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59536 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhD2Xnx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:43:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E52B564145
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 01:42:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 12/18] cache: missing table cache for several policy objects
Date:   Fri, 30 Apr 2021 01:42:49 +0200
Message-Id: <20210429234255.16840-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210429234255.16840-1-pablo@netfilter.org>
References: <20210429234255.16840-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Populate the cache with tables for several policy objects types.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/cache.c b/src/cache.c
index 03b781bb4834..d1f8e8392b58 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -26,6 +26,10 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_LIMIT:
 	case CMD_OBJ_SECMARK:
+	case CMD_OBJ_CT_HELPER:
+	case CMD_OBJ_CT_TIMEOUT:
+	case CMD_OBJ_CT_EXPECT:
+	case CMD_OBJ_SYNPROXY:
 	case CMD_OBJ_FLOWTABLE:
 		flags |= NFT_CACHE_TABLE;
 		break;
-- 
2.20.1

