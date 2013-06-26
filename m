From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 04/21] bitwise: xml: mask and xor use same number
	of data registers
Date: Wed, 26 Jun 2013 13:37:00 +0200
Message-ID: <20130626113700.23511.8040.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54658 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817Ab3FZLhJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:09 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The mask and xor must use the same number of data registers.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index fa2fc5a..6932086 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -298,6 +298,16 @@ nft_rule_expr_bitwise_xml_parse(struct nft_rule_expr *e, char *xml)
 	bitwise->xor.len = data_regtmp.len;
 	e->flags |= (1 << NFT_EXPR_BITWISE_XOR);
 
+	/* Additional validation: mask and xor must use the same number of
+	 * data registers.
+	 */
+
+	if (bitwise->mask.len != bitwise->xor.len) {
+		mxmlDelete(tree);
+		return -1;
+	}
+
+
 	mxmlDelete(tree);
 	return 0;
 #else

