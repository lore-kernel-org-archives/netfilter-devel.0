From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] nat: xml: fix wrong node name in snprintf
Date: Mon, 12 Aug 2013 09:35:39 +0200
Message-ID: <20130812073539.20663.65637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59743 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754243Ab3HLHfs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:35:48 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 32B3251ED6E
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 07:35:47 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d38uZCvtwwaX for <netfilter-devel@vger.kernel.org>;
	Mon, 12 Aug 2013 09:35:42 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 2FA1051ED78
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 09:35:42 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch renames all <nat_type> nodes to <type> in nat expr.
A bug is fixed, since the default option in snprintf was already
<type>.

This follows the pattern of avoid prefixing XML nodes.

Note that this is mostly reverting what was done at:
31e34c3 (nat: xml: rename node type to nat_type).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/32-rule-nat6.xml |    2 +-
 tests/xmlfiles/33-rule-nat4.xml |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index c81dc7f..e6866ec 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -204,7 +204,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	int32_t reg;
 	int family, nat_type_value;
 
-	nat_type = nft_mxml_str_parse(tree, "nat_type", MXML_DESCEND_FIRST);
+	nat_type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST);
 	if (nat_type == NULL)
 		return -1;
 
@@ -306,9 +306,9 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 
 	/* Is a mandatory element. Provide a default, even empty */
 	if (nat->type == NFT_NAT_SNAT)
-		ret = snprintf(buf, len, "<nat_type>snat</nat_type>");
+		ret = snprintf(buf, len, "<type>snat</type>");
 	else if (nat->type == NFT_NAT_DNAT)
-		ret = snprintf(buf, len, "<nat_type>dnat</nat_type>");
+		ret = snprintf(buf, len, "<type>dnat</type>");
 	else
 		ret = snprintf(buf, len, "<type>unknown</type>");
 
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index 1834bff..16dcfb0 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1 +1 @@
-<rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><family>ip6</family><nat_type>snat</nat_type><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
+<rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index ac4d7d2..8ac5238 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><family>ip</family><nat_type>dnat</nat_type></expr></rule>
+<rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><flags>0</flags><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule>

