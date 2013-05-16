From: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
Subject: [PATCH next] libnetfilter_conntrack: don't ignore ATTR_CONNLABELS
Date: Thu, 16 May 2013 11:30:43 +0200
Message-ID: <a17383ac-860c-4a6f-baf1-a382ce895a5c@DE-WIE-EXCH3A.green.sophos>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Afschin Hormozdiary <Afschin.Hormozdiary@sophos.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:54747 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab3EPJiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 05:38:08 -0400
Received: from mx2.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 9BBE518810D
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2013 10:30:57 +0100 (BST)
Received: from de-wie-exch3a.green.sophos (de-wie-exch3a.green.sophos [10.60.70.61])
	by mx2.sophos.com (Postfix) with ESMTPS id 65CE818810A
	for <netfilter-devel@vger.kernel.org>; Thu, 16 May 2013 10:30:57 +0100 (BST)
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
 1 file changed, 27 insertions(+)

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
-- 
1.8.2.2

