From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 3/3] examples: Add nft-rule-json-add
Date: Tue, 20 Aug 2013 17:59:03 +0200
Message-ID: <20130820155903.8850.44422.stgit@Ph0enix>
References: <20130820155844.8850.85717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:60089 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3HTP70 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:59:26 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so581101wev.22
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2013 08:59:25 -0700 (PDT)
In-Reply-To: <20130820155844.8850.85717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/Makefile.am         |    4 +
 examples/nft-rule-json-add.c |  117 ++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 examples/nft-rule-json-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 8d76f00..639aafb 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -14,6 +14,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-rule-add		\
 		 nft-rule-insert	\
 		 nft-rule-xml-add	\
+		 nft-rule-json-add	\
 		 nft-rule-del		\
 		 nft-rule-get		\
 		 nft-events		\
@@ -67,6 +68,9 @@ nft_rule_insert_LDADD =3D ../src/libnftables.la ${LIB=
MNL_LIBS} ${LIBXML_LIBS}
 nft_rule_xml_add_SOURCES =3D nft-rule-xml-add.c
 nft_rule_xml_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
+nft_rule_json_add_SOURCES =3D nft-rule-json-add.c
+nft_rule_json_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
 nft_rule_del_SOURCES =3D nft-rule-del.c
 nft_rule_del_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
diff --git a/examples/nft-rule-json-add.c b/examples/nft-rule-json-add.=
c
new file mode 100644
index 0000000..bf56b89
--- /dev/null
+++ b/examples/nft-rule-json-add.c
@@ -0,0 +1,117 @@
+/*
+ * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * Based on nft-rule-xml-add from:
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
+#include <libnftables/rule.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_rule *r =3D NULL;
+	int ret, fd;
+	uint8_t family;
+	char json[4096];
+	char reprint[4096];
+
+	if (argc < 2) {
+		printf("Usage: %s <json-file>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	fd =3D open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	if (read(fd, json, sizeof(json)) < 0) {
+		perror("read");
+		close(fd);
+		exit(EXIT_FAILURE);
+	}
+	close(fd);
+
+	r =3D nft_rule_alloc();
+	if (r =3D=3D NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_rule_parse(r, NFT_RULE_PARSE_JSON, json) < 0) {
+		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	nft_rule_snprintf(reprint, sizeof(reprint), r, NFT_RULE_O_JSON, 0);
+	printf("Parsed:\n%s\n", reprint);
+
+	nft_rule_attr_unset(r, NFT_RULE_ATTR_HANDLE);
+	family =3D nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
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

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
