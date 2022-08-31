Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF510ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 14:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiHaO40 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 10:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiHaO4V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 10:56:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40992D1E0D
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 07:55:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] rule, set_elem: remove trailing \n in userdata snprintf
Date:   Wed, 31 Aug 2022 16:55:47 +0200
Message-Id: <20220831145547.2854-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

212479ad2c92 ("rule, set_elem: fix printing of user data") uncovered
another an extra line break in the userdata printing, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c     | 2 +-
 src/set_elem.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index a1a64bd2837d..a52012b2177b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -628,7 +628,7 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf + offset, remain, " }\n");
+		ret = snprintf(buf + offset, remain, " }");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	}
diff --git a/src/set_elem.c b/src/set_elem.c
index 1c8720dc7c57..884faff432a9 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -747,7 +747,7 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 		}
 
-		ret = snprintf(buf + offset, remain, " }\n");
+		ret = snprintf(buf + offset, remain, " }");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-- 
2.30.2

