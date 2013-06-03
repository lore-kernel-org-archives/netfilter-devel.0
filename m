From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: delete unreachable code
Date: Mon, 03 Jun 2013 19:15:20 +0200
Message-ID: <20130603171520.21980.39483.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45529 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288Ab3FCRP3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:15:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The deleted code is never executed, thus junk. Introduced by me in previous commit.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 12adc18..74ebe76 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -209,8 +209,6 @@ static int nft_data_reg_value_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
-	errno = EOPNOTSUPP;
-	return -1;
 }
 #endif
 

