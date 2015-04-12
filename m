From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] set_elem: add support for userdata
Date: Sun, 12 Apr 2015 20:24:48 +0100
Message-ID: <1428866689-17679-3-git-send-email-kaber@trash.net>
References: <1428866689-17679-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61670 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbbDLTY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 15:24:56 -0400
In-Reply-To: <1428866689-17679-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/libnftnl/set.h              |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/set_elem.h                  |  4 ++++
 src/set_elem.c                      | 47 +++++++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index db38d6b..9621853 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -92,6 +92,7 @@ enum {
 	NFT_SET_ELEM_ATTR_DATA,
 	NFT_SET_ELEM_ATTR_TIMEOUT,
 	NFT_SET_ELEM_ATTR_EXPIRATION,
+	NFT_SET_ELEM_ATTR_USERDATA,
 };
 
 struct nft_set_elem;
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 6894ba3..334b389 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -291,6 +291,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
  * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
+ * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -299,6 +300,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_FLAGS,
 	NFTA_SET_ELEM_TIMEOUT,
 	NFTA_SET_ELEM_EXPIRATION,
+	NFTA_SET_ELEM_USERDATA,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/include/set_elem.h b/include/set_elem.h
index de864db..5aaad20 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -11,6 +11,10 @@ struct nft_set_elem {
 	uint32_t		flags;
 	uint64_t		timeout;
 	uint64_t		expiration;
+	struct {
+		void		*data;
+		uint32_t	len;
+	} user;
 };
 
 #endif
diff --git a/src/set_elem.c b/src/set_elem.c
index 5760902..2cf6528 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -17,6 +17,7 @@
 #include <string.h>
 #include <netinet/in.h>
 #include <errno.h>
+#include <ctype.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -72,6 +73,7 @@ void nft_set_elem_attr_unset(struct nft_set_elem *s, uint16_t attr)
 	case NFT_SET_ELEM_ATTR_DATA:	/* NFTA_SET_ELEM_DATA */
 	case NFT_SET_ELEM_ATTR_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 	case NFT_SET_ELEM_ATTR_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+	case NFT_SET_ELEM_ATTR_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
 		break;
 	default:
 		return;
@@ -108,6 +110,10 @@ void nft_set_elem_attr_set(struct nft_set_elem *s, uint16_t attr,
 	case NFT_SET_ELEM_ATTR_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 		s->timeout = *((uint64_t *)data);
 		break;
+	case NFT_SET_ELEM_ATTR_USERDATA: /* NFTA_SET_ELEM_USERDATA */
+		s->user.data = (void *)data;
+		s->user.len  = data_len;
+		break;
 	default:
 		return;
 	}
@@ -155,6 +161,9 @@ const void *nft_set_elem_attr_get(struct nft_set_elem *s, uint16_t attr, uint32_
 		return &s->timeout;
 	case NFT_SET_ELEM_ATTR_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 		return &s->expiration;
+	case NFT_SET_ELEM_ATTR_USERDATA:
+		*data_len = s->user.len;
+		return s->user.data;
 	}
 	return NULL;
 }
@@ -233,6 +242,8 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put(nlh, NFTA_DATA_VALUE, e->data.len, e->data.val);
 		mnl_attr_nest_end(nlh, nest1);
 	}
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_USERDATA))
+		mnl_attr_put(nlh, NFTA_SET_ELEM_USERDATA, e->user.len, e->user.data);
 }
 
 static void nft_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
@@ -297,6 +308,10 @@ static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
 		break;
+	case NFTA_SET_ELEM_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -350,7 +365,23 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 			break;
 		}
         }
+	if (tb[NFTA_SET_ELEM_USERDATA]) {
+		const void *udata =
+			mnl_attr_get_payload(tb[NFTA_SET_ELEM_USERDATA]);
+
+		if (e->user.data)
+			xfree(e->user.data);
+
+		e->user.len  = mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
+		e->user.data = malloc(e->user.len);
+		if (e->user.data == NULL)
+			goto err;
+		memcpy(e->user.data, udata, e->user.len);
+		e->flags |= (1 << NFT_RULE_ATTR_USERDATA);
+	}
+
 	if (ret < 0) {
+err:
 		nft_set_elem_free(e);
 		return -1;
 	}
@@ -611,6 +642,22 @@ static int nft_set_elem_snprintf_default(char *buf, size_t size,
 	ret = snprintf(buf+offset, len, "%u [end]", e->set_elem_flags);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (e->user.len) {
+		ret = snprintf(buf+offset, len, "  userdata = {");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+
+		for (i = 0; i < e->user.len; i++) {
+			char *c = e->user.data;
+
+			ret = snprintf(buf+offset, len, "%c",
+				       isalnum(c[i]) ? c[i] : 0);
+			SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		}
+
+		ret = snprintf(buf+offset, len, " }\n");
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
-- 
2.1.0

