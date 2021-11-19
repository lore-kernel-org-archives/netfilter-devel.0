Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD94C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F4E61548
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Nov 2021 15:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhKSPc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Nov 2021 10:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhKSPc1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Nov 2021 10:32:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343ECC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2021 07:29:26 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mo5pM-0005Sc-PV; Fri, 19 Nov 2021 16:29:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 7/8] exthdr: fix tcpopt_find_template to use length after mask adjustment
Date:   Fri, 19 Nov 2021 16:28:46 +0100
Message-Id: <20211119152847.18118-8-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unify bitop handling for ipv6 extension header, ip option and tcp option
processing.

Pass the real offset and length expected, not the one used in the
kernel.

mptcp subtype would pass 8 bits as length rather than 4 bits.

This makes nft show 'tcp option mptcp subtype 1' instead of
'tcp option mptcp unknown & 240 == 16'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/tcpopt.h |  4 ++--
 src/exthdr.c     | 46 ++++++++++++++++++++++------------------------
 src/tcpopt.c     |  7 +++----
 3 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/include/tcpopt.h b/include/tcpopt.h
index bb5c1329018e..3a0b8424a990 100644
--- a/include/tcpopt.h
+++ b/include/tcpopt.h
@@ -12,8 +12,8 @@ extern void tcpopt_init_raw(struct expr *expr, uint8_t type,
 			    unsigned int offset, unsigned int len,
 			    uint32_t flags);
 
-extern bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
-				 unsigned int *shift);
+extern bool tcpopt_find_template(struct expr *expr, unsigned int offset,
+				 unsigned int len);
 
 /* TCP option numbers used on wire */
 enum tcpopt_kind {
diff --git a/src/exthdr.c b/src/exthdr.c
index 22a08b0c9c2b..d2ae0f948f5e 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -348,16 +348,7 @@ static unsigned int mask_length(const struct expr *mask)
 bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned int *shift)
 {
 	unsigned int off, mask_offset, mask_len;
-
-	if (expr->exthdr.op != NFT_EXTHDR_OP_IPV4 &&
-	    expr->exthdr.tmpl != &exthdr_unknown_template)
-		return false;
-
-	/* In case we are handling tcp options instead of the default ipv6
-	 * extension headers.
-	 */
-	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT)
-		return tcpopt_find_template(expr, mask, shift);
+	bool found;
 
 	mask_offset = mpz_scan1(mask->value, 0);
 	mask_len = mask_length(mask);
@@ -366,24 +357,31 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 	off += round_up(mask->len, BITS_PER_BYTE) - mask_len;
 
 	/* Handle ip options after the offset and mask have been calculated. */
-	if (expr->exthdr.op == NFT_EXTHDR_OP_IPV4) {
-		if (ipopt_find_template(expr, off, mask_len - mask_offset)) {
-			*shift = mask_offset;
-			return true;
-		} else {
+	switch (expr->exthdr.op) {
+	case NFT_EXTHDR_OP_IPV4:
+		found = ipopt_find_template(expr, off, mask_len - mask_offset);
+		break;
+	case NFT_EXTHDR_OP_TCPOPT:
+		found = tcpopt_find_template(expr, off, mask_len - mask_offset);
+		break;
+	case NFT_EXTHDR_OP_IPV6:
+		exthdr_init_raw(expr, expr->exthdr.desc->type,
+				off, mask_len - mask_offset, expr->exthdr.op, 0);
+
+		/* still failed to find a template... Bug. */
+		if (expr->exthdr.tmpl == &exthdr_unknown_template)
 			return false;
-		}
+		found = true;
+		break;
+	default:
+		found = false;
+		break;
 	}
 
-	exthdr_init_raw(expr, expr->exthdr.desc->type,
-			off, mask_len - mask_offset, expr->exthdr.op, 0);
-
-	/* still failed to find a template... Bug. */
-	if (expr->exthdr.tmpl == &exthdr_unknown_template)
-		return false;
+	if (found)
+		*shift = mask_offset;
 
-	*shift = mask_offset;
-	return true;
+	return found;
 }
 
 #define HDR_TEMPLATE(__name, __dtype, __type, __member)			\
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 641daa7359a3..c3e07d7889ab 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -225,6 +225,7 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int off,
 	expr->exthdr.flags = flags;
 	expr->exthdr.offset = off;
 	expr->exthdr.op = NFT_EXTHDR_OP_TCPOPT;
+	expr->exthdr.tmpl = &tcpopt_unknown_template;
 
 	if (flags & NFT_EXTHDR_F_PRESENT)
 		datatype_set(expr, &boolean_type);
@@ -252,14 +253,12 @@ void tcpopt_init_raw(struct expr *expr, uint8_t type, unsigned int off,
 	}
 }
 
-bool tcpopt_find_template(struct expr *expr, const struct expr *mask,
-			  unsigned int *shift)
+bool tcpopt_find_template(struct expr *expr, unsigned int offset, unsigned int len)
 {
 	if (expr->exthdr.tmpl != &tcpopt_unknown_template)
 		return false;
 
-	tcpopt_init_raw(expr, expr->exthdr.desc->type, expr->exthdr.offset,
-			expr->len, 0);
+	tcpopt_init_raw(expr, expr->exthdr.desc->type, offset, len, 0);
 
 	if (expr->exthdr.tmpl == &tcpopt_unknown_template)
 		return false;
-- 
2.32.0

