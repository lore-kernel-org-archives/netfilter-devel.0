Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1EBC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0399B2071B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSJwhcZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfKVNki (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727192AbfKVNki (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2bdSxC0zHaIodHBTOehInQrV93acsw6FZoQDWl4XpU=;
        b=DSJwhcZ6uUVETnIhMCPlA72ryMKoyMHXfgw782lJsfLh6Dr9rT+VZHa4e0fhD/XJaZFeCK
        JHF2Gki2RNjbtcGz98tCNN4bPRcXie/4+3dx0RJlkeUvp+LG6lwRYLwV5pxDENhUdGD3la
        awxLMS0uquDah6YzaKrkVKS+prNQ0x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-k-hZgKj6OjiYVb2FTnd7Sg-1; Fri, 22 Nov 2019 08:40:32 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 804B7109D0AB;
        Fri, 22 Nov 2019 13:40:31 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 211281036C8E;
        Fri, 22 Nov 2019 13:40:28 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 7/8] nft_set_pipapo: Prepare for vectorised implementation: helpers
Date:   Fri, 22 Nov 2019 14:40:06 +0100
Message-Id: <339319875e91ebc85aa757e3ff6e4ffec6aa04cb.1574428269.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: k-hZgKj6OjiYVb2FTnd7Sg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
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
v2: No changes

 net/netfilter/nft_set_pipapo.c | 212 ++---------------------------
 net/netfilter/nft_set_pipapo.h | 236 +++++++++++++++++++++++++++++++++
 2 files changed, 244 insertions(+), 204 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.=
c
index 92a0e3dc6f79..5076325b8093 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -330,173 +330,20 @@
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
-#include <net/ipv6.h>=09=09=09/* For the maximum length of a field */
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
=20
-/* Count of concatenated fields depends on count of 32-bit nftables regist=
ers */
-#define NFT_PIPAPO_MAX_FIELDS=09=09NFT_REG32_COUNT
-
-/* Largest supported field size */
-#define NFT_PIPAPO_MAX_BYTES=09=09(sizeof(struct in6_addr))
-#define NFT_PIPAPO_MAX_BITS=09=09(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
-
-/* Number of bits to be grouped together in lookup table buckets, arbitrar=
y */
-#define NFT_PIPAPO_GROUP_BITS=09=094
-#define NFT_PIPAPO_GROUPS_PER_BYTE=09(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
-
-/* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)=09=09=09=09\
-=09(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(x)=09=09=09=09=09\
-=09(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
-
-/* Number of buckets, given by 2 ^ n, with n grouped bits */
-#define NFT_PIPAPO_BUCKETS=09=09(1 << NFT_PIPAPO_GROUP_BITS)
-
-/* Each n-bit range maps to up to n * 2 rules */
-#define NFT_PIPAPO_MAP_NBITS=09=09(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
-
-/* Use the rest of mapping table buckets for rule indices, but it makes no=
 sense
- * to exceed 32 bits
- */
-#if BITS_PER_LONG =3D=3D 64
-#define NFT_PIPAPO_MAP_TOBITS=09=0932
-#else
-#define NFT_PIPAPO_MAP_TOBITS=09=09(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
-#endif
-
-/* ...which gives us the highest allowed index for a rule */
-#define NFT_PIPAPO_RULE0_MAX=09=09((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
-=09=09=09=09=09- (1UL << NFT_PIPAPO_MAP_NBITS))
-
-/* Definitions for vectorised implementations */
-#ifdef NFT_PIPAPO_ALIGN
-#define NFT_PIPAPO_ALIGN_HEADROOM=09=09=09=09=09\
-=09(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
-#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
-#define NFT_PIPAPO_LT_ASSIGN(field, x)=09=09=09=09=09\
-=09do {=09=09=09=09=09=09=09=09\
-=09=09(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);=09=09\
-=09=09(field)->lt =3D (x);=09=09=09=09=09\
-=09} while (0)
-#else
-#define NFT_PIPAPO_ALIGN_HEADROOM=090
-#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(lt)
-#define NFT_PIPAPO_LT_ASSIGN(field, x)=09((field)->lt =3D (x))
-#endif /* NFT_PIPAPO_ALIGN */
-
-#define nft_pipapo_for_each_field(field, index, match)=09=09\
-=09for ((field) =3D (match)->f, (index) =3D 0;=09=09=09\
-=09     (index) < (match)->field_count;=09=09=09\
-=09     (index)++, (field)++)
-
-/**
- * union nft_pipapo_map_bucket - Bucket of mapping table
- * @to:=09=09First rule number (in next field) this rule maps to
- * @n:=09=09Number of rules (in next field) this rule maps to
- * @e:=09=09If there's no next field, pointer to element this rule maps to
- */
-union nft_pipapo_map_bucket {
-=09struct {
-#if BITS_PER_LONG =3D=3D 64
-=09=09static_assert(NFT_PIPAPO_MAP_TOBITS <=3D 32);
-=09=09u32 to;
-
-=09=09static_assert(NFT_PIPAPO_MAP_NBITS <=3D 32);
-=09=09u32 n;
-#else
-=09=09unsigned long to:NFT_PIPAPO_MAP_TOBITS;
-=09=09unsigned long  n:NFT_PIPAPO_MAP_NBITS;
-#endif
-=09};
-=09struct nft_pipapo_elem *e;
-};
-
-/**
- * struct nft_pipapo_field - Lookup, mapping tables and related data for a=
 field
- * @groups:=09Amount of 4-bit groups
- * @rules:=09Number of inserted rules
- * @bsize:=09Size of each bucket in lookup table, in longs
- * @lt:=09=09Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
- * @lt_aligned:=09Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
- * @mt:=09=09Mapping table: one bucket per rule
- */
-struct nft_pipapo_field {
-=09int groups;
-=09unsigned long rules;
-=09size_t bsize;
-#ifdef NFT_PIPAPO_ALIGN
-=09unsigned long *lt_aligned;
-#endif
-=09unsigned long *lt;
-=09union nft_pipapo_map_bucket *mt;
-};
-
-/**
- * struct nft_pipapo_match - Data used for lookup and matching
- * @field_count=09=09Amount of fields in set
- * @scratch:=09=09Preallocated per-CPU maps for partial matching results
- * @scratch_aligned:=09Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
- * @bsize_max:=09=09Maximum lookup table bucket size of all fields, in lon=
gs
- * @rcu=09=09=09Matching data is swapped on commits
- * @f:=09=09=09Fields, with lookup and mapping tables
- */
-struct nft_pipapo_match {
-=09int field_count;
-#ifdef NFT_PIPAPO_ALIGN
-=09unsigned long * __percpu *scratch_aligned;
-#endif
-=09unsigned long * __percpu *scratch;
-=09size_t bsize_max;
-=09struct rcu_head rcu;
-=09struct nft_pipapo_field f[0];
-};
+#include "nft_set_pipapo.h"
=20
 /* Current working bitmap index, toggled between field matches */
 static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
=20
-/**
- * struct nft_pipapo - Representation of a set
- * @match:=09Currently in-use matching data
- * @clone:=09Copy where pending insertions and deletions are kept
- * @groups:=09Total amount of 4-bit groups for fields in this set
- * @width:=09Total bytes to be matched for one packet, including padding
- * @dirty:=09Working copy has pending insertions or deletions
- * @last_gc:=09Timestamp of last garbage collection run, jiffies
- * @start_data:=09Key data of start element for insertion
- * @start_elem:=09Start element for insertion
- */
-struct nft_pipapo {
-=09struct nft_pipapo_match __rcu *match;
-=09struct nft_pipapo_match *clone;
-=09int groups;
-=09int width;
-=09bool dirty;
-=09unsigned long last_gc;
-=09u8 start_data[NFT_DATA_VALUE_MAXLEN * sizeof(u32)];
-=09struct nft_pipapo_elem *start_elem;
-};
-
-struct nft_pipapo_elem;
-
-/**
- * struct nft_pipapo_elem - API-facing representation of single set elemen=
t
- * @start:=09Pointer to element that represents start of interval
- * @ext:=09nftables API extensions
- */
-struct nft_pipapo_elem {
-=09struct nft_pipapo_elem *start;
-=09struct nft_set_ext ext;
-};
-
 /**
  * pipapo_refill() - For each set bit, set bits from selected mapping tabl=
e item
  * @map:=09Bitmap to be scanned for set bits
@@ -514,9 +361,8 @@ struct nft_pipapo_elem {
  *
  * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
  */
-static int pipapo_refill(unsigned long *map, int len, int rules,
-=09=09=09 unsigned long *dst, union nft_pipapo_map_bucket *mt,
-=09=09=09 bool match_only)
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *d=
st,
+=09=09  union nft_pipapo_map_bucket *mt, bool match_only)
 {
 =09unsigned long bitset;
 =09int k, ret =3D -1;
@@ -635,7 +481,7 @@ static bool nft_pipapo_lookup(const struct net *net, co=
nst struct nft_set *set,
 =09nft_pipapo_for_each_field(f, i, m) {
 =09=09bool last =3D i =3D=3D m->field_count - 1;
 =09=09unsigned long *lt =3D f->lt;
-=09=09int b, group, j;
+=09=09int b, j;
=20
 =09=09/* For each 4-bit group: select lookup table bucket depending on
 =09=09 * packet bytes value, then AND bucket value. Unroll loops for
@@ -653,21 +499,8 @@ static bool nft_pipapo_lookup(const struct net *net, c=
onst struct nft_set *set,
 =09=09} else if (f->groups =3D=3D 32) {
 =09=09=09NFT_PIPAPO_MATCH_32(res_map, lt, f->bsize, rp, j);
 =09=09} else {
-=09=09=09for (group =3D 0; group < f->groups; group++) {
-=09=09=09=09u8 v;
-
-=09=09=09=09if (group % 2) {
-=09=09=09=09=09v =3D *rp & 0x0f;
-=09=09=09=09=09rp++;
-=09=09=09=09} else {
-=09=09=09=09=09v =3D *rp >> 4;
-=09=09=09=09}
-=09=09=09=09__bitmap_and(res_map, res_map,
-=09=09=09=09=09     lt + v * f->bsize,
-=09=09=09=09=09     f->bsize * BITS_PER_LONG);
-
-=09=09=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
-=09=09=09}
+=09=09=09pipapo_and_field_buckets(f, res_map, rp);
+=09=09=09rp +=3D f->groups / NFT_PIPAPO_GROUPS_PER_BYTE;
 =09=09}
=20
 =09=09/* Now populate the bitmap for the next field, unless this is
@@ -2077,21 +1910,11 @@ static u64 nft_pipapo_privsize(const struct nlattr =
* const nla[],
 }
=20
 /**
- * nft_pipapo_estimate() - Estimate set size, space and lookup complexity
+ * nft_pipapo_estimate() - Set size, space and lookup complexity
  * @desc:=09Set description, initial element count used here
  * @features:=09Flags: NFT_SET_SUBKEY needs to be there
  * @est:=09Storage for estimation data
  *
- * The size for this set type can vary dramatically, as it depends on the =
number
- * of rules (composing netmasks) the entries expand to. We compute the wor=
st
- * case here, in order to ensure that other types are used if concatenatio=
n of
- * ranges is not needed.
- *
- * In general, for a non-ranged entry or a single composing netmask, we ne=
ed
- * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit group=
 (that
- * is, each input bit needs four bits of matching data), plus a bucket in =
the
- * mapping table for each field.
- *
  * Return: true
  */
 static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 featu=
res,
@@ -2100,26 +1923,7 @@ static bool nft_pipapo_estimate(const struct nft_set=
_desc *desc, u32 features,
 =09if (!(features & NFT_SET_SUBKEY))
 =09=09return false;
=20
-=09est->size =3D sizeof(struct nft_pipapo) + sizeof(struct nft_pipapo_matc=
h);
-
-=09/* Worst-case with current amount of 32-bit VM registers (16 of them):
-=09 * - 2 IPv6 addresses=098 registers
-=09 * - 2 interface names=098 registers
-=09 * that is, four 128-bit fields:
-=09 */
-=09est->size +=3D sizeof(struct nft_pipapo_field) * 4;
-
-=09/* expanding to worst-case ranges, 128 * 2 rules each, resulting in:
-=09 * - 128 4-bit groups
-=09 * - each set entry taking 256 bits in each bucket
-=09 */
-=09est->size +=3D desc->size * NFT_PIPAPO_MAX_BITS / NFT_PIPAPO_GROUP_BITS=
 *
-=09=09     NFT_PIPAPO_BUCKETS * NFT_PIPAPO_MAX_BITS * 2 /
-=09=09     BITS_PER_BYTE;
-
-=09/* and we need mapping buckets, too */
-=09est->size +=3D desc->size * NFT_PIPAPO_MAP_NBITS *
-=09=09     sizeof(union nft_pipapo_map_bucket);
+=09est->size =3D pipapo_estimate_size(desc->size);
=20
 =09est->lookup =3D NFT_SET_CLASS_O_LOG_N;
=20
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.=
h
new file mode 100644
index 000000000000..0261f72b804f
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo.h
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef _NFT_SET_PIPAPO_H
+
+#include <linux/log2.h>
+#include <net/ipv6.h>=09=09=09/* For the maximum length of a field */
+
+/* Count of concatenated fields depends on count of 32-bit nftables regist=
ers */
+#define NFT_PIPAPO_MAX_FIELDS=09=09NFT_REG32_COUNT
+
+/* Largest supported field size */
+#define NFT_PIPAPO_MAX_BYTES=09=09(sizeof(struct in6_addr))
+#define NFT_PIPAPO_MAX_BITS=09=09(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
+
+/* Number of bits to be grouped together in lookup table buckets, arbitrar=
y */
+#define NFT_PIPAPO_GROUP_BITS=09=094
+#define NFT_PIPAPO_GROUPS_PER_BYTE=09(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
+
+/* Fields are padded to 32 bits in input registers */
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)=09=09=09=09\
+=09(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(x)=09=09=09=09=09\
+=09(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
+
+/* Number of buckets, given by 2 ^ n, with n grouped bits */
+#define NFT_PIPAPO_BUCKETS=09=09(1 << NFT_PIPAPO_GROUP_BITS)
+
+/* Each n-bit range maps to up to n * 2 rules */
+#define NFT_PIPAPO_MAP_NBITS=09=09(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
+
+/* Use the rest of mapping table buckets for rule indices, but it makes no=
 sense
+ * to exceed 32 bits
+ */
+#if BITS_PER_LONG =3D=3D 64
+#define NFT_PIPAPO_MAP_TOBITS=09=0932
+#else
+#define NFT_PIPAPO_MAP_TOBITS=09=09(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
+#endif
+
+/* ...which gives us the highest allowed index for a rule */
+#define NFT_PIPAPO_RULE0_MAX=09=09((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
+=09=09=09=09=09- (1UL << NFT_PIPAPO_MAP_NBITS))
+
+/* Definitions for vectorised implementations */
+#ifdef NFT_PIPAPO_ALIGN
+#define NFT_PIPAPO_ALIGN_HEADROOM=09=09=09=09=09\
+=09(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
+#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
+#define NFT_PIPAPO_LT_ASSIGN(field, x)=09=09=09=09=09\
+=09do {=09=09=09=09=09=09=09=09\
+=09=09(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);=09=09\
+=09=09(field)->lt =3D (x);=09=09=09=09=09\
+=09} while (0);
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM=090
+#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)=09=09=09=09=09\
+=09do {=09=09=09=09=09=09=09=09\
+=09=09(field)->lt =3D (x);=09=09=09=09=09\
+=09} while (0);
+#endif /* NFT_PIPAPO_ALIGN */
+
+#define nft_pipapo_for_each_field(field, index, match)=09=09\
+=09for ((field) =3D (match)->f, (index) =3D 0;=09=09=09\
+=09     (index) < (match)->field_count;=09=09=09\
+=09     (index)++, (field)++)
+
+/**
+ * union nft_pipapo_map_bucket - Bucket of mapping table
+ * @to:=09=09First rule number (in next field) this rule maps to
+ * @n:=09=09Number of rules (in next field) this rule maps to
+ * @e:=09=09If there's no next field, pointer to element this rule maps to
+ */
+union nft_pipapo_map_bucket {
+=09struct {
+#if BITS_PER_LONG =3D=3D 64
+=09=09static_assert(NFT_PIPAPO_MAP_TOBITS <=3D 32);
+=09=09u32 to;
+
+=09=09static_assert(NFT_PIPAPO_MAP_NBITS <=3D 32);
+=09=09u32 n;
+#else
+=09=09unsigned long to:NFT_PIPAPO_MAP_TOBITS;
+=09=09unsigned long  n:NFT_PIPAPO_MAP_NBITS;
+#endif
+=09};
+=09struct nft_pipapo_elem *e;
+};
+
+/**
+ * struct nft_pipapo_field - Lookup, mapping tables and related data for a=
 field
+ * @groups:=09Amount of 4-bit groups
+ * @rules:=09Number of inserted rules
+ * @bsize:=09Size of each bucket in lookup table, in longs
+ * @lt:=09=09Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @lt_aligned:=09Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
+ * @mt:=09=09Mapping table: one bucket per rule
+ */
+struct nft_pipapo_field {
+=09int groups;
+=09unsigned long rules;
+=09size_t bsize;
+=09unsigned long *lt;
+#ifdef NFT_PIPAPO_ALIGN
+=09unsigned long *lt_aligned;
+#endif
+=09union nft_pipapo_map_bucket *mt;
+};
+
+/**
+ * struct nft_pipapo_match - Data used for lookup and matching
+ * @field_count=09=09Amount of fields in set
+ * @scratch:=09=09Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:=09Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
+ * @bsize_max:=09=09Maximum lookup table bucket size of all fields, in lon=
gs
+ * @rcu=09=09=09Matching data is swapped on commits
+ * @f:=09=09=09Fields, with lookup and mapping tables
+ */
+struct nft_pipapo_match {
+=09int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+=09unsigned long * __percpu *scratch_aligned;
+#endif
+=09unsigned long * __percpu *scratch;
+=09size_t bsize_max;
+=09struct rcu_head rcu;
+=09struct nft_pipapo_field f[0];
+};
+
+/**
+ * struct nft_pipapo - Representation of a set
+ * @match:=09Currently in-use matching data
+ * @clone:=09Copy where pending insertions and deletions are kept
+ * @groups:=09Total amount of 4-bit groups for fields in this set
+ * @width:=09Total bytes to be matched for one packet, including padding
+ * @dirty:=09Working copy has pending insertions or deletions
+ * @last_gc:=09Timestamp of last garbage collection run, jiffies
+ * @start_data:=09Key data of start element for insertion
+ * @start_elem:=09Start element for insertion
+ */
+struct nft_pipapo {
+=09struct nft_pipapo_match __rcu *match;
+=09struct nft_pipapo_match *clone;
+=09int groups;
+=09int width;
+=09bool dirty;
+=09unsigned long last_gc;
+=09u8 start_data[NFT_DATA_VALUE_MAXLEN * sizeof(u32)];
+=09struct nft_pipapo_elem *start_elem;
+};
+
+struct nft_pipapo_elem;
+
+/**
+ * struct nft_pipapo_elem - API-facing representation of single set elemen=
t
+ * @start:=09Pointer to element that represents start of interval
+ * @ext:=09nftables API extensions
+ */
+struct nft_pipapo_elem {
+=09struct nft_pipapo_elem *start;
+=09struct nft_set_ext ext;
+};
+
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *d=
st,
+=09=09  union nft_pipapo_map_bucket *mt, bool match_only);
+
+/**
+ * pipapo_and_field_buckets() - Select buckets from packet data and inters=
ect
+ * @f:=09=09Field including lookup table
+ * @dst:=09Scratch map for partial matching result
+ * @rp:=09=09Packet data register pointer
+ */
+static inline void pipapo_and_field_buckets(struct nft_pipapo_field *f,
+=09=09=09=09=09    unsigned long *dst, const u8 *rp)
+{
+=09unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+=09int group;
+
+=09for (group =3D 0; group < f->groups; group++) {
+=09=09u8 v;
+
+=09=09if (group % 2) {
+=09=09=09v =3D *rp & 0x0f;
+=09=09=09rp++;
+=09=09} else {
+=09=09=09v =3D *rp >> 4;
+=09=09}
+=09=09__bitmap_and(dst, dst, lt + v * f->bsize,
+=09=09=09     f->bsize * BITS_PER_LONG);
+
+=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
+=09}
+}
+
+/**
+ * pipapo_estimate_size() - Estimate worst-case for set size
+ * @elem_count:=09=09Count of initial set elements
+ *
+ * The size for this set type can vary dramatically, as it depends on the =
number
+ * of rules (composing netmasks) the entries expand to. We compute the wor=
st
+ * case here, in order to ensure that other types are used if concatenatio=
n of
+ * ranges is not needed.
+ *
+ * In general, for a non-ranged entry or a single composing netmask, we ne=
ed
+ * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit group=
 (that
+ * is, each input bit needs four bits of matching data), plus a bucket in =
the
+ * mapping table for each field.
+ *
+ * Return: estimated worst-case set size, in bytes.
+ */
+static int pipapo_estimate_size(int elem_count)
+{
+=09int size =3D sizeof(struct nft_pipapo) + sizeof(struct nft_pipapo_match=
);
+
+=09/* Worst-case with current amount of 32-bit VM registers (16 of them):
+=09 * - 2 IPv6 addresses=098 registers
+=09 * - 2 interface names=098 registers
+=09 * that is, four 128-bit fields:
+=09 */
+=09size +=3D sizeof(struct nft_pipapo_field) * 4;
+
+=09/* expanding to worst-case ranges, 128 * 2 rules each, resulting in:
+=09 * - 128 4-bit groups
+=09 * - each set entry taking 256 bits in each bucket
+=09 */
+=09size +=3D elem_count * NFT_PIPAPO_MAX_BITS / NFT_PIPAPO_GROUP_BITS *
+=09=09NFT_PIPAPO_BUCKETS * NFT_PIPAPO_MAX_BITS * 2 / BITS_PER_BYTE;
+
+=09/* and we need mapping buckets, too */
+=09size +=3D elem_count * NFT_PIPAPO_MAP_NBITS *
+=09=09sizeof(union nft_pipapo_map_bucket);
+
+=09return size;
+}
+
+#endif /* _NFT_SET_PIPAPO_H */
--=20
2.20.1

