From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] datatype: ll: use big endian byte ordering
Date: Fri,  9 Sep 2016 14:43:14 +0200
Message-ID: <1473424996-26957-2-git-send-email-fw@strlen.de>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48760 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbcIIMnE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 08:43:04 -0400
In-Reply-To: <1473424996-26957-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ether daddr set 00:03:2d:2b:74:ec  is listed as:
ether daddr set ec:74:2b:2d:03:00

(it was fine without 'set' keyword).  Reason is that
ether address was listed as being HOST endian.

The payload expression (unlike statement) path contains
a few conversion call sites for this, i.e.:

if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
   mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);

... it might make sense to remove those in a followup patch.

Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/datatype.c | 7 ++++---
 src/proto.c    | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 2b1619a..1e40287 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -348,7 +348,8 @@ static void lladdr_type_print(const struct expr *expr)
 	uint8_t data[len];
 	unsigned int i;
 
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	mpz_export_data(data, expr->value, BYTEORDER_BIG_ENDIAN, len);
+
 	for (i = 0; i < len; i++) {
 		printf("%s%.2x", delim, data[i]);
 		delim = ":";
@@ -374,7 +375,7 @@ static struct error_record *lladdr_type_parse(const struct expr *sym,
 	}
 
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
-				   BYTEORDER_HOST_ENDIAN, len * BITS_PER_BYTE,
+				   BYTEORDER_BIG_ENDIAN, len * BITS_PER_BYTE,
 				   buf);
 	return NULL;
 }
@@ -383,7 +384,7 @@ const struct datatype lladdr_type = {
 	.type		= TYPE_LLADDR,
 	.name		= "ll_addr",
 	.desc		= "link layer address",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.basetype	= &integer_type,
 	.print		= lladdr_type_print,
 	.parse		= lladdr_type_parse,
diff --git a/src/proto.c b/src/proto.c
index 94995f1..df5439c 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -854,7 +854,7 @@ const struct datatype etheraddr_type = {
 	.type		= TYPE_ETHERADDR,
 	.name		= "ether_addr",
 	.desc		= "Ethernet address",
-	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
 	.size		= ETH_ALEN * BITS_PER_BYTE,
 	.basetype	= &lladdr_type,
 };
@@ -892,7 +892,7 @@ const struct datatype ethertype_type = {
 	ETHHDR_TEMPLATE(__name, &ethertype_type, __member)
 #define ETHHDR_ADDR(__name, __member) \
 	PROTO_HDR_TEMPLATE(__name, &etheraddr_type,		\
-			   BYTEORDER_HOST_ENDIAN,		\
+			   BYTEORDER_BIG_ENDIAN,		\
 			   offsetof(struct ether_header, __member) * 8,	\
 			   field_sizeof(struct ether_header, __member) * 8)
 
-- 
2.7.3

