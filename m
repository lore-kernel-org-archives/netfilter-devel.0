From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] tests: redirect: fix payload display
Date: Tue, 18 Aug 2015 07:08:16 +0200
Message-ID: <1439874496-4852-2-git-send-email-pablo@netfilter.org>
References: <1439874496-4852-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbbHRFCM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 01:02:12 -0400
In-Reply-To: <1439874496-4852-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This has to be related to libnftnl's 0edeb667a2cf ("expr: redir: fix snprintf
to return the number of bytes printed").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian: After this patch, I pass all payload tests here that we have :).

 tests/regression/ip/redirect.t.payload      |   36 +++++++++++++--------------
 tests/regression/ip6/redirect.t.payload.ip6 |   30 +++++++++++-----------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/tests/regression/ip/redirect.t.payload b/tests/regression/ip/redirect.t.payload
index 3c6e1e0..ac71804 100644
--- a/tests/regression/ip/redirect.t.payload
+++ b/tests/regression/ip/redirect.t.payload
@@ -12,7 +12,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x4 ]
 
 # udp dport 53 redirect random,persistent
 ip test-ip4 output
@@ -20,7 +20,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0xc ]
 
 # udp dport 53 redirect random,persistent,fully-random
 ip test-ip4 output
@@ -28,7 +28,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect random,fully-random
 ip test-ip4 output
@@ -36,7 +36,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x14 ]
 
 # udp dport 53 redirect random,fully-random,persistent
 ip test-ip4 output
@@ -44,7 +44,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent
 ip test-ip4 output
@@ -52,7 +52,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x8 ]
 
 # udp dport 53 redirect persistent,random
 ip test-ip4 output
@@ -60,7 +60,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0xc ]
 
 # udp dport 53 redirect persistent,random,fully-random
 ip test-ip4 output
@@ -68,7 +68,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent,fully-random
 ip test-ip4 output
@@ -76,7 +76,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x18 ]
 
 # udp dport 53 redirect persistent,fully-random,random
 ip test-ip4 output
@@ -84,7 +84,7 @@ ip test-ip4 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # tcp dport 22 redirect to 22
 ip test-ip4 output
@@ -93,7 +93,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
   [ immediate reg 1 0x00001600 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # udp dport 1234 redirect to 4321
 ip test-ip4 output
@@ -102,7 +102,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
   [ immediate reg 1 0x0000e110 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # ip daddr 172.16.0.1 udp dport 9998 redirect to 6515
 ip test-ip4 output
@@ -113,7 +113,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
   [ immediate reg 1 0x00007319 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # tcp dport 39128 redirect to 993
 ip test-ip4 output
@@ -122,7 +122,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # tcp dport 9128 redirect to 993 random
 ip test-ip4 output
@@ -131,7 +131,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0x4 ]
 
 # tcp dport 9128 redirect to 993 fully-random
 ip test-ip4 output
@@ -140,7 +140,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0x10 ]
 
 # tcp dport 9128 redirect to 123 persistent
 ip test-ip4 output
@@ -149,7 +149,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x00007b00 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0x8 ]
 
 # tcp dport 9128 redirect to 123 random,persistent
 ip test-ip4 output
@@ -158,7 +158,7 @@ ip test-ip4 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x00007b00 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0xc ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 set%d test-ip4 3
diff --git a/tests/regression/ip6/redirect.t.payload.ip6 b/tests/regression/ip6/redirect.t.payload.ip6
index b05e2c9..3369a7a 100644
--- a/tests/regression/ip6/redirect.t.payload.ip6
+++ b/tests/regression/ip6/redirect.t.payload.ip6
@@ -23,7 +23,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x4 ]
 
 # udp dport 53 redirect random,persistent
 ip6 test-ip6 output
@@ -31,7 +31,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0xc ]
 
 # udp dport 53 redirect random,persistent,fully-random
 ip6 test-ip6 output
@@ -39,7 +39,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect random,fully-random
 ip6 test-ip6 output
@@ -47,7 +47,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x14 ]
 
 # udp dport 53 redirect random,fully-random,persistent
 ip6 test-ip6 output
@@ -55,7 +55,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent
 ip6 test-ip6 output
@@ -63,7 +63,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x8 ]
 
 # udp dport 53 redirect persistent,random
 ip6 test-ip6 output
@@ -71,7 +71,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0xc ]
 
 # udp dport 53 redirect persistent,random,fully-random
 ip6 test-ip6 output
@@ -79,7 +79,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 53 redirect persistent,fully-random
 ip6 test-ip6 output
@@ -87,7 +87,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x18 ]
 
 # udp dport 53 redirect persistent,fully-random,random
 ip6 test-ip6 output
@@ -95,7 +95,7 @@ ip6 test-ip6 output
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00003500 ]
-  [ redir ]
+  [ redir flags 0x1c ]
 
 # udp dport 1234 redirect to 1234
 ip6 test-ip6 output
@@ -104,7 +104,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d204 ]
   [ immediate reg 1 0x0000d204 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # ip6 daddr fe00::cafe udp dport 9998 redirect to 6515
 ip6 test-ip6 output
@@ -115,7 +115,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000e27 ]
   [ immediate reg 1 0x00007319 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # tcp dport 39128 redirect to 993
 ip6 test-ip6 output
@@ -124,7 +124,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000d898 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 ]
 
 # tcp dport 9128 redirect to 993 random
 ip6 test-ip6 output
@@ -133,7 +133,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0x4 ]
 
 # tcp dport 9128 redirect to 993 fully-random,persistent
 ip6 test-ip6 output
@@ -142,7 +142,7 @@ ip6 test-ip6 output
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000a823 ]
   [ immediate reg 1 0x0000e103 ]
-  [ redir ]
+  [ redir proto_min reg 1 flags 0x18 ]
 
 # tcp dport { 1, 2, 3, 4, 5, 6, 7, 8, 101, 202, 303, 1001, 2002, 3003} redirect
 set%d test-ip6 3
-- 
1.7.10.4

