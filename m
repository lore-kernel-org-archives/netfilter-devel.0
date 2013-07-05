From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] examples: nft-table-get different families
 options
Date: Fri, 05 Jul 2013 14:41:35 +0200
Message-ID: <20130705124135.23285.58726.stgit@Ph0enix>
References: <20130705123837.23285.5489.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47058 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEMlh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:41:37 -0400
Received: by mail-wg0-f46.google.com with SMTP id c11so1918167wgh.13
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 05:41:36 -0700 (PDT)
In-Reply-To: <20130705123837.23285.5489.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-table-get.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index 0d7746c..eab78de 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -50,11 +50,27 @@ int main(int argc, char *argv[])
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t portid, seq;
+	uint32_t portid, seq, family;
 	struct nft_table *t =3D NULL;
 	int ret;
 	uint32_t type =3D NFT_TABLE_O_DEFAULT;
=20
+	if (argc < 2 || argc > 4) {
+		fprintf(stderr, "%s <family> [<table>] [default|xml|json]\n", argv[0=
]);
+		return EXIT_FAILURE;
+	}
+
+	if (strcmp(argv[1], "ip") =3D=3D 0)
+		family =3D AF_INET;
+	else if (strcmp(argv[1], "ip6") =3D=3D 0)
+		family =3D AF_INET6;
+	else if (strcmp(argv[1], "bridge") =3D=3D 0)
+		family =3D AF_BRIDGE;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, bridge\n");
+		exit(EXIT_FAILURE);
+	}
+
 	if (strcmp(argv[argc-1], "xml") =3D=3D 0) {
 		type =3D NFT_TABLE_O_XML;
 		argv[argc-1] =3D NULL;
@@ -67,7 +83,7 @@ int main(int argc, char *argv[])
 		argc--;
 	}
=20
-	if (argc =3D=3D 2) {
+	if (argc =3D=3D 3) {
 		t =3D nft_table_alloc();
 		if (t =3D=3D NULL) {
 			perror("OOM");
@@ -77,12 +93,12 @@ int main(int argc, char *argv[])
=20
 	seq =3D time(NULL);
 	if (t =3D=3D NULL) {
-		nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, AF_INET,
+		nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 						NLM_F_DUMP, seq);
 	} else {
-		nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, AF_INET,
+		nlh =3D nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 						NLM_F_ACK, seq);
-		nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[1]);
+		nft_table_attr_set(t, NFT_TABLE_ATTR_NAME, argv[2]);
 		nft_table_nlmsg_build_payload(nlh, t);
 		nft_table_free(t);
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
