From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 3/6] examples: Add nft-table-json-add
Date: Thu, 25 Jul 2013 22:52:32 +0200
Message-ID: <20130725205232.26223.56829.stgit@Ph0enix>
References: <20130725205215.26223.77001.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46926 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYUwg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:52:36 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so2133763wgh.7
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 13:52:35 -0700 (PDT)
In-Reply-To: <20130725205215.26223.77001.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/Makefile.am          |    4 +
 examples/nft-table-json-add.c |  116 +++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 examples/nft-table-json-add.c

diff --git a/examples/Makefile.am b/examples/Makefile.am
index bf28bae..722ce0b 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -2,6 +2,7 @@ include $(top_srcdir)/Make_global.am
=20
 check_PROGRAMS =3D nft-table-add		\
 		 nft-table-xml-add	\
+		 nft-table-json-add	\
 		 nft-table-upd		\
 		 nft-table-del		\
 		 nft-table-get		\
@@ -29,6 +30,9 @@ nft_table_add_LDADD =3D ../src/libnftables.la ${LIBMN=
L_LIBS}
 nft_table_xml_add_SOURCES =3D nft-table-xml-add.c
 nft_table_xml_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
+nft_table_json_add_SOURCES =3D nft-table-json-add.c
+nft_table_json_add_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
+
 nft_table_upd_SOURCES =3D nft-table-upd.c
 nft_table_upd_LDADD =3D ../src/libnftables.la ${LIBMNL_LIBS}
=20
diff --git a/examples/nft-table-json-add.c b/examples/nft-table-json-ad=
d.c
new file mode 100644
index 0000000..5526c91
--- /dev/null
+++ b/examples/nft-table-json-add.c
@@ -0,0 +1,116 @@
+/*
+ * (C) 2013 by =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>
+ *
+ * Based on nft-table-xml-add from:
+ *
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
+#include <netinet/in.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/table.h>
+
+int main(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nft_table *t =3D NULL;
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
+	t =3D nft_table_alloc();
+	if (t =3D=3D NULL) {
+		perror("OOM");
+		exit(EXIT_FAILURE);
+	}
+
+	if (nft_table_parse(t, NFT_TABLE_PARSE_JSON, json) < 0) {
+		printf("E: Unable to parse JSON file: %s\n", strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	nft_table_snprintf(reprint, sizeof(reprint), t, NFT_TABLE_O_JSON, 0);
+	printf("Parsed:\n%s\n", reprint);
+
+	family =3D nft_table_attr_get_u32(t, NFT_TABLE_ATTR_FAMILY);
+
+	seq =3D time(NULL);
+
+	nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_NEWTABLE, family,
+					NLM_F_CREATE|NLM_F_ACK, seq);
+	nft_table_nlmsg_build_payload(nlh, t);
+	nft_table_free(t);
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
