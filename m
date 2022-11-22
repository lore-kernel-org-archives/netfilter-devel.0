Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D229C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 19:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiKVTbE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 14:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiKVTbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 14:31:03 -0500
X-Greylist: delayed 717 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 11:31:01 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A4C8FFAC
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 11:31:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id F0650CC0101;
        Tue, 22 Nov 2022 20:30:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1669145457; x=1670959858; bh=903GefYr+6
        TkmeMak7EV+GPzECVloL1NhRUalDMEDjI=; b=BpopaFHQHMpBj+K8BaIhx3WDHt
        X8b7/53nFkmgyceVoCvShxfq0xqt9LUvE1hvGmyOC6cSqnlaJQyaNKtGjQc5j5wz
        NadSfYKoGpog8CkLZlg6pHCN1a6vGTyvc3M5CJpcDFs0XZ402V1l9mjSz7cQWxEx
        dVHfSpD/enJw1sb1w=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 22 Nov 2022 20:30:57 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id A770ACC02A4;
        Tue, 22 Nov 2022 20:30:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9F96D343158; Tue, 22 Nov 2022 20:30:57 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: Add support for new bitmask parameter
Date:   Tue, 22 Nov 2022 20:30:57 +0100
Message-Id: <20221122193057.1052032-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221122193057.1052032-1-kadlec@netfilter.org>
References: <20221122193057.1052032-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vishwanath Pai <vpai@akamai.com>

Add a new parameter to complement the existing 'netmask' option. The
main difference between netmask and bitmask is that bitmask takes any
arbitrary ip address as input, it does not have to be a valid netmask.

The name of the new parameter is 'bitmask'. This lets us mask out
arbitrary bits in the ip address, for example:
ipset create set1 hash:ip bitmask 255.128.255.0
ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h      | 10 +++
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 71 ++++++++++++++++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 19 +++---
 net/netfilter/ipset/ip_set_hash_ipport.c    | 24 ++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c    | 26 ++++++--
 6 files changed, 126 insertions(+), 26 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index ada1296c87d5..ab934ad951a8 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -515,6 +515,16 @@ ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 	*skbinfo =3D ext->skbinfo;
 }
=20
+static inline void
+nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
+			  const union nf_inet_addr *mask)
+{
+	a1->all[0] &=3D mask->all[0];
+	a1->all[1] &=3D mask->all[1];
+	a1->all[2] &=3D mask->all[2];
+	a1->all[3] &=3D mask->all[3];
+}
+
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
 	{ .bytes =3D (skb)->len, .packets =3D 1, .target =3D true,\
 	  .timeout =3D ip_set_adt_opt_timeout(opt, set) }
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
index 79e5d68b87af..333807efd32b 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -85,6 +85,7 @@ enum {
 	IPSET_ATTR_CADT_LINENO =3D IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
 	IPSET_ATTR_MARKMASK,	/* 11 */
+	IPSET_ATTR_BITMASK,	/* 12 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX =3D 16,
 	/* Create-only specific attributes */
@@ -153,6 +154,7 @@ enum ipset_errno {
 	IPSET_ERR_COMMENT,
 	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_SKBINFO,
+	IPSET_ERR_BITMASK_NETMASK_EXCL,
=20
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC =3D 4352,
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 3adc291d9ce1..fdb5225a3e5c 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -159,6 +159,17 @@ htable_size(u8 hbits)
 	(SET_WITH_TIMEOUT(set) &&	\
 	 ip_set_timeout_expired(ext_timeout(d, set)))
=20
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
+static const union nf_inet_addr onesmask =3D {
+	.all[0] =3D 0xffffffff,
+	.all[1] =3D 0xffffffff,
+	.all[2] =3D 0xffffffff,
+	.all[3] =3D 0xffffffff
+};
+
+static const union nf_inet_addr zeromask =3D {};
+#endif
+
 #endif /* _IP_SET_HASH_GEN_H */
=20
 #ifndef MTYPE
@@ -283,8 +294,9 @@ struct htype {
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
 	u8 bucketsize;		/* max elements in an array block */
-#ifdef IP_SET_HASH_WITH_NETMASK
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
 	u8 netmask;		/* netmask value for subnets to store */
+	union nf_inet_addr bitmask;	/* stores bitmask */
 #endif
 	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
@@ -459,8 +471,8 @@ mtype_same_set(const struct ip_set *a, const struct i=
p_set *b)
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem =3D=3D y->maxelem &&
 	       a->timeout =3D=3D b->timeout &&
-#ifdef IP_SET_HASH_WITH_NETMASK
-	       x->netmask =3D=3D y->netmask &&
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
+	       nf_inet_addr_cmp(&x->bitmask, &y->bitmask) &&
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	       x->markmask =3D=3D y->markmask &&
@@ -1264,9 +1276,21 @@ mtype_head(struct ip_set *set, struct sk_buff *skb=
)
 			  htonl(jhash_size(htable_bits))) ||
 	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
+#ifdef IP_SET_HASH_WITH_BITMASK
+	/* if netmask is set to anything other than HOST_MASK we know that the =
user supplied netmask
+	 * and not bitmask. These two are mutually exclusive. */
+	if (h->netmask =3D=3D HOST_MASK && !nf_inet_addr_cmp(&onesmask, &h->bit=
mask)) {
+		if (set->family =3D=3D NFPROTO_IPV4) {
+			if (nla_put_ipaddr4(skb, IPSET_ATTR_BITMASK, h->bitmask.ip))
+				goto nla_put_failure;
+		} else if (set->family =3D=3D NFPROTO_IPV6) {
+			if (nla_put_ipaddr6(skb, IPSET_ATTR_BITMASK, &h->bitmask.in6))
+				goto nla_put_failure;
+		}
+	}
+#endif
 #ifdef IP_SET_HASH_WITH_NETMASK
-	if (h->netmask !=3D HOST_MASK &&
-	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
+	if (h->netmask !=3D HOST_MASK && nla_put_u8(skb, IPSET_ATTR_NETMASK, h-=
>netmask))
 		goto nla_put_failure;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
@@ -1429,8 +1453,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struc=
t ip_set *set,
 	u32 markmask;
 #endif
 	u8 hbits;
-#ifdef IP_SET_HASH_WITH_NETMASK
-	u8 netmask;
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
+	int ret __attribute__((unused)) =3D 0;
+	u8 netmask =3D set->family =3D=3D NFPROTO_IPV4 ? 32 : 128;
+	union nf_inet_addr bitmask =3D onesmask;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1468,7 +1494,6 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 #endif
=20
 #ifdef IP_SET_HASH_WITH_NETMASK
-	netmask =3D set->family =3D=3D NFPROTO_IPV4 ? 32 : 128;
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask =3D nla_get_u8(tb[IPSET_ATTR_NETMASK]);
=20
@@ -1476,6 +1501,33 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struc=
t ip_set *set,
 		    (set->family =3D=3D NFPROTO_IPV6 && netmask > 128) ||
 		    netmask =3D=3D 0)
 			return -IPSET_ERR_INVALID_NETMASK;
+
+		/* we convert netmask to bitmask and store it */
+		if (set->family =3D=3D NFPROTO_IPV4)
+			bitmask.ip =3D ip_set_netmask(netmask);
+		else
+			ip6_netmask(&bitmask, netmask);
+	}
+#endif
+
+#ifdef IP_SET_HASH_WITH_BITMASK
+	if (tb[IPSET_ATTR_BITMASK]) {
+		/* bitmask and netmask do the same thing, allow only one of these opti=
ons */
+		if (tb[IPSET_ATTR_NETMASK])
+			return -IPSET_ERR_BITMASK_NETMASK_EXCL;
+
+		if (set->family =3D=3D NFPROTO_IPV4) {
+			ret =3D ip_set_get_ipaddr4(tb[IPSET_ATTR_BITMASK], &bitmask.ip);
+			if (ret || !bitmask.ip)
+				return -IPSET_ERR_INVALID_NETMASK;
+		} else if (set->family =3D=3D NFPROTO_IPV6) {
+			ret =3D ip_set_get_ipaddr6(tb[IPSET_ATTR_BITMASK], &bitmask);
+			if (ret || ipv6_addr_any(&bitmask.in6))
+				return -IPSET_ERR_INVALID_NETMASK;
+		}
+
+		if (nf_inet_addr_cmp(&bitmask, &zeromask))
+			return -IPSET_ERR_INVALID_NETMASK;
 	}
 #endif
=20
@@ -1518,7 +1570,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct=
 ip_set *set,
 	for (i =3D 0; i < ahash_numof_locks(hbits); i++)
 		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem =3D maxelem;
-#ifdef IP_SET_HASH_WITH_NETMASK
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMAS=
K)
+	h->bitmask =3D bitmask;
 	h->netmask =3D netmask;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/i=
p_set_hash_ip.c
index dd30c03d5a23..556f74268a28 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
 /*				2	   Comments support */
 /*				3	   Forceadd support */
 /*				4	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
+/*				5	   bucketsize, initval support  */
+#define IPSET_TYPE_REV_MAX	6	/* bitmask support  */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -34,6 +35,7 @@ MODULE_ALIAS("ip_set_hash:ip");
 /* Type specific function prefix */
 #define HTYPE		hash_ip
 #define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
=20
 /* IPv4 variant */
=20
@@ -86,7 +88,7 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff =
*skb,
 	__be32 ip;
=20
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
-	ip &=3D ip_set_netmask(h->netmask);
+	ip &=3D h->bitmask.ip;
 	if (ip =3D=3D 0)
 		return -EINVAL;
=20
@@ -119,7 +121,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[]=
,
 	if (ret)
 		return ret;
=20
-	ip &=3D ip_set_hostmask(h->netmask);
+	ip &=3D ntohl(h->bitmask.ip);
 	e.ip =3D htonl(ip);
 	if (e.ip =3D=3D 0)
 		return -IPSET_ERR_HASH_ELEM;
@@ -187,12 +189,6 @@ hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
 }
=20
-static void
-hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip6_netmask(ip, prefix);
-}
-
 static bool
 hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
 {
@@ -229,7 +225,7 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buf=
f *skb,
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	hash_ip6_netmask(&e.ip, h->netmask);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -EINVAL;
=20
@@ -268,7 +264,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[]=
,
 	if (ret)
 		return ret;
=20
-	hash_ip6_netmask(&e.ip, h->netmask);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -IPSET_ERR_HASH_ELEM;
=20
@@ -295,6 +291,7 @@ static struct ip_set_type hash_ip_type __read_mostly =
=3D {
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_NETMASK]	=3D { .type =3D NLA_U8  },
+		[IPSET_ATTR_BITMASK]	=3D { .type =3D NLA_NESTED },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
 	},
 	.adt_policy	=3D {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ips=
et/ip_set_hash_ipport.c
index 7303138e46be..2ffbd0b78a8c 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,8 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
+/*				6    bucketsize, initval support added */
+#define IPSET_TYPE_REV_MAX	7 /* bitmask support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -35,6 +36,8 @@ MODULE_ALIAS("ip_set_hash:ip,port");
=20
 /* Type specific function prefix */
 #define HTYPE		hash_ipport
+#define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
=20
 /* IPv4 variant */
=20
@@ -92,12 +95,16 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk=
_buff *skb,
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipport4_elem e =3D { .ip =3D 0 };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h =3D set->data;
=20
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
=20
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	e.ip &=3D h->bitmask.ip;
+	if (e.ip =3D=3D 0)
+		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
=20
@@ -129,6 +136,10 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	if (ret)
 		return ret;
=20
+	e.ip &=3D h->bitmask.ip;
+	if (e.ip =3D=3D 0)
+		return -EINVAL;
+
 	e.port =3D nla_get_be16(tb[IPSET_ATTR_PORT]);
=20
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -253,12 +264,17 @@ hash_ipport6_kadt(struct ip_set *set, const struct =
sk_buff *skb,
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipport6_elem e =3D { .ip =3D { .all =3D { 0 } } };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h =3D set->data;
=20
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
=20
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
=20
@@ -298,6 +314,10 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	if (ret)
 		return ret;
=20
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	e.port =3D nla_get_be16(tb[IPSET_ATTR_PORT]);
=20
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -356,6 +376,8 @@ static struct ip_set_type hash_ipport_type __read_mos=
tly =3D {
 		[IPSET_ATTR_PROTO]	=3D { .type =3D NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_NETMASK]	=3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BITMASK]	=3D { .type =3D NLA_NESTED },
 	},
 	.adt_policy	=3D {
 		[IPSET_ATTR_IP]		=3D { .type =3D NLA_NESTED },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 3d09eefe998a..cdfb78c6e0d3 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -23,7 +23,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
 /*				2	   skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support added */
+/*				3	   bucketsize, initval support added */
+#define IPSET_TYPE_REV_MAX	4	/* bitmask support added */
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -33,6 +34,8 @@ MODULE_ALIAS("ip_set_hash:net,net");
 /* Type specific function prefix */
 #define HTYPE		hash_netnet
 #define IP_SET_HASH_WITH_NETS
+#define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
 #define IPSET_NET_COUNT 2
=20
 /* IPv4 variants */
@@ -153,8 +156,8 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk=
_buff *skb,
=20
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
 	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1]);
-	e.ip[0] &=3D ip_set_netmask(e.cidr[0]);
-	e.ip[1] &=3D ip_set_netmask(e.cidr[1]);
+	e.ip[0] &=3D (ip_set_netmask(e.cidr[0]) & h->bitmask.ip);
+	e.ip[1] &=3D (ip_set_netmask(e.cidr[1]) & h->bitmask.ip);
=20
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -213,8 +216,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *=
tb[],
=20
 	if (adt =3D=3D IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] ||
 				   tb[IPSET_ATTR_IP2_TO])) {
-		e.ip[0] =3D htonl(ip & ip_set_hostmask(e.cidr[0]));
-		e.ip[1] =3D htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
+		e.ip[0] =3D htonl(ip & ntohl(h->bitmask.ip) & ip_set_hostmask(e.cidr[0=
]));
+		e.ip[1] =3D htonl(ip2_from & ntohl(h->bitmask.ip) & ip_set_hostmask(e.=
cidr[1]));
 		ret =3D adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -404,6 +407,11 @@ hash_netnet6_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
=20
+	nf_inet_addr_mask_inplace(&e.ip[0], &h->bitmask);
+	nf_inet_addr_mask_inplace(&e.ip[1], &h->bitmask);
+	if (e.cidr[0] =3D=3D HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
=20
@@ -414,6 +422,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *=
tb[],
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netnet6_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_UEXT(set);
+	const struct hash_netnet6 *h =3D set->data;
 	int ret;
=20
 	if (tb[IPSET_ATTR_LINENO])
@@ -453,6 +462,11 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr =
*tb[],
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
=20
+	nf_inet_addr_mask_inplace(&e.ip[0], &h->bitmask);
+	nf_inet_addr_mask_inplace(&e.ip[1], &h->bitmask);
+	if (e.cidr[0] =3D=3D HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -IPSET_ERR_HASH_ELEM;
+
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags =3D ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
=20
@@ -484,6 +498,8 @@ static struct ip_set_type hash_netnet_type __read_mos=
tly =3D {
 		[IPSET_ATTR_RESIZE]	=3D { .type =3D NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	=3D { .type =3D NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	=3D { .type =3D NLA_U32 },
+		[IPSET_ATTR_NETMASK]    =3D { .type =3D NLA_U8 },
+		[IPSET_ATTR_BITMASK]	=3D { .type =3D NLA_NESTED },
 	},
 	.adt_policy	=3D {
 		[IPSET_ATTR_IP]		=3D { .type =3D NLA_NESTED },
--=20
2.30.2

