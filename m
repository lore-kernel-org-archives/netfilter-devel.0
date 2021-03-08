Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64D0C433E9
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2F09651DD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbhCHOLv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhCHOLf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120BAC06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:11:35 -0800 (PST)
Received: from localhost ([::1]:53486 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJGbd-0003Ri-LY; Mon, 08 Mar 2021 15:11:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/5] rule: Avoid printing trailing spaces
Date:   Mon,  8 Mar 2021 15:11:18 +0100
Message-Id: <20210308141119.17809-5-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308141119.17809-1-phil@nwl.cc>
References: <20210308141119.17809-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce 'sep' variable to track whether something was printed already.
While being at it, introduce PRIu64 for 'handle' and 'position'
attributes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 480afc8ffc1b8..e82cf73e9bbe5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -551,44 +551,53 @@ static int nftnl_rule_snprintf_default(char *buf, size_t size,
 {
 	struct nftnl_expr *expr;
 	int ret, remain = size, offset = 0, i;
+	const char *sep = "";
 
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
-		ret = snprintf(buf + offset, remain, "%s ",
+		ret = snprintf(buf + offset, remain, "%s%s", sep,
 			       nftnl_family2str(r->family));
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_TABLE)) {
-		ret = snprintf(buf + offset, remain, "%s ",
+		ret = snprintf(buf + offset, remain, "%s%s", sep,
 			       r->table);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_CHAIN)) {
-		ret = snprintf(buf + offset, remain, "%s ",
+		ret = snprintf(buf + offset, remain, "%s%s", sep,
 			       r->chain);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 	if (r->flags & (1 << NFTNL_RULE_HANDLE)) {
-		ret = snprintf(buf + offset, remain, "%llu ",
-			       (unsigned long long)r->handle);
+		ret = snprintf(buf + offset, remain, "%s%" PRIu64, sep,
+			       r->handle);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_POSITION)) {
-		ret = snprintf(buf + offset, remain, "%llu ",
-			       (unsigned long long)r->position);
+		ret = snprintf(buf + offset, remain, "%s%" PRIu64, sep,
+			       r->position);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_ID)) {
-		ret = snprintf(buf + offset, remain, "%u ", r->id);
+		ret = snprintf(buf + offset, remain, "%s%u", sep, r->id);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	if (r->flags & (1 << NFTNL_RULE_POSITION_ID)) {
-		ret = snprintf(buf + offset, remain, "%u ", r->position_id);
+		ret = snprintf(buf + offset, remain, "%s%u", sep,
+			       r->position_id);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	ret = snprintf(buf + offset, remain, "\n");
-- 
2.30.1

