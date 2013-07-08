From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] bitwise: xml: export len node
Date: Mon, 08 Jul 2013 13:52:31 +0200
Message-ID: <20130708115231.19363.2980.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42447 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751918Ab3GHLwt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:52:49 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BCC1D51ED96
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2013 11:52:38 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bWXgBZn5E+S for <netfilter-devel@vger.kernel.org>;
	Mon,  8 Jul 2013 13:52:33 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 8A2F751ED91
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2013 13:52:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The len unsigned int was not being exported in XML.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/bitwise.c                 |    5 +++--
 tests/xmlfiles/20-rule-bitwise.xml |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 67c120f..52fc648 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -280,8 +280,9 @@ nft_rule_expr_bitwise_snprintf_xml(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "<sreg>%u</sreg>"
-				"<dreg>%u</dreg>",
-		       bitwise->sreg, bitwise->dreg);
+				"<dreg>%u</dreg>"
+				"<len>%u</len>",
+		       bitwise->sreg, bitwise->dreg, bitwise->len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = snprintf(buf+offset, len, "<mask>");
diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index 411e28f..ce2d851 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -3,6 +3,7 @@
   <expr type="bitwise">
     <sreg>2</sreg>
     <dreg>2</dreg>
+    <len>16</len>
     <mask>
       <data_reg type="value">
         <len>16</len>

