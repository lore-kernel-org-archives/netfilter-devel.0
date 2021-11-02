Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4228AC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B96C610E5
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Nov 2021 13:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhKBNvk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 09:51:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60720 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBNvj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 09:51:39 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3CA94605C0
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2021 14:47:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] datatype: add xinteger_type alias to print in hexadecimal
Date:   Tue,  2 Nov 2021 14:48:59 +0100
Message-Id: <20211102134859.493100-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add an alias of the integer type to print raw payload expressions in
hexadecimal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |  1 +
 src/datatype.c     | 25 +++++++++++++++++++++++++
 src/payload.c      |  2 +-
 3 files changed, 27 insertions(+), 1 deletion(-)

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
index b849f70833c7..728c28b38075 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -410,6 +410,31 @@ const struct datatype integer_type = {
 	.parse		= integer_type_parse,
 };
 
+static void xinteger_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	const struct datatype *dtype = expr->dtype;
+	const char *fmt = "0x%Zx";
+
+	do {
+		if (dtype->basefmt != NULL) {
+			fmt = dtype->basefmt;
+			break;
+		}
+	} while ((dtype = dtype->basetype));
+
+	nft_gmp_print(octx, fmt, expr->value);
+}
+
+/* Alias of integer_type to print raw payload expressions in hexadecimal. */
+const struct datatype xinteger_type = {
+	.type		= TYPE_INTEGER,
+	.name		= "integer",
+	.desc		= "integer",
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
-- 
2.30.2

