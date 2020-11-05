Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99D7C4742C
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BC16206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgKEOMF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOME (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:12:04 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B00C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:12:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzf-0006Gd-Ap; Thu, 05 Nov 2020 15:12:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/7] tcpopt: rename noop to nop
Date:   Thu,  5 Nov 2020 15:11:40 +0100
Message-Id: <20201105141144.31430-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105141144.31430-1-fw@strlen.de>
References: <20201105141144.31430-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'nop' is the tcp padding "option". "noop" is retained for compatibility
on parser side.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt    |  4 ++--
 src/tcpopt.c                  |  2 +-
 tests/py/any/tcpopt.t         |  2 +-
 tests/py/any/tcpopt.t.json    |  4 ++--
 tests/py/any/tcpopt.t.payload | 16 +---------------
 5 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 2fa394ea966f..3cfa7791edac 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -559,8 +559,8 @@ Segment Routing Header
 |eol|
 End if option list|
 kind
-|noop|
-1 Byte TCP No-op options |
+|nop|
+1 Byte TCP Nop padding option |
 kind
 |maxseg|
 TCP Maximum Segment Size|
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 8d5bdec5399e..17cb580d0ead 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -27,7 +27,7 @@ static const struct exthdr_desc tcpopt_eol = {
 };
 
 static const struct exthdr_desc tcpopt_nop = {
-	.name		= "noop",
+	.name		= "nop",
 	.type		= TCPOPT_KIND_NOP,
 	.templates	= {
 		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0,   8),
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 5f21d4989fea..1d42de8746cd 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -5,7 +5,7 @@
 *inet;test-inet;input
 
 tcp option eol kind 1;ok
-tcp option noop kind 1;ok
+tcp option nop kind 1;ok
 tcp option maxseg kind 1;ok
 tcp option maxseg length 1;ok
 tcp option maxseg size 1;ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 2c6236a1a152..b15e36ee7f4c 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -14,14 +14,14 @@
     }
 ]
 
-# tcp option noop kind 1
+# tcp option nop kind 1
 [
     {
         "match": {
             "left": {
                 "tcp option": {
                     "field": "kind",
-                    "name": "noop"
+                    "name": "nop"
                 }
             },
             "op": "==",
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index f63076ae497e..9c480c8bd06b 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -19,21 +19,7 @@ inet
   [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option noop kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option noop kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option noop kind 1
+# tcp option nop kind 1
 inet 
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
-- 
2.26.2

