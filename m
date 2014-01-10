From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] expr: fix incorrect data type for several expression object fields
Date: Fri, 10 Jan 2014 13:38:57 +0100
Message-ID: <1389357537-7280-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39403 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaAJMjH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:39:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the incorrect data type (from uint8_t to uint32_t) in
several private data area of the expressions.

It cleans up this by translating several unsigned int to uint32_t.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/cmp.c     |    4 ++--
 src/expr/ct.c      |    2 +-
 src/expr/exthdr.c  |    8 ++++----
 src/expr/meta.c    |    4 ++--
 src/expr/payload.c |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index ca1503c..b5c694a 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -26,8 +26,8 @@
 
 struct nft_expr_cmp {
 	union nft_data_reg	data;
-	uint8_t			sreg;	/* enum nft_registers */
-	uint8_t			op;	/* enum nft_cmp_ops */
+	enum nft_registers	sreg;
+	enum nft_cmp_ops	op;
 };
 
 static int
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 59d05a5..7e20464 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -24,7 +24,7 @@
 
 struct nft_expr_ct {
 	enum nft_ct_keys        key;
-	uint32_t		dreg;	/* enum nft_registers */
+	enum nft_registers	dreg;
 	uint8_t			dir;
 };
 
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 813830b..d9e293a 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -32,9 +32,9 @@
 
 struct nft_expr_exthdr {
 	enum nft_registers	dreg;
+	uint32_t		offset;
+	uint32_t		len;
 	uint8_t			type;
-	unsigned int		offset;
-	unsigned int		len;
 };
 
 static int
@@ -51,10 +51,10 @@ nft_rule_expr_exthdr_set(struct nft_rule_expr *e, uint16_t type,
 		exthdr->type = *((uint8_t *)data);
 		break;
 	case NFT_EXPR_EXTHDR_OFFSET:
-		exthdr->offset = *((unsigned int *)data);
+		exthdr->offset = *((uint32_t *)data);
 		break;
 	case NFT_EXPR_EXTHDR_LEN:
-		exthdr->len = *((unsigned int *)data);
+		exthdr->len = *((uint32_t *)data);
 		break;
 	default:
 		return -1;
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 3c5fd77..fb62bfd 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -27,8 +27,8 @@
 #endif
 
 struct nft_expr_meta {
-	uint8_t			key;	/* enum nft_meta_keys */
-	uint8_t			dreg;	/* enum nft_registers */
+	enum nft_meta_keys	key;
+	enum nft_registers	dreg;
 };
 
 static int
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 911bb01..2c1ef04 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -29,8 +29,8 @@
 struct nft_expr_payload {
 	enum nft_registers	dreg;
 	enum nft_payload_bases	base;
-	unsigned int		offset;
-	unsigned int		len;
+	uint32_t		offset;
+	uint32_t		len;
 };
 
 static int
-- 
1.7.10.4

