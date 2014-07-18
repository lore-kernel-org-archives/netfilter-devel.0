From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] src: improve printing of XML/JSON event wrapper
 header/footer
Date: Fri, 18 Jul 2014 13:08:06 +0200
Message-ID: <20140718110806.29103.18161.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36635 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933281AbaGRLIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:08:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Every snprintf() call is warranteed to put the trailing \0 character, unless
the output was truncated, ie ret == bufsiz. In case of output truncated, the
caller must reallocate a buffer and start again.
This \0 character is used by other functions like fputs() and fprintf() to
know where a string ends, so they avoid adding garbage to the output.

The XML/JSON event wrapper header/footer is printed for each object, meaning
that the header is the first thing to be written to the buffer and the footer
the last; all objects share this code path.

A new helper function nft_fprintf2() is added because:
 * we need to handle the needed buffer resizing.
 * so, we can ignore about what string the header/footer are composed of.
 * nft_fprint() requires an object; the signature of the function differs.

There were two cases we weren't considering in the header/footer fprintf
functions: if the nft_event_[head|foot]er_snprintf() call returned 0 and/or if
returned < 0. Previous to this patch, we unconditionally do a fprintf().

Now with this patch, we avoid doing fprintf() if the inner snprintf() call:
 * failed (ret < 0)
 * didn't print nothing (ret == 0) to the buffer (even a \0 character)

Also, we were unconditionally adding a \0 character at buf[sizeof(buf) - 1],
meaning that if the inner snprintf() returned 0, we get sizeof(buf) - 2
characters of unknown value.

A side effect of this patch is that we avoid 2 syscall (2 fprintf() calls) per
nft object to be printed if the header/footer is empty (ie, no events flags
set).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/common.c   |   14 ++------------
 src/internal.h |    3 +++
 src/utils.c    |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/src/common.c b/src/common.c
index 1b600f1..2ebb7d1 100644
--- a/src/common.c
+++ b/src/common.c
@@ -113,12 +113,7 @@ int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
 
 int nft_event_header_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 {
-	char buf[64]; /* enough for the maximum string length above */
-
-	nft_event_header_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
-
-	return fprintf(fp, "%s", buf);
+	return nft_fprintf2(fp, type, flags, nft_event_header_snprintf);
 }
 
 int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
@@ -139,10 +134,5 @@ int nft_event_footer_snprintf(char *buf, size_t size, uint32_t type,
 
 int nft_event_footer_fprintf(FILE *fp, uint32_t type, uint32_t flags)
 {
-	char buf[32]; /* enough for the maximum string length above */
-
-	nft_event_footer_snprintf(buf, sizeof(buf), type, flags);
-	buf[sizeof(buf) - 1] = '\0';
-
-	return fprintf(fp, "%s", buf);
+	return nft_fprintf2(fp, type, flags, nft_event_footer_snprintf);
 }
diff --git a/src/internal.h b/src/internal.h
index b8ed616..04c3ef9 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -136,6 +136,9 @@ int nft_get_value(enum nft_type type, void *val, void *out);
 
 #include <stdio.h>
 int nft_fprintf(FILE *fp, void *obj, uint32_t type, uint32_t flags, int (*snprintf_cb)(char *buf, size_t bufsiz, void *obj, uint32_t type, uint32_t flags));
+int nft_fprintf2(FILE *fp, uint32_t type, uint32_t flags,
+		 int (*snprintf_cb)(char *buf, size_t bufsiz, uint32_t type,
+				    uint32_t flags));
 int nft_event_header_snprintf(char *buf, size_t bufsize,
 			      uint32_t format, uint32_t flags);
 int nft_event_header_fprintf(FILE *fp, uint32_t format, uint32_t flags);
diff --git a/src/utils.c b/src/utils.c
index 20a2fa3..94268c3 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -219,6 +219,39 @@ out:
 	return ret;
 }
 
+int nft_fprintf2(FILE *fp, uint32_t type, uint32_t flags,
+		 int (*snprintf_cb)(char *buf, size_t bufsiz, uint32_t type,
+				    uint32_t flags))
+{
+	char _buf[NFT_SNPRINTF_BUFSIZ];
+	char *buf = _buf;
+	size_t bufsiz = sizeof(_buf);
+	int ret;
+
+	ret = snprintf_cb(buf, bufsiz, type, flags);
+	if (ret <= 0)
+		goto out;
+
+	if (ret >= NFT_SNPRINTF_BUFSIZ) {
+		bufsiz = ret + 1;
+
+		buf = malloc(bufsiz);
+		if (buf == NULL)
+			return -1;
+
+		ret = snprintf_cb(buf, bufsiz, type, flags);
+		if (ret <= 0)
+			goto out;
+	}
+
+	ret = fprintf(fp, "%s", buf);
+out:
+	if (buf != _buf)
+		xfree(buf);
+
+	return ret;
+}
+
 void __nft_assert_fail(uint16_t attr, const char *filename, int line)
 {
 	fprintf(stderr, "libnftnl: attribute %d assertion failed in %s:%d\n",

