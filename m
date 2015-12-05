From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/7,v2] tests: vlan pcp and cfi are located in the first byte
Date: Sat,  5 Dec 2015 20:04:20 +0100
Message-ID: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51085 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbLETEk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Dec 2015 14:04:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B7FC6DA85F
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAFEFDA7E0
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A566DA795
	for <netfilter-devel@vger.kernel.org>; Sat,  5 Dec 2015 20:04:34 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adjust tests to fix wrong payloads, both pcp and cfi are located in the
first nibble of the first byte.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix vlan test for simple ranges too.

 tests/regression/bridge/vlan.t.payload | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/regression/bridge/vlan.t.payload b/tests/regression/bridge/vlan.t.payload
index 35dc437..78ee7ef 100644
--- a/tests/regression/bridge/vlan.t.payload
+++ b/tests/regression/bridge/vlan.t.payload
@@ -21,7 +21,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
@@ -32,7 +32,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000010 ]
 
@@ -43,7 +43,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
@@ -70,7 +70,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
@@ -81,7 +81,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
 
@@ -163,10 +163,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x000000e0 ]
 
@@ -177,10 +177,10 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000fe0f ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000010 ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000060 ]
 
@@ -194,8 +194,8 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000001 ]
-  [ cmp lte reg 1 0x00000003 ]
+  [ cmp gte reg 1 0x00000020 ]
+  [ cmp lte reg 1 0x00000060 ]
 
-- 
2.1.4

