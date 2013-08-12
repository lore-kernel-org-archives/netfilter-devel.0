From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] xml: expr: fix mem leak in the expr parser
Date: Mon, 12 Aug 2013 14:33:35 +0200
Message-ID: <20130812123335.25249.17288.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41498 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752416Ab3HLMdm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:33:42 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id DF1B051ED7E
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 12:33:38 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yiYQLXIDhxMR for <netfilter-devel@vger.kernel.org>;
	Mon, 12 Aug 2013 14:33:38 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id A4E9451ED7A
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 14:33:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There was several mem leaks as reported by valgrind:

==23503== 3 bytes in 1 blocks are definitely lost in loss record 1 of 44
==23503==    at 0x4C28BED: malloc (vg_replace_malloc.c:263)
==23503==    by 0x56F1B41: strdup (strdup.c:43)
==23503==    by 0x4E3BE62: nft_rule_expr_exthdr_xml_parse (exthdr.c:212)
==23503==    by 0x4E3909A: nft_mxml_expr_parse (mxml.c:49)
==23503==    by 0x4E368CC: nft_rule_parse (rule.c:581)
==23503==    by 0x401462: main (nft-parsing-test.c:255)

So, once those string are used, do a free.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/byteorder.c |    3 +++
 src/expr/cmp.c       |    3 +++
 src/expr/ct.c        |    3 +++
 src/expr/data_reg.c  |    3 +++
 src/expr/exthdr.c    |    3 +++
 src/expr/lookup.c    |    1 +
 src/expr/match.c     |    1 +
 src/expr/meta.c      |    3 +++
 src/expr/nat.c       |    3 +++
 src/expr/payload.c   |    3 +++
 src/expr/target.c    |    1 +
 11 files changed, 27 insertions(+)

diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index e2d442c..d43109d 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -220,6 +220,9 @@ nft_rule_expr_byteorder_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 		return -1;
 
 	ntoh = nft_str2ntoh(op);
+
+	xfree(op);
+
 	if (ntoh < 0)
 		return -1;
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 8ca4cb5..5cc88b3 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -193,6 +193,9 @@ static int nft_rule_expr_cmp_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 		return -1;
 
 	op_value = nft_str2cmp(op);
+
+	xfree(op);
+
 	if (op_value < 0)
 		return -1;
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index f86fd4d..9af4062 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -199,6 +199,9 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree
 		return -1;
 
 	key = str2ctkey(key_str);
+
+	xfree(key_str);
+
 	if (key < 0)
 		goto err;
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 4c354ef..7a6c470 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -65,6 +65,9 @@ static int nft_data_reg_verdict_xml_parse(union nft_data_reg *reg, char *xml)
 	}
 
 	verdict = nft_str2verdict(verdict_str);
+
+	xfree(verdict_str);
+
 	if (verdict < 0) {
 		mxmlDelete(tree);
 		return -1;
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 9781232..eb70bc1 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -215,6 +215,9 @@ nft_rule_expr_exthdr_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 		return -1;
 
 	type = str2exthdr_type(exthdr_type);
+
+	xfree(exthdr_type);
+
 	if (type < 0)
 		return -1;
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index d66577b..9c7c355 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -155,6 +155,7 @@ nft_rule_expr_lookup_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 		return -1;
 
 	strncpy(lookup->set_name, set_name, IFNAMSIZ);
+	xfree(set_name);
 	lookup->set_name[IFNAMSIZ-1] = '\0';
 	e->flags |= (1 << NFT_EXPR_LOOKUP_SET);
 
diff --git a/src/expr/match.c b/src/expr/match.c
index d155bb3..be66f9a 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -181,6 +181,7 @@ static int nft_rule_expr_match_xml_parse(struct nft_rule_expr *e, mxml_node_t *t
 		return -1;
 
 	strncpy(mt->name, name, XT_EXTENSION_MAXNAMELEN);
+	xfree(name);
 	mt->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
 	e->flags |= (1 << NFT_EXPR_MT_NAME);
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 8f163f6..8aef24d 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -179,6 +179,9 @@ static int nft_rule_expr_meta_xml_parse(struct nft_rule_expr *e, mxml_node_t *tr
 		return -1;
 
 	key = str2meta_key(key_str);
+
+	xfree(key_str);
+
 	if (key < 0)
 		return -1;
 
diff --git a/src/expr/nat.c b/src/expr/nat.c
index e6866ec..8b71b82 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -209,6 +209,9 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_node_t *tre
 		return -1;
 
 	nat_type_value = nft_str2nat(nat_type);
+
+	xfree(nat_type);
+
 	if (nat_type_value < 0)
 		return -1;
 
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 340a0d8..9e91857 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -213,6 +213,9 @@ nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 		return -1;
 
 	base = nft_str2base(base_str);
+
+	xfree(base_str);
+
 	if (base < 0)
 		return -1;
 
diff --git a/src/expr/target.c b/src/expr/target.c
index 5ef53cb..4eb313e 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -182,6 +182,7 @@ nft_rule_expr_target_xml_parse(struct nft_rule_expr *e, mxml_node_t *tree)
 		return -1;
 
 	strncpy(tg->name, name, XT_EXTENSION_MAXNAMELEN);
+	xfree(name);
 	tg->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
 	e->flags |= (1 << NFT_EXPR_TG_NAME);
 

