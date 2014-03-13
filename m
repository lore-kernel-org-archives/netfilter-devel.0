From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH v2 2/2] rule: Changed parser for being more flexible
Date: Thu, 13 Mar 2014 23:12:04 +0100
Message-ID: <1394748724-7169-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCMWMW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:12:22 -0400
Received: by mail-bk0-f46.google.com with SMTP id v15so124941bkz.33
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 15:12:21 -0700 (PDT)
Received: from localhost.localdomain (tmo-107-108.customers.d1-online.com. [80.187.107.108])
        by mx.google.com with ESMTPSA id zf3sm3660376bkb.4.2014.03.13.15.12.19
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Mar 2014 15:12:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

This change allow us to parser the rule and the kernel
bail out if the rule is well-formed.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
v2: Fixed some identation errors and used the function
nft_rule_attr_set_xx() for parsing the attributes in xml.

 src/rule.c |   72 ++++++++++++++++++++++++++--------------------------=
--------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 3aaee71..1dce1d5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -540,28 +540,36 @@ int nft_jansson_parse_rule(struct nft_rule *r, js=
on_t *tree,
 	if (root =3D=3D NULL)
 		return -1;
=20
-	if (nft_jansson_parse_family(root, &family, err) !=3D 0)
-		goto err;
+	if (nft_jansson_node_exist(root, "family")) {
+		if (nft_jansson_parse_family(root, &family, err) !=3D 0)
+			goto err;
=20
-	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
+		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
+	}
=20
-	str =3D nft_jansson_parse_str(root, "table", err);
-	if (str =3D=3D NULL)
-		goto err;
+	if (nft_jansson_node_exist(root, "table")) {
+		str =3D nft_jansson_parse_str(root, "table", err);
+		if (str =3D=3D NULL)
+			goto err;
=20
-	nft_rule_attr_set_str(r, NFT_RULE_ATTR_TABLE, str);
+		nft_rule_attr_set_str(r, NFT_RULE_ATTR_TABLE, str);
+	}
=20
-	str =3D nft_jansson_parse_str(root, "chain", err);
-	if (str =3D=3D NULL)
-		goto err;
+	if (nft_jansson_node_exist(root, "chain")) {
+		str =3D nft_jansson_parse_str(root, "chain", err);
+		if (str =3D=3D NULL)
+			goto err;
=20
-	nft_rule_attr_set_str(r, NFT_RULE_ATTR_CHAIN, str);
+		nft_rule_attr_set_str(r, NFT_RULE_ATTR_CHAIN, str);
+	}
=20
-	if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
-				  err) < 0)
-		goto err;
+	if (nft_jansson_node_exist(root, "handle")) {
+		if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval64,
+					  err) < 0)
+			goto err;
=20
-	nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
+		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
+	}
=20
 	if (nft_jansson_node_exist(root, "compat_proto") ||
 	    nft_jansson_node_exist(root, "compat_flags")) {
@@ -640,39 +648,22 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct=
 nft_rule *r,
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
-	if (family < 0)
-		return -1;
-
-	r->family =3D family;
-	r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
+	if (family >=3D 0)
+		nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
=20
 	table =3D nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
-	if (table =3D=3D NULL)
-		return -1;
-
-	if (r->table)
-		xfree(r->table);
-
-	r->table =3D strdup(table);
-	r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
+	if (table !=3D NULL)
+		nft_rule_attr_set_str(r, NFT_RULE_ATTR_TABLE, table);
=20
 	chain =3D nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
-	if (chain =3D=3D NULL)
-		return -1;
-
-	if (r->chain)
-		xfree(r->chain);
-
-	r->chain =3D strdup(chain);
-	r->flags |=3D (1 << NFT_RULE_ATTR_CHAIN);
+	if (chain !=3D NULL)
+		nft_rule_attr_set_str(r, NFT_RULE_ATTR_CHAIN, chain);
=20
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
-		return -1;
-
-	r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
+			      &r->handle, NFT_TYPE_U64, NFT_XML_MAND, err) >=3D 0)
+		r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
=20
 	if (nft_mxml_num_parse(tree, "compat_proto", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->compat.proto, NFT_TYPE_U32,
@@ -687,7 +678,6 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct n=
ft_rule *r,
 	if (nft_rule_attr_is_set(r, NFT_RULE_ATTR_COMPAT_PROTO) !=3D
 			nft_rule_attr_is_set(r, NFT_RULE_ATTR_COMPAT_FLAGS)) {
 		errno =3D EINVAL;
-		return -1;
 	}
=20
 	if (nft_mxml_num_parse(tree, "position", MXML_DESCEND_FIRST,
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
