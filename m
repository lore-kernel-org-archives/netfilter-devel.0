Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC3DC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 17:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjH2Rso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 13:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbjH2Rs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 13:48:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98598194
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 10:48:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] proto: use hexadecimal to display ip frag-off field
Date:   Tue, 29 Aug 2023 19:48:11 +0200
Message-Id: <20230829174812.158595-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The ip frag-off field in the protocol definition is 16-bits long
and it contains the DF (0x2000) and MF (0x4000) bits too.

iptables-translate also suggests:

	ip frag-off & 0x1ffff != 0

to match on fragments. Use hexadecimal for listing this header field.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c                     |  4 +++-
 tests/py/ip/ip.t                | 12 ++++++------
 tests/py/ip/ip.t.json           | 12 ++++++------
 tests/py/ip/ip.t.payload        | 12 ++++++------
 tests/py/ip/ip.t.payload.bridge | 12 ++++++------
 tests/py/ip/ip.t.payload.inet   | 12 ++++++------
 tests/py/ip/ip.t.payload.netdev | 12 ++++++------
 7 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 4650e58cd6ed..d3bcb0c4bd0b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -306,6 +306,8 @@ const struct proto_desc *proto_ctx_find_conflict(struct proto_ctx *ctx,
 
 #define HDR_FIELD(__name, __struct, __member)				\
 	HDR_TEMPLATE(__name, &integer_type, __struct, __member)
+#define HDR_HEX_FIELD(__name, __struct, __member)				\
+	HDR_TEMPLATE(__name, &xinteger_type, __struct, __member)
 #define HDR_BITFIELD(__name, __dtype,  __offset, __len)			\
 	PROTO_HDR_TEMPLATE(__name, __dtype, BYTEORDER_BIG_ENDIAN,	\
 			   __offset, __len)
@@ -846,7 +848,7 @@ const struct proto_desc proto_ip = {
 		[IPHDR_ECN]		= HDR_BITFIELD("ecn", &ecn_type, 14, 2),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
-		[IPHDR_FRAG_OFF]	= IPHDR_FIELD("frag-off",	frag_off),
+		[IPHDR_FRAG_OFF]	= HDR_HEX_FIELD("frag-off", struct iphdr, frag_off),
 		[IPHDR_TTL]		= IPHDR_FIELD("ttl",		ttl),
 		[IPHDR_PROTOCOL]	= INET_PROTOCOL("protocol", struct iphdr, protocol),
 		[IPHDR_CHECKSUM]	= IPHDR_FIELD("checksum",	check),
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index d5a4d8a5e46e..309faad40b52 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -48,12 +48,12 @@ ip id != 33-45;ok
 ip id { 33, 55, 67, 88};ok
 ip id != { 33, 55, 67, 88};ok
 
-ip frag-off 222 accept;ok
-ip frag-off != 233;ok
-ip frag-off 33-45;ok
-ip frag-off != 33-45;ok
-ip frag-off { 33, 55, 67, 88};ok
-ip frag-off != { 33, 55, 67, 88};ok
+ip frag-off 0xde accept;ok
+ip frag-off != 0xe9;ok
+ip frag-off 0x21-0x2d;ok
+ip frag-off != 0x21-0x2d;ok
+ip frag-off { 0x21, 0x37, 0x43, 0x58};ok
+ip frag-off != { 0x21, 0x37, 0x43, 0x58};ok
 
 ip ttl 0 drop;ok
 ip ttl 233;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index b1085035a000..faf18fef05f1 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -384,7 +384,7 @@
     }
 ]
 
-# ip frag-off 222 accept
+# ip frag-off 0xde accept
 [
     {
         "match": {
@@ -403,7 +403,7 @@
     }
 ]
 
-# ip frag-off != 233
+# ip frag-off != 0xe9
 [
     {
         "match": {
@@ -419,7 +419,7 @@
     }
 ]
 
-# ip frag-off 33-45
+# ip frag-off 0x21-0x2d
 [
     {
         "match": {
@@ -437,7 +437,7 @@
     }
 ]
 
-# ip frag-off != 33-45
+# ip frag-off != 0x21-0x2d
 [
     {
         "match": {
@@ -455,7 +455,7 @@
     }
 ]
 
-# ip frag-off { 33, 55, 67, 88}
+# ip frag-off { 0x21, 0x37, 0x43, 0x58}
 [
     {
         "match": {
@@ -478,7 +478,7 @@
     }
 ]
 
-# ip frag-off != { 33, 55, 67, 88}
+# ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 [
     {
         "match": {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index b9fcb5158e9d..1d677669c324 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -124,29 +124,29 @@ ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off 222 accept
+# ip frag-off 0xde accept
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0000de00 ]
   [ immediate reg 0 accept ]
 
-# ip frag-off != 233
+# ip frag-off != 0xe9
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
-# ip frag-off 33-45
+# ip frag-off 0x21-0x2d
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
-# ip frag-off != 33-45
+# ip frag-off != 0x21-0x2d
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
-# ip frag-off { 33, 55, 67, 88}
+# ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
@@ -154,7 +154,7 @@ ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# ip frag-off != { 33, 55, 67, 88}
+# ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-ip4 3
 __set%d test-ip4 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index c6f8d4e5575b..11e49540c5f0 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -162,7 +162,7 @@ bridge test-bridge input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off 222 accept
+# ip frag-off 0xde accept
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -170,14 +170,14 @@ bridge test-bridge input
   [ cmp eq reg 1 0x0000de00 ]
   [ immediate reg 0 accept ]
 
-# ip frag-off != 233
+# ip frag-off != 0xe9
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
-# ip frag-off 33-45
+# ip frag-off 0x21-0x2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -185,14 +185,14 @@ bridge test-bridge input
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
-# ip frag-off != 33-45
+# ip frag-off != 0x21-0x2d
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
-# ip frag-off { 33, 55, 67, 88}
+# ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
@@ -202,7 +202,7 @@ bridge test-bridge input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# ip frag-off != { 33, 55, 67, 88}
+# ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-bridge 3 size 4
 __set%d test-bridge 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index e26d0dac47be..84fa66e92c0c 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -162,7 +162,7 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off 222 accept
+# ip frag-off 0xde accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
@@ -170,14 +170,14 @@ inet test-inet input
   [ cmp eq reg 1 0x0000de00 ]
   [ immediate reg 0 accept ]
 
-# ip frag-off != 233
+# ip frag-off != 0xe9
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
-# ip frag-off 33-45
+# ip frag-off 0x21-0x2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
@@ -185,14 +185,14 @@ inet test-inet input
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
-# ip frag-off != 33-45
+# ip frag-off != 0x21-0x2d
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
-# ip frag-off { 33, 55, 67, 88}
+# ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-inet 3
 __set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
@@ -202,7 +202,7 @@ inet test-inet input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# ip frag-off != { 33, 55, 67, 88}
+# ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-inet 3
 __set%d test-inet 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index de990f5bba12..f14ff2c21f48 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -96,7 +96,7 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off 222 accept
+# ip frag-off 0xde accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -104,14 +104,14 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x0000de00 ]
   [ immediate reg 0 accept ]
 
-# ip frag-off != 233
+# ip frag-off != 0xe9
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x0000e900 ]
 
-# ip frag-off 33-45
+# ip frag-off 0x21-0x2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
@@ -119,14 +119,14 @@ netdev test-netdev ingress
   [ cmp gte reg 1 0x00002100 ]
   [ cmp lte reg 1 0x00002d00 ]
 
-# ip frag-off != 33-45
+# ip frag-off != 0x21-0x2d
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
-# ip frag-off { 33, 55, 67, 88}
+# ip frag-off { 0x21, 0x37, 0x43, 0x58}
 __set%d test-netdev 3
 __set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
@@ -136,7 +136,7 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# ip frag-off != { 33, 55, 67, 88}
+# ip frag-off != { 0x21, 0x37, 0x43, 0x58}
 __set%d test-netdev 3
 __set%d test-netdev 0
 	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
-- 
2.30.2

