Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBB7C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73AEE239A4
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbhAUN5S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729690AbhAUN4F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 08:56:05 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B4C0613C1
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 05:55:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2aQl-00047H-M7; Thu, 21 Jan 2021 14:55:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/4] json: limit: set default burst to 5
Date:   Thu, 21 Jan 2021 14:55:08 +0100
Message-Id: <20210121135510.14941-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121135510.14941-1-fw@strlen.de>
References: <20210121135510.14941-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The tests fail because json printing omits a burst of 5 and
the parser treats that as 'burst 0'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index f0486b77a225..2d132caf529c 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1784,7 +1784,7 @@ static struct stmt *json_parse_limit_stmt(struct json_ctx *ctx,
 					  const char *key, json_t *value)
 {
 	struct stmt *stmt;
-	uint64_t rate, burst = 0;
+	uint64_t rate, burst = 5;
 	const char *rate_unit = "packets", *time, *burst_unit = "bytes";
 	int inv = 0;
 
-- 
2.26.2

