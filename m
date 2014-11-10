From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] expr: nat: use 'nat_type' instead of 'type' in the parser
Date: Mon, 10 Nov 2014 14:26:17 +0100
Message-ID: <1415625979-29079-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaKJNYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:24:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'type' is already used from the expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/nat.c                  |    2 +-
 tests/xmlfiles/32-rule-nat6.xml |    2 +-
 tests/xmlfiles/33-rule-nat4.xml |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 811286c..60623a6 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -284,7 +284,7 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 	uint32_t reg_addr_min, reg_addr_max;
 	uint32_t reg_proto_min, reg_proto_max;
 
-	nat_type = nft_mxml_str_parse(tree, "type", MXML_DESCEND_FIRST,
+	nat_type = nft_mxml_str_parse(tree, "nat_type", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
 	if (nat_type == NULL)
 		return -1;
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index f96b7d8..8fc52e8 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1 +1 @@
-<nftables><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><type>snat</type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
+<nftables><rule><family>ip6</family><table>nat</table><chain>OUTPUT</chain><handle>100</handle><expr type="nat"><nat_type>snat</nat_type><family>ip6</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index 233c44e..b7b6cb6 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><nat_type>dnat</nat_type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></nftables>
-- 
1.7.10.4

