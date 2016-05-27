From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 nft] set_elem: Use libnftnl/udata to store set element comment
Date: Fri, 27 May 2016 16:56:55 +0200
Message-ID: <1464361015-14755-2-git-send-email-carlosfg@riseup.net>
References: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53183 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbcE0O5J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2016 10:57:09 -0400
In-Reply-To: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The set element comment is stored in nftnl_set_elem->user.data using
libnftnl/udata infrastructure. This allows store multiple variable leng=
th
user data into set element.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/netlink.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index b0dcb90..f82d4fa 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -22,6 +22,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/udata.h>
 #include <libnftnl/common.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -208,6 +209,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(c=
onst struct expr *expr)
 	const struct expr *elem, *key, *data;
 	struct nftnl_set_elem *nlse;
 	struct nft_data_linearize nld;
+	struct nftnl_udata_buf *udbuf;
=20
 	nlse =3D nftnl_set_elem_alloc();
 	if (nlse =3D=3D NULL)
@@ -228,9 +230,18 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(=
const struct expr *expr)
 	if (elem->timeout)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_TIMEOUT,
 				       elem->timeout);
-	if (elem->comment)
+	if (elem->comment) {
+		udbuf =3D nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+		if (!udbuf)
+			memory_allocation_error();
+		if (!nftnl_udata_put_strz(udbuf, UDATA_TYPE_COMMENT,
+					  elem->comment))
+			memory_allocation_error();
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_USERDATA,
-				   elem->comment, strlen(elem->comment) + 1);
+				   nftnl_udata_buf_data(udbuf),
+				   nftnl_udata_buf_len(udbuf));
+		nftnl_udata_buf_free(udbuf);
+	}
=20
 	if (data !=3D NULL) {
 		netlink_gen_data(data, &nld);
@@ -1421,6 +1432,38 @@ static struct expr *netlink_parse_concat_elem(co=
nst struct datatype *dtype,
 	return concat;
 }
=20
+static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value =3D nftnl_udata_get(attr);
+	uint8_t type =3D nftnl_udata_type(attr);
+	uint8_t len =3D nftnl_udata_len(attr);
+	const struct nftnl_udata **tb =3D data;
+
+	switch (type) {
+	case UDATA_TYPE_COMMENT:
+		if (value[len - 1] !=3D '\0')
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+	tb[type] =3D attr;
+	return 0;
+}
+
+static char *udata_get_comment(const void *data, uint32_t data_len)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
+
+	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) < 0)
+		return NULL;
+
+	if (!tb[UDATA_TYPE_COMMENT])
+		return NULL;
+
+	return xstrdup(nftnl_udata_get(tb[UDATA_TYPE_COMMENT]));
+}
+
 static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				       const struct set *set)
 {
@@ -1457,8 +1500,7 @@ static int netlink_delinearize_setelem(struct nft=
nl_set_elem *nlse,
 		uint32_t len;
=20
 		data =3D nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_USERDATA, &len);
-		expr->comment =3D xmalloc(len);
-		memcpy((char *)expr->comment, data, len);
+		expr->comment =3D udata_get_comment(data, len);
 	}
 	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR)) {
 		const struct nftnl_expr *nle;
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
