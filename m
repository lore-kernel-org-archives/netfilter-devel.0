From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnfct-ct 1/2] conntrack: snprintf: add labels in hex representation by default
Date: Tue, 18 Jun 2013 22:54:21 +0200
Message-ID: <1371588862-3407-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57871 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282Ab3FRUz7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:55:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

udp      17 24 [..] dport=62277 mark=0 use=1 labels=0x28000000000000008
or
[..]<mark>0</mark><labels>0x28000000000000008</labels> [..] </meta></flow>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I'm interested if there are any objections on putting
 this in by default, one alternative would be to toss this and only
 print label info with special formating request (see next patch,
 which adds NFCT_OF_ specifier (which will then print the resovled names
 instead of bitmask).

 include/internal/prototypes.h    |  1 +
 src/conntrack/snprintf_default.c | 36 ++++++++++++++++++++++++++++++++++++
 src/conntrack/snprintf_xml.c     | 13 +++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 484deea..cc8de1d 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -15,6 +15,7 @@ int __snprintf_protocol(char *buf, unsigned int len, const struct nf_conntrack *
 int __snprintf_proto(char *buf, unsigned int len, const struct __nfct_tuple *tuple);
 int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
 int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
+int __snprintf_connlabels(char *buf, unsigned int len, const struct nf_conntrack *ct, const char *prefix, const char *end);
 
 enum __nfct_addr {
 	__ADDR_SRC = 0,
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 911faea..a1edef4 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -288,6 +288,37 @@ __snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *c
 	return (snprintf(buf, len, "helper=%s ", ct->helper_name));
 }
 
+int
+__snprintf_connlabels(char *buf, unsigned int len,
+		      const struct nf_conntrack *ct,
+		      const char *prefix, const char *end)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	unsigned int i;
+	int ret, size = 0, offset = 0;
+
+	if (!b)
+		return 0;
+	for (i = b->words - 1; i && b->bits[i] == 0; i--)
+		/* nothing */;
+	ret = snprintf(buf, len, "%s0x%x", prefix, b->bits[i]);
+	BUFFER_SIZE(ret, size, len, offset);
+	while (i > 0) {
+		i--;
+		ret = snprintf(buf + offset, len, "%08x", b->bits[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+	ret = snprintf(buf + offset, len, "%s", end);
+	BUFFER_SIZE(ret, size, len, offset);
+	return size;
+}
+
+static int
+__snprintf_clabels(char *buf, unsigned int len, const struct nf_conntrack *ct)
+{
+	return __snprintf_connlabels(buf, len, ct, "labels=", " ");
+}
+
 int __snprintf_conntrack_default(char *buf, 
 				 unsigned int len,
 				 const struct nf_conntrack *ct,
@@ -426,6 +457,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Delete the last blank space */
 	size--;
 
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index ad53075..f373f5b 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -348,6 +348,12 @@ static int __snprintf_tuple_xml(char *buf,
 	return size;
 }
 
+static int
+__snprintf_clabels_xml(char *buf, unsigned int len, const struct nf_conntrack *ct)
+{
+	return __snprintf_connlabels(buf, len, ct, "<labels>", "</labels>");
+}
+
 int __snprintf_conntrack_xml(char *buf,
 			     unsigned int len,
 			     const struct nf_conntrack *ct,
@@ -390,6 +396,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
@@ -432,6 +439,11 @@ int __snprintf_conntrack_xml(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_CONNLABELS, ct->head.set)) {
+		ret = __snprintf_clabels_xml(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_SECMARK, ct->head.set)) {
 		ret = snprintf(buf+offset, len, 
 				"<secmark>%u</secmark>", ct->secmark);
@@ -510,6 +522,7 @@ int __snprintf_conntrack_xml(char *buf,
 	    test_bit(ATTR_USE, ct->head.set) ||
 	    test_bit(ATTR_STATUS, ct->head.set) ||
 	    test_bit(ATTR_ID, ct->head.set) ||
+	    test_bit(ATTR_CONNLABELS, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_START, ct->head.set) ||
 	    test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
 	    	ret = snprintf(buf+offset, len, "</meta>");
-- 
1.8.1.5

