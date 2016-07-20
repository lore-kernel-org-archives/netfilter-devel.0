From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf_conntrack] conntrack: labels: add function to fetch default config file location
Date: Thu, 21 Jul 2016 00:22:25 +0200
Message-ID: <1469053345-11046-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56450 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbcGTWW4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 18:22:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/internal/prototypes.h                           |  1 +
 include/libnetfilter_conntrack/libnetfilter_conntrack.h |  1 +
 src/conntrack/api.c                                     | 11 +++++++++++
 src/conntrack/labels.c                                  |  5 +++++
 4 files changed, 18 insertions(+)

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index a984a2f..251e57d 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -58,6 +58,7 @@ int __snprintf_expect_xml(char *buf, unsigned int len, const struct nf_expect *e
 /*
  * connlabel internal prototypes
  */
+const char *__labels_get_path(void);
 struct nfct_labelmap *__labelmap_new(const char *);
 void __labelmap_destroy(struct nfct_labelmap *);
 
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 6cba578..8579307 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -297,6 +297,7 @@ bool nfct_bitmask_equal(const struct nfct_bitmask *, const struct nfct_bitmask *
 /* connlabel name <-> bit translation mapping */
 struct nfct_labelmap;
 
+const char *nfct_labels_get_path(void);
 struct nfct_labelmap *nfct_labelmap_new(const char *mapfile);
 void nfct_labelmap_destroy(struct nfct_labelmap *map);
 const char *nfct_labelmap_get_name(struct nfct_labelmap *m, unsigned int bit);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index ed235ff..e4d4acc 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1527,6 +1527,17 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
  */
 
 /**
+ * nfct_labels_get_path - get name of default config path
+ *
+ * returns a pointer to a immutable (static) string containing
+ * the default connlabel.conf file location.
+ */
+const char *nfct_labels_get_path(void)
+{
+	return __labels_get_path();
+}
+
+/**
  * nfct_labelmap_get_name - get name of the label bit
  *
  * \param m label map obtained from nfct_label_open
diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
index 32113c1..8048076 100644
--- a/src/conntrack/labels.c
+++ b/src/conntrack/labels.c
@@ -209,6 +209,11 @@ static bool label_is_sane(const char *label)
 	return true;
 }
 
+const char *__labels_get_path(void)
+{
+	return CONNLABEL_CFG;
+}
+
 struct nfct_labelmap *__labelmap_new(const char *name)
 {
 	struct nfct_labelmap *map;
-- 
2.7.3

