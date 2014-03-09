From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH 2/2] src/rule: Changed parser support for having
 consistent with the new print support
Date: Sun, 09 Mar 2014 14:00:05 +0100
Message-ID: <20140309130005.23270.28970.stgit@Ph0enix>
References: <20140309125959.23270.43422.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:32927 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaCINAU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 09:00:20 -0400
Received: by mail-bk0-f49.google.com with SMTP id my13so1082414bkb.36
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2014 06:00:18 -0700 (PDT)
Received: from [127.0.1.1] ([2001:bf0:c001:30:10b9:5ac6:6d77:434d])
        by mx.google.com with ESMTPSA id z3sm8419031bkn.3.2014.03.09.06.00.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Mar 2014 06:00:18 -0700 (PDT)
In-Reply-To: <20140309125959.23270.43422.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/rule.c |   77 +++++++++++++++++++++++++++++++---------------------=
--------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index f0cafd3..e7335f8 100644
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
 	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
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
+				  	  err) < 0)
+			goto err;
=20
-	nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
+		nft_rule_attr_set_u64(r, NFT_RULE_ATTR_HANDLE, uval64);
+	}
=20
 	if (nft_jansson_node_exist(root, "compat_proto") ||
 	    nft_jansson_node_exist(root, "compat_flags")) {
@@ -640,39 +648,34 @@ int nft_mxml_rule_parse(mxml_node_t *tree, struct=
 nft_rule *r,
=20
 	family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND_FIRST,
 				       NFT_XML_MAND, err);
-	if (family < 0)
-		return -1;
-
-	r->family =3D family;
-	r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
+	if (family >=3D 0) {
+		r->family =3D family;
+		r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
+	}
=20
 	table =3D nft_mxml_str_parse(tree, "table", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
-	if (table =3D=3D NULL)
-		return -1;
-
-	if (r->table)
-		xfree(r->table);
+	if (table !=3D NULL) {
+		if (r->table)
+			xfree(r->table);
=20
-	r->table =3D strdup(table);
-	r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
+		r->table =3D strdup(table);
+		r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
+	}
=20
 	chain =3D nft_mxml_str_parse(tree, "chain", MXML_DESCEND_FIRST,
 				   NFT_XML_MAND, err);
-	if (chain =3D=3D NULL)
-		return -1;
-
-	if (r->chain)
-		xfree(r->chain);
+	if (chain !=3D NULL) {
+		if (r->chain)
+			xfree(r->chain);
=20
-	r->chain =3D strdup(chain);
-	r->flags |=3D (1 << NFT_RULE_ATTR_CHAIN);
+		r->chain =3D strdup(chain);
+		r->flags |=3D (1 << NFT_RULE_ATTR_CHAIN);
+	}
=20
 	if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BASE_DEC,
-			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND, err) !=3D 0)
-		return -1;
-
-	r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
+			       &r->handle, NFT_TYPE_U64, NFT_XML_MAND, err) >=3D 0)
+		r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
=20
 	if (nft_mxml_num_parse(tree, "compat_proto", MXML_DESCEND_FIRST,
 			       BASE_DEC, &r->compat.proto, NFT_TYPE_U32,

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
