From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH nftables] Add support for the meta connmark key
Date: Mon,  6 Jan 2014 17:58:39 +0100
Message-ID: <1389027519-16917-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40467 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbaAFQ6s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:58:48 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so6877697eek.27
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 08:58:47 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds supports for the connmark meta key, and the connection mark can
be both set and retrieved. By using the get/set operations, connmark
save/restore (from xt_CONNMARK) can be performed as follows:

save:
... meta connmark set "meta mark"

restore:
... meta mark set "meta connmark"

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/datatype.c                      | 2 +-
 src/meta.c                          | 2 ++
 src/parser.y                        | 2 ++
 src/scanner.l                       | 1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1d5a925..995ecaa 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -458,6 +458,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_NFTRACE: packet nftrace bit
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
+ * @NFT_META_CONNMARK: used to get/set the connection mark
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -475,6 +476,7 @@ enum nft_meta_keys {
 	NFT_META_NFTRACE,
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
+	NFT_META_CONNMARK,
 };
 
 /**
diff --git a/src/datatype.c b/src/datatype.c
index 2e5788d..084f0cd 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -656,7 +656,7 @@ static struct error_record *mark_type_parse(const struct expr *sym,
 const struct datatype mark_type = {
 	.type		= TYPE_MARK,
 	.name		= "mark",
-	.desc		= "packet mark",
+	.desc		= "packet/connection mark",
 	.size		= 4 * BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.basetype	= &integer_type,
diff --git a/src/meta.c b/src/meta.c
index 32f3012..dd041bd 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -329,6 +329,8 @@ static const struct meta_template meta_templates[] = {
 						4 * 8, BYTEORDER_HOST_ENDIAN),
 	[NFT_META_SECMARK]	= META_TEMPLATE("secmark",   &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
+	[NFT_META_CONNMARK]	= META_TEMPLATE("connmark",  &mark_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
 };
 
 static void meta_expr_print(const struct expr *expr)
diff --git a/src/parser.y b/src/parser.y
index 9320f2d..2f35966 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -291,6 +291,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token NFTRACE			"nftrace"
 %token RTCLASSID		"rtclassid"
 %token SECMARK			"secmark"
+%token CONNMARK			"connmark"
 
 %token CT			"ct"
 %token DIRECTION		"direction"
@@ -1387,6 +1388,7 @@ meta_key		:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	NFTRACE		{ $$ = NFT_META_NFTRACE; }
 			|	RTCLASSID	{ $$ = NFT_META_RTCLASSID; }
 			|	SECMARK		{ $$ = NFT_META_SECMARK; }
+			|	CONNMARK	{ $$ = NFT_META_CONNMARK; }
 			;
 
 meta_stmt		:	META	meta_key	SET	expr
diff --git a/src/scanner.l b/src/scanner.l
index 8c4f25d..945c14b 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -381,6 +381,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "nftrace"		{ return NFTRACE; }
 "rtclassid"		{ return RTCLASSID; }
 "secmark"		{ return SECMARK; }
+"connmark"		{ return CONNMARK; }
 
 "ct"			{ return CT; }
 "direction"		{ return DIRECTION; }
-- 
1.8.3.2

