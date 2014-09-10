From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-ct 1/2] add two new bitmask functions
Date: Wed, 10 Sep 2014 17:48:53 +0900
Message-ID: <20140910084853.GB23549@gmail.com>
References: <20140910084525.GA23549@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45382 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaIJItA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:49:00 -0400
Received: by mail-pa0-f43.google.com with SMTP id fa1so6633460pad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Sep 2014 01:48:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140910084525.GA23549@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds two functions, useful for ulogd IPFIX
output module.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 .../libnetfilter_conntrack.h                       |  3 +++
 src/conntrack/api.c                                | 29 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index d4542ba..d04a0c6 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -10,6 +10,7 @@
 #ifndef _LIBNETFILTER_CONNTRACK_H_
 #define _LIBNETFILTER_CONNTRACK_H_
 
+#include <stdbool.h>
 #include <netinet/in.h>
 #include <libnfnetlink/linux_nfnetlink.h>
 #include <libnfnetlink/libnfnetlink.h>
@@ -286,6 +287,8 @@ void nfct_bitmask_set_bit(struct nfct_bitmask *, unsigned int bit);
 int nfct_bitmask_test_bit(const struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_unset_bit(struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_destroy(struct nfct_bitmask *);
+void nfct_bitmask_clear(struct nfct_bitmask *);
+bool nfct_bitmask_equal(const struct nfct_bitmask *, const struct nfct_bitmask *);
 
 /* connlabel name <-> bit translation mapping */
 struct nfct_labelmap;
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 09270ee..073ea5c 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -8,6 +8,7 @@
  */
 
 #include <stdlib.h>
+#include <stdbool.h>
 #include <string.h> /* for memset */
 #include <errno.h>
 #include <assert.h>
@@ -1702,6 +1703,34 @@ void nfct_bitmask_destroy(struct nfct_bitmask *b)
 	free(b);
 }
 
+/*
+ * nfct_bitmask_clear - clear a bitmask object
+ *
+ * \param b pointer to the bitmask object to clear
+ */
+void nfct_bitmask_clear(struct nfct_bitmask *b)
+{
+	unsigned int bytes = b->words * sizeof(b->bits[0]);
+	memset(b->bits, 0, bytes);
+}
+
+/*
+ * nfct_bitmask_equal - compare two bitmask objects
+ *
+ * \param b1 pointer to a valid bitmask object
+ * \param b2 pointer to a valid bitmask object
+ *
+ * If both bitmask object are equal, this function returns true, otherwise
+ * false is returned.
+ */
+bool nfct_bitmask_equal(const struct nfct_bitmask *b1, const struct nfct_bitmask *b2)
+{
+	if (b1->words != b2->words)
+		return false;
+
+	return memcmp(b1->bits, b2->bits, b1->words * sizeof(b1->bits[0])) == 0;
+}
+
 /**
  * @}
  */
-- 
2.1.0
