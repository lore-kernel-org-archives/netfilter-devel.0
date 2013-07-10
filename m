From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 3/29] bugfix: correct xml name parsing
Date: Wed, 10 Jul 2013 19:25:01 +0100
Message-ID: <1373480727-11254-4-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:65111 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:43 -0400
Received: by mail-la0-f47.google.com with SMTP id fe20so6070882lab.34
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:42 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* allow accounting object names to be properly encoded and displayed when xml
output is needed, to fully conform to the xml specification.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 src/libnetfilter_acct.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index ba89e2d..4d87da3 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -228,6 +228,43 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 }
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
+static
+void parse_nfacct_name_xml(char *buf, const char *name)
+{
+	static const char escape_chars[] = "\"'<>&";
+	int length;
+	int n;
+	char e[10];
+	const char *p;
+
+	if (buf == NULL)
+		return;
+
+	buf[0] = '\0';
+	if (name == NULL)
+		return;
+
+	length = strcspn(name, escape_chars);
+	if (length > 0 && name[length] == 0) {
+		/* no escaping required */
+		strncat(buf, name, length);
+	} else {
+		for (p = strpbrk(name, escape_chars); p != NULL;
+		     p = strpbrk(name, escape_chars)) {
+			if (p > name)
+				strncat(buf, name, p - name);
+
+			n = *p;
+			snprintf(e, sizeof(e), "&#%d;", n);
+			strncat(buf, e, strlen(e));
+			name = p + 1;
+		}
+
+		/* strncat the rest */
+		strncat(buf, name, length);
+	}
+}
+
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags)
@@ -292,12 +329,16 @@ nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
 {
 	int ret = 0;
 	unsigned int size = 0, offset = 0;
+	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
 
+	parse_nfacct_name_xml(nfacct_name,
+				nfacct_attr_get_str(nfacct,
+						    NFACCT_ATTR_NAME));
 	ret = snprintf(buf, rem,
 			"<obj><name>%s</name>"
 			"<pkts>%.20"PRIu64"</pkts>"
 			"<bytes>%.20"PRIu64"</bytes>",
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
+			nfacct_name,
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
 	BUFFER_SIZE(ret, size, rem, offset);
-- 
1.8.3.1

