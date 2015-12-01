From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] tests: vlan pcp and cfi are located in the first byte
Date: Tue,  1 Dec 2015 18:44:26 +0100
Message-ID: <1448991867-21247-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42066 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbbLARok (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2015 12:44:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2F9F36E405
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21C66DA808
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F07A9DA7E0
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:32 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adjust tests to fix wrong payloads, both pcp and cfi are located in the
first nibble of the first byte.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/bridge/vlan.t.payload | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/regression/bridge/vlan.t.payload b/tests/regression/bridge/vlan.t.payload
index 35dc437..02242d2 100644
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
 
@@ -194,7 +194,7 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
-  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
   [ cmp gte reg 1 0x00000001 ]
   [ cmp lte reg 1 0x00000003 ]
-- 
2.1.4

