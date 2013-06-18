From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] conntrack: snprintf: add connlabel format specifier
Date: Tue, 18 Jun 2013 22:54:22 +0200
Message-ID: <1371588862-3407-2-git-send-email-fw@strlen.de>
References: <1371588862-3407-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57873 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932235Ab3FRU4C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:56:02 -0400
In-Reply-To: <1371588862-3407-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

by default, nfct_snprintf will not resolve connlabel names, as they're
system specific. This adds a fmt attribute to resolve names accordingly.

output looks like this:
... mark=0 use=1 labels=eth0-in (0),eth1-in (1)
or
<labels>
<label name="eth0-in" bit="0"/>
<label name="eth1-in" bit="1"/>
</labels>

Major stupidity:
As names can be anything, we need to be careful, especially when
creating XML output. Only alphanumerical label names are printed at
this time.

Else you get
labels=(0), .. or <labels><label name="" bit="0"/> in xml output.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I am interested in feedback wrt.

 a) the chosen xml representation
 b) wheter it makes sense to limit valid charactes in the label
    names this way (e.g., should we care? should be disallow that
    in iptables as well, etc).
 c) if this patch makes sense in the first place, e.g, can't use
     alternate mapping file for labels with nfct_snprintf

 include/internal/internal.h                        |  1 +
 include/internal/prototypes.h                      |  1 +
 .../libnetfilter_conntrack.h                       |  3 +
 src/conntrack/snprintf_default.c                   | 84 +++++++++++++++++++++-
 src/conntrack/snprintf_xml.c                       |  8 ++-
 5 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/include/internal/internal.h b/include/internal/internal.h
index aaf6bd4..a5c7923 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -6,6 +6,7 @@
 #ifndef __LIBNETFILTER_CONNTRACK_INTERNAL__
 #define __LIBNETFILTER_CONNTRACK_INTERNAL__
 
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index cc8de1d..577270b 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -16,6 +16,7 @@ int __snprintf_proto(char *buf, unsigned int len, const struct __nfct_tuple *tup
 int __snprintf_conntrack_default(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
 int __snprintf_conntrack_xml(char *buf, unsigned int len, const struct nf_conntrack *ct, const unsigned int msg_type, const unsigned int flags);
 int __snprintf_connlabels(char *buf, unsigned int len, const struct nf_conntrack *ct, const char *prefix, const char *end);
+int __snprintf_connlabels_names(char *buf, unsigned int len, const struct nf_conntrack *ct, const char *prefix, const char *end, bool xml);
 
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
index a1edef4..7befbd7 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -313,9 +313,89 @@ __snprintf_connlabels(char *buf, unsigned int len,
 	return size;
 }
 
+/*
+ * Labels can have any name, there are no restrictions.
+ * We will only print alpha numerical ones; else parsers
+ * could choke when putinng "&>" and friends into output
+ * (especially when using XML format).  ASCII machines only.
+ */
+static bool label_is_sane(const char *label)
+{
+	for (;*label; label++) {
+		if (*label >= 'a' && *label <= 'z')
+			continue;
+		if (*label >= 'A' && *label <= 'Z')
+			continue;
+		if (*label >= '0' && *label <= '9')
+			continue;
+		if (*label == ' ' || *label == '-')
+			continue;
+		return false;
+	}
+	return true;
+}
+
+int
+__snprintf_connlabels_names(char *buf, unsigned int len,
+			    const struct nf_conntrack *ct,
+			    const char *prefix, const char *end, bool xml)
+{
+	const struct nfct_bitmask *b = nfct_get_attr(ct, ATTR_CONNLABELS);
+	unsigned int i, max;
+	int ret, size = 0, offset = 0;
+	struct nfct_labelmap *map;
+
+	if (!b)
+		return 0;
+	map = nfct_labelmap_new(NULL);
+	if (!map)
+		return __snprintf_connlabels(buf, len, ct, prefix, end);
+
+	ret = snprintf(buf, len, "%s", prefix);
+	BUFFER_SIZE(ret, size, len, offset);
+	max = nfct_bitmask_maxbit(b);
+	for (i = 0; i <= max && len; i++) {
+		const char *name;
+		if (!nfct_bitmask_test_bit(b, i))
+			continue;
+		name = nfct_labelmap_get_name(map, i);
+		if (!name || !label_is_sane(name))
+			name = "";
+
+		if (xml)
+			ret = snprintf(buf + offset, len, "<label name=\"%s\" ", name);
+		else if (strcmp(name, "") != 0)
+			ret = snprintf(buf + offset, len, "%s ", name);
+		else
+			ret = 0;
+		BUFFER_SIZE(ret, size, len, offset);
+
+		if (xml)
+			ret = snprintf(buf + offset, len, "bit=\"%u\"/>", i);
+		else
+			ret = snprintf(buf + offset, len, "(%u),", i);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	nfct_labelmap_destroy(map);
+	if (offset && end) {
+		if (!xml) {
+			offset--; /* remove last , */
+			size--;
+		}
+		ret = snprintf(buf + offset, len, "%s", end);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+	return size;
+}
+
 static int
-__snprintf_clabels(char *buf, unsigned int len, const struct nf_conntrack *ct)
+__snprintf_clabels(char *buf, unsigned int len,
+		   const struct nf_conntrack *ct, bool names)
 {
+	if (names)
+		return  __snprintf_connlabels_names(buf, len, ct,
+					   "labels=", " ", false);
 	return __snprintf_connlabels(buf, len, ct, "labels=", " ");
 }
 
@@ -458,7 +538,7 @@ int __snprintf_conntrack_default(char *buf,
 	}
 
 	if (test_bit(ATTR_CONNLABELS, ct->head.set)) {
-		ret = __snprintf_clabels(buf+offset, len, ct);
+		ret = __snprintf_clabels(buf+offset, len, ct, flags & NFCT_OF_CONNLABELS );
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index f373f5b..1c2440a 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -349,8 +349,12 @@ static int __snprintf_tuple_xml(char *buf,
 }
 
 static int
-__snprintf_clabels_xml(char *buf, unsigned int len, const struct nf_conntrack *ct)
+__snprintf_clabels_xml(char *buf, unsigned int len,
+		       const struct nf_conntrack *ct, bool names)
 {
+	if (names)
+		return __snprintf_connlabels_names(buf, len, ct,
+				"<labels>", "</labels>", true);
 	return __snprintf_connlabels(buf, len, ct, "<labels>", "</labels>");
 }
 
@@ -440,7 +444,7 @@ int __snprintf_conntrack_xml(char *buf,
 	}
 
 	if (test_bit(ATTR_CONNLABELS, ct->head.set)) {
-		ret = __snprintf_clabels_xml(buf+offset, len, ct);
+		ret = __snprintf_clabels_xml(buf+offset, len, ct, flags & NFCT_OF_CONNLABELS);
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
-- 
1.8.1.5

