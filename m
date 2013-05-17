From: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
Subject: [PATCH next v2] libnetfilter_conntrack: don't ignore ATTR_CONNLABELS
Date: Fri, 17 May 2013 09:38:26 +0200
Message-ID: <2544e4f5-3cdf-4e2a-99f9-722ce7f344f3@de-wie-exch3b.green.sophos>
References: <1368696643-6731-1-git-send-email-Afschin.Hormozdiary@sophos.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.sophos.com ([145.253.124.137]:51273 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab3EQHrr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 May 2013 03:47:47 -0400
Received: from mx1.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 440555B81A9
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2013 08:47:46 +0100 (BST)
Received: from de-wie-exch3b.green.sophos (de-wie-exch3b.green.sophos [10.60.70.62])
	by mx1.sophos.com (Postfix) with ESMTPS id 1BBB05B80FA
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2013 08:47:46 +0100 (BST)
In-Reply-To: <1368696643-6731-1-git-send-email-Afschin.Hormozdiary@sophos.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libnfnetlink based backend 'build.c' currently ignores
ATTR_CONNLABELS and ATTR_CONNLABELS_MASK.

The libmnl based backend 'build_mnl.c' instead handles
both attributes correct.

Add function to set CTA_LABELS and CTA_LABELS_MASK
if required.

Signed-off-by: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
---
 src/conntrack/build.c | 27 +++++++++++++++++++++++++++
 src/conntrack/parse.c | 25 +++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 2900027..4852536 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -398,6 +398,30 @@ static void __build_zone(struct nfnlhdr *req,
 	nfnl_addattr16(&req->nlh, size, CTA_ZONE, htons(ct->zone));
 }
 
+static void __build_labels(struct nfnlhdr *req,
+			   size_t size,
+			   const struct nf_conntrack *ct)
+{
+	struct nfct_bitmask *b = ct->connlabels;
+	unsigned int b_size = b->words * sizeof(b->bits[0]);
+
+	nfnl_addattr_l(&req->nlh,
+		       size,
+		       CTA_LABELS,
+		       b->bits,
+		       b_size);
+
+	if (test_bit(ATTR_CONNLABELS_MASK, ct->head.set)) {
+		b = ct->connlabels_mask;
+		if (b_size == (b->words * sizeof(b->bits[0])))
+			nfnl_addattr_l(&req->nlh,
+				       size,
+				       CTA_LABELS_MASK,
+				       b->bits,
+				       b_size);
+	}
+}
+
 int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		      struct nfnlhdr *req,
 		      size_t size,
@@ -500,5 +524,8 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	if (test_bit(ATTR_ZONE, ct->head.set))
 		__build_zone(req, size, ct);
 
+	if (test_bit(ATTR_CONNLABELS, ct->head.set))
+		__build_labels(req, size, ct);
+
 	return 0;
 }
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 6096e8d..5bbf4bd 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -8,6 +8,7 @@
  */
 
 #include "internal/internal.h"
+#include <limits.h>
 #include <libmnl/libmnl.h>
 
 static void __parse_ip(const struct nfattr *attr,
@@ -476,6 +477,26 @@ __parse_timestamp(const struct nfattr *attr, struct nf_conntrack *ct)
 	}
 }
 
+static void
+__parse_labels(const struct nfattr *attr, struct nf_conntrack *ct)
+{
+	struct nfattr *tb[CTA_LABELS];
+	struct nfct_bitmask *mask;
+	uint16_t len = NFA_PAYLOAD(tb[CTA_LABELS-1]);
+
+	nfnl_parse_nested(tb, CTA_LABELS, attr);
+	if (tb[CTA_LABELS-1]) {
+		mask = nfct_bitmask_new((len * CHAR_BIT) - 1);
+		if (!mask)
+			return;
+
+		if (len)
+			memcpy(mask->bits, NFA_DATA(tb[CTA_LABELS-1]), len);
+
+		set_bit(ATTR_CONNLABELS, ct->head.set);
+	}
+}
+
 void __parse_conntrack(const struct nlmsghdr *nlh,
 		       struct nfattr *cda[],
 		       struct nf_conntrack *ct)
@@ -564,4 +585,8 @@ void __parse_conntrack(const struct nlmsghdr *nlh,
 
 	if (cda[CTA_TIMESTAMP-1])
 		__parse_timestamp(cda[CTA_TIMESTAMP-1], ct);
+
+	if (cda[CTA_LABELS-1]) {
+		__parse_labels(cda[CTA_LABELS-1], ct);
+	}
 }
-- 
1.8.2.2

