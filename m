From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 06/12] proto: update IPv6 flowlabel offset and length according to RFC2460
Date: Wed, 11 May 2016 23:05:10 +0200
Message-ID: <1463000716-11885-6-git-send-email-pablo@netfilter.org>
References: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbcEKVF2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 17:05:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B86AD1BD5BC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A5491CA101
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88A93FF2FD
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 23:05:24 +0200 (CEST)
In-Reply-To: <1463000716-11885-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a 20 bit field according to Section 3. IPv6 Header Format.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml                     | 2 +-
 src/proto.c                     | 2 +-
 tests/py/ip6/ip6.t.payload.inet | 4 ++++
 tests/py/ip6/ip6.t.payload.ip6  | 4 ++++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e4d227c..19b5607 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1479,7 +1479,7 @@ filter output oif eth0
 							<row>
 								<entry>flowlabel</entry>
 								<entry>Flow label</entry>
-								<entry></entry>
+								<entry>integer (20 bit)</entry>
 							</row>
 							<row>
 								<entry>length</entry>
diff --git a/src/proto.c b/src/proto.c
index cecde0f..9e972a3 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -643,7 +643,7 @@ const struct proto_desc proto_ip6 = {
 	.templates	= {
 		[IP6HDR_VERSION]	= HDR_BITFIELD("version", &integer_type, 0, 4),
 		[IP6HDR_PRIORITY]	= HDR_BITFIELD("priority", &integer_type, 4, 4),
-		[IP6HDR_FLOWLABEL]	= IP6HDR_FIELD("flowlabel",	flow_lbl),
+		[IP6HDR_FLOWLABEL]	= HDR_BITFIELD("flowlabel", &integer_type, 12, 20),
 		[IP6HDR_LENGTH]		= IP6HDR_FIELD("length",	payload_len),
 		[IP6HDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ipv6hdr, nexthdr),
 		[IP6HDR_HOPLIMIT]	= IP6HDR_FIELD("hoplimit",	hop_limit),
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 4d2ea35..3d0ae39 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -3,6 +3,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00160000 ]
 
 # ip6 flowlabel != 233
@@ -10,6 +11,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
@@ -20,6 +22,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
 
 # ip6 flowlabel { 33-55}
@@ -30,6 +33,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
 
 # ip6 length 22
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index db59bfb..55286ee 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -1,11 +1,13 @@
 # ip6 flowlabel 22
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00160000 ]
 
 # ip6 flowlabel != 233
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00e90000 ]
 
 # ip6 flowlabel { 33, 55, 67, 88}
@@ -14,6 +16,7 @@ set%d test-ip6 0
 	element 00210000  : 0 [end]	element 00370000  : 0 [end]	element 00430000  : 0 [end]	element 00580000  : 0 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
 
 # ip6 flowlabel { 33-55}
@@ -22,6 +25,7 @@ set%d test-ip6 0
 	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 3b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set set%d ]
 
 # ip6 length 22
-- 
2.1.4

