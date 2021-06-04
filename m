Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF52C4708F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AE0F6141C
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhFDLmk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhFDLmk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31286C06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 04:40:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp8C4-0004vB-Ms; Fri, 04 Jun 2021 13:40:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/4] tests: ct: prefer normal cmp
Date:   Fri,  4 Jun 2021 13:40:40 +0200
Message-Id: <20210604114043.4153-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210604114043.4153-1-fw@strlen.de>
References: <20210604114043.4153-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Followup patch will replace the { 1.2.3.4 } with single
cmp, so this will cause an error when the netlink dump gets
compared.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/ct.t         | 2 +-
 tests/py/inet/ct.t.json    | 8 ++------
 tests/py/inet/ct.t.payload | 7 ++-----
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/tests/py/inet/ct.t b/tests/py/inet/ct.t
index 3d0dffad2819..5312b328aa91 100644
--- a/tests/py/inet/ct.t
+++ b/tests/py/inet/ct.t
@@ -6,7 +6,7 @@
 meta nfproto ipv4 ct original saddr 1.2.3.4;ok;ct original ip saddr 1.2.3.4
 ct original ip6 saddr ::1;ok
 
-ct original ip daddr {1.2.3.4} accept;ok
+ct original ip daddr 1.2.3.4 accept;ok
 
 # missing protocol context
 ct original saddr ::1;fail
diff --git a/tests/py/inet/ct.t.json b/tests/py/inet/ct.t.json
index e7f928ca10e4..223ac9e7575f 100644
--- a/tests/py/inet/ct.t.json
+++ b/tests/py/inet/ct.t.json
@@ -39,7 +39,7 @@
     }
 ]
 
-# ct original ip daddr {1.2.3.4} accept
+# ct original ip daddr 1.2.3.4 accept
 [
     {
         "match": {
@@ -50,11 +50,7 @@
                 }
             },
             "op": "==",
-            "right": {
-                "set": [
-                    "1.2.3.4"
-                ]
-            }
+            "right": "1.2.3.4"
         }
     },
     {
diff --git a/tests/py/inet/ct.t.payload b/tests/py/inet/ct.t.payload
index 3b274f8c64c4..f7a2ef27274a 100644
--- a/tests/py/inet/ct.t.payload
+++ b/tests/py/inet/ct.t.payload
@@ -10,11 +10,8 @@ inet test-inet input
   [ ct load src_ip6 => reg 1 , dir original ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
 
-# ct original ip daddr {1.2.3.4} accept
-__set%d test-inet 3 size 1
-__set%d test-inet 0
-	element 04030201  : 0 [end]
+# ct original ip daddr 1.2.3.4 accept
 inet test-inet input
   [ ct load dst_ip => reg 1 , dir original ]
-  [ lookup reg 1 set __set%d ]
+  [ cmp eq reg 1 0x04030201 ]
   [ immediate reg 0 accept ]
-- 
2.26.3

