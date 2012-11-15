From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3] api: add connlabel api and attribute
Date: Thu, 15 Nov 2012 16:50:10 +0100
Message-ID: <1352994611-3707-3-git-send-email-fw@strlen.de>
References: <1352994611-3707-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41027 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993447Ab2KOPsV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:48:21 -0500
In-Reply-To: <1352994611-3707-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

adds new labelmap api to create a name <-> bit mapping
from a text file (default: /etc/xtables/connlabel.conf).

nfct_labelmap_new(filename) is used to create the map,
nfct_labelmap_destroy() releases the resources allocated for the map.

Two functions are added to make map lookups:

nfct_labelmap_get_name(map, bit) returns the name of a bit,
nfct_labelmap_get_bit returns the bit associated with a name.

The connlabel attribute is represented by a nfct_bitmask object, the
nfct_bitmask api can be used to test/set/get individual bits
("labels").

The exisiting nfct_attr_get/set interfaces can be used to read or
replace the existing labels associated with a conntrack with a new set.
---
 include/internal/object.h                          |    4 +
 include/internal/prototypes.h                      |    9 +
 .../libnetfilter_conntrack.h                       |    9 +
 .../linux_nfnetlink_conntrack.h                    |    1 +
 src/conntrack/Makefile.am                          |    1 +
 src/conntrack/api.c                                |   65 ++++++
 src/conntrack/build_mnl.c                          |   12 +
 src/conntrack/getter.c                             |    6 +
 src/conntrack/labels.c                             |  239 ++++++++++++++++++++
 src/conntrack/parse.c                              |    1 +
 src/conntrack/parse_mnl.c                          |   25 ++
 src/conntrack/setter.c                             |   12 +
 12 files changed, 384 insertions(+), 0 deletions(-)
 create mode 100644 src/conntrack/labels.c

diff --git a/include/internal/object.h b/include/internal/object.h
index 609265d..bbb038a 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -189,6 +189,8 @@ struct nf_conntrack {
 
 	void *helper_info;
 	size_t helper_info_len;
+
+	struct nfct_bitmask *connlabels;
 };
 
 /*
@@ -305,4 +307,6 @@ struct nfct_bitmask {
 	uint32_t bits[];
 };
 
+struct nfct_labelmap;
+
 #endif
diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index eeeea24..484deea 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -54,4 +54,13 @@ int __snprintf_expect(char *buf, unsigned int len, const struct nf_expect *exp,
 int __snprintf_expect_default(char *buf, unsigned int len, const struct nf_expect *exp, unsigned int msg_type, unsigned int flags);
 int __snprintf_expect_xml(char *buf, unsigned int len, const struct nf_expect *exp, unsigned int msg_type, unsigned int flags);
 
+/*
+ * connlabel internal prototypes
+ */
+struct nfct_labelmap *__labelmap_new(const char *);
+void __labelmap_destroy(struct nfct_labelmap *);
+
+int __labelmap_get_bit(struct nfct_labelmap *map, const char *name);
+const char *__labelmap_get_name(struct nfct_labelmap *map, unsigned int bit);
+
 #endif
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 97e2dd7..e3b1f47 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -133,6 +133,7 @@ enum nf_conntrack_attr {
 	ATTR_TIMESTAMP_START,			/* u64 bits, linux >= 2.6.38 */
 	ATTR_TIMESTAMP_STOP = 64,		/* u64 bits, linux >= 2.6.38 */
 	ATTR_HELPER_INFO,			/* variable length */
+	ATTR_CONNLABELS,			/* variable length */
 	ATTR_MAX
 };
 
@@ -284,6 +285,14 @@ int nfct_bitmask_test_bit(const struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_unset_bit(struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_destroy(struct nfct_bitmask *);
 
+/* connlabel name <-> bit translation mapping */
+struct nfct_labelmap;
+
+struct nfct_labelmap *nfct_labelmap_new(const char *mapfile);
+void nfct_labelmap_destroy(struct nfct_labelmap *map);
+const char *nfct_labelmap_get_name(struct nfct_labelmap *m, unsigned int bit);
+int nfct_labelmap_get_bit(struct nfct_labelmap *m, const char *name);
+
 /* setter */
 extern void nfct_set_attr(struct nf_conntrack *ct,
 			  const enum nf_conntrack_attr type,
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 1e32c7f..fab40ae 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -51,6 +51,7 @@ enum ctattr_type {
 	CTA_SECCTX,
 	CTA_TIMESTAMP,
 	CTA_MARK_MASK,
+	CTA_LABELS,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index 01fed53..e1d8768 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -4,6 +4,7 @@ noinst_LTLIBRARIES = libnfconntrack.la
 
 libnfconntrack_la_SOURCES = api.c \
 			    getter.c setter.c \
+			    labels.c \
 			    parse.c build.c \
 			    parse_mnl.c build_mnl.c \
 			    snprintf.c \
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index f1fcdc4..6dd7675 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -95,6 +95,8 @@ void nfct_destroy(struct nf_conntrack *ct)
 		free(ct->secctx);
 	if (ct->helper_info)
 		free(ct->helper_info);
+	if (ct->connlabels)
+		nfct_bitmask_destroy(ct->connlabels);
 	free(ct);
 	ct = NULL; /* bugtrap */
 }
@@ -1485,6 +1487,69 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
  */
 
 /**
+ * \defgroup label Conntrack labels
+ *
+ * @{
+ */
+
+/**
+ * nfct_labelmap_get_name - get name of the label bit
+ *
+ * \param m label map obtained from nfct_label_open
+ * \param bit whose name should be returned
+ *
+ * returns a pointer to the name associated with the label.
+ * If no name has been configured, the empty string is returned.
+ * If bit is out of range, NULL is returned.
+ */
+const char *nfct_labelmap_get_name(struct nfct_labelmap *m, unsigned int bit)
+{
+	return __labelmap_get_name(m, bit);
+}
+
+/**
+ * nfct_labelmap_get_bit - get bit associated with the name
+ *
+ * \param h label handle obtained from nfct_labelmap_new
+ * \param name name of the label
+ *
+ * returns the bit associated with the name, or negative value on error.
+ */
+int nfct_labelmap_get_bit(struct nfct_labelmap *m, const char *name)
+{
+	return __labelmap_get_bit(m, name);
+}
+
+/**
+ * nfct_labelmap_new - create a new label map
+ *
+ * \param mapfile the file containing the bit <-> name mapping
+ *
+ * If mapfile is NULL, the default mapping file is used.
+ * returns a new label map, or NULL on error.
+ */
+struct nfct_labelmap *nfct_labelmap_new(const char *mapfile)
+{
+	return __labelmap_new(mapfile);
+}
+
+/**
+ * nfct_labelmap_destroy - destroy nfct_labelmap object
+ *
+ * \param map the label object to destroy.
+ *
+ * This function releases the memory that is used by the labelmap object.
+ */
+void nfct_labelmap_destroy(struct nfct_labelmap *map)
+{
+	__labelmap_destroy(map);
+}
+
+/**
+ * @}
+ */
+
+/*
  * \defgroup bitmask bitmask object
  *
  * @{
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index 46aec8a..a666e01 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -10,6 +10,7 @@
  */
 
 #include "internal/internal.h"
+#include <limits.h>
 #include <libmnl/libmnl.h>
 
 static int
@@ -379,6 +380,14 @@ nfct_build_zone(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	return 0;
 }
 
+static void
+nfct_build_labels(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
+{
+	struct nfct_bitmask *b = ct->connlabels;
+	unsigned int size = b->words * sizeof(b->bits[0]);
+	mnl_attr_put(nlh, CTA_LABELS, size, b->bits);
+}
+
 int
 nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 {
@@ -475,5 +484,8 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	if (test_bit(ATTR_ZONE, ct->head.set))
 		nfct_build_zone(nlh, ct);
 
+	if (test_bit(ATTR_CONNLABELS, ct->head.set))
+		nfct_build_labels(nlh, ct);
+
 	return 0;
 }
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index e7ab048..53c9e0e 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -339,6 +339,11 @@ static const void *get_attr_helper_info(const struct nf_conntrack *ct)
 	return ct->helper_info;
 }
 
+static const void *get_attr_connlabels(const struct nf_conntrack *ct)
+{
+	return ct->connlabels;
+}
+
 const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -406,4 +411,5 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_TIMESTAMP_START]		= get_attr_timestamp_start,
 	[ATTR_TIMESTAMP_STOP]		= get_attr_timestamp_stop,
 	[ATTR_HELPER_INFO]		= get_attr_helper_info,
+	[ATTR_CONNLABELS]		= get_attr_connlabels,
 };
diff --git a/src/conntrack/labels.c b/src/conntrack/labels.c
new file mode 100644
index 0000000..b64995f
--- /dev/null
+++ b/src/conntrack/labels.c
@@ -0,0 +1,239 @@
+#include <stdint.h>
+
+#include "internal/internal.h"
+
+#define MAX_BITS 1024
+
+#define CONNLABEL_CFG "/etc/xtables/connlabel.conf"
+#define HASH_SIZE 64
+
+struct labelmap_bucket {
+	char *name;
+	unsigned int bit;
+	struct labelmap_bucket *next;
+};
+
+struct nfct_labelmap {
+	struct labelmap_bucket *map_name[HASH_SIZE];
+	unsigned int namecount;
+	char **bit_to_name;
+};
+
+static struct labelmap_bucket* label_map_bucket_alloc(const char *n, unsigned int b)
+{
+	struct labelmap_bucket *bucket;
+	char *name = strdup(n);
+
+	if (!name)
+		return NULL;
+
+	bucket = malloc(sizeof(*bucket));
+	if (!bucket) {
+		free(name);
+		return NULL;
+	}
+	bucket->name = name;
+	bucket->bit = b;
+	return bucket;
+}
+
+static unsigned int hash_name(const char *name)
+{
+	unsigned int hash = 0;
+
+	while (*name) {
+		hash = (hash << 5) - hash + *name;
+		name++;
+	}
+	return hash & (HASH_SIZE - 1);
+}
+
+int __labelmap_get_bit(struct nfct_labelmap *m, const char *name)
+{
+	unsigned int i = hash_name(name);
+	struct labelmap_bucket *list = m->map_name[i];
+
+	while (list) {
+		if (strcmp(name, list->name) == 0)
+			return list->bit;
+		list = list->next;
+	}
+	return -1;
+}
+
+const char *__labelmap_get_name(struct nfct_labelmap *m, unsigned int bit)
+{
+	if (bit < m->namecount)
+		return m->bit_to_name[bit] ? m->bit_to_name[bit] : "";
+	return NULL;
+}
+
+static int map_insert(struct nfct_labelmap *m, const char *n, unsigned int b)
+{
+	unsigned int i = hash_name(n);
+	struct labelmap_bucket *list = m->map_name[i];
+
+	while (list) {
+		if (list->bit == b)
+			return -1;
+		list = list->next;
+	}
+
+	list = label_map_bucket_alloc(n, b);
+	if (!list)
+		return -1;
+
+	if (m->map_name[i])
+		list->next = m->map_name[i];
+	else
+		list->next = NULL;
+	m->map_name[i] = list;
+	return 0;
+}
+
+static int is_space_posix(int c)
+{
+	return c == ' ' || c == '\f' || c == '\r' || c == '\t' || c == '\v';
+}
+
+static char *trim_label(char *label)
+{
+	char *end;
+
+	while (is_space_posix(*label))
+		label++;
+	end = strchr(label, '\n');
+	if (end)
+		*end = 0;
+	else
+		end = strchr(label, '\0');
+	end--;
+
+	while (is_space_posix(*end) && end > label) {
+		*end = 0;
+		end--;
+	}
+
+	return *label ? label : NULL;
+}
+
+static int
+xtables_parse_connlabel_numerical(const char *s, char **end)
+{
+	unsigned long value;
+
+	value = strtoul(s, end, 0);
+	if (value == 0 && s == *end)
+		return -1;
+	if (value < 0 || value >= MAX_BITS)
+		return -1;
+	return value;
+}
+
+static void free_list(struct labelmap_bucket *b)
+{
+	if (b->next)
+		free_list(b->next);
+	free(b->name);
+	free(b);
+}
+
+void __labelmap_destroy(struct nfct_labelmap *map)
+{
+	unsigned int i;
+	struct labelmap_bucket *b;
+
+	for (i = 0; i < HASH_SIZE; i++) {
+		b = map->map_name[i];
+		if (b != NULL)
+			free_list(b);
+	}
+
+	free(map->bit_to_name);
+	free(map);
+}
+
+static void make_name_table(struct nfct_labelmap *m)
+{
+	struct labelmap_bucket *b;
+	unsigned int i;
+
+	for (i = 0; i < HASH_SIZE; i++) {
+		b = m->map_name[i];
+		while (b) {
+			m->bit_to_name[b->bit] = b->name;
+			b = b->next;
+		}
+	}
+}
+
+static struct nfct_labelmap *map_alloc(void)
+{
+	struct nfct_labelmap *map = malloc(sizeof(*map));
+	if (map) {
+		unsigned int i;
+		for (i = 0; i < HASH_SIZE; i++)
+			map->map_name[i] = NULL;
+	}
+	return map;
+}
+
+struct nfct_labelmap *__labelmap_new(const char *name)
+{
+	struct nfct_labelmap *map;
+	char label[1024];
+	char *end;
+	FILE *fp;
+	int added = 0;
+	unsigned int maxbit = 0;
+	uint32_t bits_seen[MAX_BITS/32];
+
+	fp = fopen(name ? name : CONNLABEL_CFG, "re");
+	if (!fp)
+		return NULL;
+
+	memset(bits_seen, 0, sizeof(bits_seen));
+
+	map = map_alloc();
+	if (!map) {
+		fclose(fp);
+		return NULL;
+	}
+
+	while (fgets(label, sizeof(label), fp)) {
+		int bit;
+
+		if (label[0] == '#')
+			continue;
+
+		bit = xtables_parse_connlabel_numerical(label, &end);
+		if (bit < 0 || test_bit(bit, bits_seen))
+			continue;
+
+		end = trim_label(end);
+		if (!end)
+			continue;
+		if (map_insert(map, end, bit) == 0) {
+			added++;
+			if (maxbit < bit)
+				maxbit = bit;
+			set_bit(bit, bits_seen);
+		}
+	}
+
+	fclose(fp);
+
+	if (added) {
+		map->namecount = maxbit + 1;
+		map->bit_to_name = calloc(sizeof(char *), map->namecount);
+		if (!map->bit_to_name)
+			goto err;
+		make_name_table(map);
+		return map;
+	}
+ err:
+	__labelmap_destroy(map);
+	return NULL;
+}
+
+
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index b9f9a99..6096e8d 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -8,6 +8,7 @@
  */
 
 #include "internal/internal.h"
+#include <libmnl/libmnl.h>
 
 static void __parse_ip(const struct nfattr *attr,
 		       struct __nfct_tuple *tuple,
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 93f6681..a4272f9 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -11,6 +11,7 @@
 
 #include "internal/internal.h"
 #include <libmnl/libmnl.h>
+#include <limits.h>
 #include <endian.h>
 
 static int
@@ -772,6 +773,25 @@ nfct_parse_timestamp(const struct nlattr *attr, struct nf_conntrack *ct)
 	return 0;
 }
 
+static int nfct_parse_labels(const struct nlattr *attr, struct nf_conntrack *ct)
+{
+	uint16_t len = mnl_attr_get_payload_len(attr);
+	struct nfct_bitmask *mask;
+	uint32_t *bits;
+
+	if (len == 0)
+		return 0;
+
+	mask = nfct_bitmask_new((len * CHAR_BIT) - 1);
+	if (!mask)
+		return -1;
+	bits = mnl_attr_get_payload(attr);
+	if (len)
+		memcpy(mask->bits, bits, len);
+	nfct_set_attr(ct, ATTR_CONNLABELS, mask);
+	return 0;
+}
+
 static int
 nfct_parse_conntrack_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -934,6 +954,11 @@ nfct_payload_parse(const void *payload, size_t payload_len,
 			return -1;
 	}
 
+	if (tb[CTA_LABELS]) {
+		if (nfct_parse_labels(tb[CTA_LABELS], ct) < 0)
+			return -1;
+	}
+
 	return 0;
 }
 
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index dbcd68e..8879f02 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -421,6 +421,17 @@ retry:
 }
 
 static void
+set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	if (ct->connlabels == value)
+		return;
+
+	if (ct->connlabels)
+		nfct_bitmask_destroy(ct->connlabels);
+	ct->connlabels = (void *) value;
+}
+
+static void
 set_attr_do_nothing(struct nf_conntrack *ct, const void *value, size_t len) {}
 
 const set_attr set_attr_array[ATTR_MAX] = {
@@ -490,4 +501,5 @@ const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_TIMESTAMP_START]	= set_attr_do_nothing,
 	[ATTR_TIMESTAMP_STOP]	= set_attr_do_nothing,
 	[ATTR_HELPER_INFO]	= set_attr_helper_info,
+	[ATTR_CONNLABELS]	= set_attr_connlabels,
 };
-- 
1.7.8.6

