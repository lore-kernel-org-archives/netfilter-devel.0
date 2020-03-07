Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B109AC10F00
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A3F520684
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PePOvxrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCGQxJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:53:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbgCGQxI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 11:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583599986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0/KAJ+oLZjhQNNgXdU0OpYL4oKqk6ghDlPiZpeSa+0=;
        b=PePOvxrsBa4wCLMdC6HENuDxY0TbNX5+1KoLEuTx7mh11muxfom2pTQfzKu+llmwT5Uyz6
        cJ1VXyHWc/5rClt6vmtFdbjzVqhHuyMtuccz4nVyp1myC/PhEFGHILnfEmCDhkOO0tTRfC
        MT00sWk9NLIFhjb8IX89dEQzBSXxEhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-5bH6SfGUMzaqzt1dRMJ29Q-1; Sat, 07 Mar 2020 11:53:02 -0500
X-MC-Unique: 5bH6SfGUMzaqzt1dRMJ29Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8690B189F760;
        Sat,  7 Mar 2020 16:53:01 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0C326E3EE;
        Sat,  7 Mar 2020 16:52:59 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 5/6] nft_set_pipapo: Introduce AVX2-based lookup implementation
Date:   Sat,  7 Mar 2020 17:52:36 +0100
Message-Id: <445c4bb29a3269ea3e8e2bc88d443b38146d99cc.1583598508.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583598508.git.sbrivio@redhat.com>
References: <cover.1583598508.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the AVX2 set is available, we can exploit the repetitive
characteristic of this algorithm to provide a fast, vectorised
version by using 256-bit wide AVX2 operations for bucket loads and
bitwise intersections.

In most cases, this implementation consistently outperforms rbtree
set instances despite the fact they are configured to use a given,
single, ranged data type out of the ones used for performance
measurements by the nft_concat_range.sh kselftest.

That script, injecting packets directly on the ingoing device path
with pktgen, reports, averaged over five runs on a single AMD Epyc
7402 thread (3.35GHz, 768 KiB L1D$, 12 MiB L2$), the figures below.
CONFIG_RETPOLINE was not set here.

Note that this is not a fair comparison over hash and rbtree set
types: non-ranged entries (used to have a reference for hash types)
would be matched faster than this, and matching on a single field
only (which is the case for rbtree) is also significantly faster.

However, it's not possible at the moment to choose this set type
for non-ranged entries, and the current implementation also needs
a few minor adjustments in order to match on less than two fields.

 ---------------.-----------------------------------.------------.
 AMD Epyc 7402  |          baselines, Mpps          | this patch |
  1 thread      |___________________________________|____________|
  3.35GHz       |        |        |        |        |            |
  768KiB L1D$   | netdev |  hash  | rbtree |        |            |
 ---------------|  hook  |   no   | single |        |   pipapo   |
 type   entries |  drop  | ranges | field  | pipapo |    AVX2    |
 ---------------|--------|--------|--------|--------|------------|
 net,port       |        |        |        |        |            |
          1000  |   19.0 |   10.4 |    3.8 |    4.0 | 7.5   +87% |
 ---------------|--------|--------|--------|--------|------------|
 port,net       |        |        |        |        |            |
           100  |   18.8 |   10.3 |    5.8 |    6.3 | 8.1   +29% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port      |        |        |        |        |            |
          1000  |   16.4 |    7.6 |    1.8 |    2.1 | 4.8  +128% |
 ---------------|--------|--------|--------|--------|------------|
 port,proto     |        |        |        |        |            |
         30000  |   19.6 |   11.6 |    3.9 |    0.5 | 2.6  +420% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac  |        |        |        |        |            |
            10  |   16.5 |    5.4 |    4.3 |    3.4 | 4.7   +38% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac, |        |        |        |        |            |
 proto    1000  |   16.5 |    5.7 |    1.9 |    1.4 | 3.6   +26% |
 ---------------|--------|--------|--------|--------|------------|
 net,mac        |        |        |        |        |            |
          1000  |   19.0 |    8.4 |    3.9 |    2.5 | 6.4  +156% |
 ---------------'--------'--------'--------'--------'------------'

A similar strategy could be easily reused to implement specialised
versions for other SIMD sets, and I plan to post at least a NEON
version at a later time.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: Rebase, no significant changes

 include/net/netfilter/nf_tables_core.h |    1 +
 net/netfilter/Makefile                 |    6 +
 net/netfilter/nf_tables_api.c          |    3 +
 net/netfilter/nft_set_pipapo.c         |   24 +
 net/netfilter/nft_set_pipapo_avx2.c    | 1222 ++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h    |   14 +
 6 files changed, 1270 insertions(+)
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilt=
er/nf_tables_core.h
index 3e30cc5d195b..78516de14d31 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -75,6 +75,7 @@ extern const struct nft_set_type nft_set_hash_fast_type=
;
 extern const struct nft_set_type nft_set_rbtree_type;
 extern const struct nft_set_type nft_set_bitmap_type;
 extern const struct nft_set_type nft_set_pipapo_type;
+extern const struct nft_set_type nft_set_pipapo_avx2_type;
=20
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4fff7d0e2d27..292e71dc7ba4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -82,6 +82,12 @@ nf_tables-objs :=3D nf_tables_core.o nf_tables_api.o n=
ft_chain_filter.o \
 		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
 		  nft_set_pipapo.o
=20
+ifdef CONFIG_X86_64
+ifneq (,$(findstring -DCONFIG_AS_AVX2=3D1,$(KBUILD_CFLAGS)))
+nf_tables-objs +=3D nft_set_pipapo_avx2.o
+endif
+endif
+
 obj-$(CONFIG_NF_TABLES)		+=3D nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+=3D nft_compat.o
 obj-$(CONFIG_NFT_CONNLIMIT)	+=3D nft_connlimit.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
index 0cd41e42df81..63b16da818d3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3267,6 +3267,9 @@ static const struct nft_set_type *nft_set_types[] =3D=
 {
 	&nft_set_rhash_type,
 	&nft_set_bitmap_type,
 	&nft_set_rbtree_type,
+#if defined(CONFIG_X86_64) && defined(CONFIG_AS_AVX2)
+	&nft_set_pipapo_avx2_type,
+#endif
 	&nft_set_pipapo_type,
 };
=20
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index 141e0ab26d3c..1e8dd5dccdf7 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -339,6 +339,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
=20
+#include "nft_set_pipapo_avx2.h"
 #include "nft_set_pipapo.h"
=20
 /* Current working bitmap index, toggled between field matches */
@@ -2174,3 +2175,26 @@ const struct nft_set_type nft_set_pipapo_type =3D =
{
 		.elemsize	=3D offsetof(struct nft_pipapo_elem, ext),
 	},
 };
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_AS_AVX2)
+const struct nft_set_type nft_set_pipapo_avx2_type =3D {
+	.features	=3D NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT |
+			  NFT_SET_TIMEOUT,
+	.ops		=3D {
+		.lookup		=3D nft_pipapo_avx2_lookup,
+		.insert		=3D nft_pipapo_insert,
+		.activate	=3D nft_pipapo_activate,
+		.deactivate	=3D nft_pipapo_deactivate,
+		.flush		=3D nft_pipapo_flush,
+		.remove		=3D nft_pipapo_remove,
+		.walk		=3D nft_pipapo_walk,
+		.get		=3D nft_pipapo_get,
+		.privsize	=3D nft_pipapo_privsize,
+		.estimate	=3D nft_pipapo_avx2_estimate,
+		.init		=3D nft_pipapo_init,
+		.destroy	=3D nft_pipapo_destroy,
+		.gc_init	=3D nft_pipapo_gc_init,
+		.elemsize	=3D offsetof(struct nft_pipapo_elem, ext),
+	},
+};
+#endif
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_=
pipapo_avx2.c
new file mode 100644
index 000000000000..f6e20154d2b7
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -0,0 +1,1222 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* PIPAPO: PIle PAcket POlicies: AVX2 packet lookup routines
+ *
+ * Copyright (c) 2019-2020 Red Hat GmbH
+ *
+ * Author: Stefano Brivio <sbrivio@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <uapi/linux/netfilter/nf_tables.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+
+#include <linux/compiler.h>
+#include <asm/fpu/api.h>
+
+#include "nft_set_pipapo_avx2.h"
+#include "nft_set_pipapo.h"
+
+#define NFT_PIPAPO_LONGS_PER_M256	(XSAVE_YMM_SIZE / BITS_PER_LONG)
+
+/* Load from memory into YMM register with non-temporal hint ("stream lo=
ad"),
+ * that is, don't fetch lines from memory into the cache. This avoids pu=
shing
+ * precious packet data out of the cache hierarchy, and is appropriate w=
hen:
+ *
+ * - loading buckets from lookup tables, as they are not going to be use=
d
+ *   again before packets are entirely classified
+ *
+ * - loading the result bitmap from the previous field, as it's never us=
ed
+ *   again
+ */
+#define NFT_PIPAPO_AVX2_LOAD(reg, loc)					\
+	asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
+
+/* Stream a single lookup table bucket into YMM register given lookup ta=
ble,
+ * group index, value of packet bits, bucket size.
+ */
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD4(reg, lt, group, v, bsize)		\
+	NFT_PIPAPO_AVX2_LOAD(reg,					\
+			     lt[((group) * NFT_PIPAPO_BUCKETS(4) +	\
+				 (v)) * (bsize)])
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD8(reg, lt, group, v, bsize)		\
+	NFT_PIPAPO_AVX2_LOAD(reg,					\
+			     lt[((group) * NFT_PIPAPO_BUCKETS(8) +	\
+				 (v)) * (bsize)])
+
+/* Bitwise AND: the staple operation of this algorithm */
+#define NFT_PIPAPO_AVX2_AND(dst, a, b)					\
+	asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
+
+/* Jump to label if @reg is zero */
+#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)			\
+	asm_volatile_goto("vptest %%ymm" #reg ", %%ymm" #reg ";"	\
+			  "je %l[" #label "]" : : : : label)
+
+/* Store 256 bits from YMM register into memory. Contrary to bucket load
+ * operation, we don't bypass the cache here, as stored matching results
+ * are always used shortly after.
+ */
+#define NFT_PIPAPO_AVX2_STORE(loc, reg)					\
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : "=3Dm" (loc))
+
+/* Zero out a complete YMM register, @reg */
+#define NFT_PIPAPO_AVX2_ZERO(reg)					\
+	asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)
+
+/* Current working bitmap index, toggled between field matches */
+static DEFINE_PER_CPU(bool, nft_pipapo_avx2_scratch_index);
+
+/**
+ * nft_pipapo_avx2_prepare() - Prepare before main algorithm body
+ *
+ * This zeroes out ymm15, which is later used whenever we need to clear =
a
+ * memory location, by storing its content into memory.
+ */
+static void nft_pipapo_avx2_prepare(void)
+{
+	NFT_PIPAPO_AVX2_ZERO(15);
+}
+
+/**
+ * nft_pipapo_avx2_fill() - Fill a bitmap region with ones
+ * @data:	Base memory area
+ * @start:	First bit to set
+ * @len:	Count of bits to fill
+ *
+ * This is nothing else than a version of bitmap_set(), as used e.g. by
+ * pipapo_refill(), tailored for the microarchitectures using it and bet=
ter
+ * suited for the specific usage: it's very likely that we'll set a smal=
l number
+ * of bits, not crossing a word boundary, and correct branch prediction =
is
+ * critical here.
+ *
+ * This function doesn't actually use any AVX2 instruction.
+ */
+static void nft_pipapo_avx2_fill(unsigned long *data, int start, int len=
)
+{
+	int offset =3D start % BITS_PER_LONG;
+	unsigned long mask;
+
+	data +=3D start / BITS_PER_LONG;
+
+	if (likely(len =3D=3D 1)) {
+		*data |=3D BIT(offset);
+		return;
+	}
+
+	if (likely(len < BITS_PER_LONG || offset)) {
+		if (likely(len + offset <=3D BITS_PER_LONG)) {
+			*data |=3D GENMASK(len - 1 + offset, offset);
+			return;
+		}
+
+		*data |=3D ~0UL << offset;
+		len -=3D BITS_PER_LONG - offset;
+		data++;
+
+		if (len <=3D BITS_PER_LONG) {
+			mask =3D ~0UL >> (BITS_PER_LONG - len);
+			*data |=3D mask;
+			return;
+		}
+	}
+
+	memset(data, 0xff, len / BITS_PER_BYTE);
+	data +=3D len / BITS_PER_LONG;
+
+	len %=3D BITS_PER_LONG;
+	if (len)
+		*data |=3D ~0UL >> (BITS_PER_LONG - len);
+}
+
+/**
+ * nft_pipapo_avx2_refill() - Scan bitmap, select mapping table item, se=
t bits
+ * @offset:	Start from given bitmap (equivalent to bucket) offset, in lo=
ngs
+ * @map:	Bitmap to be scanned for set bits
+ * @dst:	Destination bitmap
+ * @mt:		Mapping table containing bit set specifiers
+ * @len:	Length of bitmap in longs
+ * @last:	Return index of first set bit, if this is the last field
+ *
+ * This is an alternative implementation of pipapo_refill() suitable for=
 usage
+ * with AVX2 lookup routines: we know there are four words to be scanned=
, at
+ * a given offset inside the map, for each matching iteration.
+ *
+ * This function doesn't actually use any AVX2 instruction.
+ *
+ * Return: first set bit index if @last, index of first filled word othe=
rwise.
+ */
+static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
+				  unsigned long *dst,
+				  union nft_pipapo_map_bucket *mt, bool last)
+{
+	int ret =3D -1;
+
+#define NFT_PIPAPO_AVX2_REFILL_ONE_WORD(x)				\
+	do {								\
+		while (map[(x)]) {					\
+			int r =3D __builtin_ctzl(map[(x)]);		\
+			int i =3D (offset + (x)) * BITS_PER_LONG + r;	\
+									\
+			if (last)					\
+				return i;				\
+									\
+			nft_pipapo_avx2_fill(dst, mt[i].to, mt[i].n);	\
+									\
+			if (ret =3D=3D -1)					\
+				ret =3D mt[i].to;				\
+									\
+			map[(x)] &=3D ~(1UL << r);			\
+		}							\
+	} while (0)
+
+	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(0);
+	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(1);
+	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(2);
+	NFT_PIPAPO_AVX2_REFILL_ONE_WORD(3);
+#undef NFT_PIPAPO_AVX2_REFILL_ONE_WORD
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_4b_2() - AVX2-based lookup for 2 four-bit grou=
ps
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * Load buckets from lookup table corresponding to the values of each 4-=
bit
+ * group of packet bytes, and perform a bitwise intersection between the=
m. If
+ * this is the first field in the set, simply AND the buckets together
+ * (equivalent to using an all-ones starting bitmap), use the provided s=
tarting
+ * bitmap otherwise. Then call nft_pipapo_avx2_refill() to generate the =
next
+ * working bitmap, @fill.
+ *
+ * This is used for 8-bit fields (i.e. protocol numbers).
+ *
+ * Out-of-order (and superscalar) execution is vital here, so it's criti=
cal to
+ * avoid false data dependencies. CPU and compiler could (mostly) take c=
are of
+ * this on their own, but the operation ordering is explicitly given her=
e with
+ * a likely execution order in mind, to highlight possible stalls. That'=
s why
+ * a number of logically distinct operations (i.e. loading buckets, inte=
rsecting
+ * buckets) are interleaved.
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	u8 pg[2] =3D { pkt[0] >> 4, pkt[0] & 0xf };
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(2, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(2, nothing);
+			NFT_PIPAPO_AVX2_AND(3, 0, 1);
+			NFT_PIPAPO_AVX2_AND(4, 2, 3);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_4b_4() - AVX2-based lookup for 4 four-bit grou=
ps
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 16-bit fields (i.e. ports).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	u8 pg[4] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(2, lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(3, lt, 3, pg[3], bsize);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+			NFT_PIPAPO_AVX2_AND(5, 2, 3);
+			NFT_PIPAPO_AVX2_AND(7, 4, 5);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0, lt, 0, pg[0], bsize);
+
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(2, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(3, lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(4, lt, 3, pg[3], bsize);
+			NFT_PIPAPO_AVX2_AND(5, 0, 1);
+
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+			NFT_PIPAPO_AVX2_AND(6, 2, 3);
+			NFT_PIPAPO_AVX2_AND(7, 4, 5);
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(7, 6, 7);
+		}
+
+		/* Stall */
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(7, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 7);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_4b_8() - AVX2-based lookup for 8 four-bit grou=
ps
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 32-bit fields (i.e. IPv4 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	u8 pg[8] =3D {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0xf=
,
+		      pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
+		   };
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0,  lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(1,  lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(2,  lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 3, pg[3], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(4,  lt, 4, pg[4], bsize);
+			NFT_PIPAPO_AVX2_AND(5,   0,  1);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(6,  lt, 5, pg[5], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(7,  lt, 6, pg[6], bsize);
+			NFT_PIPAPO_AVX2_AND(8,   2,  3);
+			NFT_PIPAPO_AVX2_AND(9,   4,  5);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(10, lt, 7, pg[7], bsize);
+			NFT_PIPAPO_AVX2_AND(11,  6,  7);
+			NFT_PIPAPO_AVX2_AND(12,  8,  9);
+			NFT_PIPAPO_AVX2_AND(13, 10, 11);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(1,  12, 13);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(0,  lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(2,  lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(4,  lt, 3, pg[3], bsize);
+
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+			NFT_PIPAPO_AVX2_AND(5,   0,  1);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(6,  lt, 4, pg[4], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(7,  lt, 5, pg[5], bsize);
+			NFT_PIPAPO_AVX2_AND(8,   2,  3);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(9,  lt, 6, pg[6], bsize);
+			NFT_PIPAPO_AVX2_AND(10,  4,  5);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD4(11, lt, 7, pg[7], bsize);
+			NFT_PIPAPO_AVX2_AND(12,  6,  7);
+			NFT_PIPAPO_AVX2_AND(13,  8,  9);
+			NFT_PIPAPO_AVX2_AND(14, 10, 11);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(1,  12, 13);
+			NFT_PIPAPO_AVX2_AND(1,   1, 14);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 1);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_4b_12() - AVX2-based lookup for 12 four-bit gr=
oups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 48-bit fields (i.e. MAC addresses/EUI-48).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned lon=
g *fill,
+				        struct nft_pipapo_field *f, int offset,
+				        const u8 *pkt, bool first, bool last)
+{
+	u8 pg[12] =3D {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0x=
f,
+		       pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
+		       pkt[4] >> 4,  pkt[4] & 0xf,  pkt[5] >> 4,  pkt[5] & 0xf,
+		    };
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (!first)
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(1,  lt,  0,  pg[0], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(2,  lt,  1,  pg[1], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt,  2,  pg[2], bsize);
+
+		if (!first) {
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(1, 1, 0);
+		}
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(4,  lt,  3,  pg[3], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(5,  lt,  4,  pg[4], bsize);
+		NFT_PIPAPO_AVX2_AND(6,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(7,  lt,  5,  pg[5], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(8,  lt,  6,  pg[6], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   1,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(10, lt,  7,  pg[7], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(12, lt,  8,  pg[8], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  7,  8);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(14, lt,  9,  pg[9], bsize);
+
+		NFT_PIPAPO_AVX2_AND(0,   9, 10);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(1,  lt, 10,  pg[10], bsize);
+		NFT_PIPAPO_AVX2_AND(2,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 11,  pg[11], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  13, 14);
+		NFT_PIPAPO_AVX2_AND(5,   0,  1);
+
+		NFT_PIPAPO_AVX2_AND(6,   2,  3);
+
+		/* Stalls */
+		NFT_PIPAPO_AVX2_AND(7,   4,  5);
+		NFT_PIPAPO_AVX2_AND(8,   6,  7);
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(8, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 8);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_4b_32() - AVX2-based lookup for 32 four-bit gr=
oups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 128-bit fields (i.e. IPv6 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned lon=
g *fill,
+					struct nft_pipapo_field *f, int offset,
+					const u8 *pkt, bool first, bool last)
+{
+	u8 pg[32] =3D {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0x=
f,
+		       pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
+		       pkt[4] >> 4,  pkt[4] & 0xf,  pkt[5] >> 4,  pkt[5] & 0xf,
+		       pkt[6] >> 4,  pkt[6] & 0xf,  pkt[7] >> 4,  pkt[7] & 0xf,
+		       pkt[8] >> 4,  pkt[8] & 0xf,  pkt[9] >> 4,  pkt[9] & 0xf,
+		      pkt[10] >> 4, pkt[10] & 0xf, pkt[11] >> 4, pkt[11] & 0xf,
+		      pkt[12] >> 4, pkt[12] & 0xf, pkt[13] >> 4, pkt[13] & 0xf,
+		      pkt[14] >> 4, pkt[14] & 0xf, pkt[15] >> 4, pkt[15] & 0xf,
+		    };
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (!first)
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(1,  lt,  0,  pg[0], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(2,  lt,  1,  pg[1], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt,  2,  pg[2], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(4,  lt,  3,  pg[3], bsize);
+		if (!first) {
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(1, 1, 0);
+		}
+
+		NFT_PIPAPO_AVX2_AND(5,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(6,  lt,  4,  pg[4], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(7,  lt,  5,  pg[5], bsize);
+		NFT_PIPAPO_AVX2_AND(8,   1,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(9,  lt,  6,  pg[6], bsize);
+		NFT_PIPAPO_AVX2_AND(10,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(11, lt,  7,  pg[7], bsize);
+		NFT_PIPAPO_AVX2_AND(12,  7,  8);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(13, lt,  8,  pg[8], bsize);
+		NFT_PIPAPO_AVX2_AND(14,  9, 10);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(0,  lt,  9,  pg[9], bsize);
+		NFT_PIPAPO_AVX2_AND(1,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(2,  lt, 10, pg[10], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 11, pg[11], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  13, 14);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(5,  lt, 12, pg[12], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(6,  lt, 13, pg[13], bsize);
+		NFT_PIPAPO_AVX2_AND(7,   0,  1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(8,  lt, 14, pg[14], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(10, lt, 15, pg[15], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  4,  5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(12, lt, 16, pg[16], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  6,  7);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(14, lt, 17, pg[17], bsize);
+
+		NFT_PIPAPO_AVX2_AND(0,   8,  9);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(1,  lt, 18, pg[18], bsize);
+		NFT_PIPAPO_AVX2_AND(2,  10, 11);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 19, pg[19], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  12, 13);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(5,  lt, 20, pg[20], bsize);
+		NFT_PIPAPO_AVX2_AND(6,  14,  0);
+		NFT_PIPAPO_AVX2_AND(7,   1,  2);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(8,  lt, 21, pg[21], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   3,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(10, lt, 22, pg[22], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(12, lt, 23, pg[23], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  7,  8);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(14, lt, 24, pg[24], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(0,  lt, 25, pg[25], bsize);
+		NFT_PIPAPO_AVX2_AND(1,   9, 10);
+		NFT_PIPAPO_AVX2_AND(2,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(3,  lt, 26, pg[26], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  13, 14);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(5,  lt, 27, pg[27], bsize);
+		NFT_PIPAPO_AVX2_AND(6,   0,  1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(7,  lt, 28, pg[28], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(8,  lt, 29, pg[29], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(10, lt, 30, pg[30], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  4,  5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD4(12, lt, 31, pg[31], bsize);
+
+		NFT_PIPAPO_AVX2_AND(0,   6,  7);
+		NFT_PIPAPO_AVX2_AND(1,   8,  9);
+		NFT_PIPAPO_AVX2_AND(2,  10, 11);
+		NFT_PIPAPO_AVX2_AND(3,  12,  0);
+
+		/* Stalls */
+		NFT_PIPAPO_AVX2_AND(4,   1,  2);
+		NFT_PIPAPO_AVX2_AND(5,   3,  4);
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(5, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 5);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_8b_1() - AVX2-based lookup for one eight-bit g=
roup
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 8-bit fields (i.e. protocol numbers).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 0, pkt[0], bsize);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0, lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+			NFT_PIPAPO_AVX2_AND(2, 0, 1);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(2, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 2);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_8b_2() - AVX2-based lookup for 2 eight-bit gro=
ups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 16-bit fields (i.e. ports).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0, lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 1, pkt[1], bsize);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		} else {
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt, 1, pkt[1], bsize);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(3, 0, 1);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(4, 3, 2);
+		}
+
+		/* Stall */
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_8b_4() - AVX2-based lookup for 4 eight-bit gro=
ups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 32-bit fields (i.e. IPv4 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0,  lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(1,  lt, 1, pkt[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2,  lt, 2, pkt[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(3,  lt, 3, pkt[3], bsize);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+			NFT_PIPAPO_AVX2_AND(5, 2, 3);
+			NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0,  lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2,  lt, 1, pkt[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(3,  lt, 2, pkt[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 3, pkt[3], bsize);
+
+			NFT_PIPAPO_AVX2_AND(5, 0, 1);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+			NFT_PIPAPO_AVX2_AND(6, 2, 3);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(7, 4, 5);
+			NFT_PIPAPO_AVX2_AND(0, 6, 7);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 0);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_8b_6() - AVX2-based lookup for 6 eight-bit gro=
ups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 48-bit fields (i.e. MAC addresses/EUI-48).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long=
 *fill,
+				       struct nft_pipapo_field *f, int offset,
+				       const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0,  lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(1,  lt, 1, pkt[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2,  lt, 2, pkt[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(3,  lt, 3, pkt[3], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 4, pkt[4], bsize);
+
+			NFT_PIPAPO_AVX2_AND(5, 0, 1);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(6,  lt, 6, pkt[5], bsize);
+			NFT_PIPAPO_AVX2_AND(7, 2, 3);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(0, 4, 5);
+			NFT_PIPAPO_AVX2_AND(1, 6, 7);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(0,  lt, 0, pkt[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(2,  lt, 1, pkt[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(3,  lt, 2, pkt[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(4,  lt, 3, pkt[3], bsize);
+
+			NFT_PIPAPO_AVX2_AND(5, 0, 1);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+			NFT_PIPAPO_AVX2_AND(6, 2, 3);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(7,  lt, 4, pkt[4], bsize);
+			NFT_PIPAPO_AVX2_AND(0, 4, 5);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD8(1,  lt, 5, pkt[5], bsize);
+			NFT_PIPAPO_AVX2_AND(2, 6, 7);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(3, 0, 1);
+			NFT_PIPAPO_AVX2_AND(4, 2, 3);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_8b_16() - AVX2-based lookup for 16 eight-bit g=
roups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * See nft_pipapo_avx2_lookup_4b_2().
+ *
+ * This is used for 128-bit fields (i.e. IPv6 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned lon=
g *fill,
+					struct nft_pipapo_field *f, int offset,
+					const u8 *pkt, bool first, bool last)
+{
+	int i, ret =3D -1, m256_size =3D f->bsize / NFT_PIPAPO_LONGS_PER_M256, =
b;
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (!first)
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt,  0,  pkt[0], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt,  1,  pkt[1], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt,  2,  pkt[2], bsize);
+		if (!first) {
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(1, 1, 0);
+		}
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(4, lt,  3,  pkt[3], bsize);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  4,  pkt[4], bsize);
+		NFT_PIPAPO_AVX2_AND(6, 1, 2);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  5,  pkt[5], bsize);
+		NFT_PIPAPO_AVX2_AND(0, 3, 4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt,  6,  pkt[6], bsize);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(2, lt,  7,  pkt[7], bsize);
+		NFT_PIPAPO_AVX2_AND(3, 5, 6);
+		NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt,  8,  pkt[8], bsize);
+
+		NFT_PIPAPO_AVX2_AND(6, 2, 3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt,  9,  pkt[9], bsize);
+		NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 10, pkt[10], bsize);
+		NFT_PIPAPO_AVX2_AND(2, 6, 7);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt, 11, pkt[11], bsize);
+		NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(5, lt, 12, pkt[12], bsize);
+		NFT_PIPAPO_AVX2_AND(6, 2, 3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(7, lt, 13, pkt[13], bsize);
+		NFT_PIPAPO_AVX2_AND(0, 4, 5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(1, lt, 14, pkt[14], bsize);
+		NFT_PIPAPO_AVX2_AND(2, 6, 7);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD8(3, lt, 15, pkt[15], bsize);
+		NFT_PIPAPO_AVX2_AND(4, 0, 1);
+
+		/* Stall */
+		NFT_PIPAPO_AVX2_AND(5, 2, 3);
+		NFT_PIPAPO_AVX2_AND(6, 4, 5);
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(6, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 6);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
+		if (last)
+			return b;
+
+		if (unlikely(ret =3D=3D -1))
+			ret =3D b / XSAVE_YMM_SIZE;
+
+		continue;
+
+nomatch:
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+		;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_slow() - Fallback function for uncommon field =
sizes
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @f:		Field, containing lookup and mapping tables
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ *
+ * This function should never be called, but is provided for the case th=
e field
+ * size doesn't match any of the known data types. Matching rate is
+ * substantially lower than AVX2 routines.
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_slow(unsigned long *map, unsigned long=
 *fill,
+					struct nft_pipapo_field *f, int offset,
+					const u8 *pkt, bool first, bool last)
+{
+	unsigned long *lt =3D f->lt, bsize =3D f->bsize;
+	int i, ret =3D -1, b;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+
+	if (first)
+		memset(map, 0xff, bsize * sizeof(*map));
+
+	for (i =3D offset; i < bsize; i++) {
+		if (f->bb =3D=3D 8)
+			pipapo_and_field_buckets_8bit(f, map, pkt);
+		else
+			pipapo_and_field_buckets_4bit(f, map, pkt);
+		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
+
+		b =3D pipapo_refill(map, bsize, f->rules, fill, f->mt, last);
+
+		if (last)
+			return b;
+
+		if (ret =3D=3D -1)
+			ret =3D b / XSAVE_YMM_SIZE;
+	}
+
+	return ret;
+}
+
+/**
+ * nft_pipapo_avx2_estimate() - Set size, space and lookup complexity
+ * @desc:	Set description, element count and field description used
+ * @features:	Flags: NFT_SET_INTERVAL needs to be there
+ * @est:	Storage for estimation data
+ *
+ * Return: true if set is compatible and AVX2 available, false otherwise=
.
+ */
+bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 featu=
res,
+			      struct nft_set_estimate *est)
+{
+	if (!(features & NFT_SET_INTERVAL) || desc->field_count <=3D 1)
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
+		return false;
+
+	est->size =3D pipapo_estimate_size(desc);
+	if (!est->size)
+		return false;
+
+	est->lookup =3D NFT_SET_CLASS_O_LOG_N;
+
+	est->space =3D NFT_SET_CLASS_O_N;
+
+	return true;
+}
+
+/**
+ * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
+ * @net:	Network namespace
+ * @set:	nftables API set representation
+ * @elem:	nftables API element representation containing key data
+ * @ext:	nftables API extension pointer, filled with matching reference
+ *
+ * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
+ *
+ * This implementation exploits the repetitive characteristic of the alg=
orithm
+ * to provide a fast, vectorised version using the AVX2 SIMD instruction=
 set.
+ *
+ * Return: true on match, false otherwise.
+ */
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set =
*set,
+			    const u32 *key, const struct nft_set_ext **ext)
+{
+	struct nft_pipapo *priv =3D nft_set_priv(set);
+	unsigned long *res, *fill, *scratch;
+	u8 genmask =3D nft_genmask_cur(net);
+	const u8 *rp =3D (const u8 *)key;
+	struct nft_pipapo_match *m;
+	struct nft_pipapo_field *f;
+	bool map_index;
+	int i, ret =3D 0;
+
+	m =3D rcu_dereference(priv->match);
+
+	/* This also protects access to all data related to scratch maps */
+	kernel_fpu_begin();
+
+	scratch =3D *raw_cpu_ptr(m->scratch_aligned);
+	if (unlikely(!scratch)) {
+		kernel_fpu_end();
+		return false;
+	}
+	map_index =3D raw_cpu_read(nft_pipapo_avx2_scratch_index);
+
+	res  =3D scratch + (map_index ? m->bsize_max : 0);
+	fill =3D scratch + (map_index ? 0 : m->bsize_max);
+
+	/* Starting map doesn't need to be set for this implementation */
+
+	nft_pipapo_avx2_prepare();
+
+next_match:
+	nft_pipapo_for_each_field(f, i, m) {
+		bool last =3D i =3D=3D m->field_count - 1, first =3D !i;
+
+#define NFT_SET_PIPAPO_AVX2_LOOKUP(b, n)				\
+		(ret =3D nft_pipapo_avx2_lookup_##b##b_##n(res, fill, f,	\
+							 ret, rp,	\
+							 first, last))
+
+		if (likely(f->bb =3D=3D 8)) {
+			if (f->groups =3D=3D 1) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 1);
+			} else if (f->groups =3D=3D 2) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 2);
+			} else if (f->groups =3D=3D 4) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 4);
+			} else if (f->groups =3D=3D 6) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 6);
+			} else if (f->groups =3D=3D 16) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(8, 16);
+			} else {
+				ret =3D nft_pipapo_avx2_lookup_slow(res, fill, f,
+								  ret, rp,
+								  first, last);
+			}
+		} else {
+			if (f->groups =3D=3D 2) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 2);
+			} else if (f->groups =3D=3D 4) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 4);
+			} else if (f->groups =3D=3D 8) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 8);
+			} else if (f->groups =3D=3D 12) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 12);
+			} else if (f->groups =3D=3D 32) {
+				NFT_SET_PIPAPO_AVX2_LOOKUP(4, 32);
+			} else {
+				ret =3D nft_pipapo_avx2_lookup_slow(res, fill, f,
+								  ret, rp,
+								  first, last);
+			}
+		}
+		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
+
+#undef NFT_SET_PIPAPO_AVX2_LOOKUP
+
+		if (ret < 0)
+			goto out;
+
+		if (last) {
+			*ext =3D &f->mt[ret].e->ext;
+			if (unlikely(nft_set_elem_expired(*ext) ||
+				     !nft_set_elem_active(*ext, genmask))) {
+				ret =3D 0;
+				goto next_match;
+			}
+
+			goto out;
+		}
+
+		swap(res, fill);
+		rp +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+	}
+
+out:
+	if (i % 2)
+		raw_cpu_write(nft_pipapo_avx2_scratch_index, !map_index);
+	kernel_fpu_end();
+
+	return ret >=3D 0;
+}
diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_=
pipapo_avx2.h
new file mode 100644
index 000000000000..396caf7bfca8
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo_avx2.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _NFT_SET_PIPAPO_AVX2_H
+
+#ifdef CONFIG_AS_AVX2
+#include <asm/fpu/xstate.h>
+#define NFT_PIPAPO_ALIGN	(XSAVE_YMM_SIZE / BITS_PER_BYTE)
+
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set =
*set,
+			    const u32 *key, const struct nft_set_ext **ext);
+bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 featu=
res,
+			      struct nft_set_estimate *est);
+#endif /* CONFIG_AS_AVX2 */
+
+#endif /* _NFT_SET_PIPAPO_AVX2_H */
--=20
2.25.1

