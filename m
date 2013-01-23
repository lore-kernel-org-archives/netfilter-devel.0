From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] api: add nfct_bitmask object
Date: Wed, 23 Jan 2013 23:38:18 +0100
Message-ID: <1358980701-3747-2-git-send-email-fw@strlen.de>
References: <1358980701-3747-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34226 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab3AWWms (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:42:48 -0500
In-Reply-To: <1358980701-3747-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to use generic getter/setter API with upcoming
conntrack label extension, add helper functions to set/test/unset
bits in a vector of arbitrary size.

Conntrack labels will then be encoded via nfct_bitmask object.

Original idea from Pablo Neira Ayuso.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/internal/bitops.h                          |    2 +
 include/internal/object.h                          |    8 ++
 .../libnetfilter_conntrack.h                       |   12 ++
 qa/test_api.c                                      |   54 +++++++++
 src/conntrack/api.c                                |  119 ++++++++++++++++++++
 5 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/include/internal/bitops.h b/include/internal/bitops.h
index 7ae566b..aefff0e 100644
--- a/include/internal/bitops.h
+++ b/include/internal/bitops.h
@@ -73,4 +73,6 @@ test_bitmask_u32_or(const uint32_t *buf1, const uint32_t *buf2, int len)
 	return 0;
 }
 
+#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+
 #endif
diff --git a/include/internal/object.h b/include/internal/object.h
index 443e800..609265d 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -297,4 +297,12 @@ struct nf_expect {
 	u_int32_t 		set[1];
 };
 
+/*
+ * bitmask object
+ */
+struct nfct_bitmask {
+	unsigned int words;
+	uint32_t bits[];
+};
+
 #endif
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 12f61d1..90290b8 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -273,6 +273,18 @@ enum {
 	NFCT_CB_STOLEN = 2,     /* like continue, but ct is not freed */
 };
 
+/* bitmask setter/getter */
+struct nfct_bitmask;
+
+struct nfct_bitmask *nfct_bitmask_new(unsigned int maxbit);
+struct nfct_bitmask *nfct_bitmask_clone(const struct nfct_bitmask *);
+unsigned int nfct_bitmask_maxbit(const struct nfct_bitmask *);
+
+void nfct_bitmask_set_bit(struct nfct_bitmask *, unsigned int bit);
+int nfct_bitmask_test_bit(const struct nfct_bitmask *, unsigned int bit);
+void nfct_bitmask_unset_bit(struct nfct_bitmask *, unsigned int bit);
+void nfct_bitmask_destroy(struct nfct_bitmask *);
+
 /* setter */
 extern void nfct_set_attr(struct nf_conntrack *ct,
 			  const enum nf_conntrack_attr type,
diff --git a/qa/test_api.c b/qa/test_api.c
index cdd128a..37bc140 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -8,6 +8,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/wait.h>
+#include <time.h>
 #include <errno.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -31,6 +32,54 @@ static void eval_sigterm(int status)
 	}
 }
 
+static void test_nfct_bitmask(void)
+{
+	struct nfct_bitmask *a, *b;
+	unsigned short int maxb, i;
+
+	maxb = rand() & 0xffff;
+
+	a = nfct_bitmask_new(maxb);
+
+	assert(!nfct_bitmask_test_bit(a, maxb + 32));
+	nfct_bitmask_set_bit(a, maxb + 32);
+	assert(!nfct_bitmask_test_bit(a, maxb + 32));
+
+	for (i = 0; i <= maxb; i++)
+		assert(!nfct_bitmask_test_bit(a, i));
+
+	for (i = 0; i <= maxb; i++) {
+		if (rand() & 1) {
+			assert(!nfct_bitmask_test_bit(a, i));
+			continue;
+		}
+		nfct_bitmask_set_bit(a, i);
+		assert(nfct_bitmask_test_bit(a, i));
+	}
+
+	b = nfct_bitmask_clone(a);
+	assert(b);
+
+	for (i = 0; i <= maxb; i++) {
+		if (nfct_bitmask_test_bit(a, i))
+			assert(nfct_bitmask_test_bit(b, i));
+		else
+			assert(!nfct_bitmask_test_bit(b, i));
+	}
+
+	nfct_bitmask_destroy(a);
+
+	for (i = 0; i <= maxb; i++) {
+		if (rand() & 1)
+			continue;
+		nfct_bitmask_unset_bit(b, i);
+		assert(!nfct_bitmask_test_bit(b, i));
+	}
+
+	nfct_bitmask_destroy(b);
+}
+
+
 int main(void)
 {
 	int ret, i;
@@ -40,6 +89,8 @@ int main(void)
 	const char *val;
 	int status;
 
+	srand(time(NULL));
+
 	/* initialize fake data for testing purposes */
 	for (i=0; i<sizeof(data); i++)
 		data[i] = 0x01;
@@ -281,5 +332,8 @@ int main(void)
 	nfct_destroy(tmp);
 	nfexp_destroy(exp);
 	nfexp_destroy(tmp_exp);
+
+	test_nfct_bitmask();
+
 	return EXIT_SUCCESS;
 }
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 0bc2091..7b79e05 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1483,3 +1483,122 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
 /**
  * @}
  */
+
+/**
+ * \defgroup bitmask bitmask object
+ *
+ * @{
+ */
+
+/**
+ * nfct_bitmask_new - allocate a new bitmask
+ *
+ * \param max highest valid bit that can be set/unset.
+ *
+ * In case of success, this function returns a valid pointer to a memory blob,
+ * otherwise NULL is returned and errno is set appropiately.
+ */
+struct nfct_bitmask *nfct_bitmask_new(unsigned int max)
+{
+	struct nfct_bitmask *b;
+	unsigned int bytes, words;
+
+	if (max > 0xffff)
+		return NULL;
+
+	words = DIV_ROUND_UP(max+1, 32);
+	bytes = words * sizeof(b->bits[0]);
+
+	b = malloc(sizeof(*b) + bytes);
+	if (b) {
+		memset(b->bits, 0, bytes);
+		b->words = words;
+	}
+	return b;
+}
+
+/*
+ * nfct_bitmask_clone - duplicate a bitmask object
+ *
+ * \param b pointer to the bitmask object to duplicate
+ *
+ * returns an identical copy of the bitmask.
+ */
+struct nfct_bitmask *nfct_bitmask_clone(const struct nfct_bitmask *b)
+{
+	unsigned int bytes = b->words * sizeof(b->bits[0]);
+	struct nfct_bitmask *copy;
+
+	bytes += sizeof(*b);
+
+	copy = malloc(bytes);
+	if (copy)
+		memcpy(copy, b, bytes);
+	return copy;
+}
+
+/*
+ * nfct_bitmask_set_bit - set bit in the bitmask
+ *
+ * \param b pointer to the bitmask object
+ * \param bit the bit to set
+ */
+void nfct_bitmask_set_bit(struct nfct_bitmask *b, unsigned int bit)
+{
+	unsigned int bits = b->words * 32;
+	if (bit < bits)
+		set_bit(bit, b->bits);
+}
+
+/*
+ * nfct_bitmask_test_bit - test if a bit in the bitmask is set
+ *
+ * \param b pointer to the bitmask object
+ * \param bit the bit to test
+ *
+ * returns 0 if the bit is not set.
+ */
+int nfct_bitmask_test_bit(const struct nfct_bitmask *b, unsigned int bit)
+{
+	unsigned int bits = b->words * 32;
+	return bit < bits && test_bit(bit, b->bits);
+}
+
+/*
+ * nfct_bitmask_unset_bit - unset bit in the bitmask
+ *
+ * \param b pointer to the bitmask object
+ * \param bit the bit to clear
+ */
+void nfct_bitmask_unset_bit(struct nfct_bitmask *b, unsigned int bit)
+{
+	unsigned int bits = b->words * 32;
+	if (bit < bits)
+		unset_bit(bit, b->bits);
+}
+
+/*
+ * nfct_bitmask_maxbit - return highest bit that may be set/unset
+ *
+ * \param b pointer to the bitmask object
+ */
+unsigned int nfct_bitmask_maxbit(const struct nfct_bitmask *b)
+{
+	return (b->words * 32) - 1;
+}
+
+/*
+ * nfct_bitmask_destroy - destroy bitmask object
+ *
+ * \param b pointer to the bitmask object
+ *
+ * This function releases the memory that is used by the bitmask object.
+ */
+void nfct_bitmask_destroy(struct nfct_bitmask *b)
+{
+	free(b);
+}
+
+/**
+ * @}
+ */
-- 
1.7.8.6

