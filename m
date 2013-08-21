From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: constify nft_*_parse input data
Date: Wed, 21 Aug 2013 14:21:28 +0200
Message-ID: <20130821122127.32150.32227.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35049 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751365Ab3HUMVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:21:40 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 0E76451ECEF
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2013 12:21:36 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PaIU-k-+ELoE for <netfilter-devel@vger.kernel.org>;
	Wed, 21 Aug 2013 14:21:30 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 795C051EC0A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2013 14:21:30 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the input string is not changing, let's make it constant.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index e80d007..52c39db 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -56,7 +56,7 @@ enum nft_chain_parse_type {
 	NFT_CHAIN_PARSE_MAX
 };
 
-int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type, char *data);
+int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type, const char *data);
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *t, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_chain_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index dd0e212..af9a0f3 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -55,7 +55,7 @@ enum nft_rule_parse_type {
 	NFT_RULE_PARSE_MAX,
 };
 
-int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, char *data);
+int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, const char *data);
 int nft_rule_snprintf(char *buf, size_t size, struct nft_rule *t, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_rule_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index e81b3ac..c55718c 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -58,7 +58,7 @@ enum nft_set_parse_type {
 	NFT_SET_PARSE_MAX,
 };
 
-int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, char *data);
+int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, const char *data);
 
 /*
  * Set elements
@@ -102,7 +102,7 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem
 
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
 
-int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type type, char *data);
+int nft_set_elem_parse(struct nft_set_elem *e, enum nft_set_parse_type type, const char *data);
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *s, uint32_t type, uint32_t flags);
 
 int nft_set_elem_foreach(struct nft_set *s, int (*cb)(struct nft_set_elem *e, void *data), void *data);
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 24ca374..1a015ca 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -44,7 +44,7 @@ enum nft_table_parse_type {
 	NFT_TABLE_PARSE_MAX,
 };
 
-int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type, char *data);
+int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type, const char *data);
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t, uint32_t type, uint32_t flags);
 
 struct nlmsghdr *nft_table_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family, uint16_t type, uint32_t seq);
diff --git a/src/chain.c b/src/chain.c
index ac6e7ad..93896c9 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -479,7 +479,7 @@ static inline int nft_str2hooknum(const char *hook)
 	return -1;
 }
 
-static int nft_chain_json_parse(struct nft_chain *c, char *json)
+static int nft_chain_json_parse(struct nft_chain *c, const char *json)
 {
 #ifdef JSON_PARSING
 	json_t *root, *node;
@@ -580,7 +580,7 @@ err:
 #endif
 }
 
-static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
+static int nft_chain_xml_parse(struct nft_chain *c, const char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
@@ -686,7 +686,7 @@ err:
 }
 
 int nft_chain_parse(struct nft_chain *c, enum nft_chain_parse_type type,
-		    char *data)
+		    const char *data)
 {
 	int ret;
 
diff --git a/src/rule.c b/src/rule.c
index 98e7940..98c2022 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -475,7 +475,7 @@ int nft_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_rule *r)
 }
 EXPORT_SYMBOL(nft_rule_nlmsg_parse);
 
-static int nft_rule_json_parse(struct nft_rule *r, char *json)
+static int nft_rule_json_parse(struct nft_rule *r, const char *json)
 {
 #ifdef JSON_PARSING
 	json_t *root, *node, *array;
@@ -562,7 +562,7 @@ err:
 #endif
 }
 
-static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
+static int nft_rule_xml_parse(struct nft_rule *r, const char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree, *node, *save;
@@ -668,7 +668,8 @@ err:
 #endif
 }
 
-int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type, char *data)
+int nft_rule_parse(struct nft_rule *r, enum nft_rule_parse_type type,
+		   const char *data)
 {
 	int ret;
 
diff --git a/src/set.c b/src/set.c
index ff34bf5..3617265 100644
--- a/src/set.c
+++ b/src/set.c
@@ -303,7 +303,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
 
-static int nft_set_xml_parse(struct nft_set *s, char *xml)
+static int nft_set_xml_parse(struct nft_set *s, const char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
@@ -406,7 +406,8 @@ err:
 #endif
 }
 
-int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type, char *data)
+int nft_set_parse(struct nft_set *s, enum nft_set_parse_type type,
+		  const char *data)
 {
 	int ret;
 
diff --git a/src/set_elem.c b/src/set_elem.c
index c3ac1da..2b2e414 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -417,7 +417,7 @@ int nft_mxml_set_elem_parse(mxml_node_t *tree, struct nft_set_elem *e)
 }
 #endif
 
-static int nft_set_elem_xml_parse(struct nft_set_elem *e, char *xml)
+static int nft_set_elem_xml_parse(struct nft_set_elem *e, const char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
@@ -447,7 +447,7 @@ err:
 }
 
 int nft_set_elem_parse(struct nft_set_elem *e,
-		       enum nft_set_parse_type type, char *data) {
+		       enum nft_set_parse_type type, const char *data) {
 	int ret;
 
 	switch (type) {
diff --git a/src/table.c b/src/table.c
index b51a383..a096da7 100644
--- a/src/table.c
+++ b/src/table.c
@@ -218,7 +218,7 @@ int nft_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_table *t)
 }
 EXPORT_SYMBOL(nft_table_nlmsg_parse);
 
-static int nft_table_xml_parse(struct nft_table *t, char *xml)
+static int nft_table_xml_parse(struct nft_table *t, const char *xml)
 {
 #ifdef XML_PARSING
 	mxml_node_t *tree;
@@ -266,7 +266,7 @@ err:
 #endif
 }
 
-static int nft_table_json_parse(struct nft_table *t, char *json)
+static int nft_table_json_parse(struct nft_table *t, const char *json)
 {
 #ifdef JSON_PARSING
 	json_t *root, *node;
@@ -312,7 +312,7 @@ err:
 }
 
 int nft_table_parse(struct nft_table *t, enum nft_table_parse_type type,
-		    char *data)
+		    const char *data)
 {
 	int ret;
 

