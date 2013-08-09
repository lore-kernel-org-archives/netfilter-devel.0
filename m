From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 10/13] expr: nat: add nft_str2nat function
Date: Fri, 09 Aug 2013 13:13:59 +0200
Message-ID: <20130809111359.29819.5548.stgit@Ph0enix>
References: <20130809111148.29819.95689.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:43160 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967573Ab3HILOK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:14:10 -0400
Received: by mail-we0-f178.google.com with SMTP id u57so3469443wes.9
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:14:09 -0700 (PDT)
In-Reply-To: <20130809111148.29819.95689.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function that will be use in the JSON parser

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/nat.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/src/expr/nat.c b/src/expr/nat.c
index 654d4d7..c81dc7f 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -15,6 +15,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <limits.h>
+#include <string.h>
 #include <errno.h>
 #include <arpa/inet.h>
 #include <libmnl/libmnl.h>
@@ -183,6 +184,17 @@ nft_rule_expr_nat_build(struct nlmsghdr *nlh, stru=
ct nft_rule_expr *e)
 				 htonl(nat->sreg_proto_max));
 }
=20
+static inline int nft_str2nat(const char *nat)
+{
+	if (strcmp(nat, "snat") =3D=3D 0)
+		return NFT_NAT_SNAT;
+	else if (strcmp(nat, "dnat") =3D=3D 0)
+		return NFT_NAT_DNAT;
+	else {
+		errno =3D EINVAL;
+		return -1;
+	}
+}
=20
 static int nft_rule_expr_nat_xml_parse(struct nft_rule_expr *e, mxml_n=
ode_t *tree)
 {
@@ -190,19 +202,17 @@ static int nft_rule_expr_nat_xml_parse(struct nft=
_rule_expr *e, mxml_node_t *tre
 	struct nft_expr_nat *nat =3D nft_expr_data(e);
 	const char *nat_type;
 	int32_t reg;
-	int family;
+	int family, nat_type_value;
=20
 	nat_type =3D nft_mxml_str_parse(tree, "nat_type", MXML_DESCEND_FIRST)=
;
 	if (nat_type =3D=3D NULL)
 		return -1;
=20
-	if (strcmp(nat_type, "snat") =3D=3D 0) {
-		nat->type =3D NFT_NAT_SNAT;
-	} else if (strcmp(nat_type, "dnat") =3D=3D 0) {
-		nat->type =3D NFT_NAT_DNAT;
-	} else
-		goto err;
+	nat_type_value =3D nft_str2nat(nat_type);
+	if (nat_type_value < 0)
+		return -1;
=20
+	nat->type =3D nat_type_value;
 	e->flags |=3D (1 << NFT_EXPR_NAT_TYPE);
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST);
@@ -243,9 +253,6 @@ static int nft_rule_expr_nat_xml_parse(struct nft_r=
ule_expr *e, mxml_node_t *tre
 	e->flags |=3D (1 << NFT_EXPR_NAT_REG_PROTO_MAX);
=20
 	return 0;
-err:
-	errno =3D EINVAL;
-	return -1;
 #else
 	errno =3D EOPNOTSUPP;
 	return -1;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
