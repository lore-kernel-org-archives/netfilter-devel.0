From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] Add hash:net,net ipset for storage of v4/v6 CIDR
 pairs.
Date: Mon, 2 Sep 2013 21:46:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309022104310.1199@blackhole.kfki.hu>
References: <7121481.vIdJUAPkhx@gentoovm> <1377825634-20308-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:33140 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab3IBTqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:46:09 -0400
In-Reply-To: <1377825634-20308-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Oliver,

On Fri, 30 Aug 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This adds a new set that provides the ability to configure pairs of
> subnets.
> 
> In order to achieve this, additional handling code has been
> added to deal with the fact that both parameters accept an arbitrary
> CIDR range. A preprocessor symbol is used to conditionally enable this
> extra code.

The patch is a good step forward, but see my comments.
 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/net/netfilter/ipset/Kbuild               |   1 +
>  kernel/net/netfilter/ipset/Kconfig              |   9 +
>  kernel/net/netfilter/ipset/ip_set_hash_gen.h    |  91 ++++
>  kernel/net/netfilter/ipset/ip_set_hash_netnet.c | 531 ++++++++++++++++++++++++
>  lib/Makefile.am                                 |   1 +
>  lib/ipset_hash_netnet.c                         | 158 +++++++
>  src/ipset.8                                     |  74 ++++
>  tests/hash:net,net.t                            | 155 +++++++
>  tests/hash:net,net.t.list0                      |  10 +
>  tests/hash:net,net.t.list1                      |   6 +
>  tests/hash:net,net.t.list2                      |  22 +
>  tests/hash:net6,net6.t                          | 139 +++++++
>  tests/hash:net6,net6.t.list0                    |  10 +
>  tests/hash:net6,net6.t.list1                    |   6 +
>  tests/netnetgen.sh                              |   9 +
>  tests/resizen.sh                                |  13 +
>  tests/resizet.sh                                |   8 +
>  tests/runtest.sh                                |   2 +-
>  18 files changed, 1244 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/net/netfilter/ipset/ip_set_hash_netnet.c
>  create mode 100644 lib/ipset_hash_netnet.c
>  create mode 100644 tests/hash:net,net.t
>  create mode 100644 tests/hash:net,net.t.list0
>  create mode 100644 tests/hash:net,net.t.list1
>  create mode 100644 tests/hash:net,net.t.list2
>  create mode 100644 tests/hash:net6,net6.t
>  create mode 100644 tests/hash:net6,net6.t.list0
>  create mode 100644 tests/hash:net6,net6.t.list1
>  create mode 100755 tests/netnetgen.sh
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
> index c694079..906c778 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -80,7 +80,13 @@ struct htable {
>  /* Book-keeping of the prefixes added to the set */
>  struct net_prefixes {
>  	u8 cidr;		/* the different cidr values in the set */
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +	u8 cidr2;
> +#endif
>  	u32 nets;		/* number of elements per cidr */
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +	u32 nets2;		/* number of elements per secondary cidr */
> +#endif
>  };

The code can further be simplified by introducing the array of cidr and 
nets struct elements and the single a double net types just set the 
array length.
  
>  /* Compute the hash table size */
> @@ -187,6 +193,7 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
>  #undef mtype_data_equal
>  #undef mtype_do_data_match
>  #undef mtype_data_set_flags
> +#undef mtype_data_reset_elem
>  #undef mtype_data_reset_flags
>  #undef mtype_data_netmask
>  #undef mtype_data_list
> @@ -226,6 +233,9 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
>  #define mtype_do_data_match(d)	1
>  #endif
>  #define mtype_data_set_flags	IPSET_TOKEN(MTYPE, _data_set_flags)
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +#define mtype_data_reset_elem	IPSET_TOKEN(MTYPE, _data_reset_elem)
> +#endif
>  #define mtype_data_reset_flags	IPSET_TOKEN(MTYPE, _data_reset_flags)
>  #define mtype_data_netmask	IPSET_TOKEN(MTYPE, _data_netmask)
>  #define mtype_data_list		IPSET_TOKEN(MTYPE, _data_list)
> @@ -233,6 +243,10 @@ hbucket_elem_add(struct hbucket *n, u8 ahash_max, size_t dsize)
>  #define mtype_elem		IPSET_TOKEN(MTYPE, _elem)
>  #define mtype_add_cidr		IPSET_TOKEN(MTYPE, _add_cidr)
>  #define mtype_del_cidr		IPSET_TOKEN(MTYPE, _del_cidr)
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +#define mtype_add_cidr2		IPSET_TOKEN(MTYPE, _add_cidr2)
> +#define mtype_del_cidr2		IPSET_TOKEN(MTYPE, _del_cidr2)
> +#endif
>  #define mtype_ahash_memsize	IPSET_TOKEN(MTYPE, _ahash_memsize)
>  #define mtype_flush		IPSET_TOKEN(MTYPE, _flush)
>  #define mtype_destroy		IPSET_TOKEN(MTYPE, _destroy)
> @@ -338,6 +352,52 @@ mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length)
>  		h->nets[j].nets = h->nets[j + 1].nets;
>  	}
>  }
> +
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +static void
> +mtype_add_cidr2(struct htype *h, u8 cidr, u8 nets_length)
> +{
> +	int i, j;
> +
> +	/* Add in increasing prefix order, so larger cidr first */
> +	for (i = 0, j = -1; i < nets_length && h->nets[i].nets2; i++) {
> +		if (j != -1)
> +			continue;
> +		else if (h->nets[i].cidr2 < cidr)
> +			j = i;
> +		else if (h->nets[i].cidr2 == cidr) {
> +			h->nets[i].nets2++;
> +			return;
> +		}
> +	}
> +	if (j != -1) {
> +		for (; i > j; i--) {
> +			h->nets[i].cidr2 = h->nets[i - 1].cidr2;
> +			h->nets[i].nets2 = h->nets[i - 1].nets2;
> +		}
> +	}
> +	h->nets[i].cidr2 = cidr;
> +	h->nets[i].nets2 = 1;
> +}
> +
> +static void
> +mtype_del_cidr2(struct htype *h, u8 cidr, u8 nets_length)
> +{
> +	u8 i, j;
> +
> +	for (i = 0; i < nets_length - 1 && h->nets[i].cidr2 != cidr; i++)
> +		;
> +	h->nets[i].nets2--;
> +
> +	if (h->nets[i].nets2 != 0)
> +		return;
> +
> +	for (j = i; j < nets_length - 1 && h->nets[j].nets2; j++) {
> +		h->nets[j].cidr2 = h->nets[j + 1].cidr2;
> +		h->nets[j].nets2 = h->nets[j + 1].nets2;
> +	}
> +}
> +#endif
>  #endif

If the arrays of cidr and nets introduced, then mtype_add_cidr, 
mtype_add_cidr2 and mtype_del_cidr, mtype_del_cidr2 can be unified. That 
way you can get rid of the the functions duplications.
  
>  /* Calculate the actual memory size of the set data */
> @@ -456,6 +516,10 @@ mtype_expire(struct htype *h, u8 nets_length, size_t dsize)
>  #ifdef IP_SET_HASH_WITH_NETS
>  				mtype_del_cidr(h, CIDR(data->cidr),
>  					       nets_length);
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +				mtype_del_cidr2(h, CIDR(data->cidr2),
> +					        nets_length);
> +#endif
>  #endif
>  				if (j != n->pos - 1)
>  					/* Not last one */
> @@ -642,7 +706,13 @@ reuse_slot:
>  		data = ahash_data(n, j, h->dsize);
>  #ifdef IP_SET_HASH_WITH_NETS
>  		mtype_del_cidr(h, CIDR(data->cidr), NETS_LENGTH(set->family));
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +		mtype_del_cidr2(h, CIDR(data->cidr2), NETS_LENGTH(set->family));
> +#endif
>  		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +		mtype_add_cidr2(h, CIDR(d->cidr2), NETS_LENGTH(set->family));
> +#endif
>  #endif

Reorder the calls above to spare one "#ifdef IP_SET_HASH_WITH_TWO_NETS".

>  	} else {
>  		/* Use/create a new slot */
> @@ -656,6 +726,9 @@ reuse_slot:
>  		data = ahash_data(n, n->pos++, h->dsize);
>  #ifdef IP_SET_HASH_WITH_NETS
>  		mtype_add_cidr(h, CIDR(d->cidr), NETS_LENGTH(set->family));
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +		mtype_add_cidr2(h, CIDR(d->cidr2), NETS_LENGTH(set->family));
> +#endif
>  #endif
>  		h->elements++;
>  	}
> @@ -754,13 +827,24 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  	struct htable *t = rcu_dereference_bh(h->table);
>  	struct hbucket *n;
>  	struct mtype_elem *data;
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +	struct mtype_elem orig = *d;
> +	int i, j = 0, k;
> +#else
>  	int i, j = 0;
> +#endif
>  	u32 key, multi = 0;
>  	u8 nets_length = NETS_LENGTH(set->family);
>  
>  	pr_debug("test by nets\n");
>  	for (; j < nets_length && h->nets[j].nets && !multi; j++) {
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +		mtype_data_reset_elem(d, &orig);
> +		for (k = 0; k < nets_length && h->nets[k].nets2 && !multi; k++) {
> +			mtype_data_netmask(d, h->nets[j].cidr, h->nets[k].cidr2);
> +#else
>  		mtype_data_netmask(d, h->nets[j].cidr);
> +#endif
>  		key = HKEY(d, h->initval, t->htable_bits);
>  		n = hbucket(t, key);
>  		for (i = 0; i < n->pos; i++) {
> @@ -780,6 +864,9 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
>  				return mtype_data_match(data, ext,
>  							mext, set, flags);
>  		}
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +		}
> +#endif
>  	}
>  	return 0;
>  }
> @@ -803,7 +890,11 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  #ifdef IP_SET_HASH_WITH_NETS
>  	/* If we test an IP address and not a network address,
>  	 * try all possible network sizes */
> +#ifdef IP_SET_HASH_WITH_TWO_NETS
> +	if (CIDR(d->cidr) == SET_HOST_MASK(set->family) && CIDR(d->cidr2) == SET_HOST_MASK(set->family)) {
> +#else
>  	if (CIDR(d->cidr) == SET_HOST_MASK(set->family)) {
> +#endif
>  		ret = mtype_test_cidrs(set, d, ext, mext, flags);
>  		goto out;
>  	}

Please make sure that the max line length is not exceeded (here and at 
other places too: use checkpatch.pl from kernel scripts/ directory).

> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_netnet.c b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
> new file mode 100644
> index 0000000..de8e634
> --- /dev/null
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_netnet.c
> @@ -0,0 +1,531 @@
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
> +#define IP_SET_HASH_WITH_TWO_NETS
> +
> +/* IPv4 variants */
> +
> +/* Member elements  */
> +struct hash_netnet4_elem {
> +	__be32 ip;
> +	__be32 ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +};
> +
> +struct hash_netnet4t_elem {
> +	__be32 ip;
> +	__be32 ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	unsigned long timeout;
> +};
> +
> +struct hash_netnet4c_elem {
> +	__be32 ip;
> +	__be32 ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	struct ip_set_counter counter;
> +};
> +
> +struct hash_netnet4ct_elem {
> +	__be32 ip;
> +	__be32 ip2;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	u8 padding0;
> +	struct ip_set_counter counter;
> +	unsigned long timeout;
> +};
> +
> +/* Common functions */
> +
> +static inline bool
> +hash_netnet4_data_equal(const struct hash_netnet4_elem *ip1,
> +		     const struct hash_netnet4_elem *ip2,
> +		     u32 *multi)
> +{
> +	return ip1->ip == ip2->ip &&
> +	       ip1->ip2 == ip2->ip2 &&
> +	       ip1->cidr == ip2->cidr &&
> +	       ip2->cidr2 == ip2->cidr2;
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
> +	elem->ip2 = orig->ip2;
> +}

Shouldn't elem->cidr2 be reset to the original value too?

> +static inline void
> +hash_netnet4_data_netmask(struct hash_netnet4_elem *elem, u8 cidr, u8 cidr2)
> +{
> +	elem->ip &= ip_set_netmask(cidr);
> +	elem->ip2 &= ip_set_netmask(cidr2);
> +	elem->cidr = cidr;
> +	elem->cidr2 = cidr2;
> +}
> +
> +static bool
> +hash_netnet4_data_list(struct sk_buff *skb, const struct hash_netnet4_elem *data)
> +{
> +	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
> +
> +	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, data->ip) ||
> +	    nla_put_ipaddr4(skb, IPSET_ATTR_IP2, data->ip2) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr2) ||
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
> +	next->ip = d->ip;
> +	next->ip2 = d->ip2;
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
> +		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
> +		.cidr2 = h->nets[0].cidr2 ? h->nets[0].cidr2 : HOST_MASK
> +	};
> +	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
> +
> +	if (adt == IPSET_TEST)
> +		e.cidr = e.cidr2 = HOST_MASK;
> +
> +	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
> +	ip4addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip2);
> +	e.ip &= ip_set_netmask(e.cidr);
> +	e.ip2 &= ip_set_netmask(e.cidr2);
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
> +	struct hash_netnet4_elem e = { .cidr = HOST_MASK, .cidr2 = HOST_MASK };
> +	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
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
> +		e.cidr = cidr;
> +	}
> +
> +	if(tb[IPSET_ATTR_CIDR2]) {
> +		cidr2 = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> +		if (!cidr2 || cidr2 > HOST_MASK)
> +			return -IPSET_ERR_INVALID_CIDR;
> +		e.cidr2 = cidr2;
> +	}
> +
> +	if (tb[IPSET_ATTR_CADT_FLAGS]) {
> +		u32 cadt_flags = ip_set_get_h32(tb[IPSET_ATTR_CADT_FLAGS]);
> +		if (cadt_flags & IPSET_FLAG_NOMATCH)
> +			flags |= (IPSET_FLAG_NOMATCH << 16);
> +	}
> +
> +	if (adt == IPSET_TEST || !(tb[IPSET_ATTR_IP_TO] && tb[IPSET_ATTR_IP2_TO])) {
> +		e.ip = htonl(ip & ip_set_hostmask(e.cidr));
> +		e.ip2 = htonl(ip2_from & ip_set_hostmask(e.cidr2));
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
> +		ip = ntohl(h->next.ip);
> +
> +	while (!after(ip, ip_to)) {
> +		e.ip = htonl(ip);
> +		last = ip_set_range_to_cidr(ip, ip_to, &cidr);
> +		e.cidr = cidr;
> +		ip2 = retried && ip == ntohl(h->next.ip) ? ntohl(h->next.ip2)
> +							 : ip2_from;
> +		while(!after(ip2, ip2_to)) {
> +			e.ip2 = htonl(ip2);
> +			last2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr2);
> +			e.cidr2 = cidr2;
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
> +	union nf_inet_addr ip;
> +	union nf_inet_addr ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +};
> +
> +struct hash_netnet6t_elem {
> +	union nf_inet_addr ip;
> +	union nf_inet_addr ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	unsigned long timeout;
> +};
> +
> +struct hash_netnet6c_elem {
> +	union nf_inet_addr ip;
> +	union nf_inet_addr ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	struct ip_set_counter counter;
> +};
> +
> +struct hash_netnet6ct_elem {
> +	union nf_inet_addr ip;
> +	union nf_inet_addr ip2;
> +	u8 padding0;
> +	u8 nomatch;
> +	u8 cidr;
> +	u8 cidr2;
> +	struct ip_set_counter counter;
> +	unsigned long timeout;
> +};
> +
> +/* Common functions */
> +
> +static inline bool
> +hash_netnet6_data_equal(const struct hash_netnet6_elem *ip1,
> +		     const struct hash_netnet6_elem *ip2,
> +		     u32 *multi)
> +{
> +	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6) &&
> +	       ipv6_addr_equal(&ip1->ip2.in6, &ip2->ip2.in6) &&
> +	       ip1->cidr == ip2->cidr &&
> +	       ip1->cidr2 == ip2->cidr2;
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
> +	elem->ip2 = orig->ip2;
> +}

The same comment as above for the IPv4 variant.

> +static inline void
> +hash_netnet6_data_netmask(struct hash_netnet6_elem *elem, u8 cidr, u8 cidr2)
> +{
> +	ip6_netmask(&elem->ip, cidr);
> +	ip6_netmask(&elem->ip2, cidr2);
> +	elem->cidr = cidr;
> +	elem->cidr2 = cidr2;
> +}
> +
> +static bool
> +hash_netnet6_data_list(struct sk_buff *skb, const struct hash_netnet6_elem *data)
> +{
> +	u32 flags = data->nomatch ? IPSET_FLAG_NOMATCH : 0;
> +
> +	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &data->ip.in6) ||
> +	    nla_put_ipaddr6(skb, IPSET_ATTR_IP2, &data->ip2.in6) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR, data->cidr) ||
> +	    nla_put_u8(skb, IPSET_ATTR_CIDR2, data->cidr2) ||
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
> +		.cidr = h->nets[0].cidr ? h->nets[0].cidr : HOST_MASK,
> +		.cidr2 = h->nets[0].cidr2 ? h->nets[0].cidr2 : HOST_MASK
> +	};
> +	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, h);
> +
> +	if (adt == IPSET_TEST)
> +		e.cidr = e.cidr2 = HOST_MASK;
> +
> +	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
> +	ip6addrptr(skb, opt->flags & IPSET_DIM_TWO_SRC, &e.ip2.in6);
> +	ip6_netmask(&e.ip, e.cidr);
> +	ip6_netmask(&e.ip2, e.cidr2);
> +
> +	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
> +}
> +
> +static int
> +hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
> +	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
> +{
> +	const struct hash_netnet *h = set->data;
> +	ipset_adtfn adtfn = set->variant->adt[adt];
> +	struct hash_netnet6_elem e = { .cidr = HOST_MASK, .cidr2 = HOST_MASK };
> +	struct ip_set_ext ext = IP_SET_INIT_UEXT(h);
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
> +
> +	if (tb[IPSET_ATTR_LINENO])
> +		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
> +
> +	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
> +	      ip_set_get_ipaddr6(tb[IPSET_ATTR_IP2], &e.ip2) ||
> +	      ip_set_get_extensions(set, tb, &ext);
> +	if (ret)
> +		return ret;
> +
> +	if (tb[IPSET_ATTR_CIDR])
> +		e.cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> +
> +	if(tb[IPSET_ATTR_CIDR2])
> +		e.cidr2 = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
> +
> +	if (!e.cidr || e.cidr > HOST_MASK || !e.cidr2 || e.cidr2 > HOST_MASK)
> +		return -IPSET_ERR_INVALID_CIDR;
> +
> +	ip6_netmask(&e.ip, e.cidr);
> +	ip6_netmask(&e.ip2, e.cidr2);
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
> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index ccc02aa..32fc820 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -9,6 +9,7 @@ IPSET_SETTYPE_LIST = \
>  	ipset_hash_ipportip.c \
>  	ipset_hash_ipportnet.c \
>  	ipset_hash_net.c \
> +	ipset_hash_netnet.c \
>  	ipset_hash_netport.c \
>  	ipset_hash_netiface.c \
>  	ipset_list_set.c
> diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
> new file mode 100644
> index 0000000..5cc5a40
> --- /dev/null
> +++ b/lib/ipset_hash_netnet.c
> @@ -0,0 +1,158 @@
> +/* Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
> + * Copyright 2013 Oliver Smith (oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <libipset/data.h>			/* IPSET_OPT_* */
> +#include <libipset/parse.h>			/* parser functions */
> +#include <libipset/print.h>			/* printing functions */
> +#include <libipset/types.h>			/* prototypes */
> +
> +/* Parse commandline arguments */
> +static const struct ipset_arg hash_netnet_create_args0[] = {
> +	{ .name = { "family", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,		.print = ipset_print_family,
> +	},
> +	/* Alias: family inet */
> +	{ .name = { "-4", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,
> +	},
> +	/* Alias: family inet6 */
> +	{ .name = { "-6", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,
> +	},
> +	{ .name = { "hashsize", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
> +	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
> +	},
> +	{ .name = { "maxelem", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
> +	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
> +	},
> +	{ .name = { "timeout", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
> +	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
> +	},
> +	{ .name = { "counters", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ },
> +};
> +
> +static const struct ipset_arg hash_netnet_add_args0[] = {
> +	{ .name = { "timeout", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
> +	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
> +	},
> +	{ .name = { "nomatch", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "packets", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
> +	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
> +	},
> +	{ .name = { "bytes", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
> +	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
> +	},
> +	{ },
> +};
> +
> +static const struct ipset_arg hash_netnet_test_args0[] = {
> +	{ .name = { "nomatch", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ },
> +};
> +
> +static const char hash_netnet_usage0[] =
> +"create SETNAME hash:net,net\n"
> +"		[family inet|inet6]\n"
> +"               [hashsize VALUE] [maxelem VALUE]\n"
> +"               [timeout VALUE] [counters]\n"
> +"add    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
> +"               [packets VALUE] [bytes VALUE]\n"
> +"del    SETNAME IP[/CIDR]|FROM-TO IP[/CIDR]|FROM-TO\n"
> +"test   SETNAME IP[/CIDR] IP[/CIDR]\n\n"
> +"where depending on the INET family\n"
> +"      IP is an IPv4 or IPv6 address (or hostname),\n"
> +"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
> +"      IP range is not supported with IPv6.\n";
> +
> +static struct ipset_type ipset_hash_netnet0 = {
> +	.name = "hash:net,net",
> +	.alias = { "netnethash", NULL },
> +	.revision = 0,
> +	.family = NFPROTO_IPSET_IPV46,
> +	.dimension = IPSET_DIM_TWO,
> +	.elem = {
> +		[IPSET_DIM_ONE - 1] = {
> +			.parse = ipset_parse_ip4_net6,
> +			.print = ipset_print_ip,
> +			.opt = IPSET_OPT_IP
> +		},
> +		[IPSET_DIM_TWO - 1] = {
> +			.parse = ipset_parse_ip4_net6,
> +			.print = ipset_print_ip,
> +			.opt = IPSET_OPT_IP2
> +		},
> +	},
> +	.args = {
> +		[IPSET_CREATE] = hash_netnet_create_args0,
> +		[IPSET_ADD] = hash_netnet_add_args0,
> +		[IPSET_TEST] = hash_netnet_test_args0,
> +	},
> +	.mandatory = {
> +		[IPSET_CREATE] = 0,
> +		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_IP2),
> +		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_IP2),
> +		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_IP2),
> +	},
> +	.full = {
> +		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
> +			| IPSET_FLAG(IPSET_OPT_MAXELEM)
> +			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
> +			| IPSET_FLAG(IPSET_OPT_COUNTERS),
> +		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_CIDR)
> +			| IPSET_FLAG(IPSET_OPT_IP_TO)
> +			| IPSET_FLAG(IPSET_OPT_IP2)
> +			| IPSET_FLAG(IPSET_OPT_CIDR2)
> +			| IPSET_FLAG(IPSET_OPT_IP2_TO)
> +			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
> +			| IPSET_FLAG(IPSET_OPT_NOMATCH)
> +			| IPSET_FLAG(IPSET_OPT_PACKETS)
> +			| IPSET_FLAG(IPSET_OPT_BYTES),
> +		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_CIDR)
> +			| IPSET_FLAG(IPSET_OPT_IP_TO)
> +			| IPSET_FLAG(IPSET_OPT_IP2)
> +			| IPSET_FLAG(IPSET_OPT_CIDR2)
> +			| IPSET_FLAG(IPSET_OPT_IP2_TO),
> +		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_CIDR)
> +			| IPSET_FLAG(IPSET_OPT_IP2)
> +			| IPSET_FLAG(IPSET_OPT_CIDR2)
> +			| IPSET_FLAG(IPSET_OPT_NOMATCH),
> +	},
> +
> +	.usage = hash_netnet_usage0,
> +	.description = "counters support",
> +};
> +
> +void _init(void);
> +void _init(void)
> +{
> +	ipset_type_add(&ipset_hash_netnet0);
> +}
> diff --git a/src/ipset.8 b/src/ipset.8
> index d7fa964..b53e94d 100644
> --- a/src/ipset.8
> +++ b/src/ipset.8
> @@ -534,6 +534,80 @@ ipset add foo 192.168.0/30 nomatch
>  When matching the elements in the set above, all IP addresses will match
>  from the networks 192.168.0.0/24, 10.1.0.0/16 and 192.168.0/24 except
>  the ones from 192.168.0/30.
> +.SS hash:net,net
> +The \fBhash:net,net\fR set type uses a hash to store pairs of different sized IP
> +network addresses.  Bear  in  mind  that  the  first parameter has precedence
> +over the second, so a nomatch entry could be potentially be ineffective if a more specific
> +first parameter existed with a suitable second parameter.
> +Network address with zero prefix size cannot be stored in this type of set.
> +.PP
> +\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
> +.PP
> +\fIADD\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
> +.PP
> +\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
> +.PP
> +\fIDEL\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
> +.PP
> +\fITEST\-ENTRY\fR := \fInetaddr\fR,\fInetaddr,\fR
> +.PP
> +where
> +\fInetaddr\fR := \fIip\fR[/\fIcidr\fR]
> +.PP
> +Optional \fBcreate\fR options:
> +.TP
> +\fBfamily\fR { \fBinet\fR | \fBinet6\fR }
> +The protocol family of the IP addresses to be stored in the set. The default is
> +\fBinet\fR, i.e IPv4.
> +.TP
> +\fBhashsize\fR \fIvalue\fR
> +The initial hash size for the set, default is 1024. The hash size must be a power
> +of two, the kernel automatically rounds up non power of two hash sizes to the first
> +correct value.
> +.TP
> +\fBmaxelem\fR \fIvalue\fR
> +The maximal number of elements which can be stored in the set, default 65536.
> +.PP
> +For the \fBinet\fR family one can add or delete multiple entries by specifying
> +a range, which is converted internally to network(s) equal to the range:
> +.PP
> +\fInetaddr\fR := { \fIip\fR[/\fIcidr\fR] | \fIfromaddr\fR\-\fItoaddr\fR }
> +.PP
> +When adding/deleting/testing entries, if the cidr prefix parameter is not specified,
> +then the host prefix value is assumed. When adding/deleting entries, the exact
> +element is added/deleted and overlapping elements are not checked by the kernel.
> +When testing entries, if a host address is tested, then the kernel tries to match
> +the host address in the networks added to the set and reports the result accordingly.
> +.PP
> +From the \fBset\fR netfilter match point of view the searching for a match
> +always  starts  from  the smallest  size  of netblock (most specific
> +prefix) to the largest one (least specific prefix) with the first param
> +having precedence.
> +When  adding/deleting IP addresses  to the set by the \fBSET\fR netfilter target,
> +it  will  be  added/deleted  by  the most specific prefix which can be found in
> +the set, or by the host prefix value if the set is empty.
> +.PP
> +The lookup time grows linearly with the number of the different prefix
> +values added to the first parameter of the set. The number of secondary prefixes
> +further increases this as the list of secondary prefixes is traversed per primary
> +prefix.
> +.PP
> +Example:
> +.IP
> +ipset create foo hash:net,net
> +.IP
> +ipset add foo 192.168.0.0/24,10.0.1.0/24
> +.IP
> +ipset add foo 10.1.0.0/16,10.255.0.0/24
> +.IP
> +ipset add foo 192.168.0/24,192.168.54.0-192.168.54.255
> +.IP
> +ipset add foo 192.168.0/30,192.168.64/30 nomatch
> +.PP
> +When matching the elements in the set above, all IP addresses will match
> +from the networks 192.168.0.0/24<->10.0.1.0/24, 10.1.0.0/16<->10.255.0.0/24
> +and 192.168.0/24<->192.168.54.0/24 except the ones from
> +192.168.0/30<->192.168.64/30.
>  .SS hash:ip,port
>  The \fBhash:ip,port\fR set type uses a hash to store IP address and port number pairs.
>  The port number is interpreted together with a protocol (default TCP) and zero
> diff --git a/tests/hash:net,net.t b/tests/hash:net,net.t
> new file mode 100644
> index 0000000..ed708d2
> --- /dev/null
> +++ b/tests/hash:net,net.t
> @@ -0,0 +1,155 @@
> +# Create a set with timeout
> +0 ipset create test hash:net,net hashsize 128 timeout 5
> +# Add zero valued element
> +1 ipset add test 0.0.0.0/0,0.0.0.0/0
> +# Test zero valued element
> +1 ipset test test 0.0.0.0/0,0.0.0.0/0
> +# Delete zero valued element
> +1 ipset del test 0.0.0.0/0,0.0.0.0/0
> +# Try to add /0
> +1 ipset add test 1.1.1.1/0,1.1.1.1/0
> +# Try to add /32
> +0 ipset add test 1.1.1.1/32,1.1.1.2/32
> +# Add almost zero valued element
> +0 ipset add test 0.0.0.0/1,0.0.0.0/1
> +# Test almost zero valued element
> +0 ipset test test 0.0.0.0/1,0.0.0.0/1
> +# Delete almost zero valued element
> +0 ipset del test 0.0.0.0/1,0.0.0.0/1
> +# Test deleted element
> +1 ipset test test 0.0.0.0/1,0.0.0.0/1
> +# Delete element not added to the set
> +1 ipset del test 0.0.0.0/1,0.0.0.0/1
> +# Add first random network
> +0 ipset add test 2.0.0.1/24,2.0.1.1/24
> +# Add second random network
> +0 ipset add test 192.168.68.69/27,192.168.129.69/27
> +# Test first random value
> +0 ipset test test "2.0.0.255,2.0.1.255"

Why are the quotation marks required?

> +# Test second random value
> +0 ipset test test 192.168.68.95,192.168.129.75
> +# Test value not added to the set
> +1 ipset test test 2.0.1.0,2.0.0.1
> +# Try to add IP address
> +0 ipset add test 2.0.0.1,2.0.0.2
> +# List set
> +0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
> +# Check listing
> +0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list0
> +# Sleep 5s so that element can time out
> +0 sleep 5
> +# List set
> +0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
> +# Check listing
> +0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list1
> +# Flush test set
> +0 ipset flush test
> +# Delete test set
> +0 ipset destroy test
> +# Create test set
> +0 ipset new test hash:net,net
> +# Add networks in range notation
> +0 ipset add test 10.2.0.0-10.2.1.12,10.3.0.0-10.3.1.12
> +# List set
> +0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
> +# Check listing
> +0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list2
> +# Delete test set
> +0 ipset destroy test
> +# Stress test with range notation
> +0 ./netnetgen.sh | ipset restore
> +# List set and check the number of elements
> +0 n=`ipset -L test|grep '^10.'|wc -l` && test $n -eq 87040
> +# Destroy test set
> +0 ipset destroy test
> +# Create test set with timeout support
> +0 ipset create test hash:net,net timeout 30
> +# Add a non-matching IP address entry
> +0 ipset -A test 1.1.1.1,1.1.1.2 nomatch
> +# Add an overlapping matching small net
> +0 ipset -A test 1.1.1.0/30,1.1.1.0/30
> +# Add an overlapping non-matching larger net
> +0 ipset -A test 1.1.1.0/28,1.1.1.0/28 nomatch
> +# Add an even larger matching net
> +0 ipset -A test 1.1.1.0/26,1.1.1.0/26
> +# Check non-matching IP
> +1 ipset -T test 1.1.1.1,1.1.1.2
> +# Check matching IP from non-matchin small net
> +0 ipset -T test 1.1.1.3,1.1.1.2
> +# Check non-matching IP from larger net
> +1 ipset -T test 1.1.1.4,1.1.1.4
> +# Check matching IP from even larger net
> +0 ipset -T test 1.1.1.16,1.1.1.16
> +# Update non-matching IP to matching one
> +0 ipset -! -A test 1.1.1.1,1.1.1.2
> +# Delete overlapping small net
> +0 ipset -D test 1.1.1.0/30,1.1.1.0/30
> +# Check matching IP
> +0 ipset -T test 1.1.1.1,1.1.1.2
> +# Add overlapping small net
> +0 ipset -A test 1.1.1.0/30,1.1.1.0/30
> +# Update matching IP as a non-matching one, with shorter timeout
> +0 ipset -! -A test 1.1.1.1,1.1.1.2 nomatch timeout 2
> +# Check non-matching IP
> +1 ipset -T test 1.1.1.1,1.1.1.2
> +# Sleep 3s so that element can time out
> +0 sleep 3
> +# Check non-matching IP
> +0 ipset -T test 1.1.1.1,1.1.1.2
> +# Check matching IP
> +0 ipset -T test 1.1.1.3,1.1.1.2
> +# Delete test set
> +0 ipset destroy test
> +# Timeout: Check that resizing keeps timeout values
> +0 ./resizet.sh -4 netnet
> +# Nomatch: Check that resizing keeps the nomatch flag
> +0 ./resizen.sh -4 netnet
> +# Counters: create set
> +0 ipset n test hash:net,net counters
> +# Counters: add element with packet, byte counters
> +0 ipset a test 2.0.0.1/24,2.0.0.1/24 packets 5 bytes 3456
> +# Counters: check element
> +0 ipset t test 2.0.0.1/24,2.0.0.1/24
> +# Counters: check counters
> +0 ./check_counters test 2.0.0.0/24,2.0.0.0/24 5 3456
> +# Counters: delete element
> +0 ipset d test 2.0.0.1/24,2.0.0.1/24
> +# Counters: test deleted element
> +1 ipset t test 2.0.0.1/24,2.0.0.1/24
> +# Counters: add element with packet, byte counters
> +0 ipset a test 2.0.0.20/25,2.0.0.20/25 packets 12 bytes 9876
> +# Counters: check counters
> +0 ./check_counters test 2.0.0.0/25,2.0.0.0/25 12 9876
> +# Counters: update counters
> +0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 packets 13 bytes 12479
> +# Counters: check counters
> +0 ./check_counters test 2.0.0.0/25,2.0.0.0/25 13 12479
> +# Counters: destroy set
> +0 ipset x test
> +# Counters and timeout: create set
> +0 ipset n test hash:net,net counters timeout 600
> +# Counters and timeout: add element with packet, byte counters
> +0 ipset a test 2.0.0.1/24,2.0.0.1/24 packets 5 bytes 3456
> +# Counters and timeout: check element
> +0 ipset t test 2.0.0.1/24,2.0.0.1/24
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2.0.0.0/24,2.0.0.0/24 600 5 3456
> +# Counters and timeout: delete element
> +0 ipset d test 2.0.0.1/24,2.0.0.1/24
> +# Counters and timeout: test deleted element
> +1 ipset t test 2.0.0.1/24,2.0.0.1/24
> +# Counters and timeout: add element with packet, byte counters
> +0 ipset a test 2.0.0.20/25,2.0.0.20/25 packets 12 bytes 9876
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 600 12 9876
> +# Counters and timeout: update counters
> +0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 packets 13 bytes 12479
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 600 13 12479
> +# Counters and timeout: update timeout
> +0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 timeout 700
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 700 13 12479
> +# Counters and timeout: destroy set
> +0 ipset x test
> +# eof

Please add tests (for the IPv6 variant too), where the precedence of the 
first network over the second one is demonstrated and verified, i.e. there 
are intersecting networks like "10.0.0.0/16,192.168.0.0/24", 
10.0.0.0/24,192.168.0.0/16" nomatch", "10.0.0.0/30,192.168.0.0/24" and all 
the different match/non-match cases are checked/tested. In the tests above 
there's no such a case and it's important, for documentation purposes too.

Otherwise the patch looks just fine.

Best regards,
Jozsef

> diff --git a/tests/hash:net,net.t.list0 b/tests/hash:net,net.t.list0
> new file mode 100644
> index 0000000..b759316
> --- /dev/null
> +++ b/tests/hash:net,net.t.list0
> @@ -0,0 +1,10 @@
> +Name: test
> +Type: hash:net,net
> +Header: family inet hashsize 128 maxelem 65536 timeout x
> +Size in memory: 3040
> +References: 0
> +Members:
> +1.1.1.1,1.1.1.2 timeout x
> +192.168.68.64/27,192.168.129.64/27 timeout x
> +2.0.0.0/24,2.0.1.0/24 timeout x
> +2.0.0.1,2.0.0.2 timeout x
> diff --git a/tests/hash:net,net.t.list1 b/tests/hash:net,net.t.list1
> new file mode 100644
> index 0000000..d27b4a4
> --- /dev/null
> +++ b/tests/hash:net,net.t.list1
> @@ -0,0 +1,6 @@
> +Name: test
> +Type: hash:net,net
> +Header: family inet hashsize 128 maxelem 65536 timeout 5
> +Size in memory: 3040
> +References: 0
> +Members:
> diff --git a/tests/hash:net,net.t.list2 b/tests/hash:net,net.t.list2
> new file mode 100644
> index 0000000..adf26ff
> --- /dev/null
> +++ b/tests/hash:net,net.t.list2
> @@ -0,0 +1,22 @@
> +Name: test
> +Type: hash:net,net
> +Header: family inet hashsize 1024 maxelem 65536
> +Size in memory: 17664
> +References: 0
> +Members:
> +10.2.0.0/24,10.3.0.0/24
> +10.2.0.0/24,10.3.1.0/29
> +10.2.0.0/24,10.3.1.12
> +10.2.0.0/24,10.3.1.8/30
> +10.2.1.0/29,10.3.0.0/24
> +10.2.1.0/29,10.3.1.0/29
> +10.2.1.0/29,10.3.1.12
> +10.2.1.0/29,10.3.1.8/30
> +10.2.1.12,10.3.0.0/24
> +10.2.1.12,10.3.1.0/29
> +10.2.1.12,10.3.1.12
> +10.2.1.12,10.3.1.8/30
> +10.2.1.8/30,10.3.0.0/24
> +10.2.1.8/30,10.3.1.0/29
> +10.2.1.8/30,10.3.1.12
> +10.2.1.8/30,10.3.1.8/30
> diff --git a/tests/hash:net6,net6.t b/tests/hash:net6,net6.t
> new file mode 100644
> index 0000000..1b60875
> --- /dev/null
> +++ b/tests/hash:net6,net6.t
> @@ -0,0 +1,139 @@
> +# Create a set with timeout
> +0 ipset create test hash:net,net family inet6 hashsize 128 timeout 5
> +# Add zero valued element
> +1 ipset add test ::/0,::/0
> +# Test zero valued element
> +1 ipset test test ::/0,::/0
> +# Delete zero valued element
> +1 ipset del test ::/0,::/0
> +# Try to add /0
> +1 ipset add test 1:1:1::1/0,1:1:1::1/0
> +# Try to add /128
> +0 ipset add test 1:1:1::1/128,2:2:2::2/128
> +# Add almost zero valued element
> +0 ipset add test 0:0:0::0/1,0:0:0::0/1
> +# Test almost zero valued element
> +0 ipset test test 0:0:0::0/1,0:0:0::0/1
> +# Delete almost zero valued element
> +0 ipset del test 0:0:0::0/1,0:0:0::0/1
> +# Test deleted element
> +1 ipset test test 0:0:0::0/1,0:0:0::0/1
> +# Delete element not added to the set
> +1 ipset del test 0:0:0::0/1,0:0:0::0/1
> +# Add first random network
> +0 ipset add test 2:0:0::1/24,4:0:0::1/32
> +# Add second random network
> +0 ipset add test 192:168:68::69/27,172:16:68::69/48
> +# Test first random value
> +0 ipset test test 2:0:0::255,4:0:0::54
> +# Test second random value
> +0 ipset test test 192:168:68::95,172:16:68::68
> +# Test value not added to the set
> +1 ipset test test 3:0:0::1,172:255:24::1
> +# Try to add IP address
> +0 ipset add test 3:0:0::1,8:0:0::1
> +# List set
> +0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
> +# Check listing
> +0 diff -u -I 'Size in memory.*' .foo hash:net6,net6.t.list0
> +# Sleep 5s so that element can time out
> +0 sleep 5
> +# IP: List set
> +0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
> +# IP: Check listing
> +0 diff -u -I 'Size in memory.*' .foo hash:net6,net6.t.list1
> +# Flush test set
> +0 ipset flush test
> +# Delete test set
> +0 ipset destroy test
> +# Create test set with timeout support
> +0 ipset create test hash:net,net family inet6 timeout 30
> +# Add a non-matching IP address entry
> +0 ipset -A test 1:1:1::1,2:2:2::2 nomatch
> +# Add an overlapping matching small net
> +0 ipset -A test 1:1:1::/124,2:2:2::/124
> +# Add an overlapping non-matching larger net
> +0 ipset -A test 1:1:1::/120,2:2:2::/120 nomatch
> +# Add an even larger matching net
> +0 ipset -A test 1:1:1::/116,2:2:2::/116
> +# Check non-matching IP
> +1 ipset -T test 1:1:1::1,2:2:2::2
> +# Check matching IP from non-matchin small net
> +0 ipset -T test 1:1:1::f,2:2:2::f
> +# Check non-matching IP from larger net
> +1 ipset -T test 1:1:1::10,2:2:2::10
> +# Check matching IP from even larger net
> +0 ipset -T test 1:1:1::100,2:2:2::100
> +# Update non-matching IP to matching one
> +0 ipset -! -A test 1:1:1::1,2:2:2::2
> +# Delete overlapping small net
> +0 ipset -D test 1:1:1::/124,2:2:2::/124
> +# Check matching IP
> +0 ipset -T test 1:1:1::1,2:2:2::2
> +# Add overlapping small net
> +0 ipset -A test 1:1:1::/124,2:2:2::/124
> +# Update matching IP as a non-matching one, with shorter timeout
> +0 ipset -! -A test 1:1:1::1,2:2:2::2 nomatch timeout 2
> +# Check non-matching IP
> +1 ipset -T test 1:1:1::1,2:2:2::2
> +# Sleep 3s so that element can time out
> +0 sleep 3
> +# Check non-matching IP
> +0 ipset -T test 1:1:1::1,2:2:2::2
> +# Check matching IP
> +0 ipset -T test 1:1:1::f,2:2:2::f
> +# Delete test set
> +0 ipset destroy test
> +# Timeout: Check that resizing keeps timeout values
> +0 ./resizet.sh -6 net
> +# Nomatch: Check that resizing keeps the nomatch flag
> +0 ./resizen.sh -6 net
> +# Counters: create set
> +0 ipset n test hash:net,net -6 counters
> +# Counters: add element with packet, byte counters
> +0 ipset a test 2:0:0::1/64,3:0:0::1/64 packets 5 bytes 3456
> +# Counters: check element
> +0 ipset t test 2:0:0::1/64,3:0:0::1/64
> +# Counters: check counters
> +0 ./check_counters test 2:: 5 3456
> +# Counters: delete element
> +0 ipset d test 2:0:0::1/64,3:0:0::1/64
> +# Counters: test deleted element
> +1 ipset t test 2:0:0::1/64,3:0:0::1/64
> +# Counters: add element with packet, byte counters
> +0 ipset a test 2:0:0::20/54,3:0:0::20/54 packets 12 bytes 9876
> +# Counters: check counters
> +0 ./check_counters test 2:: 12 9876
> +# Counters: update counters
> +0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 packets 13 bytes 12479
> +# Counters: check counters
> +0 ./check_counters test 2:: 13 12479
> +# Counters: destroy set
> +0 ipset x test
> +# Counters and timeout: create set
> +0 ipset n test hash:net,net -6 counters timeout 600
> +# Counters and timeout: add element with packet, byte counters
> +0 ipset a test 2:0:0::1/64,3:0:0::1/64 packets 5 bytes 3456
> +# Counters and timeout: check element
> +0 ipset t test 2:0:0::1/64,3:0:0::1/64
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2:: 600 5 3456
> +# Counters and timeout: delete element
> +0 ipset d test 2:0:0::1/64,3:0:0::1/64
> +# Counters and timeout: test deleted element
> +1 ipset t test 2:0:0::1/64,3:0:0::1/64
> +# Counters and timeout: add element with packet, byte counters
> +0 ipset a test 2:0:0::20/54,3:0:0::20/54 packets 12 bytes 9876
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2:: 600 12 9876
> +# Counters and timeout: update counters
> +0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 packets 13 bytes 12479
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2:: 600 13 12479
> +# Counters and timeout: update timeout
> +0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 timeout 700
> +# Counters and timeout: check counters
> +0 ./check_extensions test 2:: 700 13 12479
> +# Counters and timeout: destroy set
> +0 ipset x test
> +# eof
> diff --git a/tests/hash:net6,net6.t.list0 b/tests/hash:net6,net6.t.list0
> new file mode 100644
> index 0000000..ea78bbb
> --- /dev/null
> +++ b/tests/hash:net6,net6.t.list0
> @@ -0,0 +1,10 @@
> +Name: test
> +Type: hash:net,net
> +Header: family inet6 hashsize 128 maxelem 65536 timeout x
> +Size in memory: 4672
> +References: 0
> +Members:
> +192:160::/27,172:16:68::/48 timeout x
> +1:1:1::1,2:2:2::2 timeout x
> +2::/24,4::/32 timeout x
> +3::1,8::1 timeout x
> diff --git a/tests/hash:net6,net6.t.list1 b/tests/hash:net6,net6.t.list1
> new file mode 100644
> index 0000000..0e1b7d2
> --- /dev/null
> +++ b/tests/hash:net6,net6.t.list1
> @@ -0,0 +1,6 @@
> +Name: test
> +Type: hash:net,net
> +Header: family inet6 hashsize 128 maxelem 65536 timeout 5
> +Size in memory: 4672
> +References: 0
> +Members:
> diff --git a/tests/netnetgen.sh b/tests/netnetgen.sh
> new file mode 100755
> index 0000000..e33710e
> --- /dev/null
> +++ b/tests/netnetgen.sh
> @@ -0,0 +1,9 @@
> +#!/bin/sh
> +
> +echo "n test hash:net,net hashsize 32 maxelem 87040"
> +for x in `seq 0 255`; do
> +    for y in `seq 0 3 253`; do
> +	z=$((y+2))
> +	echo "a test 10.0.0.0-10.0.2.255,10.$x.$y.0-10.$x.$z.255"
> +    done
> +done
> diff --git a/tests/resizen.sh b/tests/resizen.sh
> index 1294efc..7df5dc8 100644
> --- a/tests/resizen.sh
> +++ b/tests/resizen.sh
> @@ -47,6 +47,19 @@ case "$2" in
>      	    done
>      	done
>      	;;
> +    netnet)
> +	$ipset n test hash:net,net $1 hashsize 64
> +	for x in `seq 0 16`; do
> +	    for y in `seq 0 255`; do
> +		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch
> +	    done
> +	done
> +	for x in `seq 0 16`; do
> +	    for y in `seq 0 255`; do
> +		$ipset t test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch 2>/dev/null
> +	    done
> +	done
> +	;;
>      netport)
>      	$ipset n test hash:net,port $1 hashsize 64
>      	for x in `seq 0 16`; do
> diff --git a/tests/resizet.sh b/tests/resizet.sh
> index 74fb19e..ff98d58 100644
> --- a/tests/resizet.sh
> +++ b/tests/resizet.sh
> @@ -61,6 +61,14 @@ case "$2" in
>      	    done
>      	done
>      	;;
> +    netnet)
> +	$ipset n test hash:net,net $1 hashsize 64 timeout 100
> +	for x in `seq 0 16`; do
> +	    for y in `seq 0 255`; do
> +		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net
> +	    done
> +	done
> +	;;
>      netport)
>      	$ipset n test hash:net,port $1 hashsize 64 timeout 100
>      	for x in `seq 0 16`; do
> diff --git a/tests/runtest.sh b/tests/runtest.sh
> index b14f151..261a657 100755
> --- a/tests/runtest.sh
> +++ b/tests/runtest.sh
> @@ -8,7 +8,7 @@ tests="$tests macipmap portmap"
>  tests="$tests iphash hash:ip hash:ip6"
>  tests="$tests ipporthash hash:ip,port hash:ip6,port"
>  tests="$tests ipportiphash hash:ip,port,ip hash:ip6,port,ip6"
> -tests="$tests nethash hash:net hash:net6 hash:net,port hash:net6,port"
> +tests="$tests nethash hash:net hash:net6 hash:net,port hash:net6,port hash:net,net hash:net6,net6"
>  tests="$tests hash:ip,port,net hash:ip6,port,net6"
>  tests="$tests hash:net,iface.t"
>  tests="$tests setlist restore"
> -- 
> 1.8.2.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
