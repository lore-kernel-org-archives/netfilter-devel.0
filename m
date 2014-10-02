From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 3/3] tests: also test nat's flags attribute
Date: Thu, 02 Oct 2014 13:58:47 +0200
Message-ID: <20141002115847.10972.33892.stgit@nfdev.cica.es>
References: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, anayrey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59090 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbaJBL6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:58:55 -0400
In-Reply-To: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nat expression has a new attribute. Let's give some testing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/jsonfiles/33-rule-nat6.json |    2 +-
 tests/nft-expr_nat-test.c         |    4 ++++
 tests/xmlfiles/33-rule-nat4.xml   |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/jsonfiles/33-rule-nat6.json b/tests/jsonfiles/33-rule-nat6.json
index e5d8c8f..a76eb71 100644
--- a/tests/jsonfiles/33-rule-nat6.json
+++ b/tests/jsonfiles/33-rule-nat6.json
@@ -1 +1 @@
-{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4}]}}]}
+{"nftables":[{"rule":{"family":"ip6","table":"nat","chain":"output","handle":33,"expr":[{"type":"nat","nat_type":"snat","family":"ip6","sreg_addr_min":1,"sreg_addr_max":2,"sreg_proto_min":3,"sreg_proto_max":4,"flags":12}]}}]}
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 64966b2..8982b98 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -49,6 +49,9 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_REG_PROTO_MAX) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_REG_PROTO_MAX))
 		print_err("Expr NFT_EXPR_NAT_REG_PROTO_MAX mismatches");
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_NAT_FLAGS) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_NAT_FLAGS))
+		print_err("Expr NFT_EXPR_NAT_FLAGS mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -74,6 +77,7 @@ int main(int argc, char *argv[])
 	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_ADDR_MAX, 0x1234568);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_PROTO_MIN, 0x1234568);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_REG_PROTO_MAX, 0x1234568);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_NAT_FLAGS, 0x1234568);
 
 	nft_rule_add_expr(a, ex);
 
diff --git a/tests/xmlfiles/33-rule-nat4.xml b/tests/xmlfiles/33-rule-nat4.xml
index 73c5b56..233c44e 100644
--- a/tests/xmlfiles/33-rule-nat4.xml
+++ b/tests/xmlfiles/33-rule-nat4.xml
@@ -1 +1 @@
-<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max></expr></rule></nftables>
+<nftables><rule><family>ip</family><table>filter</table><chain>INPUT</chain><handle>100</handle><expr type="nat"><type>dnat</type><family>ip</family><sreg_addr_min>1</sreg_addr_min><sreg_addr_max>2</sreg_addr_max><sreg_proto_min>3</sreg_proto_min><sreg_proto_max>4</sreg_proto_max><flags>12</flags></expr></rule></nftables>

