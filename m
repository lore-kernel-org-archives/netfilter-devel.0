From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] examples: XML parsing examples
Date: Wed, 15 May 2013 12:19:02 +0200
Message-ID: <20130515101902.3787.99657.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56445 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140Ab3EOKTH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 06:19:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some code snipplets to add tables/chain/rules using the XML representation.

The examples contains:
 * A binary to parse/add the object using libnftables.
 * A shellscript to easily call that binary, doing some tests.

I included my name in new files, but I don't know if this is correct. Please let me know.

Instructions:
 $ make nft-table-xml-add
 # ./nft-table-xml-add.sh

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am          |   48 ++++++++++------
 examples/nft-chain-xml-add.c  |   92 +++++++++++++++++++++++++++++++
 examples/nft-chain-xml-add.sh |  104 +++++++++++++++++++++++++++++++++++
 examples/nft-rule-xml-add.c   |   90 ++++++++++++++++++++++++++++++
 examples/nft-rule-xml-add.sh  |  122 +++++++++++++++++++++++++++++++++++++++++
 examples/nft-table-xml-add.c  |   93 +++++++++++++++++++++++++++++++
 examples/nft-table-xml-add.sh |   88 ++++++++++++++++++++++++++++++
 7 files changed, 619 insertions(+), 18 deletions(-)
 create mode 100644 examples/nft-chain-xml-add.c
 create mode 100755 examples/nft-chain-xml-add.sh
 create mode 100644 examples/nft-rule-xml-add.c
 create mode 100755 examples/nft-rule-xml-add.sh
 create mode 100644 examples/nft-table-xml-add.c
 create mode 100755 examples/nft-table-xml-add.sh

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
diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.c
new file mode 100644
index 0000000..f06cab4
--- /dev/null
+++ b/examples/nft-chain-xml-add.c
@@ -0,0 +1,92 @@
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
+	uint16_t family;
+
+	if (argc < 2) {
+		printf("Usage: %s \"<nftables XML chain definition>\"\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	char *xml = argv[1];
+
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) < 0) {
+		printf("E: Unable to parse given XML.\n");
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	family = (uint16_t)nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
+
+	seq = time(NULL);
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
+					NLM_F_ACK, seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
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
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-chain-xml-add.sh b/examples/nft-chain-xml-add.sh
new file mode 100755
index 0000000..4436786
--- /dev/null
+++ b/examples/nft-chain-xml-add.sh
@@ -0,0 +1,104 @@
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
+BINARY="./nft-chain-xml-add"
+NFT="$( which nft )"
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
+
+XML="<chain name=\"test1\" handle=\"300\" bytes=\"123\" packets=\"321\" >
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
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	exit 1
+fi
+
+echo "I: Added XML:"
+echo "$XML"
+
+# This is valid (as long as the table exist)
+XML="<chain name=\"test2\" handle=\"100\" bytes=\"59\" packets=\"1\" >
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
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	exit 1
+fi
+
+# This is valid (as long as the table exist)
+XML="<chain name=\"sh_test2\" handle=\"101\" bytes=\"51231239\" packets=\"1123123123\" >
+		<properties>
+			<type>filter</type>
+			<table>filter</table>
+			<prio>0</prio>
+			<use>0</use>
+			<hooknum>4</hooknum>
+			<policy>1</policy>
+			<family>2</family>
+		</properties>
+	</chain>"
+
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
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
+	exit 1
+fi
+
+echo "I: The test ended succefully"
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
new file mode 100644
index 0000000..4d2e787
--- /dev/null
+++ b/examples/nft-rule-xml-add.c
@@ -0,0 +1,90 @@
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
+	int ret;
+	uint8_t family;
+
+	if (argc < 2) {
+		printf("Usage: %s <nftables XML rule definition>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	char *xml = argv[1];
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
diff --git a/examples/nft-rule-xml-add.sh b/examples/nft-rule-xml-add.sh
new file mode 100755
index 0000000..4e85abd
--- /dev/null
+++ b/examples/nft-rule-xml-add.sh
@@ -0,0 +1,122 @@
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
+BINARY="./nft-rule-xml-add"
+NFT="$( which nft )"
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
+
+XML="<rule family=\"2\" table=\"filter\" chain=\"INPUT\" handle=\"100\">
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
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+#	echo "$XML"
+	exit 1
+fi
+
+echo "I: Added XML:"
+#echo "$XML"
+
+echo "I: The test ended succefully"
+
+
+
diff --git a/examples/nft-table-xml-add.c b/examples/nft-table-xml-add.c
new file mode 100644
index 0000000..5baf6cd
--- /dev/null
+++ b/examples/nft-table-xml-add.c
@@ -0,0 +1,93 @@
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
+	uint16_t family;
+	char *xml;
+
+	if (argc < 2) {
+		printf("Usage: %s \"<nftables xml table definition>\"\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	xml = argv[1];
+
+	t = nft_table_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Parsing XML now */
+	if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) < 0) {
+		printf("E: Unable to parse the XML.\n");
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
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
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-table-xml-add.sh b/examples/nft-table-xml-add.sh
new file mode 100755
index 0000000..55a44f5
--- /dev/null
+++ b/examples/nft-table-xml-add.sh
@@ -0,0 +1,88 @@
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
+BINARY="./nft-table-xml-add"
+NFT="$( which nft )"
+
+if [ ! -x "$BINARY" ] ; then
+	echo "E: Binary not found $BINARY"
+	exit 1
+fi
+
+if [ ! -x "$NFT" ] ; then
+	echo "W: nftables main binary not found but continuing anyway $NFT"
+fi
+
+# This is valid
+XML="<table name=\"filter_test\" >
+	<properties>
+		<family>2</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>"
+
+# Delete
+$NFT delete table filter_test 2>/dev/null >&2
+
+# Add
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	exit 1
+fi
+
+echo "I: Added XML:"
+echo "$XML"
+
+# This is valid
+XML="<table name=\"filter6_test\" >
+	<properties>
+		<family>10</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>"
+
+# Delete
+$NFT delete table filter6_test 2>/dev/null >&2
+
+# Add
+if ! $BINARY "$XML" ; then
+	echo "E: Unable to add XML:"
+	echo "$XML"
+	exit 1
+fi
+
+echo "I: Added XML:"
+echo "$XML"
+
+# This is invalid
+XML="<table nasd\" >
+	<propertasdies>
+		<fasdmily>4</family>
+		<flags>5asd</flags>
+		<table_fl1ags>013ax4<123/table_flags>
+	</propertides>
+</tablex>"
+
+if $BINARY "$XML" 2>/dev/null; then
+	echo "E: Accepted invalid XML:"
+	echo "$XML"
+	exit 1
+fi
+
+echo "I: Not added XML:"
+echo "$XML"
+
+
+echo "I: This test was succefully."

