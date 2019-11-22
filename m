Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A7CC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959C020707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edAKzy1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKVNkn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47261 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727097AbfKVNkn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncVGfT0Ism3fRWw+Zkjt9ujG3P4GSEOvHEgvfe5Cb2I=;
        b=edAKzy1AhxVW+cqOip3HdCvCragSbxMzxEyI7IfmYO57y1xhYRZZe3NE2ar4Ip8B/uW9uk
        K6cS0AGd7ixT7tDkmCfBkM3WfWJk2+Cc1uxTTcV8hlBnBxLydn3tzOxfDXmYTs5ZhwNUar
        ezzmQ9e3R54EG6bq0aHY1N52AihQyVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-3I-gnLwIN6usDtdEs2oP4A-1; Fri, 22 Nov 2019 08:40:36 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D40A1852E4D;
        Fri, 22 Nov 2019 13:40:34 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE9781036C73;
        Fri, 22 Nov 2019 13:40:31 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 8/8] nft_set_pipapo: Introduce AVX2-based lookup implementation
Date:   Fri, 22 Nov 2019 14:40:07 +0100
Message-Id: <6158cddaa4f970fcff6ed307f0c3a5cf5b4bb1cb.1574428269.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 3I-gnLwIN6usDtdEs2oP4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
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
with pktgen, reports:

- for one AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB L2$):

TEST: performance
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):              10195687pps
    baseline hash (non-ranged entries):             6166047pps
    baseline rbtree (match on first field only):    2648166pps
    set with  1000 full, ranged entries:            5013920pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              10146446pps
    baseline hash (non-ranged entries):             5958857pps
    baseline rbtree (match on first field only):    3972543pps
    set with   100 full, ranged entries:            5032332pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):               9621089pps
    baseline hash (non-ranged entries):             4784304pps
    baseline rbtree (match on first field only):    1349369pps
    set with  1000 full, ranged entries:            2413250pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              10821583pps
    baseline hash (non-ranged entries):             6809399pps
    baseline rbtree (match on first field only):    2799538pps
    set with 30000 full, ranged entries:            1921039pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):               9460996pps
    baseline hash (non-ranged entries):             3893325pps
    baseline rbtree (match on first field only):    2919418pps
    set with    10 full, ranged entries:            2898623pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):               9578663pps
    baseline hash (non-ranged entries):             3705263pps
    baseline rbtree (match on first field only):    1342876pps
    set with  1000 full, ranged entries:            2005030pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              10153020pps
    baseline hash (non-ranged entries):             5145586pps
    baseline rbtree (match on first field only):    2664821pps
    set with  1000 full, ranged entries:            3922839pps

- for one Intel Core i7-6600U thread (3.4GHz, 64 KiB L1D$, 512 KiB L2$):

TEST: performance
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):              10229859pps
    baseline hash (non-ranged entries):             6160930pps
    baseline rbtree (match on first field only):    2926966pps
    set with  1000 full, ranged entries:            4812717pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              10234013pps
    baseline hash (non-ranged entries):             6164457pps
    baseline rbtree (match on first field only):    4019270pps
    set with   100 full, ranged entries:            5072830pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):               9603512pps
    baseline hash (non-ranged entries):             4771150pps
    baseline rbtree (match on first field only):    1610077pps
    set with  1000 full, ranged entries:            2942229pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              10912230pps
    baseline hash (non-ranged entries):             6906587pps
    baseline rbtree (match on first field only):    3156167pps
    set with 30000 full, ranged entries:            2440219pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):              10020213pps
    baseline hash (non-ranged entries):             3415258pps
    baseline rbtree (match on first field only):    3167192pps
    set with    10 full, ranged entries:            2422204pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):               9860087pps
    baseline hash (non-ranged entries):             3883861pps
    baseline rbtree (match on first field only):    1626784pps
    set with  1000 full, ranged entries:            2318861pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              10313285pps
    baseline hash (non-ranged entries):             5324213pps
    baseline rbtree (match on first field only):    2970661pps
    set with  1000 full, ranged entries:            4128105pps

A similar strategy could be easily reused to implement specialised
versions for other SIMD sets, and I plan to post at least a NEON
version at a later time.

The vectorised implementation is automatically selected whenever
the AVX2 feature is available, and this can be detected with the
following check:

=09[ $(uname -m) =3D "x86_64" ] && grep -q avx2 /proc/cpuinfo

In order to make set selection more explicit and visible, we might
at a later time export a different name, by introducing a new
attribute, e.g. NFTA_SET_OPS, as suggested by Phil Sutter on
netfilter-devel in <20180403211540.23700-3-phil@nwl.cc>.

v2:
 - extend scope of kernel_fpu_begin/end() to protect all accesses
   to scratch maps (Florian Westphal)
 - drop rcu_read_lock/unlock() from nft_pipapo_avx2_lookup(), it's
   already implied (Florian Westphal)
 - mention in commit message how to check if this set is used

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/netfilter/nf_tables_core.h |   1 +
 net/netfilter/Makefile                 |   3 +
 net/netfilter/nf_tables_set_core.c     |   6 +
 net/netfilter/nft_set_pipapo.c         |  25 +
 net/netfilter/nft_set_pipapo_avx2.c    | 838 +++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h    |  14 +
 6 files changed, 887 insertions(+)
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter=
/nf_tables_core.h
index 9759257ec8ec..6b7cdc0a592f 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -75,6 +75,7 @@ extern struct nft_set_type nft_set_hash_fast_type;
 extern struct nft_set_type nft_set_rbtree_type;
 extern struct nft_set_type nft_set_bitmap_type;
 extern struct nft_set_type nft_set_pipapo_type;
+extern struct nft_set_type nft_set_pipapo_avx2_type;
=20
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3f572e5a975e..847b759895fc 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -83,6 +83,9 @@ nf_tables-objs :=3D nf_tables_core.o nf_tables_api.o nft_=
chain_filter.o \
 nf_tables_set-objs :=3D nf_tables_set_core.o \
 =09=09      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
 =09=09      nft_set_pipapo.o
+ifneq (,$(findstring -DCONFIG_AS_AVX2=3D1,$(KBUILD_CFLAGS)))
+nf_tables_set-objs +=3D nft_set_pipapo_avx2.o
+endif
=20
 obj-$(CONFIG_NF_TABLES)=09=09+=3D nf_tables.o
 obj-$(CONFIG_NF_TABLES_SET)=09+=3D nf_tables_set.o
diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables_s=
et_core.c
index 586b621007eb..4fa8f610038c 100644
--- a/net/netfilter/nf_tables_set_core.c
+++ b/net/netfilter/nf_tables_set_core.c
@@ -9,6 +9,9 @@ static int __init nf_tables_set_module_init(void)
 =09nft_register_set(&nft_set_rhash_type);
 =09nft_register_set(&nft_set_bitmap_type);
 =09nft_register_set(&nft_set_rbtree_type);
+#ifdef CONFIG_AS_AVX2
+=09nft_register_set(&nft_set_pipapo_avx2_type);
+#endif
 =09nft_register_set(&nft_set_pipapo_type);
=20
 =09return 0;
@@ -17,6 +20,9 @@ static int __init nf_tables_set_module_init(void)
 static void __exit nf_tables_set_module_exit(void)
 {
 =09nft_unregister_set(&nft_set_pipapo_type);
+#ifdef CONFIG_AS_AVX2
+=09nft_unregister_set(&nft_set_pipapo_avx2_type);
+#endif
 =09nft_unregister_set(&nft_set_rbtree_type);
 =09nft_unregister_set(&nft_set_bitmap_type);
 =09nft_unregister_set(&nft_set_rhash_type);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.=
c
index 5076325b8093..48a738639777 100644
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
@@ -2138,3 +2139,27 @@ struct nft_set_type nft_set_pipapo_type __read_mostl=
y =3D {
 =09=09.elemsize=09=3D offsetof(struct nft_pipapo_elem, ext),
 =09},
 };
+
+#ifdef CONFIG_AS_AVX2
+struct nft_set_type nft_set_pipapo_avx2_type __read_mostly =3D {
+=09.owner=09=09=3D THIS_MODULE,
+=09.features=09=3D NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT |
+=09=09=09  NFT_SET_TIMEOUT | NFT_SET_SUBKEY,
+=09.ops=09=09=3D {
+=09=09.lookup=09=09=3D nft_pipapo_avx2_lookup,
+=09=09.insert=09=09=3D nft_pipapo_insert,
+=09=09.activate=09=3D nft_pipapo_activate,
+=09=09.deactivate=09=3D nft_pipapo_deactivate,
+=09=09.flush=09=09=3D nft_pipapo_flush,
+=09=09.remove=09=09=3D nft_pipapo_remove,
+=09=09.walk=09=09=3D nft_pipapo_walk,
+=09=09.get=09=09=3D nft_pipapo_get,
+=09=09.privsize=09=3D nft_pipapo_privsize,
+=09=09.estimate=09=3D nft_pipapo_avx2_estimate,
+=09=09.init=09=09=3D nft_pipapo_init,
+=09=09.destroy=09=3D nft_pipapo_destroy,
+=09=09.gc_init=09=3D nft_pipapo_gc_init,
+=09=09.elemsize=09=3D offsetof(struct nft_pipapo_elem, ext),
+=09},
+};
+#endif
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pi=
papo_avx2.c
new file mode 100644
index 000000000000..2d79673bf21e
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -0,0 +1,838 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* PIPAPO: PIle PAcket POlicies: AVX2 packet lookup routines
+ *
+ * Copyright (c) 2019 Red Hat GmbH
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
+#define NFT_PIPAPO_LONGS_PER_M256=09(XSAVE_YMM_SIZE / BITS_PER_LONG)
+
+/* Load from memory into YMM register with non-temporal hint ("stream load=
"),
+ * that is, don't fetch lines from memory into the cache. This avoids push=
ing
+ * precious packet data out of the cache hierarchy, and is appropriate whe=
n:
+ *
+ * - loading buckets from lookup tables, as they are not going to be used
+ *   again before packets are entirely classified
+ *
+ * - loading the result bitmap from the previous field, as it's never used
+ *   again
+ */
+#define NFT_PIPAPO_AVX2_LOAD(reg, loc)=09=09=09=09=09\
+=09asm volatile("vmovntdqa %0, %%ymm" #reg : : "m" (loc))
+
+/* Stream a single lookup table bucket into YMM register given lookup tabl=
e,
+ * group index, value of packet bits, bucket size.
+ */
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD(reg, lt, group, v, bsize)=09=09\
+=09NFT_PIPAPO_AVX2_LOAD(reg,=09=09=09=09=09\
+=09=09=09     lt[((group) * NFT_PIPAPO_BUCKETS + (v)) * (bsize)])
+
+/* Bitwise AND: the staple operation of this algorithm */
+#define NFT_PIPAPO_AVX2_AND(dst, a, b)=09=09=09=09=09\
+=09asm volatile("vpand %ymm" #a ", %ymm" #b ", %ymm" #dst)
+
+/* Jump to label if @reg is zero */
+#define NFT_PIPAPO_AVX2_NOMATCH_GOTO(reg, label)=09=09=09\
+=09asm_volatile_goto("vptest %%ymm" #reg ", %%ymm" #reg ";"=09\
+=09=09=09  "je %l[" #label "]" : : : : label)
+
+/* Store 256 bits from YMM register into memory. Contrary to bucket load
+ * operation, we don't bypass the cache here, as stored matching results
+ * are always used shortly after.
+ */
+#define NFT_PIPAPO_AVX2_STORE(loc, reg)=09=09=09=09=09\
+=09asm volatile("vmovdqa %%ymm" #reg ", %0" : "=3Dm" (loc))
+
+/* Zero out a complete YMM register, @reg */
+#define NFT_PIPAPO_AVX2_ZERO(reg)=09=09=09=09=09\
+=09asm volatile("vpxor %ymm" #reg ", %ymm" #reg ", %ymm" #reg)
+
+/* Current working bitmap index, toggled between field matches */
+static DEFINE_PER_CPU(bool, nft_pipapo_avx2_scratch_index);
+
+/**
+ * nft_pipapo_avx2_prepare() - Prepare before main algorithm body
+ *
+ * This zeroes out ymm15, which is later used whenever we need to clear a
+ * memory location, by storing its content into memory.
+ */
+static void nft_pipapo_avx2_prepare(void)
+{
+=09NFT_PIPAPO_AVX2_ZERO(15);
+}
+
+/**
+ * nft_pipapo_avx2_fill() - Fill a bitmap region with ones
+ * @data:=09Base memory area
+ * @start:=09First bit to set
+ * @len:=09Count of bits to fill
+ *
+ * This is nothing else than a version of bitmap_set(), as used e.g. by
+ * pipapo_refill(), tailored for the microarchitectures using it and bette=
r
+ * suited for the specific usage: it's very likely that we'll set a small =
number
+ * of bits, not crossing a word boundary, and correct branch prediction is
+ * critical here.
+ *
+ * This function doesn't actually use any AVX2 instruction.
+ */
+static void nft_pipapo_avx2_fill(unsigned long *data, int start, int len)
+{
+=09int offset =3D start % BITS_PER_LONG;
+=09unsigned long mask;
+
+=09data +=3D start / BITS_PER_LONG;
+
+=09if (likely(len =3D=3D 1)) {
+=09=09*data |=3D BIT(offset);
+=09=09return;
+=09}
+
+=09if (likely(len < BITS_PER_LONG || offset)) {
+=09=09if (likely(len + offset <=3D BITS_PER_LONG)) {
+=09=09=09*data |=3D GENMASK(len - 1 + offset, offset);
+=09=09=09return;
+=09=09}
+
+=09=09*data |=3D ~0UL << offset;
+=09=09len -=3D BITS_PER_LONG - offset;
+=09=09data++;
+
+=09=09if (len <=3D BITS_PER_LONG) {
+=09=09=09mask =3D ~0UL >> (BITS_PER_LONG - len);
+=09=09=09*data |=3D mask;
+=09=09=09return;
+=09=09}
+=09}
+
+=09memset(data, 0xff, len / BITS_PER_BYTE);
+=09data +=3D len / BITS_PER_LONG;
+
+=09len %=3D BITS_PER_LONG;
+=09if (len)
+=09=09*data |=3D ~0UL >> (BITS_PER_LONG - len);
+}
+
+/**
+ * nft_pipapo_avx2_refill() - Scan bitmap, select mapping table item, set =
bits
+ * @offset:=09Start from given bitmap (equivalent to bucket) offset, in lo=
ngs
+ * @map:=09Bitmap to be scanned for set bits
+ * @dst:=09Destination bitmap
+ * @mt:=09=09Mapping table containing bit set specifiers
+ * @len:=09Length of bitmap in longs
+ * @last:=09Return index of first set bit, if this is the last field
+ *
+ * This is an alternative implementation of pipapo_refill() suitable for u=
sage
+ * with AVX2 lookup routines: we know there are four words to be scanned, =
at
+ * a given offset inside the map, for each matching iteration.
+ *
+ * This function doesn't actually use any AVX2 instruction.
+ *
+ * Return: first set bit index if @last, index of first filled word otherw=
ise.
+ */
+static int nft_pipapo_avx2_refill(int offset, unsigned long *map,
+=09=09=09=09  unsigned long *dst,
+=09=09=09=09  union nft_pipapo_map_bucket *mt, bool last)
+{
+=09int ret =3D -1;
+
+#define NFT_PIPAPO_AVX2_REFILL_ONE_WORD(x)=09=09=09=09\
+=09do {=09=09=09=09=09=09=09=09\
+=09=09while (map[(x)]) {=09=09=09=09=09\
+=09=09=09int r =3D __builtin_ctzl(map[(x)]);=09=09\
+=09=09=09int i =3D (offset + (x)) * BITS_PER_LONG + r;=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09=09if (last)=09=09=09=09=09\
+=09=09=09=09return i;=09=09=09=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09=09nft_pipapo_avx2_fill(dst, mt[i].to, mt[i].n);=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09=09if (ret =3D=3D -1)=09=09=09=09=09\
+=09=09=09=09ret =3D mt[i].to;=09=09=09=09\
+=09=09=09=09=09=09=09=09=09\
+=09=09=09map[(x)] &=3D ~(1UL << r);=09=09=09\
+=09=09}=09=09=09=09=09=09=09\
+=09} while (0)
+
+=09NFT_PIPAPO_AVX2_REFILL_ONE_WORD(0);
+=09NFT_PIPAPO_AVX2_REFILL_ONE_WORD(1);
+=09NFT_PIPAPO_AVX2_REFILL_ONE_WORD(2);
+=09NFT_PIPAPO_AVX2_REFILL_ONE_WORD(3);
+#undef NFT_PIPAPO_AVX2_REFILL_ONE_WORD
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup2() - AVX2-based lookup for 2 four-bit groups
+ * @map:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @pkt:=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * Load buckets from lookup table corresponding to the values of each 4-bi=
t
+ * group of packet bytes, and perform a bitwise intersection between them.=
 If
+ * this is the first field in the set, simply AND the buckets together
+ * (equivalent to using an all-ones starting bitmap), use the provided sta=
rting
+ * bitmap otherwise. Then call nft_pipapo_avx2_refill() to generate the ne=
xt
+ * working bitmap, @fill.
+ *
+ * This is used for 8-bit fields (i.e. protocol numbers).
+ *
+ * Out-of-order (and superscalar) execution is vital here, so it's critica=
l to
+ * avoid false data dependencies. CPU and compiler could (mostly) take car=
e of
+ * this on their own, but the operation ordering is explicitly given here =
with
+ * a likely execution order in mind, to highlight possible stalls. That's =
why
+ * a number of logically distinct operations (i.e. loading buckets, inters=
ecting
+ * buckets) are interleaved.
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup2(unsigned long *map, unsigned long *fill=
,
+=09=09=09=09   unsigned long *lt,
+=09=09=09=09   union nft_pipapo_map_bucket *mt,
+=09=09=09=09   unsigned long bsize, const u8 *pkt,
+=09=09=09=09   bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+=09u8 pg[2] =3D { pkt[0] >> 4, pkt[0] & 0xf };
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+=09for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+=09=09int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+=09=09if (first) {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(4, 0, 1);
+=09=09} else {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+=09=09=09NFT_PIPAPO_AVX2_LOAD(2, map[i_ul]);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(2, nothing);
+=09=09=09NFT_PIPAPO_AVX2_AND(3, 0, 1);
+=09=09=09NFT_PIPAPO_AVX2_AND(4, 2, 3);
+=09=09}
+
+=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
+
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (unlikely(ret =3D=3D -1))
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+
+=09=09continue;
+nomatch:
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+=09=09;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup4() - AVX2-based lookup for 4 four-bit groups
+ * @map:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @pkt:=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 16-bit fields (i.e. ports).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup4(unsigned long *map, unsigned long *fill=
,
+=09=09=09=09   unsigned long *lt,
+=09=09=09=09   union nft_pipapo_map_bucket *mt,
+=09=09=09=09   unsigned long bsize, const u8 *pkt,
+=09=09=09=09   bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+=09u8 pg[4] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+=09for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+=09=09int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+=09=09if (first) {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2, lt, 2, pg[2], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3, lt, 3, pg[3], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(4, 0, 1);
+=09=09=09NFT_PIPAPO_AVX2_AND(5, 2, 3);
+=09=09=09NFT_PIPAPO_AVX2_AND(7, 4, 5);
+=09=09} else {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+
+=09=09=09NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2, lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3, lt, 2, pg[2], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(4, lt, 3, pg[3], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(5, 0, 1);
+
+=09=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+=09=09=09NFT_PIPAPO_AVX2_AND(6, 2, 3);
+=09=09=09NFT_PIPAPO_AVX2_AND(7, 4, 5);
+=09=09=09/* Stall */
+=09=09=09NFT_PIPAPO_AVX2_AND(7, 6, 7);
+=09=09}
+
+=09=09/* Stall */
+=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(7, nomatch);
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 7);
+
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (unlikely(ret =3D=3D -1))
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+
+=09=09continue;
+nomatch:
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+=09=09;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup8() - AVX2-based lookup for 8 four-bit groups
+ * @map:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @pkt:=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 32-bit fields (i.e. IPv4 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup8(unsigned long *map, unsigned long *fill=
,
+=09=09=09=09   unsigned long *lt,
+=09=09=09=09   union nft_pipapo_map_bucket *mt,
+=09=09=09=09   unsigned long bsize, const u8 *pkt,
+=09=09=09=09   bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+=09u8 pg[8] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf,
+=09=09     pkt[2] >> 4, pkt[2] & 0xf, pkt[3] >> 4, pkt[3] & 0xf };
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+=09for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+=09=09int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+=09=09if (first) {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 0, pg[0], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 2, pg[2], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 3, pg[3], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt, 4, pg[4], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(5,   0,  1);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 5, pg[5], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 6, pg[6], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(8,   2,  3);
+=09=09=09NFT_PIPAPO_AVX2_AND(9,   4,  5);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 7, pg[7], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(11,  6,  7);
+=09=09=09NFT_PIPAPO_AVX2_AND(12,  8,  9);
+=09=09=09NFT_PIPAPO_AVX2_AND(13, 10, 11);
+
+=09=09=09/* Stall */
+=09=09=09NFT_PIPAPO_AVX2_AND(1,  12, 13);
+=09=09} else {
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 0, pg[0], bsize);
+=09=09=09NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 1, pg[1], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 2, pg[2], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt, 3, pg[3], bsize);
+
+=09=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+=09=09=09NFT_PIPAPO_AVX2_AND(5,   0,  1);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 4, pg[4], bsize);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 5, pg[5], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(8,   2,  3);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(9,  lt, 6, pg[6], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(10,  4,  5);
+=09=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(11, lt, 7, pg[7], bsize);
+=09=09=09NFT_PIPAPO_AVX2_AND(12,  6,  7);
+=09=09=09NFT_PIPAPO_AVX2_AND(13,  8,  9);
+=09=09=09NFT_PIPAPO_AVX2_AND(14, 10, 11);
+
+=09=09=09/* Stall */
+=09=09=09NFT_PIPAPO_AVX2_AND(1,  12, 13);
+=09=09=09NFT_PIPAPO_AVX2_AND(1,   1, 14);
+=09=09}
+
+=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nomatch);
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 1);
+
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (unlikely(ret =3D=3D -1))
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+
+=09=09continue;
+
+nomatch:
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+=09=09;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup12() - AVX2-based lookup for 12 four-bit groups
+ * @map:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @pkt:=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 48-bit fields (i.e. MAC addresses/EUI-48).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup12(unsigned long *map, unsigned long *fil=
l,
+=09=09=09=09    unsigned long *lt,
+=09=09=09=09    union nft_pipapo_map_bucket *mt,
+=09=09=09=09    unsigned long bsize, const u8 *pkt,
+=09=09=09=09    bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+=09u8 pg[12] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf,
+=09=09      pkt[2] >> 4, pkt[2] & 0xf, pkt[3] >> 4, pkt[3] & 0xf,
+=09=09      pkt[4] >> 4, pkt[4] & 0xf, pkt[5] >> 4, pkt[5] & 0xf };
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+=09for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+=09=09int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+=09=09if (!first)
+=09=09=09NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt,  0,  pg[0], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt,  1,  pg[1], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt,  2,  pg[2], bsize);
+
+=09=09if (!first) {
+=09=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+=09=09=09NFT_PIPAPO_AVX2_AND(1, 1, 0);
+=09=09}
+
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt,  3,  pg[3], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt,  4,  pg[4], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(6,   2,  3);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt,  5,  pg[5], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt,  6,  pg[6], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(9,   1,  4);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt,  7,  pg[7], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(11,  5,  6);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt,  8,  pg[8], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(13,  7,  8);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt,  9,  pg[9], bsize);
+
+=09=09NFT_PIPAPO_AVX2_AND(0,   9, 10);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 10,  pg[10], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(2,  11, 12);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 11,  pg[11], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(4,  13, 14);
+=09=09NFT_PIPAPO_AVX2_AND(5,   0,  1);
+
+=09=09NFT_PIPAPO_AVX2_AND(6,   2,  3);
+
+=09=09/* Stalls */
+=09=09NFT_PIPAPO_AVX2_AND(7,   4,  5);
+=09=09NFT_PIPAPO_AVX2_AND(8,   6,  7);
+
+=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(8, nomatch);
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 8);
+
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (unlikely(ret =3D=3D -1))
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+
+=09=09continue;
+nomatch:
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+=09=09;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup32() - AVX2-based lookup for 32 four-bit groups
+ * @map:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @pkt:=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 128-bit fields (i.e. IPv6 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup32(unsigned long *map, unsigned long *fil=
l,
+=09=09=09=09    unsigned long *lt,
+=09=09=09=09    union nft_pipapo_map_bucket *mt,
+=09=09=09=09    unsigned long bsize, const u8 *pkt,
+=09=09=09=09    bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+=09u8 pg[32] =3D {  pkt[0] >> 4,  pkt[0] & 0xf,  pkt[1] >> 4,  pkt[1] & 0x=
f,
+=09=09       pkt[2] >> 4,  pkt[2] & 0xf,  pkt[3] >> 4,  pkt[3] & 0xf,
+=09=09       pkt[4] >> 4,  pkt[4] & 0xf,  pkt[5] >> 4,  pkt[5] & 0xf,
+=09=09       pkt[6] >> 4,  pkt[6] & 0xf,  pkt[7] >> 4,  pkt[7] & 0xf,
+=09=09       pkt[8] >> 4,  pkt[8] & 0xf,  pkt[9] >> 4,  pkt[9] & 0xf,
+=09=09      pkt[10] >> 4, pkt[10] & 0xf, pkt[11] >> 4, pkt[11] & 0xf,
+=09=09      pkt[12] >> 4, pkt[12] & 0xf, pkt[13] >> 4, pkt[13] & 0xf,
+=09=09      pkt[14] >> 4, pkt[14] & 0xf, pkt[15] >> 4, pkt[15] & 0xf,
+=09=09    };
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+=09for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+=09=09int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+=09=09if (!first)
+=09=09=09NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt,  0,  pg[0], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt,  1,  pg[1], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt,  2,  pg[2], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt,  3,  pg[3], bsize);
+=09=09if (!first) {
+=09=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+=09=09=09NFT_PIPAPO_AVX2_AND(1, 1, 0);
+=09=09}
+
+=09=09NFT_PIPAPO_AVX2_AND(5,   2,  3);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt,  4,  pg[4], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt,  5,  pg[5], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(8,   1,  4);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(9,  lt,  6,  pg[6], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(10,  5,  6);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(11, lt,  7,  pg[7], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(12,  7,  8);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(13, lt,  8,  pg[8], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(14,  9, 10);
+
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt,  9,  pg[9], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(1,  11, 12);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 10, pg[10], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 11, pg[11], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(4,  13, 14);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 12, pg[12], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 13, pg[13], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(7,   0,  1);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 14, pg[14], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(9,   2,  3);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 15, pg[15], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(11,  4,  5);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 16, pg[16], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(13,  6,  7);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt, 17, pg[17], bsize);
+
+=09=09NFT_PIPAPO_AVX2_AND(0,   8,  9);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 18, pg[18], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(2,  10, 11);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 19, pg[19], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(4,  12, 13);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 20, pg[20], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(6,  14,  0);
+=09=09NFT_PIPAPO_AVX2_AND(7,   1,  2);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 21, pg[21], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(9,   3,  4);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 22, pg[22], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(11,  5,  6);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 23, pg[23], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(13,  7,  8);
+
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt, 24, pg[24], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 25, pg[25], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(1,   9, 10);
+=09=09NFT_PIPAPO_AVX2_AND(2,  11, 12);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 26, pg[26], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(4,  13, 14);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 27, pg[27], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(6,   0,  1);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 28, pg[28], bsize);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 29, pg[29], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(9,   2,  3);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 30, pg[30], bsize);
+=09=09NFT_PIPAPO_AVX2_AND(11,  4,  5);
+=09=09NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 31, pg[31], bsize);
+
+=09=09NFT_PIPAPO_AVX2_AND(0,   6,  7);
+=09=09NFT_PIPAPO_AVX2_AND(1,   8,  9);
+=09=09NFT_PIPAPO_AVX2_AND(2,  10, 11);
+=09=09NFT_PIPAPO_AVX2_AND(3,  12,  0);
+
+=09=09/* Stalls */
+=09=09NFT_PIPAPO_AVX2_AND(4,   1,  2);
+=09=09NFT_PIPAPO_AVX2_AND(5,   3,  4);
+
+=09=09NFT_PIPAPO_AVX2_NOMATCH_GOTO(5, nomatch);
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 5);
+
+=09=09b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (unlikely(ret =3D=3D -1))
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+
+=09=09continue;
+nomatch:
+=09=09NFT_PIPAPO_AVX2_STORE(map[i_ul], 15);
+nothing:
+=09=09;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_lookup_noavx2() - Fallback function for uncommon field =
sizes
+ * @f:=09=09Field to be matched
+ * @res:=09Previous match result, used as initial bitmap
+ * @fill:=09Destination bitmap to be filled with current match result
+ * @lt:=09=09Lookup table for this field
+ * @mt:=09=09Mapping table for this field
+ * @bsize:=09Bucket size for this lookup table, in longs
+ * @rp:=09=09Packet data, pointer to input nftables register
+ * @first:=09If this is the first field, don't source previous result
+ * @last:=09Last field: stop at the first match and return bit index
+ * @offset:=09Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * This function should never be called, but is provided for the case the =
field
+ * size doesn't match any of the known data types. Matching rate is
+ * substantially lower than AVX2 routines.
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first l=
ong
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup_noavx2(struct nft_pipapo_field *f,
+=09=09=09=09=09 unsigned long *res,
+=09=09=09=09=09 unsigned long *fill, unsigned long *lt,
+=09=09=09=09=09 union nft_pipapo_map_bucket *mt,
+=09=09=09=09=09 unsigned long bsize, const u8 *rp,
+=09=09=09=09=09 bool first, bool last, int offset)
+{
+=09int i, ret =3D -1, b;
+
+=09lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+
+=09if (first)
+=09=09memset(res, 0xff, bsize * sizeof(*res));
+
+=09for (i =3D offset; i < bsize; i++) {
+=09=09pipapo_and_field_buckets(f, res, rp);
+
+=09=09b =3D pipapo_refill(res, bsize, f->rules, fill, mt, last);
+
+=09=09if (last)
+=09=09=09return b;
+
+=09=09if (ret =3D=3D -1)
+=09=09=09ret =3D b / XSAVE_YMM_SIZE;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_avx2_estimate() - Set size, space and lookup complexity
+ * @desc:=09Set description, initial element count used here
+ * @features:=09Flags: NFT_SET_SUBKEY needs to be there
+ * @est:=09Storage for estimation data
+ *
+ * Return: true if @features match and AVX2 is available, false otherwise.
+ */
+bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 feature=
s,
+=09=09=09      struct nft_set_estimate *est)
+{
+=09if (!(features & NFT_SET_SUBKEY))
+=09=09return false;
+
+=09if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
+=09=09return false;
+
+=09est->size =3D pipapo_estimate_size(desc->size);
+=09est->lookup =3D NFT_SET_CLASS_O_LOG_N;
+=09est->space =3D NFT_SET_CLASS_O_N;
+
+=09return true;
+}
+
+/**
+ * nft_pipapo_avx2_lookup() - Lookup function for AVX2 implementation
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ * @ext:=09nftables API extension pointer, filled with matching reference
+ *
+ * For more details, see DOC: Theory of Operation in nft_set_pipapo.c.
+ *
+ * This implementation exploits the repetitive characteristic of the algor=
ithm
+ * to provide a fast, vectorised version using the AVX2 SIMD instruction s=
et.
+ *
+ * Return: true on match, false otherwise.
+ */
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *s=
et,
+=09=09=09    const u32 *key, const struct nft_set_ext **ext)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09unsigned long *res, *fill, *scratch;
+=09u8 genmask =3D nft_genmask_cur(net);
+=09const u8 *rp =3D (const u8 *)key;
+=09struct nft_pipapo_match *m;
+=09struct nft_pipapo_field *f;
+=09bool map_index;
+=09int i, ret =3D 0;
+
+=09m =3D rcu_dereference(priv->match);
+
+=09/* This also protects access to all data related to scratch maps */
+=09kernel_fpu_begin();
+
+=09if (unlikely(!m || !*raw_cpu_ptr(m->scratch))) {
+=09=09kernel_fpu_end();
+=09=09return false;
+=09}
+
+=09scratch =3D *raw_cpu_ptr(m->scratch_aligned);
+=09map_index =3D raw_cpu_read(nft_pipapo_avx2_scratch_index);
+
+=09res  =3D scratch + (map_index ? m->bsize_max : 0);
+=09fill =3D scratch + (map_index ? 0 : m->bsize_max);
+
+=09/* Starting map doesn't need to be set for this implementation */
+
+=09nft_pipapo_avx2_prepare();
+
+next_match:
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09bool last =3D i =3D=3D m->field_count - 1, first =3D !i;
+
+#define NFT_SET_PIPAPO_AVX2_LOOKUP(n)=09=09=09=09=09\
+=09=09(ret =3D nft_pipapo_avx2_lookup ##n(res, fill,=09=09\
+=09=09=09=09=09=09  f->lt_aligned, f->mt,=09\
+=09=09=09=09=09=09  f->bsize, rp,=09=09\
+=09=09=09=09=09=09  first, last, ret))
+
+=09=09if (f->groups =3D=3D 2) {
+=09=09=09NFT_SET_PIPAPO_AVX2_LOOKUP(2);
+=09=09} else if (f->groups =3D=3D 4) {
+=09=09=09NFT_SET_PIPAPO_AVX2_LOOKUP(4);
+=09=09} else if (f->groups =3D=3D 8) {
+=09=09=09NFT_SET_PIPAPO_AVX2_LOOKUP(8);
+=09=09} else if (f->groups =3D=3D 12) {
+=09=09=09NFT_SET_PIPAPO_AVX2_LOOKUP(12);
+=09=09} else if (f->groups =3D=3D 32) {
+=09=09=09NFT_SET_PIPAPO_AVX2_LOOKUP(32);
+=09=09} else {
+=09=09=09ret =3D nft_pipapo_avx2_lookup_noavx2(f, res, fill,
+=09=09=09=09=09=09=09    f->lt_aligned,
+=09=09=09=09=09=09=09    f->mt, f->bsize,
+=09=09=09=09=09=09=09    rp,
+=09=09=09=09=09=09=09    first, last, ret);
+=09=09}
+#undef NFT_SET_PIPAPO_AVX2_LOOKUP
+
+=09=09if (ret < 0)
+=09=09=09goto out;
+
+=09=09if (last) {
+=09=09=09*ext =3D &f->mt[ret].e->ext;
+=09=09=09if (unlikely(nft_set_elem_expired(*ext) ||
+=09=09=09=09     !nft_set_elem_active(*ext, genmask))) {
+=09=09=09=09ret =3D 0;
+=09=09=09=09goto next_match;
+=09=09=09}
+
+=09=09=09goto out;
+=09=09}
+
+=09=09map_index =3D !map_index;
+=09=09swap(res, fill);
+=09=09rp +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09}
+
+out:
+=09raw_cpu_write(nft_pipapo_avx2_scratch_index, map_index);
+=09kernel_fpu_end();
+
+=09return ret >=3D 0;
+}
diff --git a/net/netfilter/nft_set_pipapo_avx2.h b/net/netfilter/nft_set_pi=
papo_avx2.h
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
+#define NFT_PIPAPO_ALIGN=09(XSAVE_YMM_SIZE / BITS_PER_BYTE)
+
+bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *s=
et,
+=09=09=09    const u32 *key, const struct nft_set_ext **ext);
+bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 feature=
s,
+=09=09=09      struct nft_set_estimate *est);
+#endif /* CONFIG_AS_AVX2 */
+
+#endif /* _NFT_SET_PIPAPO_AVX2_H */
--=20
2.20.1

