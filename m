Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4DCC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA8AF20663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VO3Mi1c3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgASNeC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:34:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51915 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726816AbgASNeC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoiezClx+5eizk8CypAa34wHsdtMurgmziH4NVyFRxM=;
        b=VO3Mi1c3LkXuqHXNf14Md290wHxtrxzInt9/kmFi082SiEbdr7RrGvpwqVvwx0vhoEtta8
        8AZAYWmFDoE3yQ3JCX19+/gS2RnUqCzcgLCw+aDJUllhnyoFzGgiJwWaXslIP6S5TMIXB4
        I3YxrocN9XaGS5l11rbCANvGTFKaXYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-PyLi04NQO0-4c8GB8PNjyg-1; Sun, 19 Jan 2020 08:33:53 -0500
X-MC-Unique: PyLi04NQO0-4c8GB8PNjyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC35C18A6EC0;
        Sun, 19 Jan 2020 13:33:51 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 603ED5D9CA;
        Sun, 19 Jan 2020 13:33:49 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v3 9/9] nft_set_pipapo: Introduce AVX2-based lookup implementation
Date:   Sun, 19 Jan 2020 14:33:21 +0100
Message-Id: <cec6cc894c8472e9c78c998e8058a4774f52d6a3.1579434906.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579434906.git.sbrivio@redhat.com>
References: <cover.1579434906.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

- for one AMD Epyc 7402 thread (3.35GHz, 768 KiB L1D$, 12 MiB L2$):
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):              13816909pps
    baseline hash (non-ranged entries):             7706821pps
    baseline rbtree (match on first field only):    3719979pps
    set with  1000 full, ranged entries:            5843256pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              13440355pps
    baseline hash (non-ranged entries):             7755855pps
    baseline rbtree (match on first field only):    5404151pps
    set with   100 full, ranged entries:            6274637pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):              12695318pps
    baseline hash (non-ranged entries):             5998414pps
    baseline rbtree (match on first field only):    1704466pps
    set with  1000 full, ranged entries:            3258636pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              14045198pps
    baseline hash (non-ranged entries):             8586447pps
    baseline rbtree (match on first field only):    3811115pps
    set with 30000 full, ranged entries:            2200493pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):              12644024pps
    baseline hash (non-ranged entries):             4834372pps
    baseline rbtree (match on first field only):    3654772pps
    set with    10 full, ranged entries:            3655568pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):              12545632pps
    baseline hash (non-ranged entries):             4656663pps
    baseline rbtree (match on first field only):    1713780pps
    set with  1000 full, ranged entries:            2529071pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              13766991pps
    baseline hash (non-ranged entries):             6440069pps
    baseline rbtree (match on first field only):    3739526pps
    set with  1000 full, ranged entries:            4818210pps

- for one AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB L2$):
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):              10170346pps
    baseline hash (non-ranged entries):             6214729pps
    baseline rbtree (match on first field only):    2589686pps
    set with  1000 full, ranged entries:            4695300pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              10162240pps
    baseline hash (non-ranged entries):             6199651pps
    baseline rbtree (match on first field only):    4176819pps
    set with   100 full, ranged entries:            4884376pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):               9732630pps
    baseline hash (non-ranged entries):             4747333pps
    baseline rbtree (match on first field only):    1376541pps
    set with  1000 full, ranged entries:            2486028pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              10682224pps
    baseline hash (non-ranged entries):             6872565pps
    baseline rbtree (match on first field only):    2793442pps
    set with 30000 full, ranged entries:            1876571pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):               9718917pps
    baseline hash (non-ranged entries):             3969930pps
    baseline rbtree (match on first field only):    3082588pps
    set with    10 full, ranged entries:            2988231pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):               9754800pps
    baseline hash (non-ranged entries):             3810961pps
    baseline rbtree (match on first field only):    1365740pps
    set with  1000 full, ranged entries:            1967771pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              10206690pps
    baseline hash (non-ranged entries):             5237175pps
    baseline rbtree (match on first field only):    2975866pps
    set with  1000 full, ranged entries:            3896154pps

- for one Intel Core i7-6600U thread (3.4GHz, 64 KiB L1D$, 512 KiB L2$):
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):              10021039pps
    baseline hash (non-ranged entries):             6061766pps
    baseline rbtree (match on first field only):    3304312pps
    set with  1000 full, ranged entries:            4844887pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              10865207pps
    baseline hash (non-ranged entries):             6435691pps
    baseline rbtree (match on first field only):    4861128pps
    set with   100 full, ranged entries:            5246583pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):              10173990pps
    baseline hash (non-ranged entries):             4992955pps
    baseline rbtree (match on first field only):    1769058pps
    set with  1000 full, ranged entries:            3186628pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              10680118pps
    baseline hash (non-ranged entries):             7127671pps
    baseline rbtree (match on first field only):    4001820pps
    set with 30000 full, ranged entries:            2591677pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):               9932346pps
    baseline hash (non-ranged entries):             4216648pps
    baseline rbtree (match on first field only):    3414029pps
    set with    10 full, ranged entries:            3164909pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):               9967056pps
    baseline hash (non-ranged entries):             4024868pps
    baseline rbtree (match on first field only):    1777420pps
    set with  1000 full, ranged entries:            2457853pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              10702441pps
    baseline hash (non-ranged entries):             5615505pps
    baseline rbtree (match on first field only):    3488851pps
    set with  1000 full, ranged entries:            4257577pps

A similar strategy could be easily reused to implement specialised
versions for other SIMD sets, and I plan to post at least a NEON
version at a later time.

The vectorised implementation is automatically selected whenever
the AVX2 feature is available, and this can be detected with the
following check:

	[ $(uname -m) =3D "x86_64" ] && grep -q avx2 /proc/cpuinfo

In order to make set selection more explicit and visible, we might
at a later time export a different name, by introducing a new
attribute, e.g. NFTA_SET_OPS, as suggested by Phil Sutter on
netfilter-devel in <20180403211540.23700-3-phil@nwl.cc>.

v3:
 - update matching rate data in commit message
 - skip AVX2 check in Makefile for i386
   (kbuild test robot <lkp@intel.com>)
v2:
 - extend scope of kernel_fpu_begin/end() to protect all accesses
   to scratch maps (Florian Westphal)
 - drop rcu_read_lock/unlock() from nft_pipapo_avx2_lookup(), it's
   already implied (Florian Westphal)
 - mention in commit message how to check if this set is used

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/netfilter/nf_tables_core.h |   1 +
 net/netfilter/Makefile                 |   5 +
 net/netfilter/nf_tables_set_core.c     |   6 +
 net/netfilter/nft_set_pipapo.c         |  25 +
 net/netfilter/nft_set_pipapo_avx2.c    | 842 +++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h    |  14 +
 6 files changed, 893 insertions(+)
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilt=
er/nf_tables_core.h
index 29e7e1021267..549d5f9ea8c3 100644
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
index 3f572e5a975e..4c1896943f6e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -83,6 +83,11 @@ nf_tables-objs :=3D nf_tables_core.o nf_tables_api.o n=
ft_chain_filter.o \
 nf_tables_set-objs :=3D nf_tables_set_core.o \
 		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
 		      nft_set_pipapo.o
+ifeq ($(ARCH),x86_64)
+ifneq (,$(findstring -DCONFIG_AS_AVX2=3D1,$(KBUILD_CFLAGS)))
+nf_tables_set-objs +=3D nft_set_pipapo_avx2.o
+endif
+endif
=20
 obj-$(CONFIG_NF_TABLES)		+=3D nf_tables.o
 obj-$(CONFIG_NF_TABLES_SET)	+=3D nf_tables_set.o
diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables=
_set_core.c
index 586b621007eb..4fa8f610038c 100644
--- a/net/netfilter/nf_tables_set_core.c
+++ b/net/netfilter/nf_tables_set_core.c
@@ -9,6 +9,9 @@ static int __init nf_tables_set_module_init(void)
 	nft_register_set(&nft_set_rhash_type);
 	nft_register_set(&nft_set_bitmap_type);
 	nft_register_set(&nft_set_rbtree_type);
+#ifdef CONFIG_AS_AVX2
+	nft_register_set(&nft_set_pipapo_avx2_type);
+#endif
 	nft_register_set(&nft_set_pipapo_type);
=20
 	return 0;
@@ -17,6 +20,9 @@ static int __init nf_tables_set_module_init(void)
 static void __exit nf_tables_set_module_exit(void)
 {
 	nft_unregister_set(&nft_set_pipapo_type);
+#ifdef CONFIG_AS_AVX2
+	nft_unregister_set(&nft_set_pipapo_avx2_type);
+#endif
 	nft_unregister_set(&nft_set_rbtree_type);
 	nft_unregister_set(&nft_set_bitmap_type);
 	nft_unregister_set(&nft_set_rhash_type);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index e7f4cecea7d6..396eb434aa75 100644
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
@@ -1985,3 +1986,27 @@ struct nft_set_type nft_set_pipapo_type __read_mos=
tly =3D {
 		.elemsize	=3D offsetof(struct nft_pipapo_elem, ext),
 	},
 };
+
+#ifdef CONFIG_AS_AVX2
+struct nft_set_type nft_set_pipapo_avx2_type __read_mostly =3D {
+	.owner		=3D THIS_MODULE,
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
index 000000000000..b33e2a05b5e8
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -0,0 +1,842 @@
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
+#define NFT_PIPAPO_AVX2_BUCKET_LOAD(reg, lt, group, v, bsize)		\
+	NFT_PIPAPO_AVX2_LOAD(reg,					\
+			     lt[((group) * NFT_PIPAPO_BUCKETS + (v)) * (bsize)])
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
+ * nft_pipapo_avx2_lookup2() - AVX2-based lookup for 2 four-bit groups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
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
+static int nft_pipapo_avx2_lookup2(unsigned long *map, unsigned long *fi=
ll,
+				   unsigned long *lt,
+				   union nft_pipapo_map_bucket *mt,
+				   unsigned long bsize, const u8 *pkt,
+				   bool first, bool last, int offset)
+{
+	int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+	u8 pg[2] =3D { pkt[0] >> 4, pkt[0] & 0xf };
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(2, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(2, nothing);
+			NFT_PIPAPO_AVX2_AND(3, 0, 1);
+			NFT_PIPAPO_AVX2_AND(4, 2, 3);
+		}
+
+		NFT_PIPAPO_AVX2_NOMATCH_GOTO(4, nomatch);
+		NFT_PIPAPO_AVX2_STORE(map[i_ul], 4);
+
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
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
+ * nft_pipapo_avx2_lookup4() - AVX2-based lookup for 4 four-bit groups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 16-bit fields (i.e. ports).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup4(unsigned long *map, unsigned long *fi=
ll,
+				   unsigned long *lt,
+				   union nft_pipapo_map_bucket *mt,
+				   unsigned long bsize, const u8 *pkt,
+				   bool first, bool last, int offset)
+{
+	int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+	u8 pg[4] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf };
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(1, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(2, lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(3, lt, 3, pg[3], bsize);
+			NFT_PIPAPO_AVX2_AND(4, 0, 1);
+			NFT_PIPAPO_AVX2_AND(5, 2, 3);
+			NFT_PIPAPO_AVX2_AND(7, 4, 5);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0, lt, 0, pg[0], bsize);
+
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(2, lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(3, lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(4, lt, 3, pg[3], bsize);
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
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
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
+ * nft_pipapo_avx2_lookup8() - AVX2-based lookup for 8 four-bit groups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 32-bit fields (i.e. IPv4 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup8(unsigned long *map, unsigned long *fi=
ll,
+				   unsigned long *lt,
+				   union nft_pipapo_map_bucket *mt,
+				   unsigned long bsize, const u8 *pkt,
+				   bool first, bool last, int offset)
+{
+	int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+	u8 pg[8] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf,
+		     pkt[2] >> 4, pkt[2] & 0xf, pkt[3] >> 4, pkt[3] & 0xf };
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (first) {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 3, pg[3], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt, 4, pg[4], bsize);
+			NFT_PIPAPO_AVX2_AND(5,   0,  1);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 5, pg[5], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 6, pg[6], bsize);
+			NFT_PIPAPO_AVX2_AND(8,   2,  3);
+			NFT_PIPAPO_AVX2_AND(9,   4,  5);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 7, pg[7], bsize);
+			NFT_PIPAPO_AVX2_AND(11,  6,  7);
+			NFT_PIPAPO_AVX2_AND(12,  8,  9);
+			NFT_PIPAPO_AVX2_AND(13, 10, 11);
+
+			/* Stall */
+			NFT_PIPAPO_AVX2_AND(1,  12, 13);
+		} else {
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 0, pg[0], bsize);
+			NFT_PIPAPO_AVX2_LOAD(1, map[i_ul]);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 1, pg[1], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 2, pg[2], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt, 3, pg[3], bsize);
+
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(1, nothing);
+
+			NFT_PIPAPO_AVX2_AND(5,   0,  1);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 4, pg[4], bsize);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 5, pg[5], bsize);
+			NFT_PIPAPO_AVX2_AND(8,   2,  3);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(9,  lt, 6, pg[6], bsize);
+			NFT_PIPAPO_AVX2_AND(10,  4,  5);
+			NFT_PIPAPO_AVX2_BUCKET_LOAD(11, lt, 7, pg[7], bsize);
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
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
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
+ * nft_pipapo_avx2_lookup12() - AVX2-based lookup for 12 four-bit groups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 48-bit fields (i.e. MAC addresses/EUI-48).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup12(unsigned long *map, unsigned long *f=
ill,
+				    unsigned long *lt,
+				    union nft_pipapo_map_bucket *mt,
+				    unsigned long bsize, const u8 *pkt,
+				    bool first, bool last, int offset)
+{
+	int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
+	u8 pg[12] =3D { pkt[0] >> 4, pkt[0] & 0xf, pkt[1] >> 4, pkt[1] & 0xf,
+		      pkt[2] >> 4, pkt[2] & 0xf, pkt[3] >> 4, pkt[3] & 0xf,
+		      pkt[4] >> 4, pkt[4] & 0xf, pkt[5] >> 4, pkt[5] & 0xf };
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (!first)
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt,  0,  pg[0], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt,  1,  pg[1], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt,  2,  pg[2], bsize);
+
+		if (!first) {
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(1, 1, 0);
+		}
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt,  3,  pg[3], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt,  4,  pg[4], bsize);
+		NFT_PIPAPO_AVX2_AND(6,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt,  5,  pg[5], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt,  6,  pg[6], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   1,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt,  7,  pg[7], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt,  8,  pg[8], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  7,  8);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt,  9,  pg[9], bsize);
+
+		NFT_PIPAPO_AVX2_AND(0,   9, 10);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 10,  pg[10], bsize);
+		NFT_PIPAPO_AVX2_AND(2,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 11,  pg[11], bsize);
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
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
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
+ * nft_pipapo_avx2_lookup32() - AVX2-based lookup for 32 four-bit groups
+ * @map:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @pkt:	Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
+ *
+ * See nft_pipapo_avx2_lookup2().
+ *
+ * This is used for 128-bit fields (i.e. IPv6 addresses).
+ *
+ * Return: -1 on no match, rule index of match if @last, otherwise first=
 long
+ * word index to be checked next (i.e. first filled word).
+ */
+static int nft_pipapo_avx2_lookup32(unsigned long *map, unsigned long *f=
ill,
+				    unsigned long *lt,
+				    union nft_pipapo_map_bucket *mt,
+				    unsigned long bsize, const u8 *pkt,
+				    bool first, bool last, int offset)
+{
+	int i, ret =3D -1, m256_size =3D bsize / NFT_PIPAPO_LONGS_PER_M256, b;
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
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+	for (i =3D offset; i < m256_size; i++, lt +=3D NFT_PIPAPO_LONGS_PER_M25=
6) {
+		int i_ul =3D i * NFT_PIPAPO_LONGS_PER_M256;
+
+		if (!first)
+			NFT_PIPAPO_AVX2_LOAD(0, map[i_ul]);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt,  0,  pg[0], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt,  1,  pg[1], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt,  2,  pg[2], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(4,  lt,  3,  pg[3], bsize);
+		if (!first) {
+			NFT_PIPAPO_AVX2_NOMATCH_GOTO(0, nothing);
+			NFT_PIPAPO_AVX2_AND(1, 1, 0);
+		}
+
+		NFT_PIPAPO_AVX2_AND(5,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt,  4,  pg[4], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt,  5,  pg[5], bsize);
+		NFT_PIPAPO_AVX2_AND(8,   1,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(9,  lt,  6,  pg[6], bsize);
+		NFT_PIPAPO_AVX2_AND(10,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(11, lt,  7,  pg[7], bsize);
+		NFT_PIPAPO_AVX2_AND(12,  7,  8);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(13, lt,  8,  pg[8], bsize);
+		NFT_PIPAPO_AVX2_AND(14,  9, 10);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt,  9,  pg[9], bsize);
+		NFT_PIPAPO_AVX2_AND(1,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(2,  lt, 10, pg[10], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 11, pg[11], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  13, 14);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 12, pg[12], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(6,  lt, 13, pg[13], bsize);
+		NFT_PIPAPO_AVX2_AND(7,   0,  1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 14, pg[14], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 15, pg[15], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  4,  5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 16, pg[16], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  6,  7);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt, 17, pg[17], bsize);
+
+		NFT_PIPAPO_AVX2_AND(0,   8,  9);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(1,  lt, 18, pg[18], bsize);
+		NFT_PIPAPO_AVX2_AND(2,  10, 11);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 19, pg[19], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  12, 13);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 20, pg[20], bsize);
+		NFT_PIPAPO_AVX2_AND(6,  14,  0);
+		NFT_PIPAPO_AVX2_AND(7,   1,  2);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 21, pg[21], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   3,  4);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 22, pg[22], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  5,  6);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 23, pg[23], bsize);
+		NFT_PIPAPO_AVX2_AND(13,  7,  8);
+
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(14, lt, 24, pg[24], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(0,  lt, 25, pg[25], bsize);
+		NFT_PIPAPO_AVX2_AND(1,   9, 10);
+		NFT_PIPAPO_AVX2_AND(2,  11, 12);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(3,  lt, 26, pg[26], bsize);
+		NFT_PIPAPO_AVX2_AND(4,  13, 14);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(5,  lt, 27, pg[27], bsize);
+		NFT_PIPAPO_AVX2_AND(6,   0,  1);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(7,  lt, 28, pg[28], bsize);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(8,  lt, 29, pg[29], bsize);
+		NFT_PIPAPO_AVX2_AND(9,   2,  3);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(10, lt, 30, pg[30], bsize);
+		NFT_PIPAPO_AVX2_AND(11,  4,  5);
+		NFT_PIPAPO_AVX2_BUCKET_LOAD(12, lt, 31, pg[31], bsize);
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
+		b =3D nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, mt, last);
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
+ * nft_pipapo_avx2_lookup_noavx2() - Fallback function for uncommon fiel=
d sizes
+ * @f:		Field to be matched
+ * @res:	Previous match result, used as initial bitmap
+ * @fill:	Destination bitmap to be filled with current match result
+ * @lt:		Lookup table for this field
+ * @mt:		Mapping table for this field
+ * @bsize:	Bucket size for this lookup table, in longs
+ * @rp:		Packet data, pointer to input nftables register
+ * @first:	If this is the first field, don't source previous result
+ * @last:	Last field: stop at the first match and return bit index
+ * @offset:	Ignore buckets before the given index, no bits are filled th=
ere
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
+static int nft_pipapo_avx2_lookup_noavx2(struct nft_pipapo_field *f,
+					 unsigned long *res,
+					 unsigned long *fill, unsigned long *lt,
+					 union nft_pipapo_map_bucket *mt,
+					 unsigned long bsize, const u8 *rp,
+					 bool first, bool last, int offset)
+{
+	int i, ret =3D -1, b;
+
+	lt +=3D offset * NFT_PIPAPO_LONGS_PER_M256;
+
+	if (first)
+		memset(res, 0xff, bsize * sizeof(*res));
+
+	for (i =3D offset; i < bsize; i++) {
+		pipapo_and_field_buckets(f, res, rp);
+
+		b =3D pipapo_refill(res, bsize, f->rules, fill, mt, last);
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
+	if (unlikely(!m || !*raw_cpu_ptr(m->scratch))) {
+		kernel_fpu_end();
+		return false;
+	}
+
+	scratch =3D *raw_cpu_ptr(m->scratch_aligned);
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
+#define NFT_SET_PIPAPO_AVX2_LOOKUP(n)					\
+		(ret =3D nft_pipapo_avx2_lookup ##n(res, fill,		\
+						  f->lt_aligned, f->mt,	\
+						  f->bsize, rp,		\
+						  first, last, ret))
+
+		if (f->groups =3D=3D 2) {
+			NFT_SET_PIPAPO_AVX2_LOOKUP(2);
+		} else if (f->groups =3D=3D 4) {
+			NFT_SET_PIPAPO_AVX2_LOOKUP(4);
+		} else if (f->groups =3D=3D 8) {
+			NFT_SET_PIPAPO_AVX2_LOOKUP(8);
+		} else if (f->groups =3D=3D 12) {
+			NFT_SET_PIPAPO_AVX2_LOOKUP(12);
+		} else if (f->groups =3D=3D 32) {
+			NFT_SET_PIPAPO_AVX2_LOOKUP(32);
+		} else {
+			ret =3D nft_pipapo_avx2_lookup_noavx2(f, res, fill,
+							    f->lt_aligned,
+							    f->mt, f->bsize,
+							    rp,
+							    first, last, ret);
+		}
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
+		map_index =3D !map_index;
+		swap(res, fill);
+		rp +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+	}
+
+out:
+	raw_cpu_write(nft_pipapo_avx2_scratch_index, map_index);
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
2.24.1

