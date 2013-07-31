From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 5/7] chain:Add json parser support
Date: Wed, 31 Jul 2013 15:21:20 +0200
Message-ID: <20130731132120.29730.738.stgit@Ph0enix>
References: <20130731132051.29730.53717.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33796 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3GaNVY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:21:24 -0400
Received: by mail-wg0-f51.google.com with SMTP id a12so577446wgh.18
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2013 06:21:22 -0700 (PDT)
In-Reply-To: <20130731132051.29730.53717.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add function for parsing chains in format JSON

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/libnftables/chain.h |    1=20
 src/chain.c                 |  117 +++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 118 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index 382947f..53fd407 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -52,6 +52,7 @@ enum {
 enum nft_chain_parse_type {
 	NFT_CHAIN_PARSE_NONE	=3D 0,
 	NFT_CHAIN_PARSE_XML,
+	NFT_CHAIN_PARSE_JSON,
 	NFT_CHAIN_PARSE_MAX
 };
=20
diff --git a/src/chain.c b/src/chain.c
index 7e2567b..c9beb84 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -468,6 +468,120 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr *=
nlh, struct nft_chain *c)
 }
 EXPORT_SYMBOL(nft_chain_nlmsg_parse);
=20
+static int nft_str2hooknum(const char *hook)
+{
+	int hooknum;
+
+	for (hooknum =3D 0; hooknum < NF_INET_NUMHOOKS; hooknum++) {
+		if (strcmp(hook, hooknum2str_array[hooknum]) =3D=3D 0)
+			break;
+	}
+	return hooknum;
+}
+
+static int nft_chain_json_parse(struct nft_chain *c, char *json)
+{
+#ifdef JSON_PARSING
+	json_t *root;
+	json_error_t error;
+	uint64_t uval64;
+	uint32_t policy;
+	int32_t val32;
+	const char *valstr;
+
+	root =3D nft_jansson_get_root(json, "chain", &error);
+	if (root =3D=3D NULL)
+		return -1;
+
+	valstr =3D nft_jansson_value_parse_str(root, "name");
+	if (valstr =3D=3D NULL)
+		goto err;
+
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, strdup(valstr));
+
+	if (nft_jansson_value_parse_val(root, "handle", NFT_TYPE_U64,
+					&uval64) =3D=3D -1)
+		goto err;
+
+	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, uval64);
+
+	if (nft_jansson_value_parse_val(root, "bytes", NFT_TYPE_U64,
+					&uval64) =3D=3D -1)
+		goto err;
+
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, uval64);
+
+	if (nft_jansson_value_parse_val(root, "packets", NFT_TYPE_U64,
+					&uval64) =3D=3D -1)
+		goto err;
+
+	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, uval64);
+
+	valstr =3D nft_jansson_value_parse_str(root, "family");
+
+	if (valstr =3D=3D NULL)
+		goto err;
+
+	val32 =3D nft_str2family(valstr);
+	if (val32 =3D=3D -1)
+		goto err;
+
+	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, val32);
+
+	valstr =3D nft_jansson_value_parse_str(root, "table");
+
+	if (valstr =3D=3D NULL)
+		goto err;
+
+	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, strdup(valstr));
+
+	if (nft_jansson_node_exist(root, "hooknum")) {
+		valstr =3D nft_jansson_value_parse_str(root, "type");
+
+		if (valstr =3D=3D NULL)
+			goto err;
+
+		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, strdup(valstr));
+
+		if (nft_jansson_value_parse_val(root, "prio", NFT_TYPE_S32,
+						&val32) =3D=3D -1)
+			goto err;
+
+		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, val32);
+
+		valstr =3D nft_jansson_value_parse_str(root, "hooknum");
+		if (valstr =3D=3D NULL)
+			goto err;
+
+		val32 =3D nft_str2hooknum(valstr);
+		if (val32 =3D=3D -1)
+			goto err;
+
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM, val32);
+
+		valstr =3D nft_jansson_value_parse_str(root, "policy");
+		if (valstr =3D=3D NULL)
+			goto err;
+
+		policy =3D nft_str2verdict(valstr);
+		if (policy =3D=3D -1)
+			goto err;
+
+		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
+	}
+
+	free(root);
+	return 0;
+
+err:
+	free(root);
+	return -1;
+#else
+	errno =3D EOPNOTSUPP;
+	return -1;
+#endif
+}
+
 static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
 {
 #ifdef XML_PARSING
@@ -649,6 +763,9 @@ int nft_chain_parse(struct nft_chain *c, enum nft_c=
hain_parse_type type,
 	case NFT_CHAIN_PARSE_XML:
 		ret =3D nft_chain_xml_parse(c, data);
 		break;
+	case NFT_CHAIN_PARSE_JSON:
+		ret =3D nft_chain_json_parse(c, data);
+		break;
 	default:
 		ret =3D -1;
 		errno =3D EOPNOTSUPP;

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
