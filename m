From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 06/21] nat: xml: change nat types string to
	dnat/snat
Date: Wed, 26 Jun 2013 13:37:03 +0200
Message-ID: <20130626113703.23511.73236.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54667 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752018Ab3FZLhL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:11 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces the string NFT_NAT_{S|D}NAT with {s|d}nat in the <type> node.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/nat.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 501f20c..f38011a 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -236,9 +236,9 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	if (strcmp(node->child->value.opaque, "NFT_NAT_SNAT") == 0) {
+	if (strcmp(node->child->value.opaque, "snat") == 0) {
 		nat->type = NFT_NAT_SNAT;
-	} else if (strcmp(node->child->value.opaque, "NFT_NAT_DNAT") == 0) {
+	} else if (strcmp(node->child->value.opaque, "dnat") == 0) {
 		nat->type = NFT_NAT_DNAT;
 	} else {
 		mxmlDelete(tree);
@@ -332,18 +332,15 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 	struct nft_expr_nat *nat = (struct nft_expr_nat *)e->data;
 	int len = size, offset = 0, ret = 0;
 
-	switch (nat->type) {
-	case NFT_NAT_SNAT:
-		ret = snprintf(buf, len,
-			"<type>NFT_NAT_SNAT</type>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		break;
-	case NFT_NAT_DNAT:
-		ret = snprintf(buf, len,
-			"<type>NFT_NAT_DNAT</type>");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		break;
-	}
+	/* Is a mandatory element. Provide a default, even empty */
+	if (nat->type == NFT_NAT_SNAT)
+		ret = snprintf(buf, len, "<type>snat</type>");
+	else if (nat->type == NFT_NAT_DNAT)
+		ret = snprintf(buf, len, "<type>dnat</type>");
+	else
+		ret = snprintf(buf, len, "<type/>");
+
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<family>%s</family>",
 		       nft_family2str(nat->family));

