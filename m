From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 nft] parser: add redirect constant to rhs_expr rule
Date: Mon, 28 Dec 2015 12:52:54 +0100
Message-ID: <1451303574-14510-3-git-send-email-pablo@netfilter.org>
References: <1451303574-14510-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbbL1LxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 06:53:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3765D1324C1
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27872DA801
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C3476DA7E0
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 12:53:06 +0100 (CET)
In-Reply-To: <1451303574-14510-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So we can use the 'redirect' reserve word as constant from the rhs
expression. Thus, we can use it as icmp type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h | 1 +
 src/parser_bison.y | 7 +++++++
 src/proto.c        | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/datatype.h b/include/datatype.h
index 07fedce..91ca2dd 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -207,6 +207,7 @@ extern const struct datatype arphrd_type;
 extern const struct datatype inet_protocol_type;
 extern const struct datatype inet_service_type;
 extern const struct datatype mark_type;
+extern const struct datatype icmp_type_type;
 extern const struct datatype icmp_code_type;
 extern const struct datatype icmpv6_code_type;
 extern const struct datatype icmpx_code_type;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index be1c740..d42bd2f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2101,6 +2101,13 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
+			|	REDIRECT
+			{
+				uint8_t data = ICMP_REDIRECT;
+				$$ = constant_expr_alloc(&@$, &icmp_type_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 sizeof(data) * BITS_PER_BYTE, &data);
+			}
 			;
 
 relational_op		:	EQ		{ $$ = OP_EQ; }
diff --git a/src/proto.c b/src/proto.c
index 3282271..65ee158 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -303,7 +303,7 @@ static const struct symbol_table icmp_type_tbl = {
 	},
 };
 
-static const struct datatype icmp_type_type = {
+const struct datatype icmp_type_type = {
 	.type		= TYPE_ICMP_TYPE,
 	.name		= "icmp_type",
 	.desc		= "ICMP type",
-- 
2.1.4

