From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: xml: fix invalid veredict validation
Date: Thu, 30 May 2013 00:46:26 +0200
Message-ID: <20130529224626.18127.15020.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44757 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966329Ab3E2Wq3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 18:46:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Other kind of validations are used all over the XML parsing code.
This validation is not valid anymore, and this patch update it.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 71b10fe..12adc18 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -64,10 +64,8 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 		return -1;
 	}
 
-	errno = 0;
 	tmp = strtoll(node->child->value.opaque, &endptr, 10);
-	if (tmp > INT_MAX || tmp < INT_MIN || errno != 0
-						|| strlen(endptr) > 0) {
+	if (tmp > INT_MAX || tmp < INT_MIN || *endptr) {
 		mxmlDelete(tree);
 		return -1;
 	}

