Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D0BC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiF2VWH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiF2VWG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:22:06 -0400
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 14:22:04 PDT
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F300E18E35
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:22:04 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TIAJHS011646;
        Wed, 29 Jun 2022 22:22:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=0Ol2OUQiil+7IDFAYGAMD3f2EB6b7HLPbaWoiccIzHs=;
 b=ZK/TIS/ZgVzShmQchgCY70hpIsaxShn8Qa91AXyYtM1Z/e+9sCmImC5myW3xyIaz29ND
 /Weg/GXPZu9aINE/JO5LlOFhh19KETF/rmCLdlFQP3ma3vi8EWllqv0m9/paGLkS/lvO
 x5+berkg9RZKwMqobSPAbDsv9NBi/FymJ/hRcxJRhhYNdckf2iYt75hCUJNp8tnTusMi
 qHwc7k/Ypo03NHbx/WPde+b/jEEbFDhCDjDcQxDKGv1f6CXmZF1+Zlk4+6BP8XUa1Q0N
 9zk9aWLg6YLoLd9/F049nhuXLdGV71YlOiYiEYU6kRmwVHerEeH1Cwt4pb+6uO5F8Jlx 8Q== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3h04bcxskw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:22:00 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TGbd5O008582;
        Wed, 29 Jun 2022 17:21:59 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.22])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3gwwpwy5r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 17:21:59 -0400
Received: from usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:21:58 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:21:58 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id B4D6E15F504; Wed, 29 Jun 2022 17:21:58 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH] netfilter: ipset: Add support for new bitmask parameter
Date:   Wed, 29 Jun 2022 17:21:09 -0400
Message-ID: <20220629212109.3045794-3-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629212109.3045794-1-vpai@akamai.com>
References: <20220629212109.3045794-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: ga8-fEwse1PBgrsTui1iZeMOCfxXIxSx
X-Proofpoint-GUID: ga8-fEwse1PBgrsTui1iZeMOCfxXIxSx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new parameter to complement the existing 'netmask' option. The
main difference between netmask and bitmask is that bitmask takes any
arbitrary ip address as input, it does not have to be a valid netmask.

The name of the new parameter is 'bitmask'. This lets us mask out
arbitrary bits in the ip address, for example:
ipset create set1 hash:ip bitmask 255.128.255.0
ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>
---
 include/linux/netfilter.h                   | 18 ++++++++
 include/uapi/linux/netfilter/ipset/ip_set.h |  1 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 48 ++++++++++++++++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 36 +++++++++++-----
 net/netfilter/ipset/ip_set_hash_ipport.c    | 39 ++++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c    | 39 +++++++++++++++--
 6 files changed, 160 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c2c6f332fb90..c184f01920e2 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -56,6 +56,24 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 #endif
 }
 
+static inline void nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
+					     const union nf_inet_addr *mask)
+{
+	a1->all[0] &= mask->all[0];
+	a1->all[1] &= mask->all[1];
+	a1->all[2] &= mask->all[2];
+	a1->all[3] &= mask->all[3];
+}
+
+static inline void nf_inet_addr_invert(const union nf_inet_addr *src,
+				       union nf_inet_addr *dst)
+{
+	dst->all[0] = ~src->all[0];
+	dst->all[1] = ~src->all[1];
+	dst->all[2] = ~src->all[2];
+	dst->all[3] = ~src->all[3];
+}
+
 int netfilter_init(void);
 
 struct sk_buff;
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 6397d75899bc..8c3046ea2362 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -89,6 +89,7 @@ enum {
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
 	IPSET_ATTR_MARKMASK,	/* 11 */
+	IPSET_ATTR_BITMASK,	/* 12 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6e391308431d..1f658b4546b6 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -182,6 +182,17 @@ htable_size(u8 hbits)
 	(SET_WITH_TIMEOUT(set) &&	\
 	 ip_set_timeout_expired(ext_timeout(d, set)))
 
+#ifdef IP_SET_HASH_WITH_NETMASK
+static const union nf_inet_addr onesmask = {
+	.all[0] = 0xffffffff,
+	.all[1] = 0xffffffff,
+	.all[2] = 0xffffffff,
+	.all[3] = 0xffffffff
+};
+
+static const union nf_inet_addr zeromask;
+#endif
+
 #endif /* _IP_SET_HASH_GEN_H */
 
 #ifndef MTYPE
@@ -308,6 +319,7 @@ struct htype {
 	u8 bucketsize;		/* max elements in an array block */
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;		/* netmask value for subnets to store */
+	union nf_inet_addr bitmask;	/* stores bitmask */
 #endif
 	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
@@ -484,6 +496,7 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 	       a->timeout == b->timeout &&
 #ifdef IP_SET_HASH_WITH_NETMASK
 	       x->netmask == y->netmask &&
+	       nf_inet_addr_cmp(&x->bitmask, &y->bitmask) &&
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	       x->markmask == y->markmask &&
@@ -1283,8 +1296,16 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
 #ifdef IP_SET_HASH_WITH_NETMASK
-	if (h->netmask != HOST_MASK &&
-	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
+	if (!nf_inet_addr_cmp(&onesmask, &h->bitmask)) {
+		if (set->family == NFPROTO_IPV4) {
+			if (nla_put_ipaddr4(skb, IPSET_ATTR_BITMASK, h->bitmask.ip))
+				goto nla_put_failure;
+		} else if (set->family == NFPROTO_IPV6) {
+			if (nla_put_ipaddr6(skb, IPSET_ATTR_BITMASK, &h->bitmask.in6))
+				goto nla_put_failure;
+		}
+	}
+	if (h->netmask != HOST_MASK && nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
 		goto nla_put_failure;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
@@ -1448,7 +1469,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 	u8 hbits;
 #ifdef IP_SET_HASH_WITH_NETMASK
-	u8 netmask;
+	int ret = 0;
+	u8 netmask = 0;
+	union nf_inet_addr bitmask = onesmask;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1489,10 +1512,22 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
-
 		if ((set->family == NFPROTO_IPV4 && netmask > 32) ||
-		    (set->family == NFPROTO_IPV6 && netmask > 128) ||
-		    netmask == 0)
+		    (set->family == NFPROTO_IPV6 && netmask > 128))
+			return -IPSET_ERR_INVALID_NETMASK;
+	}
+	if (tb[IPSET_ATTR_BITMASK]) {
+		if (set->family == NFPROTO_IPV4) {
+			ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_BITMASK], &bitmask.ip);
+			if (ret || !bitmask.ip)
+				return -IPSET_ERR_INVALID_NETMASK;
+		} else if (set->family == NFPROTO_IPV6) {
+			ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_BITMASK], &bitmask);
+			if (ret || ipv6_addr_any(&bitmask.in6))
+				return -IPSET_ERR_INVALID_NETMASK;
+		}
+
+		if (nf_inet_addr_cmp(&bitmask, &zeromask))
 			return -IPSET_ERR_INVALID_NETMASK;
 	}
 #endif
@@ -1537,6 +1572,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem = maxelem;
 #ifdef IP_SET_HASH_WITH_NETMASK
+	h->bitmask = bitmask;
 	h->netmask = netmask;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 258aeb324483..6976b4bcaa96 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
 /*				2	   Comments support */
 /*				3	   Forceadd support */
 /*				4	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
+/*				5	   bucketsize, initval support  */
+#define IPSET_TYPE_REV_MAX	6	/* bucketsize, initval support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -86,7 +87,12 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	__be32 ip;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
-	ip &= ip_set_netmask(h->netmask);
+
+	if (h->netmask != HOST_MASK)
+		ip &= ip_set_netmask(h->netmask);
+	else
+		ip &= h->bitmask.ip;
+
 	if (ip == 0)
 		return -EINVAL;
 
@@ -119,7 +125,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	ip &= ip_set_hostmask(h->netmask);
+	if (h->netmask != HOST_MASK)
+		ip &= ip_set_hostmask(h->netmask);
+	else
+		ip &= ntohl(h->bitmask.ip);
 
 	if (ip == 0)
 		return -IPSET_ERR_HASH_ELEM;
@@ -193,12 +202,6 @@ hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
 	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
 }
 
-static void
-hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
-{
-	ip6_netmask(ip, prefix);
-}
-
 static bool
 hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
 {
@@ -224,6 +227,16 @@ hash_ip6_data_next(struct hash_ip6_elem *next, const struct hash_ip6_elem *e)
 #define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
+static void
+hash_ip6_netmask(union nf_inet_addr *ip, u8 netmask,
+		 const union nf_inet_addr *bitmask)
+{
+	if (netmask != HOST_MASK)
+		ip6_netmask(ip, netmask);
+	else
+		nf_inet_addr_mask_inplace(ip, bitmask);
+}
+
 static int
 hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	      const struct xt_action_param *par,
@@ -235,7 +248,7 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	hash_ip6_netmask(&e.ip, h->netmask);
+	hash_ip6_netmask(&e.ip, h->netmask, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -EINVAL;
 
@@ -274,7 +287,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	hash_ip6_netmask(&e.ip, h->netmask);
+	hash_ip6_netmask(&e.ip, h->netmask, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -IPSET_ERR_HASH_ELEM;
 
@@ -301,6 +314,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 	},
 	.adt_policy	= {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 7303138e46be..8f5379738ffa 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -26,7 +26,8 @@
 /*				3    Comments support added */
 /*				4    Forceadd support added */
 /*				5    skbinfo support added */
-#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
+/*				6    bucketsize, initval support added */
+#define IPSET_TYPE_REV_MAX	7 /* bitmask support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -35,6 +36,7 @@ MODULE_ALIAS("ip_set_hash:ip,port");
 
 /* Type specific function prefix */
 #define HTYPE		hash_ipport
+#define IP_SET_HASH_WITH_NETMASK
 
 /* IPv4 variant */
 
@@ -92,12 +94,19 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h = set->data;
 
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	if (h->netmask != HOST_MASK)
+		e.ip &= ip_set_netmask(h->netmask);
+	else
+		e.ip &= h->bitmask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -129,6 +138,13 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
+	if (h->netmask != HOST_MASK)
+		e.ip &= ip_set_netmask(h->netmask);
+	else
+		e.ip &= h->bitmask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -245,6 +261,16 @@ hash_ipport6_data_next(struct hash_ipport6_elem *next,
 #define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
+static void
+hash_ipport6_netmask(union nf_inet_addr *ip, u8 netmask,
+		     const union nf_inet_addr *bitmask)
+{
+	if (netmask != HOST_MASK)
+		ip6_netmask(ip, netmask);
+	else
+		nf_inet_addr_mask_inplace(ip, bitmask);
+}
+
 static int
 hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  const struct xt_action_param *par,
@@ -253,12 +279,17 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem e = { .ip = { .all = { 0 } } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h = set->data;
 
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	hash_ipport6_netmask(&e.ip, h->netmask, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -298,6 +329,10 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
+	hash_ipport6_netmask(&e.ip, h->netmask, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -356,6 +391,8 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 3d09eefe998a..a44d71cbc192 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -23,7 +23,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Forceadd support added */
 /*				2	   skbinfo support added */
-#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support added */
+/*				3	   bucketsize, initval support added */
+#define IPSET_TYPE_REV_MAX	4	/* bitmask support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -33,6 +34,7 @@ MODULE_ALIAS("ip_set_hash:net,net");
 /* Type specific function prefix */
 #define HTYPE		hash_netnet
 #define IP_SET_HASH_WITH_NETS
+#define IP_SET_HASH_WITH_NETMASK
 #define IPSET_NET_COUNT 2
 
 /* IPv4 variants */
@@ -153,7 +155,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
 	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1]);
-	e.ip[0] &= ip_set_netmask(e.cidr[0]);
+	if (h->netmask != HOST_MASK)
+		e.ip[0] &= (ip_set_netmask(e.cidr[0]) & ip_set_netmask(h->netmask));
+	else
+		e.ip[0] &= (ip_set_netmask(e.cidr[0]) & h->bitmask.ip);
 	e.ip[1] &= ip_set_netmask(e.cidr[1]);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -213,7 +218,13 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] ||
 				   tb[IPSET_ATTR_IP2_TO])) {
-		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
+		if (h->netmask != HOST_MASK)
+			e.ip[0] = htonl(ip & ip_set_hostmask(h->netmask)) &
+					ip_set_hostmask(e.cidr[0]);
+		else
+			e.ip[0] = htonl(ip & ntohl(h->bitmask.ip) &
+					ip_set_hostmask(e.cidr[0]));
+
 		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
@@ -377,6 +388,16 @@ hash_netnet6_data_next(struct hash_netnet6_elem *next,
 #define IP_SET_EMIT_CREATE
 #include "ip_set_hash_gen.h"
 
+static inline void
+hash_netnet6_netmask(union nf_inet_addr *ip, u8 netmask,
+		     const union nf_inet_addr *bitmask)
+{
+	if (netmask != HOST_MASK)
+		ip6_netmask(ip, netmask);
+	else
+		nf_inet_addr_mask_inplace(ip, bitmask);
+}
+
 static void
 hash_netnet6_init(struct hash_netnet6_elem *e)
 {
@@ -404,6 +425,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
 
+	hash_netnet6_netmask(&e.ip[0], h->netmask, &h->bitmask);
+	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -414,6 +439,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
+	const struct hash_netnet6 *h = set->data;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -453,6 +479,11 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
 
+	hash_netnet6_netmask(&e.ip[0], h->netmask, &h->bitmask);
+
+	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -IPSET_ERR_HASH_ELEM;
+
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
 
@@ -484,6 +515,8 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
-- 
2.25.1

