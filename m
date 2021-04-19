Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4BBC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF4161077
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDSKwQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 06:52:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36118 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhDSKwQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 06:52:16 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B522F63E64
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 12:51:15 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: missing relational operation on flag list
Date:   Mon, 19 Apr 2021 12:51:42 +0200
Message-Id: <20210419105142.30685-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Complete e6c32b2fa0b8 ("src: add negation match on singleton bitmask
value") which was missing comma-separated list of flags:

    tcp flags and fin,rst == 0

which allows to check for the packet whose fin and rst bits are unset:

    # nft add rule x y tcp flags not fin,rst counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y          |  4 ++++
 tests/py/inet/tcp.t         |  1 +
 tests/py/inet/tcp.t.json    | 16 ++++++++++++++++
 tests/py/inet/tcp.t.payload |  7 +++++++
 4 files changed, 28 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cc477e65672a..2b04700a43cc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4461,6 +4461,10 @@ relational_expr		:	expr	/* implicit */	rhs_expr
 			{
 				$$ = relational_expr_alloc(&@2, $2, $1, $3);
 			}
+			|	expr	relational_op	list_rhs_expr
+			{
+				$$ = relational_expr_alloc(&@2, $2, $1, $3);
+			}
 			;
 
 list_rhs_expr		:	basic_rhs_expr		COMMA		basic_rhs_expr
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index 29f06f5ae484..5f2caea98759 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -81,6 +81,7 @@ tcp flags & (syn|fin) == (syn|fin);ok;tcp flags & (fin | syn) == fin | syn
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
+tcp flags ! fin,rst;ok
 
 tcp window 22222;ok
 tcp window 22;ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 702251828360..251bf6f0b42b 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1730,3 +1730,19 @@
         }
     }
 ]
+
+# tcp flags ! fin,rst
+[
+    {
+        "match": {
+            "op": "!",
+            "left": {
+                "payload": {
+                    "protocol": "tcp",
+                    "field": "flags"
+                }
+            },
+            "right": ["fin", "rst"]
+        }
+    }
+]
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 5eaf4090462d..da932b6d8c12 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -701,3 +701,10 @@ inet
   [ payload load 1b @ transport header + 13 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# tcp flags ! fin,rst
+inet
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000005 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
-- 
2.20.1

