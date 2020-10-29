Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A34C4363A
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6F1B20838
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="pkX9KEde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgJ2Pqy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728370AbgJ2Pqx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 11:46:53 -0400
X-Greylist: delayed 416 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Oct 2020 08:46:53 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF13C0613D2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 08:46:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 5091D674014C;
        Thu, 29 Oct 2020 16:39:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1603985990; x=1605800391; bh=ucA87H4atT
        05mgXspRFXLkFlXEjF1OmMzqMgVJjJYKo=; b=pkX9KEdeaE/xwHZOu2kqM7YYt3
        LQpFZMHKhOrBM3+X9ZxkiMLuiCg0erc+ukBP/wDTx0a3f5vWVmta3ZjMAFAsuwXg
        abqjqrUE5Ubk2Yufpsr7KWyXf4ns3kpR7oeP3ECv9vXyYXDgqvl+ieJ7VbYt7TP5
        hF3KoOMsALgMLxMZU=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 29 Oct 2020 16:39:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id E86816740149;
        Thu, 29 Oct 2020 16:39:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id DCC06340D6B; Thu, 29 Oct 2020 16:39:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] netfilter: ipset: Add bucketsize parameter to all hash types
Date:   Thu, 29 Oct 2020 16:39:48 +0100
Message-Id: <20201029153949.6567-4-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201029153949.6567-1-kadlec@netfilter.org>
References: <20201029153949.6567-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The parameter defines the upper limit in any hash bucket at adding new en=
tries
from userspace - if the limit would be exceeded, ipset doubles the hash s=
ize
and rehashes. It means the set may consume more memory but gives faster
evaluation at matching in the set.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h       |  5 +++
 include/uapi/linux/netfilter/ipset/ip_set.h  |  4 ++-
 net/netfilter/ipset/ip_set_core.c            |  2 ++
 net/netfilter/ipset/ip_set_hash_gen.h        | 38 ++++++++++++--------
 net/netfilter/ipset/ip_set_hash_ip.c         |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  5 +--
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  6 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  6 ++--
 net/netfilter/ipset/ip_set_hash_mac.c        |  5 +--
 net/netfilter/ipset/ip_set_hash_net.c        |  6 ++--
 net/netfilter/ipset/ip_set_hash_netiface.c   |  6 ++--
 net/netfilter/ipset/ip_set_hash_netnet.c     |  6 ++--
 net/netfilter/ipset/ip_set_hash_netport.c    |  6 ++--
 net/netfilter/ipset/ip_set_hash_netportnet.c |  6 ++--
 16 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index ab192720e2d6..46d9a0c26c67 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -198,6 +198,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
=20
+/* The max revision number supported by any set type + 1 */
+#define IPSET_REVISION_MAX	9
+
 /* The core set type structure */
 struct ip_set_type {
 	struct list_head list;
@@ -215,6 +218,8 @@ struct ip_set_type {
 	u8 family;
 	/* Type revisions */
 	u8 revision_min, revision_max;
+	/* Revision-specific supported (create) flags */
+	u8 create_flags[IPSET_REVISION_MAX+1];
 	/* Set features to control swapping */
 	u16 features;
=20
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
index 11a72a938eb1..398f7b909b7d 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -96,7 +96,7 @@ enum {
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
 	IPSET_ATTR_NETMASK,
-	IPSET_ATTR_PROBES,
+	IPSET_ATTR_BUCKETSIZE,	/* was unused IPSET_ATTR_PROBES */
 	IPSET_ATTR_RESIZE,
 	IPSET_ATTR_SIZE,
 	/* Kernel-only */
@@ -214,6 +214,8 @@ enum ipset_cadt_flags {
 enum ipset_create_flags {
 	IPSET_CREATE_FLAG_BIT_FORCEADD =3D 0,
 	IPSET_CREATE_FLAG_FORCEADD =3D (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
+	IPSET_CREATE_FLAG_BIT_BUCKETSIZE =3D 1,
+	IPSET_CREATE_FLAG_BUCKETSIZE =3D (1 << IPSET_CREATE_FLAG_BIT_BUCKETSIZE=
),
 	IPSET_CREATE_FLAG_BIT_MAX =3D 7,
 };
=20
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 8d459725311e..c7eaa3776238 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1110,6 +1110,8 @@ static int ip_set_create(struct net *net, struct so=
ck *ctnl,
 		ret =3D -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
+	/* Set create flags depending on the type revision */
+	set->flags |=3D set->type->create_flags[revision];
=20
 	ret =3D set->type->create(net, set, tb, flags);
 	if (ret !=3D 0)
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 521e970be402..4e3544442b26 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -37,18 +37,18 @@
  */
=20
 /* Number of elements to store in an initial array block */
-#define AHASH_INIT_SIZE			4
+#define AHASH_INIT_SIZE			2
 /* Max number of elements to store in an array block */
-#define AHASH_MAX_SIZE			(3 * AHASH_INIT_SIZE)
+#define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
 /* Max muber of elements in the array block when tuned */
 #define AHASH_MAX_TUNED			64
=20
+#define AHASH_MAX(h)			((h)->bucketsize)
+
 /* Max number of elements can be tuned */
 #ifdef IP_SET_HASH_WITH_MULTI
-#define AHASH_MAX(h)			((h)->ahash_max)
-
 static u8
-tune_ahash_max(u8 curr, u32 multi)
+tune_bucketsize(u8 curr, u32 multi)
 {
 	u32 n;
=20
@@ -61,12 +61,10 @@ tune_ahash_max(u8 curr, u32 multi)
 	 */
 	return n > curr && n <=3D AHASH_MAX_TUNED ? n : curr;
 }
-
-#define TUNE_AHASH_MAX(h, multi)	\
-	((h)->ahash_max =3D tune_ahash_max((h)->ahash_max, multi))
+#define TUNE_BUCKETSIZE(h, multi)	\
+	((h)->bucketsize =3D tune_bucketsize((h)->bucketsize, multi))
 #else
-#define AHASH_MAX(h)			AHASH_MAX_SIZE
-#define TUNE_AHASH_MAX(h, multi)
+#define TUNE_BUCKETSIZE(h, multi)
 #endif
=20
 /* A hash bucket */
@@ -321,9 +319,7 @@ struct htype {
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
-#ifdef IP_SET_HASH_WITH_MULTI
-	u8 ahash_max;		/* max elements in an array block */
-#endif
+	u8 bucketsize;		/* max elements in an array block */
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
 #endif
@@ -950,7 +946,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >=3D n->size) {
-		TUNE_AHASH_MAX(h, multi);
+		TUNE_BUCKETSIZE(h, multi);
 		if (n->size >=3D AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);
@@ -1305,6 +1301,9 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
 		goto nla_put_failure;
 #endif
+	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE &&
+	    nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize))
+		goto nla_put_failure;
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
 	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(elements)))
@@ -1548,7 +1547,16 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struc=
t ip_set *set,
 	h->markmask =3D markmask;
 #endif
 	get_random_bytes(&h->initval, sizeof(h->initval));
-
+	h->bucketsize =3D AHASH_MAX_SIZE;
+	if (tb[IPSET_ATTR_BUCKETSIZE]) {
+		h->bucketsize =3D nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
+		if (h->bucketsize < AHASH_INIT_SIZE)
+			h->bucketsize =3D AHASH_INIT_SIZE;
+		else if (h->bucketsize > AHASH_MAX_SIZE)
+			h->bucketsize =3D AHASH_MAX_SIZE;
+		else if (h->bucketsize % 2)
+			h->bucketsize +=3D 1;
+	}
 	t->htable_bits =3D hbits;
 	t->maxelem =3D h->maxelem / ahash_numof_locks(hbits);
 	RCU_INIT_POINTER(h->table, t);
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index 5d6d68eaf6a9..0495d515c498 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -23,7 +23,8 @@
 /*				1	   Counters support */
 /*				2	   Comments support */
 /*				3	   Forceadd support */
-#define IPSET_TYPE_REV_MAX	4	/* skbinfo support  */
+/*				4	   skbinfo support */
+#define IPSET_TYPE_REV_MAX	5	/* bucketsize support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -277,11 +278,12 @@ static struct ip_set_type hash_ip_type __read_mostl=
y =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ip_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_NETMASK]	=3D { .type =3D NLA_U8  },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipse=
t/ip_set_hash_ipmac.c
index eceb7bc4a93a..2655501f9fe3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
=20
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Chilinski <tomasz.chilinski@chilan.com>");
@@ -268,11 +268,12 @@ static struct ip_set_type hash_ipmac_type __read_mo=
stly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ipmac_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ips=
et/ip_set_hash_ipmark.c
index aba1df617d6e..5bbed85d0e47 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -21,7 +21,8 @@
=20
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support */
-#define IPSET_TYPE_REV_MAX	2	/* skbinfo support  */
+/*				2	   skbinfo support */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
@@ -274,12 +275,13 @@ static struct ip_set_type hash_ipmark_type __read_m=
ostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ipmark_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_MARKMASK]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index 1ff228717e29..c1ac2e89e2d3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -25,7 +25,8 @@
 /*				2    Counters support added */
 /*				3    Comments support added */
 /*				4    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
+/*				5    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -341,11 +342,12 @@ static struct ip_set_type hash_ipport_type __read_m=
ostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ipport_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/i=
pset/ip_set_hash_ipportip.c
index fa88afd812fa..d3f4a672986e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -25,7 +25,8 @@
 /*				2    Counters support added */
 /*				3    Comments support added */
 /*				4    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	5 /* skbinfo support added */
+/*				5    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -356,11 +357,12 @@ static struct ip_set_type hash_ipportip_type __read=
_mostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ipportip_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index eef6ecfcb409..8f7fe360736a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -27,7 +27,8 @@
 /*				4    Counters support added */
 /*				5    Comments support added */
 /*				6    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
+/*				7    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -513,11 +514,12 @@ static struct ip_set_type hash_ipportnet_type __rea=
d_mostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_ipportnet_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/=
ip_set_hash_mac.c
index 0b61593165ef..00dd7e20df3c 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
=20
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	0
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize support */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -125,11 +125,12 @@ static struct ip_set_type hash_mac_type __read_most=
ly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_mac_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index 136cf0781d3a..d366e816b6ed 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -24,7 +24,8 @@
 /*				3    Counters support added */
 /*				4    Comments support added */
 /*				5    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	6 /* skbinfo mapping support added */
+/*				6    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	7 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -354,11 +355,12 @@ static struct ip_set_type hash_net_type __read_most=
ly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_net_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index be5e95a0d876..38b1d77584d4 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -26,7 +26,8 @@
 /*				4    Comments support added */
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	7 /* interface wildcard support added */
+/*				7    interface wildcard support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -470,11 +471,12 @@ static struct ip_set_type hash_netiface_type __read=
_mostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_netiface_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index da4ef910b12d..0cc7970f36e9 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -22,7 +22,8 @@
=20
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
-#define IPSET_TYPE_REV_MAX	2	/* skbinfo support added */
+/*				2	   skbinfo support added */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -459,11 +460,12 @@ static struct ip_set_type hash_netnet_type __read_m=
ostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_netnet_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index 34448df80fb9..b356d7d85e34 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -26,7 +26,8 @@
 /*				4    Counters support added */
 /*				5    Comments support added */
 /*				6    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	7 /* skbinfo support added */
+/*				7    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -460,11 +461,12 @@ static struct ip_set_type hash_netport_type __read_=
mostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_netport_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index 934c1712cba8..eeb39688f26f 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -23,7 +23,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				0    Comments support added */
 /*				1    Forceadd support added */
-#define IPSET_TYPE_REV_MAX	2 /* skbinfo support added */
+/*				2    skbinfo support added */
+#define IPSET_TYPE_REV_MAX	3 /* bucketsize support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -558,11 +559,12 @@ static struct ip_set_type hash_netportnet_type __re=
ad_mostly =3D {
 	.family		=3D NFPROTO_UNSPEC,
 	.revision_min	=3D IPSET_TYPE_REV_MIN,
 	.revision_max	=3D IPSET_TYPE_REV_MAX,
+	.create_flags[IPSET_TYPE_REV_MAX] =3D IPSET_CREATE_FLAG_BUCKETSIZE,
 	.create		=3D hash_netportnet_create,
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
-		[IPSET_ATTR_PROBES]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
--=20
2.20.1

