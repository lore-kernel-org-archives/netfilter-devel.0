From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] data_reg: xml: delete unreachable code in
	_veredict_xml_parse()
Date: Sat, 08 Jun 2013 16:02:33 +0200
Message-ID: <20130608140233.2361.71553.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49503 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751734Ab3FHOCn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 10:02:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code was unreachable.

There was a similar commit fixing a similar code which didn't fix this (414ac29).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/data_reg.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index a7511a7..5eb7f38 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -76,8 +76,6 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 
 	mxmlDelete(tree);
 	return 0;
-	errno = EOPNOTSUPP;
-	return -1;
 }
 
 static int nft_data_reg_chain_xml_parse(union nft_data_reg *reg, char *xml)

