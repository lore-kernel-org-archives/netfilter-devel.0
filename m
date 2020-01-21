Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D07C33CAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F9224653
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HopTOPJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAUXSa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:18:30 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727847AbgAUXS3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 18:18:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579648707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7H4WkfKctW40XHO+X08OgAGrOoz6nTqHZ8lhCcHNshs=;
        b=HopTOPJJJkMcavDRsoqRNm8F8pzt+iuOrkIl9Y0Bn0vLxZJsGytEKwHPN6X1t7bYzhlZq1
        t3Rqk3LVioizpPlLDGjw0XvXvSCPoZoAgF5ILCT4CZB6LjkLR+myC0I6hJDSQWRJdcq6to
        diiJo1Gftyr9lay2VyFvHPvhIJlIdKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-A7HtBUOpNBeZ1pj19c_EeA-1; Tue, 21 Jan 2020 18:18:25 -0500
X-MC-Unique: A7HtBUOpNBeZ1pj19c_EeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2630FDB60;
        Tue, 21 Jan 2020 23:18:24 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5AA5C1BB;
        Tue, 21 Jan 2020 23:18:21 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v4 8/9] nft_set_pipapo: Prepare for vectorised implementation: helpers
Date:   Wed, 22 Jan 2020 00:17:58 +0100
Message-Id: <df162e5903e971a6dae7462d8fc85e8d6ea3a838.1579647351.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579647351.git.sbrivio@redhat.com>
References: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move most macros and helpers to a header file, so that they can be
conveniently used by related implementations.

No functional changes are intended here.

v4: No changes
v3: Fix comment for pipapo_estimate_size(), we return 0 on overflow
v2: No changes

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 216 ++----------------------------
 net/netfilter/nft_set_pipapo.h | 237 +++++++++++++++++++++++++++++++++
 2 files changed, 248 insertions(+), 205 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index a9665d44e4f8..e7f4cecea7d6 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -330,167 +330,20 @@
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
-/* Number of bits to be grouped together in lookup table buckets, arbitr=
ary */
-#define NFT_PIPAPO_GROUP_BITS		4
-#define NFT_PIPAPO_GROUPS_PER_BYTE	(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
-
-/* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)				\
-	(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(x)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
-
-/* Number of buckets, given by 2 ^ n, with n grouped bits */
-#define NFT_PIPAPO_BUCKETS		(1 << NFT_PIPAPO_GROUP_BITS)
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
- * @groups:	Amount of 4-bit groups
- * @rules:	Number of inserted rules
- * @bsize:	Size of each bucket in lookup table, in longs
- * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
- * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
- * @mt:		Mapping table: one bucket per rule
- */
-struct nft_pipapo_field {
-	int groups;
-	unsigned long rules;
-	size_t bsize;
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
-	struct nft_pipapo_field f[0];
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
- * @groups:	Total amount of 4-bit groups for fields in this set
- * @width:	Total bytes to be matched for one packet, including padding
- * @dirty:	Working copy has pending insertions or deletions
- * @last_gc:	Timestamp of last garbage collection run, jiffies
- */
-struct nft_pipapo {
-	struct nft_pipapo_match __rcu *match;
-	struct nft_pipapo_match *clone;
-	int groups;
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
@@ -508,9 +361,8 @@ struct nft_pipapo_elem {
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
@@ -583,26 +435,13 @@ static bool nft_pipapo_lookup(const struct net *net=
, const struct nft_set *set,
=20
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last =3D i =3D=3D m->field_count - 1;
-		unsigned long *lt =3D f->lt;
-		int b, group;
+		int b;
=20
 		/* For each 4-bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		for (group =3D 0; group < f->groups; group +=3D 2) {
-			u8 v;
-
-			v =3D *rp >> 4;
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
-			lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
-
-			v =3D *rp & 0x0f;
-			rp++;
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
-			lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
-		}
+		pipapo_and_field_buckets(f, res_map, rp);
+		rp +=3D f->groups / NFT_PIPAPO_GROUPS_PER_BYTE;
=20
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -1943,56 +1782,23 @@ static u64 nft_pipapo_privsize(const struct nlatt=
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
- * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit gro=
up (that
- * is, each input bit needs four bits of matching data), plus a bucket i=
n the
- * mapping table for each field.
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
-		entry_size +=3D rules * NFT_PIPAPO_BUCKETS / BITS_PER_BYTE;
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
index 000000000000..f11fbfa2c9aa
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo.h
@@ -0,0 +1,237 @@
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
+/* Number of bits to be grouped together in lookup table buckets, arbitr=
ary */
+#define NFT_PIPAPO_GROUP_BITS		4
+#define NFT_PIPAPO_GROUPS_PER_BYTE	(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
+
+/* Fields are padded to 32 bits in input registers */
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)				\
+	(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(x)					\
+	(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
+
+/* Number of buckets, given by 2 ^ n, with n grouped bits */
+#define NFT_PIPAPO_BUCKETS		(1 << NFT_PIPAPO_GROUP_BITS)
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
+	} while (0);
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM	0
+#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
+	do {								\
+		(field)->lt =3D (x);					\
+	} while (0);
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
+ * @groups:	Amount of 4-bit groups
+ * @rules:	Number of inserted rules
+ * @bsize:	Size of each bucket in lookup table, in longs
+ * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
+ * @mt:		Mapping table: one bucket per rule
+ */
+struct nft_pipapo_field {
+	int groups;
+	unsigned long rules;
+	size_t bsize;
+	unsigned long *lt;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long *lt_aligned;
+#endif
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
+	struct nft_pipapo_field f[0];
+};
+
+/**
+ * struct nft_pipapo - Representation of a set
+ * @match:	Currently in-use matching data
+ * @clone:	Copy where pending insertions and deletions are kept
+ * @groups:	Total amount of 4-bit groups for fields in this set
+ * @width:	Total bytes to be matched for one packet, including padding
+ * @dirty:	Working copy has pending insertions or deletions
+ * @last_gc:	Timestamp of last garbage collection run, jiffies
+ */
+struct nft_pipapo {
+	struct nft_pipapo_match __rcu *match;
+	struct nft_pipapo_match *clone;
+	int groups;
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
+ * pipapo_and_field_buckets() - Select buckets from packet data and inte=
rsect
+ * @f:		Field including lookup table
+ * @dst:	Scratch map for partial matching result
+ * @rp:		Packet data register pointer
+ */
+static inline void pipapo_and_field_buckets(struct nft_pipapo_field *f,
+					    unsigned long *dst, const u8 *rp)
+{
+	unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+	int group;
+
+	for (group =3D 0; group < f->groups; group +=3D 2) {
+		u8 v;
+
+		v =3D *rp >> 4;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
+
+		v =3D *rp & 0x0f;
+		rp++;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
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
+		entry_size +=3D rules * NFT_PIPAPO_BUCKETS / BITS_PER_BYTE;
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
2.24.1

