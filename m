From: Florian Westphal <fw@strlen.de>
Subject: [PATCH V2 lnf-ct 2/2] conntrack: snprintf: add connlabel format specifier
Date: Sun, 23 Jun 2013 23:14:39 +0200
Message-ID: <1372022079-11719-2-git-send-email-fw@strlen.de>
References: <1372022079-11719-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44876 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab3FWVQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:16:14 -0400
In-Reply-To: <1372022079-11719-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By default, nfct_snprintf will not print connlabels, as they're
system specific and can easily generate lots of output.

This adds a fmt attribute to print connlabel names.

output looks like this:
... mark=0 use=1 labels=eth0-in,eth1-in
or
<labels>
<label>eth0-in</label>
<label>eth1-in</label>
</labels>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Pablo, I _think_ this is pretty much what you had in
 mind, if I misunderstood anything please let me know.

 Change since V1:
 - avoid changing current nfct_snprint default output
 - print only name of a label, needs NFCT_OF_CONNLABELS output format

 include/internal/prototypes.h                      |  1 +
 .../libnetfilter_conntrack.h                       |  3 ++
 src/conntrack/snprintf_default.c                   | 60 ++++++++++++++++++++++
 src/conntrack/snprintf_xml.c                       | 37 +++++++++++++
 4 files changed, 101 insertions(+)

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 484deea..414d7f8 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -15,6 +15,7 @@ int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *
 int __snprintf_proto(char *buf, unsigned int len, const struct __nfct_tuple *tuple);
 int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
 int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
+int __snprintf_connlabels(char *buf, unsigned int len, struct nfct_labelmap *map, const struct nfct_bitmask *b, const char *fmt);
 
 enum __nfct_addr {
 	__ADDR_SRC = 0,
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 39dc24c..eedf85e 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -389,6 +389,9 @@ enum {
 
 	NFCT_OF_TIMESTAMP_BIT = 3,
 	NFCT_OF_TIMESTAMP = (1 << NFCT_OF_TIMESTAMP_BIT),
+
+	NFCT_OF_CONNLABELS_BIT = 4,
+	NFCT_OF_CONNLABELS = (1 << NFCT_OF_CONNLABELS_BIT),
 };
 
 extern int nfct_snprintf(char *buf, 
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 911faea..2ede0bc 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -288,6 +288,61 @@ __snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *c
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
+		   const struct nf_conntrack *ct)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	struct nfct_labelmap *map;
+	int ret, size = 0, offset = 0;
+
+	if (!b)
+		return 0;
+
+	map = nfct_labelmap_new(NULL);
+	if (!map)
+		return 0;
+
+	ret = snprintf(buf, len, "labels=");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	ret = __snprintf_connlabels(buf + offset, len, map, b, "%s,");
+
+	nfct_labelmap_destroy(map);
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
@@ -426,6 +481,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if ((flags & NFCT_OF_CONNLABELS) && test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Delete the last blank space */
 	size--;
 
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index ad53075..27cda04 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -348,6 +348,36 @@ static int __snprintf_tuple_xml(char *buf,
 	return size;
 }
 
+static int
+__snprintf_clabels_xml(char *buf, unsigned int len,
+		       const struct nf_conntrack *ct)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	struct nfct_labelmap *map;
+	int ret, size = 0, offset = 0;
+
+	if (!b)
+		return 0;
+
+	map = nfct_labelmap_new(NULL);
+	if (!map)
+		return 0;
+
+	ret = snprintf(buf, len, "<labels>");
+	BUFFER_SIZE(ret, size, len, offset);
+
+	ret = __snprintf_connlabels(buf + offset, len, map, b, "<label>%s</label>");
+
+	nfct_labelmap_destroy(map);
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
@@ -390,6 +420,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
@@ -432,6 +463,11 @@ int __snprintf_conntrack_xml(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if ((flags & NFCT_OF_CONNLABELS) && test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels_xml(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_SECMARK, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
 				"<secmark>%u</secmark>", ct->secmark);
@@ -510,6 +546,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 	    	ret = snprintf(buf+offset, len, "</meta>");
-- 
1.8.1.5

