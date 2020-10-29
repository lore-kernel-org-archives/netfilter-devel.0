Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38642C4363A
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802242076B
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ofufj60u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgJ2Ps1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:48:27 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:54051 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgJ2Ps1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 11:48:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 3C3FB3C8013C;
        Thu, 29 Oct 2020 16:39:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1603985990; x=1605800391; bh=J4P1en5y1s
        0oiceMnuRAuyMqyN6sf5cqJvtKOMxWSq8=; b=ofufj60ugl+34AMYVRwCSBHbvX
        MSlodla+jV9biECND467QoKZBim1EBH0C2K/JpkjOfHRX3g/Y/dcDmambZl1/EQ7
        BE90DSJwti43d/Rg4hXajN9VA3JAoGzf93qaNX5+/ZlXB75h0MmOXCwGZoBKXrJx
        SJUufbUwXlWxjyckk=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 29 Oct 2020 16:39:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id F08D93C8013D;
        Thu, 29 Oct 2020 16:39:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id E3E7A340D6E; Thu, 29 Oct 2020 16:39:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/4] netfilter: ipset: Expose the initval hash parameter to userspace
Date:   Thu, 29 Oct 2020 16:39:49 +0100
Message-Id: <20201029153949.6567-5-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201029153949.6567-1-kadlec@netfilter.org>
References: <20201029153949.6567-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It makes possible to reproduce exactly the same set after a save/restore.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/uapi/linux/netfilter/ipset/ip_set.h  |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h        | 13 +++++++++----
 net/netfilter/ipset/ip_set_hash_ip.c         |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipmac.c      |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 ++-
 net/netfilter/ipset/ip_set_hash_mac.c        |  3 ++-
 net/netfilter/ipset/ip_set_hash_net.c        |  3 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  3 ++-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  3 ++-
 net/netfilter/ipset/ip_set_hash_netport.c    |  3 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  3 ++-
 14 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
index 398f7b909b7d..6397d75899bc 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -92,7 +92,7 @@ enum {
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX =3D 16,
 	/* Create-only specific attributes */
-	IPSET_ATTR_GC,
+	IPSET_ATTR_INITVAL,	/* was unused IPSET_ATTR_GC */
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
 	IPSET_ATTR_NETMASK,
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 4e3544442b26..5f1208ad049e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1301,9 +1301,11 @@ mtype_head(struct ip_set *set, struct sk_buff *skb=
)
 	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
 		goto nla_put_failure;
 #endif
-	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE &&
-	    nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize))
-		goto nla_put_failure;
+	if (set->flags & IPSET_CREATE_FLAG_BUCKETSIZE) {
+		if (nla_put_u8(skb, IPSET_ATTR_BUCKETSIZE, h->bucketsize) ||
+		    nla_put_net32(skb, IPSET_ATTR_INITVAL, htonl(h->initval)))
+			goto nla_put_failure;
+	}
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
 	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(elements)))
@@ -1546,7 +1548,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struc=
t ip_set *set,
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	h->markmask =3D markmask;
 #endif
-	get_random_bytes(&h->initval, sizeof(h->initval));
+	if (tb[IPSET_ATTR_INITVAL])
+		h->initval =3D ntohl(nla_get_be32(tb[IPSET_ATTR_INITVAL]));
+	else
+		get_random_bytes(&h->initval, sizeof(h->initval));
 	h->bucketsize =3D AHASH_MAX_SIZE;
 	if (tb[IPSET_ATTR_BUCKETSIZE]) {
 		h->bucketsize =3D nla_get_u8(tb[IPSET_ATTR_BUCKETSIZE]);
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index 0495d515c498..d1bef23fd4f5 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,7 @@
 /*				2	   Comments support */
 /*				3	   Forceadd support */
 /*				4	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	5	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -283,6 +283,7 @@ static struct ip_set_type hash_ip_type __read_mostly =
=3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipse=
t/ip_set_hash_ipmac.c
index 2655501f9fe3..467c59a83c0a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
=20
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize, initval support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Chilinski <tomasz.chilinski@chilan.com>");
@@ -273,6 +273,7 @@ static struct ip_set_type hash_ipmac_type __read_most=
ly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ips=
et/ip_set_hash_ipmark.c
index 5bbed85d0e47..18346d18aa16 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -22,7 +22,7 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support */
 /*				2	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize support  */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vytas Dauksa <vytas.dauksa@smoothwall.net>");
@@ -281,6 +281,7 @@ static struct ip_set_type hash_ipmark_type __read_mos=
tly =3D {
 		[IPSET_ATTR_MARKMASK]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index c1ac2e89e2d3..e1ca11196515 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,7 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -347,6 +347,7 @@ static struct ip_set_type hash_ipport_type __read_mos=
tly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/i=
pset/ip_set_hash_ipportip.c
index d3f4a672986e..ab179e064597 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -26,7 +26,7 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -362,6 +362,7 @@ static struct ip_set_type hash_ipportip_type __read_m=
ostly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 8f7fe360736a..8f075b44cf64 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -28,7 +28,7 @@
 /*				5    Comments support added */
 /*				6    Forceadd support added */
 /*				7    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -519,6 +519,7 @@ static struct ip_set_type hash_ipportnet_type __read_=
mostly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/=
ip_set_hash_mac.c
index 00dd7e20df3c..718814730acf 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/ipset/ip_set_hash.h>
=20
 #define IPSET_TYPE_REV_MIN	0
-#define IPSET_TYPE_REV_MAX	1	/* bucketsize support */
+#define IPSET_TYPE_REV_MAX	1	/* bucketsize, initval support */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -130,6 +130,7 @@ static struct ip_set_type hash_mac_type __read_mostly=
 =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index d366e816b6ed..c1a11f041ac6 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -25,7 +25,7 @@
 /*				4    Comments support added */
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	7 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	7 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -360,6 +360,7 @@ static struct ip_set_type hash_net_type __read_mostly=
 =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index 38b1d77584d4..3d74169b794c 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -27,7 +27,7 @@
 /*				5    Forceadd support added */
 /*				6    skbinfo support added */
 /*				7    interface wildcard support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -476,6 +476,7 @@ static struct ip_set_type hash_netiface_type __read_m=
ostly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 0cc7970f36e9..6532f0505e66 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -23,7 +23,7 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
 /*				2	   skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -465,6 +465,7 @@ static struct ip_set_type hash_netnet_type __read_mos=
tly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index b356d7d85e34..ec1564a1cb5a 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -27,7 +27,7 @@
 /*				5    Comments support added */
 /*				6    Forceadd support added */
 /*				7    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	8 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	8 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -466,6 +466,7 @@ static struct ip_set_type hash_netport_type __read_mo=
stly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index eeb39688f26f..0e91d1e82f1c 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -24,7 +24,7 @@
 /*				0    Comments support added */
 /*				1    Forceadd support added */
 /*				2    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3 /* bucketsize support added */
+#define IPSET_TYPE_REV_MAX	3 /* bucketsize, initval support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -564,6 +564,7 @@ static struct ip_set_type hash_netportnet_type __read=
_mostly =3D {
 	.create_policy	=3D {
 		[IPSET_ATTR_HASHSIZE]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_INITVAL]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_BUCKETSIZE]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
--=20
2.20.1

