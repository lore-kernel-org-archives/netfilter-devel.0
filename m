From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] netfilter: ipset: Add hash:net,net module to
 kernel.
Date: Wed, 18 Sep 2013 19:23:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309181913300.21599@blackhole.kfki.hu>
References: <1379420818-22541-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379420818-22541-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:45089 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3IRRXE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:23:04 -0400
In-Reply-To: <1379420818-22541-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Oliver,

Please check your patches with checkpatch.pl and fix all errors, warnings.

On Tue, 17 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This adds a new set that provides the ability to configure pairs of
> subnets. A small amount of additional handling code has been added to
> the generic hash header file - this code is conditionally activated by a
> preprocessor definition.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/net/netfilter/ipset/Kbuild               |   1 +
>  kernel/net/netfilter/ipset/Kconfig              |   9 +
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  56 +++
>  kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 473 ++++++++++++++++++++++++
>  4 files changed, 539 insertions(+)
>  create mode 100644 kernel/net/netfilter/ipset/ip_set_hash_netnet.c
> 
> diff --git a/kernel/net/netfilter/ipset/Kbuild b/kernel/net/netfilter/ipset/Kbuild
> index c205ab9..6174c86 100644
> --- a/kernel/net/netfilter/ipset/Kbuild
> +++ b/kernel/net/netfilter/ipset/Kbuild
> @@ -7,6 +7,7 @@ obj-m += ip_set_bitmap_ip.o ip_set_bitmap_ipmac.o ip_set_bitmap_port.o
>  obj-m += ip_set_hash_ip.o ip_set_hash_ipport.o ip_set_hash_ipportip.o
>  obj-m += ip_set_hash_ipportnet.o
>  obj-m += ip_set_hash_net.o ip_set_hash_netport.o ip_set_hash_netiface.o
> +obj-m += ip_set_hash_netnet.o
>  obj-m += ip_set_list_set.o
>  
>  # It's for me...
> diff --git a/kernel/net/netfilter/ipset/Kconfig b/kernel/net/netfilter/ipset/Kconfig
> index ba36c28..46d5873 100644
> --- a/kernel/net/netfilter/ipset/Kconfig
> +++ b/kernel/net/netfilter/ipset/Kconfig
> @@ -99,6 +99,15 @@ config IP_SET_HASH_NET
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> +config IP_SET_HASH_NETNET
> +	tristate "hash:net,net set support"
> +	depends on IP_SET
> +	help
> +	  This option adds the hash:net,net  set type support, by which
> +	  one can store IPv4/IPv6 network address/prefix pairs in a set.
> +
> +	  To compile it as a module, choose M here.  If unsure, say N.
> +
>  config IP_SET_HASH_NETPORT
>  	tristate "hash:net,port set support"
>  	depends on IP_SET
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> index 3add0bf..4098edc 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -210,6 +210,7 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
>  #define mtype_do_data_match(d)	1
>  #endif
>  #define mtype_data_set_flags	IPSET_TOKEN(MTYPE, _data_set_flags)
> +#define mtype_data_reset_elem	IPSET_TOKEN(MTYPE, _data_reset_elem)
>  #define mtype_data_reset_flags	IPSET_TOKEN(MTYPE, _data_reset_flags)
>  #define mtype_data_netmask	IPSET_TOKEN(MTYPE, _data_netmask)
>  #define mtype_data_list		IPSET_TOKEN(MTYPE, _data_list)
> @@ -461,6 +462,9 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
>  	struct mtype_elem *data;
>  	u32 i;
>  	int j;
> +#if IPSET_NET_COUNT > 1
> +	u8 k;
> +#endif

Please get rid of all these #if .. [#else ...] #endif constructions, 
except in mtype_test_cidrs. The compiler optimizes away the for loop when 
IPSET_NET_COUNT == 1.
  
>  	rcu_read_lock_bh();
>  	t = rcu_dereference_bh(h->table);
> @@ -471,9 +475,15 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
>  			if (ip_set_timeout_expired(ext_timeout(data, set))) {
>  				pr_debug("expired %u/%u\n", i, j);
>  #ifdef IP_SET_HASH_WITH_NETS
> +#if IPSET_NET_COUNT > 1
> +				for (k = 0; k < IPSET_NET_COUNT; k++)
> +					mtype_del_cidr(h, CIDR(data->cidr[k]),
> +						       nets_length, k);
> +#else
>  				mtype_del_cidr(h, CIDR(data->cidr),
>  					       nets_length, 0);
>  #endif
> +#endif
>  				ip_set_ext_destroy(set, data);
>  				if (j != n->pos - 1)
>  					/* Not last one */
> @@ -658,9 +668,18 @@ reuse_slot:
>  		/* Fill out reused slot */
>  		data = ahash_data(n, j, set->dsize);
>  #ifdef IP_SET_HASH_WITH_NETS
> +#if IPSET_NET_COUNT > 1
> +		for (i = 0; i < IPSET_NET_COUNT; i++) {
> +			mtype_del_cidr(h, CIDR(data->cidr[i]),
> +				       NLEN(set->family), i);
> +			mtype_add_cidr(h, CIDR(d->cidr[i]),
> +				       NLEN(set->family), i);
> +		}
> +#else
>  		mtype_del_cidr(h, CIDR(data->cidr), NLEN(set->family), 0);
>  		mtype_add_cidr(h, CIDR(d->cidr), NLEN(set->family), 0);
>  #endif
> +#endif
>  		ip_set_ext_destroy(set, data);
>  	} else {
>  		/* Use/create a new slot */
> @@ -673,8 +692,14 @@ reuse_slot:
>  		}
>  		data = ahash_data(n, n->pos++, set->dsize);
>  #ifdef IP_SET_HASH_WITH_NETS
> +#if IPSET_NET_COUNT > 1
> +		for (i = 0; i < IPSET_NET_COUNT; i++)
> +			mtype_add_cidr(h, CIDR(d->cidr[i]), NLEN(set->family),
> +				       i);
> +#else
>  		mtype_add_cidr(h, CIDR(d->cidr), NLEN(set->family), 0);
>  #endif
> +#endif
>  		h->elements++;
>  	}
>  	memcpy(data, d, sizeof(struct mtype_elem));
> @@ -704,6 +729,9 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  	struct mtype_elem *data;
>  	struct hbucket *n;
>  	int i, ret = -IPSET_ERR_EXIST;
> +#if IPSET_NET_COUNT > 1
> +	u8 j;
> +#endif
>  	u32 key, multi = 0;
>  
>  	rcu_read_lock_bh();
> @@ -725,8 +753,14 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  		n->pos--;
>  		h->elements--;
>  #ifdef IP_SET_HASH_WITH_NETS
> +#if IPSET_NET_COUNT > 1
> +		for (j = 0; j < IPSET_NET_COUNT; j++)
> +			mtype_del_cidr(h, CIDR(d->cidr[j]), NLEN(set->family),
> +				       j);
> +#else
>  		mtype_del_cidr(h, CIDR(d->cidr), NLEN(set->family), 0);
>  #endif
> +#endif
>  		ip_set_ext_destroy(set, data);
>  		if (n->pos + AHASH_INIT_SIZE < n->size) {
>  			void *tmp = kzalloc((n->size - AHASH_INIT_SIZE)
> @@ -772,13 +806,25 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  	struct htable *t = rcu_dereference_bh(h->table);
>  	struct hbucket *n;
>  	struct mtype_elem *data;
> +#if IPSET_NET_COUNT == 2
> +	struct mtype_elem orig = *d;
> +	int i, j = 0, k;
> +#else
>  	int i, j = 0;
> +#endif
>  	u32 key, multi = 0;
>  	u8 nets_length = NLEN(set->family);
>  
>  	pr_debug("test by nets\n");
>  	for (; j < nets_length && h->nets[j].nets[0] && !multi; j++) {
> +#if IPSET_NET_COUNT == 2
> +		mtype_data_reset_elem(d, &orig);
> +		mtype_data_netmask(d, h->nets[j].cidr[0], false);
> +		for (k = 0; k < nets_length && h->nets[k].nets[1] && !multi; k++) {
> +			mtype_data_netmask(d, h->nets[k].cidr[1], true);
> +#else
>  		mtype_data_netmask(d, h->nets[j].cidr[0]);
> +#endif
>  		key = HKEY(d, h->initval, t->htable_bits);
>  		n = hbucket(t, key);
>  		for (i = 0; i < n->pos; i++) {
> @@ -798,6 +844,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  				return mtype_data_match(data, ext,
>  							mext, set, flags);
>  		}
> +#if IPSET_NET_COUNT == 2
> +		}
> +#endif
>
>  	}
>  	return 0;
>  }
> @@ -821,7 +870,14 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  #ifdef IP_SET_HASH_WITH_NETS
>  	/* If we test an IP address and not a network address,
>  	 * try all possible network sizes */
> +#if IPSET_NET_COUNT > 1
> +	for (i = 0; i < IPSET_NET_COUNT; i++)
> +		if(CIDR(d->cidr[i]) != SET_HOST_MASK(set->family))
> +			break;
> +	if (i == IPSET_NET_COUNT) {
> +#else
>  	if (CIDR(d->cidr) == SET_HOST_MASK(set->family)) {
> +#endif
>  		ret = mtype_test_cidrs(set, d, ext, mext, flags);
>  		goto out;
>  	}
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
> new file mode 100644
> index 0000000..49f138c
> --- /dev/null
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
> @@ -0,0 +1,473 @@
> +/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + * Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/* Kernel module implementing an IP set type: the hash:net type */
> +
> +#include <linux/jhash.h>
> +#include <linux/module.h>
> +#include <linux/ip.h>
> +#include <linux/skbuff.h>
> +#include <linux/errno.h>
> +#include <linux/random.h>
> +#include <net/ip.h>
> +#include <net/ipv6.h>
> +#include <net/netlink.h>
> +
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/ipset/pfxlen.h>
> +#include <linux/netfilter/ipset/ip_set.h>
> +#include <linux/netfilter/ipset/ip_set_hash.h>
> +
> +#define IPSET_TYPE_REV_MIN	0
> +#define IPSET_TYPE_REV_MAX	0
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>");
> +IP_SET_MODULE_DESC("hash:net,net", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
> +MODULE_ALIAS("ip_set_hash:net,net");
> +
> +/* Type specific function prefix */
> +#define HTYPE		hash_netnet
> +#define IP_SET_HASH_WITH_NETS
> +#define IPSET_NET_COUNT 2
> +
> +/* IPv4 variants */
> +
> +/* Member elements  */
> +struct hash_netnet4_elem {
> +	union {
> +		__be32 ip[2];
> +		__be64 ipcmp;
> +	};
> +	u8 nomatch;
> +	union {
> +		u8 cidr[2];
> +		u16 ccmp;
> +	};
> +};
> +
> +/* Common functions */
> +
> +static inline bool
> +hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
> +		     const struct hash_netnet4_elem *ip2,
> +		     u32 *multi)
> +{
> +	return ip1->ipcmp == ip2->ipcmp &&
> +	       ip2->ccmp == ip2->ccmp;
> +}
> +
> +static inline int
> +hash_netnet4_do_data_match(const struct hash_netnet4_elem *elem)
> +{
> +	return elem->nomatch ? -ENOTEMPTY : 1;
> +}
> +
> +static inline void
> +hash_netnet4_data_set_flags(struct hash_netnet4_elem *elem, u32 flags)
> +{
> +	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
> +}
> +
> +static inline void
> +hash_netnet4_data_reset_flags(struct hash_netnet4_elem *elem, u8 *flags)
> +{
> +	swap(*flags, elem->nomatch);
> +}
> +
> +static inline void
> +hash_netnet4_data_reset_elem(struct hash_netnet4_elem *elem, struct hash_netnet4_elem *orig)
> +{
> +	elem->ip[1] = orig->ip[1];
> +}
> +
> +static inline void
> +hash_netnet4_data_netmask(struct hash_netnet4_elem *elem, u8 cidr, bool inner)
> +{
> +	if (inner) {
> +		elem->ip[1] &= ip_set_netmask(cidr);
> +		elem->cidr[1] = cidr;
> +	} else {
> +		elem->ip[0] &= ip_set_netmask(cidr);
> +		elem->cidr[0] = cidr;
> +	}
> +}
> +
> +static bool
> +hash_netnet4_data_list(struct sk_buff *skb, const struct hash_netnet4_elem *data)
> +{
> +	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
> +
> +	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip[0]) ||
> +	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip[1]) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr[1]) ||
> +	    (flags &&
> +	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
> +		goto nla_put_failure;
> +	return 0;
> +
> +nla_put_failure:
> +	return 1;
> +}
> +
> +static inline void
> +hash_netnet4_data_next(struct hash_netnet4_elem *next,
> +		    const struct hash_netnet4_elem *d)
> +{
> +	next->ipcmp = d->ipcmp;
> +}
> +
> +#define MTYPE		hash_netnet4
> +#define PF		4
> +#define HOST_MASK	32
> +#include "ip_set_hash_gen.h"
> +
> +static int
> +hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
> +	       const struct xt_action_param *par,
> +	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
> +{
> +	const struct hash_netnet *h = set->data;
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet4_elem e = {
> +		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
> +		.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK,
> +	};
> +	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
> +
> +	if (adt == IPSET_TEST)
> +		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
> +
> +	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0]);
> +	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1]);
> +	e.ip[0] &= ip_set_netmask(e.cidr[0]);
> +	e.ip[1] &= ip_set_netmask(e.cidr[1]);
> +
> +	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
> +}
> +
> +static int
> +hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
> +	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
> +{
> +	const struct hash_netnet *h = set->data;
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet4_elem e = { .cidr[0] = HOST_MASK, .cidr[1] = HOST_MASK };
> +	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
> +	u32 ip = 0, ip_to = 0, last;
> +	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, last2;
> +	u8 cidr, cidr2;
> +	int ret;
> +
> +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	if (tb[IPSET_ATTR_LINENO])
> +		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
> +
> +	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip) ||
> +	      ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2], &ip2_from) ||
> +	      ip_set_get_extensions(set, tb, &ext);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[IPSET_ATTR_CIDR]) {
> +		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> +		if (!cidr || cidr > HOST_MASK)
> +			return -IPSET_ERR_INVALID_CIDR;
> +		e.cidr[0] = cidr;
> +	}
> +
> +	if(tb[IPSET_ATTR_CIDR2]) {
> +		cidr2 = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> +		if (!cidr2 || cidr2 > HOST_MASK)
> +			return -IPSET_ERR_INVALID_CIDR;
> +		e.cidr[1] = cidr2;
> +	}
> +
> +	if (tb[IPSET_ATTR_CADT_FLAGS]) {
> +		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> +		if (cadt_flags & IPSET_FLAG_NOMATCH)
> +			flags |= (IPSET_FLAG_NOMATCH << 16);
> +	}
> +
> +	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] && tb[IPSET_ATTR_IP2_TO])) {
> +		e.ip[0] = htonl(ip & ip_set_hostmask(e.cidr[0]));
> +		e.ip[1] = htonl(ip2_from & ip_set_hostmask(e.cidr[1]));
> +		ret = adtfn(set, &e, &ext, &ext, flags);
> +		return ip_set_enomatch(ret, flags, adt, set) ? -ret :
> +		       ip_set_eexist(ret, flags) ? 0 : ret;
> +	}
> +
> +	ip_to = ip;
> +	if (tb[IPSET_ATTR_IP_TO]) {
> +		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
> +		if (ret)
> +			return ret;
> +		if (ip_to < ip)
> +			swap(ip, ip_to);
> +		if (ip + UINT_MAX == ip_to)
> +			return -IPSET_ERR_HASH_RANGE;
> +	}
> +
> +	ip2_to = ip2_from;
> +	if (tb[IPSET_ATTR_IP2_TO]) {
> +		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
> +		if (ret)
> +			return ret;
> +		if (ip2_to < ip2_from)
> +			swap(ip2_from, ip2_to);
> +		if (ip2_from + UINT_MAX == ip2_to)
> +			return -IPSET_ERR_HASH_RANGE;
> +
> +	}
> +
> +	if (retried)
> +		ip = ntohl(h->next.ip[0]);
> +
> +	while (!after(ip, ip_to)) {
> +		e.ip[0] = htonl(ip);
> +		last = ip_set_range_to_cidr(ip, ip_to, &cidr);
> +		e.cidr[0] = cidr;
> +		ip2 = retried && ip == ntohl(h->next.ip[0]) ? ntohl(h->next.ip[1])
> +							 : ip2_from;
> +		while(!after(ip2, ip2_to)) {
> +			e.ip[1] = htonl(ip2);
> +			last2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr2);
> +			e.cidr[1] = cidr2;
> +			ret = adtfn(set, &e, &ext, &ext, flags);
> +			if (ret && !ip_set_eexist(ret, flags))
> +				return ret;
> +			else
> +				ret = 0;
> +			ip2 = last2 + 1;
> +		}
> +		ip = last + 1;
> +	}
> +	return ret;
> +}
> +
> +/* IPv6 variants */
> +
> +struct hash_netnet6_elem {
> +	union nf_inet_addr ip[2];
> +	u8 nomatch;
> +	union {
> +		u8 cidr[2];
> +		u16 ccmp;
> +	};
> +};
> +
> +/* Common functions */
> +
> +static inline bool
> +hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
> +		     const struct hash_netnet6_elem *ip2,
> +		     u32 *multi)
> +{
> +	return ipv6_addr_equal(&ip1->ip[0].in6, &ip2->ip[0].in6) &&
> +	       ipv6_addr_equal(&ip1->ip[1].in6, &ip2->ip[1].in6) &&
> +	       ip1->ccmp == ip2->ccmp;
> +}
> +
> +static inline int
> +hash_netnet6_do_data_match(const struct hash_netnet6_elem *elem)
> +{
> +	return elem->nomatch ? -ENOTEMPTY : 1;
> +}
> +
> +static inline void
> +hash_netnet6_data_set_flags(struct hash_netnet6_elem *elem, u32 flags)
> +{
> +	elem->nomatch = (flags >> 16) & IPSET_FLAG_NOMATCH;
> +}
> +
> +static inline void
> +hash_netnet6_data_reset_flags(struct hash_netnet6_elem *elem, u8 *flags)
> +{
> +	swap(*flags, elem->nomatch);
> +}
> +
> +static inline void
> +hash_netnet6_data_reset_elem(struct hash_netnet6_elem *elem, struct hash_netnet6_elem *orig)
> +{
> +	elem->ip[1] = orig->ip[1];
> +}
> +
> +static inline void
> +hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, bool inner)
> +{
> +	if (inner) {
> +		ip6_netmask(&elem->ip[1], cidr);
> +		elem->cidr[1] = cidr;
> +	} else {
> +		ip6_netmask(&elem->ip[0], cidr);
> +		elem->cidr[0] = cidr;
> +	}
> +}
> +
> +static bool
> +hash_netnet6_data_list(struct sk_buff *skb, const struct hash_netnet6_elem *data)
> +{
> +	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
> +
> +	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip[0].in6) ||
> +	    nla_put_ipaddr6(skb, IPSET_ATTR_IP2, &data->ip[1].in6) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr[0]) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr[1]) ||
> +	    (flags &&
> +	     nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(flags))))
> +		goto nla_put_failure;
> +	return 0;
> +
> +nla_put_failure:
> +	return 1;
> +}
> +
> +static inline void
> +hash_netnet6_data_next(struct hash_netnet4_elem *next,
> +		    const struct hash_netnet6_elem *d)
> +{
> +}
> +
> +#undef MTYPE
> +#undef PF
> +#undef HOST_MASK
> +
> +#define MTYPE		hash_netnet6
> +#define PF		6
> +#define HOST_MASK	128
> +#define IP_SET_EMIT_CREATE
> +#include "ip_set_hash_gen.h"
> +
> +static int
> +hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
> +	       const struct xt_action_param *par,
> +	       enum ipset_adt adt, struct ip_set_adt_opt *opt)
> +{
> +	const struct hash_netnet *h = set->data;
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet6_elem e = {
> +		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
> +		.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK
> +	};
> +	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
> +
> +	if (adt == IPSET_TEST)
> +		e.ccmp = (HOST_MASK << (sizeof(u8)*8)) | HOST_MASK;
> +
> +	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip[0].in6);
> +	ip6addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip[1].in6);
> +	ip6_netmask(&e.ip[0], e.cidr[0]);
> +	ip6_netmask(&e.ip[1], e.cidr[1]);
> +
> +	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
> +}
> +
> +static int
> +hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
> +	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
> +{
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet6_elem e = { .cidr[0] = HOST_MASK, .cidr[1] = HOST_MASK };
> +	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
> +	int ret;
> +
> +	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PACKETS) ||
> +		     !ip_set_optattr_netorder(tb, IPSET_ATTR_BYTES)))
> +		return -IPSET_ERR_PROTOCOL;
> +	if (unlikely(tb[IPSET_ATTR_IP_TO]))
> +		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;

Check tb[IPSET_ATTR_IP2_TO] in the condition above too.

> +
> +	if (tb[IPSET_ATTR_LINENO])
> +		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
> +
> +	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip[0]) ||
> +	      ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip[1]) ||
> +	      ip_set_get_extensions(set, tb, &ext);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[IPSET_ATTR_CIDR])
> +		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> +
> +	if(tb[IPSET_ATTR_CIDR2])
> +		e.cidr[1] = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> +
> +	if (!e.cidr[0] || e.cidr[0] > HOST_MASK || !e.cidr[1] || e.cidr[1] > HOST_MASK)
> +		return -IPSET_ERR_INVALID_CIDR;
> +
> +	ip6_netmask(&e.ip[0], e.cidr[0]);
> +	ip6_netmask(&e.ip[1], e.cidr[1]);
> +
> +	if (tb[IPSET_ATTR_CADT_FLAGS]) {
> +		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> +		if (cadt_flags & IPSET_FLAG_NOMATCH)
> +			flags |= (IPSET_FLAG_NOMATCH << 16);
> +	}
> +
> +	ret = adtfn(set, &e, &ext, &ext, flags);
> +
> +	return ip_set_enomatch(ret, flags, adt, set) ? -ret :
> +	       ip_set_eexist(ret, flags) ? 0 : ret;
> +}
> +
> +static struct ip_set_type hash_netnet_type __read_mostly = {
> +	.name		= "hash:net,net",
> +	.protocol	= IPSET_PROTOCOL,
> +	.features	= IPSET_TYPE_IP | IPSET_TYPE_IP2 | IPSET_TYPE_NOMATCH,
> +	.dimension	= IPSET_DIM_TWO,
> +	.family		= NFPROTO_UNSPEC,
> +	.revision_min	= IPSET_TYPE_REV_MIN,
> +	.revision_max	= IPSET_TYPE_REV_MAX,
> +	.create		= hash_netnet_create,
> +	.create_policy	= {
> +		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
> +		[IPSET_ATTR_RESIZE]	= { .type = NLA_U8  },
> +		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
> +	},
> +	.adt_policy	= {
> +		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
> +		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
> +		[IPSET_ATTR_IP2]	= { .type = NLA_NESTED },
> +		[IPSET_ATTR_IP2_TO]	= { .type = NLA_NESTED },
> +		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
> +		[IPSET_ATTR_CIDR2]	= { .type = NLA_U8 },
> +		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
> +		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
> +		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
> +	},
> +	.me		= THIS_MODULE,
> +};
> +
> +static int __init
> +hash_netnet_init(void)
> +{
> +	return ip_set_type_register(&hash_netnet_type);
> +}
> +
> +static void __exit
> +hash_netnet_fini(void)
> +{
> +	ip_set_type_unregister(&hash_netnet_type);
> +}
> +
> +module_init(hash_netnet_init);
> +module_exit(hash_netnet_fini);
> -- 
> 1.8.3.2

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
