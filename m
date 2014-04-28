From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [libnetfilter_conntrack PATCH 1/13] conntrack: introduce clear and
 equal functions for bitmask object
Date: Mon, 28 Apr 2014 20:42:50 +0900
Message-ID: <20140428114250.GB12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34391 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaD1Lm5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:42:57 -0400
Received: by mail-pd0-f174.google.com with SMTP id z10so4832387pdj.19
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:42:56 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id kl1sm34454019pbd.73.2014.04.28.04.42.54
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:42:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds two functions, useful for ulogd IPFIX
output module.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
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
index 09270ee..c601efc 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -1702,6 +1702,37 @@ void nfct_bitmask_destroy(struct nfct_bitmask *b)
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
+	   return -1;
+
+	if (!memcmp(b1->bits, b2->bits, b1->words * sizeof(b1->bits[0])))
+	   return 1;
+	   else
+		return 0;
+}
+
 /**
  * @}
  */
-- 
1.9.1

