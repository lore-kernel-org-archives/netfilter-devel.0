Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9908BC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6505D20707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hU9mBEyX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfKVNkf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727192AbfKVNkf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6eh4BmVwzFUTnIuZwlmIdRlvWggis5k18LCqCNE3Nx4=;
        b=hU9mBEyXQxEbl1ON6b9u2xVPBy1gJQ8z5SRSP5QUF1XP60Ckj8nd8r9y2wzPhWMjDTUWJs
        uMijwt1eewF3raa9DXOir+9T3gl68TDRrk7Sfu1NnFHwPWzIgQZ8srpso9hGEuJ08+wx8/
        drz903ckncg+krDJu24a9xUX6OugLBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-PrR8hn8rPW-cxNXs1EsI4w-1; Fri, 22 Nov 2019 08:40:30 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9413100551D;
        Fri, 22 Nov 2019 13:40:28 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5743D1036C8E;
        Fri, 22 Nov 2019 13:40:26 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 6/8] nft_set_pipapo: Prepare for vectorised implementation: alignment
Date:   Fri, 22 Nov 2019 14:40:05 +0100
Message-Id: <b5d791e99c06df677892674ecc50cd07b58f9ddc.1574428269.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: PrR8hn8rPW-cxNXs1EsI4w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SIMD vector extension sets require stricter alignment than native
instruction sets to operate efficiently (AVX, NEON) or for some
instructions to work at all (AltiVec).

Provide facilities to define arbitrary alignment for lookup tables
and scratch maps. By defining byte alignment with NFT_PIPAPO_ALIGN,
lt_aligned and scratch_aligned pointers become available.

Additional headroom is allocated, and pointers to the possibly
unaligned, originally allocated areas are kept so that they can
be freed.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes

 net/netfilter/nft_set_pipapo.c | 115 +++++++++++++++++++++++++++------
 1 file changed, 97 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.=
c
index 0596dbd11319..92a0e3dc6f79 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -377,6 +377,22 @@
 #define NFT_PIPAPO_RULE0_MAX=09=09((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
 =09=09=09=09=09- (1UL << NFT_PIPAPO_MAP_NBITS))
=20
+/* Definitions for vectorised implementations */
+#ifdef NFT_PIPAPO_ALIGN
+#define NFT_PIPAPO_ALIGN_HEADROOM=09=09=09=09=09\
+=09(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
+#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
+#define NFT_PIPAPO_LT_ASSIGN(field, x)=09=09=09=09=09\
+=09do {=09=09=09=09=09=09=09=09\
+=09=09(field)->lt_aligned =3D NFT_PIPAPO_LT_ALIGN(x);=09=09\
+=09=09(field)->lt =3D (x);=09=09=09=09=09\
+=09} while (0)
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM=090
+#define NFT_PIPAPO_LT_ALIGN(lt)=09=09(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)=09((field)->lt =3D (x))
+#endif /* NFT_PIPAPO_ALIGN */
+
 #define nft_pipapo_for_each_field(field, index, match)=09=09\
 =09for ((field) =3D (match)->f, (index) =3D 0;=09=09=09\
 =09     (index) < (match)->field_count;=09=09=09\
@@ -410,12 +426,16 @@ union nft_pipapo_map_bucket {
  * @rules:=09Number of inserted rules
  * @bsize:=09Size of each bucket in lookup table, in longs
  * @lt:=09=09Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @lt_aligned:=09Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
  * @mt:=09=09Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
 =09int groups;
 =09unsigned long rules;
 =09size_t bsize;
+#ifdef NFT_PIPAPO_ALIGN
+=09unsigned long *lt_aligned;
+#endif
 =09unsigned long *lt;
 =09union nft_pipapo_map_bucket *mt;
 };
@@ -424,12 +444,16 @@ struct nft_pipapo_field {
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count=09=09Amount of fields in set
  * @scratch:=09=09Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:=09Version of @scratch aligned to NFT_PIPAPO_ALIGN byt=
es
  * @bsize_max:=09=09Maximum lookup table bucket size of all fields, in lon=
gs
  * @rcu=09=09=09Matching data is swapped on commits
  * @f:=09=09=09Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
 =09int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+=09unsigned long * __percpu *scratch_aligned;
+#endif
 =09unsigned long * __percpu *scratch;
 =09size_t bsize_max;
 =09struct rcu_head rcu;
@@ -733,8 +757,8 @@ static void *pipapo_get(const struct net *net, const st=
ruct nft_set *set,
 =09memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
=20
 =09nft_pipapo_for_each_field(f, i, m) {
+=09=09unsigned long *lt =3D NFT_PIPAPO_LT_ALIGN(f->lt);
 =09=09bool last =3D i =3D=3D m->field_count - 1;
-=09=09unsigned long *lt =3D f->lt;
 =09=09int b, group;
=20
 =09=09/* For each 4-bit group: select lookup table bucket depending on
@@ -828,6 +852,10 @@ static int pipapo_resize(struct nft_pipapo_field *f, i=
nt old_rules, int rules)
 =09int group, bucket;
=20
 =09new_bucket_size =3D DIV_ROUND_UP(rules, BITS_PER_LONG);
+#ifdef NFT_PIPAPO_ALIGN
+=09new_bucket_size =3D roundup(new_bucket_size,
+=09=09=09=09  NFT_PIPAPO_ALIGN / sizeof(*new_lt));
+#endif
=20
 =09if (new_bucket_size =3D=3D f->bsize)
 =09=09goto mt;
@@ -838,12 +866,14 @@ static int pipapo_resize(struct nft_pipapo_field *f, =
int old_rules, int rules)
 =09=09copy =3D new_bucket_size;
=20
 =09new_lt =3D kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
-=09=09=09  sizeof(*new_lt), GFP_KERNEL);
+=09=09=09  sizeof(*new_lt) + NFT_PIPAPO_ALIGN_HEADROOM,
+=09=09=09  GFP_KERNEL);
 =09if (!new_lt)
 =09=09return -ENOMEM;
=20
-=09new_p =3D new_lt;
-=09old_p =3D old_lt;
+=09new_p =3D NFT_PIPAPO_LT_ALIGN(new_lt);
+=09old_p =3D NFT_PIPAPO_LT_ALIGN(old_lt);
+
 =09for (group =3D 0; group < f->groups; group++) {
 =09=09for (bucket =3D 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
 =09=09=09memcpy(new_p, old_p, copy * sizeof(*new_p));
@@ -872,7 +902,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, in=
t old_rules, int rules)
=20
 =09if (new_lt) {
 =09=09f->bsize =3D new_bucket_size;
-=09=09f->lt =3D new_lt;
+=09=09NFT_PIPAPO_LT_ASSIGN(f, new_lt);
 =09=09kvfree(old_lt);
 =09}
=20
@@ -894,7 +924,8 @@ static void pipapo_bucket_set(struct nft_pipapo_field *=
f, int rule, int group,
 {
 =09unsigned long *pos;
=20
-=09pos =3D f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
+=09pos =3D NFT_PIPAPO_LT_ALIGN(f->lt);
+=09pos +=3D f->bsize * NFT_PIPAPO_BUCKETS * group;
 =09pos +=3D f->bsize * v;
=20
 =09__set_bit(rule, pos);
@@ -1118,8 +1149,12 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
match *clone,
=20
 =09for_each_possible_cpu(i) {
 =09=09unsigned long *scratch;
+#ifdef NFT_PIPAPO_ALIGN
+=09=09unsigned long *scratch_aligned;
+#endif
=20
-=09=09scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2,
+=09=09scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2 +
+=09=09=09=09       NFT_PIPAPO_ALIGN_HEADROOM,
 =09=09=09=09       GFP_KERNEL, cpu_to_node(i));
 =09=09if (!scratch) {
 =09=09=09/* On failure, there's no need to undo previous
@@ -1135,6 +1170,11 @@ static int pipapo_realloc_scratch(struct nft_pipapo_=
match *clone,
 =09=09kfree(*per_cpu_ptr(clone->scratch, i));
=20
 =09=09*per_cpu_ptr(clone->scratch, i) =3D scratch;
+
+#ifdef NFT_PIPAPO_ALIGN
+=09=09scratch_aligned =3D NFT_PIPAPO_LT_ALIGN(scratch);
+=09=09*per_cpu_ptr(clone->scratch_aligned, i) =3D scratch_aligned;
+#endif
 =09}
=20
 =09return 0;
@@ -1291,21 +1331,33 @@ static struct nft_pipapo_match *pipapo_clone(struct=
 nft_pipapo_match *old)
 =09if (!new->scratch)
 =09=09goto out_scratch;
=20
+#ifdef NFT_PIPAPO_ALIGN
+=09new->scratch_aligned =3D alloc_percpu(*new->scratch_aligned);
+=09if (!new->scratch_aligned)
+=09=09goto out_scratch;
+#endif
+
 =09rcu_head_init(&new->rcu);
=20
 =09src =3D old->f;
 =09dst =3D new->f;
=20
 =09for (i =3D 0; i < old->field_count; i++) {
+=09=09unsigned long *new_lt;
+
 =09=09memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
=20
-=09=09dst->lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
-=09=09=09=09   src->bsize * sizeof(*dst->lt),
-=09=09=09=09   GFP_KERNEL);
-=09=09if (!dst->lt)
+=09=09new_lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
+=09=09=09=09  src->bsize * sizeof(*dst->lt) +
+=09=09=09=09  NFT_PIPAPO_ALIGN_HEADROOM,
+=09=09=09=09  GFP_KERNEL);
+=09=09if (!new_lt)
 =09=09=09goto out_lt;
=20
-=09=09memcpy(dst->lt, src->lt,
+=09=09NFT_PIPAPO_LT_ASSIGN(dst, new_lt);
+
+=09=09memcpy(NFT_PIPAPO_LT_ALIGN(new_lt),
+=09=09       NFT_PIPAPO_LT_ALIGN(src->lt),
 =09=09       src->bsize * sizeof(*dst->lt) *
 =09=09       src->groups * NFT_PIPAPO_BUCKETS);
=20
@@ -1328,8 +1380,11 @@ static struct nft_pipapo_match *pipapo_clone(struct =
nft_pipapo_match *old)
 =09=09kvfree(dst->lt);
 =09=09dst--;
 =09}
-=09free_percpu(new->scratch);
+#ifdef NFT_PIPAPO_ALIGN
+=09free_percpu(new->scratch_aligned);
+#endif
 out_scratch:
+=09free_percpu(new->scratch);
 =09kfree(new);
=20
 =09return ERR_PTR(-ENOMEM);
@@ -1485,7 +1540,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 =09=09=09unsigned long *pos;
 =09=09=09int b;
=20
-=09=09=09pos =3D f->lt + g * NFT_PIPAPO_BUCKETS * f->bsize;
+=09=09=09pos =3D NFT_PIPAPO_LT_ALIGN(f->lt) + g *
+=09=09=09      NFT_PIPAPO_BUCKETS * f->bsize;
=20
 =09=09=09for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
 =09=09=09=09bitmap_cut(pos, pos, rulemap[i].to,
@@ -1590,6 +1646,9 @@ static void pipapo_reclaim_match(struct rcu_head *rcu=
)
 =09for_each_possible_cpu(i)
 =09=09kfree(*per_cpu_ptr(m->scratch, i));
=20
+#ifdef NFT_PIPAPO_ALIGN
+=09free_percpu(m->scratch_aligned);
+#endif
 =09free_percpu(m->scratch);
=20
 =09pipapo_free_fields(m);
@@ -1817,7 +1876,8 @@ static int pipapo_get_boundaries(struct nft_pipapo_fi=
eld *f, int first_rule,
 =09=09for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
 =09=09=09unsigned long *pos;
=20
-=09=09=09pos =3D f->lt + (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
+=09=09=09pos =3D NFT_PIPAPO_LT_ALIGN(f->lt) +
+=09=09=09      (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
 =09=09=09if (test_bit(first_rule, pos) && x0 =3D=3D -1)
 =09=09=09=09x0 =3D b;
 =09=09=09if (test_bit(first_rule + rule_count - 1, pos))
@@ -2117,11 +2177,21 @@ static int nft_pipapo_init(const struct nft_set *se=
t,
 =09m->scratch =3D alloc_percpu(unsigned long *);
 =09if (!m->scratch) {
 =09=09err =3D -ENOMEM;
-=09=09goto out_free;
+=09=09goto out_scratch;
 =09}
 =09for_each_possible_cpu(i)
 =09=09*per_cpu_ptr(m->scratch, i) =3D NULL;
=20
+#ifdef NFT_PIPAPO_ALIGN
+=09m->scratch_aligned =3D alloc_percpu(unsigned long *);
+=09if (!m->scratch_aligned) {
+=09=09err =3D -ENOMEM;
+=09=09goto out_free;
+=09}
+=09for_each_possible_cpu(i)
+=09=09*per_cpu_ptr(m->scratch_aligned, i) =3D NULL;
+#endif
+
 =09rcu_head_init(&m->rcu);
=20
 =09f =3D m->f;
@@ -2139,7 +2209,7 @@ static int nft_pipapo_init(const struct nft_set *set,
=20
 =09=09f->bsize =3D 0;
 =09=09f->rules =3D 0;
-=09=09f->lt =3D NULL;
+=09=09NFT_PIPAPO_LT_ASSIGN(f, NULL);
 =09=09f->mt =3D NULL;
=20
 =09=09f++;
@@ -2159,7 +2229,11 @@ static int nft_pipapo_init(const struct nft_set *set=
,
 =09return 0;
=20
 out_free:
+#ifdef NFT_PIPAPO_ALIGN
+=09free_percpu(m->scratch_aligned);
+#endif
 =09free_percpu(m->scratch);
+out_scratch:
 =09kfree(m);
=20
 =09return err;
@@ -2198,16 +2272,21 @@ static void nft_pipapo_destroy(const struct nft_set=
 *set)
 =09=09=09nft_set_elem_destroy(set, e, true);
 =09=09}
=20
+#ifdef NFT_PIPAPO_ALIGN
+=09=09free_percpu(m->scratch_aligned);
+#endif
 =09=09for_each_possible_cpu(cpu)
 =09=09=09kfree(*per_cpu_ptr(m->scratch, cpu));
 =09=09free_percpu(m->scratch);
-
 =09=09pipapo_free_fields(m);
 =09=09kfree(m);
 =09=09priv->match =3D NULL;
 =09}
=20
 =09if (priv->clone) {
+#ifdef NFT_PIPAPO_ALIGN
+=09=09free_percpu(priv->clone->scratch_aligned);
+#endif
 =09=09for_each_possible_cpu(cpu)
 =09=09=09kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
 =09=09free_percpu(priv->clone->scratch);
--=20
2.20.1

