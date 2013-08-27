From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 4/4] examples: Add nft-set-json-add
Date: Tue, 27 Aug 2013 20:11:02 +0200
Message-ID: <20130827181102.9399.70961.stgit@Ph0enix>
References: <20130827181037.9399.30579.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57244 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3H0SLZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:11:25 -0400
Received: by mail-wi0-f169.google.com with SMTP id l12so5773804wiv.4
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2013 11:11:24 -0700 (PDT)
In-Reply-To: <20130827181037.9399.30579.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/Makefile.am        |    4 +
 examples/nft-set-json-add.c |  116 +++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 examples/nft-set-json-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 639aafb..9965387 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -19,6 +19,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-rule-get		\
 		 nft-events		\
 		 nft-set-add		\
+		 nft-set-json-add	\
 		 nft-set-get		\
 		 nft-set-del		\
 		 nft-set-elem-add	\
@@ -83,6 +84,9 @@ nft_events_LDADD =3D ../src/libnftables.la ${LIBMNL_L=
IBS}
 nft_set_add_SOURCES =3D nft-set-add.c
 nft_set_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
+nft_set_json_add_SOURCES =3D nft-set-json-add.c
+nft_set_json_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
 nft_set_del_SOURCES =3D nft-set-del.c
 nft_set_del_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
diff --git a/examples/nft-set-json-add.c b/examples/nft-set-json-add.c
new file mode 100644
index 0000000..33c3acd
--- /dev/null
+++ b/examples/nft-set-json-add.c
@@ -0,0 +1,116 @@
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
+#include <libnftables/set.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_set *s;
+	int ret, fd;
+	uint16_t family;
+	char json[4096];
+	char reprint[4096];
+
+	if (argc < 2) {
+		printf("Usage: %s <json-file>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	s =3D nft_set_alloc();
+	if (s =3D=3D NULL) {
+		perror("OOM");
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
+
+	close(fd);
+
+	if (nft_set_parse(s, NFT_SET_PARSE_JSON, json) < 0) {
+		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	nft_set_snprintf(reprint, sizeof(reprint), s, NFT_SET_O_JSON, 0);
+	printf("Parsed:\n%s\n", reprint);
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
