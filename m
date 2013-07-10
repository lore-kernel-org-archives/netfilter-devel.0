From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 22/29] add *_EXTENDED template support
Date: Wed, 10 Jul 2013 19:25:20 +0100
Message-ID: <1373480727-11254-23-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53037 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3GJS0n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:43 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so6124950lab.28
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:42 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add NFACCT_SNPRINTF_F_EXTENDED plaintext and xml templates, allowing
printing of all nfacct object attriutes in separate columns: name,
packet & byte counters, threshold exceeded indicator and the threshold
value. Example:

[ pkts = 30,430,924  bytes = 17.624GiB+ thr = 15.000GiB ] = "ALL WEB"

<?xml version="1.0" encoding="utf-8"?>
<nfacct>
<obj>
<name>ALL WEB</name>
<pkts fmt="3pl">30430924</pkts>
<bytes fmt="iec" thr="true">18923536384</bytes>
<threshold fmt="iec">16106127360</threshold>
</obj>
</nfacct>

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  3 ++
 src/libnetfilter_acct.c                       | 72 ++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index 920df9d..e4f21e0 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -124,6 +124,9 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 /* print numbers only (formatted), useful for determining max column width */
 #define NFACCT_SNPRINTF_F_NUMONLY	(1 << 4)
 
+/* print packets, pmark, bytes, bmark, threshold and name columns */
+#define NFACCT_SNPRINTF_F_EXTENDED	(1 << 5)
+
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index db01c31..c9f6fe6 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -512,6 +512,9 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s fmt=%s,%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
 #define NFACCT_STR_PLAIN_SAVE_BTHR	" thr=%"PRIu64
+#define NFACCT_STR_PLAIN_EXTENDED	"[ pkts = %%%zus " \
+					" bytes = %%%zus%s" \
+					" thr = %%%zus ] = %%s"
 #define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus" \
 					" bytes = %%%zus%s ] = %%s"
 #define NFACCT_STR_PLAIN		"{ pkts = %%%zus, " \
@@ -521,6 +524,7 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_XML_PKTS			"<pkts fmt=\"%s\">%s</pkts>"
 #define NFACCT_XML_BYTES		"<bytes fmt=\"%s\" " \
 					"thr=\"%s\">%s</bytes>"
+#define NFACCT_XML_BTHR			"<threshold fmt=\"%s\">%s</threshold>"
 #define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_BYTES
 #define NFACCT_STR_XML_COMPAT		"<obj><name>%s</name>"	\
@@ -528,6 +532,9 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 					"<bytes>%s</bytes>"
 #define NFACCT_STR_XML			"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_PKTS NFACCT_XML_BYTES
+#define NFACCT_STR_XML_EXTENDED		"<obj>"	NFACCT_XML_NAME \
+					NFACCT_XML_PKTS NFACCT_XML_BYTES \
+					NFACCT_XML_BTHR
 #define NFACCT_STR_DEFAULT		"%020.0f%s"
 #define NFACCT_STR_NONE			"%.0f%s"
 #define NFACCT_STR_TRIPLETS		"%'.0f%s"
@@ -772,9 +779,10 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 	int ret = 0, size = 0, offset = 0;
 	bool compat = (options == NULL);
 	uint16_t fmt, fl;
+	size_t pcw, bcw, btcw;
 	uint64_t pkts = 0, bytes = 0, thr = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
-	char fmt_str[sizeof(NFACCT_STR_PLAIN_NEW) +
+	char fmt_str[sizeof(NFACCT_STR_PLAIN_EXTENDED) +
 		     sizeof(NFACCT_STR_DEFAULT) * 5 + 10];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
 			     bn = NFACCT_NUM_DEFAULT,
@@ -880,6 +888,38 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 
 		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_NUMONLY,
 				pn.str, bn.str, tn.str);
+	} else if (flags & NFACCT_SNPRINTF_F_EXTENDED) {
+		/* print pkts + pmark + bytes + bmark + threshold + name */
+		pcw = nfacct_option_get_tsize(options, NFACCT_OPT_PCW);
+		bcw = nfacct_option_get_tsize(options, NFACCT_OPT_BCW);
+		btcw = nfacct_option_get_tsize(options, NFACCT_OPT_BTCW);
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,
+						    NFACCT_ATTR_NAME));
+		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
+
+		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
+		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
+
+		if (fl & NFACCT_FLAG_BTHR)
+			format_number(&tn, thr, nfacct_get_bytes_fmt(fmt));
+
+		snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN_EXTENDED,
+			 pcw, bcw,
+			 NFACCT_PRINT_FL(fl & NFACCT_FLAG_BTHR, bytes, thr),
+			 btcw);
+		ret = snprintf(buf, rem, fmt_str, pn.str, bn.str, tn.str,
+			       nfacct_name);
 	} else {
 		/* print out name only */
 		parse_nfacct_name(nfacct_name,
@@ -933,7 +973,8 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 	uint64_t pkts = 0, bytes = 0, thr = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
 	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
-			     bn = NFACCT_NUM_DEFAULT;
+			     bn = NFACCT_NUM_DEFAULT,
+			     tn = NFACCT_NUM_DEFAULT;
 
 	parse_nfacct_name_xml(nfacct_name,
 				nfacct_attr_get_str(nfacct,
@@ -959,6 +1000,33 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 						    bytes,thr),
 				bn.str);
 		BUFFER_SIZE(ret, size, rem, offset);
+	} else if (flags & NFACCT_SNPRINTF_F_EXTENDED) {
+		/* print name + pkts + pmark + bytes + bmark + threshold */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
+
+		format_number(&pn, pkts, NFACCT_FMT_NONE);
+		format_number(&bn, bytes, NFACCT_FMT_NONE);
+
+		if (fl & NFACCT_FLAG_BTHR)
+			format_number(&tn, thr, NFACCT_FMT_NONE);
+
+		ret = snprintf(buf, rem, NFACCT_STR_XML_EXTENDED,
+				nfacct_name,
+				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				pn.str,
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				NFACCT_PRINT_FL_XML(fl & NFACCT_FLAG_BTHR,
+						    bytes, thr),
+				bn.str,
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				tn.str);
+		BUFFER_SIZE(ret, size, rem, offset);
 	} else {
 		/* default/everything else: print name + pkts + bytes */
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
-- 
1.8.3.1

