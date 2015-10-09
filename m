From: Vijay Subramanian <subramanian.vijay@gmail.com>
Subject: [PATCH libnftnl] Fix compilation with JSON and XML parsing enabled
Date: Fri,  9 Oct 2015 12:21:07 -0700
Message-ID: <1444418467-18610-1-git-send-email-subramanian.vijay@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Vijay Subramanian <subramanian.vijay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34527 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbbJITVS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 15:21:18 -0400
Received: by qgez77 with SMTP id z77so77491144qge.1
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2015 12:21:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix missing/incorrect variables.
Also remove unsed variables to avoid warnings.

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
---
 src/expr/dup.c   |   13 +++++--------
 src/expr/limit.c |    2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/src/expr/dup.c b/src/expr/dup.c
index d0fa35f..217450a 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -115,18 +115,16 @@ static int nftnl_expr_dup_json_parse(struct nftnl_expr *e, json_t *root,
 				     struct nftnl_parse_err *err)
 {
 #ifdef JSON_PARSING
-	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 	uint32_t sreg_addr, sreg_dev;
-	int datareg_type;
+	int ret = 0;
 
-	ret = nftnl_jansson_parse_val(root, "sreg_addr", NFT_TYPE_U32, &sreg_addr, err);
+	ret = nftnl_jansson_parse_val(root, "sreg_addr", NFTNL_TYPE_U32, &sreg_addr, err);
 	if (ret >= 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_addr);
-	ret = nftnl_jansson_parse_val(root, "sreg_dev", NFT_TYPE_U32, &sreg_dev, err);
+	ret = nftnl_jansson_parse_val(root, "sreg_dev", NFTNL_TYPE_U32, &sreg_dev, err);
 	if (ret >= 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_dev);
 
-
 	return 0;
 #else
 	errno = EOPNOTSUPP;
@@ -138,14 +136,13 @@ static int nftnl_expr_dup_xml_parse(struct nftnl_expr *e, mxml_node_t *tree,
 				    struct nftnl_parse_err *err)
 {
 #ifdef XML_PARSING
-	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 	uint32_t sreg_addr, sreg_dev;
 
 	if (nftnl_mxml_reg_parse(tree, "sreg_addr", &sreg_addr, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) == 0)
+			       NFTNL_XML_OPT, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_ADDR, sreg_addr);
 	if (nftnl_mxml_reg_parse(tree, "sreg_dev", &sreg_dev, MXML_DESCEND_FIRST,
-			       NFT_XML_OPT, err) == 0)
+			       NFTNL_XML_OPT, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_DUP_SREG_DEV, sreg_dev);
 
 	return 0;
diff --git a/src/expr/limit.c b/src/expr/limit.c
index ef7c17f..ab9ceff 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -189,7 +189,7 @@ static int nftnl_expr_limit_xml_parse(struct nftnl_expr *e,
 			       &burst, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_BURST, burst);
 	if (nftnl_mxml_num_parse(tree, "type", MXML_DESCEND_FIRST, BASE_DEC,
-			       &burst, NFT_TYPE_U32, NFTNL_XML_MAND, err) == 0)
+			       &type, NFTNL_TYPE_U32, NFTNL_XML_MAND, err) == 0)
 		nftnl_expr_set_u32(e, NFTNL_EXPR_LIMIT_TYPE, type);
 
 	return 0;
-- 
1.7.9.5

