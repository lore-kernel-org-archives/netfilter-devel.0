From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 4/29] bugfix: correct (plain) name parsing
Date: Wed, 10 Jul 2013 19:25:02 +0100
Message-ID: <1373480727-11254-5-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38848 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:46 -0400
Received: by mail-lb0-f170.google.com with SMTP id t13so5909556lbd.29
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:44 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* allow accounting object names containing space or other "odd" characters
to be properly parsed and displayed.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  2 +
 src/libnetfilter_acct.c                       | 54 +++++++++++++++++++++++++--
 src/libnetfilter_acct.map                     |  1 +
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index b00e366..9f66c39 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -28,6 +28,8 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type);
 const char *nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type);
 uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type);
 
+void parse_nfacct_name(char *buf, const char *name);
+
 struct nlmsghdr;
 
 struct nlmsghdr *nfacct_nlmsg_build_hdr(char *buf, uint8_t cmd, uint16_t flags, uint32_t seq);
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 4d87da3..493be3b 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -228,6 +228,52 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 }
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
+void
+parse_nfacct_name(char *buf, const char *name)
+{
+	static const char no_quote_chars[] = ",._-0123456789"
+		"abcdefghijklmnopqrstuvwxyz"
+		"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	static const char escape_chars[] = "\"\\'";
+	size_t length;
+	const char *p;
+
+	if (buf == NULL)
+		return;
+
+	buf[0] = '\0';
+	if (name == NULL)
+		return;
+
+	length = strspn(name, no_quote_chars);
+
+	if (length > 0 && name[length] == 0) {
+		/* no quoting required */
+		strncat(buf, name, length);
+	} else {
+		/* there is at least one character in the name, which
+		   we have to quote.  Write double quotes around the
+		   name and escape special characters with a backslash */
+		strncat(buf,"\"",1);
+
+		for (p = strpbrk(name, escape_chars); p != NULL;
+		     p = strpbrk(name, escape_chars)) {
+			if (p > name) {
+				strncat(buf,name, p - name);
+			}
+			strncat(buf,"\\",1);
+			strncat(buf,p,1);
+			name = p + 1;
+		}
+
+		/* strcat the rest and finish the double quoted
+		   string */
+		strncat(buf,name,strlen(name));
+		strncat(buf,"\"",1);
+	}
+}
+EXPORT_SYMBOL(parse_nfacct_name);
+
 static
 void parse_nfacct_name_xml(char *buf, const char *name)
 {
@@ -270,16 +316,18 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags)
 {
 	int ret;
+	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
 
+	parse_nfacct_name(nfacct_name,
+			  nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
 		ret = snprintf(buf, rem,
 			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+			nfacct_name);
 	} else {
-		ret = snprintf(buf, rem, "%s\n",
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, "%s\n", nfacct_name);
 	}
 
 	return ret;
diff --git a/src/libnetfilter_acct.map b/src/libnetfilter_acct.map
index e71a6b3..f12bc8e 100644
--- a/src/libnetfilter_acct.map
+++ b/src/libnetfilter_acct.map
@@ -21,4 +21,5 @@ local: *;
 
 LIBNETFILTER_ACCT_1.1 {
   nfacct_snprintf;
+  parse_nfacct_name;
 } LIBNETFILTER_ACCT_1.0;
-- 
1.8.3.1

