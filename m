Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44060C10F00
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E026620684
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dnCcjHTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCGQxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:53:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgCGQxE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 11:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583599982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCVrqv7KSII5YDJkzPhTG6fgCeVzSH+U2MqE78EwczQ=;
        b=dnCcjHTjgpYBKdql5hwLpPRkAP71dSdx3OBxGjy+z00JAwQeYtiXZuSnILdHRcPfd+X0bk
        1F/asaE2AxHTa7G3LLfkG007aus4Qd9ccWwN8L0/dF/jdPH3V/AaiPbYuO/ejfekFEJiqE
        4IDnjks3uKa9IT2Bl50TSBL2JhcesYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-DogD1vxhMeKjwW4VFI7g1w-1; Sat, 07 Mar 2020 11:53:00 -0500
X-MC-Unique: DogD1vxhMeKjwW4VFI7g1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 153598017DF;
        Sat,  7 Mar 2020 16:52:59 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76B596E3EE;
        Sat,  7 Mar 2020 16:52:57 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 4/6] nft_set_pipapo: Prepare for vectorised implementation: helpers
Date:   Sat,  7 Mar 2020 17:52:35 +0100
Message-Id: <1504c6ae1560247924b1afbf472d241c60880c24.1583598508.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583598508.git.sbrivio@redhat.com>
References: <cover.1583598508.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move most macros and helpers to a header file, so that they can be
conveniently used by related implementations.

No functional changes are intended here.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: Rebase, no significant changes

 net/netfilter/nft_set_pipapo.c | 269 +-------------------------------
 net/netfilter/nft_set_pipapo.h | 277 +++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+), 261 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index ef6866fe90a1..141e0ab26d3c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -330,188 +330,20 @@
=20
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <uapi/linux/netfilter/nf_tables.h>
-#include <net/ipv6.h>			/* For the maximum length of a field */
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
=20
-/* Count of concatenated fields depends on count of 32-bit nftables regi=
sters */
-#define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
-
-/* Largest supported field size */
-#define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
-#define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
-
-/* Bits to be grouped together in table buckets depending on set size */
-#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
-#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
-#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
-#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
-	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET !=3D 8) ||		\
-		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET !=3D 4))
-#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
-
-/* If a lookup table gets bigger than NFT_PIPAPO_LT_SIZE_HIGH, switch to=
 the
- * small group width, and switch to the big group width if the table get=
s
- * smaller than NFT_PIPAPO_LT_SIZE_LOW.
- *
- * Picking 2MiB as threshold (for a single table) avoids as much as poss=
ible
- * crossing page boundaries on most architectures (x86-64 and MIPS huge =
pages,
- * ARMv7 supersections, POWER "large" pages, SPARC Level 1 regions, etc.=
), which
- * keeps performance nice in case kvmalloc() gives us non-contiguous are=
as.
- */
-#define NFT_PIPAPO_LT_SIZE_THRESHOLD	(1 << 21)
-#define NFT_PIPAPO_LT_SIZE_HYSTERESIS	(1 << 16)
-#define NFT_PIPAPO_LT_SIZE_HIGH		NFT_PIPAPO_LT_SIZE_THRESHOLD
-#define NFT_PIPAPO_LT_SIZE_LOW		NFT_PIPAPO_LT_SIZE_THRESHOLD -	\
-					NFT_PIPAPO_LT_SIZE_HYSTERESIS
-
-/* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
-	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(f)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
-					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
-
-/* Number of buckets given by 2 ^ n, with n bucket bits */
-#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
-
-/* Each n-bit range maps to up to n * 2 rules */
-#define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
-
-/* Use the rest of mapping table buckets for rule indices, but it makes =
no sense
- * to exceed 32 bits
- */
-#if BITS_PER_LONG =3D=3D 64
-#define NFT_PIPAPO_MAP_TOBITS		32
-#else
-#define NFT_PIPAPO_MAP_TOBITS		(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
-#endif
-
-/* ...which gives us the highest allowed index for a rule */
-#define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
-					- (1UL << NFT_PIPAPO_MAP_NBITS))
-
-/* Definitions for vectorised implementations */
-#ifdef NFT_PIPAPO_ALIGN
-#define NFT_PIPAPO_ALIGN_HEADROOM					\
-	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
-#define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
-#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
-	do {								\
-		(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);		\
-		(field)->lt =3D (x);					\
-	} while (0)
-#else
-#define NFT_PIPAPO_ALIGN_HEADROOM	0
-#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
-#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt =3D (x))
-#endif /* NFT_PIPAPO_ALIGN */
-
-#define nft_pipapo_for_each_field(field, index, match)		\
-	for ((field) =3D (match)->f, (index) =3D 0;			\
-	     (index) < (match)->field_count;			\
-	     (index)++, (field)++)
-
-/**
- * union nft_pipapo_map_bucket - Bucket of mapping table
- * @to:		First rule number (in next field) this rule maps to
- * @n:		Number of rules (in next field) this rule maps to
- * @e:		If there's no next field, pointer to element this rule maps to
- */
-union nft_pipapo_map_bucket {
-	struct {
-#if BITS_PER_LONG =3D=3D 64
-		static_assert(NFT_PIPAPO_MAP_TOBITS <=3D 32);
-		u32 to;
-
-		static_assert(NFT_PIPAPO_MAP_NBITS <=3D 32);
-		u32 n;
-#else
-		unsigned long to:NFT_PIPAPO_MAP_TOBITS;
-		unsigned long  n:NFT_PIPAPO_MAP_NBITS;
-#endif
-	};
-	struct nft_pipapo_elem *e;
-};
-
-/**
- * struct nft_pipapo_field - Lookup, mapping tables and related data for=
 a field
- * @groups:	Amount of bit groups
- * @rules:	Number of inserted rules
- * @bsize:	Size of each bucket in lookup table, in longs
- * @bb:		Number of bits grouped together in lookup table buckets
- * @lt:		Lookup table: 'groups' rows of buckets
- * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
- * @mt:		Mapping table: one bucket per rule
- */
-struct nft_pipapo_field {
-	int groups;
-	unsigned long rules;
-	size_t bsize;
-	int bb;
-#ifdef NFT_PIPAPO_ALIGN
-	unsigned long *lt_aligned;
-#endif
-	unsigned long *lt;
-	union nft_pipapo_map_bucket *mt;
-};
-
-/**
- * struct nft_pipapo_match - Data used for lookup and matching
- * @field_count		Amount of fields in set
- * @scratch:		Preallocated per-CPU maps for partial matching results
- * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
- * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
- * @rcu			Matching data is swapped on commits
- * @f:			Fields, with lookup and mapping tables
- */
-struct nft_pipapo_match {
-	int field_count;
-#ifdef NFT_PIPAPO_ALIGN
-	unsigned long * __percpu *scratch_aligned;
-#endif
-	unsigned long * __percpu *scratch;
-	size_t bsize_max;
-	struct rcu_head rcu;
-	struct nft_pipapo_field f[];
-};
+#include "nft_set_pipapo.h"
=20
 /* Current working bitmap index, toggled between field matches */
 static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
=20
-/**
- * struct nft_pipapo - Representation of a set
- * @match:	Currently in-use matching data
- * @clone:	Copy where pending insertions and deletions are kept
- * @width:	Total bytes to be matched for one packet, including padding
- * @dirty:	Working copy has pending insertions or deletions
- * @last_gc:	Timestamp of last garbage collection run, jiffies
- */
-struct nft_pipapo {
-	struct nft_pipapo_match __rcu *match;
-	struct nft_pipapo_match *clone;
-	int width;
-	bool dirty;
-	unsigned long last_gc;
-};
-
-struct nft_pipapo_elem;
-
-/**
- * struct nft_pipapo_elem - API-facing representation of single set elem=
ent
- * @ext:	nftables API extensions
- */
-struct nft_pipapo_elem {
-	struct nft_set_ext ext;
-};
-
 /**
  * pipapo_refill() - For each set bit, set bits from selected mapping ta=
ble item
  * @map:	Bitmap to be scanned for set bits
@@ -529,9 +361,8 @@ struct nft_pipapo_elem {
  *
  * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
  */
-static int pipapo_refill(unsigned long *map, int len, int rules,
-			 unsigned long *dst, union nft_pipapo_map_bucket *mt,
-			 bool match_only)
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long =
*dst,
+		  union nft_pipapo_map_bucket *mt, bool match_only)
 {
 	unsigned long bitset;
 	int k, ret =3D -1;
@@ -565,54 +396,6 @@ static int pipapo_refill(unsigned long *map, int len=
, int rules,
 	return ret;
 }
=20
-/**
- * pipapo_and_field_buckets_4bit() - Intersect buckets for 4-bit groups
- * @f:		Field including lookup table
- * @dst:	Area to store result
- * @data:	Input data selecting table buckets
- */
-static void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
-					  unsigned long *dst,
-					  const u8 *data)
-{
-	unsigned long *lt =3D f->lt;
-	int group;
-
-	for (group =3D 0; group < f->groups; group +=3D BITS_PER_BYTE / 4, data=
++) {
-		u8 v;
-
-		v =3D *data >> 4;
-		__bitmap_and(dst, dst, lt + v * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(4);
-
-		v =3D *data & 0x0f;
-		__bitmap_and(dst, dst, lt + v * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(4);
-	}
-}
-
-/**
- * pipapo_and_field_buckets_8bit() - Intersect buckets for 8-bit groups
- * @f:		Field including lookup table
- * @dst:	Area to store result
- * @data:	Input data selecting table buckets
- */
-static void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
-					  unsigned long *dst,
-					  const u8 *data)
-{
-	unsigned long *lt =3D f->lt;
-	int group;
-
-	for (group =3D 0; group < f->groups; group++, data++) {
-		__bitmap_and(dst, dst, lt + *data * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(8);
-	}
-}
-
 /**
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
@@ -753,7 +536,6 @@ static struct nft_pipapo_elem *pipapo_get(const struc=
t net *net,
 	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
=20
 	nft_pipapo_for_each_field(f, i, m) {
-		unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
 		bool last =3D i =3D=3D m->field_count - 1;
 		int b;
=20
@@ -2190,58 +1972,23 @@ static u64 nft_pipapo_privsize(const struct nlatt=
r * const nla[],
 }
=20
 /**
- * nft_pipapo_estimate() - Estimate set size, space and lookup complexit=
y
- * @desc:	Set description, element count and field description used here
+ * nft_pipapo_estimate() - Set size, space and lookup complexity
+ * @desc:	Set description, element count and field description used
  * @features:	Flags: NFT_SET_INTERVAL needs to be there
  * @est:	Storage for estimation data
  *
- * The size for this set type can vary dramatically, as it depends on th=
e number
- * of rules (composing netmasks) the entries expand to. We compute the w=
orst
- * case here.
- *
- * In general, for a non-ranged entry or a single composing netmask, we =
need
- * one bit in each of the sixteen buckets, for each 4-bit group (that is=
, each
- * input bit needs four bits of matching data), plus a bucket in the map=
ping
- * table for each field.
- *
- * Return: true only for compatible range concatenations
+ * Return: true if set description is compatible, false otherwise
  */
 static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 fea=
tures,
 				struct nft_set_estimate *est)
 {
-	unsigned long entry_size;
-	int i;
-
 	if (!(features & NFT_SET_INTERVAL) || desc->field_count <=3D 1)
 		return false;
=20
-	for (i =3D 0, entry_size =3D 0; i < desc->field_count; i++) {
-		unsigned long rules;
-
-		if (desc->field_len[i] > NFT_PIPAPO_MAX_BYTES)
-			return false;
-
-		/* Worst-case ranges for each concatenated field: each n-bit
-		 * field can expand to up to n * 2 rules in each bucket, and
-		 * each rule also needs a mapping bucket.
-		 */
-		rules =3D ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
-		entry_size +=3D rules *
-			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
-			      BITS_PER_BYTE;
-		entry_size +=3D rules * sizeof(union nft_pipapo_map_bucket);
-	}
-
-	/* Rules in lookup and mapping tables are needed for each entry */
-	est->size =3D desc->size * entry_size;
-	if (est->size && div_u64(est->size, desc->size) !=3D entry_size)
+	est->size =3D pipapo_estimate_size(desc);
+	if (!est->size)
 		return false;
=20
-	est->size +=3D sizeof(struct nft_pipapo) +
-		     sizeof(struct nft_pipapo_match) * 2;
-
-	est->size +=3D sizeof(struct nft_pipapo_field) * desc->field_count;
-
 	est->lookup =3D NFT_SET_CLASS_O_LOG_N;
=20
 	est->space =3D NFT_SET_CLASS_O_N;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipap=
o.h
new file mode 100644
index 000000000000..3cfc0a385ee2
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo.h
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef _NFT_SET_PIPAPO_H
+
+#include <linux/log2.h>
+#include <net/ipv6.h>			/* For the maximum length of a field */
+
+/* Count of concatenated fields depends on count of 32-bit nftables regi=
sters */
+#define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
+
+/* Largest supported field size */
+#define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
+#define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
+
+/* Bits to be grouped together in table buckets depending on set size */
+#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
+#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
+#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
+#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
+	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET !=3D 8) ||		\
+		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET !=3D 4))
+#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
+
+/* If a lookup table gets bigger than NFT_PIPAPO_LT_SIZE_HIGH, switch to=
 the
+ * small group width, and switch to the big group width if the table get=
s
+ * smaller than NFT_PIPAPO_LT_SIZE_LOW.
+ *
+ * Picking 2MiB as threshold (for a single table) avoids as much as poss=
ible
+ * crossing page boundaries on most architectures (x86-64 and MIPS huge =
pages,
+ * ARMv7 supersections, POWER "large" pages, SPARC Level 1 regions, etc.=
), which
+ * keeps performance nice in case kvmalloc() gives us non-contiguous are=
as.
+ */
+#define NFT_PIPAPO_LT_SIZE_THRESHOLD	(1 << 21)
+#define NFT_PIPAPO_LT_SIZE_HYSTERESIS	(1 << 16)
+#define NFT_PIPAPO_LT_SIZE_HIGH		NFT_PIPAPO_LT_SIZE_THRESHOLD
+#define NFT_PIPAPO_LT_SIZE_LOW		NFT_PIPAPO_LT_SIZE_THRESHOLD -	\
+					NFT_PIPAPO_LT_SIZE_HYSTERESIS
+
+/* Fields are padded to 32 bits in input registers */
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
+	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(f)					\
+	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
+					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
+
+/* Number of buckets given by 2 ^ n, with n bucket bits */
+#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
+
+/* Each n-bit range maps to up to n * 2 rules */
+#define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
+
+/* Use the rest of mapping table buckets for rule indices, but it makes =
no sense
+ * to exceed 32 bits
+ */
+#if BITS_PER_LONG =3D=3D 64
+#define NFT_PIPAPO_MAP_TOBITS		32
+#else
+#define NFT_PIPAPO_MAP_TOBITS		(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
+#endif
+
+/* ...which gives us the highest allowed index for a rule */
+#define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
+					- (1UL << NFT_PIPAPO_MAP_NBITS))
+
+/* Definitions for vectorised implementations */
+#ifdef NFT_PIPAPO_ALIGN
+#define NFT_PIPAPO_ALIGN_HEADROOM					\
+	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
+#define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
+#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
+	do {								\
+		(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);		\
+		(field)->lt =3D (x);					\
+	} while (0)
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM	0
+#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt =3D (x))
+#endif /* NFT_PIPAPO_ALIGN */
+
+#define nft_pipapo_for_each_field(field, index, match)		\
+	for ((field) =3D (match)->f, (index) =3D 0;			\
+	     (index) < (match)->field_count;			\
+	     (index)++, (field)++)
+
+/**
+ * union nft_pipapo_map_bucket - Bucket of mapping table
+ * @to:		First rule number (in next field) this rule maps to
+ * @n:		Number of rules (in next field) this rule maps to
+ * @e:		If there's no next field, pointer to element this rule maps to
+ */
+union nft_pipapo_map_bucket {
+	struct {
+#if BITS_PER_LONG =3D=3D 64
+		static_assert(NFT_PIPAPO_MAP_TOBITS <=3D 32);
+		u32 to;
+
+		static_assert(NFT_PIPAPO_MAP_NBITS <=3D 32);
+		u32 n;
+#else
+		unsigned long to:NFT_PIPAPO_MAP_TOBITS;
+		unsigned long  n:NFT_PIPAPO_MAP_NBITS;
+#endif
+	};
+	struct nft_pipapo_elem *e;
+};
+
+/**
+ * struct nft_pipapo_field - Lookup, mapping tables and related data for=
 a field
+ * @groups:	Amount of bit groups
+ * @rules:	Number of inserted rules
+ * @bsize:	Size of each bucket in lookup table, in longs
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @lt:		Lookup table: 'groups' rows of buckets
+ * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
+ * @mt:		Mapping table: one bucket per rule
+ */
+struct nft_pipapo_field {
+	int groups;
+	unsigned long rules;
+	size_t bsize;
+	int bb;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long *lt_aligned;
+#endif
+	unsigned long *lt;
+	union nft_pipapo_map_bucket *mt;
+};
+
+/**
+ * struct nft_pipapo_match - Data used for lookup and matching
+ * @field_count		Amount of fields in set
+ * @scratch:		Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
+ * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
+ * @rcu			Matching data is swapped on commits
+ * @f:			Fields, with lookup and mapping tables
+ */
+struct nft_pipapo_match {
+	int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long * __percpu *scratch_aligned;
+#endif
+	unsigned long * __percpu *scratch;
+	size_t bsize_max;
+	struct rcu_head rcu;
+	struct nft_pipapo_field f[];
+};
+
+/**
+ * struct nft_pipapo - Representation of a set
+ * @match:	Currently in-use matching data
+ * @clone:	Copy where pending insertions and deletions are kept
+ * @width:	Total bytes to be matched for one packet, including padding
+ * @dirty:	Working copy has pending insertions or deletions
+ * @last_gc:	Timestamp of last garbage collection run, jiffies
+ */
+struct nft_pipapo {
+	struct nft_pipapo_match __rcu *match;
+	struct nft_pipapo_match *clone;
+	int width;
+	bool dirty;
+	unsigned long last_gc;
+};
+
+struct nft_pipapo_elem;
+
+/**
+ * struct nft_pipapo_elem - API-facing representation of single set elem=
ent
+ * @ext:	nftables API extensions
+ */
+struct nft_pipapo_elem {
+	struct nft_set_ext ext;
+};
+
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long =
*dst,
+		  union nft_pipapo_map_bucket *mt, bool match_only);
+
+/**
+ * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field=
 *f,
+						 unsigned long *dst,
+						 const u8 *data)
+{
+	unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+	int group;
+
+	for (group =3D 0; group < f->groups; group +=3D BITS_PER_BYTE / 4, data=
++) {
+		u8 v;
+
+		v =3D *data >> 4;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(4);
+
+		v =3D *data & 0x0f;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(4);
+	}
+}
+
+/**
+ * pipapo_and_field_buckets_8bit() - Intersect 8-bit buckets
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static inline void pipapo_and_field_buckets_8bit(struct nft_pipapo_field=
 *f,
+						 unsigned long *dst,
+						 const u8 *data)
+{
+	unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+	int group;
+
+	for (group =3D 0; group < f->groups; group++, data++) {
+		__bitmap_and(dst, dst, lt + *data * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(8);
+	}
+}
+
+/**
+ * pipapo_estimate_size() - Estimate worst-case for set size
+ * @desc:	Set description, element count and field description used here
+ *
+ * The size for this set type can vary dramatically, as it depends on th=
e number
+ * of rules (composing netmasks) the entries expand to. We compute the w=
orst
+ * case here.
+ *
+ * In general, for a non-ranged entry or a single composing netmask, we =
need
+ * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit gro=
up (that
+ * is, each input bit needs four bits of matching data), plus a bucket i=
n the
+ * mapping table for each field.
+ *
+ * Return: worst-case set size in bytes, 0 on any overflow
+ */
+static u64 pipapo_estimate_size(const struct nft_set_desc *desc)
+{
+	unsigned long entry_size;
+	u64 size;
+	int i;
+
+	for (i =3D 0, entry_size =3D 0; i < desc->field_count; i++) {
+		unsigned long rules;
+
+		if (desc->field_len[i] > NFT_PIPAPO_MAX_BYTES)
+			return 0;
+
+		/* Worst-case ranges for each concatenated field: each n-bit
+		 * field can expand to up to n * 2 rules in each bucket, and
+		 * each rule also needs a mapping bucket.
+		 */
+		rules =3D ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
+		entry_size +=3D rules *
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
+			      BITS_PER_BYTE;
+		entry_size +=3D rules * sizeof(union nft_pipapo_map_bucket);
+	}
+
+	/* Rules in lookup and mapping tables are needed for each entry */
+	size =3D desc->size * entry_size;
+	if (size && div_u64(size, desc->size) !=3D entry_size)
+		return 0;
+
+	size +=3D sizeof(struct nft_pipapo) + sizeof(struct nft_pipapo_match) *=
 2;
+
+	size +=3D sizeof(struct nft_pipapo_field) * desc->field_count;
+
+	return size;
+}
+
+#endif /* _NFT_SET_PIPAPO_H */
--=20
2.25.1

