From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] examples: merge nft-chain-{xml|json}-add.c
Date: Mon, 18 Aug 2014 21:06:14 +0200
Message-ID: <20140818190614.15504.2107.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:49053 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817AbaHRTG0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:06:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Merge the two examples in one. Use an input argument to choose the
format to parse.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am           |   10 +--
 examples/nft-chain-json-add.c  |  126 --------------------------------=
--
 examples/nft-chain-parse-add.c |  149 ++++++++++++++++++++++++++++++++=
++++++++
 examples/nft-chain-xml-add.c   |  126 --------------------------------=
--
 4 files changed, 152 insertions(+), 259 deletions(-)
 delete mode 100644 examples/nft-chain-json-add.c
 create mode 100644 examples/nft-chain-parse-add.c
 delete mode 100644 examples/nft-chain-xml-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index c45b9df..f35924d 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -7,8 +7,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-table-del		\
 		 nft-table-get		\
 		 nft-chain-add		\
-		 nft-chain-xml-add	\
-		 nft-chain-json-add	\
+		 nft-chain-parse-add	\
 		 nft-chain-del		\
 		 nft-chain-get		\
 		 nft-rule-add		\
@@ -48,11 +47,8 @@ nft_table_get_LDADD =3D ../src/libnftnl.la ${LIBMNL_=
LIBS}
 nft_chain_add_SOURCES =3D nft-chain-add.c
 nft_chain_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
-nft_chain_xml_add_SOURCES =3D nft-chain-xml-add.c
-nft_chain_xml_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
-
-nft_chain_json_add_SOURCES =3D nft-chain-json-add.c
-nft_chain_json_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS} ${LIBXM=
L_LIBS} ${LIBJSON_LIBS}
+nft_chain_parse_add_SOURCES =3D nft-chain-parse-add.c
+nft_chain_parse_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
 nft_chain_del_SOURCES =3D nft-chain-del.c
 nft_chain_del_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-chain-json-add.c b/examples/nft-chain-json-ad=
d.c
deleted file mode 100644
index 4fd0551..0000000
--- a/examples/nft-chain-json-add.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
- *
- * Based on nft-chain-xml-add from:
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
-#include <string.h>
-#include <netinet/in.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/chain.h>
-#include <libnftnl/rule.h>
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_chain *c =3D NULL;
-	int ret, fd;
-	uint16_t family;
-	char json[4096];
-	char reprint[4096];
-	struct nft_parse_err *err;
-
-	if (argc < 2) {
-		printf("Usage: %s <json-file>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	c =3D nft_chain_alloc();
-	if (c =3D=3D NULL) {
-		perror("OOM");
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
-
-	err =3D nft_parse_err_alloc();
-	if (err =3D=3D NULL) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-
-	close(fd);
-
-	if (nft_chain_parse(c, NFT_PARSE_JSON, json, err) < 0) {
-		nft_parse_perror("Unable to parse JSON file", err);
-		exit(EXIT_FAILURE);
-	}
-
-	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_OUTPUT_JSON, 0);
-	printf("Parsed:\n%s\n", reprint);
-
-	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
-	family =3D nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
-
-	seq =3D time(NULL);
-	nlh =3D nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-
-	nft_chain_free(c);
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
-
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
-
-	mnl_socket_close(nl);
-	return EXIT_SUCCESS;
-}
diff --git a/examples/nft-chain-parse-add.c b/examples/nft-chain-parse-=
add.c
new file mode 100644
index 0000000..01696ad
--- /dev/null
+++ b/examples/nft-chain-parse-add.c
@@ -0,0 +1,149 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2014 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/chain.h>
+#include <libnftnl/rule.h>
+
+static struct nft_chain *chain_parse_file(const char *file, uint16_t f=
ormat)
+{
+	int fd;
+	struct nft_chain *c;
+	struct nft_parse_err *err;
+	char data[4096];
+
+	c =3D nft_chain_alloc();
+	if (c =3D=3D NULL) {
+		perror("OOM");
+		return NULL;
+	}
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
+
+	close(fd);
+
+	err =3D nft_parse_err_alloc();
+	if (err =3D=3D NULL) {
+		perror("OOM");
+		return NULL;
+	}
+
+	if (nft_chain_parse(c, format, data, err) < 0) {
+		nft_parse_perror("Unable to parse file", err);
+		nft_parse_err_free(err);
+		return NULL;
+	}
+
+	nft_parse_err_free(err);
+	return c;
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_chain *c;
+	uint16_t family, format, outformat;
+	int ret;
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
+	c =3D chain_parse_file(argv[2], format);
+	if (c =3D=3D NULL)
+		exit(EXIT_FAILURE);
+
+	nft_chain_fprintf(stdout, c, outformat, 0);
+	fprintf(stdout, "\n");
+
+	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
+	family =3D nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
+
+	seq =3D time(NULL);
+	nlh =3D nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
+					NLM_F_CREATE|NLM_F_ACK, seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
+
+	nft_chain_free(c);
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
+
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
+
+	}
+	if (ret =3D=3D -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}
diff --git a/examples/nft-chain-xml-add.c b/examples/nft-chain-xml-add.=
c
deleted file mode 100644
index 5d26af6..0000000
--- a/examples/nft-chain-xml-add.c
+++ /dev/null
@@ -1,126 +0,0 @@
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
-#include <netinet/in.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/chain.h>
-#include <libnftnl/rule.h>
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_chain *c =3D NULL;
-	int ret, fd;
-	uint16_t family;
-	char xml[4096];
-	char reprint[4096];
-	struct nft_parse_err *err;
-
-	if (argc < 2) {
-		printf("Usage: %s <xml-file>\n", argv[0]);
-		exit(EXIT_FAILURE);
-	}
-
-	c =3D nft_chain_alloc();
-	if (c =3D=3D NULL) {
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
-        fd =3D open(argv[1], O_RDONLY);
-        if (fd < 0) {
-                perror("open");
-                exit(EXIT_FAILURE);
-        }
-
-        if (read(fd, xml, sizeof(xml)) < 0) {
-                perror("read");
-                close(fd);
-                exit(EXIT_FAILURE);
-        }
-
-	close(fd);
-
-	if (nft_chain_parse(c, NFT_PARSE_XML, xml, err) < 0) {
-		nft_parse_perror("Unable to parse XML file", err);
-		exit(EXIT_FAILURE);
-	}
-
-	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_OUTPUT_XML, 0);
-	printf("Parsed:\n%s\n", reprint);
-
-	nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
-	family =3D nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_FAMILY);
-
-	seq =3D time(NULL);
-	nlh =3D nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
-	nft_chain_nlmsg_build_payload(nlh, c);
-
-	nft_chain_free(c);
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
-
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
-
-	}
-	if (ret =3D=3D -1) {
-		perror("error");
-		exit(EXIT_FAILURE);
-	}
-
-
-	mnl_socket_close(nl);
-	return EXIT_SUCCESS;
-}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
