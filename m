Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7023C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A30E86108B
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhKSPcC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPcB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1755FC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5ow-0005QK-Kb; Fri, 19 Nov 2021 16:28:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/8] tcpopt: remove KIND keyword
Date:   Fri, 19 Nov 2021 16:28:40 +0100
Message-Id: <20211119152847.18118-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tcp option <foo> kind ... never makes any sense, as "tcp option <foo>"
already tells the kernel to look for the foo <kind>.

"tcp option sack kind 5" matches if the sack option is present; its a
more complicated form of the simpler "tcp option sack exists".

"tcp option sack kind 1" (or any other value than 5) will never match.

So remove this.

Test cases are converted to "exists".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt    | 29 +++++++++-------
 src/parser_bison.y            |  4 +--
 src/scanner.l                 |  1 -
 tests/py/any/tcpopt.t         | 13 ++++----
 tests/py/any/tcpopt.t.json    | 63 +++++++++++------------------------
 tests/py/any/tcpopt.t.payload | 29 +++++++---------
 6 files changed, 56 insertions(+), 83 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 930a18074a6c..106ff74ce57e 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -614,37 +614,37 @@ Segment Routing Header
 |Keyword| Description | TCP option fields
 |eol|
 End if option list|
-kind
+-
 |nop|
 1 Byte TCP Nop padding option |
-kind
+-
 |maxseg|
 TCP Maximum Segment Size|
-kind, length, size
+length, size
 |window|
 TCP Window Scaling |
-kind, length, count
+length, count
 |sack-perm |
 TCP SACK permitted |
-kind, length
+length
 |sack|
 TCP Selective Acknowledgement (alias of block 0) |
-kind, length, left, right
+length, left, right
 |sack0|
 TCP Selective Acknowledgement (block 0) |
-kind, length, left, right
+length, left, right
 |sack1|
 TCP Selective Acknowledgement (block 1) |
-kind, length, left, right
+length, left, right
 |sack2|
 TCP Selective Acknowledgement (block 2) |
-kind, length, left, right
+length, left, right
 |sack3|
 TCP Selective Acknowledgement (block 3) |
-kind, length, left, right
+length, left, right
 |timestamp|
 TCP Timestamps |
-kind, length, tsval, tsecr
+length, tsval, tsecr
 |============================
 
 TCP option matching also supports raw expression syntax to access arbitrary options:
@@ -673,7 +673,12 @@ type, length, ptr, addr
 
 .finding TCP options
 --------------------
-filter input tcp option sack-perm kind 1 counter
+filter input tcp option sack-perm exists counter
+--------------------
+
+.matching TCP options
+--------------------
+filter input tcp option maxseg size lt 536
 --------------------
 
 .matching IPv6 exthdr
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 81d75ecb2fe8..bc5ec2e667b8 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -412,7 +412,6 @@ int nft_lex(void *, void *, void *);
 %token SACK3			"sack3"
 %token SACK_PERM		"sack-permitted"
 %token TIMESTAMP		"timestamp"
-%token KIND			"kind"
 %token COUNT			"count"
 %token LEFT			"left"
 %token RIGHT			"right"
@@ -5526,8 +5525,7 @@ tcp_hdr_option_type	:	EOL		{ $$ = TCPOPT_KIND_EOL; }
 			}
 			;
 
-tcp_hdr_option_field	:	KIND		{ $$ = TCPOPT_COMMON_KIND; }
-			|	LENGTH		{ $$ = TCPOPT_COMMON_LENGTH; }
+tcp_hdr_option_field	:	LENGTH		{ $$ = TCPOPT_COMMON_LENGTH; }
 			|	SIZE		{ $$ = TCPOPT_MAXSEG_SIZE; }
 			|	COUNT		{ $$ = TCPOPT_WINDOW_COUNT; }
 			|	LEFT		{ $$ = TCPOPT_SACK_LEFT; }
diff --git a/src/scanner.l b/src/scanner.l
index 6cc7778dd85e..455ef99fea8f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -481,7 +481,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "timestamp"		{ return TIMESTAMP; }
 "time"			{ return TIME; }
 
-"kind"			{ return KIND; }
 "count"			{ return COUNT; }
 "left"			{ return LEFT; }
 "right"			{ return RIGHT; }
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index bcc64eac2e21..d3586eae8399 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -4,17 +4,16 @@
 *ip6;test-ip6;input
 *inet;test-inet;input
 
-tcp option eol kind 1;ok
-tcp option nop kind 1;ok
-tcp option maxseg kind 1;ok
+tcp option eol exists;ok
+tcp option nop exists;ok
+tcp option maxseg exists;ok
 tcp option maxseg length 1;ok
 tcp option maxseg size 1;ok
-tcp option window kind 1;ok
 tcp option window length 1;ok
 tcp option window count 1;ok
-tcp option sack-perm kind 1;ok
+tcp option sack-perm exists;ok
 tcp option sack-perm length 1;ok
-tcp option sack kind 1;ok
+tcp option sack exists;ok
 tcp option sack length 1;ok
 tcp option sack left 1;ok
 tcp option sack0 left 1;ok;tcp option sack left 1
@@ -26,7 +25,7 @@ tcp option sack0 right 1;ok;tcp option sack right 1
 tcp option sack1 right 1;ok
 tcp option sack2 right 1;ok
 tcp option sack3 right 1;ok
-tcp option timestamp kind 1;ok
+tcp option timestamp exists;ok
 tcp option timestamp length 1;ok
 tcp option timestamp tsval 1;ok
 tcp option timestamp tsecr 1;ok
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index a45b4c8b5c58..5468accb16b4 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -1,47 +1,44 @@
-# tcp option eol kind 1
+# tcp option eol exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "eol"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
 
-# tcp option nop kind 1
+# tcp option nop exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "nop"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
 
-# tcp option maxseg kind 1
+# tcp option maxseg exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "maxseg"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
@@ -78,22 +75,6 @@
     }
 ]
 
-# tcp option window kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "window"
-                }
-            },
-            "op": "==",
-            "right": 1
-        }
-    }
-]
-
 # tcp option window length 1
 [
     {
@@ -126,18 +107,17 @@
     }
 ]
 
-# tcp option sack-perm kind 1
+# tcp option sack-perm exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "sack-perm"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
@@ -158,18 +138,17 @@
     }
 ]
 
-# tcp option sack kind 1
+# tcp option sack exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "sack"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
@@ -213,7 +192,7 @@
             "left": {
                 "tcp option": {
                     "field": "left",
-                    "name": "sack0"
+                    "name": "sack"
                 }
             },
             "op": "==",
@@ -293,7 +272,7 @@
             "left": {
                 "tcp option": {
                     "field": "right",
-                    "name": "sack0"
+                    "name": "sack"
                 }
             },
             "op": "==",
@@ -350,18 +329,17 @@
     }
 ]
 
-# tcp option timestamp kind 1
+# tcp option timestamp exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "field": "kind",
                     "name": "timestamp"
                 }
             },
             "op": "==",
-            "right": 1
+            "right": true
         }
     }
 ]
@@ -414,36 +392,36 @@
     }
 ]
 
-# tcp option 6 exists
+# tcp option 255 missing
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "base": 6,
+                    "base": 255,
                     "len": 8,
                     "offset": 0
                 }
             },
             "op": "==",
-            "right": true
+            "right": false
         }
     }
 ]
 
-# tcp option 255 missing
+# tcp option 6 exists
 [
     {
         "match": {
             "left": {
                 "tcp option": {
-                    "base": 255,
+                    "base": 6,
                     "len": 8,
                     "offset": 0
                 }
             },
             "op": "==",
-            "right": false
+            "right": true
         }
     }
 ]
@@ -509,4 +487,3 @@
         }
     }
 ]
-
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 51f3a7527668..d88bcd433a10 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -1,16 +1,16 @@
-# tcp option eol kind 1
+# tcp option eol exists
 inet 
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option nop kind 1
+# tcp option nop exists
 inet 
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option maxseg kind 1
+# tcp option maxseg exists
 inet 
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option maxseg length 1
@@ -23,11 +23,6 @@ inet
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
 
-# tcp option window kind 1
-inet 
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option window length 1
 inet 
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
@@ -38,9 +33,9 @@ inet
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-perm kind 1
+# tcp option sack-perm exists
 inet 
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack-perm length 1
@@ -48,9 +43,9 @@ inet
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack kind 1
+# tcp option sack exists
 inet 
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option sack length 1
@@ -108,9 +103,9 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option timestamp kind 1
+# tcp option timestamp exists
 inet 
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 present => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
 # tcp option timestamp length 1
-- 
2.32.0

