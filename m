From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 1/2] set: json: fix incomplete output
Date: Mon, 15 Jul 2013 21:30:52 +0200
Message-ID: <20130715193052.20241.52862.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38619 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3GOTa4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:30:56 -0400
Received: by mail-wi0-f172.google.com with SMTP id c10so3293975wiw.5
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2013 12:30:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

In (bf39c53 set: add json output), the json support for sets was
incomplete:

* version, family, key_type, key_len, data_type, data_len were not incl=
uded.
* Now I use nft_data_reg_snprintf for printing the key and data

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/internal.h |    1 +
 src/set.c      |   23 +++++++++++++++++------
 src/set_elem.c |   50 ++++++++++++++++++++++++++++--------------------=
--
 3 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/src/internal.h b/src/internal.h
index 803dcc4..b3cdb76 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -28,6 +28,7 @@ int nft_mxml_data_reg_parse(mxml_node_t *tree, const =
char *node_name, union nft_
 #define NFT_TABLE_JSON_VERSION 0
 #define NFT_CHAIN_JSON_VERSION 0
 #define NFT_RULE_JSON_VERSION 0
+#define NFT_SET_JSON_VERSION 0
=20
 const char *nft_family2str(uint32_t family);
 int nft_str2family(const char *family);
diff --git a/src/set.c b/src/set.c
index dc3bd27..343e27c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -317,16 +317,27 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nl=
h, struct nft_set *s)
 EXPORT_SYMBOL(nft_set_nlmsg_parse);
=20
 static int nft_set_snprintf_json(char *buf, size_t size, struct nft_se=
t *s,
-			   uint32_t type, uint32_t flags)
+				  uint32_t type, uint32_t flags)
 {
-	int ret;
-	int len =3D size, offset =3D 0;
+	int len =3D size, offset =3D 0, ret;
 	struct nft_set_elem *elem;
=20
-	ret =3D snprintf(buf, size, "{ \"set\" : { \"name\" : \"%s\", \"table=
\" : \"%s\", \"flags\" : %u",
-			s->name, s->table, s->set_flags);
+	ret =3D snprintf(buf, size, "{ \"set\": { \"name\": \"%s\","
+				  "\"table\": \"%s\",\"version\": %d,"
+				  "\"flags\": %u,\"family\": \"%s\","
+				  "\"key_type\": %u,\"key_len\": %u",
+			s->name, s->table, NFT_SET_JSON_VERSION, s->set_flags,
+			nft_family2str(s->family), s->key_type, s->key_len);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
+	if(s->flags & (1 << NFT_SET_ATTR_DATA_TYPE) &&
+	   s->flags & (1 << NFT_SET_ATTR_DATA_LEN)){
+		ret =3D snprintf(buf+offset, size,
+				  ",\"data_type\": %u,\"data_len\": %u",
+			s->data_type, s->data_len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Empty set? Skip printinf of elements */
 	if (list_empty(&s->element_list)){
 		ret =3D snprintf(buf+offset, size, "}}");
@@ -334,7 +345,7 @@ static int nft_set_snprintf_json(char *buf, size_t =
size, struct nft_set *s,
 		return offset;
 	}
=20
-	ret =3D snprintf(buf+offset, size, ", \"set_elem\" : [");
+	ret =3D snprintf(buf+offset, size, ",\"set_elem\": [");
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	list_for_each_entry(elem, &s->element_list, head) {
diff --git a/src/set_elem.c b/src/set_elem.c
index 3966cd6..eeab726 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -385,34 +385,40 @@ int nft_set_elems_nlmsg_parse(const struct nlmsgh=
dr *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_parse);
=20
-static int nft_set_elem_snprintf_json(char *buf, size_t size, struct n=
ft_set_elem *e)
+static int nft_set_elem_snprintf_json(char *buf, size_t size,
+				       struct nft_set_elem *e, uint32_t flags)
 {
-	int ret, len =3D size, offset =3D 0, i, numregs;
+	int ret, len =3D size, offset =3D 0, type =3D -1;
=20
-	ret =3D snprintf(buf, size, "\"flags\" : %u", e->set_elem_flags);
+	ret =3D snprintf(buf, size, "\"set_elem_flags\": %u", e->set_elem_fla=
gs);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
-	numregs =3D div_round_up(e->key.len, sizeof(uint32_t));
-	if (numregs !=3D 0) {
-		ret =3D snprintf(buf+offset, len, ", \"key\" : \"0x");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		for (i =3D 0; i < numregs; i++) {
-			ret =3D snprintf(buf+offset, len, "%.8x", e->key.val[i]);
-			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-		ret =3D snprintf(buf+offset, len, "\"");
-		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
+	ret =3D snprintf(buf+offset, size, ",\"set_elem_key\": {");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
+				    NFT_RULE_O_JSON, flags, DATA_VALUE);
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	ret =3D snprintf(buf+offset, size, "}");
+	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA))
+		type =3D DATA_VALUE;
+	else if (e->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+		type =3D DATA_CHAIN;
+	else if (e->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT))
+		type =3D DATA_VERDICT;
=20
-	numregs =3D div_round_up(e->data.len, sizeof(uint32_t));
-	if (numregs !=3D 0) {
-		ret =3D snprintf(buf+offset, size, " ,\"data\" : \"0x");
+	if (type !=3D -1) {
+		ret =3D snprintf(buf+offset, size, ",\"set_elem_data\": {");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		for (i =3D 0; i < numregs; i++) {
-			ret =3D snprintf(buf+offset, len, "%.8x", e->data.val[i]);
+
+		ret =3D nft_data_reg_snprintf(buf+offset, len, &e->data,
+				    NFT_RULE_O_JSON, flags, type);
 			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-		}
-		ret =3D snprintf(buf+offset, len, "\"");
+
+		ret =3D snprintf(buf+offset, size, "}");
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
@@ -514,7 +520,7 @@ int nft_set_elem_snprintf(char *buf, size_t size, s=
truct nft_set_elem *e,
 	case NFT_SET_O_XML:
 		return nft_set_elem_snprintf_xml(buf, size, e, flags);
 	case NFT_SET_O_JSON:
-		return nft_set_elem_snprintf_json(buf, size, e);
+		return nft_set_elem_snprintf_json(buf, size, e, flags);
 	default:
 		break;
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
