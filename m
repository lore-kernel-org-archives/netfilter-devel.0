From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v2 libnetfilter_conntrack] zero value handling of mark and
 zone
Date: Tue, 17 Jun 2014 21:04:06 +0900
Message-ID: <20140617120405.GA24712@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33711 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbaFQMEM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:04:12 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so5595462pac.5
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2014 05:04:12 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables comparison of 0 value with mark and zone since
both CTA_MARK and CTA_ZONE are not set in case of its value is 0.
These changes has been done in cmp_meta() and its own cmp function
as Florian pointed out.

This enables `conntrack -L --zone 0' to work expctedly too.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 src/conntrack/compare.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index f4a194a..384050e 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -291,7 +291,10 @@ cmp_mark(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->mark == ct2->mark);
+	return (flags & NFCT_CMP_MASK &&
+		!test_bit(ATTR_MARK, ct1->head.set)) ||
+		nfct_get_attr_u32(ct1, ATTR_MARK)
+		== nfct_get_attr_u32(ct2, ATTR_MARK);
 }
 
 static int 
@@ -357,7 +360,10 @@ cmp_zone(const struct nf_conntrack *ct1,
 	 const struct nf_conntrack *ct2,
 	 unsigned int flags)
 {
-	return (ct1->zone == ct2->zone);
+	return (flags & NFCT_CMP_MASK &&
+		!test_bit(ATTR_ZONE, ct1->head.set)) ||
+		nfct_get_attr_u16(ct1, ATTR_ZONE)
+		== nfct_get_attr_u16(ct2, ATTR_ZONE);
 }
 
 static int
@@ -421,7 +427,7 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 {
 	if (!__cmp(ATTR_ID, ct1, ct2, flags, cmp_id))
 		return 0;
-	if (!__cmp(ATTR_MARK, ct1, ct2, flags, cmp_mark))
+	if (!cmp_mark(ct1, ct2, flags))
 		return 0;
 	if (!__cmp(ATTR_TIMEOUT, ct1, ct2, flags, cmp_timeout))
 		return 0;
@@ -433,7 +439,7 @@ static int cmp_meta(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_DCCP_STATE, ct1, ct2, flags, cmp_dccp_state))
 		return 0;
-	if (!__cmp(ATTR_ZONE, ct1, ct2, flags, cmp_zone))
+	if (!cmp_zone(ct1, ct2, flags))
 		return 0;
 	if (!__cmp(ATTR_SECCTX, ct1, ct2, flags, cmp_secctx))
 		return 0;
-- 
1.9.1


