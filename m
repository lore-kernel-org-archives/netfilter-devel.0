From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables] meta: iif/oifname should be host byte order
Date: Fri, 20 Sep 2013 16:01:33 +0200
Message-ID: <1379685693-2854-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49244 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940Ab3ITOBj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:01:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src/nft add rule filter output meta oifname eth0

doesn't work on x86.  Problem is that nft declares these as
BYTEORDER_INVALID, but when converting the string mpz_import_data
treats INVALID like BIG_ENDIAN.

[ cmp eq reg 1 0x00000000 0x00000000 0x65000000 0x00306874 ]

as kernel nft_cmp_eval basically boils down to

memcmp(reg, skb->dev->name, sizeof(reg) comparision fails.

with patch:
[ cmp eq reg 1 0x30687465 0x00000000 0x00000000 0x00000000 ]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 On a related note:
 Instead of
 memcmp(register, devicename, strlen(register)+1) [i.e., strcmp]
 The comparision in kernel is always
 memcmp(register, dev->name, IFNAMSIZ).

 IOW, why does expr_evaluate_value() replace the interface names
 string length with the template length (IFNAMSIZ)?

 It doesn't seem to be needed, and without it supporting
 iptables-style wildcard name match (oifname "eth+") should be quite simple.

diff --git a/src/datatype.c b/src/datatype.c
index c4fc131..4c5a70f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -258,7 +258,7 @@ static void string_type_print(const struct expr *expr)
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	char data[len];
 
-	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 	printf("\"%s\"", data);
 }
 
@@ -266,7 +266,7 @@ static struct error_record *string_type_parse(const struct expr *sym,
 	      				      struct expr **res)
 {
 	*res = constant_expr_alloc(&sym->location, &string_type,
-				   BYTEORDER_INVALID,
+				   BYTEORDER_HOST_ENDIAN,
 				   (strlen(sym->identifier) + 1) * BITS_PER_BYTE,
 				   sym->identifier);
 	return NULL;
diff --git a/src/meta.c b/src/meta.c
index 17322af..9606a44 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -295,14 +295,14 @@ static const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFNAME]	= META_TEMPLATE("iifname",   &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_INVALID),
+						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_IIFTYPE]	= META_TEMPLATE("iiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIF]		= META_TEMPLATE("oif",	     &ifindex_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFNAME]	= META_TEMPLATE("oifname",   &string_type,
 						IFNAMSIZ * BITS_PER_BYTE,
-						BYTEORDER_INVALID),
+						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_OIFTYPE]	= META_TEMPLATE("oiftype",   &arphrd_type,
 						2 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SKUID]	= META_TEMPLATE("skuid",     &uid_type,
-- 
1.7.8.6

