Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8417C10F00
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 801CC20684
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EZT/A/qO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgCGQw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:52:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726065AbgCGQw6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 11:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583599976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yxUStE+mqrlWuPrKAVq6sPba38W2vHASjtVZ3UZ5ha8=;
        b=EZT/A/qO2RK5uDqe49QNDeHpgmPu+dvxuILD+LWCuyifkrtiAn7ELpgVdytSPumFVdaKZy
        SPGkPgO8k1qwYtGa/ySOeswU8jfwOhqysHpE55v1VkQxZ553sRUz3gpRztQ5r8+QkWuh5k
        XBUHmGmj0sT9cLun2Rjzg+Krgs3tevA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-e4X9wLARMtOmDfZ1l8H_OA-1; Sat, 07 Mar 2020 11:52:54 -0500
X-MC-Unique: e4X9wLARMtOmDfZ1l8H_OA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A39801E67;
        Sat,  7 Mar 2020 16:52:53 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88B226E3EE;
        Sat,  7 Mar 2020 16:52:51 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/6] nft_set_pipapo: Generalise group size for buckets
Date:   Sat,  7 Mar 2020 17:52:32 +0100
Message-Id: <8c5f89455e88893afa165cc594dba51186ce2e8f.1583598508.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583598508.git.sbrivio@redhat.com>
References: <cover.1583598508.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get rid of all hardcoded assumptions that buckets in lookup tables
correspond to four-bit groups, and replace them with appropriate
calculations based on a variable group size, now stored in struct
field.

The group size could now be in principle any divisor of eight. Note,
though, that lookup and get functions need an implementation
intimately depending on the group size, and the only supported size
there, currently, is four bits, which is also the initial and only
used size at the moment.

While at it, drop 'groups' from struct nft_pipapo: it was never used.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: Rebase, no changes

 net/netfilter/nft_set_pipapo.c | 208 ++++++++++++++++++---------------
 1 file changed, 112 insertions(+), 96 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index 26395c8188b1..43d7189a6a1f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -350,16 +350,18 @@
=20
 /* Number of bits to be grouped together in lookup table buckets, arbitr=
ary */
 #define NFT_PIPAPO_GROUP_BITS		4
-#define NFT_PIPAPO_GROUPS_PER_BYTE	(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
+
+#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
=20
 /* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)				\
-	(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(x)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
+	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(f)					\
+	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
+					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
=20
-/* Number of buckets, given by 2 ^ n, with n grouped bits */
-#define NFT_PIPAPO_BUCKETS		(1 << NFT_PIPAPO_GROUP_BITS)
+/* Number of buckets given by 2 ^ n, with n bucket bits */
+#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
=20
 /* Each n-bit range maps to up to n * 2 rules */
 #define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
@@ -406,16 +408,18 @@ union nft_pipapo_map_bucket {
=20
 /**
  * struct nft_pipapo_field - Lookup, mapping tables and related data for=
 a field
- * @groups:	Amount of 4-bit groups
+ * @groups:	Amount of bit groups
  * @rules:	Number of inserted rules
  * @bsize:	Size of each bucket in lookup table, in longs
- * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @lt:		Lookup table: 'groups' rows of buckets
  * @mt:		Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
 	int groups;
 	unsigned long rules;
 	size_t bsize;
+	int bb;
 	unsigned long *lt;
 	union nft_pipapo_map_bucket *mt;
 };
@@ -443,7 +447,6 @@ static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index)=
;
  * struct nft_pipapo - Representation of a set
  * @match:	Currently in-use matching data
  * @clone:	Copy where pending insertions and deletions are kept
- * @groups:	Total amount of 4-bit groups for fields in this set
  * @width:	Total bytes to be matched for one packet, including padding
  * @dirty:	Working copy has pending insertions or deletions
  * @last_gc:	Timestamp of last garbage collection run, jiffies
@@ -451,7 +454,6 @@ static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index)=
;
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
-	int groups;
 	int width;
 	bool dirty;
 	unsigned long last_gc;
@@ -520,6 +522,34 @@ static int pipapo_refill(unsigned long *map, int len=
, int rules,
 	return ret;
 }
=20
+/**
+ * pipapo_and_field_buckets_4bit() - Intersect buckets for 4-bit groups
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
+					  unsigned long *dst,
+					  const u8 *data)
+{
+	unsigned long *lt =3D f->lt;
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
 /**
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
@@ -559,26 +589,15 @@ static bool nft_pipapo_lookup(const struct net *net=
, const struct nft_set *set,
=20
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last =3D i =3D=3D m->field_count - 1;
-		unsigned long *lt =3D f->lt;
-		int b, group;
+		int b;
=20
-		/* For each 4-bit group: select lookup table bucket depending on
+		/* For each bit group: select lookup table bucket depending on
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
+		pipapo_and_field_buckets_4bit(f, res_map, rp);
+		BUILD_BUG_ON(NFT_PIPAPO_GROUP_BITS !=3D 4);
+
+		rp +=3D f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -621,7 +640,7 @@ static bool nft_pipapo_lookup(const struct net *net, =
const struct nft_set *set,
 		map_index =3D !map_index;
 		swap(res_map, fill_map);
=20
-		rp +=3D NFT_PIPAPO_GROUPS_PADDING(f->groups);
+		rp +=3D NFT_PIPAPO_GROUPS_PADDING(f);
 	}
=20
 out:
@@ -669,26 +688,17 @@ static struct nft_pipapo_elem *pipapo_get(const str=
uct net *net,
=20
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last =3D i =3D=3D m->field_count - 1;
-		unsigned long *lt =3D f->lt;
-		int b, group;
+		int b;
=20
-		/* For each 4-bit group: select lookup table bucket depending on
+		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		for (group =3D 0; group < f->groups; group++) {
-			u8 v;
-
-			if (group % 2) {
-				v =3D *data & 0x0f;
-				data++;
-			} else {
-				v =3D *data >> 4;
-			}
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
+		if (f->bb =3D=3D 4)
+			pipapo_and_field_buckets_4bit(f, res_map, data);
+		else
+			BUG();
=20
-			lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
-		}
+		data +=3D f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -713,7 +723,7 @@ static struct nft_pipapo_elem *pipapo_get(const struc=
t net *net,
 			goto out;
 		}
=20
-		data +=3D NFT_PIPAPO_GROUPS_PADDING(f->groups);
+		data +=3D NFT_PIPAPO_GROUPS_PADDING(f);
=20
 		/* Swap bitmap indices: fill_map will be the initial bitmap for
 		 * the next field (i.e. the new res_map), and res_map is
@@ -772,15 +782,15 @@ static int pipapo_resize(struct nft_pipapo_field *f=
, int old_rules, int rules)
 	else
 		copy =3D new_bucket_size;
=20
-	new_lt =3D kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
-			  sizeof(*new_lt), GFP_KERNEL);
+	new_lt =3D kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
+			  new_bucket_size * sizeof(*new_lt), GFP_KERNEL);
 	if (!new_lt)
 		return -ENOMEM;
=20
 	new_p =3D new_lt;
 	old_p =3D old_lt;
 	for (group =3D 0; group < f->groups; group++) {
-		for (bucket =3D 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
+		for (bucket =3D 0; bucket < NFT_PIPAPO_BUCKETS(f->bb); bucket++) {
 			memcpy(new_p, old_p, copy * sizeof(*new_p));
 			new_p +=3D copy;
 			old_p +=3D copy;
@@ -829,7 +839,7 @@ static void pipapo_bucket_set(struct nft_pipapo_field=
 *f, int rule, int group,
 {
 	unsigned long *pos;
=20
-	pos =3D f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
+	pos =3D f->lt + f->bsize * NFT_PIPAPO_BUCKETS(f->bb) * group;
 	pos +=3D f->bsize * v;
=20
 	__set_bit(rule, pos);
@@ -849,7 +859,7 @@ static void pipapo_bucket_set(struct nft_pipapo_field=
 *f, int rule, int group,
 static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 			 int mask_bits)
 {
-	int rule =3D f->rules++, group, ret;
+	int rule =3D f->rules++, group, ret, bit_offset =3D 0;
=20
 	ret =3D pipapo_resize(f, f->rules - 1, f->rules);
 	if (ret)
@@ -859,22 +869,25 @@ static int pipapo_insert(struct nft_pipapo_field *f=
, const uint8_t *k,
 		int i, v;
 		u8 mask;
=20
-		if (group % 2)
-			v =3D k[group / 2] & 0x0f;
-		else
-			v =3D k[group / 2] >> 4;
+		v =3D k[group / (BITS_PER_BYTE / f->bb)];
+		v &=3D GENMASK(BITS_PER_BYTE - bit_offset - 1, 0);
+		v >>=3D (BITS_PER_BYTE - bit_offset) - f->bb;
=20
-		if (mask_bits >=3D (group + 1) * 4) {
+		bit_offset +=3D f->bb;
+		bit_offset %=3D BITS_PER_BYTE;
+
+		if (mask_bits >=3D (group + 1) * f->bb) {
 			/* Not masked */
 			pipapo_bucket_set(f, rule, group, v);
-		} else if (mask_bits <=3D group * 4) {
+		} else if (mask_bits <=3D group * f->bb) {
 			/* Completely masked */
-			for (i =3D 0; i < NFT_PIPAPO_BUCKETS; i++)
+			for (i =3D 0; i < NFT_PIPAPO_BUCKETS(f->bb); i++)
 				pipapo_bucket_set(f, rule, group, i);
 		} else {
 			/* The mask limit falls on this group */
-			mask =3D 0x0f >> (mask_bits - group * 4);
-			for (i =3D 0; i < NFT_PIPAPO_BUCKETS; i++) {
+			mask =3D GENMASK(f->bb - 1, 0);
+			mask >>=3D mask_bits - group * f->bb;
+			for (i =3D 0; i < NFT_PIPAPO_BUCKETS(f->bb); i++) {
 				if ((i & ~mask) =3D=3D (v & ~mask))
 					pipapo_bucket_set(f, rule, group, i);
 			}
@@ -1123,11 +1136,11 @@ static int nft_pipapo_insert(const struct net *ne=
t, const struct nft_set *set,
 			return -ENOSPC;
=20
 		if (memcmp(start_p, end_p,
-			   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) > 0)
+			   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f)) > 0)
 			return -EINVAL;
=20
-		start_p +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-		end_p +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+		start_p +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		end_p +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
=20
 	/* Insert */
@@ -1141,22 +1154,19 @@ static int nft_pipapo_insert(const struct net *ne=
t, const struct nft_set *set,
 		rulemap[i].to =3D f->rules;
=20
 		ret =3D memcmp(start, end,
-			     f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
-		if (!ret) {
-			ret =3D pipapo_insert(f, start,
-					    f->groups * NFT_PIPAPO_GROUP_BITS);
-		} else {
-			ret =3D pipapo_expand(f, start, end,
-					    f->groups * NFT_PIPAPO_GROUP_BITS);
-		}
+			     f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f));
+		if (!ret)
+			ret =3D pipapo_insert(f, start, f->groups * f->bb);
+		else
+			ret =3D pipapo_expand(f, start, end, f->groups * f->bb);
=20
 		if (f->bsize > bsize_max)
 			bsize_max =3D f->bsize;
=20
 		rulemap[i].n =3D ret;
=20
-		start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-		end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+		start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
=20
 	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
@@ -1208,7 +1218,7 @@ static struct nft_pipapo_match *pipapo_clone(struct=
 nft_pipapo_match *old)
 	for (i =3D 0; i < old->field_count; i++) {
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
=20
-		dst->lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
+		dst->lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
 				   src->bsize * sizeof(*dst->lt),
 				   GFP_KERNEL);
 		if (!dst->lt)
@@ -1216,7 +1226,7 @@ static struct nft_pipapo_match *pipapo_clone(struct=
 nft_pipapo_match *old)
=20
 		memcpy(dst->lt, src->lt,
 		       src->bsize * sizeof(*dst->lt) *
-		       src->groups * NFT_PIPAPO_BUCKETS);
+		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
=20
 		dst->mt =3D kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
@@ -1394,9 +1404,9 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			unsigned long *pos;
 			int b;
=20
-			pos =3D f->lt + g * NFT_PIPAPO_BUCKETS * f->bsize;
+			pos =3D f->lt + g * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize;
=20
-			for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
+			for (b =3D 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 				bitmap_cut(pos, pos, rulemap[i].to,
 					   rulemap[i].n,
 					   f->bsize * BITS_PER_LONG);
@@ -1690,30 +1700,33 @@ static bool nft_pipapo_flush(const struct net *ne=
t, const struct nft_set *set,
 static int pipapo_get_boundaries(struct nft_pipapo_field *f, int first_r=
ule,
 				 int rule_count, u8 *left, u8 *right)
 {
+	int g, mask_len =3D 0, bit_offset =3D 0;
 	u8 *l =3D left, *r =3D right;
-	int g, mask_len =3D 0;
=20
 	for (g =3D 0; g < f->groups; g++) {
 		int b, x0, x1;
=20
 		x0 =3D -1;
 		x1 =3D -1;
-		for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
+		for (b =3D 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 			unsigned long *pos;
=20
-			pos =3D f->lt + (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
+			pos =3D f->lt + (g * NFT_PIPAPO_BUCKETS(f->bb) + b) *
+				      f->bsize;
 			if (test_bit(first_rule, pos) && x0 =3D=3D -1)
 				x0 =3D b;
 			if (test_bit(first_rule + rule_count - 1, pos))
 				x1 =3D b;
 		}
=20
-		if (g % 2) {
-			*(l++) |=3D x0 & 0x0f;
-			*(r++) |=3D x1 & 0x0f;
-		} else {
-			*l |=3D x0 << 4;
-			*r |=3D x1 << 4;
+		*l |=3D x0 << (BITS_PER_BYTE - f->bb - bit_offset);
+		*r |=3D x1 << (BITS_PER_BYTE - f->bb - bit_offset);
+
+		bit_offset +=3D f->bb;
+		if (bit_offset >=3D BITS_PER_BYTE) {
+			bit_offset %=3D BITS_PER_BYTE;
+			l++;
+			r++;
 		}
=20
 		if (x1 - x0 =3D=3D 0)
@@ -1748,8 +1761,9 @@ static bool pipapo_match_field(struct nft_pipapo_fi=
eld *f,
=20
 	pipapo_get_boundaries(f, first_rule, rule_count, left, right);
=20
-	return !memcmp(start, left, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) &&
-	       !memcmp(end, right, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
+	return !memcmp(start, left,
+		       f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f)) &&
+	       !memcmp(end, right, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f));
 }
=20
 /**
@@ -1801,8 +1815,8 @@ static void nft_pipapo_remove(const struct net *net=
, const struct nft_set *set,
 			rules_fx =3D f->mt[start].n;
 			start =3D f->mt[start].to;
=20
-			match_start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-			match_end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+			match_start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+			match_end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 		}
=20
 		if (i =3D=3D m->field_count) {
@@ -1895,9 +1909,9 @@ static u64 nft_pipapo_privsize(const struct nlattr =
* const nla[],
  * case here.
  *
  * In general, for a non-ranged entry or a single composing netmask, we =
need
- * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit gro=
up (that
- * is, each input bit needs four bits of matching data), plus a bucket i=
n the
- * mapping table for each field.
+ * one bit in each of the sixteen buckets, for each 4-bit group (that is=
, each
+ * input bit needs four bits of matching data), plus a bucket in the map=
ping
+ * table for each field.
  *
  * Return: true only for compatible range concatenations
  */
@@ -1921,7 +1935,9 @@ static bool nft_pipapo_estimate(const struct nft_se=
t_desc *desc, u32 features,
 		 * each rule also needs a mapping bucket.
 		 */
 		rules =3D ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
-		entry_size +=3D rules * NFT_PIPAPO_BUCKETS / BITS_PER_BYTE;
+		entry_size +=3D rules *
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS) /
+			      BITS_PER_BYTE;
 		entry_size +=3D rules * sizeof(union nft_pipapo_map_bucket);
 	}
=20
@@ -1985,8 +2001,8 @@ static int nft_pipapo_init(const struct nft_set *se=
t,
 	rcu_head_init(&m->rcu);
=20
 	nft_pipapo_for_each_field(f, i, m) {
-		f->groups =3D desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE;
-		priv->groups +=3D f->groups;
+		f->bb =3D NFT_PIPAPO_GROUP_BITS;
+		f->groups =3D desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
 		priv->width +=3D round_up(desc->field_len[i], sizeof(u32));
=20
--=20
2.25.1

