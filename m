From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH v2] test: add testbench for XML
Date: Thu, 27 Jun 2013 20:09:34 +0200
Message-ID: <20130627180824.10906.42385.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37998 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753950Ab3F0SJp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:09:45 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id DB6A351ED4E
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 18:09:42 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cT+CG5vx2vD7 for <netfilter-devel@vger.kernel.org>;
	Thu, 27 Jun 2013 20:09:36 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 1E78151ED34
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 20:09:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add a testbench for XML parsing, which may be extended to also test JSON.

To use it:
 $ cd test/
 $ make nft-parsing-test
 $ ./nft-parsing-test xmlfiles/

This testbench supersedes old .sh test scripts, so they are deleted.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v1: initial version.
v2: deleted old .sh, implements all XML changes. 

 test/Makefile.am                 |    6 ++
 test/nft-chain-xml-add.sh        |  123 -------------------------------------
 test/nft-parsing-test.c          |  118 ++++++++++++++++++++++++++++++++++++
 test/nft-rule-xml-add.sh         |  125 --------------------------------------
 test/nft-table-xml-add.sh        |   75 -----------------------
 test/xmlfiles/chain1.xml         |   11 +++
 test/xmlfiles/chain2.xml         |   11 +++
 test/xmlfiles/chain3.xml         |   11 +++
 test/xmlfiles/rule_bitwise.xml   |   25 ++++++++
 test/xmlfiles/rule_byteorder.xml |   12 ++++
 test/xmlfiles/rule_cmp.xml       |   13 ++++
 test/xmlfiles/rule_counter.xml   |    8 ++
 test/xmlfiles/rule_ct.xml        |   10 +++
 test/xmlfiles/rule_exthdr.xml    |    9 +++
 test/xmlfiles/rule_immediate.xml |   12 ++++
 test/xmlfiles/rule_limit.xml     |    7 ++
 test/xmlfiles/rule_log.xml       |    9 +++
 test/xmlfiles/rule_lookup.xml    |    8 ++
 test/xmlfiles/rule_match.xml     |    6 ++
 test/xmlfiles/rule_meta.xml      |    7 ++
 test/xmlfiles/rule_nat.xml       |   11 +++
 test/xmlfiles/rule_nat6.xml      |   11 +++
 test/xmlfiles/rule_payload.xml   |    9 +++
 test/xmlfiles/rule_target.xml    |    6 ++
 test/xmlfiles/table1.xml         |    6 ++
 test/xmlfiles/table2.xml         |    6 ++
 26 files changed, 332 insertions(+), 323 deletions(-)
 create mode 100644 test/Makefile.am
 delete mode 100755 test/nft-chain-xml-add.sh
 create mode 100644 test/nft-parsing-test.c
 delete mode 100755 test/nft-rule-xml-add.sh
 delete mode 100755 test/nft-table-xml-add.sh
 create mode 100644 test/xmlfiles/chain1.xml
 create mode 100644 test/xmlfiles/chain2.xml
 create mode 100644 test/xmlfiles/chain3.xml
 create mode 100644 test/xmlfiles/rule_bitwise.xml
 create mode 100644 test/xmlfiles/rule_byteorder.xml
 create mode 100644 test/xmlfiles/rule_cmp.xml
 create mode 100644 test/xmlfiles/rule_counter.xml
 create mode 100644 test/xmlfiles/rule_ct.xml
 create mode 100644 test/xmlfiles/rule_exthdr.xml
 create mode 100644 test/xmlfiles/rule_immediate.xml
 create mode 100644 test/xmlfiles/rule_limit.xml
 create mode 100644 test/xmlfiles/rule_log.xml
 create mode 100644 test/xmlfiles/rule_lookup.xml
 create mode 100644 test/xmlfiles/rule_match.xml
 create mode 100644 test/xmlfiles/rule_meta.xml
 create mode 100644 test/xmlfiles/rule_nat.xml
 create mode 100644 test/xmlfiles/rule_nat6.xml
 create mode 100644 test/xmlfiles/rule_payload.xml
 create mode 100644 test/xmlfiles/rule_target.xml
 create mode 100644 test/xmlfiles/table1.xml
 create mode 100644 test/xmlfiles/table2.xml

diff --git a/Makefile.am b/Makefile.am
index 6999f51..7ad11d4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@ include $(top_srcdir)/Make_global.am
 
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = src include examples
+SUBDIRS = src include examples test
 DIST_SUBDIRS = src include examples
 
 pkgconfigdir = $(libdir)/pkgconfig
diff --git a/configure.ac b/configure.ac
index 0eec5bd..eaf3bb8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -38,5 +38,5 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wformat=2 -pipe"
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftables/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile libnftables.pc doxygen.cfg])
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftables/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile test/Makefile libnftables.pc doxygen.cfg])
 AC_OUTPUT
diff --git a/examples/chain.xml b/examples/chain.xml
deleted file mode 100644
index 01ccb85..0000000
--- a/examples/chain.xml
+++ /dev/null
@@ -1,11 +0,0 @@
-<chain name="test" handle="0" bytes="59" packets="1" version="0">
-	<properties>
-		<type>filter</type>
-		<table>filter</table>
-		<prio>1</prio>
-		<use>0</use>
-		<hooknum>4</hooknum>
-		<policy>1</policy>
-		<family>10</family>
-	</properties>
-</chain>
diff --git a/examples/rule.xml b/examples/rule.xml
deleted file mode 100644
index b1de25a..0000000
--- a/examples/rule.xml
+++ /dev/null
@@ -1,85 +0,0 @@
-<?xml version="1.0"?>
-<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <flags>127</flags>
-  <compat_flags>0</compat_flags>
-  <compat_proto>0</compat_proto>
-  <expr type="meta">
-    <dreg>1</dreg>
-    <key>4</key>
-  </expr>
-  <expr type="cmp">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type="value">
-        <len>1</len>
-        <data0>0x04000000</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type="payload">
-    <dreg>1</dreg>
-    <base>1</base>
-    <offset>12</offset>
-    <len>4</len>
-  </expr>
-  <expr type="cmp">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type="value">
-        <len>1</len>
-        <data0>0x96d60496</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type="payload">
-    <dreg>1</dreg>
-    <base>1</base>
-    <offset>16</offset>
-    <len>4</len>
-  </expr>
-  <expr type="cmp">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type="value">
-        <len>1</len>
-        <data0>0x96d60329</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type="payload">
-    <dreg>1</dreg>
-    <base>1</base>
-    <offset>9</offset>
-    <len>1</len>
-  </expr>
-  <expr type="cmp">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type="value">
-        <len>1</len>
-        <data0>0x06000000</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type="match">
-    <name>state</name>
-    <rev>0</rev>
-   <info>
-    </info>
-  </expr>
-  <expr type="counter">
-    <pkts>123123</pkts>
-    <bytes>321321</bytes>
-  </expr>
-  <expr type="target">
-    <name>LOG</name>
-    <rev>0</rev>
-    <info>
-    </info>
-  </expr>
-</rule>
diff --git a/examples/table.xml b/examples/table.xml
deleted file mode 100644
index a397d52..0000000
--- a/examples/table.xml
+++ /dev/null
@@ -1,6 +0,0 @@
-<table name="filter" version="0">
-	<properties>
-		<family>2</family>
-		<table_flags>0</table_flags>
-	</properties>
-</table>
diff --git a/test/Makefile.am b/test/Makefile.am
new file mode 100644
index 0000000..6941c3c
--- /dev/null
+++ b/test/Makefile.am
@@ -0,0 +1,6 @@
+include $(top_srcdir)/Make_global.am
+
+check_PROGRAMS = nft-parsing-test
+
+nft_parsing_test_SOURCES = nft-parsing-test.c
+nft_parsing_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
diff --git a/test/nft-chain-xml-add.sh b/test/nft-chain-xml-add.sh
deleted file mode 100755
index ed39d54..0000000
--- a/test/nft-chain-xml-add.sh
+++ /dev/null
@@ -1,123 +0,0 @@
-#!/bin/bash
-
-#
-# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
-#
-# This program is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-
-# This is a small testbench for adding nftables chains to kernel
-# in XML format.
-
-BINARY="../examples/nft-chain-xml-add"
-NFT=$( which nft )
-MKTEMP=$( which mktemp)
-TMPFILE=$( $MKTEMP )
-
-if [ ! -x "$BINARY" ] ; then
-	echo "E: Binary not found $BINARY"
-	exit 1
-fi
-
-if [ ! -x "$MKTEMP" ] ; then
-	echo "E: mktemp not found and is neccesary"
-	exit 1
-fi
-
-if [ ! -w "$TMPFILE" ] ; then
-	echo "E: Unable to create temp file via mktemp"
-	exit 1
-fi
-
-[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
-
-XML="<chain name=\"test1\" handle=\"100\" bytes=\"123\" packets=\"321\" version=\"0\">
-        <properties>
-                <type>filter</type>
-                <table>filter</table>
-                <prio>0</prio>
-                <use>0</use>
-                <hooknum>NF_INET_LOCAL_IN</hooknum>
-                <policy>accept</policy>
-                <family>ip</family>
-        </properties>
-</chain>"
-
-$NFT delete chain ip filter test1 2>/dev/null >&2
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML:"
-	echo "$XML"
-	exit 1
-fi
-
-# This is valid (as long as the table exist)
-XML="<chain name=\"test2\" handle=\"101\" bytes=\"59\" packets=\"1\" version=\"0\">
-	<properties>
-		<type>filter</type>
-		<table>filter</table>
-		<prio>1</prio>
-		<use>0</use>
-		<hooknum>NF_INET_POST_ROUTING</hooknum>
-		<policy>accept</policy>
-		<family>ip6</family>
-	</properties>
-</chain>"
-
-$NFT delete chain ip6 filter test2 2>/dev/null >&2
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML:"
-	echo "$XML"
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-# This is valid (as long as the table exist)
-XML="<chain name=\"test3\" handle=\"102\" bytes=\"51231239\" packets=\"1123123123\" version=\"0\">
-	<properties>
-		<type>filter</type>
-		<table>filter</table>
-		<prio>0</prio>
-		<use>0</use>
-		<hooknum>NF_INET_FORWARD</hooknum>
-		<policy>drop</policy>
-		<family>ip</family>
-	</properties>
-</chain>"
-
-$NFT delete chain ip6 filter test3 2>/dev/null >&2
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML:"
-	echo "$XML"
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-# This is invalid
-XML="<chain name=\"XXXX\" handle=\"XXXX\" bytes=\"XXXXXXX\" packets=\"XXXXXXX\" >
-		<properties>
-			<flags>asdasd</flags>
-			<type>filter</type>
-			<table>filter</table>
-			<prio>asdasd</prio>
-			<use>asdasd</use>
-			<hooknum>asdasd</hooknum>
-			<policy>asdasd</policy>
-			<family>asdasd</family>
-		</properties>
-	</chain>"
-
-if $BINARY "$XML" 2>/dev/null; then
-	echo "E: Accepted invalid XML:"
-	echo "$XML"
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-rm -rf $TMPFILE 2>/dev/null
-echo "I: Test OK"
diff --git a/test/nft-parsing-test.c b/test/nft-parsing-test.c
new file mode 100644
index 0000000..6ac6909
--- /dev/null
+++ b/test/nft-parsing-test.c
@@ -0,0 +1,118 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <dirent.h>
+#include <limits.h>
+
+#include <mxml.h>
+
+#include <libmnl/libmnl.h> /*nlmsghdr*/
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+
+static int test_xml(const char *filename)
+{
+	int ret = -1;
+	struct nft_table *t = NULL;
+	struct nft_chain *c = NULL;
+	struct nft_rule *r = NULL;
+	FILE *fp;
+	mxml_node_t *tree = NULL;;
+	char *xml = NULL;
+
+	fp = fopen(filename, "r");
+	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
+	fclose(fp);
+
+	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
+	if (xml == NULL)
+		return -1;
+
+	if (tree == NULL)
+		return -1;
+
+	/* Check what parsing should be done */
+	if (strcmp(tree->value.opaque, "table") == 0) {
+		t = nft_table_alloc();
+		if (t != NULL) {
+			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) == 0)
+				ret = 0;
+
+			nft_table_free(t);
+		}
+	} else if (strcmp(tree->value.opaque, "chain") == 0) {
+		c = nft_chain_alloc();
+		if (c != NULL) {
+			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) == 0)
+				ret = 0;
+
+			nft_chain_free(c);
+		}
+	} else if (strcmp(tree->value.opaque, "rule") == 0) {
+		r = nft_rule_alloc();
+		if (r != NULL) {
+			if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) == 0)
+				ret = 0;
+
+			nft_rule_free(r);
+		}
+	}
+
+	return ret;
+}
+
+static int test_json(const char *filename)
+{
+	/* XXX parse file JSON file, in case of failure return -1 */
+	return -1;
+}
+
+int main(int argc, char *argv[])
+{
+	DIR *d;
+	struct dirent *dent;
+	char path[PATH_MAX];
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	d = opendir(argv[1]);
+	if (d == NULL) {
+		perror("opendir");
+		exit(EXIT_FAILURE);
+	}
+
+	strncpy(path, argv[1], sizeof(path));
+
+	while ((dent = readdir(d)) != NULL) {
+		int len = strlen(dent->d_name);
+
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+
+		snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);
+
+		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
+			printf("parsing json file %s ..\t", path);
+			if (test_json(path) < 0)
+				printf("FAILED\n");
+			else
+				printf("OK\n");
+		}
+
+		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
+			printf("parsing xml file %s ..\t", path);
+			if (test_xml(path) < 0)
+				printf("FAILED\n");
+			else
+				printf("OK\n");
+		}
+	}
+
+	closedir(d);
+	return 0;
+}
diff --git a/test/nft-rule-xml-add.sh b/test/nft-rule-xml-add.sh
deleted file mode 100755
index 2a052b2..0000000
--- a/test/nft-rule-xml-add.sh
+++ /dev/null
@@ -1,125 +0,0 @@
-#!/bin/bash
-
-#
-# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
-#
-# This program is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-
-# This is a small testbench for adding nftables rules to kernel
-# in XML format.
-
-BINARY="../examples/nft-rule-xml-add"
-NFT="$( which nft )"
-MKTEMP="$( which mktemp )"
-TMPFILE="$( $MKTEMP )"
-
-if [ ! -x "$BINARY" ] ; then
-	echo "E: Binary not found $BINARY"
-	exit 1
-fi
-
-if [ ! -x "$MKTEMP" ] ; then
-	echo "E: mktemp not found. Is mandatory."
-	exit 1
-fi
-
-if [ ! -w "$TMPFILE" ] ; then
-	echo "E: Unable to create tempfile with mktemp"
-	exit 1
-fi
-
-[ ! -x "$NFT" ] && echo "W: nftables main binary not found but continuing anyway $NFT"
-
-XML="<rule family=\"ip\" table=\"filter\" chain=\"INPUT\" handle=\"100\" version=\"0\">
-  <rule_flags>0</rule_flags>
-  <compat_flags>0</compat_flags>
-  <compat_proto>0</compat_proto>
-  <expr type=\"meta\">
-    <dreg>1</dreg>
-    <key>iif</key>
-  </expr>
-  <expr type=\"cmp\">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type=\"value\">
-        <len>4</len>
-        <data0>0x04000000</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type=\"payload\">
-    <dreg>1</dreg>
-    <base>transport</base>
-    <offset>12</offset>
-    <len>4</len>
-  </expr>
-  <expr type=\"cmp\">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type=\"value\">
-        <len>4</len>
-        <data0>0x96d60496</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type=\"payload\">
-    <dreg>1</dreg>
-    <base>link</base>
-    <offset>16</offset>
-    <len>4</len>
-  </expr>
-  <expr type=\"cmp\">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type=\"value\">
-        <len>4</len>
-        <data0>0x96d60329</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type=\"payload\">
-    <dreg>1</dreg>
-    <base>network</base>
-    <offset>9</offset>
-    <len>1</len>
-  </expr>
-  <expr type=\"cmp\">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type=\"value\">
-        <len>4</len>
-        <data0>0x06000000</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
-  <expr type=\"match\">
-    <name>state</name>
-  </expr>
-  <expr type=\"counter\">
-    <pkts>123123</pkts>
-    <bytes>321321</bytes>
-  </expr>
-  <expr type=\"target\">
-    <name>LOG</name>
-  </expr>
-</rule>"
-
-$NFT add table filter 2>/dev/null >&2
-$NFT add chain filter INPUT 2>/dev/null >&2
-
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML."
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-rm -rf $TMPFILE 2>/dev/null
-echo "I: Test OK"
diff --git a/test/nft-table-xml-add.sh b/test/nft-table-xml-add.sh
deleted file mode 100755
index 30b65e1..0000000
--- a/test/nft-table-xml-add.sh
+++ /dev/null
@@ -1,75 +0,0 @@
-#!/bin/bash
-
-#
-# (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
-#
-# This program is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-
-# This is a small testbench for adding nftables tables to kernel
-# in XML format.
-
-BINARY="../examples/nft-table-xml-add"
-NFT="$( which nft )"
-MKTEMP="$( which mktemp)"
-TMPFILE="$( $MKTEMP )"
-
-if [ ! -x "$BINARY" ] ; then
-	echo "E: Binary not found $BINARY"
-	exit 1
-fi
-
-if [ ! -x "$MKTEMP" ] ; then
-	echo "E: mktemp not found and is neccesary"
-	exit 1
-fi
-
-if [ ! -w "$TMPFILE" ] ; then
-	echo "E: Unable to create temp file via mktemp"
-	exit 1
-fi
-
-
-if [ ! -x "$NFT" ] ; then
-	echo "W: nftables main binary not found but continuing anyway $NFT"
-fi
-
-# This is valid
-XML="<table name=\"filter_test\" version=\"0\">
-	<properties>
-		<family>ip</family>
-		<table_flags>0</table_flags>
-	</properties>
-</table>"
-
-$NFT delete table filter_test 2>/dev/null >&2
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML:"
-	echo "$XML"
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-# This is valid
-XML="<table name=\"filter6_test\" version=\"0\">
-	<properties>
-		<family>ip6</family>
-		<table_flags>0</table_flags>
-	</properties>
-</table>"
-
-$NFT delete table filter6_test 2>/dev/null >&2
-echo $XML > $TMPFILE
-if ! $BINARY "$TMPFILE" ; then
-	echo "E: Unable to add XML:"
-	echo "$XML"
-	rm -rf $TMPFILE 2>/dev/null
-	exit 1
-fi
-
-rm -rf $TMPFILE 2>/dev/null
-echo "I: Test OK"
diff --git a/test/xmlfiles/chain1.xml b/test/xmlfiles/chain1.xml
new file mode 100644
index 0000000..5e5f516
--- /dev/null
+++ b/test/xmlfiles/chain1.xml
@@ -0,0 +1,11 @@
+<chain name="test" handle="0" bytes="0" packets="0" version="0">
+	<properties>
+		<type>filter</type>
+		<table>filter</table>
+		<prio>0</prio>
+		<use>0</use>
+		<hooknum>NF_INET_LOCAL_IN</hooknum>
+		<policy>accept</policy>
+		<family>ip</family>
+	</properties>
+</chain>
diff --git a/test/xmlfiles/chain2.xml b/test/xmlfiles/chain2.xml
new file mode 100644
index 0000000..0978fe8
--- /dev/null
+++ b/test/xmlfiles/chain2.xml
@@ -0,0 +1,11 @@
+<chain name="test" handle="0" bytes="59" packets="1" version="0">
+	<properties>
+		<type>bridge</type>
+		<table>filter</table>
+		<prio>1</prio>
+		<use>0</use>
+		<hooknum>NF_INET_FORWARD</hooknum>
+		<policy>drop</policy>
+		<family>ip6</family>
+	</properties>
+</chain>
diff --git a/test/xmlfiles/chain3.xml b/test/xmlfiles/chain3.xml
new file mode 100644
index 0000000..b32fdf0
--- /dev/null
+++ b/test/xmlfiles/chain3.xml
@@ -0,0 +1,11 @@
+<chain name="foo" handle="100" bytes="59264154979" packets="2548796325" version="0">
+	<properties>
+		<type>nat</type>
+		<table>nat</table>
+		<prio>123</prio>
+		<use>321</use>
+		<hooknum>NF_INET_LOCAL_OUT</hooknum>
+		<policy>accept</policy>
+		<family>bridge</family>
+	</properties>
+</chain>
diff --git a/test/xmlfiles/rule_bitwise.xml b/test/xmlfiles/rule_bitwise.xml
new file mode 100644
index 0000000..411e28f
--- /dev/null
+++ b/test/xmlfiles/rule_bitwise.xml
@@ -0,0 +1,25 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="bitwise">
+    <sreg>2</sreg>
+    <dreg>2</dreg>
+    <mask>
+      <data_reg type="value">
+        <len>16</len>
+        <data0>0xffffffff</data0>
+        <data1>0xffffffff</data1>
+        <data2>0xffffffff</data2>
+        <data3>0x000000ff</data3>
+      </data_reg>
+    </mask>
+    <xor>
+      <data_reg type="value">
+        <len>16</len>
+        <data0>0xfaceb00c</data0>
+        <data1>0xc1cac1ca</data1>
+        <data2>0xcafecafe</data2>
+        <data3>0xdeadbeef</data3>
+      </data_reg>
+    </xor>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_byteorder.xml b/test/xmlfiles/rule_byteorder.xml
new file mode 100644
index 0000000..24e0e8d
--- /dev/null
+++ b/test/xmlfiles/rule_byteorder.xml
@@ -0,0 +1,12 @@
+<rule family="bridge" table="test" chain="test" handle="1000" version="0">
+  <rule_flags>123</rule_flags>
+  <compat_flags>123</compat_flags>
+  <compat_proto>123</compat_proto>
+  <expr type="byteorder">
+	<sreg>3</sreg>
+	<dreg>4</dreg>
+	<op>hton</op>
+	<len>4</len>
+	<size>4</size>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_cmp.xml b/test/xmlfiles/rule_cmp.xml
new file mode 100644
index 0000000..0c42271
--- /dev/null
+++ b/test/xmlfiles/rule_cmp.xml
@@ -0,0 +1,13 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="cmp">
+    <sreg>1</sreg>
+    <op>eq</op>
+    <cmpdata>
+      <data_reg type="value">
+        <len>4</len>
+        <data0>0x04000000</data0>
+      </data_reg>
+    </cmpdata>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_counter.xml b/test/xmlfiles/rule_counter.xml
new file mode 100644
index 0000000..e6ff78a
--- /dev/null
+++ b/test/xmlfiles/rule_counter.xml
@@ -0,0 +1,8 @@
+<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <flags>127</flags>
+  <expr type="counter">
+    <pkts>123123</pkts>
+    <bytes>321321</bytes>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_ct.xml b/test/xmlfiles/rule_ct.xml
new file mode 100644
index 0000000..8fff41a
--- /dev/null
+++ b/test/xmlfiles/rule_ct.xml
@@ -0,0 +1,10 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <compat_flags>0</compat_flags>
+  <compat_proto>0</compat_proto>
+  <expr type="ct">
+    <dreg>4</dreg>
+    <dir>1</dir>
+    <key>state</key>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_exthdr.xml b/test/xmlfiles/rule_exthdr.xml
new file mode 100644
index 0000000..bc848ef
--- /dev/null
+++ b/test/xmlfiles/rule_exthdr.xml
@@ -0,0 +1,9 @@
+<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="exthdr">
+    <dreg>3</dreg>
+    <exthdr_type>mh</exthdr_type>
+    <offset>123</offset>
+    <len>256</len>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_immediate.xml b/test/xmlfiles/rule_immediate.xml
new file mode 100644
index 0000000..d58a13d
--- /dev/null
+++ b/test/xmlfiles/rule_immediate.xml
@@ -0,0 +1,12 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="immediate">
+    <dreg>1</dreg>
+    <immdata>
+      <data_reg type="value">
+        <len>4</len>
+	<data0>0xaabbccdd</data0>
+      </data_reg>
+    </immdata>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_limit.xml b/test/xmlfiles/rule_limit.xml
new file mode 100644
index 0000000..92a2bd9
--- /dev/null
+++ b/test/xmlfiles/rule_limit.xml
@@ -0,0 +1,7 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="limit">
+    <rate>123123</rate>
+    <depth>321321</depth>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_log.xml b/test/xmlfiles/rule_log.xml
new file mode 100644
index 0000000..e33ff25
--- /dev/null
+++ b/test/xmlfiles/rule_log.xml
@@ -0,0 +1,9 @@
+<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="log">
+    <group>10</group>
+    <snaplen>4000000</snaplen>
+    <qthreshold>1222222</qthreshold>
+    <prefix>prefixtest</prefix>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_lookup.xml b/test/xmlfiles/rule_lookup.xml
new file mode 100644
index 0000000..5d6f114
--- /dev/null
+++ b/test/xmlfiles/rule_lookup.xml
@@ -0,0 +1,8 @@
+<rule family="bridge" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="lookup">
+    <sreg>2</sreg>
+    <dreg>1</dreg>
+    <set>set_name_test</set>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_match.xml b/test/xmlfiles/rule_match.xml
new file mode 100644
index 0000000..1738aa1
--- /dev/null
+++ b/test/xmlfiles/rule_match.xml
@@ -0,0 +1,6 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="match">
+    <name>state</name>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_meta.xml b/test/xmlfiles/rule_meta.xml
new file mode 100644
index 0000000..7e2f57a
--- /dev/null
+++ b/test/xmlfiles/rule_meta.xml
@@ -0,0 +1,7 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="meta">
+    <dreg>1</dreg>
+    <key>oifname</key>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_nat.xml b/test/xmlfiles/rule_nat.xml
new file mode 100644
index 0000000..531e7f9
--- /dev/null
+++ b/test/xmlfiles/rule_nat.xml
@@ -0,0 +1,11 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="nat">
+    <sreg_addr_min>1</sreg_addr_min>
+    <sreg_addr_max>1</sreg_addr_max>
+    <sreg_proto_min>1</sreg_proto_min>
+    <sreg_proto_max>2</sreg_proto_max>
+    <family>ip</family>
+    <nat_type>dnat</nat_type>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_nat6.xml b/test/xmlfiles/rule_nat6.xml
new file mode 100644
index 0000000..17a97f7
--- /dev/null
+++ b/test/xmlfiles/rule_nat6.xml
@@ -0,0 +1,11 @@
+<rule family="ip6" table="nat" chain="OUTPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="nat">
+    <family>ip6</family>
+    <nat_type>snat</nat_type>
+    <sreg_addr_min>2</sreg_addr_min>
+    <sreg_addr_max>2</sreg_addr_max>
+    <sreg_proto_min>1</sreg_proto_min>
+    <sreg_proto_max>2</sreg_proto_max>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_payload.xml b/test/xmlfiles/rule_payload.xml
new file mode 100644
index 0000000..a7846d6
--- /dev/null
+++ b/test/xmlfiles/rule_payload.xml
@@ -0,0 +1,9 @@
+<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="payload">
+    <dreg>1</dreg>
+    <base>transport</base>
+    <offset>12</offset>
+    <len>4</len>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/rule_target.xml b/test/xmlfiles/rule_target.xml
new file mode 100644
index 0000000..2a4f5e9
--- /dev/null
+++ b/test/xmlfiles/rule_target.xml
@@ -0,0 +1,6 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="target">
+    <name>LOG</name>
+  </expr>
+</rule>
diff --git a/test/xmlfiles/table1.xml b/test/xmlfiles/table1.xml
new file mode 100644
index 0000000..d1f4692
--- /dev/null
+++ b/test/xmlfiles/table1.xml
@@ -0,0 +1,6 @@
+<table name="filter" version="0">
+	<properties>
+		<family>ip</family>
+		<table_flags>0</table_flags>
+	</properties>
+</table>
diff --git a/test/xmlfiles/table2.xml b/test/xmlfiles/table2.xml
new file mode 100644
index 0000000..9fa25be
--- /dev/null
+++ b/test/xmlfiles/table2.xml
@@ -0,0 +1,6 @@
+<table name="nat" version="0">
+	<properties>
+		<family>ip6</family>
+		<table_flags>123</table_flags>
+	</properties>
+</table>

