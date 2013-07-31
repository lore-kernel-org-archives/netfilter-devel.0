From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 7/7] examples: Add nft-chain-json-add
Date: Wed, 31 Jul 2013 15:21:34 +0200
Message-ID: <20130731132134.29730.13415.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50110 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759586Ab3GaNVj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:39 -0400
Received: by mail-we0-f170.google.com with SMTP id w60so606685wes.15
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:37 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/Makefile.am          |    4 +
 examples/nft-chain-json-add.c |  118 +++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 122 insertions(+)
 create mode 100644 examples/nft-chain-json-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index 722ce0b..8d76f00 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -8,6 +8,7 @@ check_PROGRAMS =3D nft-table-add		\
 		 nft-table-get		\
 		 nft-chain-add		\
 		 nft-chain-xml-add	\
+		 nft-chain-json-add	\
 		 nft-chain-del		\
 		 nft-chain-get		\
 		 nft-rule-add		\
@@ -48,6 +49,9 @@ nft_chain_add_LDADD =3D ../src/libnftables.la ${LIBMN=
L_LIBS}
 nft_chain_xml_add_SOURCES =3D nft-chain-xml-add.c
 nft_chain_xml_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
+nft_chain_json_add_SOURCES =3D nft-chain-json-add.c
+nft_chain_json_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS} ${LI=
BXML_LIBS} ${LIBJSON_LIBS}
+
 nft_chain_del_SOURCES =3D nft-chain-del.c
 nft_chain_del_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
diff --git a/examples/nft-chain-json-add.c b/examples/nft-chain-json-ad=
d.c
new file mode 100644
index 0000000..42e2d82
--- /dev/null
+++ b/examples/nft-chain-json-add.c
@@ -0,0 +1,118 @@
+/*
+ * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * Based on nft-chain-xml-add from:
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
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_chain *c =3D NULL;
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
+	c =3D nft_chain_alloc();
+	if (c =3D=3D NULL) {
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
+	if (nft_chain_parse(c, NFT_CHAIN_PARSE_JSON, json) < 0) {
+		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	nft_chain_snprintf(reprint, sizeof(reprint), c, NFT_CHAIN_O_JSON, 0);
+	printf("Parsed:\n%s\n", reprint);
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
+	}
+	if (ret =3D=3D -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+
+	mnl_socket_close(nl);
+	return EXIT_SUCCESS;
+}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
