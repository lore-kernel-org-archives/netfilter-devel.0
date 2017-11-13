From: eric.sesterhenn@x41-dsec.de
Subject: [PATCH 2/2] Extend nf_h323_error_boundary to work on bits as well
Date: Mon, 13 Nov 2017 09:09:41 +0100
Message-ID: <20171113080941.616-2-eric.sesterhenn@x41-dsec.de>
References: <20171113080941.616-1-eric.sesterhenn@x41-dsec.de>
Cc: netfilter-devel@vger.kernel.org
To: eric.sesterhenn@x41-dsec.de, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:35834 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbdKMIKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 03:10:03 -0500
In-Reply-To: <20171113080941.616-1-eric.sesterhenn@x41-dsec.de>
In-Reply-To: <20171106151313.GA21034@salvia>
References: <20171106151313.GA21034@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>

This patches several out of bounds memory reads by extending
the nf_h323_error_boundary() function to work on bits as well
an check the affected parts.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 92 +++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index f358222b1e5e..b8b4fecaa016 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -165,8 +165,13 @@ static unsigned int get_len(bitstr_t *bs)
 }
 
 /****************************************************************************/
-static int nf_h323_error_boundary(bitstr_t *bs, size_t bytes)
+static int nf_h323_error_boundary(bitstr_t *bs, size_t bytes, size_t bits)
 {
+	bits += bs->bit;
+	bytes += bits / 8;
+	if (bits % 8 > 0)
+		bytes++;
+
 	if(*bs->cur + bytes > *bs->end)
 		return 1;
 	return 0;
@@ -286,8 +291,7 @@ static int decode_bool(bitstr_t *bs, const struct field_t *f,
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
 	INC_BIT(bs);
-
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -301,12 +305,12 @@ static int decode_oid(bitstr_t *bs, const struct field_t *f,
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
 	BYTE_ALIGN(bs);
-	if (nf_h323_error_boundary(bs, 1))
+	if (nf_h323_error_boundary(bs, 1, 0))
 		return H323_ERROR_BOUND;
 
 	len = *bs->cur++;
 	bs->cur += len;
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 
 	return H323_ERROR_NONE;
@@ -330,6 +334,8 @@ static int decode_int(bitstr_t *bs, const struct field_t *f,
 		bs->cur += 2;
 		break;
 	case CONS:		/* 64K < Range < 4G */
+		if (nf_h323_error_boundary(bs, 0, 2))
+			return H323_ERROR_BOUND;
 		len = get_bits(bs, 2) + 1;
 		BYTE_ALIGN(bs);
 		if (base && (f->attr & DECODE)) {	/* timeToLive */
@@ -341,7 +347,7 @@ static int decode_int(bitstr_t *bs, const struct field_t *f,
 		break;
 	case UNCO:
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs);
 		bs->cur += len;
@@ -353,7 +359,7 @@ static int decode_int(bitstr_t *bs, const struct field_t *f,
 
 	PRINT("\n");
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -370,7 +376,7 @@ static int decode_enum(bitstr_t *bs, const struct field_t *f,
 		INC_BITS(bs, f->sz);
 	}
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -389,13 +395,13 @@ static int decode_bitstr(bitstr_t *bs, const struct field_t *f,
 		len = f->lb;
 		break;
 	case WORD:		/* 2-byte length */
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = (*bs->cur++) << 8;
 		len += (*bs->cur++) + f->lb;
 		break;
 	case SEMI:
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs);
 		break;
@@ -407,7 +413,7 @@ static int decode_bitstr(bitstr_t *bs, const struct field_t *f,
 	bs->cur += len >> 3;
 	bs->bit = len & 7;
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -421,12 +427,14 @@ static int decode_numstr(bitstr_t *bs, const struct field_t *f,
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
 
 	/* 2 <= Range <= 255 */
+	if (nf_h323_error_boundary(bs, 0, f->sz))
+		return H323_ERROR_BOUND;
 	len = get_bits(bs, f->sz) + f->lb;
 
 	BYTE_ALIGN(bs);
 	INC_BITS(bs, (len << 2));
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -458,17 +466,19 @@ static int decode_octstr(bitstr_t *bs, const struct field_t *f,
 		break;
 	case BYTE:		/* Range == 256 */
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 1))
+		if (nf_h323_error_boundary(bs, 1, 0))
 			return H323_ERROR_BOUND;
 		len = (*bs->cur++) + f->lb;
 		break;
 	case SEMI:
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs) + f->lb;
 		break;
 	default:		/* 2 <= Range <= 255 */
+		if (nf_h323_error_boundary(bs, 0, f->sz))
+			return H323_ERROR_BOUND;
 		len = get_bits(bs, f->sz) + f->lb;
 		BYTE_ALIGN(bs);
 		break;
@@ -478,7 +488,7 @@ static int decode_octstr(bitstr_t *bs, const struct field_t *f,
 
 	PRINT("\n");
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -494,11 +504,13 @@ static int decode_bmpstr(bitstr_t *bs, const struct field_t *f,
 	switch (f->sz) {
 	case BYTE:		/* Range == 256 */
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 1))
+		if (nf_h323_error_boundary(bs, 1, 0))
 			return H323_ERROR_BOUND;
 		len = (*bs->cur++) + f->lb;
 		break;
 	default:		/* 2 <= Range <= 255 */
+		if (nf_h323_error_boundary(bs, 0, f->sz))
+			return H323_ERROR_BOUND;
 		len = get_bits(bs, f->sz) + f->lb;
 		BYTE_ALIGN(bs);
 		break;
@@ -506,7 +518,7 @@ static int decode_bmpstr(bitstr_t *bs, const struct field_t *f,
 
 	bs->cur += len << 1;
 
-	if (nf_h323_error_boundary(bs, 0))
+	if (nf_h323_error_boundary(bs, 0, 0))
 		return H323_ERROR_BOUND;
 	return H323_ERROR_NONE;
 }
@@ -526,9 +538,13 @@ static int decode_seq(bitstr_t *bs, const struct field_t *f,
 	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
 
 	/* Extensible? */
+	if (nf_h323_error_boundary(bs, 0, 1))
+		return H323_ERROR_BOUND;
 	ext = (f->attr & EXT) ? get_bit(bs) : 0;
 
 	/* Get fields bitmap */
+	if (nf_h323_error_boundary(bs, 0, f->sz))
+		return H323_ERROR_BOUND;
 	bmp = get_bitmap(bs, f->sz);
 	if (base)
 		*(unsigned int *)base = bmp;
@@ -548,10 +564,10 @@ static int decode_seq(bitstr_t *bs, const struct field_t *f,
 
 		/* Decode */
 		if (son->attr & OPEN) {	/* Open field */
-			if (nf_h323_error_boundary(bs, 2))
+			if (nf_h323_error_boundary(bs, 2, 0))
 				return H323_ERROR_BOUND;
 			len = get_len(bs);
-			if (nf_h323_error_boundary(bs, len))
+			if (nf_h323_error_boundary(bs, len, 0))
 				return H323_ERROR_BOUND;
 			if (!base || !(son->attr & DECODE)) {
 				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
@@ -580,8 +596,10 @@ static int decode_seq(bitstr_t *bs, const struct field_t *f,
 		return H323_ERROR_NONE;
 
 	/* Get the extension bitmap */
+	if (nf_h323_error_boundary(bs, 0, 7))
+		return H323_ERROR_BOUND;
 	bmp2_len = get_bits(bs, 7) + 1;
-	if (nf_h323_error_boundary(bs, (bmp2_len + 7) >> 3))
+	if (nf_h323_error_boundary(bs, 0, bmp2_len))
 		return H323_ERROR_BOUND;
 	bmp2 = get_bitmap(bs, bmp2_len);
 	bmp |= bmp2 >> f->sz;
@@ -593,10 +611,10 @@ static int decode_seq(bitstr_t *bs, const struct field_t *f,
 	for (opt = 0; opt < bmp2_len; opt++, i++, son++) {
 		/* Check Range */
 		if (i >= f->ub) {	/* Newer Version? */
-			if (nf_h323_error_boundary(bs, 2))
+			if (nf_h323_error_boundary(bs, 2, 0))
 				return H323_ERROR_BOUND;
 			len = get_len(bs);
-			if (nf_h323_error_boundary(bs, len))
+			if (nf_h323_error_boundary(bs, len, 0))
 				return H323_ERROR_BOUND;
 			bs->cur += len;
 			continue;
@@ -611,10 +629,10 @@ static int decode_seq(bitstr_t *bs, const struct field_t *f,
 		if (!((0x80000000 >> opt) & bmp2))	/* Not present */
 			continue;
 
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs);
-		if (nf_h323_error_boundary(bs, len))
+		if (nf_h323_error_boundary(bs, len, 0))
 			return H323_ERROR_BOUND;
 		if (!base || !(son->attr & DECODE)) {
 			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
@@ -653,13 +671,13 @@ static int decode_seqof(bitstr_t *bs, const struct field_t *f,
 	switch (f->sz) {
 	case BYTE:
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 1))
+		if (nf_h323_error_boundary(bs, 1, 0))
 			return H323_ERROR_BOUND;
 		count = *bs->cur++;
 		break;
 	case WORD:
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		count = *bs->cur++;
 		count <<= 8;
@@ -667,11 +685,13 @@ static int decode_seqof(bitstr_t *bs, const struct field_t *f,
 		break;
 	case SEMI:
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, 2))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		count = get_len(bs);
 		break;
 	default:
+		if (nf_h323_error_boundary(bs, 0, f->sz))
+			return H323_ERROR_BOUND;
 		count = get_bits(bs, f->sz);
 		break;
 	}
@@ -691,8 +711,10 @@ static int decode_seqof(bitstr_t *bs, const struct field_t *f,
 	for (i = 0; i < count; i++) {
 		if (son->attr & OPEN) {
 			BYTE_ALIGN(bs);
+			if (nf_h323_error_boundary(bs, 2, 0))
+				return H323_ERROR_BOUND;
 			len = get_len(bs);
-			if (nf_h323_error_boundary(bs, len))
+			if (nf_h323_error_boundary(bs, len, 0))
 				return H323_ERROR_BOUND;
 			if (!base || !(son->attr & DECODE)) {
 				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
@@ -744,11 +766,17 @@ static int decode_choice(bitstr_t *bs, const struct field_t *f,
 	base = (base && (f->attr & DECODE)) ? base + f->offset : NULL;
 
 	/* Decode the choice index number */
+	if (nf_h323_error_boundary(bs, 0, 1))
+		return H323_ERROR_BOUND;
 	if ((f->attr & EXT) && get_bit(bs)) {
 		ext = 1;
+		if (nf_h323_error_boundary(bs, 0, 7))
+			return H323_ERROR_BOUND;
 		type = get_bits(bs, 7) + f->lb;
 	} else {
 		ext = 0;
+		if (nf_h323_error_boundary(bs, 0, f->sz))
+			return H323_ERROR_BOUND;
 		type = get_bits(bs, f->sz);
 		if (type >= f->lb)
 			return H323_ERROR_RANGE;
@@ -761,8 +789,10 @@ static int decode_choice(bitstr_t *bs, const struct field_t *f,
 	/* Check Range */
 	if (type >= f->ub) {	/* Newer version? */
 		BYTE_ALIGN(bs);
+		if (nf_h323_error_boundary(bs, 2, 0))
+			return H323_ERROR_BOUND;
 		len = get_len(bs);
-		if (nf_h323_error_boundary(bs, len))
+		if (nf_h323_error_boundary(bs, len, 0))
 			return H323_ERROR_BOUND;
 		bs->cur += len;
 		return H323_ERROR_NONE;
@@ -777,8 +807,10 @@ static int decode_choice(bitstr_t *bs, const struct field_t *f,
 
 	if (ext || (son->attr & OPEN)) {
 		BYTE_ALIGN(bs);
+		if (nf_h323_error_boundary(bs, len, 0))
+			return H323_ERROR_BOUND;
 		len = get_len(bs);
-		if (nf_h323_error_boundary(bs, len))
+		if (nf_h323_error_boundary(bs, len, 0))
 			return H323_ERROR_BOUND;
 		if (!base || !(son->attr & DECODE)) {
 			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
-- 
2.11.0

