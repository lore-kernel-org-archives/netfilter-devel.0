From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] examples: merge nft-rule-{xml|json}-add.c
Date: Tue, 23 Sep 2014 13:15:21 +0200
Message-ID: <20140923111521.4630.78017.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49748 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754980AbaIWLPZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:15:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Merge the two examples in just one. An input argument choose the format=
 to use.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am          |   10 +--
 examples/nft-rule-json-add.c  |  123 ---------------------------------=
-
 examples/nft-rule-parse-add.c |  148 +++++++++++++++++++++++++++++++++=
++++++++
 examples/nft-rule-xml-add.c   |  123 ---------------------------------=
-
 4 files changed, 151 insertions(+), 253 deletions(-)
 delete mode 100644 examples/nft-rule-json-add.c
 create mode 100644 examples/nft-rule-parse-add.c
 delete mode 100644 examples/nft-rule-xml-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 69f5c7f..2559f5c 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -10,8 +10,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-chain-del		\
 		 nft-chain-get		\
 		 nft-rule-add		\
-		 nft-rule-xml-add	\
-		 nft-rule-json-add	\
+		 nft-rule-parse-add	\
 		 nft-rule-del		\
 		 nft-rule-get		\
 		 nft-events		\
@@ -55,11 +54,8 @@ nft_chain_get_LDADD =3D ../src/libnftnl.la ${LIBMNL_=
LIBS}
 nft_rule_add_SOURCES =3D nft-rule-add.c
 nft_rule_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
-nft_rule_xml_add_SOURCES =3D nft-rule-xml-add.c
-nft_rule_xml_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
-
-nft_rule_json_add_SOURCES =3D nft-rule-json-add.c
-nft_rule_json_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
+nft_rule_parse_add_SOURCES =3D nft-rule-parse-add.c
+nft_rule_parse_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
 nft_rule_del_SOURCES =3D nft-rule-del.c
 nft_rule_del_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-rule-json-add.c b/examples/nft-rule-json-add.=
c
deleted file mode 100644
index b33025b..0000000
--- a/examples/nft-rule-json-add.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
- *
- * Based on nft-rule-xml-add from:
- *
- * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modif=
y it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <stdlib.h>
-#include <time.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <string.h>
-#include <netinet/in.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/rule.h>
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_rule *r =3D NULL;
-	int ret, fd;
-	uint8_t family;
-	char json[4096];
-	char reprint[4096];
-	struct nft_parse_err *err;
-
-	if (argc < 2) {
-		printf("Usage: %s <json-file>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	fd =3D open(argv[1], O_RDONLY);
-	if (fd < 0) {
-		perror("open");
-		exit(EXIT_FAILURE);
-	}
-
-	if (read(fd, json, sizeof(json)) < 0) {
-		perror("read");
-		close(fd);
-		exit(EXIT_FAILURE);
-	}
-	close(fd);
-
-	r =3D nft_rule_alloc();
-	if (r =3D=3D NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
-	err =3D nft_parse_err_alloc();
-	if (err =3D=3D NULL) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-
-	if (nft_rule_parse(r, NFT_PARSE_JSON, json, err) < 0) {
-		nft_parse_perror("Unable to parse JSON file", err);
-		exit(EXIT_FAILURE);
-	}
-
-	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_OUTPUT_JSON, 0);
-	printf("Parsed:\n%s\n", reprint);
-
-	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
-	family =3D nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-
-	seq =3D time(NULL);
-	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
-				       NLM_F_CREATE|NLM_F_APPEND|NLM_F_ACK,
-				       seq);
-	nft_rule_nlmsg_build_payload(nlh, r);
-	nft_rule_free(r);
-	nft_parse_err_free(err);
-
-	nl =3D mnl_socket_open(NETLINK_NETFILTER);
-	if (nl =3D=3D NULL) {
-		perror("mnl_socket_open");
-		exit(EXIT_FAILURE);
-	}
-
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
-		exit(EXIT_FAILURE);
-	}
-	portid =3D mnl_socket_get_portid(nl);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <=3D 0)
-			break;
-		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret =3D=3D -1) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-	mnl_socket_close(nl);
-
-	return EXIT_SUCCESS;
-}
diff --git a/examples/nft-rule-parse-add.c b/examples/nft-rule-parse-ad=
d.c
new file mode 100644
index 0000000..8b6152a
--- /dev/null
+++ b/examples/nft-rule-parse-add.c
@@ -0,0 +1,148 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Sophos Astaro <http://www.sophos.co=
m>
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
+#include <errno.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/rule.h>
+
+static struct nft_rule *rule_parse_file(const char *file, uint16_t for=
mat)
+{
+	int fd;
+	struct nft_rule *r;
+	struct nft_parse_err *err;
+	char data[4096];
+
+	fd =3D open(file, O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return NULL;
+	}
+
+	if (read(fd, data, sizeof(data)) < 0) {
+		perror("read");
+		close(fd);
+		return NULL;
+	}
+	close(fd);
+
+	r =3D nft_rule_alloc();
+	if (r =3D=3D NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	err =3D nft_parse_err_alloc();
+	if (err =3D=3D NULL) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_rule_parse(r, format, data, err) < 0) {
+		nft_parse_perror("Unable to parse file", err);
+		nft_parse_err_free(err);
+		nft_rule_free(r);
+		return NULL;
+	}
+
+	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
+
+	nft_parse_err_free(err);
+	return r;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_rule *r;
+	int ret;
+	uint16_t family, format, outformat;
+
+	if (argc < 3) {
+		printf("Usage: %s {xml|json} <file>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "xml") =3D=3D 0) {
+		format =3D NFT_PARSE_XML;
+		outformat =3D NFT_OUTPUT_XML;
+	} else if (strcmp(argv[1], "json") =3D=3D 0) {
+		format =3D NFT_PARSE_JSON;
+		outformat =3D NFT_OUTPUT_JSON;
+	} else {
+		printf("Unknown format: xml, json\n");
+		exit(EXIT_FAILURE);
+	}
+
+	r =3D rule_parse_file(argv[2], format);
+	if (r =3D=3D NULL)
+		exit(EXIT_FAILURE);
+
+	nft_rule_fprintf(stdout, r, outformat, 0);
+	fprintf(stdout, "\n");
+
+	family =3D nft_rule_attr_get_u32(r, NFT_RULE_ATTR_FAMILY);
+
+	seq =3D time(NULL);
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
+				       NLM_F_CREATE|NLM_F_APPEND|NLM_F_ACK,
+				       seq);
+	nft_rule_nlmsg_build_payload(nlh, r);
+	nft_rule_free(r);
+
+	nl =3D mnl_socket_open(NETLINK_NETFILTER);
+	if (nl =3D=3D NULL) {
+		perror("mnl_socket_open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		exit(EXIT_FAILURE);
+	}
+	portid =3D mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
+
+	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		if (ret <=3D 0)
+			break;
+		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret =3D=3D -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-rule-xml-add.c b/examples/nft-rule-xml-add.c
deleted file mode 100644
index dd16922..0000000
--- a/examples/nft-rule-xml-add.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modif=
y it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This code has been sponsored by Sophos Astaro <http://www.sophos.co=
m>
- */
-
-#include <stdlib.h>
-#include <time.h>
-#include <string.h>
-#include <stddef.h>	/* for offsetof */
-#include <netinet/in.h>
-#include <arpa/inet.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/rule.h>
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_rule *r =3D NULL;
-	int ret, fd;
-	uint8_t family;
-	char xml[4096];
-	char reprint[4096];
-	struct nft_parse_err *err;
-
-	if (argc < 2) {
-		printf("Usage: %s <xml-file>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	fd =3D open(argv[1], O_RDONLY);
-	if (fd < 0) {
-		perror("open");
-		exit(EXIT_FAILURE);
-	}
-
-	if (read(fd, xml, sizeof(xml)) < 0) {
-		perror("read");
-		close(fd);
-		exit(EXIT_FAILURE);
-	}
-	close(fd);
-
-	r =3D nft_rule_alloc();
-	if (r =3D=3D NULL) {
-		perror("OOM");
-		exit(EXIT_FAILURE);
-	}
-
-	err =3D nft_parse_err_alloc();
-	if (err =3D=3D NULL) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-
-	if (nft_rule_parse(r, NFT_PARSE_XML, xml, err) < 0) {
-		nft_parse_perror("Unable to parse XML file", err);
-		exit(EXIT_FAILURE);
-	}
-
-	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_OUTPUT_XML, 0);
-	printf("Parsed:\n%s\n", reprint);
-
-	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
-	family =3D nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-
-	seq =3D time(NULL);
-	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_NEWRULE, family,
-				       NLM_F_CREATE|NLM_F_APPEND|NLM_F_ACK,
-				       seq);
-	nft_rule_nlmsg_build_payload(nlh, r);
-	nft_rule_free(r);
-	nft_parse_err_free(err);
-
-	nl =3D mnl_socket_open(NETLINK_NETFILTER);
-	if (nl =3D=3D NULL) {
-		perror("mnl_socket_open");
-		exit(EXIT_FAILURE);
-	}
-
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
-		perror("mnl_socket_bind");
-		exit(EXIT_FAILURE);
-	}
-	portid =3D mnl_socket_get_portid(nl);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-		perror("mnl_socket_send");
-		exit(EXIT_FAILURE);
-	}
-
-	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
-		if (ret <=3D 0)
-			break;
-		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret =3D=3D -1) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-	mnl_socket_close(nl);
-
-	return EXIT_SUCCESS;
-}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
