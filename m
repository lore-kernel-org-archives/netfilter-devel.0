From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 iptables,xlate4] xtables: add xt_xlate_add_comment()
Date: Mon,  1 Feb 2016 19:43:36 +0100
Message-ID: <1454352216-18812-3-git-send-email-pablo@netfilter.org>
References: <1454352216-18812-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56515 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbcBASnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 13:43:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E956A61EA2
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DB4E8DA809
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ED773DA801
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:41 +0100 (CET)
In-Reply-To: <1454352216-18812-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new function allows us to add comments to the nft rule. This
can be used to provide a translation for the comment match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/xtables.h    |  1 +
 libxtables/xtables.c | 41 ++++++++++++++++++++++++++---------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 82aa2bb..6fd3bdf 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -573,6 +573,7 @@ extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 struct xt_xlate *xt_xlate_alloc(int size);
 void xt_xlate_free(struct xt_xlate *xl);
 void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...);
+void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment);
 const char *xt_xlate_get(struct xt_xlate *xl);
 
 #ifdef XTABLES_INTERNAL
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 32d6a5a..c4b86f5 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1987,11 +1987,16 @@ void get_kernel_version(void)
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
+#include <linux/netfilter/nf_tables.h>
+
 struct xt_xlate {
-	char	*data;
-	int	size;
-	int	rem;
-	int	off;
+	struct {
+		char	*data;
+		int	size;
+		int	rem;
+		int	off;
+	} buf;
+	char comment[NFT_USERDATA_MAXLEN];
 };
 
 struct xt_xlate *xt_xlate_alloc(int size)
@@ -2002,20 +2007,20 @@ struct xt_xlate *xt_xlate_alloc(int size)
 	if (xl == NULL)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	xl->data = malloc(size);
-	if (xl->data == NULL)
+	xl->buf.data = malloc(size);
+	if (xl->buf.data == NULL)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	xl->size = size;
-	xl->rem = size;
-	xl->off = 0;
+	xl->buf.size = size;
+	xl->buf.rem = size;
+	xl->buf.off = 0;
 
 	return xl;
 }
 
 void xt_xlate_free(struct xt_xlate *xl)
 {
-	free(xl->data);
+	free(xl->buf.data);
 	free(xl);
 }
 
@@ -2025,16 +2030,22 @@ void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...)
 	int len;
 
 	va_start(ap, fmt);
-	len = vsnprintf(xl->data + xl->off, xl->rem, fmt, ap);
-	if (len < 0 || len >= xl->rem)
+	len = vsnprintf(xl->buf.data + xl->buf.off, xl->buf.rem, fmt, ap);
+	if (len < 0 || len >= xl->buf.rem)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
 	va_end(ap);
-	xl->rem -= len;
-	xl->off += len;
+	xl->buf.rem -= len;
+	xl->buf.off += len;
+}
+
+void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment)
+{
+	strncpy(xl->comment, comment, NFT_USERDATA_MAXLEN - 1);
+	xl->comment[NFT_USERDATA_MAXLEN - 1] = '\0';
 }
 
 const char *xt_xlate_get(struct xt_xlate *xl)
 {
-	return xl->data;
+	return xl->buf.data;
 }
-- 
2.1.4

