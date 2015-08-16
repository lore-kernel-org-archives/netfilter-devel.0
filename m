From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 09/12] tests: add tests for ip version/hdrlength/tcp doff
Date: Sun, 16 Aug 2015 21:05:52 +0200
Message-ID: <1439751955-31190-10-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34750 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbbHPTGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:14 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Header fields of 4 bit lengths.  Requires implicit masks and
shifting of RHS constant.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/regression/inet/tcp.t              |  2 ++
 tests/regression/inet/tcp.t.payload.inet |  8 ++++++++
 tests/regression/inet/tcp.t.payload.ip   |  8 ++++++++
 tests/regression/inet/tcp.t.payload.ip6  |  8 ++++++++
 tests/regression/ip/ip.t                 |  4 ++++
 tests/regression/ip/ip.t.payload         | 21 +++++++++++++++++++++
 tests/regression/ip/ip.t.payload.inet    | 27 +++++++++++++++++++++++++++
 7 files changed, 78 insertions(+)

diff --git a/tests/regression/inet/tcp.t b/tests/regression/inet/tcp.t
index 95267da..53a1689 100644
--- a/tests/regression/inet/tcp.t
+++ b/tests/regression/inet/tcp.t
@@ -101,3 +101,5 @@ tcp urgptr { 33, 55, 67, 88};ok
 - tcp urgptr != { 33, 55, 67, 88};ok
 tcp urgptr { 33-55};ok
 - tcp urgptr != { 33-55};ok
+
+tcp doff 8;ok
diff --git a/tests/regression/inet/tcp.t.payload.inet b/tests/regression/inet/tcp.t.payload.inet
index e1673db..21b21ab 100644
--- a/tests/regression/inet/tcp.t.payload.inet
+++ b/tests/regression/inet/tcp.t.payload.inet
@@ -498,3 +498,11 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# tcp doff 8
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000080 ]
+
diff --git a/tests/regression/inet/tcp.t.payload.ip b/tests/regression/inet/tcp.t.payload.ip
index c21cca1..34c9714 100644
--- a/tests/regression/inet/tcp.t.payload.ip
+++ b/tests/regression/inet/tcp.t.payload.ip
@@ -498,3 +498,11 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# tcp doff 8
+ip test-ip4 input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000080 ]
+
diff --git a/tests/regression/inet/tcp.t.payload.ip6 b/tests/regression/inet/tcp.t.payload.ip6
index 32115ed..44decab 100644
--- a/tests/regression/inet/tcp.t.payload.ip6
+++ b/tests/regression/inet/tcp.t.payload.ip6
@@ -498,3 +498,11 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set set%d ]
 
+# tcp doff 8
+ip6 test-ip6 input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000080 ]
+
diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
index 6e29ffb..0339c2a 100644
--- a/tests/regression/ip/ip.t
+++ b/tests/regression/ip/ip.t
@@ -111,3 +111,7 @@ ip saddr \& 0.0.0.255 \< 0.0.0.127;ok;ip saddr & 0.0.0.255 < 0.0.0.127
 
 ip saddr \& 0xffff0000 == 0xffff0000;ok;ip saddr 255.255.0.0/16
 
+ip version 4 ip hdrlength 5;ok
+ip hdrlength 0;ok
+ip hdrlength 15;ok
+ip hdrlength 16;fail
diff --git a/tests/regression/ip/ip.t.payload b/tests/regression/ip/ip.t.payload
index 7a77dc4..31a57a2 100644
--- a/tests/regression/ip/ip.t.payload
+++ b/tests/regression/ip/ip.t.payload
@@ -353,3 +353,24 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip version 4 ip hdrlength 5
+ip test-ip4 input
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000040 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000005 ]
+
+# ip hdrlength 0
+ip test-ip4 input
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ip hdrlength 15
+ip test-ip4 input
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000f ]
+
diff --git a/tests/regression/ip/ip.t.payload.inet b/tests/regression/ip/ip.t.payload.inet
index dbc7852..8c31349 100644
--- a/tests/regression/ip/ip.t.payload.inet
+++ b/tests/regression/ip/ip.t.payload.inet
@@ -465,3 +465,30 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
+# ip version 4 ip hdrlength 5
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000040 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000005 ]
+
+# ip hdrlength 0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ip hdrlength 15
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000000f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000f ]
+
-- 
2.0.5

