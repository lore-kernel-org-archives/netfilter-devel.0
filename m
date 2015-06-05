From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 6/9] netlink: pad constant concat sub-expressions
Date: Fri,  5 Jun 2015 15:42:48 +0200
Message-ID: <1433511771-4620-7-git-send-email-kaber@trash.net>
References: <1433511771-4620-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbbFENm4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:42:56 -0400
In-Reply-To: <1433511771-4620-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pad all but the last sub-expressions of a concat expressions.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/netlink.h | 10 ++++++++++
 src/datatype.c    |  3 ++-
 src/netlink.c     | 14 ++++++--------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 9b42fdb..185c435 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -58,6 +58,16 @@ static inline unsigned int netlink_register_space(unsigned int size)
 	return div_round_up(size, NFT_REG32_SIZE * BITS_PER_BYTE);
 }
 
+static inline unsigned int netlink_padded_len(unsigned int size)
+{
+	return netlink_register_space(size) * NFT_REG32_SIZE * BITS_PER_BYTE;
+}
+
+static inline unsigned int netlink_padding_len(unsigned int size)
+{
+	return netlink_padded_len(size) - size;
+}
+
 extern void netlink_gen_data(const struct expr *expr,
 			     struct nft_data_linearize *data);
 extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
diff --git a/src/datatype.c b/src/datatype.c
index f93337b..a06a58e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -23,6 +23,7 @@
 #include <expression.h>
 #include <gmputil.h>
 #include <erec.h>
+#include <netlink.h>
 
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
@@ -943,7 +944,7 @@ const struct datatype *concat_type_alloc(uint32_t type)
 		strncat(desc, i->desc, sizeof(desc) - strlen(desc) - 1);
 		strncat(name, i->name, sizeof(name) - strlen(name) - 1);
 
-		size += i->size;
+		size += netlink_padded_len(i->size);
 		subtypes++;
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
diff --git a/src/netlink.c b/src/netlink.c
index d31387f..3369d22 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -273,23 +273,21 @@ static void netlink_gen_concat_data(const struct expr *expr,
 	const struct expr *i;
 	unsigned int len, offset;
 
-	len = 0;
-	list_for_each_entry(i, &expr->expressions, list)
-		len += i->len;
-
+	len = expr->len / BITS_PER_BYTE;
 	if (1) {
-		unsigned char data[len / BITS_PER_BYTE];
+		unsigned char data[len];
 
+		memset(data, 0, sizeof(data));
 		offset = 0;
 		list_for_each_entry(i, &expr->expressions, list) {
 			assert(i->ops->type == EXPR_VALUE);
 			mpz_export_data(data + offset, i->value, i->byteorder,
 					i->len / BITS_PER_BYTE);
-			offset += i->len / BITS_PER_BYTE;
+			offset += netlink_padded_len(i->len) / BITS_PER_BYTE;
 		}
 
-		memcpy(nld->value, data, len / BITS_PER_BYTE);
-		nld->len = len / BITS_PER_BYTE;
+		memcpy(nld->value, data, len);
+		nld->len = len;
 	}
 }
 
-- 
2.1.0

