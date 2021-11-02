Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C2AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 21:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2317D60FC4
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 21:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhKBVxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 17:53:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33348 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhKBVxn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 17:53:43 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D4ECB605C2
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2021 22:49:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v3] datatype: add xinteger_type alias to print in hexadecimal
Date:   Tue,  2 Nov 2021 22:50:58 +0100
Message-Id: <20211102215058.520935-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add an alias of the integer type to print raw payload expressions in
hexadecimal.

Update tests/py.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: set basetype to integer_type.

 include/datatype.h                |  1 +
 src/datatype.c                    | 16 ++++++++++++++++
 src/payload.c                     |  2 +-
 tests/py/any/rawpayload.t         | 10 +++++-----
 tests/py/any/rawpayload.t.payload |  6 +++---
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 7ddd3566d459..f5bb9dc4d937 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -254,6 +254,7 @@ extern const struct datatype verdict_type;
 extern const struct datatype nfproto_type;
 extern const struct datatype bitmask_type;
 extern const struct datatype integer_type;
+extern const struct datatype xinteger_type;
 extern const struct datatype string_type;
 extern const struct datatype lladdr_type;
 extern const struct datatype ipaddr_type;
diff --git a/src/datatype.c b/src/datatype.c
index b849f70833c7..a06c39960fa0 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -410,6 +410,22 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
+static void xinteger_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	nft_gmp_print(octx, "0x%Zx", expr->value);
+}
+
+/* Alias of integer_type to print raw payload expressions in hexadecimal. */
+const struct datatype xinteger_type = {
+	.type		= TYPE_INTEGER,
+	.name		= "integer",
+	.desc		= "integer",
+	.basetype	= &integer_type,
+	.print		= xinteger_type_print,
+	.json		= integer_type_json,
+	.parse		= integer_type_parse,
+};
+
 static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
diff --git a/src/payload.c b/src/payload.c
index c662900bdaac..d9e0d4254f19 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -269,7 +269,7 @@ void payload_init_raw(struct expr *expr, enum proto_bases base,
 	expr->payload.base	= base;
 	expr->payload.offset	= offset;
 	expr->len		= len;
-	expr->dtype		= &integer_type;
+	expr->dtype		= &xinteger_type;
 
 	if (base != PROTO_BASE_TRANSPORT_HDR)
 		return;
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index 9687729d610d..9fe377e24397 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -7,14 +7,14 @@
 
 meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 };ok;meta l4proto { 6, 17, 132} th dport { 22, 23, 80}
 meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
-@nh,8,8 255;ok
-@nh,8,16 0;ok
+@nh,8,8 0xff;ok
+@nh,8,16 0x0;ok
 
 # out of range (0-1)
 @th,16,1 2;fail
 
 @ll,0,0 2;fail
 @ll,0,1;fail
-@ll,0,1 1;ok;@ll,0,8 & 128 == 128
-@ll,0,8 and 0x80 eq 0x80;ok;@ll,0,8 & 128 == 128
-@ll,0,128 0xfedcba987654321001234567890abcde;ok;@ll,0,128 338770000845734292516042252062074518750
+@ll,0,1 1;ok;@ll,0,8 & 0x80 == 0x80
+@ll,0,8 & 0x80 == 0x80;ok
+@ll,0,128 0xfedcba987654321001234567890abcde;ok
diff --git a/tests/py/any/rawpayload.t.payload b/tests/py/any/rawpayload.t.payload
index b3ca919fb6e5..d2b38183cc95 100644
--- a/tests/py/any/rawpayload.t.payload
+++ b/tests/py/any/rawpayload.t.payload
@@ -21,12 +21,12 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# @nh,8,8 255
+# @nh,8,8 0xff
 inet test-inet input
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ cmp eq reg 1 0x000000ff ]
 
-# @nh,8,16 0
+# @nh,8,16 0x0
 inet test-inet input
   [ payload load 2b @ network header + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
@@ -37,7 +37,7 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000080 ]
 
-# @ll,0,8 and 0x80 eq 0x80
+# @ll,0,8 & 0x80 == 0x80
 inet test-inet input
   [ payload load 1b @ link header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x00000080 ) ^ 0x00000000 ]
-- 
2.30.2

