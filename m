From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 27/29] add *_MONLY template support
Date: Wed, 10 Jul 2013 19:25:25 +0100
Message-ID: <1373480727-11254-28-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56106 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3GJS04 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:56 -0400
Received: by mail-lb0-f176.google.com with SMTP id z5so5866761lbh.21
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:54 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add NFACCT_SNPRINTF_F_MONLY plaintext and xml templates, allowing
printing of mark-only nfacct object attriutes - name, pmark and bmark -
showing the amount of traffic which passed through each nfacct object
since the last mark was set, allowing for short-term traffic analysis, in
addition to the main traffic. Example:

[ pmark = 8,629,324  bmark = 4.447GiB ] = "ALL WEB"

<?xml version="1.0" encoding="utf-8"?>
<nfacct>
<obj>
<name>ALL WEB</name>
<pmark fmt="3pl">8629324</pmark>
<bmark fmt="iec">4774467072</bmark>
</obj>
</nfacct>

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  3 ++
 src/libnetfilter_acct.c                       | 62 +++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index a58d93f..9030f64 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -131,6 +131,9 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 /* print packets, pmark, bytes, bmark, threshold and name columns */
 #define NFACCT_SNPRINTF_F_EXTENDED	(1 << 5)
 
+/* print pmark, bmark and name columns */
+#define NFACCT_SNPRINTF_F_MONLY		(1 << 6)
+
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 8773710..e57cb16 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -569,6 +569,8 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_STR_PLAIN		"{ pkts = %%%zus%s, " \
 					"bytes = %%%zus%s } = %%s;"
 #define NFACCT_STR_PLAIN_BONLY		"[ bytes = %%%zus%s ] = %%s"
+#define NFACCT_STR_PLAIN_MONLY		"[ pmark = %%%zus  bmark = %%%zus ]" \
+					" = %%s"
 #define NFACCT_XML_NAME			"<name>%s</name>"
 #define NFACCT_XML_PKTS			"<pkts fmt=\"%s\" " \
 					"mark=\"%s\">%s</pkts>"
@@ -579,6 +581,8 @@ EXPORT_SYMBOL(nfacct_option_get_tsize);
 #define NFACCT_XML_BTHR			"<threshold fmt=\"%s\">%s</threshold>"
 #define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_BYTES
+#define NFACCT_STR_XML_MONLY		"<obj>"	NFACCT_XML_NAME \
+					NFACCT_XML_PMARK NFACCT_XML_BMARK
 #define NFACCT_STR_XML_COMPAT		"<obj><name>%s</name>"	\
 					"<pkts>%s</pkts>"	\
 					"<bytes>%s</bytes>"
@@ -1013,6 +1017,39 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 			 bmcw, btcw);
 		ret = snprintf(buf, rem, fmt_str, pn.str, pm.str, bn.str,
 				bm.str, tn.str, nfacct_name);
+	} else if (flags & NFACCT_SNPRINTF_F_MONLY) {
+		/* print pmark + bmark + name */
+		pmcw = nfacct_option_get_tsize(options,	NFACCT_OPT_PMCW);
+		bmcw = nfacct_option_get_tsize(options,	NFACCT_OPT_BMCW);
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
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
+		snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN_MONLY,
+			 pmcw, bmcw);
+		ret = snprintf(buf, rem, fmt_str, pm.str, bm.str,
+				nfacct_name);
 	} else {
 		/* print out name only */
 		parse_nfacct_name(nfacct_name,
@@ -1138,6 +1175,31 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
 				tn.str);
 		BUFFER_SIZE(ret, size, rem, offset);
+	} else if (flags & NFACCT_SNPRINTF_F_MONLY) {
+		/* print pmark + bmark + name */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		fl = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FLAGS);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = nfacct_attr_get_u16(nfacct, NFACCT_ATTR_FMT);
+
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
+		ret = snprintf(buf, rem, NFACCT_STR_XML_MONLY, nfacct_name,
+				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				pm.str,
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				bm.str);
+		BUFFER_SIZE(ret, size, rem, offset);
 	} else {
 		/* default/everything else: print name + pkts + bytes */
 		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
-- 
1.8.3.1

