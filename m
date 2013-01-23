From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] api: add CTA_LABEL_MASK attribute handling
Date: Wed, 23 Jan 2013 23:38:21 +0100
Message-ID: <1358980701-3747-5-git-send-email-fw@strlen.de>
References: <1358980701-3747-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34232 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab3AWWmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:42:55 -0500
In-Reply-To: <1358980701-3747-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows to set/clear only a subset of the in-kernel label set, e.g.
"set bit 1 and do not change any others".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nfct-mnl-set-label.c                      |    8 +++++++
 include/internal/object.h                          |    1 +
 .../libnetfilter_conntrack.h                       |    1 +
 .../linux_nfnetlink_conntrack.h                    |    1 +
 src/conntrack/build_mnl.c                          |    6 +++++
 src/conntrack/copy.c                               |    8 +++++++
 src/conntrack/getter.c                             |    6 +++++
 src/conntrack/parse_mnl.c                          |    1 +
 src/conntrack/setter.c                             |   21 +++++++++++++++----
 9 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/examples/nfct-mnl-set-label.c b/examples/nfct-mnl-set-label.c
index 9e7fbf6..c52b267 100644
--- a/examples/nfct-mnl-set-label.c
+++ b/examples/nfct-mnl-set-label.c
@@ -35,6 +35,14 @@ static void set_label(struct nf_conntrack *ct, struct callback_args *cbargs)
 		nfct_bitmask_set_bit(b, bit);
 	nfct_set_attr(ct, ATTR_CONNLABELS, b);
 
+	if (bit >= 0) {
+		b = nfct_bitmask_new(bit);
+		if (b) {
+			nfct_bitmask_set_bit(b, bit);
+			nfct_set_attr(ct, ATTR_CONNLABELS_MASK, b);
+		}
+	}
+
 	cbargs->seq++;
 
 	nlh = mnl_nlmsg_put_header(buf);
diff --git a/include/internal/object.h b/include/internal/object.h
index bbb038a..540ad0d 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -191,6 +191,7 @@ struct nf_conntrack {
 	size_t helper_info_len;
 
 	struct nfct_bitmask *connlabels;
+	struct nfct_bitmask *connlabels_mask;
 };
 
 /*
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index c209184..39dc24c 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -134,6 +134,7 @@ enum nf_conntrack_attr {
 	ATTR_TIMESTAMP_STOP = 64,		/* u64 bits, linux >= 2.6.38 */
 	ATTR_HELPER_INFO,			/* variable length */
 	ATTR_CONNLABELS,			/* variable length */
+	ATTR_CONNLABELS_MASK,			/* variable length */
 	ATTR_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index fab40ae..1acc72a 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -52,6 +52,7 @@ enum ctattr_type {
 	CTA_TIMESTAMP,
 	CTA_MARK_MASK,
 	CTA_LABELS,
+	CTA_LABELS_MASK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index a666e01..a37bd73 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -386,6 +386,12 @@ nfct_build_labels(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	struct nfct_bitmask *b = ct->connlabels;
 	unsigned int size = b->words * sizeof(b->bits[0]);
 	mnl_attr_put(nlh, CTA_LABELS, size, b->bits);
+
+	if (test_bit(ATTR_CONNLABELS_MASK, ct->head.set)) {
+		b = ct->connlabels_mask;
+		if (size == (b->words * sizeof(b->bits[0])))
+			mnl_attr_put(nlh, CTA_LABELS_MASK, size, b->bits);
+	}
 }
 
 int
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index 9cb567c..43da12f 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -466,6 +466,12 @@ static void copy_attr_connlabels(struct nf_conntrack *dest,
 	dest->connlabels = do_copy_attr_connlabels(dest->connlabels, orig->connlabels);
 }
 
+static void copy_attr_connlabels_mask(struct nf_conntrack *dest,
+				 const struct nf_conntrack *orig)
+{
+	dest->connlabels_mask = do_copy_attr_connlabels(dest->connlabels_mask, orig->connlabels_mask);
+}
+
 const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= copy_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= copy_attr_orig_ipv4_dst,
@@ -534,6 +540,7 @@ const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_TIMESTAMP_STOP]		= copy_attr_timestamp_stop,
 	[ATTR_HELPER_INFO]		= copy_attr_help_info,
 	[ATTR_CONNLABELS]		= copy_attr_connlabels,
+	[ATTR_CONNLABELS_MASK]		= copy_attr_connlabels_mask,
 };
 
 /* this is used by nfct_copy() with the NFCT_CP_OVERRIDE flag set. */
@@ -548,4 +555,5 @@ void __copy_fast(struct nf_conntrack *ct1, const struct nf_conntrack *ct2)
 	copy_attr_secctx(ct1, ct2);
 	copy_attr_help_info(ct1, ct2);
 	copy_attr_connlabels(ct1, ct2);
+	copy_attr_connlabels_mask(ct1, ct2);
 }
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index 53c9e0e..ae546ee 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -344,6 +344,11 @@ static const void *get_attr_connlabels(const struct nf_conntrack *ct)
 	return ct->connlabels;
 }
 
+static const void *get_attr_connlabels_mask(const struct nf_conntrack *ct)
+{
+	return ct->connlabels_mask;
+}
+
 const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -412,4 +417,5 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_TIMESTAMP_STOP]		= get_attr_timestamp_stop,
 	[ATTR_HELPER_INFO]		= get_attr_helper_info,
 	[ATTR_CONNLABELS]		= get_attr_connlabels,
+	[ATTR_CONNLABELS_MASK]		= get_attr_connlabels_mask,
 };
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index a4272f9..6984e78 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -958,6 +958,7 @@ nfct_payload_parse(const void *payload, size_t payload_len,
 		if (nfct_parse_labels(tb[CTA_LABELS], ct) < 0)
 			return -1;
 	}
+	/* CTA_LABELS_MASK: never sent by kernel */
 
 	return 0;
 }
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 8879f02..4dda6c9 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -421,17 +421,27 @@ retry:
 }
 
 static void
-set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
+do_set_attr_connlabels(struct nfct_bitmask *current, const void *value)
 {
-	if (ct->connlabels == value)
-		return;
+	if (current && current != value)
+		nfct_bitmask_destroy(current);
+}
 
-	if (ct->connlabels)
-		nfct_bitmask_destroy(ct->connlabels);
+static void
+set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	do_set_attr_connlabels(ct->connlabels, value);
 	ct->connlabels = (void *) value;
 }
 
 static void
+set_attr_connlabels_mask(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	do_set_attr_connlabels(ct->connlabels_mask, value);
+	ct->connlabels_mask = (void *) value;
+}
+
+static void
 set_attr_do_nothing(struct nf_conntrack *ct, const void *value, size_t len) {}
 
 const set_attr set_attr_array[ATTR_MAX] = {
@@ -502,4 +512,5 @@ const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_TIMESTAMP_STOP]	= set_attr_do_nothing,
 	[ATTR_HELPER_INFO]	= set_attr_helper_info,
 	[ATTR_CONNLABELS]	= set_attr_connlabels,
+	[ATTR_CONNLABELS_MASK]	= set_attr_connlabels_mask,
 };
-- 
1.7.8.6

