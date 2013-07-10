From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 25/29] add packets/bytes mark capability support
Date: Wed, 10 Jul 2013 19:25:23 +0100
Message-ID: <1373480727-11254-26-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:42319 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3GJS0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:51 -0400
Received: by mail-la0-f53.google.com with SMTP id fs12so5986032lab.26
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:49 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add support for printing/retrieving packets and bytes mark of nfacct
objects, using the 'pmark' and 'bmark' values stored in each such object
within the kernel;

* enhance the existing API to support get/set pmark/bmark functions;

* adjust all existing xml and plaintext templates to support this feature;

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |   4 +
 include/linux/netfilter/nfnetlink_acct.h      |   8 +-
 src/libnetfilter_acct.c                       | 169 +++++++++++++++++++++++---
 3 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index e4f21e0..a58d93f 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -18,6 +18,8 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_FMT,
 	NFACCT_ATTR_FLAGS,
 	NFACCT_ATTR_CMD,
+	NFACCT_ATTR_PMARK,
+	NFACCT_ATTR_BMARK,
 };
 
 struct nfacct_options;
@@ -25,7 +27,9 @@ struct nfacct_options;
 enum nfacct_option_type {
 	NFACCT_OPT_FMT = 0,	/* number format option 	*/
 	NFACCT_OPT_PCW,		/* packets count column width 	*/
+	NFACCT_OPT_PMCW,	/* packets mark column width 	*/
 	NFACCT_OPT_BCW,		/* bytes count column width 	*/
+	NFACCT_OPT_BMCW,	/* bytes mark column width 	*/
 	NFACCT_OPT_BTCW,	/* bytes threshold column width */
 };
 
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index e972970..87d2615 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,6 +10,8 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_GET_SETMARK,
+	NFNL_MSG_ACCT_GET_CLRMARK,
 	NFNL_MSG_ACCT_MAX
 };
 
@@ -23,6 +25,8 @@ enum nfnl_acct_type {
 	NFACCT_FMT,
 	NFACCT_FLAGS,
 	NFACCT_CMD,
+	NFACCT_PMARK,
+	NFACCT_BMARK,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
@@ -30,7 +34,9 @@ enum nfnl_acct_type {
 enum nfnl_acct_flags {
 	NFACCT_FLAG_BIT_BTHR 	= 0,
 	NFACCT_FLAG_BTHR	= (1 << NFACCT_FLAG_BIT_BTHR),
-	NFACCT_FLAG_BIT_MAX	= 1,
+	NFACCT_FLAG_BIT_MARK	= 1,
+	NFACCT_FLAG_MARK	= (1 << NFACCT_FLAG_BIT_MARK),
+	NFACCT_FLAG_BIT_MAX	= 2,
 	NFACCT_FLAG_MAX		= (1 << NFACCT_FLAG_BIT_MAX),
 };
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index c9f6fe6..8773710 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -62,6 +62,8 @@ struct nfacct {
 	uint64_t	pkts;
 	uint64_t	bytes;
 	uint64_t	bthr;
+	uint64_t	pmark;
+	uint64_t	bmark;
 	/*
 	 * Structure of fmt:
 	 * <- packets format: 8 bits-><-bytes format: 8 bits ->
@@ -77,6 +79,8 @@ struct nfacct_options {
 	size_t		pcw;
 	size_t		bcw;
 	size_t		btcw;
+	size_t		pmcw;
+	size_t		bmcw;
 	uint32_t	bitset;
 };
 
@@ -169,6 +173,14 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->cmd = *((uint16_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_CMD);
 		break;
+	case NFACCT_ATTR_PMARK:
+		nfacct->pmark = *((uint64_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_PMARK);
+		break;
+	case NFACCT_ATTR_BMARK:
+		nfacct->bmark = *((uint64_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_BMARK);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -245,6 +257,12 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 	case NFACCT_ATTR_CMD:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_CMD);
 		break;
+	case NFACCT_ATTR_PMARK:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_PMARK);
+		break;
+	case NFACCT_ATTR_BMARK:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_BMARK);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -290,6 +308,14 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 		if (nfacct->bitset & (1 << NFACCT_ATTR_CMD))
 			ret = &nfacct->cmd;
 		break;
+	case NFACCT_ATTR_PMARK:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_PMARK))
+			ret = &nfacct->pmark;
+		break;
+	case NFACCT_ATTR_BMARK:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_BMARK))
+			ret = &nfacct->bmark;
+		break;
 	}
 	return ret;
 }
@@ -368,6 +394,14 @@ nfacct_option_set(struct nfacct_options *options,
 		options->btcw = *((size_t *) data);
 		options->bitset |= (1 << NFACCT_OPT_BTCW);
 		break;
+	case NFACCT_OPT_PMCW:
+		options->pmcw = *((size_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_PMCW);
+		break;
+	case NFACCT_OPT_BMCW:
+		options->bmcw = *((size_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_BMCW);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_option_set);
@@ -424,6 +458,12 @@ nfacct_option_unset(struct nfacct_options *options,
 	case NFACCT_OPT_BTCW:
 		options->bitset &= ~(1 << NFACCT_OPT_BTCW);
 		break;
+	case NFACCT_OPT_PMCW:
+		options->bitset &= ~(1 << NFACCT_OPT_PMCW);
+		break;
+	case NFACCT_OPT_BMCW:
+		options->bitset &= ~(1 << NFACCT_OPT_BMCW);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_option_unset);
@@ -458,6 +498,14 @@ const void *nfacct_option_get(struct nfacct_options *options,
 		if (options->bitset & (1 << NFACCT_OPT_BTCW))
 			ret = &options->btcw;
 		break;
+	case NFACCT_OPT_PMCW:
+		if (options->bitset & (1 << NFACCT_OPT_PMCW))
+			ret = &options->pmcw;
+		break;
+	case NFACCT_OPT_BMCW:
+		if (options->bitset & (1 << NFACCT_OPT_BMCW))
+			ret = &options->bmcw;
+		break;
 	}
 	return ret;
 }
@@ -508,22 +556,26 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define PB ((uint64_t) TB*1000)
 #define EB ((uint64_t) PB*1000)
 
-#define NFACCT_STR_PLAIN_NUMONLY	"%s %s %s"
+#define NFACCT_STR_PLAIN_NUMONLY	"%s %s %s %s %s"
 #define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s fmt=%s,%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
 #define NFACCT_STR_PLAIN_SAVE_BTHR	" thr=%"PRIu64
-#define NFACCT_STR_PLAIN_EXTENDED	"[ pkts = %%%zus " \
-					" bytes = %%%zus%s" \
+#define NFACCT_STR_PLAIN_SAVE_MARK	" pmark=%"PRIu64 " bmark=%"PRIu64
+#define NFACCT_STR_PLAIN_EXTENDED	"[ pkts = %%%zus%s pmark = %%%zus " \
+					" bytes = %%%zus%s bmark = %%%zus " \
 					" thr = %%%zus ] = %%s"
-#define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus" \
+#define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus%s" \
 					" bytes = %%%zus%s ] = %%s"
-#define NFACCT_STR_PLAIN		"{ pkts = %%%zus, " \
+#define NFACCT_STR_PLAIN		"{ pkts = %%%zus%s, " \
 					"bytes = %%%zus%s } = %%s;"
 #define NFACCT_STR_PLAIN_BONLY		"[ bytes = %%%zus%s ] = %%s"
 #define NFACCT_XML_NAME			"<name>%s</name>"
-#define NFACCT_XML_PKTS			"<pkts fmt=\"%s\">%s</pkts>"
+#define NFACCT_XML_PKTS			"<pkts fmt=\"%s\" " \
+					"mark=\"%s\">%s</pkts>"
+#define NFACCT_XML_PMARK		"<pmark fmt=\"%s\">%s</pmark>"
 #define NFACCT_XML_BYTES		"<bytes fmt=\"%s\" " \
 					"thr=\"%s\">%s</bytes>"
+#define NFACCT_XML_BMARK		"<bmark fmt=\"%s\">%s</bmark>"
 #define NFACCT_XML_BTHR			"<threshold fmt=\"%s\">%s</threshold>"
 #define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_BYTES
@@ -533,7 +585,8 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_STR_XML			"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_PKTS NFACCT_XML_BYTES
 #define NFACCT_STR_XML_EXTENDED		"<obj>"	NFACCT_XML_NAME \
-					NFACCT_XML_PKTS NFACCT_XML_BYTES \
+					NFACCT_XML_PKTS NFACCT_XML_PMARK \
+					NFACCT_XML_BYTES NFACCT_XML_BMARK \
 					NFACCT_XML_BTHR
 #define NFACCT_STR_DEFAULT		"%020.0f%s"
 #define NFACCT_STR_NONE			"%.0f%s"
@@ -542,6 +595,7 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 
 #define NFACCT_NUM_DEFAULT		{ .value = 0., .str = "" }
 #define NFACCT_THR_DEFAULT		{ .value = 0., .str = "-" }
+#define NFACCT_MARK_DEFAULT		NFACCT_THR_DEFAULT
 
 struct nfacct_number {
 	float value;
@@ -779,13 +833,15 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 	int ret = 0, size = 0, offset = 0;
 	bool compat = (options == NULL);
 	uint16_t fmt, fl;
-	size_t pcw, bcw, btcw;
-	uint64_t pkts = 0, bytes = 0, thr = 0;
+	size_t pcw, bcw, btcw, pmcw, bmcw;
+	uint64_t pkts = 0, bytes = 0, thr = 0, pmark = 0, bmark = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
 	char fmt_str[sizeof(NFACCT_STR_PLAIN_EXTENDED) +
 		     sizeof(NFACCT_STR_DEFAULT) * 5 + 10];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     pm = NFACCT_MARK_DEFAULT,
 			     bn = NFACCT_NUM_DEFAULT,
+			     bm = NFACCT_MARK_DEFAULT,
 			     tn = NFACCT_THR_DEFAULT;
 
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
@@ -798,16 +854,22 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 				  nfacct_attr_get_str(nfacct,
 						      NFACCT_ATTR_NAME));
 
+		if (fl & NFACCT_FLAG_MARK)
+			pmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PMARK);
+
 		if (compat) {
 			fmt = NFACCT_FMT_MAX;
 			snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN,
-				 (size_t)0, (size_t)0, "");
+				 (size_t)0, "", (size_t)0, "");
 		} else {
 			fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
 			snprintf(fmt_str, sizeof(fmt_str),
 				NFACCT_STR_PLAIN_NEW,
 				 nfacct_option_get_tsize(options,
 							 NFACCT_OPT_PCW),
+				 NFACCT_PRINT_FL(fl & NFACCT_FLAG_MARK,
+						 pkts,pmark),
 				 nfacct_option_get_tsize(options,
 							 NFACCT_OPT_BCW),
 				 NFACCT_PRINT_FL(fl & NFACCT_FLAG_BTHR,
@@ -840,6 +902,12 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		BUFFER_SIZE(ret, size, rem, offset);
 
 		fl = nfacct_attr_get_u16(nfacct,NFACCT_ATTR_FLAGS);
+		if (fl & NFACCT_FLAG_MARK) {
+			ret = snprintf(buf+offset, rem, NFACCT_STR_PLAIN_SAVE_MARK,
+			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PMARK),
+			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BMARK));
+			BUFFER_SIZE(ret, size, rem, offset);
+		}
 		if (fl & NFACCT_FLAG_BTHR) {
 			ret = snprintf(buf+offset, rem, NFACCT_STR_PLAIN_SAVE_BTHR,
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BTHR));
@@ -883,15 +951,27 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
 		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
 
+		if (fl & NFACCT_FLAG_MARK) {
+			pmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PMARK);
+			bmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_BMARK);
+			format_number(&pm, pkts-pmark < 0 ? 0 : pkts-pmark,
+				      nfacct_get_pkt_fmt(fmt));
+			format_number(&bm, bytes-bmark < 0 ? 0 : bytes-bmark,
+				      nfacct_get_bytes_fmt(fmt));
+		}
 		if (fl & NFACCT_FLAG_BTHR)
 			format_number(&tn, thr, nfacct_get_bytes_fmt(fmt));
 
 		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_NUMONLY,
-				pn.str, bn.str, tn.str);
+				pn.str, pm.str,	bn.str,	bm.str,	tn.str);
 	} else if (flags & NFACCT_SNPRINTF_F_EXTENDED) {
 		/* print pkts + pmark + bytes + bmark + threshold + name */
 		pcw = nfacct_option_get_tsize(options, NFACCT_OPT_PCW);
+		pmcw = nfacct_option_get_tsize(options,	NFACCT_OPT_PMCW);
 		bcw = nfacct_option_get_tsize(options, NFACCT_OPT_BCW);
+		bmcw = nfacct_option_get_tsize(options,	NFACCT_OPT_BMCW);
 		btcw = nfacct_option_get_tsize(options, NFACCT_OPT_BTCW);
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
 		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
@@ -908,18 +988,31 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
 			init_locale();
 
+		if (fl & NFACCT_FLAG_MARK) {
+			pmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PMARK);
+			bmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_BMARK);
+			format_number(&pm, pkts-pmark < 0 ? 0 : pkts-pmark,
+				      nfacct_get_pkt_fmt(fmt));
+			format_number(&bm, bytes-bmark < 0 ? 0 : bytes-bmark,
+				      nfacct_get_bytes_fmt(fmt));
+		}
+
 		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
 		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
 
 		if (fl & NFACCT_FLAG_BTHR)
 			format_number(&tn, thr, nfacct_get_bytes_fmt(fmt));
 
-		snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN_EXTENDED,
-			 pcw, bcw,
+		snprintf(fmt_str,sizeof(fmt_str),NFACCT_STR_PLAIN_EXTENDED,
+			 pcw,
+			 NFACCT_PRINT_FL(fl & NFACCT_FLAG_MARK, pkts, pmark),
+			 pmcw, bcw,
 			 NFACCT_PRINT_FL(fl & NFACCT_FLAG_BTHR, bytes, thr),
-			 btcw);
-		ret = snprintf(buf, rem, fmt_str, pn.str, bn.str, tn.str,
-			       nfacct_name);
+			 bmcw, btcw);
+		ret = snprintf(buf, rem, fmt_str, pn.str, pm.str, bn.str,
+				bm.str, tn.str, nfacct_name);
 	} else {
 		/* print out name only */
 		parse_nfacct_name(nfacct_name,
@@ -970,10 +1063,12 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 	bool compat = (options == NULL);
 	unsigned int size = 0, offset = 0;
 	uint16_t fmt, fl;
-	uint64_t pkts = 0, bytes = 0, thr = 0;
+	uint64_t pkts = 0, bytes = 0, thr = 0, pmark = 0, bmark = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     pm = NFACCT_NUM_DEFAULT,
 			     bn = NFACCT_NUM_DEFAULT,
+			     bm = NFACCT_NUM_DEFAULT,
 			     tn = NFACCT_NUM_DEFAULT;
 
 	parse_nfacct_name_xml(nfacct_name,
@@ -1013,18 +1108,34 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		format_number(&pn, pkts, NFACCT_FMT_NONE);
 		format_number(&bn, bytes, NFACCT_FMT_NONE);
 
+		if (fl & NFACCT_FLAG_MARK) {
+			pmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PMARK);
+			bmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_BMARK);
+			format_number(&pm, pkts-pmark < 0 ? 0 : pkts-pmark,
+				      NFACCT_FMT_NONE);
+			format_number(&bm, bytes-bmark < 0 ? 0 : bytes-bmark,
+				      NFACCT_FMT_NONE);
+		}
 		if (fl & NFACCT_FLAG_BTHR)
 			format_number(&tn, thr, NFACCT_FMT_NONE);
 
 		ret = snprintf(buf, rem, NFACCT_STR_XML_EXTENDED,
 				nfacct_name,
 				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_MARK, pkts,
+					     	    pmark),
 				pn.str,
+				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				pm.str,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
-				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR,
-						    bytes, thr),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR, bytes,
+						    thr),
 				bn.str,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				bm.str,
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
 				tn.str);
 		BUFFER_SIZE(ret, size, rem, offset);
 	} else {
@@ -1034,6 +1145,10 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
 		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
 
+		if (fl & NFACCT_FLAG_MARK)
+			pmark = nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PMARK);
+
 		if (fmt == NFACCT_FMT_MAX)
 			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
 
@@ -1046,6 +1161,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 		} else {
 			ret = snprintf(buf, rem, NFACCT_STR_XML, nfacct_name,
 				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_MARK,
+						    pkts, pmark),
 				pn.str,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
 				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR,
@@ -1211,6 +1328,12 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_CMD))
 		mnl_attr_put_u16(nlh, NFACCT_CMD, htobe16(nfacct->cmd));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_PMARK))
+		mnl_attr_put_u64(nlh, NFACCT_PMARK, htobe64(nfacct->pmark));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_BMARK))
+		mnl_attr_put_u64(nlh, NFACCT_BMARK, htobe64(nfacct->bmark));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -1232,6 +1355,8 @@ static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFACCT_PKTS:
 	case NFACCT_BYTES:
 	case NFACCT_BTHR:
+	case NFACCT_PMARK:
+	case NFACCT_BMARK:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
@@ -1286,6 +1411,12 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 	if (tb[NFACCT_CMD])
 		nfacct_attr_set_u16(nfacct, NFACCT_ATTR_CMD,
 				be16toh(mnl_attr_get_u16(tb[NFACCT_CMD])));
+	if (tb[NFACCT_PMARK])
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PMARK,
+				be64toh(mnl_attr_get_u64(tb[NFACCT_PMARK])));
+	if (tb[NFACCT_BMARK])
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BMARK,
+				be64toh(mnl_attr_get_u64(tb[NFACCT_BMARK])));
 
 	return 0;
 }
-- 
1.8.3.1

