From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] conntrack: nfct_cmp: also compare labels
Date: Wed,  5 Jun 2013 22:30:42 +0200
Message-ID: <1370464243-8130-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab3FEUcA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:32:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As nfct_cmp fails if the ctmark is different, it should compare labels, too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
YET another missing bit of the connlabel patchset.
Followup patch extends qa/test_api to check for these
kinds of errors.

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index 97c25cb..f4a194a 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -370,6 +370,51 @@ cmp_secctx(const struct nf_conntrack *ct1,
 	return strcmp(ct1->secctx, ct2->secctx) == 0;
 }
 
+static int __cmp_clabel(const struct nfct_bitmask *a,
+			const struct nfct_bitmask *b)
+{
+	unsigned int len, max;
+	const uint32_t *bits;
+
+	if (a == NULL || b == NULL)
+		return a == b;
+
+	if (a->words < b->words) {
+		bits = b->bits;
+		max = b->words;
+		len = a->words;
+	} else {
+		bits = a->bits;
+		max = a->words;
+		len = b->words;
+	}
+
+	while (max > len) {
+		if (bits[--max])
+			return 0;
+	}
+	/* bitmask sizes are equal or extra bits are not set */
+	return memcmp(a->bits, b->bits, len * sizeof(a->bits[0])) == 0;
+}
+
+static int cmp_clabel(const struct nf_conntrack *ct1,
+		      const struct nf_conntrack *ct2,
+		      unsigned int flags)
+{
+	return __cmp_clabel(nfct_get_attr(ct1, ATTR_CONNLABELS),
+			    nfct_get_attr(ct2, ATTR_CONNLABELS));
+
+}
+
+static int cmp_clabel_mask(const struct nf_conntrack *ct1,
+		      const struct nf_conntrack *ct2,
+		      unsigned int flags)
+{
+	return __cmp_clabel(nfct_get_attr(ct1, ATTR_CONNLABELS_MASK),
+			    nfct_get_attr(ct2, ATTR_CONNLABELS_MASK));
+
+}
+
 static int cmp_meta(const struct nf_conntrack *ct1,
 		    const struct nf_conntrack *ct2,
 		    unsigned int flags)
@@ -392,6 +437,10 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx))
 		return 0;
+	if (!__cmp(ATTR_CONNLABELS, ct1, ct2, flags, cmp_clabel))
+		return 0;
+	if (!__cmp(ATTR_CONNLABELS_MASK, ct1, ct2, flags, cmp_clabel_mask))
+		return 0;
 
 	return 1;
 }
-- 
1.8.1.5

