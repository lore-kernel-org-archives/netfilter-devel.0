From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] expr: dynset: fix json/xml parsing
Date: Mon, 13 Apr 2015 21:07:19 +0200
Message-ID: <20150413190719.26645.76710.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:39207 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751328AbbDMTH3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Apr 2015 15:07:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

expr/dynset.c: In function 'nft_rule_expr_dynset_json_parse':
expr/dynset.c:194:3: warning: implicit declaration of function 'nft_rule_expr_dynset_str' [-Wimplicit-function-declaration]
   nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
   ^
expr/dynset.c:194:31: error: 'NFT_EXPR_DYNSET_SET' undeclared (first use in this function)
   nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
                               ^
expr/dynset.c:194:31: note: each undeclared identifier is reported only once for each function it appears in
expr/dynset.c:197:3: warning: implicit declaration of function 'nft_rule_expr_dynset_u32' [-Wimplicit-function-declaration]
   nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
   ^
expr/dynset.c:197:31: error: 'NFT_EXPR_DYNSET_SREG' undeclared (first use in this function)
   nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
                               ^
expr/dynset.c:200:31: error: 'NFT_EXPR_DYNSET_DREG' undeclared (first use in this function)
   nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
                               ^
expr/dynset.c: In function 'nft_rule_expr_dynset_xml_parse':
expr/dynset.c:220:31: error: 'NFT_EXPR_DYNSET_SET' undeclared (first use in this function)
   nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
                               ^
expr/dynset.c:224:31: error: 'NFT_EXPR_DYNSET_SREG' undeclared (first use in this function)
   nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
                               ^
expr/dynset.c:228:31: error: 'NFT_EXPR_DYNSET_DREG' undeclared (first use in this function)
   nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
                               ^

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/dynset.c |   48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index a2c1946..3c61144 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -187,17 +187,28 @@ nft_rule_expr_dynset_json_parse(struct nft_rule_expr *e, json_t *root,
 {
 #ifdef JSON_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t uval32;
+	uint64_t uval64;
 
 	set_name = nft_jansson_parse_str(root, "set", err);
 	if (set_name != NULL)
-		nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
+		nft_rule_expr_set_str(e, NFT_EXPR_DYNSET_SET, set_name);
 
-	if (nft_jansson_parse_reg(root, "sreg", NFT_TYPE_U32, &sreg, err) == 0)
-		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
+	if (nft_jansson_parse_reg(root, "sreg_key",
+				  NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_SREG_KEY, uval32);
 
-	if (nft_jansson_parse_reg(root, "dreg", NFT_TYPE_U32, &dreg, err) == 0)
-		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
+	if (nft_jansson_parse_reg(root, "sreg_data",
+				  NFT_TYPE_U32, &uval32, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_SREG_DATA, uval32);
+
+	if (nft_jansson_parse_val(root, "op", NFT_TYPE_U32, &uval32,
+				  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_OP, uval32);
+
+	if (nft_jansson_parse_val(root, "timeout", NFT_TYPE_U64, &uval64,
+				  err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_DYNSET_TIMEOUT, uval64);
 
 	return 0;
 #else
@@ -212,20 +223,29 @@ nft_rule_expr_dynset_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree,
 {
 #ifdef XML_PARSING
 	const char *set_name;
-	uint32_t sreg, dreg;
+	uint32_t uval32;
+	uint64_t uval64;
 
 	set_name = nft_mxml_str_parse(tree, "set", MXML_DESCEND_FIRST,
 				      NFT_XML_MAND, err);
 	if (set_name != NULL)
-		nft_rule_expr_dynset_str(e, NFT_EXPR_DYNSET_SET, set_name);
+		nft_rule_expr_set_str(e, NFT_EXPR_DYNSET_SET, set_name);
+
+	if (nft_mxml_reg_parse(tree, "sreg_key", &uval32, MXML_DESCEND,
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_SREG_KEY, uval32);
+
+	if (nft_mxml_reg_parse(tree, "sreg_data", &uval32, MXML_DESCEND,
+			       NFT_XML_MAND, err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_SREG_DATA, uval32);
 
-	if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND, NFT_XML_MAND,
-			       err) == 0)
-		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_SREG, sreg);
+	if (nft_mxml_num_parse(tree, "op", MXML_DESCEND_FIRST, BASE_DEC,
+			       &uval32, NFT_TYPE_U32, NFT_XML_MAND,  err) == 0)
+		nft_rule_expr_set_u32(e, NFT_EXPR_DYNSET_OP, uval32);
 
-	if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT_XML_OPT,
-			       err) == 0)
-		nft_rule_expr_dynset_u32(e, NFT_EXPR_DYNSET_DREG, dreg);
+	if (nft_mxml_num_parse(tree, "timeout", MXML_DESCEND_FIRST, BASE_DEC,
+			       &uval64, NFT_TYPE_U64, NFT_XML_MAND,  err) == 0)
+		nft_rule_expr_set_u64(e, NFT_EXPR_DYNSET_TIMEOUT, uval64);
 
 	return 0;
 #else

