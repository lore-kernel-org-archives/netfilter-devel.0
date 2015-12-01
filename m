From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] src: fix sub-bytes protocol header definition
Date: Tue,  1 Dec 2015 18:44:27 +0100
Message-ID: <1448991867-21247-2-git-send-email-pablo@netfilter.org>
References: <1448991867-21247-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42068 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbbLARol (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2015 12:44:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E82126E406
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA107DA807
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1A0EDA85E
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2015 18:44:35 +0100 (CET)
In-Reply-To: <1448991867-21247-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update bitfield definitions to match according to the way they are
expressed in RFC and IEEE specifications.

This required to update a bit of update for c3f0501 ("src:
netlink_linearize: handle sub-byte lengths").

>From the linearize step, to calculate the shift based on the bitfield
offset, we need to obtain the length of the word in bytes:

	len = round_up(expr->len, BITS_PER_BYTE);

Then, we substract the offset bits and the bitfield length.

        shift = len - (offset + expr->len);

>From the delinearize, payload_expr_trim() needs to obtain the real
offset through:

	off = round_up(mask->len, BITS_PER_BYTE) -
		       mpz_fls(mask->value, mask->len);

For vlan id (offset 12), this gets the position of the last bit set in
the mask (ie. 12), then we substract the length we fetch in bytes (16),
so we obtain the real bitfield offset (4).

Then, we add that to the original payload offset that was expressed in
bytes:

	payload_offset += off;

Note that payload_expr_trim() now also adjusts the payload expression to
its real length and offset.

Reported-by: Patrick McHardy <kaber@trash.net>>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This aims to fix what we have, I'm willing to give another pass to this.

 include/gmputil.h         |  2 ++
 include/proto.h           |  4 ++--
 include/utils.h           |  1 +
 src/gmputil.c             | 16 ++++++++++++++++
 src/netlink_delinearize.c |  3 ---
 src/netlink_linearize.c   | 27 ++++++++++++++++-----------
 src/payload.c             |  8 +++++++-
 src/proto.c               | 17 +++++++++--------
 8 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/include/gmputil.h b/include/gmputil.h
index 1bf696a..84d7775 100644
--- a/include/gmputil.h
+++ b/include/gmputil.h
@@ -58,4 +58,6 @@ extern void mpz_import_data(mpz_t rop, const void *data,
 			    unsigned int len);
 extern void mpz_switch_byteorder(mpz_t rop, unsigned int len);
 
+unsigned long mpz_fls(mpz_t rop, unsigned int len);
+
 #endif /* NFTABLES_GMPUTIL_H */
diff --git a/include/proto.h b/include/proto.h
index 974116f..d90bccd 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -159,9 +159,9 @@ enum eth_hdr_fields {
 
 enum vlan_hdr_fields {
 	VLANHDR_INVALID,
-	VLANHDR_VID,
-	VLANHDR_CFI,
 	VLANHDR_PCP,
+	VLANHDR_CFI,
+	VLANHDR_VID,
 	VLANHDR_TYPE,
 };
 
diff --git a/include/utils.h b/include/utils.h
index e94ae81..8a1dc5e 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -69,6 +69,7 @@
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))
+#define round_up(n, b)		(div_round_up(n, b) * b)
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/src/gmputil.c b/src/gmputil.c
index c763792..3934c8f 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -14,6 +14,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <string.h>
+#include <limits.h>
 
 #include <nftables.h>
 #include <datatype.h>
@@ -146,6 +147,21 @@ void mpz_switch_byteorder(mpz_t rop, unsigned int len)
 	mpz_import_data(rop, data, BYTEORDER_HOST_ENDIAN, len);
 }
 
+unsigned long mpz_fls(mpz_t rop, unsigned int len)
+{
+	unsigned long n = 0, last = ULONG_MAX;
+
+	while (len--) {
+		n = mpz_scan1(rop, n);
+		if (n == ULONG_MAX)
+			break;
+
+		n++;
+		last = n;
+	}
+	return last;
+}
+
 #ifndef HAVE_LIBGMP
 /* mini-gmp doesn't have a gmp_printf so we use our own minimal
  * variant here which is able to format a single mpz_t.
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3e1f912..e6e870f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1229,9 +1229,6 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx, struct expr *e
 				value->len = mask->len;
 			}
 
-			payload->len = mask->len;
-			payload->payload.offset += mpz_scan1(mask->value, 0);
-
 			payload_match_postprocess(ctx, expr, payload, mask);
 
 			assert(expr->left->ops->type == EXPR_BINOP);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0790dce..9e65c9e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -109,21 +109,21 @@ static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
 {
 	struct nft_data_linearize nld, zero = {};
 	struct nftnl_expr *nle;
-	unsigned int offset, len, masklen;
+	unsigned int shift, len, masklen, offset;
 	mpz_t mask;
 
 	offset = expr->payload.offset % BITS_PER_BYTE;
-	masklen = expr->len + offset;
+	len = round_up(expr->len, BITS_PER_BYTE);
+	shift = len - (offset + expr->len);
 
-	if (masklen > 128)
-		BUG("expr mask length is %u (len %u, offset %u)\n",
-				masklen, expr->len, offset);
+	if (!shift && expr->payload.offset % BITS_PER_BYTE == 0)
+		return;
 
+	masklen = expr->len + shift;
+	assert(masklen <= NFT_REG_SIZE * BITS_PER_BYTE);
 	mpz_init2(mask, masklen);
 	mpz_bitmask(mask, expr->len);
-
-	if (offset)
-		mpz_lshift_ui(mask, offset);
+	mpz_lshift_ui(mask, shift);
 
 	nle = alloc_nft_expr("bitwise");
 
@@ -158,8 +158,7 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 
-	if (expr->len % BITS_PER_BYTE)
-		netlink_gen_payload_mask(ctx, expr, dreg);
+	netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
 static void netlink_gen_exthdr(struct netlink_linearize_ctx *ctx,
@@ -283,11 +282,17 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 static void payload_shift_value(const struct expr *left, struct expr *right)
 {
+	unsigned int shift, offset, len;
+
 	if (right->ops->type != EXPR_VALUE ||
 	    left->ops->type != EXPR_PAYLOAD)
 		return;
 
-	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
+	offset = left->payload.offset % BITS_PER_BYTE;
+	len = round_up(left->len, BITS_PER_BYTE);
+	shift = len - (offset + left->len);
+	if (shift)
+		mpz_lshift_ui(right->value, shift);
 }
 
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
diff --git a/src/payload.c b/src/payload.c
index a97041e..761a06d 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -345,7 +345,7 @@ static unsigned int mask_length(const struct expr *mask)
 bool payload_expr_trim(struct expr *expr, struct expr *mask,
 		       const struct proto_ctx *ctx)
 {
-	unsigned int payload_offset = expr->payload.offset + mask_to_offset(mask);
+	unsigned int payload_offset = expr->payload.offset, off;
 	unsigned int mask_len = mask_length(mask);
 	const struct proto_hdr_template *tmpl;
 	unsigned int payload_len = expr->len;
@@ -365,6 +365,10 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 		payload_offset -= ctx->protocol[expr->payload.base].offset;
 	}
 
+	off = round_up(mask->len, BITS_PER_BYTE) -
+	      mpz_fls(mask->value, mask->len);
+	payload_offset += off;
+
 	for (i = 1; i < array_size(desc->templates); i++) {
 		tmpl = &desc->templates[i];
 		if (tmpl->offset != payload_offset)
@@ -381,6 +385,8 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 
 		if (matched_len == mask_len) {
 			assert(mask->len >= mask_len);
+			expr->len = mask_len;
+			expr->payload.offset += off;
 			mask->len = mask_len;
 			return true;
 		}
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..1b63232 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -407,9 +407,9 @@ const struct proto_desc proto_tcp = {
 		[TCPHDR_SEQ]		= TCPHDR_FIELD("sequence", seq),
 		[TCPHDR_ACKSEQ]		= TCPHDR_FIELD("ackseq", ack_seq),
 		[TCPHDR_DOFF]		= HDR_BITFIELD("doff", &integer_type,
-						       (12 * BITS_PER_BYTE) + 4, 4),
+						       (12 * BITS_PER_BYTE), 4),
 		[TCPHDR_RESERVED]	= HDR_BITFIELD("reserved", &integer_type,
-						       (12 * BITS_PER_BYTE) + 0, 4),
+						       (12 * BITS_PER_BYTE) + 4, 4),
 		[TCPHDR_FLAGS]		= HDR_BITFIELD("flags", &tcp_flag_type,
 						       13 * BITS_PER_BYTE,
 						       BITS_PER_BYTE),
@@ -459,7 +459,8 @@ const struct proto_desc proto_dccp = {
 	.templates	= {
 		[DCCPHDR_SPORT]		= INET_SERVICE("sport", struct dccp_hdr, dccph_sport),
 		[DCCPHDR_DPORT]		= INET_SERVICE("dport", struct dccp_hdr, dccph_dport),
-		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type, 67, 4),
+		[DCCPHDR_TYPE]		= HDR_BITFIELD("type", &dccp_pkttype_type,
+						       4 * BITS_PER_BYTE, 4),
 	},
 };
 
@@ -508,8 +509,8 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
 	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),
@@ -730,9 +731,9 @@ const struct proto_desc proto_vlan = {
 
 	},
 	.templates	= {
-		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 0, 12),
-		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 12, 1),
-		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 13, 3),
+		[VLANHDR_PCP]		= VLANHDR_BITFIELD("pcp", 0, 3),
+		[VLANHDR_CFI]		= VLANHDR_BITFIELD("cfi", 3, 1),
+		[VLANHDR_VID]		= VLANHDR_BITFIELD("id", 4, 12),
 		[VLANHDR_TYPE]		= VLANHDR_TYPE("type", &ethertype_type, vlan_type),
 	},
 };
-- 
2.1.4

