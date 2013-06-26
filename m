From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 02/21] src: xml: convert family values to string
Date: Wed, 26 Jun 2013 13:36:58 +0200
Message-ID: <20130626113658.23511.31451.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54649 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911Ab3FZLhH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:07 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch translates all family values all around the code to show a string:
 * ip if AF_INET
 * ip6 if AF_INET6
 * bridge if AF_BRIDGE
 * arp if 0

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/Makefile.am           |    3 ++-
 src/chain.c               |   24 ++++++++++++----------
 src/expr/nat.c            |   12 ++++-------
 src/internal.h            |    3 +++
 src/rule.c                |   13 ++++++------
 src/table.c               |   24 ++++++++++------------
 src/utils.c               |   49 +++++++++++++++++++++++++++++++++++++++++++++
 test/nft-chain-xml-add.sh |    6 +++---
 test/nft-rule-xml-add.sh  |    3 +--
 test/nft-table-xml-add.sh |    4 ++--
 10 files changed, 94 insertions(+), 47 deletions(-)
 create mode 100644 src/utils.c

diff --git a/src/Makefile.am b/src/Makefile.am
index 4017720..4649646 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -4,7 +4,8 @@ lib_LTLIBRARIES = libnftables.la
 libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBXML_LIBS}
 libnftables_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftables.map \
 			 -version-info $(LIBVERSION)
-libnftables_la_SOURCES = table.c		\
+libnftables_la_SOURCES = utils.c		\
+			 table.c		\
 			 chain.c		\
 			 rule.c			\
 			 set.c			\
diff --git a/src/chain.c b/src/chain.c
index f3ba532..ce9bb1b 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -675,13 +675,13 @@ static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 		mxmlDelete(tree);
 		return -1;
 	}
-	utmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (utmp > UINT8_MAX || utmp < 0 || *endptr) {
+
+	if (nft_str2family(node->child->value.opaque) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	c->family = (uint32_t)utmp;
+	c->family = nft_str2family(node->child->value.opaque);
 	c->flags |= (1 << NFT_CHAIN_ATTR_FAMILY);
 
 	mxmlDelete(tree);
@@ -727,14 +727,14 @@ static int nft_chain_snprintf_json(char *buf, size_t size, struct nft_chain *c)
 				"\"use\" : %d,"
 				"\"hooknum\" : %s,"
 				"\"policy\" : %d,"
-				"\"family\" : %d"
+				"\"family\" : %s"
 			"}"
 		"}"
 		"}",
 			c->name, c->handle, c->bytes, c->packets,
 			NFT_CHAIN_JSON_VERSION, c->type, c->table,
 			c->prio, c->use, hooknum2str_array[c->hooknum],
-			c->policy, c->family);
+			c->policy, nft_family2str(c->family));
 }
 
 static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
@@ -749,22 +749,24 @@ static int nft_chain_snprintf_xml(char *buf, size_t size, struct nft_chain *c)
 				"<use>%d</use>"
 				"<hooknum>%s</hooknum>"
 				"<policy>%d</policy>"
-				"<family>%d</family>"
+				"<family>%s</family>"
 			"</properties>"
 		"</chain>",
 			c->name, c->handle, c->bytes, c->packets,
 			NFT_CHAIN_XML_VERSION, c->type, c->table,
 			c->prio, c->use, hooknum2str_array[c->hooknum],
-			c->policy, c->family);
+			c->policy, nft_family2str(c->family));
 }
 
-static int nft_chain_snprintf_default(char *buf, size_t size, struct nft_chain *c)
+static int nft_chain_snprintf_default(char *buf, size_t size,
+				      struct nft_chain *c)
 {
-	return snprintf(buf, size, "family=%u table=%s chain=%s type=%s "
+	return snprintf(buf, size, "family=%s table=%s chain=%s type=%s "
 				   "hook=%u prio=%d policy=%d use=%d "
 				   "packets=%lu bytes=%lu",
-			c->family, c->table, c->name, c->type, c->hooknum,
-			c->prio, c->policy, c->use, c->packets, c->bytes);
+			nft_family2str(c->family), c->table, c->name, c->type,
+			c->hooknum, c->prio, c->policy, c->use, c->packets,
+			c->bytes);
 }
 
 int nft_chain_snprintf(char *buf, size_t size, struct nft_chain *c,
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 7c4cf37..501f20c 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -254,15 +254,12 @@ static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, char *xml)
 		return -1;
 	}
 
-	if (strcmp(node->child->value.opaque, "AF_INET") == 0) {
-		nat->family = AF_INET;
-	} else if (strcmp(node->child->value.opaque, "AF_INET6") == 0) {
-		nat->family = AF_INET6;
-	} else {
+	if (nft_str2family(node->child->value.opaque) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
+	nat->family = nft_str2family(node->child->value.opaque);
 	e->flags |= (1 << NFT_EXPR_NAT_FAMILY);
 
 	/* Get and set <sreg_addr_min_v4>. Not mandatory */
@@ -349,7 +346,7 @@ nft_rule_expr_nat_snprintf_xml(char *buf, size_t size,
 	}
 
 	ret = snprintf(buf+offset, len, "<family>%s</family>",
-		       nat->family == AF_INET ? "AF_INET" : "AF_INET6");
+		       nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
@@ -389,8 +386,7 @@ nft_rule_expr_nat_snprintf_default(char *buf, size_t size,
 		break;
 	}
 
-	ret = snprintf(buf, len, "family=%s ",
-		       nat->family == AF_INET ? "AF_INET" : "AF_INET6");
+	ret = snprintf(buf, len, "family=%s ", nft_family2str(nat->family));
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (e->flags & (1 << NFT_EXPR_NAT_REG_ADDR_MIN)) {
diff --git a/src/internal.h b/src/internal.h
index fffca3d..23a3e59 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -23,6 +23,9 @@
 #define NFT_TABLE_JSON_VERSION 0
 #define NFT_CHAIN_JSON_VERSION 0
 
+const char *nft_family2str(uint32_t family);
+int nft_str2family(const char *family);
+
 struct expr_ops;
 
 struct nft_rule_expr {
diff --git a/src/rule.c b/src/rule.c
index 6058878..380b9ae 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -509,13 +509,12 @@ static int nft_rule_xml_parse(struct nft_rule *r, char *xml)
 		return -1;
 	}
 
-	tmp = strtoull(mxmlElementGetAttr(tree, "family"), &endptr, 10);
-	if (tmp > UINT8_MAX || tmp < 0 || *endptr) {
+	if (nft_str2family(mxmlElementGetAttr(tree, "family")) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	r->family = (uint8_t)tmp;
+	r->family = nft_str2family(mxmlElementGetAttr(tree, "family"));
 	r->flags |= (1 << NFT_RULE_ATTR_FAMILY);
 
 	/* get and set <rule ... table=X ...> */
@@ -678,9 +677,9 @@ static int nft_rule_snprintf_xml(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 
 	ret = snprintf(buf, size,
-		"<rule family=\"%u\" table=\"%s\" "
+		"<rule family=\"%s\" table=\"%s\" "
 			"chain=\"%s\" handle=\"%llu\" version=\"%d\">",
-				r->family, r->table, r->chain,
+				nft_family2str(r->family), r->table, r->chain,
 				(unsigned long long)r->handle,
 				NFT_RULE_XML_VERSION);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -716,9 +715,9 @@ static int nft_rule_snprintf_default(char *buf, size_t size, struct nft_rule *r,
 	struct nft_rule_expr *expr;
 	int ret, len = size, offset = 0;
 
-	ret = snprintf(buf, size, "family=%u table=%s chain=%s handle=%llu "
+	ret = snprintf(buf, size, "family=%s table=%s chain=%s handle=%llu "
 				  "flags=%x ",
-			r->family, r->table, r->chain,
+			nft_family2str(r->family), r->table, r->chain,
 			(unsigned long long)r->handle, r->rule_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
diff --git a/src/table.c b/src/table.c
index 4533e23..211acdf 100644
--- a/src/table.c
+++ b/src/table.c
@@ -275,13 +275,12 @@ static int nft_table_xml_parse(struct nft_table *t, char *xml)
 		return -1;
 	}
 
-	tmp = strtoull(node->child->value.opaque, &endptr, 10);
-	if (tmp > UINT32_MAX || *endptr || tmp < 0) {
+	if (nft_str2family(node->child->value.opaque) < 0) {
 		mxmlDelete(tree);
 		return -1;
 	}
 
-	t->family = (uint32_t)tmp;
+	t->family = nft_str2family(node->child->value.opaque);
 	t->flags |= (1 << NFT_TABLE_ATTR_FAMILY);
 
 	/* Get and set <table_flags> */
@@ -335,32 +334,31 @@ static int nft_table_snprintf_json(char *buf, size_t size, struct nft_table *t)
 			"\"name\" : \"%s\","
 			"\"version\" : %d,"
 			"\"properties\" : {"
-				"\"family\" : %u,"
+				"\"family\" : %s,"
 				"\"table_flags\" : %d"
 				"}"
 			"}"
 			"}" ,
 			t->name, NFT_TABLE_JSON_VERSION,
-			t->family, t->table_flags);
+			nft_family2str(t->family), t->table_flags);
 }
 
 static int nft_table_snprintf_xml(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size,
-			"<table name=\"%s\" version=\"%d\">"
+	return snprintf(buf, size, "<table name=\"%s\" version=\"%d\">"
 				"<properties>"
-					"<family>%u</family>"
+					"<family>%s</family>"
 					"<table_flags>%d</table_flags>"
 				"</properties>"
-			"</table>" ,
-			t->name, NFT_TABLE_XML_VERSION,
-			t->family, t->table_flags);
+				"</table>",
+		       t->name, NFT_TABLE_XML_VERSION,
+		       nft_family2str(t->family), t->table_flags);
 }
 
 static int nft_table_snprintf_default(char *buf, size_t size, struct nft_table *t)
 {
-	return snprintf(buf, size, "table=%s family=%u flags=%x",
-			t->name, t->family, t->table_flags);
+	return snprintf(buf, size, "table=%s family=%s flags=%x",
+			t->name, nft_family2str(t->family), t->table_flags);
 }
 
 int nft_table_snprintf(char *buf, size_t size, struct nft_table *t,
diff --git a/src/utils.c b/src/utils.c
new file mode 100644
index 0000000..e4463f1
--- /dev/null
+++ b/src/utils.c
@@ -0,0 +1,49 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <internal.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <stdint.h>
+#include <arpa/inet.h>
+
+const char *nft_family2str(uint32_t family)
+{
+	switch (family) {
+	case AF_INET:
+		return "ip";
+	case AF_INET6:
+		return "ip6";
+	case AF_BRIDGE:
+		return "bridge";
+	case 0:
+		return "arp";
+	default:
+		return "unknown";
+	}
+}
+
+int nft_str2family(const char *family)
+{
+	if (strcmp(family, "ip") == 0)
+		return AF_INET;
+
+	if (strcmp(family, "ip6") == 0)
+		return AF_INET6;
+
+	if (strcmp(family, "bridge") == 0)
+		return AF_BRIDGE;
+
+	if (strcmp(family, "arp") == 0)
+		return 0;
+
+	return -1;
+}
diff --git a/test/nft-chain-xml-add.sh b/test/nft-chain-xml-add.sh
index fda28cb..ab50e2b 100755
--- a/test/nft-chain-xml-add.sh
+++ b/test/nft-chain-xml-add.sh
@@ -42,7 +42,7 @@ XML="<chain name=\"test1\" handle=\"100\" bytes=\"123\" packets=\"321\" version=
                 <use>0</use>
                 <hooknum>NF_INET_LOCAL_IN</hooknum>
                 <policy>1</policy>
-                <family>2</family>
+                <family>ip</family>
         </properties>
 </chain>"
 
@@ -63,7 +63,7 @@ XML="<chain name=\"test2\" handle=\"101\" bytes=\"59\" packets=\"1\" version=\"0
 		<use>0</use>
 		<hooknum>NF_INET_POST_ROUTING</hooknum>
 		<policy>1</policy>
-		<family>10</family>
+		<family>ip6</family>
 	</properties>
 </chain>"
 
@@ -85,7 +85,7 @@ XML="<chain name=\"test3\" handle=\"102\" bytes=\"51231239\" packets=\"112312312
 		<use>0</use>
 		<hooknum>NF_INET_FORWARD</hooknum>
 		<policy>1</policy>
-		<family>2</family>
+		<family>ip</family>
 	</properties>
 </chain>"
 
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
index 426b975..961b597 100755
--- a/test/nft-rule-xml-add.sh
+++ b/test/nft-rule-xml-add.sh
@@ -33,9 +33,8 @@ fi
 
 [ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
 
-XML="<rule family=\"2\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version=\"0\">
+XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version=\"0\">
   <rule_flags>0</rule_flags>
-  <flags>127</flags>
   <compat_flags>0</compat_flags>
   <compat_proto>0</compat_proto>
   <expr type=\"meta\">
diff --git a/test/nft-table-xml-add.sh b/test/nft-table-xml-add.sh
index 2c55edc..30b65e1 100755
--- a/test/nft-table-xml-add.sh
+++ b/test/nft-table-xml-add.sh
@@ -40,7 +40,7 @@ fi
 # This is valid
 XML="<table name=\"filter_test\" version=\"0\">
 	<properties>
-		<family>2</family>
+		<family>ip</family>
 		<table_flags>0</table_flags>
 	</properties>
 </table>"
@@ -57,7 +57,7 @@ fi
 # This is valid
 XML="<table name=\"filter6_test\" version=\"0\">
 	<properties>
-		<family>10</family>
+		<family>ip6</family>
 		<table_flags>0</table_flags>
 	</properties>
 </table>"

