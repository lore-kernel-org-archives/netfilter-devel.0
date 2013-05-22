From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] examples: XML parsing examples
Date: Wed, 22 May 2013 12:33:25 +0200
Message-ID: <20130522103325.904.74543.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36485 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754079Ab3EVKdh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 06:33:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some code snipplets to add tables/chain/rules using the XML representation.

The examples contains:
 * A binary to parse/add the object using libnftables.
 * A shellscript to easily call that binary, doing some tests.
 * table/chain/rule sample XML file.

I included my name in new files, but I don't know if this is correct. Please let me know.

Instructions:
 $ cd examples/ ; make nft-table-xml-add
 # cd test/ ; ./nft-table-xml-add.sh

NOTE: Some kernel changes are required to allow reinsert exactly what is printed (handle handling, flags..)

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am         |   48 +++++++++------
 examples/chain.xml           |   11 +++
 examples/nft-chain-xml-add.c |  116 ++++++++++++++++++++++++++++++++++++
 examples/nft-rule-xml-add.c  |  110 ++++++++++++++++++++++++++++++++++
 examples/nft-table-xml-add.c |  118 +++++++++++++++++++++++++++++++++++++
 examples/rule.xml            |   85 ++++++++++++++++++++++++++
 examples/table.xml           |    6 ++
 test/nft-chain-xml-add.sh    |  123 ++++++++++++++++++++++++++++++++++++++
 test/nft-rule-xml-add.sh     |  135 ++++++++++++++++++++++++++++++++++++++++++
 test/nft-table-xml-add.sh    |   75 +++++++++++++++++++++++
 10 files changed, 809 insertions(+), 18 deletions(-)
 create mode 100644 examples/chain.xml
 create mode 100644 examples/nft-chain-xml-add.c
 create mode 100644 examples/nft-rule-xml-add.c
 create mode 100644 examples/nft-table-xml-add.c
 create mode 100644 examples/rule.xml
 create mode 100644 examples/table.xml
 create mode 100755 test/nft-chain-xml-add.sh
 create mode 100755 test/nft-rule-xml-add.sh
 create mode 100755 test/nft-table-xml-add.sh

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 1c39e12..dcf798a 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -1,13 +1,16 @@
 include $(top_srcdir)/Make_global.am
 
 check_PROGRAMS = nft-table-add		\
+		 nft-table-xml-add	\
 		 nft-table-upd		\
 		 nft-table-del		\
 		 nft-table-get		\
 		 nft-chain-add		\
+		 nft-chain-xml-add	\
 		 nft-chain-del		\
 		 nft-chain-get		\
 		 nft-rule-add		\
+		 nft-rule-xml-add	\
 		 nft-rule-del		\
 		 nft-rule-get		\
 		 nft-events		\
@@ -20,55 +23,64 @@ check_PROGRAMS = nft-table-add		\
 		 nft-compat-get
 
 nft_table_add_SOURCES = nft-table-add.c
-nft_table_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_table_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
+
+nft_table_xml_add_SOURCES = nft-table-xml-add.c
+nft_table_xml_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_table_upd_SOURCES = nft-table-upd.c
-nft_table_upd_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_table_upd_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_table_del_SOURCES = nft-table-del.c
-nft_table_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_table_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_table_get_SOURCES = nft-table-get.c
-nft_table_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_table_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_chain_add_SOURCES = nft-chain-add.c
-nft_chain_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_chain_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
+
+nft_chain_xml_add_SOURCES = nft-chain-xml-add.c
+nft_chain_xml_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_chain_del_SOURCES = nft-chain-del.c
-nft_chain_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_chain_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_chain_get_SOURCES = nft-chain-get.c
-nft_chain_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_chain_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_rule_add_SOURCES = nft-rule-add.c
-nft_rule_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_rule_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
+
+nft_rule_xml_add_SOURCES = nft-rule-xml-add.c
+nft_rule_xml_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_rule_del_SOURCES = nft-rule-del.c
-nft_rule_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_rule_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_rule_get_SOURCES = nft-rule-get.c
-nft_rule_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_rule_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_events_SOURCES = nft-events.c
-nft_events_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_events_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_add_SOURCES = nft-set-add.c
-nft_set_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_del_SOURCES = nft-set-del.c
-nft_set_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_get_SOURCES = nft-set-get.c
-nft_set_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_elem_add_SOURCES = nft-set-elem-add.c
-nft_set_elem_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_elem_add_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_elem_del_SOURCES = nft-set-elem-del.c
-nft_set_elem_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_elem_del_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_set_elem_get_SOURCES = nft-set-elem-get.c
-nft_set_elem_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_set_elem_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
 
 nft_compat_get_SOURCES = nft-compat-get.c
-nft_compat_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS}
+nft_compat_get_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
diff --git a/examples/chain.xml b/examples/chain.xml
new file mode 100644
index 0000000..01ccb85
--- /dev/null
+++ b/examples/chain.xml
@@ -0,0 +1,11 @@
+<chain name="test" handle="0" bytes="59" packets="1" version="0">
+	<properties>
+		<type>filter</type>
+		<table>filter</table>
+		<prio>1</prio>
+		<use>0</use>
+		<hooknum>4</hooknum>
+		<policy>1</policy>
+		<family>10</family>
+	</properties>
+</chain>
diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.c
new file mode 100644
index 0000000..a537d47
--- /dev/null
+++ b/examples/nft-chain-xml-add.c
@@ -0,0 +1,116 @@
+/*
+ * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_chain *c = NULL;
+	int ret;
+	int fd;
+	uint16_t family;
+	char xml[4096];
+	char reprint[4096];
+
+	if (argc < 2) {
+		printf("Usage: %s FILE\n"
+			" FILE being a file with a single"
+			" nftables XML chain definition.\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+        fd = open(argv[1], O_RDONLY);
+        if (fd < 0) {
+                perror("open");
+                exit(EXIT_FAILURE);
+        }
+
+        if (read(fd, xml, sizeof(xml)) < 0) {
+                perror("read");
+                close(fd);
+                exit(EXIT_FAILURE);
+        }
+
+	close(fd);
+
+	if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) < 0) {
+		printf("E: Unable to parse given XML.\n");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_CHAIN_O_XML, 0);
+	printf("Parsed:\n%s\n", reprint);
+
+	family = (uint16_t)nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
+
+	seq = time(NULL);
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
+					NLM_F_ACK, seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
+
+	nft_chain_free(c);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
new file mode 100644
index 0000000..a18257e
--- /dev/null
+++ b/examples/nft-rule-xml-add.c
@@ -0,0 +1,110 @@
+/*
+ * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <stddef.h>	/* for offsetof */
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/rule.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_rule *r = NULL;
+	int ret, fd;
+	uint8_t family;
+	char xml[4096];
+	char reprint[4096];
+
+	if (argc < 2) {
+		printf("Usage: %s FILE\n"
+			" FILE being a file with a single"
+			" nftables XML rule definition.\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (read(fd, xml, sizeof(xml)) < 0) {
+		perror("read");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	r = nft_rule_alloc();
+	if (r == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) < 0) {
+		printf("E: Unable to parse the XML\n");
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_RULE_O_XML, 0);
+	printf("Parsed:\n%s\n", reprint);
+
+	family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+
+	seq = time(NULL);
+	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
+					NLM_F_APPEND|NLM_F_ACK, seq);
+	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_rule_free(r);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-table-xml-add.c b/examples/nft-table-xml-add.c
new file mode 100644
index 0000000..84630e7
--- /dev/null
+++ b/examples/nft-table-xml-add.c
@@ -0,0 +1,118 @@
+/*
+ * 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <time.h>
+#include <string.h>
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/table.h>
+
+extern struct nft_table nft_table;
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_table *t = NULL;
+	int ret;
+	int fd;
+	uint16_t family;
+	char xml[4096];
+	char reprint[4096];
+
+	if (argc < 2) {
+		printf("Usage: %s FILE\n"
+			" FILE being a file with a single"
+			" nftables XML table definition.\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (read(fd, xml, sizeof(xml)) < 0) {
+		perror("read");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Parsing XML now */
+	if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) < 0) {
+		printf("E: Unable to parse the XML.\n");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+
+	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_TABLE_O_XML, 0);
+	printf("Parsed:\n%s\n", reprint);
+
+
+	family = (uint16_t)nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
+
+	seq = time(NULL);
+
+	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
+							NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, t);
+	nft_table_free(t);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/rule.xml b/examples/rule.xml
new file mode 100644
index 0000000..b1de25a
--- /dev/null
+++ b/examples/rule.xml
@@ -0,0 +1,85 @@
+<?xml version="1.0"?>
+<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <flags>127</flags>
+  <compat_flags>0</compat_flags>
+  <compat_proto>0</compat_proto>
+  <expr type="meta">
+    <dreg>1</dreg>
+    <key>4</key>
+  </expr>
+  <expr type="cmp">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type="value">
+        <len>1</len>
+        <data0>0x04000000</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type="payload">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>12</offset>
+    <len>4</len>
+  </expr>
+  <expr type="cmp">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type="value">
+        <len>1</len>
+        <data0>0x96d60496</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type="payload">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>16</offset>
+    <len>4</len>
+  </expr>
+  <expr type="cmp">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type="value">
+        <len>1</len>
+        <data0>0x96d60329</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type="payload">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>9</offset>
+    <len>1</len>
+  </expr>
+  <expr type="cmp">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type="value">
+        <len>1</len>
+        <data0>0x06000000</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type="match">
+    <name>state</name>
+    <rev>0</rev>
+   <info>
+    </info>
+  </expr>
+  <expr type="counter">
+    <pkts>123123</pkts>
+    <bytes>321321</bytes>
+  </expr>
+  <expr type="target">
+    <name>LOG</name>
+    <rev>0</rev>
+    <info>
+    </info>
+  </expr>
+</rule>
diff --git a/examples/table.xml b/examples/table.xml
new file mode 100644
index 0000000..a397d52
--- /dev/null
+++ b/examples/table.xml
@@ -0,0 +1,6 @@
+<table name="filter" version="0">
+	<properties>
+		<family>2</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>
diff --git a/test/nft-chain-xml-add.sh b/test/nft-chain-xml-add.sh
new file mode 100755
index 0000000..28b7b82
--- /dev/null
+++ b/test/nft-chain-xml-add.sh
@@ -0,0 +1,123 @@
+#!/bin/bash
+
+#
+# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+
+# This is a small testbench for adding nftables chains to kernel
+# in XML format.
+
+BINARY="../examples/nft-chain-xml-add"
+NFT=$( which nft )
+MKTEMP=$( which mktemp)
+TMPFILE=$( $MKTEMP )
+
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+
+if [ ! -x "$MKTEMP" ] ; then
+	echo "E: mktemp not found and is neccesary"
+	exit 1
+fi
+
+if [ ! -w "$TMPFILE" ] ; then
+	echo "E: Unable to create temp file via mktemp"
+	exit 1
+fi
+
+[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
+
+XML="<chain name=\"test1\" handle=\"100\" bytes=\"123\" packets=\"321\" version=\"0\">
+        <properties>
+                <type>filter</type>
+                <table>filter</table>
+                <prio>0</prio>
+                <use>0</use>
+                <hooknum>2</hooknum>
+                <policy>1</policy>
+                <family>2</family>
+        </properties>
+</chain>"
+
+$NFT delete chain ip filter test1 2>/dev/null >&2
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	exit 1
+fi
+
+# This is valid (as long as the table exist)
+XML="<chain name=\"test2\" handle=\"101\" bytes=\"59\" packets=\"1\" version=\"0\">
+	<properties>
+		<type>filter</type>
+		<table>filter</table>
+		<prio>1</prio>
+		<use>0</use>
+		<hooknum>4</hooknum>
+		<policy>1</policy>
+		<family>10</family>
+	</properties>
+</chain>"
+
+$NFT delete chain ip6 filter test2 2>/dev/null >&2
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+# This is valid (as long as the table exist)
+XML="<chain name=\"test3\" handle=\"102\" bytes=\"51231239\" packets=\"1123123123\" version=\"0\">
+	<properties>
+		<type>filter</type>
+		<table>filter</table>
+		<prio>0</prio>
+		<use>0</use>
+		<hooknum>4</hooknum>
+		<policy>1</policy>
+		<family>2</family>
+	</properties>
+</chain>"
+
+$NFT delete chain ip6 filter test3 2>/dev/null >&2
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+# This is invalid
+XML="<chain name=\"XXXX\" handle=\"XXXX\" bytes=\"XXXXXXX\" packets=\"XXXXXXX\" >
+		<properties>
+			<flags>asdasd</flags>
+			<type>filter</type>
+			<table>filter</table>
+			<prio>asdasd</prio>
+			<use>asdasd</use>
+			<hooknum>asdasd</hooknum>
+			<policy>asdasd</policy>
+			<family>asdasd</family>
+		</properties>
+	</chain>"
+
+if $BINARY "$XML" 2>/dev/null; then
+	echo "E: Accepted invalid XML:"
+	echo "$XML"
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+rm -rf $TMPFILE 2>/dev/null
+echo "I: The test ended succefully"
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
new file mode 100755
index 0000000..5d83273
--- /dev/null
+++ b/test/nft-rule-xml-add.sh
@@ -0,0 +1,135 @@
+#!/bin/bash
+
+#
+# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+# This is a small testbench for adding nftables rules to kernel
+# in XML format.
+
+BINARY="../examples/nft-rule-xml-add"
+NFT="$( which nft )"
+MKTEMP="$( which mktemp )"
+TMPFILE="$( $MKTEMP )"
+
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+
+if [ ! -x "$MKTEMP" ] ; then
+	echo "E: mktemp not found. Is mandatory."
+	exit 1
+fi
+
+if [ ! -w "$TMPFILE" ] ; then
+	echo "E: Unable to create tempfile with mktemp"
+	exit 1
+fi
+
+[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
+
+XML="<rule family=\"2\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version=\"0\">
+  <rule_flags>0</rule_flags>
+  <flags>127</flags>
+  <compat_flags>0</compat_flags>
+  <compat_proto>0</compat_proto>
+  <expr type=\"meta\">
+    <dreg>1</dreg>
+    <key>4</key>
+  </expr>
+  <expr type=\"cmp\">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type=\"value\">
+        <len>1</len>
+        <data0>0x04000000</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type=\"payload\">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>12</offset>
+    <len>4</len>
+  </expr>
+  <expr type=\"cmp\">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type=\"value\">
+        <len>1</len>
+        <data0>0x96d60496</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type=\"payload\">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>16</offset>
+    <len>4</len>
+  </expr>
+  <expr type=\"cmp\">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type=\"value\">
+        <len>1</len>
+        <data0>0x96d60329</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type=\"payload\">
+    <dreg>1</dreg>
+    <base>1</base>
+    <offset>9</offset>
+    <len>1</len>
+  </expr>
+  <expr type=\"cmp\">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type=\"value\">
+        <len>1</len>
+        <data0>0x06000000</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+  <expr type=\"match\">
+    <name>state</name>
+    <rev>0</rev>
+    <info>
+    </info>
+  </expr>
+  <expr type=\"counter\">
+    <pkts>123123</pkts>
+    <bytes>321321</bytes>
+  </expr>
+  <expr type=\"target\">
+    <name>LOG</name>
+    <rev>0</rev>
+    <info>
+    </info>
+  </expr>
+</rule>"
+
+$NFT add table filter 2>/dev/null >&2
+$NFT add chain filter INPUT 2>/dev/null >&2
+
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML."
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+rm -rf $TMPFILE 2>/dev/null
+echo "I: The test ended succefully"
+
+
+
diff --git a/test/nft-table-xml-add.sh b/test/nft-table-xml-add.sh
new file mode 100755
index 0000000..9c71292
--- /dev/null
+++ b/test/nft-table-xml-add.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+
+#
+# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+
+# This is a small testbench for adding nftables tables to kernel
+# in XML format.
+
+BINARY="../examples/nft-table-xml-add"
+NFT="$( which nft )"
+MKTEMP="$( which mktemp)"
+TMPFILE="$( $MKTEMP )"
+
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+
+if [ ! -x "$MKTEMP" ] ; then
+	echo "E: mktemp not found and is neccesary"
+	exit 1
+fi
+
+if [ ! -w "$TMPFILE" ] ; then
+	echo "E: Unable to create temp file via mktemp"
+	exit 1
+fi
+
+
+if [ ! -x "$NFT" ] ; then
+	echo "W: nftables main binary not found but continuing anyway $NFT"
+fi
+
+# This is valid
+XML="<table name=\"filter_test\" version=\"0\">
+	<properties>
+		<family>2</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>"
+
+$NFT delete table filter_test 2>/dev/null >&2
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+# This is valid
+XML="<table name=\"filter6_test\" version=\"0\">
+	<properties>
+		<family>10</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>"
+
+$NFT delete table filter6_test 2>/dev/null >&2
+echo $XML > $TMPFILE
+if ! $BINARY "$TMPFILE" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	rm -rf $TMPFILE 2>/dev/null
+	exit 1
+fi
+
+rm -rf $TMPFILE 2>/dev/null
+echo "I: This test was succefully."

