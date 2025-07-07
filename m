Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7087B3E1
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 09:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751881661; cv=none; b=PLImgFD3pC4tFPZZOBq/enjcbEwl6f6fzEnYUe/d85tfgUbeYsRiuwQH65zCP6uObI5jT4mAJM4e0Yxv1yPNSk1sAeBQhQupQBjUoWRQy1DTql1L/khBwhvA9mbCe0OlXVbS4cn34iekUYATsVjDRMMeOHnbo21fpH7R6LK/6zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751881661; c=relaxed/simple;
	bh=bXfbqkNqjRID7aE+uxZKjpISq4Y5sy9DmhEDRulArJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2iqRxk43SxDw+fbJX8uee7ZBUG7MWrvqoyaIs5R11nO8PnPpQGlit86vsH0GNFJikS90kmdg9oPLcZQcqOOX4Dn/aP+AmKSyxNrrGyYiaOkYhlSInJ1v0E4QxFm/ZeKsIzinDkNsmXJHy92y15VKXr+4Zo78cbcmy/5fuS20c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 41158618B5; Mon,  7 Jul 2025 11:47:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] src: add conntrack information to trace monitor mode
Date: Mon,  7 Jul 2025 11:47:14 +0200
Message-ID: <20250707094722.2162-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250707094722.2162-1-fw@strlen.de>
References: <20250707094722.2162-1-fw@strlen.de>
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

v2: add more status bits: helper, clash, offload, hw-offload.
    add flag explanation to documentation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/data-types.txt                            |  31 ++---
 include/linux/netfilter/nf_conntrack_common.h |  16 +++
 src/ct.c                                      |   8 ++
 src/trace.c                                   | 109 ++++++++++++++++++
 4 files changed, 149 insertions(+), 15 deletions(-)

diff --git a/doc/data-types.txt b/doc/data-types.txt
index 46b0867cb5a4..d688350c4afd 100644
--- a/doc/data-types.txt
+++ b/doc/data-types.txt
@@ -378,21 +378,22 @@ For each of the types above, keywords are available for convenience:
 .conntrack status (ct_status)
 [options="header"]
 |==================
-|Keyword| Value
-|expected|
-1
-|seen-reply|
-2
-|assured|
-4
-|confirmed|
-8
-|snat|
-16
-|dnat|
-32
-|dying|
-512
+|Keyword| Value	| Description
+|expected|1| Expected connection; conntrack helper set it up
+|seen-reply|2| Conntrack has seen packets in both directions
+|assured| 4 |Conntrack entry will not be removed if hash table is full
+|confirmed | 8 | Initial packet processed
+|snat| 16 | Original source address differs from reply destination
+|dnat| 32 | Original destination differs from reply source
+|seq-adjust| 64 | tcp sequence number rewrite due to conntrack helper or synproxy
+|snat-done| 128 | tried to find matching snat/masquerade rule
+|dnat-done| 256 | tried to find matching dnat/redirect rule
+|dying| 512 | Connection about to be deleted
+|fixed-timeout | 1024 | entry expires even if traffic is active
+|clash  | 4096 | packet drop avoidance scheme
+|helper | 8192 | connection is monitored by conntrack helper
+|offload | 16384 | connection is offloaded to a flow table
+|hw-offload | 32768 | connection is offloaded to hardware
 |================
 
 .conntrack event bits (ct_event)
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 768ff251308b..22bbb6c92fb1 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -77,6 +77,22 @@ enum ip_conntrack_status {
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Conntrack is a fake untracked entry.  Obsolete and not used anymore */
+	IPS_UNTRACKED_BIT = 12,
+	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
+
+	/* Conntrack got a helper explicitly attached (ruleset, ctnetlink). */
+	IPS_HELPER_BIT = 13,
+	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Conntrack has been offloaded to flow table. */
+	IPS_OFFLOAD_BIT = 14,
+	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
+
+	/* Conntrack has been offloaded to hardware. */
+	IPS_HW_OFFLOAD_BIT = 15,
+	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
 };
 
 /* Connection tracking event types */
diff --git a/src/ct.c b/src/ct.c
index 71ebb9483893..7fa808800fcf 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -98,7 +98,15 @@ static const struct symbol_table ct_status_tbl = {
 		SYMBOL("confirmed",	IPS_CONFIRMED),
 		SYMBOL("snat",		IPS_SRC_NAT),
 		SYMBOL("dnat",		IPS_DST_NAT),
+		SYMBOL("seq-adjust",	IPS_SEQ_ADJUST),
+		SYMBOL("snat-done",	IPS_SRC_NAT_DONE),
+		SYMBOL("dnat-done",	IPS_DST_NAT_DONE),
 		SYMBOL("dying",		IPS_DYING),
+		SYMBOL("fixed-timeout",	IPS_FIXED_TIMEOUT),
+		SYMBOL("clash",		IPS_UNTRACKED_BIT),
+		SYMBOL("helper",	IPS_HELPER_BIT),
+		SYMBOL("offload",	IPS_OFFLOAD_BIT),
+		SYMBOL("hw-offload",	IPS_HW_OFFLOAD_BIT),
 		SYMBOL_LIST_END
 	},
 };
diff --git a/src/trace.c b/src/trace.c
index a7cc8ff08251..b270951025b8 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -237,6 +237,114 @@ next:
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
@@ -248,6 +356,7 @@ static void trace_print_packet(const struct nftnl_trace *nlt,
 	uint32_t nfproto;
 	struct stmt *stmt, *next;
 
+	trace_print_ct(nlt, octx);
 	trace_print_hdr(nlt, octx);
 
 	nft_print(octx, "packet: ");
-- 
2.49.0

