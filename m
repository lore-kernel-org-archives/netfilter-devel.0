Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB1AC001DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 17:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjG1Rnd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjG1Rnb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 13:43:31 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6EF2D60
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 10:43:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qPRUt-0004E9-Ur; Fri, 28 Jul 2023 19:43:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     danw@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: allow src/dstnat prios in input and output
Date:   Fri, 28 Jul 2023 19:43:16 +0200
Message-ID: <20230728174320.127518-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dan Winship says:

The "dnat" command is usable from either "prerouting" or "output", but the
"dstnat" priority is only usable from "prerouting". (Likewise, "snat" is usable
from either "postrouting" or "input", but "srcnat" is only usable from
"postrouting".)

No need to restrict those priorities to pre/postrouting.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1694
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 04fbbaaddc53..08841902fef4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -927,7 +927,8 @@ static bool std_prio_family_hook_compat(int prio, int family, int hook)
 		case NFPROTO_INET:
 		case NFPROTO_IPV4:
 		case NFPROTO_IPV6:
-			if (hook == NF_INET_PRE_ROUTING)
+			if (hook == NF_INET_PRE_ROUTING ||
+			    hook == NF_INET_LOCAL_OUT)
 				return true;
 		}
 		break;
@@ -936,7 +937,8 @@ static bool std_prio_family_hook_compat(int prio, int family, int hook)
 		case NFPROTO_INET:
 		case NFPROTO_IPV4:
 		case NFPROTO_IPV6:
-			if (hook == NF_INET_POST_ROUTING)
+			if (hook == NF_INET_LOCAL_IN ||
+			    hook == NF_INET_POST_ROUTING)
 				return true;
 		}
 	}
-- 
2.41.0

