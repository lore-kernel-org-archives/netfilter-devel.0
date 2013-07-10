From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 20/29] add byte threshold capability support
Date: Wed, 10 Jul 2013 19:25:18 +0100
Message-ID: <1373480727-11254-21-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40099 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3GJS0f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:35 -0400
Received: by mail-lb0-f169.google.com with SMTP id d10so6012492lbj.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:34 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add support for printing/retrieving byte threshold of nfacct objects,
using the 'bthr' value stored in each such object within the kernel;

* enhance the existing API to support get/set byte threshold functions;

* adjust all existing xml and plaintext templates to support this feature;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |   4 +
 include/linux/netfilter/nfnetlink_acct.h      |   9 ++
 src/libnetfilter_acct.c                       | 149 ++++++++++++++++++++++----
 3 files changed, 140 insertions(+), 22 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index 0944247..920df9d 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -14,7 +14,10 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_BTHR,
 	NFACCT_ATTR_FMT,
+	NFACCT_ATTR_FLAGS,
+	NFACCT_ATTR_CMD,
 };
 
 struct nfacct_options;
@@ -23,6 +26,7 @@ enum nfacct_option_type {
 	NFACCT_OPT_FMT = 0,	/* number format option 	*/
 	NFACCT_OPT_PCW,		/* packets count column width 	*/
 	NFACCT_OPT_BCW,		/* bytes count column width 	*/
+	NFACCT_OPT_BTCW,	/* bytes threshold column width */
 };
 
 enum nfacct_format {
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 0b65f9c..e972970 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -19,10 +19,19 @@ enum nfnl_acct_type {
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_BTHR,
 	NFACCT_FMT,
+	NFACCT_FLAGS,
+	NFACCT_CMD,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
 
+enum nfnl_acct_flags {
+	NFACCT_FLAG_BIT_BTHR 	= 0,
+	NFACCT_FLAG_BTHR	= (1 << NFACCT_FLAG_BIT_BTHR),
+	NFACCT_FLAG_BIT_MAX	= 1,
+	NFACCT_FLAG_MAX		= (1 << NFACCT_FLAG_BIT_MAX),
+};
 
 #endif /* _UAPI_NFNL_ACCT_H_ */
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index f7890a1..db01c31 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -61,11 +61,14 @@ struct nfacct {
 	char		name[NFACCT_NAME_MAX];
 	uint64_t	pkts;
 	uint64_t	bytes;
+	uint64_t	bthr;
 	/*
 	 * Structure of fmt:
 	 * <- packets format: 8 bits-><-bytes format: 8 bits ->
 	 */
 	uint16_t	fmt;
+	uint16_t	flags;
+	uint16_t	cmd;
 	uint32_t	bitset;
 };
 
@@ -73,6 +76,7 @@ struct nfacct_options {
 	uint16_t	fmt;
 	size_t		pcw;
 	size_t		bcw;
+	size_t		btcw;
 	uint32_t	bitset;
 };
 
@@ -149,10 +153,22 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_BTHR:
+		nfacct->bthr = *((uint64_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_BTHR);
+		break;
 	case NFACCT_ATTR_FMT:
 		nfacct->fmt = *((uint16_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_FMT);
 		break;
+	case NFACCT_ATTR_FLAGS:
+		nfacct->flags = *((uint16_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_FLAGS);
+		break;
+	case NFACCT_ATTR_CMD:
+		nfacct->cmd = *((uint16_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_CMD);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -217,9 +233,18 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 	case NFACCT_ATTR_BYTES:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_BTHR:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_BTHR);
+		break;
 	case NFACCT_ATTR_FMT:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_FMT);
 		break;
+	case NFACCT_ATTR_FLAGS:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_FLAGS);
+		break;
+	case NFACCT_ATTR_CMD:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_CMD);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -249,10 +274,22 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 		if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 			ret = &nfacct->bytes;
 		break;
+	case NFACCT_ATTR_BTHR:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_BTHR))
+			ret = &nfacct->bthr;
+		break;
 	case NFACCT_ATTR_FMT:
 		if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
 			ret = &nfacct->fmt;
 		break;
+	case NFACCT_ATTR_FLAGS:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_FLAGS))
+			ret = &nfacct->flags;
+		break;
+	case NFACCT_ATTR_CMD:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_CMD))
+			ret = &nfacct->cmd;
+		break;
 	}
 	return ret;
 }
@@ -327,6 +364,10 @@ nfacct_option_set(struct nfacct_options *options,
 		options->bcw = *((size_t *) data);
 		options->bitset |= (1 << NFACCT_OPT_BCW);
 		break;
+	case NFACCT_OPT_BTCW:
+		options->btcw = *((size_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_BTCW);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_option_set);
@@ -380,6 +421,9 @@ nfacct_option_unset(struct nfacct_options *options,
 	case NFACCT_OPT_BCW:
 		options->bitset &= ~(1 << NFACCT_OPT_BCW);
 		break;
+	case NFACCT_OPT_BTCW:
+		options->bitset &= ~(1 << NFACCT_OPT_BTCW);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_option_unset);
@@ -410,6 +454,10 @@ const void *nfacct_option_get(struct nfacct_options *options,
 		if (options->bitset & (1 << NFACCT_OPT_BCW))
 			ret = &options->bcw;
 		break;
+	case NFACCT_OPT_BTCW:
+		if (options->bitset & (1 << NFACCT_OPT_BTCW))
+			ret = &options->btcw;
+		break;
 	}
 	return ret;
 }
@@ -460,17 +508,19 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define PB ((uint64_t) TB*1000)
 #define EB ((uint64_t) PB*1000)
 
-#define NFACCT_STR_PLAIN_NUMONLY	"%s %s"
+#define NFACCT_STR_PLAIN_NUMONLY	"%s %s %s"
 #define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s fmt=%s,%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
+#define NFACCT_STR_PLAIN_SAVE_BTHR	" thr=%"PRIu64
 #define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus" \
-					" bytes = %%%zus ] = %%s"
+					" bytes = %%%zus%s ] = %%s"
 #define NFACCT_STR_PLAIN		"{ pkts = %%%zus, " \
-					"bytes = %%%zus } = %%s;"
-#define NFACCT_STR_PLAIN_BONLY		"[ bytes = %%%zus ] = %%s"
+					"bytes = %%%zus%s } = %%s;"
+#define NFACCT_STR_PLAIN_BONLY		"[ bytes = %%%zus%s ] = %%s"
 #define NFACCT_XML_NAME			"<name>%s</name>"
 #define NFACCT_XML_PKTS			"<pkts fmt=\"%s\">%s</pkts>"
-#define NFACCT_XML_BYTES		"<bytes fmt=\"%s\">%s</bytes>"
+#define NFACCT_XML_BYTES		"<bytes fmt=\"%s\" " \
+					"thr=\"%s\">%s</bytes>"
 #define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_BYTES
 #define NFACCT_STR_XML_COMPAT		"<obj><name>%s</name>"	\
@@ -484,6 +534,7 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_STR_SI_IEC		"%'.3f%s"
 
 #define NFACCT_NUM_DEFAULT		{ .value = 0., .str = "" }
+#define NFACCT_THR_DEFAULT		{ .value = 0., .str = "-" }
 
 struct nfacct_number {
 	float value;
@@ -703,24 +754,38 @@ static void init_locale(void) {
 #define nfacct_get_bytes_fmt(x)		_nfacct_get_value(x,bytes)
 #define nfacct_get_pkt_fmt(x)		_nfacct_get_value(x,pkts)
 
+#define NFACCT_PRINT_FL(flag,x,v)	((flag && x > v) ? "+" : " ")
+#define NFACCT_PRINT_FL_XML(flag,x,v)	((flag ? ((x > v) ? \
+					"true" : "false") : ""))
+
+#define BUFFER_SIZE(ret, size, rem, offset)		\
+	size += ret;					\
+	if (ret > rem)					\
+		ret = rem;				\
+	offset += ret;					\
+	rem -= ret;
+
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags, struct nfacct_options *options)
 {
-	int ret = 0;
+	int ret = 0, size = 0, offset = 0;
 	bool compat = (options == NULL);
-	uint16_t fmt;
-	uint64_t pkts = 0, bytes = 0;
+	uint16_t fmt, fl;
+	uint64_t pkts = 0, bytes = 0, thr = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
 	char fmt_str[sizeof(NFACCT_STR_PLAIN_NEW) +
 		     sizeof(NFACCT_STR_DEFAULT) * 5 + 10];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
-			     bn = NFACCT_NUM_DEFAULT;
+			     bn = NFACCT_NUM_DEFAULT,
+			     tn = NFACCT_THR_DEFAULT;
 
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
 		/* default: print pkts + bytes + name */
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 		parse_nfacct_name(nfacct_name,
 				  nfacct_attr_get_str(nfacct,
 						      NFACCT_ATTR_NAME));
@@ -728,7 +793,7 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		if (compat) {
 			fmt = NFACCT_FMT_MAX;
 			snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN,
-				 (size_t)0, (size_t)0);
+				 (size_t)0, (size_t)0, "");
 		} else {
 			fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
 			snprintf(fmt_str, sizeof(fmt_str),
@@ -736,7 +801,9 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 				 nfacct_option_get_tsize(options,
 							 NFACCT_OPT_PCW),
 				 nfacct_option_get_tsize(options,
-							 NFACCT_OPT_BCW));
+							 NFACCT_OPT_BCW),
+				 NFACCT_PRINT_FL(fl & NFACCT_FLAG_BTHR,
+						 bytes,thr));
 		}
 
 		if (fmt == NFACCT_FMT_MAX)
@@ -762,9 +829,19 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 			       NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PKTS),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BYTES));
+		BUFFER_SIZE(ret, size, rem, offset);
+
+		fl = nfacct_attr_get_u16(nfacct,NFACCT_ATTR_FLAGS);
+		if (fl & NFACCT_FLAG_BTHR) {
+			ret = snprintf(buf+offset, rem, NFACCT_STR_PLAIN_SAVE_BTHR,
+			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BTHR));
+			BUFFER_SIZE(ret, size, rem, offset);
+		}
 	} else if (flags & NFACCT_SNPRINTF_F_BONLY) {
 		/* print bytes + name only */
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 		parse_nfacct_name(nfacct_name,
 				nfacct_attr_get_str(nfacct,
 						    NFACCT_ATTR_NAME));
@@ -778,12 +855,15 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 
 		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
 		snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN_BONLY,
-			 nfacct_option_get_tsize(options,NFACCT_OPT_BCW));
+			 nfacct_option_get_tsize(options,NFACCT_OPT_BCW),
+			 NFACCT_PRINT_FL(fl & NFACCT_FLAG_BTHR, bytes, thr));
 		ret = snprintf(buf, rem, fmt_str, bn.str, nfacct_name);
 	} else if (flags & NFACCT_SNPRINTF_F_NUMONLY) {
 		/* numbers only: to determine the maximum column width */
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
 
 		if (fmt == NFACCT_FMT_MAX)
@@ -795,8 +875,11 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
 		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
 
+		if (fl & NFACCT_FLAG_BTHR)
+			format_number(&tn, thr, nfacct_get_bytes_fmt(fmt));
+
 		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_NUMONLY,
-				pn.str, bn.str);
+				pn.str, bn.str, tn.str);
 	} else {
 		/* print out name only */
 		parse_nfacct_name(nfacct_name,
@@ -808,13 +891,6 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 	return ret;
 }
 
-#define BUFFER_SIZE(ret, size, rem, offset)		\
-	size += ret;					\
-	if (ret > rem)					\
-		ret = rem;				\
-	offset += ret;					\
-	rem -= ret;
-
 static int
 nfacct_snprintf_xml_localtime(char *buf, unsigned int rem, const struct tm *tm)
 {
@@ -853,8 +929,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 	int ret = 0;
 	bool compat = (options == NULL);
 	unsigned int size = 0, offset = 0;
-	uint16_t fmt;
-	uint64_t pkts = 0, bytes = 0;
+	uint16_t fmt, fl;
+	uint64_t pkts = 0, bytes = 0, thr = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
 			     bn = NFACCT_NUM_DEFAULT;
@@ -870,6 +946,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 	if (flags & NFACCT_SNPRINTF_F_BONLY) {
 		/* print name + bytes only */
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 
 		if (fmt == NFACCT_FMT_MAX)
 			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
@@ -877,12 +955,16 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		format_number(&bn, bytes, NFACCT_FMT_NONE);
 		ret = snprintf(buf, rem, NFACCT_STR_XML_BONLY, nfacct_name,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR,
+						    bytes,thr),
 				bn.str);
 		BUFFER_SIZE(ret, size, rem, offset);
 	} else {
 		/* default/everything else: print name + pkts + bytes */
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 
 		if (fmt == NFACCT_FMT_MAX)
 			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
@@ -898,6 +980,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
 				pn.str,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR,
+						    bytes,thr),
 				bn.str);
 		}
 		BUFFER_SIZE(ret, size, rem, offset);
@@ -1048,8 +1132,17 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
 
+	if (nfacct->bitset & (1 << NFACCT_ATTR_BTHR))
+		mnl_attr_put_u64(nlh, NFACCT_BTHR, htobe64(nfacct->bthr));
+
 	if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
 		mnl_attr_put_u16(nlh, NFACCT_FMT, htobe16(nfacct->fmt));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_FLAGS))
+		mnl_attr_put_u16(nlh, NFACCT_FLAGS, htobe16(nfacct->flags));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_CMD))
+		mnl_attr_put_u16(nlh, NFACCT_CMD, htobe16(nfacct->cmd));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -1070,12 +1163,15 @@ static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFACCT_PKTS:
 	case NFACCT_BYTES:
+	case NFACCT_BTHR:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
 		}
 		break;
 	case NFACCT_FMT:
+	case NFACCT_FLAGS:
+	case NFACCT_CMD:
 		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -1110,9 +1206,18 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_PKTS])));
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES,
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_BYTES])));
+	if (tb[NFACCT_BTHR])
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BTHR,
+				  be64toh(mnl_attr_get_u64(tb[NFACCT_BTHR])));
 	if (tb[NFACCT_FMT])
 		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FMT,
 				  be16toh(mnl_attr_get_u16(tb[NFACCT_FMT])));
+	if (tb[NFACCT_FLAGS])
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_FLAGS,
+				be16toh(mnl_attr_get_u16(tb[NFACCT_FLAGS])));
+	if (tb[NFACCT_CMD])
+		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_CMD,
+				be16toh(mnl_attr_get_u16(tb[NFACCT_CMD])));
 
 	return 0;
 }
-- 
1.8.3.1

