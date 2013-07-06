From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] set: add xml output
Date: Sat, 06 Jul 2013 02:39:52 +0200
Message-ID: <20130706003952.14469.97245.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52737 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670Ab3GFAkD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 20:40:03 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 61D3F51ED66
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jul 2013 00:40:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eejVsEVpH7tz for <netfilter-devel@vger.kernel.org>;
	Sat,  6 Jul 2013 02:39:55 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id A5E4951ED5E
	for <netfilter-devel@vger.kernel.org>; Sat,  6 Jul 2013 02:39:53 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds XML output for sets.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-set-elem-get.c |    5 +++
 examples/nft-set-get.c      |    4 ++-
 include/libnftables/set.h   |    1 +
 src/internal.h              |    1 +
 src/set.c                   |   45 ++++++++++++++++++++++++++++-
 src/set_elem.c              |   66 ++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 353a752..806cdc6 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -56,7 +56,8 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc < 4 || argc > 5) {
-		fprintf(stderr, "%s <family> <table> <set> [default|json]\n", argv[0]);
+		fprintf(stderr, "%s <family> <table> <set> [{json|xml}]\n",
+			argv[0]);
 		return EXIT_FAILURE;
 	}
 	t = nft_set_alloc();
@@ -78,6 +79,8 @@ int main(int argc, char *argv[])
 
 	if (argc == 5 && strcmp(argv[4], "json") == 0 )
 		type = NFT_SET_O_JSON;
+	else if (argc == 5 && strcmp(argv[4], "xml") == 0)
+		type = NFT_SET_O_XML;
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 5ef654c..6a3b7dc 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -56,7 +56,7 @@ int main(int argc, char *argv[])
 	int ret;
 
 	if (argc < 3 || argc > 4) {
-		fprintf(stderr, "%s <family> <table> [default|json]\n", argv[0]);
+		fprintf(stderr, "%s <family> <table> [{json|xml}]\n", argv[0]);
 		return EXIT_FAILURE;
 	}
 	t = nft_set_alloc();
@@ -78,6 +78,8 @@ int main(int argc, char *argv[])
 
 	if (argc == 4 && strcmp(argv[3], "json") == 0)
 		type = NFT_SET_O_JSON;
+	else if (argc == 4 && strcmp(argv[3], "xml") == 0)
+		type = NFT_SET_O_XML;
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 					NLM_F_DUMP|NLM_F_ACK, seq);
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 2d41c8e..5c77945 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -64,6 +64,7 @@ enum {
 
 enum {
 	NFT_SET_O_DEFAULT	= 0,
+	NFT_SET_O_XML,
 	NFT_SET_O_JSON,
 };
 
diff --git a/src/internal.h b/src/internal.h
index d5d41bd..803dcc4 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -24,6 +24,7 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, const char *node_name, union nft_
 #define NFT_TABLE_XML_VERSION 0
 #define NFT_CHAIN_XML_VERSION 0
 #define NFT_RULE_XML_VERSION 0
+#define NFT_SET_XML_VERSION 0
 #define NFT_TABLE_JSON_VERSION 0
 #define NFT_CHAIN_JSON_VERSION 0
 #define NFT_RULE_JSON_VERSION 0
diff --git a/src/set.c b/src/set.c
index 4f2e8a5..8844dfd 100644
--- a/src/set.c
+++ b/src/set.c
@@ -16,6 +16,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
+#include <limits.h>
+#include <errno.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -355,7 +357,7 @@ static int nft_set_snprintf_json(char *buf, size_t size, struct nft_set *s,
 }
 
 static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
-			      uint32_t type, uint32_t flags)
+				    uint32_t type, uint32_t flags)
 {
 	int ret;
 	int len = size, offset = 0;
@@ -383,12 +385,51 @@ static int nft_set_snprintf_default(char *buf, size_t size, struct nft_set *s,
 	return offset;
 }
 
+static int nft_set_snprintf_xml(char *buf, size_t size, struct nft_set *s,
+				uint32_t flags)
+{
+	int ret;
+	int len = size, offset = 0;
+	struct nft_set_elem *elem;
+
+	ret = snprintf(buf, size,
+		       "<set name=\"%s\" table=\"%s\" version=\"%d\">",
+		       s->name, s->table, NFT_SET_XML_VERSION);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, size, "<family>%s</family>"
+					"<set_flags>%u</set_flags>"
+					"<key_type>%u</key_type>"
+					"<key_len>%u</key_len>"
+					"<data_type>%u</data_type>"
+					"<data_len>%u</data_len>",
+			nft_family2str(s->family),
+			s->set_flags, s->key_type, s->key_len,
+			s->data_type, s->data_len);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (!list_empty(&s->element_list)) {
+		list_for_each_entry(elem, &s->element_list, head) {
+			ret = nft_set_elem_snprintf(buf+offset, size, elem,
+						    NFT_SET_O_XML, flags);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+	}
+
+	ret = snprintf(buf+offset, size, "</set>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 int nft_set_snprintf(char *buf, size_t size, struct nft_set *s,
-		      uint32_t type, uint32_t flags)
+		     uint32_t type, uint32_t flags)
 {
 	switch(type) {
 	case NFT_SET_O_DEFAULT:
 		return nft_set_snprintf_default(buf, size, s, type, flags);
+	case NFT_SET_O_XML:
+		return nft_set_snprintf_xml(buf, size, s, flags);
 	case NFT_SET_O_JSON:
 		return nft_set_snprintf_json(buf, size, s, type, flags);
 	default:
diff --git a/src/set_elem.c b/src/set_elem.c
index c5c3de4..d455ced 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -16,12 +16,14 @@
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
+#include <errno.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftables/set.h>
+#include <libnftables/rule.h>
 
 #include "linux_list.h"
 #include "expr/data_reg.h"
@@ -418,7 +420,8 @@ static int nft_set_elem_snprintf_json(char *buf, size_t size, struct nft_set_ele
 	return offset;
 }
 
-static int nft_set_elem_snprintf_default(char *buf, size_t size, struct nft_set_elem *e)
+static int nft_set_elem_snprintf_default(char *buf, size_t size,
+					 struct nft_set_elem *e)
 {
 	int ret, len = size, offset = 0, i;
 
@@ -444,12 +447,73 @@ static int nft_set_elem_snprintf_default(char *buf, size_t size, struct nft_set_
 	return offset;
 }
 
+static int nft_set_elem_snprintf_xml(char *buf, size_t size,
+				     struct nft_set_elem *e, uint32_t flags)
+{
+	int ret, len = size, offset = 0;
+
+	ret = snprintf(buf, size, "<set_elem>"
+				"<set_elem_flags>%u</set_elem_flags>",
+				e->set_elem_flags);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, size, "<set_elem_key>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
+				    NFT_RULE_O_XML, flags, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf+offset, size, "</set_elem_key>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA)) {
+		ret = snprintf(buf+offset, size, "<set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
+					    NFT_RULE_O_XML, flags, DATA_VALUE);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, size, "</set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (e->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT)) {
+		ret = snprintf(buf+offset, size, "<set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
+					    NFT_RULE_O_XML, flags,
+					    DATA_VERDICT);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, size, "</set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	} else if (e->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN)) {
+		ret = snprintf(buf+offset, size, "<set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = nft_data_reg_snprintf(buf+offset, len, &e->data,
+					    NFT_RULE_O_XML, flags, DATA_CHAIN);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret = snprintf(buf+offset, size, "</set_elem_data>");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	ret = snprintf(buf+offset, size, "</set_elem>");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
 int nft_set_elem_snprintf(char *buf, size_t size, struct nft_set_elem *e,
 			   uint32_t type, uint32_t flags)
 {
 	switch(type) {
 	case NFT_SET_O_DEFAULT:
 		return nft_set_elem_snprintf_default(buf, size, e);
+	case NFT_SET_O_XML:
+		return nft_set_elem_snprintf_xml(buf, size, e, flags);
 	case NFT_SET_O_JSON:
 		return nft_set_elem_snprintf_json(buf, size, e);
 	default:

