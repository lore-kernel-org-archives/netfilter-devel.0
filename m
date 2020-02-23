Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EF9C35671
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB881206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0SUnSpC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgBWVXh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 16:23:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58584 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727064AbgBWVXh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 16:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582493015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWoWn9osq+P8asySaUEIH3McOlTa1u+oUQvI8XIUJPM=;
        b=C0SUnSpCuk1xi9VTcZVKNkIN6Ad7oml1HknHR9C82tc7wv3bjrX8S4qfpf5H9mBU6ANLud
        nN02yK6/fiBGxFt1lcqUZBhSEdEtDiCkUSdKRYE7ig4/ExqwzXIr/lloyoYe5vTdvfzzOf
        gloRlrH8C67lBE9KjiecsP60/ihExYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-VvLzCi3UOo-YBqnK8JrPQg-1; Sun, 23 Feb 2020 16:23:33 -0500
X-MC-Unique: VvLzCi3UOo-YBqnK8JrPQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3BC1107ACC5;
        Sun, 23 Feb 2020 21:23:31 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C278B87B01;
        Sun, 23 Feb 2020 21:23:30 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/5] nft_set_pipapo: Add support for 8-bit lookup groups and dynamic switch
Date:   Sun, 23 Feb 2020 22:23:13 +0100
Message-Id: <e5735e5d19e5a0ee56354a2af61e353511c3aeee.1582488826.git.sbrivio@redhat.com>
In-Reply-To: <cover.1582488826.git.sbrivio@redhat.com>
References: <cover.1582488826.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While grouping matching bits in groups of four saves memory compared
to the more natural choice of 8-bit words (lookup table size is one
eighth), it comes at a performance cost, as the number of lookup
comparisons is doubled, and those also needs bitshifts and masking.

Introduce support for 8-bit lookup groups, together with a mapping
mechanism to dynamically switch, based on defined per-table size
thresholds and hysteresis, between 8-bit and 4-bit groups, as tables
grow and shrink. Empty sets start with 8-bit groups, and per-field
tables are converted to 4-bit groups if they get too big.

An alternative approach would have been to swap per-set lookup
operation functions as needed, but this doesn't allow for different
group sizes in the same set, which looks desirable if some fields
need significantly more matching data compared to others due to
heavier impact of ranges (e.g. a big number of subnets with
relatively simple port specifications).

Allowing different group sizes for the same lookup functions implies
the need for further conditional clauses, whose cost, however,
appears to be negligible in tests.

The matching rate figures below were obtained for x86_64 running
the nft_concat_range.sh "performance" cases, averaged over five
runs, on a single thread of an AMD Epyc 7402 CPU, and for aarch64
on a single thread of a BCM2711 (Raspberry Pi 4 Model B 4GB),
clocked at a stable 2147MHz frequency:

 ---------------.-----------------------------------.------------.
 AMD Epyc 7402  |          baselines, Mpps          | this patch |
  1 thread      |___________________________________|____________|
  3.35GHz       |        |        |        |        |            |
  768KiB L1D$   | netdev |  hash  | rbtree |        |            |
 ---------------|  hook  |   no   | single | pipapo |   pipapo   |
 type   entries |  drop  | ranges | field  | 4 bits | bit switch |
 ---------------|--------|--------|--------|--------|------------|
 net,port       |        |        |        |        |            |
          1000  |   19.0 |   10.4 |    3.8 |    2.8 | 4.0   +43% |
 ---------------|--------|--------|--------|--------|------------|
 port,net       |        |        |        |        |            |
           100  |   18.8 |   10.3 |    5.8 |    5.5 | 6.3   +14% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port      |        |        |        |        |            |
          1000  |   16.4 |    7.6 |    1.8 |    1.3 | 2.1   +61% |
 ---------------|--------|--------|--------|--------|------------|
 port,proto     |        |        |        |        |     [1]    |
         30000  |   19.6 |   11.6 |    3.9 |    0.3 | 0.5   +66% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac  |        |        |        |        |            |
            10  |   16.5 |    5.4 |    4.3 |    2.6 | 3.4   +31% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac, |        |        |        |        |            |
 proto    1000  |   16.5 |    5.7 |    1.9 |    1.0 | 1.4   +40% |
 ---------------|--------|--------|--------|--------|------------|
 net,mac        |        |        |        |        |            |
          1000  |   19.0 |    8.4 |    3.9 |    1.7 | 2.5   +47% |
 ---------------'--------'--------'--------'--------'------------'
[1] Causes switch of lookup table buckets for 'port', not 'proto',
    to 4-bit groups

 ---------------.-----------------------------------.------------.
 BCM2711        |          baselines, Mpps          | this patch |
  1 thread      |___________________________________|____________|
  2147MHz       |        |        |        |        |            |
  32KiB L1D$    | netdev |  hash  | rbtree |        |            |
 ---------------|  hook  |   no   | single | pipapo |   pipapo   |
 type   entries |  drop  | ranges | field  | 4 bits | bit switch |
 ---------------|--------|--------|--------|--------|------------|
 net,port       |        |        |        |        |            |
          1000  |   1.63 |   1.37 |   0.87 |   0.61 | 0.70  +17% |
 ---------------|--------|--------|--------|--------|------------|
 port,net       |        |        |        |        |            |
           100  |   1.64 |   1.36 |   1.02 |   0.78 | 0.81   +4% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port      |        |        |        |        |            |
          1000  |   1.56 |   1.27 |   0.65 |   0.34 | 0.50  +47% |
 ---------------|--------|--------|--------|--------|------------|
 port,proto [2] |        |        |        |        |            |
         10000  |   1.68 |   1.43 |   0.84 |   0.30 | 0.40  +13% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac  |        |        |        |        |            |
            10  |   1.56 |   1.14 |   1.02 |   0.62 | 0.66   +6% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac, |        |        |        |        |            |
 proto    1000  |   1.56 |   1.12 |   0.64 |   0.27 | 0.40  +48% |
 ---------------|--------|--------|--------|--------|------------|
 net,mac        |        |        |        |        |            |
          1000  |   1.63 |   1.26 |   0.87 |   0.41 | 0.53  +29% |
 ---------------'--------'--------'--------'--------'------------'
[2] Using 10000 entries instead of 30000 as it would take way too
    long for the test script to generate all of them

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 241 +++++++++++++++++++++++++++++++--
 1 file changed, 233 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index e9ed9734a82a..63e608e73e05 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -348,11 +348,30 @@
 #define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
 #define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
=20
-/* Number of bits to be grouped together in lookup table buckets, arbitr=
ary */
-#define NFT_PIPAPO_GROUP_BITS		4
-
+/* Bits to be grouped together in table buckets depending on set size */
+#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
+#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
+#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
+#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
+	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET !=3D 8) ||		\
+		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET !=3D 4))
 #define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
=20
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
 /* Fields are padded to 32 bits in input registers */
 #define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
 	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
@@ -550,6 +569,26 @@ static void pipapo_and_field_buckets_4bit(struct nft=
_pipapo_field *f,
 	}
 }
=20
+/**
+ * pipapo_and_field_buckets_8bit() - Intersect buckets for 8-bit groups
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
+					  unsigned long *dst,
+					  const u8 *data)
+{
+	unsigned long *lt =3D f->lt;
+	int group;
+
+	for (group =3D 0; group < f->groups; group++, data++) {
+		__bitmap_and(dst, dst, lt + *data * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt +=3D f->bsize * NFT_PIPAPO_BUCKETS(8);
+	}
+}
+
 /**
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
@@ -594,8 +633,11 @@ static bool nft_pipapo_lookup(const struct net *net,=
 const struct nft_set *set,
 		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		pipapo_and_field_buckets_4bit(f, res_map, rp);
-		BUILD_BUG_ON(NFT_PIPAPO_GROUP_BITS !=3D 4);
+		if (likely(f->bb =3D=3D 8))
+			pipapo_and_field_buckets_8bit(f, res_map, rp);
+		else
+			pipapo_and_field_buckets_4bit(f, res_map, rp);
+		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
=20
 		rp +=3D f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
@@ -693,7 +735,9 @@ static struct nft_pipapo_elem *pipapo_get(const struc=
t net *net,
 		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		if (f->bb =3D=3D 4)
+		if (f->bb =3D=3D 8)
+			pipapo_and_field_buckets_8bit(f, res_map, data);
+		else if (f->bb =3D=3D 4)
 			pipapo_and_field_buckets_4bit(f, res_map, data);
 		else
 			BUG();
@@ -845,6 +889,183 @@ static void pipapo_bucket_set(struct nft_pipapo_fie=
ld *f, int rule, int group,
 	__set_bit(rule, pos);
 }
=20
+/**
+ * pipapo_lt_4b_to_8b() - Switch lookup table group width from 4 bits to=
 8 bits
+ * @old_groups:	Number of current groups
+ * @bsize:	Size of one bucket, in longs
+ * @old_lt:	Pointer to the current lookup table
+ * @new_lt:	Pointer to the new, pre-allocated lookup table
+ *
+ * Each bucket with index b in the new lookup table, belonging to group =
g, is
+ * filled with the bit intersection between:
+ * - bucket with index given by the upper 4 bits of b, from group g, and
+ * - bucket with index given by the lower 4 bits of b, from group g + 1
+ *
+ * That is, given buckets from the new lookup table N(x, y) and the old =
lookup
+ * table O(x, y), with x bucket index, and y group index:
+ *
+ *	N(b, g) :=3D O(b / 16, g) & O(b % 16, g + 1)
+ *
+ * This ensures equivalence of the matching results on lookup. Two examp=
les in
+ * pictures:
+ *
+ *              bucket
+ *  group  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 ... 2=
54 255
+ *    0                ^
+ *    1                |                                                =
 ^
+ *   ...             ( & )                                              =
 |
+ *                  /     \                                             =
 |
+ *                 /       \                                         .-(=
 & )-.
+ *                /  bucket \                                        |  =
     |
+ *      group  0 / 1   2   3 \ 4   5   6   7   8   9  10  11  12  13 |14=
  15 |
+ *        0     /             \                                      |  =
     |
+ *        1                    \                                     |  =
     |
+ *        2                                                          |  =
   --'
+ *        3                                                          '-
+ *       ...
+ */
+static void pipapo_lt_4b_to_8b(int old_groups, int bsize,
+			       unsigned long *old_lt, unsigned long *new_lt)
+{
+	int g, b, i;
+
+	for (g =3D 0; g < old_groups / 2; g++) {
+		int src_g0 =3D g * 2, src_g1 =3D g * 2 + 1;
+
+		for (b =3D 0; b < NFT_PIPAPO_BUCKETS(8); b++) {
+			int src_b0 =3D b / NFT_PIPAPO_BUCKETS(4);
+			int src_b1 =3D b % NFT_PIPAPO_BUCKETS(4);
+			int src_i0 =3D src_g0 * NFT_PIPAPO_BUCKETS(4) + src_b0;
+			int src_i1 =3D src_g1 * NFT_PIPAPO_BUCKETS(4) + src_b1;
+
+			for (i =3D 0; i < bsize; i++) {
+				*new_lt =3D old_lt[src_i0 * bsize + i] &
+					  old_lt[src_i1 * bsize + i];
+				new_lt++;
+			}
+		}
+	}
+}
+
+/**
+ * pipapo_lt_8b_to_4b() - Switch lookup table group width from 8 bits to=
 4 bits
+ * @old_groups:	Number of current groups
+ * @bsize:	Size of one bucket, in longs
+ * @old_lt:	Pointer to the current lookup table
+ * @new_lt:	Pointer to the new, pre-allocated lookup table
+ *
+ * Each bucket with index b in the new lookup table, belonging to group =
g, is
+ * filled with the bit union of:
+ * - all the buckets with index such that the upper four bits of the low=
er byte
+ *   equal b, from group g, with g odd
+ * - all the buckets with index such that the lower four bits equal b, f=
rom
+ *   group g, with g even
+ *
+ * That is, given buckets from the new lookup table N(x, y) and the old =
lookup
+ * table O(x, y), with x bucket index, and y group index:
+ *
+ *	- with g odd:  N(b, g) :=3D U(O(x, g) for each x : x =3D (b & 0xf0) >=
> 4)
+ *	- with g even: N(b, g) :=3D U(O(x, g) for each x : x =3D b & 0x0f)
+ *
+ * where U() denotes the arbitrary union operation (binary OR of n terms=
). This
+ * ensures equivalence of the matching results on lookup.
+ */
+static void pipapo_lt_8b_to_4b(int old_groups, int bsize,
+			       unsigned long *old_lt, unsigned long *new_lt)
+{
+	int g, b, bsrc, i;
+
+	memset(new_lt, 0, old_groups * 2 * NFT_PIPAPO_BUCKETS(4) * bsize *
+			  sizeof(unsigned long));
+
+	for (g =3D 0; g < old_groups * 2; g +=3D 2) {
+		int src_g =3D g / 2;
+
+		for (b =3D 0; b < NFT_PIPAPO_BUCKETS(4); b++) {
+			for (bsrc =3D NFT_PIPAPO_BUCKETS(8) * src_g;
+			     bsrc < NFT_PIPAPO_BUCKETS(8) * (src_g + 1);
+			     bsrc++) {
+				if (((bsrc & 0xf0) >> 4) !=3D b)
+					continue;
+
+				for (i =3D 0; i < bsize; i++)
+					new_lt[i] |=3D old_lt[bsrc * bsize + i];
+			}
+
+			new_lt +=3D bsize;
+		}
+
+		for (b =3D 0; b < NFT_PIPAPO_BUCKETS(4); b++) {
+			for (bsrc =3D NFT_PIPAPO_BUCKETS(8) * src_g;
+			     bsrc < NFT_PIPAPO_BUCKETS(8) * (src_g + 1);
+			     bsrc++) {
+				if ((bsrc & 0x0f) !=3D b)
+					continue;
+
+				for (i =3D 0; i < bsize; i++)
+					new_lt[i] |=3D old_lt[bsrc * bsize + i];
+			}
+
+			new_lt +=3D bsize;
+		}
+	}
+}
+
+/**
+ * pipapo_lt_bits_adjust() - Adjust group size for lookup table if neede=
d
+ * @f:		Field containing lookup table
+ */
+static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
+{
+	unsigned long *new_lt;
+	int groups, bb;
+	size_t lt_size;
+
+	lt_size =3D f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
+		  sizeof(*f->lt);
+
+	if (f->bb =3D=3D NFT_PIPAPO_GROUP_BITS_SMALL_SET &&
+	    lt_size > NFT_PIPAPO_LT_SIZE_HIGH) {
+		groups =3D f->groups * 2;
+		bb =3D NFT_PIPAPO_GROUP_BITS_LARGE_SET;
+
+		lt_size =3D groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
+			  sizeof(*f->lt);
+	} else if (f->bb =3D=3D NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
+		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
+		groups =3D f->groups / 2;
+		bb =3D NFT_PIPAPO_GROUP_BITS_SMALL_SET;
+
+		lt_size =3D groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
+			  sizeof(*f->lt);
+
+		/* Don't increase group width if the resulting lookup table size
+		 * would exceed the upper size threshold for a "small" set.
+		 */
+		if (lt_size > NFT_PIPAPO_LT_SIZE_HIGH)
+			return;
+	} else {
+		return;
+	}
+
+	new_lt =3D kvzalloc(lt_size, GFP_KERNEL);
+	if (!new_lt)
+		return;
+
+	NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
+	if (f->bb =3D=3D 4 && bb =3D=3D 8)
+		pipapo_lt_4b_to_8b(f->groups, f->bsize, f->lt, new_lt);
+	else if (f->bb =3D=3D 8 && bb =3D=3D 4)
+		pipapo_lt_8b_to_4b(f->groups, f->bsize, f->lt, new_lt);
+	else
+		BUG();
+
+	f->groups =3D groups;
+	f->bb =3D bb;
+	kvfree(f->lt);
+	f->lt =3D new_lt;
+}
+
 /**
  * pipapo_insert() - Insert new rule in field given input key and mask l=
ength
  * @f:		Field containing lookup table
@@ -894,6 +1115,8 @@ static int pipapo_insert(struct nft_pipapo_field *f,=
 const uint8_t *k,
 		}
 	}
=20
+	pipapo_lt_bits_adjust(f);
+
 	return 1;
 }
=20
@@ -1424,6 +1647,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			;
 		}
 		f->rules -=3D rulemap[i].n;
+
+		pipapo_lt_bits_adjust(f);
 	}
 }
=20
@@ -1936,7 +2161,7 @@ static bool nft_pipapo_estimate(const struct nft_se=
t_desc *desc, u32 features,
 		 */
 		rules =3D ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
 		entry_size +=3D rules *
-			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS) /
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
 			      BITS_PER_BYTE;
 		entry_size +=3D rules * sizeof(union nft_pipapo_map_bucket);
 	}
@@ -2001,7 +2226,7 @@ static int nft_pipapo_init(const struct nft_set *se=
t,
 	rcu_head_init(&m->rcu);
=20
 	nft_pipapo_for_each_field(f, i, m) {
-		f->bb =3D NFT_PIPAPO_GROUP_BITS;
+		f->bb =3D NFT_PIPAPO_GROUP_BITS_INIT;
 		f->groups =3D desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
 		priv->width +=3D round_up(desc->field_len[i], sizeof(u32));
--=20
2.25.0

