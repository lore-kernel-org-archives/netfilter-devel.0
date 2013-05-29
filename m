From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: xml: fix using bad temp variable
Date: Thu, 30 May 2013 00:45:06 +0200
Message-ID: <20130529224506.18081.1971.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44731 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755104Ab3E2WpK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 18:45:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a bug. It should use 'utmp' instead of 'tmp'.

Signed-off-by: Arturo Borero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index cf74888..71b10fe 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -204,7 +204,7 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 			mxmlDelete(tree);
 			return -1;
 		}
-		reg->val[i] = tmp;
+		reg->val[i] = utmp;
 	}
 
 	reg->len = sizeof(reg->val);

