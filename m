From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 17/29] add *permanent* number formatting support
Date: Wed, 10 Jul 2013 19:25:15 +0100
Message-ID: <1373480727-11254-18-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:42958 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab3GJS0Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:25 -0400
Received: by mail-la0-f54.google.com with SMTP id ec20so6057259lab.13
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:23 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add support for permanent number formatting of nfacct objects, using the
'fmt' value stored in each such object within the kernel;

* enhance the existing API to support get/set format functions;

* adjust all existing xml and plaintext templates to support this feature;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  3 ++
 include/linux/netfilter/nfnetlink_acct.h      |  1 +
 src/libnetfilter_acct.c                       | 72 ++++++++++++++++++++++++---
 src/libnetfilter_acct.map                     |  2 +
 4 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index 3328fdb..0944247 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -14,6 +14,7 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_FMT,
 };
 
 struct nfacct_options;
@@ -75,11 +76,13 @@ void nfacct_options_free(struct nfacct_options *options);
 void nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type, const void *data);
 void nfacct_attr_set_str(struct nfacct *nfacct, enum nfacct_attr_type type, const char *name);
 void nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type, uint64_t value);
+void nfacct_attr_set_u16(struct nfacct *nfacct, enum nfacct_attr_type type, uint16_t value);
 void nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type);
 
 const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type);
 const char *nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type);
 uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type);
+uint16_t nfacct_attr_get_u16(struct nfacct *nfacct, enum nfacct_attr_type type);
 
 void nfacct_option_set(struct nfacct_options *options,
 			enum nfacct_option_type type, const void *data);
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index c7b6269..0b65f9c 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -19,6 +19,7 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FMT,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 440bc0b..f7890a1 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -61,6 +61,11 @@ struct nfacct {
 	char		name[NFACCT_NAME_MAX];
 	uint64_t	pkts;
 	uint64_t	bytes;
+	/*
+	 * Structure of fmt:
+	 * <- packets format: 8 bits-><-bytes format: 8 bits ->
+	 */
+	uint16_t	fmt;
 	uint32_t	bitset;
 };
 
@@ -144,6 +149,10 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->fmt = *((uint16_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -177,6 +186,20 @@ nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type,
 EXPORT_SYMBOL(nfacct_attr_set_u64);
 
 /**
+ * nfacct_attr_set_u16 - set one attribute the accounting object
+ * \param nfacct pointer to the accounting object
+ * \param type attribute type you want to set
+ * \param value unsigned 16-bit integer
+ */
+void
+nfacct_attr_set_u16(struct nfacct *nfacct, enum nfacct_attr_type type,
+		    uint16_t value)
+{
+	nfacct_attr_set(nfacct, type, &value);
+}
+EXPORT_SYMBOL(nfacct_attr_set_u16);
+
+/**
  * nfacct_attr_unset - unset one attribute the accounting object
  * \param nfacct pointer to the accounting object
  * \param type attribute type you want to set
@@ -194,6 +217,9 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 	case NFACCT_ATTR_BYTES:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -223,6 +249,10 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 		if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 			ret = &nfacct->bytes;
 		break;
+	case NFACCT_ATTR_FMT:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+			ret = &nfacct->fmt;
+		break;
 	}
 	return ret;
 }
@@ -259,6 +289,21 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
 /**
+ * nfacct_attr_get_u16 - get one attribute the accounting object
+ * \param nfacct pointer to the accounting object
+ * \param type attribute type you want to get
+ *
+ * This function returns a unsigned 16-bits integer. If the attribute is
+ * unsupported, this returns NULL.
+ */
+uint16_t nfacct_attr_get_u16(struct nfacct *nfacct, enum nfacct_attr_type type)
+{
+	const void *ret = nfacct_attr_get(nfacct, type);
+	return ret ? *((uint16_t *)ret) : 0;
+}
+EXPORT_SYMBOL(nfacct_attr_get_u16);
+
+/**
  * nfacct_option_set - set one option of the accounting options object
  * \param options pointer to the accounting options object
  * \param type option type you want to set
@@ -416,7 +461,7 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define EB ((uint64_t) PB*1000)
 
 #define NFACCT_STR_PLAIN_NUMONLY	"%s %s"
-#define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s pkts=%"PRIu64 \
+#define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s fmt=%s,%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
 #define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus" \
 					" bytes = %%%zus ] = %%s"
@@ -695,7 +740,7 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		}
 
 		if (fmt == NFACCT_FMT_MAX)
-			fmt = NFACCT_FMT_DEFAULT;
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
 		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
 			init_locale();
@@ -707,11 +752,14 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 				nfacct_name);
 	} else if (flags & NFACCT_SNPRINTF_F_SAVE) {
 		/* save: format useful for 'restore' */
+		fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 		parse_nfacct_name(nfacct_name,
 				  nfacct_attr_get_str(nfacct,
 						      NFACCT_ATTR_NAME));
 		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_SAVE_BASE,
 			       nfacct_name,
+			       NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+			       NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PKTS),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BYTES));
 	} else if (flags & NFACCT_SNPRINTF_F_BONLY) {
@@ -723,7 +771,7 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
 
 		if (fmt == NFACCT_FMT_MAX)
-			fmt = NFACCT_FMT_DEFAULT;
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
 		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
 			init_locale();
@@ -739,7 +787,7 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
 
 		if (fmt == NFACCT_FMT_MAX)
-			fmt = NFACCT_FMT_DEFAULT;
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
 		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
 			init_locale();
@@ -824,7 +872,7 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
 
 		if (fmt == NFACCT_FMT_MAX)
-			fmt = NFACCT_FMT_DEFAULT;
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
 		format_number(&bn, bytes, NFACCT_FMT_NONE);
 		ret = snprintf(buf, rem, NFACCT_STR_XML_BONLY, nfacct_name,
@@ -837,7 +885,7 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
 
 		if (fmt == NFACCT_FMT_MAX)
-			fmt = NFACCT_FMT_DEFAULT;
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
 		format_number(&pn, pkts, NFACCT_FMT_NONE);
 		format_number(&bn, bytes, NFACCT_FMT_NONE);
@@ -999,6 +1047,9 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+		mnl_attr_put_u16(nlh, NFACCT_FMT, htobe16(nfacct->fmt));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -1024,6 +1075,12 @@ static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFACCT_FMT:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 	tb[type] = attr;
 	return MNL_CB_OK;
@@ -1053,6 +1110,9 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_PKTS])));
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES,
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_BYTES])));
+	if (tb[NFACCT_FMT])
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT,
+				  be16toh(mnl_attr_get_u16(tb[NFACCT_FMT])));
 
 	return 0;
 }
diff --git a/src/libnetfilter_acct.map b/src/libnetfilter_acct.map
index ded60a9..6554090 100644
--- a/src/libnetfilter_acct.map
+++ b/src/libnetfilter_acct.map
@@ -21,6 +21,8 @@ local: *;
 
 LIBNETFILTER_ACCT_1.1 {
   nfacct_snprintf;
+  nfacct_attr_set_u16;
+  nfacct_attr_get_u16;
   nfacct_options_alloc;
   nfacct_options_free;
   nfacct_option_set;
-- 
1.8.3.1

