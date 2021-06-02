Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EEFC47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FDB613B1
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhFBP0O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhFBP0N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A0C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:29 -0700 (PDT)
Received: from localhost ([::1]:43106 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjM-0007PK-6J; Wed, 02 Jun 2021 17:24:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 9/9] extensions: libxt_string: Avoid buffer size warning for strncpy()
Date:   Wed,  2 Jun 2021 17:24:03 +0200
Message-Id: <20210602152403.5689-10-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the target buffer does not need to be null-terminated, one may simply
use memcpy() and thereby avoid any compiler warnings.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 7c6366cbbf1b3..739a8e7fd66b6 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -81,7 +81,7 @@ parse_string(const char *s, struct xt_string_info *info)
 {	
 	/* xt_string does not need \0 at the end of the pattern */
 	if (strlen(s) <= XT_STRING_MAX_PATTERN_SIZE) {
-		strncpy(info->pattern, s, XT_STRING_MAX_PATTERN_SIZE);
+		memcpy(info->pattern, s, XT_STRING_MAX_PATTERN_SIZE);
 		info->patlen = strnlen(s, XT_STRING_MAX_PATTERN_SIZE);
 		return;
 	}
-- 
2.31.1

