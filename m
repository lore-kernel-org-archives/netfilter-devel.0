From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-ct V3] conntrack: api: add nfct_snprintf_labels
Date: Wed,  3 Jul 2013 13:06:22 +0200
Message-ID: <1372849582-14738-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49686 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932066Ab3GCLGN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:06:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>

nfct_snprintf doesn't print connlabels, as they're system specific
and can easily generate lots of output.

This adds a new helper function, nfct_snprintf_labels. It behaves like
nfct_snprintf, except that the label names in the labelmap whose bits are
contained in connlabel attribute bitset are added to the buffer.

output looks like this:
output looks like this:
... mark=0 use=1 labels=eth0-in,eth1-in
or
<labels>
<label>eth0-in</label>
<label>eth1-in</label>
</labels>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v2:
 - add nfct_snprintf_labels() as superset of nfct_snprintf
 - support xml output

 include/internal/prototypes.h                      |    7 ++-
 .../libnetfilter_conntrack.h                       |    8 +++
 src/conntrack/api.c                                |   29 +++++++++-
 src/conntrack/snprintf.c                           |    7 ++-
 src/conntrack/snprintf_default.c                   |   56 +++++++++++++++++++-
 src/conntrack/snprintf_xml.c                       |   33 +++++++++++-
 6 files changed, 130 insertions(+), 10 deletions(-)

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 484deea..21aa7f3 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -9,12 +9,13 @@ void __build_tuple(struct nfnlhdr *req, size_t size, const struct __nfct_tuple *
 int __parse_message_type(const struct nlmsghdr *nlh);
 void __parse_conntrack(const struct nlmsghdr *nlh, struct nfattr *cda[], struct nf_conntrack *ct);
 void __parse_tuple(const struct nfattr *attr, struct __nfct_tuple *tuple, int dir, u_int32_t *set);
-int __snprintf_conntrack(char *buf, unsigned int len, const struct nf_conntrack *ct, unsigned int type, unsigned int msg_output, unsigned int flags);
+int __snprintf_conntrack(char *buf, unsigned int len, const struct nf_conntrack *ct, unsigned int type, unsigned int msg_output, unsigned int flags, struct nfct_labelmap *);
 int __snprintf_address(char *buf, unsigned int len, const struct __nfct_tuple *tuple, const char *src_tag, const char *dst_tag);
 int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *ct);
 int __snprintf_proto(char *buf, unsigned int len, const struct __nfct_tuple *tuple);
-int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
-int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
+int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags, struct nfct_labelmap *);
+int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags, struct nfct_labelmap *);
+int __snprintf_connlabels(char *buf, unsigned int len, struct nfct_labelmap *map, const struct nfct_bitmask *b, const char *fmt);
 
 enum __nfct_addr {
 	__ADDR_SRC = 0,
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 39dc24c..8311739 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -398,6 +398,14 @@ extern int nfct_snprintf(char *buf,
 			 const unsigned int out_type,
 			 const unsigned int out_flags);
 
+extern int nfct_snprintf_labels(char *buf, 
+				unsigned int size,
+				const struct nf_conntrack *ct,
+				const unsigned int msg_type,
+				const unsigned int out_type,
+				const unsigned int out_flags,
+				struct nfct_labelmap *map);
+
 /* comparison */
 extern int nfct_compare(const struct nf_conntrack *ct1,
 			const struct nf_conntrack *ct2);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index b6c453f..cad860e 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1071,13 +1071,38 @@ int nfct_snprintf(char *buf,
 		  const struct nf_conntrack *ct,
 		  unsigned int msg_type,
 		  unsigned int out_type,
-		  unsigned int flags) 
+		  unsigned int flags)
 {
 	assert(buf != NULL);
 	assert(size > 0);
 	assert(ct != NULL);
 
-	return __snprintf_conntrack(buf, size, ct, msg_type, out_type, flags);
+	return __snprintf_conntrack(buf, size, ct, msg_type, out_type, flags, NULL);
+}
+
+/**
+ * nfct_snprintf_labels - print a bitmask object to a buffer including labels
+ * \param buf buffer used to build the printable conntrack
+ * \param size size of the buffer
+ * \param ct pointer to a valid conntrack object
+ * \param message_type print message type (NFCT_T_UNKNOWN, NFCT_T_NEW,...)
+ * \param output_type print type (NFCT_O_DEFAULT, NFCT_O_XML, ...)
+ * \param flags extra flags for the output type (NFCT_OF_LAYER3)
+ * \param map nfct_labelmap describing the connlabel translation, or NULL.
+ *
+ * When map is NULL, the function is equal to nfct_snprintf().
+ * Otherwise, if the conntrack object has a connlabel attribute, the active
+ * labels are translated using the label map and added to the buffer.
+ */
+int nfct_snprintf_labels(char *buf,
+			 unsigned int size,
+			 const struct nf_conntrack *ct,
+			 unsigned int msg_type,
+			 unsigned int out_type,
+			 unsigned int flags,
+			 struct nfct_labelmap *map)
+{
+	return __snprintf_conntrack(buf, size, ct, msg_type, out_type, flags, map);
 }
 
 /**
diff --git a/src/conntrack/snprintf.c b/src/conntrack/snprintf.c
index 9a9017d..17ad885 100644
--- a/src/conntrack/snprintf.c
+++ b/src/conntrack/snprintf.c
@@ -68,16 +68,17 @@ int __snprintf_conntrack(char *buf,
 			 const struct nf_conntrack *ct,
 			 unsigned int type,
 			 unsigned int msg_output,
-			 unsigned int flags)
+			 unsigned int flags,
+			 struct nfct_labelmap *map)
 {
 	int size;
 
 	switch(msg_output) {
 	case NFCT_O_DEFAULT:
-		size = __snprintf_conntrack_default(buf, len, ct, type, flags);
+		size = __snprintf_conntrack_default(buf, len, ct, type, flags, map);
 		break;
 	case NFCT_O_XML:
-		size = __snprintf_conntrack_xml(buf, len, ct, type, flags);
+		size = __snprintf_conntrack_xml(buf, len, ct, type, flags, map);
 		break;
 	default:
 		errno = ENOENT;
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 911faea..24e2f28 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -288,11 +288,60 @@ __snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *c
 	return (snprintf(buf, len, "helper=%s ", ct->helper_name));
 }
 
+int
+__snprintf_connlabels(char *buf, unsigned int len,
+		      struct nfct_labelmap *map,
+		      const struct nfct_bitmask *b, const char *fmt)
+{
+	unsigned int i, max;
+	int ret, size = 0, offset = 0;
+
+	max = nfct_bitmask_maxbit(b);
+	for (i = 0; i <= max && len; i++) {
+		const char *name;
+		if (!nfct_bitmask_test_bit(b, i))
+			continue;
+		name = nfct_labelmap_get_name(map, i);
+		if (!name || strcmp(name, "") == 0)
+			continue;
+
+		ret = snprintf(buf + offset, len, fmt, name);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+	return size;
+}
+
+static int
+__snprintf_clabels(char *buf, unsigned int len,
+		   const struct nf_conntrack *ct, struct nfct_labelmap *map)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	int ret, size = 0, offset = 0;
+
+	if (!b)
+		return 0;
+
+	ret = snprintf(buf, len, "labels=");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	ret = __snprintf_connlabels(buf + offset, len, map, b, "%s,");
+
+	BUFFER_SIZE(ret, size, len, offset);
+
+	offset--; /* remove last , */
+	size--;
+	ret = snprintf(buf + offset, len, " ");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	return size;
+}
+
 int __snprintf_conntrack_default(char *buf, 
 				 unsigned int len,
 				 const struct nf_conntrack *ct,
 				 unsigned int msg_type,
-				 unsigned int flags) 
+				 unsigned int flags,
+				 struct nfct_labelmap *map)
 {
 	int ret = 0, size = 0, offset = 0;
 
@@ -426,6 +475,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (map && test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels(buf+offset, len, ct, map);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Delete the last blank space */
 	size--;
 
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index ad53075..37f51b4 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -348,11 +348,35 @@ static int __snprintf_tuple_xml(char *buf,
 	return size;
 }
 
+static int
+__snprintf_clabels_xml(char *buf, unsigned int len,
+		       const struct nf_conntrack *ct, struct nfct_labelmap *map)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	int ret, size = 0, offset = 0;
+
+	if (!b)
+		return 0;
+
+	ret = snprintf(buf, len, "<labels>");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	ret = __snprintf_connlabels(buf + offset, len, map, b, "<label>%s</label>");
+
+	BUFFER_SIZE(ret, size, len, offset);
+
+	ret = snprintf(buf + offset, len, "</labels>");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	return size;
+}
+
 int __snprintf_conntrack_xml(char *buf,
 			     unsigned int len,
 			     const struct nf_conntrack *ct,
 			     const unsigned int msg_type,
-			     const unsigned int flags) 
+			     const unsigned int flags,
+			     struct nfct_labelmap *map)
 {
 	int ret = 0;
 	unsigned int size = 0, offset = 0;
@@ -390,6 +414,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
@@ -432,6 +457,11 @@ int __snprintf_conntrack_xml(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (map && test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels_xml(buf+offset, len, ct, map);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_SECMARK, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
 				"<secmark>%u</secmark>", ct->secmark);
@@ -510,6 +540,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 	    	ret = snprintf(buf+offset, len, "</meta>");
-- 
1.7.8.6

