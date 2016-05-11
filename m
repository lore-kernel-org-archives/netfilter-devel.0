From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 12/12] tests/py: fix payload of dccp type in set elements
Date: Wed, 11 May 2016 23:05:16 +0200
Message-ID: <1463000716-11885-12-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbcEKVFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6B06D1BD5BA
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 58207FF153
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3274FCA0FF
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:28 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This value needs to be lshift one bit to be correct.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/dccp.t.payload.inet   | 2 +-
 tests/py/inet/dccp.t.payload.ip     | 2 +-
 tests/py/inet/dccp.t.payload.ip6    | 2 +-
 tests/py/inet/dccp.t.payload.netdev | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/py/inet/dccp.t.payload.inet b/tests/py/inet/dccp.t.payload.inet
index 11f5aaf..06cabaf 100644
--- a/tests/py/inet/dccp.t.payload.inet
+++ b/tests/py/inet/dccp.t.payload.inet
@@ -83,7 +83,7 @@ inet test-inet input
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 set%d test-inet 3
 set%d test-inet 0
-	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
diff --git a/tests/py/inet/dccp.t.payload.ip b/tests/py/inet/dccp.t.payload.ip
index fbf441a..3b5def4 100644
--- a/tests/py/inet/dccp.t.payload.ip
+++ b/tests/py/inet/dccp.t.payload.ip
@@ -83,7 +83,7 @@ ip test-ip4 input
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 set%d test-ip4 3
 set%d test-ip4 0
-	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
diff --git a/tests/py/inet/dccp.t.payload.ip6 b/tests/py/inet/dccp.t.payload.ip6
index b323c06..fd7177c 100644
--- a/tests/py/inet/dccp.t.payload.ip6
+++ b/tests/py/inet/dccp.t.payload.ip6
@@ -83,7 +83,7 @@ ip6 test-ip6 input
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 set%d test-ip6 3
 set%d test-ip6 0
-        element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
diff --git a/tests/py/inet/dccp.t.payload.netdev b/tests/py/inet/dccp.t.payload.netdev
index 5a8c873..678b986 100644
--- a/tests/py/inet/dccp.t.payload.netdev
+++ b/tests/py/inet/dccp.t.payload.netdev
@@ -83,7 +83,7 @@ inet test-inet input
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 set%d test-netdev 3
 set%d test-netdev 0
-	element 00000000  : 0 [end]     element 00000001  : 0 [end]     element 00000002  : 0 [end]     element 00000003  : 0 [end]     element 00000004  : 0 [end]     element 00000005  : 0 [end]     element 00000006  : 0 [end]     element 00000007  : 0 [end]     element 00000008  : 0 [end]     element 00000009  : 0 [end]
+	element 00000000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00000010  : 0 [end]	element 00000012  : 0 [end]
 netdev test-netdev ingress
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
-- 
2.1.4

