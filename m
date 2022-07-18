Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917B6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jul 2022 15:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbiGRPTO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiGRPTN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jul 2022 11:19:13 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54A2B7C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 08:19:09 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 26ICJsO9032288;
        Mon, 18 Jul 2022 16:18:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=830gCEEZUNxW9DmWf3huaWKll9nheZjK4M1DsOUXkeU=;
 b=NcgL7JlE0FouwUIqsGLA+6eKVhCZFmycHO5dHkLbB0zE+4BIxtbWs/EQbtG6N6lUdeoA
 /9zoUTU+pmp4OJg2msSkvWz6K6LLwJWMB1GCK5P2iBrZLVJyva72EVZiprTon282zjW8
 LA5J6s7TdBWwlQ7Iw2RbsRgf47qCy13EpAS/96DDj+IS0DN3HdNihwQuU0bhCF/8Wjhh
 jpHknqjTf2cY2A4fIJFs0iX2Ues632oPk4zeGOrairzgG6EXRo3jjhWLRpANfN1H/VSd
 OoZJ1GxDRYiY2yVy7BlSrUkxKq+rEHT7EPYZ62Q3L7MYx1i2V/fR9EKDdaqmPefTnSTw 6Q== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3hbnrafgx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 16:18:52 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 26IDjNxT017640;
        Mon, 18 Jul 2022 11:18:50 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com (PPS) with ESMTP id 3hbrny7mq4-1;
        Mon, 18 Jul 2022 11:18:50 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 8BDBC2D8C6;
        Mon, 18 Jul 2022 15:18:50 +0000 (GMT)
Message-ID: <1a7fec2e-ec52-4b3c-1730-ec16c0c8e848@akamai.com>
Date:   Mon, 18 Jul 2022 11:18:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] netfilter: ipset: Add support for new bitmask parameter
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
References: <20220629212109.3045794-1-vpai@akamai.com>
 <20220629212109.3045794-3-vpai@akamai.com>
 <6e8e15f1-f276-7f35-9aac-456e3d3fcbb1@netfilter.org>
From:   Vishwanath Pai <vpai@akamai.com>
In-Reply-To: <6e8e15f1-f276-7f35-9aac-456e3d3fcbb1@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_14,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180067
X-Proofpoint-ORIG-GUID: zQqxlanKJIKbDOHc0ulaIBVrX0_EkyZ9
X-Proofpoint-GUID: zQqxlanKJIKbDOHc0ulaIBVrX0_EkyZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_14,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 adultscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180067
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

Thank you so much for the feedback. I have replied inline below.

On 7/12/22 18:45, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Wed, 29 Jun 2022, Vishwanath Pai wrote:
> 
>> Add a new parameter to complement the existing 'netmask' option. The
>> main difference between netmask and bitmask is that bitmask takes any
>> arbitrary ip address as input, it does not have to be a valid netmask.
>>
>> The name of the new parameter is 'bitmask'. This lets us mask out
>> arbitrary bits in the ip address, for example:
>> ipset create set1 hash:ip bitmask 255.128.255.0
>> ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80
> 
> In my opinion new stuff should be added to nftables and not to ipset,
> but see my comments below
> 
>> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
>> Signed-off-by: Joshua Hunt <johunt@akamai.com>
>> ---
>>  include/linux/netfilter.h                   | 18 ++++++++
>>  include/uapi/linux/netfilter/ipset/ip_set.h |  1 +
>>  net/netfilter/ipset/ip_set_hash_gen.h       | 48 ++++++++++++++++++---
>>  net/netfilter/ipset/ip_set_hash_ip.c        | 36 +++++++++++-----
>>  net/netfilter/ipset/ip_set_hash_ipport.c    | 39 ++++++++++++++++-
>>  net/netfilter/ipset/ip_set_hash_netnet.c    | 39 +++++++++++++++--
> 
> Why these three set types are picked? If you introduce a new feature, add 
> it to all possible set types.

The hash:ip type already had netmask, and we designed bitmask to be an extension
of netmask. The other two were picked because of our customer requirements.

> 
> What does the bitmask option exactly means for the hash:net* types? It is 
> a set level option and not a per entry level one, so the functionality is 
> limited.
> 

I don't know exactly how our customer makes use of this, but I think the overall
idea is that they want to mask out bits in the middle of the IP block before
taking action on that packet. It looks like the netmask feature on net,net is a
bit redundant because it already accepts a cidr so maybe I'll remove that and
only add bitmask.

> The netmask and bitmap options are excluding ones, so those should be 
> handled that way.
> 

Yes, agreed. I could not find a way to do this from the userspace, but I can
return an appropriate error from the kernel if both netmask and bitmask are
provided.

> Please add tests to the testsuite to verify the functionality.
> 
>>  6 files changed, 160 insertions(+), 21 deletions(-)
>>
Will do.

>> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
>> index c2c6f332fb90..c184f01920e2 100644
>> --- a/include/linux/netfilter.h
>> +++ b/include/linux/netfilter.h
>> @@ -56,6 +56,24 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
>>  #endif
>>  }
>>  
>> +static inline void nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
>> +					     const union nf_inet_addr *mask)
>> +{
>> +	a1->all[0] &= mask->all[0];
>> +	a1->all[1] &= mask->all[1];
>> +	a1->all[2] &= mask->all[2];
>> +	a1->all[3] &= mask->all[3];
>> +}
>> +
>> +static inline void nf_inet_addr_invert(const union nf_inet_addr *src,
>> +				       union nf_inet_addr *dst)
>> +{
>> +	dst->all[0] = ~src->all[0];
>> +	dst->all[1] = ~src->all[1];
>> +	dst->all[2] = ~src->all[2];
>> +	dst->all[3] = ~src->all[3];
>> +}
>> +
>>  int netfilter_init(void);
>>  
>>  struct sk_buff;
>> diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
>> index 6397d75899bc..8c3046ea2362 100644
>> --- a/include/uapi/linux/netfilter/ipset/ip_set.h
>> +++ b/include/uapi/linux/netfilter/ipset/ip_set.h
>> @@ -89,6 +89,7 @@ enum {
>>  	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
>>  	IPSET_ATTR_MARK,	/* 10 */
>>  	IPSET_ATTR_MARKMASK,	/* 11 */
>> +	IPSET_ATTR_BITMASK,	/* 12 */
>>  	/* Reserve empty slots */
>>  	IPSET_ATTR_CADT_MAX = 16,
>>  	/* Create-only specific attributes */
>> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
>> index 6e391308431d..1f658b4546b6 100644
>> --- a/net/netfilter/ipset/ip_set_hash_gen.h
>> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
>> @@ -182,6 +182,17 @@ htable_size(u8 hbits)
>>  	(SET_WITH_TIMEOUT(set) &&	\
>>  	 ip_set_timeout_expired(ext_timeout(d, set)))
>>  
>> +#ifdef IP_SET_HASH_WITH_NETMASK
>> +static const union nf_inet_addr onesmask = {
>> +	.all[0] = 0xffffffff,
>> +	.all[1] = 0xffffffff,
>> +	.all[2] = 0xffffffff,
>> +	.all[3] = 0xffffffff
>> +};
>> +
>> +static const union nf_inet_addr zeromask;
>> +#endif
>> +
>>  #endif /* _IP_SET_HASH_GEN_H */
>>  
>>  #ifndef MTYPE
>> @@ -308,6 +319,7 @@ struct htype {
>>  	u8 bucketsize;		/* max elements in an array block */
>>  #ifdef IP_SET_HASH_WITH_NETMASK
>>  	u8 netmask;		/* netmask value for subnets to store */
>> +	union nf_inet_addr bitmask;	/* stores bitmask */
> 
> I'd better see a new IP_SET_HASH_WITH_BITMASK macro. When a set can be 
> defined either with netmask or bitmap options, then netmask member above 
> can be kept to store that value for listing and use a new flag member to 
> tell which option was used (in the case of none, when the default netmask 
> value should be applied).
> 
> However, store ip_set_netmask(netmask) in the bitmap member.
> 
Will do, I will use a separate macro for bitmask.

>>  #endif
>>  	struct list_head ad;	/* Resize add|del backlist */
>>  	struct mtype_elem next; /* temporary storage for uadd */
>> @@ -484,6 +496,7 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
>>  	       a->timeout == b->timeout &&
>>  #ifdef IP_SET_HASH_WITH_NETMASK
>>  	       x->netmask == y->netmask &&
>> +	       nf_inet_addr_cmp(&x->bitmask, &y->bitmask) &&
>>  #endif
>>  #ifdef IP_SET_HASH_WITH_MARKMASK
>>  	       x->markmask == y->markmask &&
>> @@ -1283,8 +1296,16 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
>>  	    nla_put_net32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem)))
>>  		goto nla_put_failure;
>>  #ifdef IP_SET_HASH_WITH_NETMASK
>> -	if (h->netmask != HOST_MASK &&
>> -	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
>> +	if (!nf_inet_addr_cmp(&onesmask, &h->bitmask)) {
>> +		if (set->family == NFPROTO_IPV4) {
>> +			if (nla_put_ipaddr4(skb, IPSET_ATTR_BITMASK, h->bitmask.ip))
>> +				goto nla_put_failure;
>> +		} else if (set->family == NFPROTO_IPV6) {
>> +			if (nla_put_ipaddr6(skb, IPSET_ATTR_BITMASK, &h->bitmask.in6))
>> +				goto nla_put_failure;
>> +		}
>> +	}
>> +	if (h->netmask != HOST_MASK && nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
>>  		goto nla_put_failure;
>>  #endif
>>  #ifdef IP_SET_HASH_WITH_MARKMASK
>> @@ -1448,7 +1469,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>>  #endif
>>  	u8 hbits;
>>  #ifdef IP_SET_HASH_WITH_NETMASK
>> -	u8 netmask;
>> +	int ret = 0;
>> +	u8 netmask = 0;
>> +	union nf_inet_addr bitmask = onesmask;
>>  #endif
>>  	size_t hsize;
>>  	struct htype *h;
>> @@ -1489,10 +1512,22 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>>  	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
>>  	if (tb[IPSET_ATTR_NETMASK]) {
>>  		netmask = nla_get_u8(tb[IPSET_ATTR_NETMASK]);
>> -
>>  		if ((set->family == NFPROTO_IPV4 && netmask > 32) ||
>> -		    (set->family == NFPROTO_IPV6 && netmask > 128) ||
>> -		    netmask == 0)
>> +		    (set->family == NFPROTO_IPV6 && netmask > 128))
>> +			return -IPSET_ERR_INVALID_NETMASK;
>> +	}
> 
> Why the "netmask == 0" condition was removed?
> 
This check is not needed because of the line immediately above the
if(tb[IPSET_ATTR_NETMASK]) block where we assign either 32 or 128 to netmask.

>> +	if (tb[IPSET_ATTR_BITMASK]) {
>> +		if (set->family == NFPROTO_IPV4) {
>> +			ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_BITMASK], &bitmask.ip);
>> +			if (ret || !bitmask.ip)
>> +				return -IPSET_ERR_INVALID_NETMASK;
>> +		} else if (set->family == NFPROTO_IPV6) {
>> +			ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_BITMASK], &bitmask);
>> +			if (ret || ipv6_addr_any(&bitmask.in6))
>> +				return -IPSET_ERR_INVALID_NETMASK;
>> +		}
>> +
>> +		if (nf_inet_addr_cmp(&bitmask, &zeromask))
>>  			return -IPSET_ERR_INVALID_NETMASK;
>>  	}
>>  #endif
> 
> You have to explicitly exclude when both the netmask and bitmask options 
> are specified.
> 
Agreed, I will make the two parameters mutually exclusive.

>> @@ -1537,6 +1572,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
>>  		spin_lock_init(&t->hregion[i].lock);
>>  	h->maxelem = maxelem;
>>  #ifdef IP_SET_HASH_WITH_NETMASK
>> +	h->bitmask = bitmask;
>>  	h->netmask = netmask;
>>  #endif
>>  #ifdef IP_SET_HASH_WITH_MARKMASK
>> diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
>> index 258aeb324483..6976b4bcaa96 100644
>> --- a/net/netfilter/ipset/ip_set_hash_ip.c
>> +++ b/net/netfilter/ipset/ip_set_hash_ip.c
>> @@ -24,7 +24,8 @@
>>  /*				2	   Comments support */
>>  /*				3	   Forceadd support */
>>  /*				4	   skbinfo support */
>> -#define IPSET_TYPE_REV_MAX	5	/* bucketsize, initval support  */
>> +/*				5	   bucketsize, initval support  */
>> +#define IPSET_TYPE_REV_MAX	6	/* bucketsize, initval support  */
> 
> Fill the comment out with the introduced functionality :-).
>  
Sorry, I overlooked this, will fix it :)
 
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
>> @@ -86,7 +87,12 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	__be32 ip;
>>  
>>  	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
>> -	ip &= ip_set_netmask(h->netmask);
>> +
>> +	if (h->netmask != HOST_MASK)
>> +		ip &= ip_set_netmask(h->netmask);
>> +	else
>> +		ip &= h->bitmask.ip;
>> +
>>  	if (ip == 0)
>>  		return -EINVAL;
> 
> If you store the ip_set_netmask(h->netmask) in h->bitmask.ip, then there's 
> no need for the condition and the hot paths are not slowed down.
>  
Agreed, that is a good optimization. Will change it.
 
>> @@ -119,7 +125,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	if (ret)
>>  		return ret;
>>  
>> -	ip &= ip_set_hostmask(h->netmask);
>> +	if (h->netmask != HOST_MASK)
>> +		ip &= ip_set_hostmask(h->netmask);
>> +	else
>> +		ip &= ntohl(h->bitmask.ip);
>>  
>>  	if (ip == 0)
>>  		return -IPSET_ERR_HASH_ELEM;
>> @@ -193,12 +202,6 @@ hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
>>  	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
>>  }
>>  
>> -static void
>> -hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
>> -{
>> -	ip6_netmask(ip, prefix);
>> -}
>> -
>>  static bool
>>  hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
>>  {
>> @@ -224,6 +227,16 @@ hash_ip6_data_next(struct hash_ip6_elem *next, const struct hash_ip6_elem *e)
>>  #define IP_SET_EMIT_CREATE
>>  #include "ip_set_hash_gen.h"
>>  
>> +static void
>> +hash_ip6_netmask(union nf_inet_addr *ip, u8 netmask,
>> +		 const union nf_inet_addr *bitmask)
>> +{
>> +	if (netmask != HOST_MASK)
>> +		ip6_netmask(ip, netmask);
>> +	else
>> +		nf_inet_addr_mask_inplace(ip, bitmask);
>> +}
>> +
>>  static int
>>  hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	      const struct xt_action_param *par,
>> @@ -235,7 +248,7 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
>>  
>>  	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
>> -	hash_ip6_netmask(&e.ip, h->netmask);
>> +	hash_ip6_netmask(&e.ip, h->netmask, &h->bitmask);
>>  	if (ipv6_addr_any(&e.ip.in6))
>>  		return -EINVAL;
>>  
>> @@ -274,7 +287,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	if (ret)
>>  		return ret;
>>  
>> -	hash_ip6_netmask(&e.ip, h->netmask);
>> +	hash_ip6_netmask(&e.ip, h->netmask, &h->bitmask);
>>  	if (ipv6_addr_any(&e.ip.in6))
>>  		return -IPSET_ERR_HASH_ELEM;
>>  
>> @@ -301,6 +314,7 @@ static struct ip_set_type hash_ip_type __read_mostly = {
>>  		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
>>  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
>>  		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8  },
>> +		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
>>  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
>>  	},
>>  	.adt_policy	= {
>> diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
>> index 7303138e46be..8f5379738ffa 100644
>> --- a/net/netfilter/ipset/ip_set_hash_ipport.c
>> +++ b/net/netfilter/ipset/ip_set_hash_ipport.c
>> @@ -26,7 +26,8 @@
>>  /*				3    Comments support added */
>>  /*				4    Forceadd support added */
>>  /*				5    skbinfo support added */
>> -#define IPSET_TYPE_REV_MAX	6 /* bucketsize, initval support added */
>> +/*				6    bucketsize, initval support added */
>> +#define IPSET_TYPE_REV_MAX	7 /* bitmask support added */
>>  
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
>> @@ -35,6 +36,7 @@ MODULE_ALIAS("ip_set_hash:ip,port");
>>  
>>  /* Type specific function prefix */
>>  #define HTYPE		hash_ipport
>> +#define IP_SET_HASH_WITH_NETMASK
> 
> If you don't want to introduce the netmask option, then don't use this 
> macro but IP_SET_HASH_WITH_BITMASK.
>   
I think our customer needs both netmask and bitmask, but I will check.
>>  /* IPv4 variant */
>>  
>> @@ -92,12 +94,19 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	ipset_adtfn adtfn = set->variant->adt[adt];
>>  	struct hash_ipport4_elem e = { .ip = 0 };
>>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
>> +	const struct MTYPE *h = set->data;
>>  
>>  	if (!ip_set_get_ip4_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>>  				 &e.port, &e.proto))
>>  		return -EINVAL;
>>  
>>  	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
>> +	if (h->netmask != HOST_MASK)
>> +		e.ip &= ip_set_netmask(h->netmask);
>> +	else
>> +		e.ip &= h->bitmask.ip;
>> +	if (e.ip == 0)
>> +		return -EINVAL;
>>  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
>>  }
>>  
>> @@ -129,6 +138,13 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	if (ret)
>>  		return ret;
>>  
>> +	if (h->netmask != HOST_MASK)
>> +		e.ip &= ip_set_netmask(h->netmask);
>> +	else
>> +		e.ip &= h->bitmask.ip;
>> +	if (e.ip == 0)
>> +		return -EINVAL;
>> +
>>  	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
>>  
>>  	if (tb[IPSET_ATTR_PROTO]) {
>> @@ -245,6 +261,16 @@ hash_ipport6_data_next(struct hash_ipport6_elem *next,
>>  #define IP_SET_EMIT_CREATE
>>  #include "ip_set_hash_gen.h"
>>  
>> +static void
>> +hash_ipport6_netmask(union nf_inet_addr *ip, u8 netmask,
>> +		     const union nf_inet_addr *bitmask)
>> +{
>> +	if (netmask != HOST_MASK)
>> +		ip6_netmask(ip, netmask);
>> +	else
>> +		nf_inet_addr_mask_inplace(ip, bitmask);
>> +}
>> +
>>  static int
>>  hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  		  const struct xt_action_param *par,
>> @@ -253,12 +279,17 @@ hash_ipport6_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	ipset_adtfn adtfn = set->variant->adt[adt];
>>  	struct hash_ipport6_elem e = { .ip = { .all = { 0 } } };
>>  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
>> +	const struct MTYPE *h = set->data;
>>  
>>  	if (!ip_set_get_ip6_port(skb, opt->flags & IPSET_DIM_TWO_SRC,
>>  				 &e.port, &e.proto))
>>  		return -EINVAL;
>>  
>>  	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
>> +	hash_ipport6_netmask(&e.ip, h->netmask, &h->bitmask);
>> +	if (ipv6_addr_any(&e.ip.in6))
>> +		return -EINVAL;
>> +
>>  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
>>  }
>>  
>> @@ -298,6 +329,10 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	if (ret)
>>  		return ret;
>>  
>> +	hash_ipport6_netmask(&e.ip, h->netmask, &h->bitmask);
>> +	if (ipv6_addr_any(&e.ip.in6))
>> +		return -EINVAL;
>> +
>>  	e.port = nla_get_be16(tb[IPSET_ATTR_PORT]);
>>  
>>  	if (tb[IPSET_ATTR_PROTO]) {
>> @@ -356,6 +391,8 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
>>  		[IPSET_ATTR_PROTO]	= { .type = NLA_U8 },
>>  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
>>  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
>> +		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
>> +		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
>>  	},
>>  	.adt_policy	= {
>>  		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
>> diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
>> index 3d09eefe998a..a44d71cbc192 100644
>> --- a/net/netfilter/ipset/ip_set_hash_netnet.c
>> +++ b/net/netfilter/ipset/ip_set_hash_netnet.c
>> @@ -23,7 +23,8 @@
>>  #define IPSET_TYPE_REV_MIN	0
>>  /*				1	   Forceadd support added */
>>  /*				2	   skbinfo support added */
>> -#define IPSET_TYPE_REV_MAX	3	/* bucketsize, initval support added */
>> +/*				3	   bucketsize, initval support added */
>> +#define IPSET_TYPE_REV_MAX	4	/* bitmask support added */
>>  
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
>> @@ -33,6 +34,7 @@ MODULE_ALIAS("ip_set_hash:net,net");
>>  /* Type specific function prefix */
>>  #define HTYPE		hash_netnet
>>  #define IP_SET_HASH_WITH_NETS
>> +#define IP_SET_HASH_WITH_NETMASK
>>  #define IPSET_NET_COUNT 2
>>  
>>  /* IPv4 variants */
>> @@ -153,7 +155,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  
>>  	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
>>  	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1]);
>> -	e.ip[0] &= ip_set_netmask(e.cidr[0]);
>> +	if (h->netmask != HOST_MASK)
>> +		e.ip[0] &= (ip_set_netmask(e.cidr[0]) & ip_set_netmask(h->netmask));
>> +	else
>> +		e.ip[0] &= (ip_set_netmask(e.cidr[0]) & h->bitmask.ip);
> 
> I really don't see the intention here. We have normal network addresses 
> which then masked with either another netmask or a bitmask value.
> 
The netmask option seems redundant here, but with the bitmask we're masking out
bits in the middle of the IP.

>>  	e.ip[1] &= ip_set_netmask(e.cidr[1]);
>>  
>>  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
>> @@ -213,7 +218,13 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>>  
>>  	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] ||
>>  				   tb[IPSET_ATTR_IP2_TO])) {
>> -		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
>> +		if (h->netmask != HOST_MASK)
>> +			e.ip[0] = htonl(ip & ip_set_hostmask(h->netmask)) &
>> +					ip_set_hostmask(e.cidr[0]);
>> +		else
>> +			e.ip[0] = htonl(ip & ntohl(h->bitmask.ip) &
>> +					ip_set_hostmask(e.cidr[0]));
>> +
>>  		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
>>  		ret = adtfn(set, &e, &ext, &ext, flags);
>>  		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
>> @@ -377,6 +388,16 @@ hash_netnet6_data_next(struct hash_netnet6_elem *next,
>>  #define IP_SET_EMIT_CREATE
>>  #include "ip_set_hash_gen.h"
>>  
>> +static inline void
>> +hash_netnet6_netmask(union nf_inet_addr *ip, u8 netmask,
>> +		     const union nf_inet_addr *bitmask)
>> +{
>> +	if (netmask != HOST_MASK)
>> +		ip6_netmask(ip, netmask);
>> +	else
>> +		nf_inet_addr_mask_inplace(ip, bitmask);
>> +}
>> +
>>  static void
>>  hash_netnet6_init(struct hash_netnet6_elem *e)
>>  {
>> @@ -404,6 +425,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
>>  	ip6_netmask(&e.ip[0], e.cidr[0]);
>>  	ip6_netmask(&e.ip[1], e.cidr[1]);
>>  
>> +	hash_netnet6_netmask(&e.ip[0], h->netmask, &h->bitmask);
>> +	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
>> +		return -EINVAL;
>> +
>>  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
>>  }
>>  
>> @@ -414,6 +439,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	ipset_adtfn adtfn = set->variant->adt[adt];
>>  	struct hash_netnet6_elem e = { };
>>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>> +	const struct hash_netnet6 *h = set->data;
>>  	int ret;
>>  
>>  	if (tb[IPSET_ATTR_LINENO])
>> @@ -453,6 +479,11 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
>>  	ip6_netmask(&e.ip[0], e.cidr[0]);
>>  	ip6_netmask(&e.ip[1], e.cidr[1]);
>>  
>> +	hash_netnet6_netmask(&e.ip[0], h->netmask, &h->bitmask);
>> +
>> +	if (e.cidr[0] == HOST_MASK && ipv6_addr_any(&e.ip[0].in6))
>> +		return -IPSET_ERR_HASH_ELEM;
>> +
>>  	if (tb[IPSET_ATTR_CADT_FLAGS]) {
>>  		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
>>  
>> @@ -484,6 +515,8 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
>>  		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
>>  		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
>>  		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
>> +		[IPSET_ATTR_NETMASK]	= { .type = NLA_U8 },
>> +		[IPSET_ATTR_BITMASK]	= { .type = NLA_NESTED },
>>  	},
>>  	.adt_policy	= {
>>  		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
>> -- 
>> 2.25.1
>>
>>
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https://wigner.hu/*kadlec/pgp_public_key.txt__;fg!!GjvTz_vk!RpdjKaLxiPULLF4FBpz0cF4sqDUh_OC90cEwFXoLEIRTy0ekM1GM5Upql6uzT0cC8L1VXh9r0LPSkA$ 
> Address : Wigner Research Centre for Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Thanks for the feedback and comments. I will submit a v2.

Thanks,
Vishwanath
