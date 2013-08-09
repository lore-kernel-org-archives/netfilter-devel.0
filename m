From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 12/13] example: nft-rule-get: family parameter
 added
Date: Fri, 09 Aug 2013 13:14:31 +0200
Message-ID: <20130809111431.29819.64631.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62296 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILOl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:14:41 -0400
Received: by mail-wi0-f169.google.com with SMTP id f14so1629567wiw.0
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:14:40 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

I have added the parameter family in the example nft-rule-get.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 examples/nft-rule-get.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 2404f27..e78a5cf 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <netinet/in.h>
=20
+#include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
=20
 #include <libmnl/libmnl.h>
@@ -52,13 +53,31 @@ int main(int argc, char *argv[])
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq, type =3D NFT_RULE_O_DEFAULT;
 	struct nft_rule *t =3D NULL;
-	int ret;
+	int ret, family;
=20
-	if (argc =3D=3D 2 && strcmp(argv[1], "xml") =3D=3D 0 ){
+	if (argc < 2 || argc > 3) {
+		fprintf(stderr, "Usage: %s <family> [xml|json]\n",
+			argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (strcmp(argv[1], "ip") =3D=3D 0)
+		family =3D NFPROTO_IPV4;
+	else if (strcmp(argv[1], "ip6") =3D=3D 0)
+		family =3D NFPROTO_IPV6;
+	else if (strcmp(argv[1], "bridge") =3D=3D 0)
+		family =3D NFPROTO_BRIDGE;
+	else if (strcmp(argv[1], "arp") =3D=3D 0)
+		family =3D NFPROTO_ARP;
+	else {
+		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc =3D=3D 3 && strcmp(argv[2], "xml") =3D=3D 0 )
 		type =3D NFT_RULE_O_XML;
-	}else if (argc =3D=3D 2 && strcmp(argv[1], "json") =3D=3D 0 ){
+	else if (argc =3D=3D 3 && strcmp(argv[2], "json") =3D=3D 0 )
 		type =3D NFT_RULE_O_JSON;
-	}
=20
 	/* XXX requires table, chain and handle attributes for selective get =
*/
=20
@@ -69,7 +88,7 @@ int main(int argc, char *argv[])
 	}
=20
 	seq =3D time(NULL);
-	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, AF_INET,
+	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 					NLM_F_DUMP, seq);
=20
 	nl =3D mnl_socket_open(NETLINK_NETFILTER);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
