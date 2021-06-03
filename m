Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E210BC47096
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C43836140F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFCW76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:59:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45824 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCW75 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 18:59:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9E7FE64207
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 00:57:03 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2 1/5] libxtables: extend xlate infrastructure
Date:   Fri,  4 Jun 2021 00:58:02 +0200
Message-Id: <20210603225806.13625-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603225806.13625-1-pablo@netfilter.org>
References: <20210603225806.13625-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This infrastructure extends the existing xlate infrastructure:

- Extensions can define set dependencies through .xlate. The resulting
  set definition can be obtained through xt_xlate_set_get().
- Add xl_xlate_set_family() and xl_xlate_get_family() to store/fetch
  the family.

The first client of this new xlate API is the connlimit extension,
which is added in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac                 |  4 +-
 include/xtables.h            |  6 +++
 iptables/xtables-translate.c | 29 +++++++++----
 libxtables/xtables.c         | 82 ++++++++++++++++++++++++++++--------
 4 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6864378a3fcb..00ae60c5cfa1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.8.7])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=16
-libxtables_vage=4
+libxtables_vcurrent=17
+libxtables_vage=5
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h b/include/xtables.h
index df1eaee32664..347f4bd7aa98 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -632,9 +632,15 @@ extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 struct xt_xlate *xt_xlate_alloc(int size);
 void xt_xlate_free(struct xt_xlate *xl);
 void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
+#define xt_xlate_rule_add xt_xlate_add
+void xt_xlate_set_add(struct xt_xlate *xl, const char *fmt, ...) __attribute__((format(printf,2,3)));
 void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment);
 const char *xt_xlate_get_comment(struct xt_xlate *xl);
+void xl_xlate_set_family(struct xt_xlate *xl, uint8_t family);
+uint8_t xt_xlate_get_family(struct xt_xlate *xl);
 const char *xt_xlate_get(struct xt_xlate *xl);
+#define xt_xlate_rule_get xt_xlate_get
+const char *xt_xlate_set_get(struct xt_xlate *xl);
 
 #ifdef XTABLES_INTERNAL
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 575fb320dc40..33ba68eceb74 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -155,20 +155,33 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 			      bool append)
 {
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
+	const char *set;
 	int ret;
 
+	xl_xlate_set_family(xl, h->family);
+	ret = h->ops->xlate(cs, xl);
+	if (!ret)
+		goto err_out;
+
+	set = xt_xlate_set_get(xl);
+	if (set[0]) {
+		printf("add set %s %s %s\n", family2str[h->family], p->table,
+		       xt_xlate_set_get(xl));
+
+		if (!cs->restore && p->command != CMD_NONE)
+			printf("nft ");
+	}
+
 	if (append) {
-		xt_xlate_add(xl, "add rule %s %s %s ",
-			   family2str[h->family], p->table, p->chain);
+		printf("add rule %s %s %s ",
+		       family2str[h->family], p->table, p->chain);
 	} else {
-		xt_xlate_add(xl, "insert rule %s %s %s ",
-			   family2str[h->family], p->table, p->chain);
+		printf("insert rule %s %s %s ",
+		       family2str[h->family], p->table, p->chain);
 	}
+	printf("%s\n", xt_xlate_rule_get(xl));
 
-	ret = h->ops->xlate(cs, xl);
-	if (ret)
-		printf("%s\n", xt_xlate_get(xl));
-
+err_out:
 	xt_xlate_free(xl);
 	return ret;
 }
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index e6edfb5b4946..d7aab834b998 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2319,32 +2319,42 @@ void get_kernel_version(void)
 
 #include <linux/netfilter/nf_tables.h>
 
+enum xt_xlate_type {
+	XT_XLATE_RULE = 0,
+	XT_XLATE_SET,
+	__XT_XLATE_MAX
+};
+
 struct xt_xlate {
-	struct {
+	struct xt_xlate_buf {
 		char	*data;
 		int	size;
 		int	rem;
 		int	off;
-	} buf;
+	} buf[__XT_XLATE_MAX];
 	char comment[NFT_USERDATA_MAXLEN];
+	int family;
 };
 
 struct xt_xlate *xt_xlate_alloc(int size)
 {
 	struct xt_xlate *xl;
+	int i;
 
 	xl = malloc(sizeof(struct xt_xlate));
 	if (xl == NULL)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	xl->buf.data = malloc(size);
-	if (xl->buf.data == NULL)
-		xtables_error(RESOURCE_PROBLEM, "OOM");
+	for (i = 0; i < __XT_XLATE_MAX; i++) {
+		xl->buf[i].data = malloc(size);
+		if (xl->buf[i].data == NULL)
+			xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	xl->buf.data[0] = '\0';
-	xl->buf.size = size;
-	xl->buf.rem = size;
-	xl->buf.off = 0;
+		xl->buf[i].data[0] = '\0';
+		xl->buf[i].size = size;
+		xl->buf[i].rem = size;
+		xl->buf[i].off = 0;
+	}
 	xl->comment[0] = '\0';
 
 	return xl;
@@ -2352,23 +2362,44 @@ struct xt_xlate *xt_xlate_alloc(int size)
 
 void xt_xlate_free(struct xt_xlate *xl)
 {
-	free(xl->buf.data);
+	int i;
+
+	for (i = 0; i < __XT_XLATE_MAX; i++)
+		free(xl->buf[i].data);
+
 	free(xl);
 }
 
-void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...)
+static void __xt_xlate_add(struct xt_xlate *xl, enum xt_xlate_type type,
+			   const char *fmt, va_list ap)
 {
-	va_list ap;
+	struct xt_xlate_buf *buf = &xl->buf[type];
 	int len;
 
-	va_start(ap, fmt);
-	len = vsnprintf(xl->buf.data + xl->buf.off, xl->buf.rem, fmt, ap);
-	if (len < 0 || len >= xl->buf.rem)
+	len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
+	if (len < 0 || len >= buf->rem)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
+	buf->rem -= len;
+	buf->off += len;
+}
+
+void xt_xlate_rule_add(struct xt_xlate *xl, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__xt_xlate_add(xl, XT_XLATE_RULE, fmt, ap);
+	va_end(ap);
+}
+
+void xt_xlate_set_add(struct xt_xlate *xl, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__xt_xlate_add(xl, XT_XLATE_SET, fmt, ap);
 	va_end(ap);
-	xl->buf.rem -= len;
-	xl->buf.off += len;
 }
 
 void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment)
@@ -2382,7 +2413,22 @@ const char *xt_xlate_get_comment(struct xt_xlate *xl)
 	return xl->comment[0] ? xl->comment : NULL;
 }
 
+void xl_xlate_set_family(struct xt_xlate *xl, uint8_t family)
+{
+	xl->family = family;
+}
+
+uint8_t xt_xlate_get_family(struct xt_xlate *xl)
+{
+	return xl->family;
+}
+
 const char *xt_xlate_get(struct xt_xlate *xl)
 {
-	return xl->buf.data;
+	return xl->buf[XT_XLATE_RULE].data;
+}
+
+const char *xt_xlate_set_get(struct xt_xlate *xl)
+{
+	return xl->buf[XT_XLATE_SET].data;
 }
-- 
2.20.1

