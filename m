From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [libnetfilter_conntrack PATCH] conntrack: introduce clear and equal
 functions for bitmask object
Date: Sat, 8 Mar 2014 10:24:18 +0900
Message-ID: <20140308012416.GJ4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48490 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaCHBYk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:24:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id rq2so4864899pbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:24:40 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id sx8sm17279806pab.5.2014.03.07.17.24.36
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:24:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 This patch adds two functions, useful for ulogd IPFIX
output module.

---
 .../libnetfilter_conntrack.h                       |  2 ++
 src/conntrack/api.c                                | 31 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index d4542ba..a5e6a91 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -286,6 +286,8 @@ void nfct_bitmask_set_bit(struct nfct_bitmask *, unsigned int bit);
 int nfct_bitmask_test_bit(const struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_unset_bit(struct nfct_bitmask *, unsigned int bit);
 void nfct_bitmask_destroy(struct nfct_bitmask *);
+void nfct_bitmask_clear(struct nfct_bitmask *);
+int nfct_bitmask_equal(const struct nfct_bitmask *, const struct nfct_bitmask *);
 
 /* connlabel name <-> bit translation mapping */
 struct nfct_labelmap;
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 224be86..fc4c58f 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1704,6 +1704,37 @@ void nfct_bitmask_destroy(struct nfct_bitmask *b)
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
+ * If both bitmask object are equal, this function returns 1, otherwise
+ * -1 or 0 is returned.
+ */
+int nfct_bitmask_equal(const struct nfct_bitmask *b1, const struct nfct_bitmask *b2)
+{
+	if (b1->words != b2->words)
+		return -1;
+
+	if (!memcmp(b1->bits, b2->bits, b1->words * sizeof(b1->bits[0])))
+		return 1;
+	else
+		return 0;
+}
+
 /**
  * @}
  */
-- 
1.8.5.3

