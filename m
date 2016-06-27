From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnftnl] set: Add new attribute into 'set' to store user data
Date: Mon, 27 Jun 2016 19:05:22 +0200
Message-ID: <20160627170523.6560-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49983 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbcF0RFr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jun 2016 13:05:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new structure 'user' holds a pointer to user data and its length. T=
he
kernel must have the flag NFTA_SET_USERDATA to support this feature.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/libnftnl/set.h |  1 +
 include/set.h          |  4 ++++
 src/set.c              | 29 +++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 3d50d56..5266b6f 100644
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
index 7b333ed..ebb4329 100644
--- a/src/set.c
+++ b/src/set.c
@@ -87,6 +87,9 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t at=
tr)
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
 		break;
+	case NFTNL_SET_USERDATA:
+		xfree(s->user.data);
+		break;
 	default:
 		return;
 	}
@@ -164,6 +167,16 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16=
_t attr, const void *data,
 	case NFTNL_SET_GC_INTERVAL:
 		s->gc_interval =3D *((uint32_t *)data);
 		break;
+	case NFTNL_SET_USERDATA:
+		if (s->flags & (1 << NFTNL_SET_USERDATA))
+			xfree(s->user.data);
+
+		s->user.data =3D malloc(data_len);
+		if (!s->user.data)
+			return -1;
+		memcpy(s->user.data, data, data_len);
+		s->user.len =3D data_len;
+		break;
 	}
 	s->flags |=3D (1 << attr);
 	return 0;
@@ -238,6 +251,9 @@ const void *nftnl_set_get_data(const struct nftnl_s=
et *s, uint16_t attr,
 	case NFTNL_SET_GC_INTERVAL:
 		*data_len =3D sizeof(uint32_t);
 		return &s->gc_interval;
+	case NFTNL_SET_USERDATA:
+		*data_len =3D s->user.len;
+		return s->user.data;
 	}
 	return NULL;
 }
@@ -352,6 +368,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr =
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
@@ -380,6 +398,10 @@ static int nftnl_set_parse_attr_cb(const struct nl=
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
@@ -490,6 +512,13 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *n=
lh, struct nftnl_set *s)
 		s->gc_interval =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_GC_INTERVAL]))=
;
 		s->flags |=3D (1 << NFTNL_SET_GC_INTERVAL);
 	}
+	if (tb[NFTA_SET_USERDATA]) {
+		ret =3D nftnl_set_set_data(s, NFTNL_SET_USERDATA,
+			mnl_attr_get_payload(tb[NFTA_SET_USERDATA]),
+			mnl_attr_get_payload_len(tb[NFTA_SET_USERDATA]));
+		if (ret < 0)
+			return ret;
+	}
 	if (tb[NFTA_SET_DESC]) {
 		ret =3D nftnl_set_desc_parse(s, tb[NFTA_SET_DESC]);
 		if (ret < 0)
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
