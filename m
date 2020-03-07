Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A1FC10F25
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDE420684
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UwuyHyMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCGQxG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:53:06 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32196 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgCGQxG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 11:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583599985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5j58xO7W7+BRtEoI4jRh/3IiVG28SjfKnK4RCssWCxU=;
        b=UwuyHyMdKqwZ5JLr0xDL6hb50ZLl/eIhPR+olU0MLcedOcRxQ//JNszEr/7MXYPvWT+fbw
        VqlRS4YxT/mR6ddYgR4pc9kLpmDBnLWLJlqDMqbAYCOzwsGwoa/ik21t3juspmwT7cIJNL
        DNuCzN4X10WX6T/d7evMLxTg3JgnO/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-a_-PWya-NymmEn26cun-fw-1; Sat, 07 Mar 2020 11:53:04 -0500
X-MC-Unique: a_-PWya-NymmEn26cun-fw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55524189F762;
        Sat,  7 Mar 2020 16:53:03 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09CF46E3EE;
        Sat,  7 Mar 2020 16:53:01 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 6/6] nft_set_pipapo: Prepare for single ranged field usage
Date:   Sat,  7 Mar 2020 17:52:37 +0100
Message-Id: <be7d4e51603633e7b88e4b0dde54b25a3e5a018b.1583598508.git.sbrivio@redhat.com>
In-Reply-To: <cover.1583598508.git.sbrivio@redhat.com>
References: <cover.1583598508.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A few adjustments in nft_pipapo_init() are needed to allow usage of
this set back-end for a single, ranged field.

Provide a convenient NFT_PIPAPO_MIN_FIELDS definition that currently
makes sure that the rbtree back-end is selected instead, for sets
with a single field.

This finally allows a fair comparison with rbtree sets, by defining
NFT_PIPAPO_MIN_FIELDS as 0 and skipping rbtree back-end initialisation:

 ---------------.--------------------------.-------------------------.
 AMD Epyc 7402  |      baselines, Mpps     |   Mpps, % over rbtree   |
  1 thread      |__________________________|_________________________|
  3.35GHz       |        |        |        |            |            |
  768KiB L1D$   | netdev |  hash  | rbtree |            |   pipapo   |
 ---------------|  hook  |   no   | single |   pipapo   |single field|
 type   entries |  drop  | ranges | field  |single field|    AVX2    |
 ---------------|--------|--------|--------|------------|------------|
 net,port       |        |        |        |            |            |
          1000  |   19.0 |   10.4 |    3.8 | 6.0   +58% | 9.6  +153% |
 ---------------|--------|--------|--------|------------|------------|
 port,net       |        |        |        |            |            |
           100  |   18.8 |   10.3 |    5.8 | 9.1   +57% |11.6  +100% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port      |        |        |        |            |            |
          1000  |   16.4 |    7.6 |    1.8 | 2.8   +55% | 6.5  +261% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |     [1]    |    [1]     |
         30000  |   19.6 |   11.6 |    3.9 | 0.9   -77% | 2.7   -31% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
         10000  |   19.6 |   11.6 |    4.4 | 2.1   -52% | 5.6   +27% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
 4 threads 10000|   77.9 |   45.1 |   17.4 | 8.3   -52% |22.4   +29% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac  |        |        |        |            |            |
            10  |   16.5 |    5.4 |    4.3 | 4.5    +5% | 8.2   +91% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac, |        |        |        |            |            |
 proto    1000  |   16.5 |    5.7 |    1.9 | 2.8   +47% | 6.6  +247% |
 ---------------|--------|--------|--------|------------|------------|
 net,mac        |        |        |        |            |            |
          1000  |   19.0 |    8.4 |    3.9 | 6.0   +54% | 9.9  +154% |
 ---------------'--------'--------'--------'------------'------------'
 [1] Causes switch of lookup table buckets for 'port' to 4-bit groups

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: New patch

 net/netfilter/nft_set_pipapo.c      | 19 ++++++++++++-------
 net/netfilter/nft_set_pipapo.h      |  3 +++
 net/netfilter/nft_set_pipapo_avx2.c |  3 ++-
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index 1e8dd5dccdf7..c1afb6c94edc 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1983,7 +1983,8 @@ static u64 nft_pipapo_privsize(const struct nlattr =
* const nla[],
 static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 fea=
tures,
 				struct nft_set_estimate *est)
 {
-	if (!(features & NFT_SET_INTERVAL) || desc->field_count <=3D 1)
+	if (!(features & NFT_SET_INTERVAL) ||
+	    desc->field_count < NFT_PIPAPO_MIN_FIELDS)
 		return false;
=20
 	est->size =3D pipapo_estimate_size(desc);
@@ -2016,17 +2017,19 @@ static int nft_pipapo_init(const struct nft_set *=
set,
 	struct nft_pipapo *priv =3D nft_set_priv(set);
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
-	int err, i;
+	int err, i, field_count;
=20
-	if (desc->field_count > NFT_PIPAPO_MAX_FIELDS)
+	field_count =3D desc->field_count ? : 1;
+
+	if (field_count > NFT_PIPAPO_MAX_FIELDS)
 		return -EINVAL;
=20
-	m =3D kmalloc(sizeof(*priv->match) + sizeof(*f) * desc->field_count,
+	m =3D kmalloc(sizeof(*priv->match) + sizeof(*f) * field_count,
 		    GFP_KERNEL);
 	if (!m)
 		return -ENOMEM;
=20
-	m->field_count =3D desc->field_count;
+	m->field_count =3D field_count;
 	m->bsize_max =3D 0;
=20
 	m->scratch =3D alloc_percpu(unsigned long *);
@@ -2050,10 +2053,12 @@ static int nft_pipapo_init(const struct nft_set *=
set,
 	rcu_head_init(&m->rcu);
=20
 	nft_pipapo_for_each_field(f, i, m) {
+		int len =3D desc->field_len[i] ? : set->klen;
+
 		f->bb =3D NFT_PIPAPO_GROUP_BITS_INIT;
-		f->groups =3D desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
+		f->groups =3D len * NFT_PIPAPO_GROUPS_PER_BYTE(f);
=20
-		priv->width +=3D round_up(desc->field_len[i], sizeof(u32));
+		priv->width +=3D round_up(len, sizeof(u32));
=20
 		f->bsize =3D 0;
 		f->rules =3D 0;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipap=
o.h
index 3cfc0a385ee2..25a75591583e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -8,6 +8,9 @@
 /* Count of concatenated fields depends on count of 32-bit nftables regi=
sters */
 #define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
=20
+/* Restrict usage to multiple fields, make sure rbtree is used otherwise=
 */
+#define NFT_PIPAPO_MIN_FIELDS		2
+
 /* Largest supported field size */
 #define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
 #define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_=
pipapo_avx2.c
index f6e20154d2b7..d65ae0e23028 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1087,7 +1087,8 @@ static int nft_pipapo_avx2_lookup_slow(unsigned lon=
g *map, unsigned long *fill,
 bool nft_pipapo_avx2_estimate(const struct nft_set_desc *desc, u32 featu=
res,
 			      struct nft_set_estimate *est)
 {
-	if (!(features & NFT_SET_INTERVAL) || desc->field_count <=3D 1)
+	if (!(features & NFT_SET_INTERVAL) ||
+	    desc->field_count < NFT_PIPAPO_MIN_FIELDS)
 		return false;
=20
 	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
--=20
2.25.1

