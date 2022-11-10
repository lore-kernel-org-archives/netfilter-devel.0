Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C34C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiKJVbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKJVbG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:06 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB031D6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:02 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AAKqjww032490;
        Thu, 10 Nov 2022 21:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=vtDM/3OTXLWhglma3ZDiPm1MiqtHQHOlFFj0YzTa+D8=;
 b=KvIgIFkKfTLBpxaXm8mcmfi2ryOPs0VcdiJhzWIiWsAPzLTC/xlqpSxSXKqA5mLw1OYI
 +3WJKf0eu9qWqLxM/hO3lZRSxfVmyrr4PDT3mMzvLxwzH56jMIAAB6inDEeLUrnrLqSJ
 Jps5yH7cg6ml2ztTPeBCvzXQYs0MRaJaZNN8imZLnS7evi2eUdU6x8XXzbWUPrprBLVb
 mJnoWNmxZgM+0M0wqgjJ93UDLabDU0hlMLQ4SLlKrePIYZNEgu7pP1BusnUC6lKyLJ+2
 /BpbnUpaOwTVRGjXKQCvMT+2OMb7SUcw7ObKthLudOcFMh+Zpe10nau5qtjsqhlr0yIe Kw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3ks24p2ur6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:30:53 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHNkSB014838;
        Thu, 10 Nov 2022 16:30:51 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3knk5xj6rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:30:51 -0500
Received: from usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:30:50 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:30:50 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 8CD9015FA7F; Thu, 10 Nov 2022 16:30:50 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3] netfilter: ipset: Add support for new bitmask parameter
Date:   Thu, 10 Nov 2022 16:30:26 -0500
Message-ID: <20221110213026.2083134-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
X-Proofpoint-ORIG-GUID: lnKekCNNCDup09lk3balOTPm3Ipwo3y0
X-Proofpoint-GUID: lnKekCNNCDup09lk3balOTPm3Ipwo3y0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100151
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

Notes:
    Changes in v3:
    * Move inline function to ip_set.h
    * Explicitly initialize zeromask = {}
    * Don't remove the check for netmask == 0 in _create()
    * Add netmask option to hash:net,net
    
    Changes in v2:
    * bitmask and netmask options are mutually exclusive now
    * Added tests for the bitmask feature to all three set types
    * IP_SET_HASH_WITH_BITMASK is a separate macro now
    * netmask is now converted and stored as 'bitmask' and bitmask is
      applied to the entries directly for better efficiency
    * fixed comment for revision 6 in hash:ip
    * removed netmask from hash:net,net, it has a cidr option already

 include/linux/netfilter/ipset/ip_set.h      | 10 +++
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 71 ++++++++++++++++++---
 net/netfilter/ipset/ip_set_hash_ip.c        | 19 +++---
 net/netfilter/ipset/ip_set_hash_ipport.c    | 24 ++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c    | 26 ++++++--
 6 files changed, 126 insertions(+), 26 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ada1296c87d5..ab934ad951a8 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -515,6 +515,16 @@ ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 	*skbinfo = ext->skbinfo;
 }
 
+static inline void
+nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
+			  const union nf_inet_addr *mask)
+{
+	a1->all[0] &= mask->all[0];
+	a1->all[1] &= mask->all[1];
+	a1->all[2] &= mask->all[2];
+	a1->all[3] &= mask->all[3];
+}
+
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
 	{ .bytes = (skb)->len, .packets = 1, .target = true,\
 	  .timeout = ip_set_adt_opt_timeout(opt, set) }
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 6397d75899bc..1bfa765a2191 100644
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
@@ -157,6 +158,7 @@ enum ipset_errno {
 	IPSET_ERR_COMMENT,
 	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_SKBINFO,
+	IPSET_ERR_BITMASK_NETMASK_EXCL,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6e391308431d..298be8c9c8af 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -182,6 +182,17 @@ htable_size(u8 hbits)
 	(SET_WITH_TIMEOUT(set) &&	\
 	 ip_set_timeout_expired(ext_timeout(d, set)))
 
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
+static const union nf_inet_addr onesmask = {
+	.all[0] = 0xffffffff,
+	.all[1] = 0xffffffff,
+	.all[2] = 0xffffffff,
+	.all[3] = 0xffffffff
+};
+
+static const union nf_inet_addr zeromask = {};
+#endif
+
 #endif /* _IP_SET_HASH_GEN_H */
 
 #ifndef MTYPE
@@ -306,8 +317,9 @@ struct htype {
 	u32 markmask;		/* markmask value for mark mask to store */
 #endif
 	u8 bucketsize;		/* max elements in an array block */
-#ifdef IP_SET_HASH_WITH_NETMASK
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
 	u8 netmask;		/* netmask value for subnets to store */
+	union nf_inet_addr bitmask;	/* stores bitmask */
 #endif
 	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
@@ -482,8 +494,8 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 	/* Resizing changes htable_bits, so we ignore it */
 	return x->maxelem == y->maxelem &&
 	       a->timeout == b->timeout &&
-#ifdef IP_SET_HASH_WITH_NETMASK
-	       x->netmask == y->netmask &&
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
+	       nf_inet_addr_cmp(&x->bitmask, &y->bitmask) &&
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
 	       x->markmask == y->markmask &&
@@ -1282,9 +1294,21 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 			  htonl(jhash_size(htable_bits))) ||
 	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
 		goto nla_put_failure;
+#ifdef IP_SET_HASH_WITH_BITMASK
+	/* if netmask is set to anything other than HOST_MASK we know that the user supplied netmask
+	 * and not bitmask. These two are mutually exclusive. */
+	if (h->netmask == HOST_MASK && !nf_inet_addr_cmp(&onesmask, &h->bitmask)) {
+		if (set->family == NFPROTO_IPV4) {
+			if (nla_put_ipaddr4(skb, IPSET_ATTR_BITMASK, h->bitmask.ip))
+				goto nla_put_failure;
+		} else if (set->family == NFPROTO_IPV6) {
+			if (nla_put_ipaddr6(skb, IPSET_ATTR_BITMASK, &h->bitmask.in6))
+				goto nla_put_failure;
+		}
+	}
+#endif
 #ifdef IP_SET_HASH_WITH_NETMASK
-	if (h->netmask != HOST_MASK &&
-	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
+	if (h->netmask != HOST_MASK && nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
 		goto nla_put_failure;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
@@ -1447,8 +1471,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	u32 markmask;
 #endif
 	u8 hbits;
-#ifdef IP_SET_HASH_WITH_NETMASK
-	u8 netmask;
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
+	int ret __attribute__((unused)) = 0;
+	u8 netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
+	union nf_inet_addr bitmask = onesmask;
 #endif
 	size_t hsize;
 	struct htype *h;
@@ -1486,7 +1512,6 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #endif
 
 #ifdef IP_SET_HASH_WITH_NETMASK
-	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	if (tb[IPSET_ATTR_NETMASK]) {
 		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
 
@@ -1494,6 +1519,33 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 		    (set->family == NFPROTO_IPV6 && netmask > 128) ||
 		    netmask == 0)
 			return -IPSET_ERR_INVALID_NETMASK;
+
+		/* we convert netmask to bitmask and store it */
+		if (set->family == NFPROTO_IPV4)
+			bitmask.ip = ip_set_netmask(netmask);
+		else
+			ip6_netmask(&bitmask, netmask);
+	}
+#endif
+
+#ifdef IP_SET_HASH_WITH_BITMASK
+	if (tb[IPSET_ATTR_BITMASK]) {
+		/* bitmask and netmask do the same thing, allow only one of these options */
+		if (tb[IPSET_ATTR_NETMASK])
+			return -IPSET_ERR_BITMASK_NETMASK_EXCL;
+
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
+			return -IPSET_ERR_INVALID_NETMASK;
 	}
 #endif
 
@@ -1536,7 +1588,8 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	for (i = 0; i < ahash_numof_locks(hbits); i++)
 		spin_lock_init(&t->hregion[i].lock);
 	h->maxelem = maxelem;
-#ifdef IP_SET_HASH_WITH_NETMASK
+#if defined(IP_SET_HASH_WITH_NETMASK) || defined(IP_SET_HASH_WITH_BITMASK)
+	h->bitmask = bitmask;
 	h->netmask = netmask;
 #endif
 #ifdef IP_SET_HASH_WITH_MARKMASK
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 75d556d71652..e30513cefd90 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -24,7 +24,8 @@
 /*				2	   Comments support */
 /*				3	   Forceadd support */
 /*				4	   skbinfo support */
-#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
+/*				5	   bucketsize, initval support  */
+#define IPSET_TYPE_REV_MAX	6	/* bitmask support  */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -34,6 +35,7 @@ MODULE_ALIAS("ip_set_hash:ip");
 /* Type specific function prefix */
 #define HTYPE		hash_ip
 #define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
 
 /* IPv4 variant */
 
@@ -86,7 +88,7 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	__be32 ip;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
-	ip &= ip_set_netmask(h->netmask);
+	ip &= h->bitmask.ip;
 	if (ip == 0)
 		return -EINVAL;
 
@@ -119,7 +121,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	ip &= ip_set_hostmask(h->netmask);
+	ip &= ntohl(h->bitmask.ip);
 	e.ip = htonl(ip);
 	if (e.ip == 0)
 		return -IPSET_ERR_HASH_ELEM;
@@ -185,12 +187,6 @@ hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
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
@@ -227,7 +223,7 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
-	hash_ip6_netmask(&e.ip, h->netmask);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -EINVAL;
 
@@ -266,7 +262,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
-	hash_ip6_netmask(&e.ip, h->netmask);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
 	if (ipv6_addr_any(&e.ip.in6))
 		return -IPSET_ERR_HASH_ELEM;
 
@@ -293,6 +289,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 	},
 	.adt_policy	= {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
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
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -35,6 +36,8 @@ MODULE_ALIAS("ip_set_hash:ip,port");
 
 /* Type specific function prefix */
 #define HTYPE		hash_ipport
+#define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
 
 /* IPv4 variant */
 
@@ -92,12 +95,16 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h = set->data;
 
 	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
+	e.ip &= h->bitmask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -129,6 +136,10 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
+	e.ip &= h->bitmask.ip;
+	if (e.ip == 0)
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -253,12 +264,17 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport6_elem e = { .ip = { .all = { 0 } } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
+	const struct MTYPE *h = set->data;
 
 	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
 				 &e.port, &e.proto))
 		return -EINVAL;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -298,6 +314,10 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (ret)
 		return ret;
 
+	nf_inet_addr_mask_inplace(&e.ip, &h->bitmask);
+	if (ipv6_addr_any(&e.ip.in6))
+		return -EINVAL;
+
 	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
 
 	if (tb[IPSET_ATTR_PROTO]) {
@@ -356,6 +376,8 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
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
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
@@ -33,6 +34,8 @@ MODULE_ALIAS("ip_set_hash:net,net");
 /* Type specific function prefix */
 #define HTYPE		hash_netnet
 #define IP_SET_HASH_WITH_NETS
+#define IP_SET_HASH_WITH_NETMASK
+#define IP_SET_HASH_WITH_BITMASK
 #define IPSET_NET_COUNT 2
 
 /* IPv4 variants */
@@ -153,8 +156,8 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
 	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1]);
-	e.ip[0] &= ip_set_netmask(e.cidr[0]);
-	e.ip[1] &= ip_set_netmask(e.cidr[1]);
+	e.ip[0] &= (ip_set_netmask(e.cidr[0]) & h->bitmask.ip);
+	e.ip[1] &= (ip_set_netmask(e.cidr[1]) & h->bitmask.ip);
 
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
@@ -213,8 +216,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] ||
 				   tb[IPSET_ATTR_IP2_TO])) {
-		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
-		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
+		e.ip[0] = htonl(ip & ntohl(h->bitmask.ip) & ip_set_hostmask(e.cidr[0]));
+		e.ip[1] = htonl(ip2_from & ntohl(h->bitmask.ip) & ip_set_hostmask(e.cidr[1]));
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
 		       ip_set_eexist(ret, flags) ? 0 : ret;
@@ -404,6 +407,11 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
 
+	nf_inet_addr_mask_inplace(&e.ip[0], &h->bitmask);
+	nf_inet_addr_mask_inplace(&e.ip[1], &h->bitmask);
+	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -EINVAL;
+
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
@@ -414,6 +422,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
+	const struct hash_netnet6 *h = set->data;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -453,6 +462,11 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	ip6_netmask(&e.ip[0], e.cidr[0]);
 	ip6_netmask(&e.ip[1], e.cidr[1]);
 
+	nf_inet_addr_mask_inplace(&e.ip[0], &h->bitmask);
+	nf_inet_addr_mask_inplace(&e.ip[1], &h->bitmask);
+	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
+		return -IPSET_ERR_HASH_ELEM;
+
 	if (tb[IPSET_ATTR_CADT_FLAGS]) {
 		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
 
@@ -484,6 +498,8 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
+		[IPSET_ATTR_NETMASK]    = { .type = NLA_U8 },
+		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
 	},
 	.adt_policy	= {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
-- 
2.25.1

