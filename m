From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] expr: nat: add helper function to translate nat
	types to string
Date: Fri, 20 Jun 2014 10:55:08 +0200
Message-ID: <20140620085508.12697.41817.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: anarey@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45229 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934307AbaFTIzS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:55:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a helper functon to translate nat types to string.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 0136fca..c719b6c 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -184,6 +184,18 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
 				 htonl(nat->sreg_proto_max));
 }
 
+static inline const char *nft_nat2str(uint16_t nat)
+{
+	switch (nat) {
+	case NFT_NAT_SNAT:
+		return "snat";
+	case NFT_NAT_DNAT:
+		return "dnat";
+	default:
+		return "unknown";
+	}
+}
+
 static inline int nft_str2nat(const char *nat)
 {
 	if (strcmp(nat, "snat") == 0)
@@ -304,11 +316,8 @@ nft_rule_expr_nat_snprintf_json(char *buf, size_t size,
 	struct nft_expr_nat *nat = nft_expr_data(e);
 	int len = size, offset = 0, ret = 0;
 
-	if (nat->type == NFT_NAT_SNAT)
-		ret = snprintf(buf, len, "\"nat_type\":\"snat\",");
-	else if (nat->type == NFT_NAT_DNAT)
-		ret = snprintf(buf, len, "\"nat_type\":\"dnat\",");
-
+	ret = snprintf(buf, len, "\"nat_type\":\"%s\",",
+		       nft_nat2str(nat->type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "\"family\":\"%s\",",
@@ -340,14 +349,7 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_nat *nat = nft_expr_data(e);
 	int len = size, offset = 0, ret = 0;
 
-	/* Is a mandatory element. Provide a default, even empty */
-	if (nat->type == NFT_NAT_SNAT)
-		ret = snprintf(buf, len, "<type>snat</type>");
-	else if (nat->type == NFT_NAT_DNAT)
-		ret = snprintf(buf, len, "<type>dnat</type>");
-	else
-		ret = snprintf(buf, len, "<type>unknown</type>");
-
+	ret = snprintf(buf, len, "<type>%s</type>", nft_nat2str(nat->type));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<family>%s</family>",
@@ -380,16 +382,8 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 	struct nft_expr_nat *nat = nft_expr_data(e);
 	int len = size, offset = 0, ret = 0;
 
-	switch (nat->type) {
-	case NFT_NAT_SNAT:
-		ret = snprintf(buf, len, "snat ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		break;
-	case NFT_NAT_DNAT:
-		ret = snprintf(buf, len, "dnat ");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		break;
-	}
+	ret = snprintf(buf, len, "%s ", nft_nat2str(nat->type));
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "%s ", nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);

