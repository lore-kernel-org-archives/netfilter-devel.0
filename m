From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/2] examples: nft-set-json-add: generalize parsing
 format support
Date: Fri, 26 Sep 2014 20:34:42 +0200
Message-ID: <20140926183442.3333.62136.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:45194 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752861AbaIZSeu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:34:50 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 569A151EF6C
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 18:34:46 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AgHVK09b8EwS for <netfilter-devel@vger.kernel.org>;
	Fri, 26 Sep 2014 20:34:40 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id B6BCD51EF62
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 20:34:40 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's create a single code example with XML/JSON support.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/Makefile.am         |    6 +-
 examples/nft-set-json-add.c  |  124 ----------------------------------=
-
 examples/nft-set-parse-add.c |  147 ++++++++++++++++++++++++++++++++++=
++++++++
 3 files changed, 150 insertions(+), 127 deletions(-)
 delete mode 100644 examples/nft-set-json-add.c
 create mode 100644 examples/nft-set-parse-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 2559f5c..fafcb76 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -15,7 +15,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-rule-get		\
 		 nft-events		\
 		 nft-set-add		\
-		 nft-set-json-add	\
+		 nft-set-parse-add	\
 		 nft-set-get		\
 		 nft-set-del		\
 		 nft-set-elem-add	\
@@ -69,8 +69,8 @@ nft_events_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS=
}
 nft_set_add_SOURCES =3D nft-set-add.c
 nft_set_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
-nft_set_json_add_SOURCES =3D nft-set-json-add.c
-nft_set_json_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
+nft_set_parse_add_SOURCES =3D nft-set-parse-add.c
+nft_set_parse_add_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
=20
 nft_set_del_SOURCES =3D nft-set-del.c
 nft_set_del_LDADD =3D ../src/libnftnl.la ${LIBMNL_LIBS}
diff --git a/examples/nft-set-json-add.c b/examples/nft-set-json-add.c
deleted file mode 100644
index a4535da..0000000
--- a/examples/nft-set-json-add.c
+++ /dev/null
@@ -1,124 +0,0 @@
-/*
- * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
- *
- * Based on nft-set-xml-add from:
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
-#include <libnftnl/set.h>
-
-int main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
-	struct nft_set *s;
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
-	s =3D nft_set_alloc();
-	if (s =3D=3D NULL) {
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
-	if (nft_set_parse(s, NFT_PARSE_JSON, json, err) < 0) {
-		nft_parse_perror("Unable to parse JSON file", err);
-		exit(EXIT_FAILURE);
-	}
-
-	nft_set_snprintf(reprint, sizeof(reprint), s, NFT_OUTPUT_JSON, 0);
-	printf("Parsed:\n%s\n", reprint);
-
-	family =3D nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
-
-	seq =3D time(NULL);
-
-	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, family,
-					NLM_F_CREATE|NLM_F_ACK, seq);
-	nft_set_nlmsg_build_payload(nlh, s);
-	nft_set_free(s);
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
-
-	mnl_socket_close(nl);
-
-	return EXIT_SUCCESS;
-}
diff --git a/examples/nft-set-parse-add.c b/examples/nft-set-parse-add.=
c
new file mode 100644
index 0000000..b74ad7f
--- /dev/null
+++ b/examples/nft-set-parse-add.c
@@ -0,0 +1,147 @@
+/*
+ * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * Based on nft-set-xml-add from:
+ *
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2013 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
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
+#include <errno.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftnl/set.h>
+
+static struct nft_set *set_parse_file(const char *file, uint16_t forma=
t)
+{
+	int fd;
+	struct nft_set *s;
+	struct nft_parse_err *err;
+	char data[4096];
+
+	s =3D nft_set_alloc();
+	if (s =3D=3D NULL) {
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
+	close(fd);
+
+	err =3D nft_parse_err_alloc();
+	if (err =3D=3D NULL) {
+		perror("error");
+		return NULL;
+	}
+
+	if (nft_set_parse(s, format, data, err) < 0) {
+		nft_parse_perror("Unable to parse file", err);
+		nft_parse_err_free(err);
+		return NULL;
+	}
+
+	nft_parse_err_free(err);
+	return s;
+
+}
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_set *s;
+	int ret;
+	uint16_t family, format, outformat;
+
+	if (argc < 2) {
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
+	s =3D set_parse_file(argv[2], format);
+	if (s =3D=3D NULL)
+		exit(EXIT_FAILURE);
+
+	nft_set_fprintf(stdout, s, outformat, 0);
+	fprintf(stdout, "\n");
+
+	family =3D nft_set_attr_get_u32(s, NFT_SET_ATTR_FAMILY);
+
+	seq =3D time(NULL);
+
+	nlh =3D nft_set_nlmsg_build_hdr(buf, NFT_MSG_NEWSET, family,
+					NLM_F_CREATE|NLM_F_ACK, seq);
+	nft_set_nlmsg_build_payload(nlh, s);
+	nft_set_free(s);
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
+
+	mnl_socket_close(nl);
+
+	return EXIT_SUCCESS;
+}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
