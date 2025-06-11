Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F8323A58E
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2025 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749679229; cv=none; b=AZwC7mJM17rMwRAWwn9BN5TVmf2trP1iua7onEghqdn5+cOLmnjK00g6hnH1IQWD+gJZ7DaCqeUNZ8T4GD6goD3HB9z7Ray76ESIMlIyceLvtUSYdbTryQx24JOLdZNo6zVthW8gWHAfOLL3Yr1xzMQMdTRm2mif4UIGrOM00b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749679229; c=relaxed/simple;
	bh=6B4n+lJC1EQujE84uMAagHvtU3Pu6kRU9Olys8N/2+w=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=pn5ErlbtHlGL62/DvpdYLnOEHD2AH8xGycwkzgHtrUHlcgoEidfunK+ohOYWVtGMkOp9iFSZKPqK2LpovHjV/Z2aTxVkoQvlhrfggu1BHMM347I0/kkHYcMmKeh7I9wZ1ltO1Tnbi4JMRoHu6ZCPRfKssJ50Ad3228EWiTeHxoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kQVeiitL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PDMvF2AZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kQVeiitL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PDMvF2AZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 01B6E60696; Thu, 12 Jun 2025 00:00:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749679217;
	bh=VVBmSe8h9t0kLvczEgc7R72KQRILbHCDKDLI99WvJcg=;
	h=From:To:Subject:Date:From;
	b=kQVeiitL5FsFXuJ3DZz/wLzdr8kcVTMi2gpsQe9fyG6wLkYbDGUbJEuZ8IEqIQr7W
	 ldZ59rFxghD5aLBv6msmWGxCmmfuAeIKBsv8Fp8N7jqhe4gVgsUua+YBq1/5kgPaDL
	 /TYfUQLGN0fqNHh2uaRydGqntc0zRo7wRmnJX1lVdEdLQU7Mo511/j5bDoYHHIOjye
	 GLod4e/ZPgmEeTM6r/G+uqwtYIpfzcyEJp4yS5sdbrRMIoQ6uU6eesMRyw/JIRKBRV
	 rlAyHhn89dnlqiMMYHgfoczNgsRDCs2uK4pigNBHgqZV1Zc0YjA7eyw02dOQMraOnm
	 4KNCdDdpU7F6A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6DC1460694
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 00:00:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749679216;
	bh=VVBmSe8h9t0kLvczEgc7R72KQRILbHCDKDLI99WvJcg=;
	h=From:To:Subject:Date:From;
	b=PDMvF2AZLo4KoXkxvMCuzbEM2UEr+Ef/XdXzh6vdGNXiZT8iIz3EiOUh/uJW1WIe1
	 4aCJ/j0x7fOpkXhogEKOnppvhI+p1LJhpxH5r97S8/pQZ9KDOHx68gNZ1IZNSnp1nT
	 gefYSprtUZPAyE1TABZbEOEanCNZpU7Nql0jIO2lwkqLMLs/rhpYgu0CsAnkp5vhf0
	 NVPv3Ntv4jx3Mh9KcbYDHUzAANfncfkTLdpag7q+AK0OCKA/VbIWooSzVnRjnFpcTP
	 f/u5oBI6kVK21TLg5P6IMzIIVAW7QC9PRJ4JoNXqCoRuycvhy7LrJl6+Xbg43h+eTl
	 9w7xa6epi8BXQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: use constant range expression for interval+concatenation sets
Date: Thu, 12 Jun 2025 00:00:12 +0200
Message-Id: <20250611220012.1301735-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand 347039f64509 ("src: add symbol range expression to further
compact intervals") to use constant range expression for elements with
concatenation of intervals.

Ruleset with 100k elements of this type:

 table inet x {
        set y {
                typeof ip saddr . tcp dport
                flags interval
                elements = {
			0.1.2.0-0.1.2.240 . 0-1,
			...
		}
	}
 }

This reduces memory consumption by 35.23%.

Before: 123.80 Mbytes
After:   80.19 Mbytes

This patch keeps the workaround 2fbade3cd990 ("netlink: bogus
concatenated set ranges with netlink message overrun") in place.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Follow up to continue in this direction, to further reduce memory
consumption.

 src/evaluate.c |  1 -
 src/netlink.c  | 11 +++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 9c7f23cb080e..56be7e90db15 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2368,7 +2368,6 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 
 	/* concatenation and maps need more work to use constant_range_expr. */
 	if (ctx->set && !set_is_map(ctx->set->flags) &&
-	    set_is_non_concat_range(ctx->set) &&
 	    left->etype == EXPR_VALUE &&
 	    right->etype == EXPR_VALUE) {
 		constant_range = constant_range_expr_alloc(&expr->location,
diff --git a/src/netlink.c b/src/netlink.c
index bed816af3123..97a2dc90a040 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -285,6 +285,17 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			byteorder_switch_expr_value(value, expr);
 
 		i = expr;
+		break;
+	case EXPR_RANGE_VALUE:
+		if (flags & EXPR_F_INTERVAL_END)
+			mpz_init_set(value, i->range.high);
+		else
+			mpz_init_set(value, i->range.low);
+
+		if (expr_basetype(i)->type == TYPE_INTEGER &&
+		    i->byteorder == BYTEORDER_HOST_ENDIAN)
+			byteorder_switch_expr_value(value, i);
+
 		break;
 	case EXPR_PREFIX:
 		if (flags & EXPR_F_INTERVAL_END) {
-- 
2.30.2

