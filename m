From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/3,libnftnl] set: Add new attribute into 'set' to store an
Date: Tue, 22 Dec 2015 19:00:29 +0100
Message-ID: <1450807230-18208-2-git-send-email-carlosfg@riseup.net>
References: <1450807230-18208-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51516 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723AbbLVSAk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 13:00:40 -0500
In-Reply-To: <1450807230-18208-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new structure 'user' holds a pointer to user data and its length. T=
he kernel
must have the flag NFTA_SET_USERDATA to support this feature.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set.h                       |  4 ++++
 src/set.c                           | 48 +++++++++++++++++++++++++++++=
++++++++
 4 files changed, 55 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 11243f5..0af1060 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -22,6 +22,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_DESC_SIZE,
 	NFTNL_SET_TIMEOUT,
 	NFTNL_SET_GC_INTERVAL,
+	NFTNL_SET_USERDATA,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfil=
ter/nf_tables.h
index f77693b..9beddc5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -291,6 +291,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
+ * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -306,6 +307,7 @@ enum nft_set_attributes {
 	NFTA_SET_ID,
 	NFTA_SET_TIMEOUT,
 	NFTA_SET_GC_INTERVAL,
+	NFTA_SET_USERDATA,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index c3b96f2..85bd389 100644
--- a/include/set.h
+++ b/include/set.h
@@ -14,6 +14,10 @@ struct nftnl_set {
 	uint32_t		key_len;
 	uint32_t		data_type;
 	uint32_t		data_len;
+	struct {
+		void		*data;
+		uint32_t	len;
+	} user;
 	uint32_t		id;
 	enum nft_set_policies	policy;
 	struct {
diff --git a/src/set.c b/src/set.c
index 8369f7f..a63264d 100644
--- a/src/set.c
+++ b/src/set.c
@@ -19,6 +19,7 @@
 #include <netinet/in.h>
 #include <limits.h>
 #include <errno.h>
+#include <ctype.h>
=20
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -91,6 +92,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t at=
tr)
 	case NFTNL_SET_DESC_SIZE:
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
+	case NFTNL_SET_USERDATA:
 		break;
 	default:
 		return;
@@ -167,6 +169,10 @@ void nftnl_set_set_data(struct nftnl_set *s, uint1=
6_t attr, const void *data,
 	case NFTNL_SET_GC_INTERVAL:
 		s->gc_interval =3D *((uint32_t *)data);
 		break;
+	case NFTNL_SET_USERDATA:
+		s->user.data =3D (void *)data;
+		s->user.len  =3D data_len;
+		break;
 	}
 	s->flags |=3D (1 << attr);
 }
@@ -240,6 +246,9 @@ const void *nftnl_set_get_data(struct nftnl_set *s,=
 uint16_t attr,
 	case NFTNL_SET_GC_INTERVAL:
 		*data_len =3D sizeof(uint32_t);
 		return &s->gc_interval;
+	case NFTNL_SET_USERDATA:
+		*data_len =3D s->user.len;
+		return s->user.data;
 	}
 	return NULL;
 }
@@ -348,6 +357,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr =
*nlh, struct nftnl_set *s)
 		mnl_attr_put_u64(nlh, NFTA_SET_TIMEOUT, htobe64(s->timeout));
 	if (s->flags & (1 << NFTNL_SET_GC_INTERVAL))
 		mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
+	if (s->flags & (1 << NFTNL_SET_USERDATA))
+		mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_nlmsg_build_payload, nft_set_nlmsg_build=
_payload);
=20
@@ -376,6 +387,10 @@ static int nftnl_set_parse_attr_cb(const struct nl=
attr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_SET_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
 	case NFTA_SET_TIMEOUT:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
 			abi_breakage();
@@ -480,6 +495,20 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nftnl_set *s)
 		s->gc_interval =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]))=
;
 		s->flags |=3D (1 << NFTNL_SET_GC_INTERVAL);
 	}
+	if (tb[NFTA_SET_USERDATA]) {
+		const void *udata =3D
+			mnl_attr_get_payload(tb[NFTA_SET_USERDATA]);
+
+		if (s->user.data)
+			xfree(s->user.data);
+
+		s->user.len  =3D mnl_attr_get_payload_len(tb[NFTA_SET_USERDATA]);
+		s->user.data =3D malloc(s->user.len);
+		if (s->user.data =3D=3D NULL)
+			return -1;
+		memcpy(s->user.data, udata, s->user.len);
+		s->flags |=3D (1 << NFTNL_SET_USERDATA);
+	}
 	if (tb[NFTA_SET_DESC])
 		ret =3D nftnl_set_desc_parse(s, tb[NFTA_SET_DESC]);
=20
@@ -775,6 +804,7 @@ static int nftnl_set_snprintf_json(char *buf, size_=
t size, struct nftnl_set *s,
 				  uint32_t type, uint32_t flags)
 {
 	int len =3D size, offset =3D 0, ret;
+	int i;
 	struct nftnl_set_elem *elem;
=20
 	ret =3D snprintf(buf, len, "{\"set\":{");
@@ -826,6 +856,24 @@ static int nftnl_set_snprintf_json(char *buf, size=
_t size, struct nftnl_set *s,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
=20
+	if (s->flags & (1 << NFTNL_SET_USERDATA)) {
+		ret =3D snprintf(buf + offset, len, ",\"userdata_len\":%u", s->user.=
len);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		ret =3D snprintf(buf + offset, len, ",\"userdata\":\"");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		char *c =3D s->user.data;
+		for (i =3D 0; i < s->user.len; i++) {
+			ret =3D snprintf(buf + offset, len, "%c",
+				       isprint(c[i]) ? c[i] : ' ');
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret =3D snprintf(buf + offset, len, "\"");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (s->flags & (1 << NFTNL_SET_DESC_SIZE)) {
 		ret =3D snprintf(buf + offset, len, ",\"desc_size\":%u",
 			       s->desc.size);
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
