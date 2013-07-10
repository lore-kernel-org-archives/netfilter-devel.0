From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 10/29] add *_BONLY template to show bytes-only
Date: Wed, 10 Jul 2013 19:25:08 +0100
Message-ID: <1373480727-11254-11-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50343 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3GJS0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:00 -0400
Received: by mail-lb0-f176.google.com with SMTP id z5so5986949lbh.35
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:59 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add NFACCT_SNPRINTF_F_BONLY plaintext and xml templates, allowing printing
of only the bytes and name columns for each accounting object. Example:

{ bytes = 00000000018921291776 } = "ALL IN net 17"

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  3 ++
 src/libnetfilter_acct.c                       | 41 ++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index ecf8280..aec26d3 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -42,6 +42,9 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 /* print in a format suitable for 'restore' */
 #define NFACCT_SNPRINTF_F_SAVE		(1 << 2)
 
+/* print only the bytes and name columns */
+#define NFACCT_SNPRINTF_F_BONLY		(1 << 3)
+
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index e4fdf84..23f7616 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -230,6 +230,16 @@ EXPORT_SYMBOL(nfacct_attr_get_u64);
 
 #define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
+#define NFACCT_STR_PLAIN		"{ pkts = %.20"PRIu64", " \
+					"bytes = %.20"PRIu64" } = %s"
+#define NFACCT_STR_PLAIN_BONLY		"{ bytes = %.20"PRIu64 " } = %s"
+#define NFACCT_XML_NAME			"<name>%s</name>"
+#define NFACCT_XML_PKTS			"<pkts>%.20"PRIu64"</pkts>"
+#define NFACCT_XML_BYTES		"<bytes>%.20"PRIu64"</bytes>"
+#define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
+					NFACCT_XML_BYTES
+#define NFACCT_STR_XML			"<obj>"	NFACCT_XML_NAME \
+					NFACCT_XML_PKTS NFACCT_XML_BYTES
 
 void
 parse_nfacct_name(char *buf, const char *name)
@@ -325,8 +335,7 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 			  nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
 		/* default: print pkts + bytes + name */
-		ret = snprintf(buf, rem,
-			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
+		ret = snprintf(buf, rem, NFACCT_STR_PLAIN,
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
 			nfacct_name);
@@ -336,6 +345,11 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 			       nfacct_name,
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PKTS),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BYTES));
+	} else if (flags & NFACCT_SNPRINTF_F_BONLY) {
+		/* print bytes + name only */
+		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_BONLY,
+				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
+				nfacct_name);
 	} else {
 		/* print out name only */
 		ret = snprintf(buf, rem, "%s\n", nfacct_name);
@@ -393,14 +407,21 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 	parse_nfacct_name_xml(nfacct_name,
 				nfacct_attr_get_str(nfacct,
 						    NFACCT_ATTR_NAME));
-	ret = snprintf(buf, rem,
-			"<obj><name>%s</name>"
-			"<pkts>%.20"PRIu64"</pkts>"
-			"<bytes>%.20"PRIu64"</bytes>",
-			nfacct_name,
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
-	BUFFER_SIZE(ret, size, rem, offset);
+	if (flags & NFACCT_SNPRINTF_F_BONLY) {
+		/* print name + bytes only */
+		ret = snprintf(buf, rem, NFACCT_STR_XML_BONLY, nfacct_name,
+				nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_BYTES));
+		BUFFER_SIZE(ret, size, rem, offset);
+	} else {
+		/* default/everything else: print name + pkts + bytes */
+		ret = snprintf(buf, rem, NFACCT_STR_XML, nfacct_name,
+				nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_BYTES),
+				nfacct_attr_get_u64(nfacct,
+						    NFACCT_ATTR_PKTS));
+		BUFFER_SIZE(ret, size, rem, offset);
+	}
 
 	if (flags & NFACCT_SNPRINTF_F_TIME) {
 		time_t t;
-- 
1.8.3.1

