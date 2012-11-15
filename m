From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] api: add nfct_bitmask object
Date: Thu, 15 Nov 2012 16:50:09 +0100
Message-ID: <1352994611-3707-2-git-send-email-fw@strlen.de>
References: <1352994611-3707-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41026 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993118Ab2KOPsT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:48:19 -0500
In-Reply-To: <1352994611-3707-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to use generic getter/setter API with upcoming
conntrack label extension, add  helper functions to set/test/unset
bits in a vector of arbitrary size.

Conntrack labels will then be encoded via nfct_bitmask object.

Original idea from Pablo Neira Ayuso.
---
 include/internal/bitops.h                          |    2 +
 include/internal/object.h                          |    8 ++
 .../libnetfilter_conntrack.h                       |   11 ++
 src/conntrack/api.c                                |   99 ++++++++++++++++++++
 4 files changed, 120 insertions(+), 0 deletions(-)

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
index 12f61d1..97e2dd7 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -273,6 +273,17 @@ enum {
 	NFCT_CB_STOLEN = 2,     /* like continue, but ct is not freed */
 };
 
+/* bitmask setter/getter */
+struct nfct_bitmask;
+
+struct nfct_bitmask *nfct_bitmask_new(unsigned int maxbit);
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
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 000571f..f1fcdc4 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1483,3 +1483,102 @@ void nfct_filter_dump_set_attr_u8(struct nfct_filter_dump *filter_dump,
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
+	b = malloc(sizeof(struct nfct_bitmask) + bytes);
+	if (b) {
+		memset(b->bits, 0, bytes);
+		b->words = words;
+	}
+	return b;
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

