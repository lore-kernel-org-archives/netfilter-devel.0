Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47948278E42
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718482; cv=none; b=e9rvicdvErKROqszeRrP7d1k6mcgDJRFEE9whRIY7STXgyU3y8aqIr2gJHtTSs4jpvkFewvkMCyC2JDL4+N76NWDvYwhPmkVCvQIDA+L/ata27KfiGpxYJFh/4Kr+aw66pPP9lFPjfFDNw/+/2Qov8BkhfSF0wrDxpy8Y/zgUx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718482; c=relaxed/simple;
	bh=m0nc4BsPKeO6fzCOo3xMJ9hk2iXRN2kDeSef+lCWMco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=buiQ5jyaDHZz82NYdULrFbKu+jBq9X8QEEINnuQTFYMEQL5xJFrrqgVYVCnrhX0kSaEfnmnLdtM5xV54dmkncQqPLBacvGqVQgZRms874jzWtGYkkSq7Agz6bGmg8sfrlokIQM+YspkhsfGV2v8PXBXq+9hKZAEA0EtAuN25PlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1uD3Gg-00056G-IV; Thu, 08 May 2025 17:34:38 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: add conntrack information to trace monitor mode
Date: Thu,  8 May 2025 17:33:56 +0200
Message-ID: <20250508153358.8015-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upcoming kernel change provides the packets conntrack state in the
trace message data.

This allows to see if packet is seen as original or reply, the conntrack
state (new, establieshed, related) and the status bits which show if e.g.
NAT was applied.  Alsoi include conntrack ID so users can use conntrack
tool to query the kernel for more information via ctnetlink.

This improves debugging when e.g. packets do not pick up the expected
NAT mapping, which could e.g. also happen because of expectations
following the NAT binding of the owning conntrack entry.

Example output ("conntrack: " lines are new):

trace id 32 t PRE_RAW packet: iif "enp0s3" ether saddr [..]
trace id 32 t PRE_RAW rule tcp flags syn meta nftrace set 1 (verdict continue)
trace id 32 t PRE_RAW policy accept
trace id 32 t PRE_MANGLE conntrack: ct direction original ct state new ct id 2641368242
trace id 32 t PRE_MANGLE packet: iif "enp0s3" ether saddr [..]
trace id 32 t ct_new_pre rule jump rpfilter (verdict jump rpfilter)
trace id 32 t PRE_MANGLE policy accept
trace id 32 t INPUT conntrack: ct direction original ct state new ct status dnat-done ct id 2641368242
trace id 32 t INPUT packet: iif "enp0s3" [..]
trace id 32 t public_in rule tcp dport 443 accept (verdict accept)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c      |   4 ++
 src/netlink.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/src/ct.c b/src/ct.c
index 71ebb9483893..fc43bf63f02c 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -98,7 +98,11 @@ static const struct symbol_table ct_status_tbl = {
 		SYMBOL("confirmed",	IPS_CONFIRMED),
 		SYMBOL("snat",		IPS_SRC_NAT),
 		SYMBOL("dnat",		IPS_DST_NAT),
+		SYMBOL("seq-adjust",	IPS_SEQ_ADJUST),
+		SYMBOL("snat-done",	IPS_SRC_NAT_DONE),
+		SYMBOL("dnat-done",	IPS_DST_NAT_DONE),
 		SYMBOL("dying",		IPS_DYING),
+		SYMBOL("fixed-timeout",	IPS_FIXED_TIMEOUT),
 		SYMBOL_LIST_END
 	},
 };
diff --git a/src/netlink.c b/src/netlink.c
index 86ca32144f02..b1d1dc7f4bd1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2116,6 +2116,114 @@ next:
 	}
 }
 
+static struct expr *trace_alloc_list(const struct datatype *dtype,
+				     enum byteorder byteorder,
+				     unsigned int len, const void *data)
+{
+	struct expr *list_expr;
+	unsigned int i;
+	mpz_t value;
+	uint32_t v;
+
+	if (len != sizeof(v))
+		return constant_expr_alloc(&netlink_location,
+					   dtype, byteorder,
+					   len * BITS_PER_BYTE, data);
+
+	list_expr = list_expr_alloc(&netlink_location);
+
+	mpz_init2(value, 32);
+	mpz_import_data(value, data, byteorder, len);
+	v = mpz_get_uint32(value);
+	if (v == 0) {
+		mpz_clear(value);
+		return NULL;
+	}
+
+	for (i = 0; i < 32; i++) {
+		uint32_t bitv = v & (1 << i);
+
+		if (bitv == 0)
+			continue;
+
+		compound_expr_add(list_expr,
+				  constant_expr_alloc(&netlink_location,
+						      dtype, byteorder,
+						      len * BITS_PER_BYTE,
+						      &bitv));
+	}
+
+	mpz_clear(value);
+	return list_expr;
+}
+
+static void trace_print_ct_expr(const struct nftnl_trace *nlt, unsigned int attr,
+				enum nft_ct_keys key, struct output_ctx *octx)
+{
+	struct expr *lhs, *rhs, *rel;
+	const void *data;
+	uint32_t len;
+
+	data = nftnl_trace_get_data(nlt, attr, &len);
+	lhs = ct_expr_alloc(&netlink_location, key, -1);
+
+	switch (key) {
+	case NFT_CT_STATUS:
+		rhs = trace_alloc_list(lhs->dtype, lhs->byteorder, len, data);
+		if (!rhs) {
+			expr_free(lhs);
+			return;
+		}
+		rel  = binop_expr_alloc(&netlink_location, OP_IMPLICIT, lhs, rhs);
+		break;
+	case NFT_CT_DIRECTION:
+	case NFT_CT_STATE:
+	case NFT_CT_ID:
+		/* fallthrough */
+	default:
+		rhs  = constant_expr_alloc(&netlink_location,
+					   lhs->dtype, lhs->byteorder,
+					   len * BITS_PER_BYTE, data);
+		rel  = relational_expr_alloc(&netlink_location, OP_IMPLICIT, lhs, rhs);
+		break;
+	}
+
+	expr_print(rel, octx);
+	nft_print(octx, " ");
+	expr_free(rel);
+}
+
+static void trace_print_ct(const struct nftnl_trace *nlt,
+			   struct output_ctx *octx)
+{
+	bool ct = nftnl_trace_is_set(nlt, NFTNL_TRACE_CT_STATE);
+
+	if (!ct)
+		return;
+
+	trace_print_hdr(nlt, octx);
+
+	nft_print(octx, "conntrack: ");
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CT_DIRECTION))
+		trace_print_ct_expr(nlt, NFTNL_TRACE_CT_DIRECTION,
+				    NFT_CT_DIRECTION, octx);
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CT_STATE))
+		trace_print_ct_expr(nlt, NFTNL_TRACE_CT_STATE,
+				    NFT_CT_STATE, octx);
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CT_STATUS))
+		trace_print_ct_expr(nlt, NFTNL_TRACE_CT_STATUS,
+				    NFT_CT_STATUS, octx);
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CT_ID))
+		trace_print_ct_expr(nlt, NFTNL_TRACE_CT_ID,
+				    NFT_CT_ID, octx);
+
+	nft_print(octx, "\n");
+}
+
 static void trace_print_packet(const struct nftnl_trace *nlt,
 			        struct output_ctx *octx)
 {
@@ -2127,6 +2235,8 @@ static void trace_print_packet(const struct nftnl_trace *nlt,
 	uint32_t nfproto;
 	struct stmt *stmt, *next;
 
+	trace_print_ct(nlt, octx);
+
 	trace_print_hdr(nlt, octx);
 
 	nft_print(octx, "packet: ");
-- 
2.49.0

