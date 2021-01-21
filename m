Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D566C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B23E239A4
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbhAUN47 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729707AbhAUN4J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 08:56:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36108C0613D3
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 05:55:29 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2aQp-00047P-SJ; Thu, 21 Jan 2021 14:55:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/4] json: ct: add missing rule
Date:   Thu, 21 Jan 2021 14:55:09 +0100
Message-Id: <20210121135510.14941-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121135510.14941-1-fw@strlen.de>
References: <20210121135510.14941-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ERROR: did not find JSON equivalent for rule 'meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 }'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/ct.t.json | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index 881cd4c942c1..d942649a550f 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -216,3 +216,33 @@
     }
 ]
 
+# meta mark set ct original ip daddr map { 1.1.1.1 : 0x00000011 }
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "1.1.1.1",
+                                17
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "ct": {
+                            "dir": "original",
+                            "key": "ip daddr"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
-- 
2.26.2

