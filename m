From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/12] IP set core support
Date: Wed, 19 Jan 2011 17:05:57 +0100
Message-ID: <4D370BE5.4050901@trash.net>
References: yes <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu> <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1ASQF7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:05:59 -0500
In-Reply-To: <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.01.2011 00:23, Jozsef Kadlecsik wrote:
> The patch adds the IP set core support to the kernel.

Following are some comments based on a first review. I'll make another
pass over this patch to have a closer look at the netlink protocol.

> The IP set core implements a netlink (nfnetlink) based protocol by which
> one can create, destroy, flush, rename, swap, list, save, restore sets,
> and add, delete, test elements from userspace. For simplicity (and backward
> compatibilty and for not to force ip(6)tables to be linked with a netlink
> library) reasons a small getsockopt-based protocol is also kept in order
> to communicate with the ip(6)tables match and target.
> 
> The netlink protocol passes all u16, etc values in network order, but it
> honors the NLA_F_NET_BYTEORDER flag. The protocol enforces the proper
> use of the NLA_F_NESTED flag for its container type of attributes.
> Backward/forward compatibility is supported with proper protocol (and set
> type) version number.

I don't really see the benefit of accepting both byteorders, why not
simply define the byteorder to big endian (with or without the
NLA_F_NET_BYTEORDER flag)? The current code will trigger sparse
endianess warnings when doing the byteorder conversion since the value
is always temporarily stored in a uXX.

Also the remaining code doesn't seem to make use of the endian specific
types, so this will trigger a lot of sparse warnings as well.

> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> new file mode 100644
> index 0000000..7003c78
> --- /dev/null
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -0,0 +1,522 @@
> +#ifndef _IP_SET_H
> +#define _IP_SET_H
> +
> +...
> +#ifdef __KERNEL__
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/vmalloc.h>
> +#include <net/netlink.h>

I think it would fit better with our current header organization to move
this part to include/net/netfilter/...

> +/* Sets are identified by an index in kernel space. Tweak with ip_set_id_t
> + * and IPSET_INVALID_ID if you want to increase the max number of sets.
> + */
> +typedef u16 ip_set_id_t;

This typedef does not really fit any of the "acceptable" cases of
CodingStyle, but I see why you're using it.

> +
> +...
> +/* Allocate members */
> +static inline void *
> +ip_set_alloc(size_t size, gfp_t gfp_mask)
> +{
> +	void *members = NULL;
> +
> +	if (size < KMALLOC_MAX_SIZE)
> +		members = kzalloc(size, gfp_mask | __GFP_NOWARN);
> +
> +	if (members) {
> +		pr_debug("%p: allocated with kmalloc", members);
> +		return members;
> +	}
> +
> +	members = __vmalloc(size, gfp_mask | __GFP_ZERO, PAGE_KERNEL);
> +	if (!members)
> +		return NULL;
> +	pr_debug("%p: allocated with vmalloc", members);
> +
> +	return members;

This looks too large to be inlined and is probably also not particulary
performance critical. I'd suggest to move the allocation and free
function to a .c file.

> ...
> +static const struct nla_policy ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] = {
> +	[IPSET_ATTR_IPADDR_IPV4]	= { .type = NLA_U32 },
> +	[IPSET_ATTR_IPADDR_IPV6]	= { .type = NLA_BINARY,
> +					    .len = sizeof(struct in6_addr) },
> +};
> +
> +static inline int
> +ip_set_get_ipaddr4(struct nlattr *attr[], int type, u32 *ipaddr)
> +{
> +	struct nlattr *tb[IPSET_ATTR_IPADDR_MAX+1] = {};

The initialization is not necessary, nla_parse already clears
the array.

> +
> +	if (!attr[type])
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	if (nla_parse(tb, IPSET_ATTR_IPADDR_MAX,
> +		      nla_data(attr[type]), nla_len(attr[type]),
> +		      ipaddr_policy))

This is exactly what nla_parse_nested() does.

> +		return -IPSET_ERR_PROTOCOL;
> +	if (!tb[IPSET_ATTR_IPADDR_IPV4])
> +		return -IPSET_ERR_IPADDR_IPV4;
> +
> +	*ipaddr = ip_set_get_n32(tb[IPSET_ATTR_IPADDR_IPV4]);
> +	return 0;
> +}

This also looks to large for inlining, also you're including the
nla_policy array in every file using this.

> +
> +static inline int
> +ip_set_get_ipaddr6(struct nlattr *attr[], int type, union nf_inet_addr *ipaddr)
> +{

Same comments as to ip_set_get_ipaddr4 apply.

> ...
> +
> +#define NLA_PUT_NET32(skb, type, value)	\
> +	NLA_PUT_BE32(skb, type | NLA_F_NET_BYTEORDER, value)
> +
> +#define NLA_PUT_NET16(skb, type, value)	\
> +	NLA_PUT_BE16(skb, type | NLA_F_NET_BYTEORDER, value)

These could maybe go into include/net/netlink.h.

> +/* Get address from skbuff */
> +static inline u32
> +ip4addr(const struct sk_buff *skb, bool src)

This and other related functions should be using the endian specific
types.

> ...
> +
> +/* Interface to iptables/ip6tables */
> +
> +#define SO_IP_SET		83

Just wondering if we should define this in relation to IP_BASE_CTL
or something like that to avoid possible clashes in the future.

> diff --git a/include/linux/netfilter/ipset/ip_set_kernel.h b/include/linux/netfilter/ipset/ip_set_kernel.h
> new file mode 100644
> index 0000000..d770589
> --- /dev/null
> +++ b/include/linux/netfilter/ipset/ip_set_kernel.h
> @@ -0,0 +1,15 @@
> +#ifndef _IP_SET_KERNEL_H
> +#define _IP_SET_KERNEL_H
> +
> +#ifdef __KERNEL__
> +
> +#ifdef CONFIG_DEBUG_KERNEL
> +/* Complete debug messages */
> +#define pr_fmt(fmt) "%s %s[%i]: " fmt "\n", __FILE__, __func__, __LINE__
> +#endif
> +
> +#include <linux/kernel.h>

Is this really still needed? Also include/net/netfilter would be a
better place for a purely kernel-internal header (same comment for
all other internal headers).

> +
> +#endif	/* __KERNEL__ */
> +
> +#endif /*_IP_SET_H */
> diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
> new file mode 100644
> index 0000000..fe7153c
> --- /dev/null
> +++ b/include/linux/netfilter/ipset/pfxlen.h
> @@ -0,0 +1,16 @@
> +#ifndef _PFXLEN_H
> +#define _PFXLEN_H
> +
> +#include <asm/byteorder.h>
> +#include <linux/netfilter.h> 
> +
> +/* Prefixlen maps, by Jan Engelhardt  */
> +extern const union nf_inet_addr prefixlen_netmask_map[];
> +extern const union nf_inet_addr prefixlen_hostmask_map[];
> +
> +#define NETMASK(n)	prefixlen_netmask_map[n].ip
> +#define NETMASK6(n)	prefixlen_netmask_map[n].ip6
> +#define HOSTMASK(n)	prefixlen_hostmask_map[n].ip
> +#define HOSTMASK6(n)	prefixlen_hostmask_map[n].ip6

These names seem a bit to generic.

> +
> +#endif /*_PFXLEN_H */
> --- /dev/null
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -0,0 +1,1556 @@
> +/* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
> + *                         Patrick Schaaf <bof@bof.de>
> + * Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/* Kernel module for IP set management */
> +
> +#include <linux/netfilter/ipset/ip_set_kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/ip.h>
> +#include <linux/skbuff.h>
> +#include <linux/spinlock.h>
> +#include <linux/netlink.h>
> +#include <linux/rculist.h>
> +#include <net/netlink.h>
> +
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/ipset/ip_set.h>
> +
> +static struct list_head ip_set_type_list;	/* all registered set types */

static LIST_HEAD(..) avoids the need for explicit initialization
during runtime.

> +static DEFINE_MUTEX(ip_set_type_mutex);		/* protects ip_set_type_list */
> +
> +static struct ip_set **ip_set_list;		/* all individual sets */
> +static ip_set_id_t ip_set_max = CONFIG_IP_SET_MAX; /* max number of sets */
> +
> +#define STREQ(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
> +
> +static int max_sets;
> +
> +module_param(max_sets, int, 0600);

unsigned int?

> +MODULE_PARM_DESC(max_sets, "maximal number of sets");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> +MODULE_DESCRIPTION("core IP set support");
> +MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_IPSET);
> +
> +/*
> + * The set types are implemented in modules and registered set types
> + * can be found in ip_set_type_list. Adding/deleting types is
> + * serialized by ip_set_type_mutex.
> + */
> +
> +static inline void
> +ip_set_type_lock(void)
> +{
> +	mutex_lock(&ip_set_type_mutex);
> +}
> +
> +static inline void
> +ip_set_type_unlock(void)
> +{
> +	mutex_unlock(&ip_set_type_mutex);
> +}
> +
> +/* Register and deregister settype */
> +
> +static inline struct ip_set_type *
> +find_set_type(const char *name, u8 family, u8 revision)

Except when the function is really small and performance critical,
its usually better to let the compiler decide based on the options
given (like optimize for size).

> +{
> +	struct ip_set_type *type;
> +
> +	list_for_each_entry_rcu(type, &ip_set_type_list, list)
> +		if (STREQ(type->name, name)
> +		    && (type->family == family || type->family == AF_UNSPEC)
> +		    && type->revision == revision)

This "&&" and "||" continuation style is used throughout the entire
ipset code. We had a bunch of patches a while ago to get rid of this
in the entire net/ tree, so I'd prefer not to reintroduce this.

> +			return type;
> +	return NULL;
> +}
> +

> +static inline void
> +load_type_module(const char *typename)
> +{
> +	pr_debug("try to load ip_set_%s", typename);
> +	request_module("ip_set_%s", typename);
> +}
> +
> +static int
> +ip_set_create(struct sock *ctnl, struct sk_buff *skb,
> +	      const struct nlmsghdr *nlh,
> +	      const struct nlattr * const attr[])
> +{
> +	struct ip_set *set, *clash;
> +	ip_set_id_t index = IPSET_INVALID_ID;
> +	const char *name, *typename;
> +	u8 family, revision;
> +	u32 flags = flag_exist(nlh);
> +	int ret = 0, len;
> +
> +	if (unlikely(protocol_failed(attr)
> +		     || attr[IPSET_ATTR_SETNAME] == NULL
> +		     || attr[IPSET_ATTR_TYPENAME] == NULL
> +		     || attr[IPSET_ATTR_REVISION] == NULL
> +		     || attr[IPSET_ATTR_FAMILY] == NULL
> +		     || (attr[IPSET_ATTR_DATA] != NULL
> +			 && !flag_nested(attr[IPSET_ATTR_DATA]))))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	name = nla_data(attr[IPSET_ATTR_SETNAME]);
> +	typename = nla_data(attr[IPSET_ATTR_TYPENAME]);
> +	family = nla_get_u8(attr[IPSET_ATTR_FAMILY]);
> +	revision = nla_get_u8(attr[IPSET_ATTR_REVISION]);
> +	pr_debug("setname: %s, typename: %s, family: %s, revision: %u",
> +		 name, typename, family_name(family), revision);
> +
> +	/*
> +	 * First, and without any locks, allocate and initialize
> +	 * a normal base set structure.
> +	 */
> +	set = kzalloc(sizeof(struct ip_set), GFP_KERNEL);
> +	if (!set)
> +		return -ENOMEM;
> +	rwlock_init(&set->lock);
> +	strlcpy(set->name, name, IPSET_MAXNAMELEN);
> +	atomic_set(&set->ref, 0);
> +	set->family = family;
> +
> +	/*
> +	 * Next, check that we know the type, and take
> +	 * a reference on the type, to make sure it stays available
> +	 * while constructing our new set.
> +	 *
> +	 * After referencing the type, we try to create the type
> +	 * specific part of the set without holding any locks.
> +	 */
> +	set->type = find_set_type_rcu(typename, family, revision);
> +	if (set->type == NULL) {
> +		/* Try loading the module */
> +		load_type_module(typename);

We holding the nfnl_mutex here, so you can't perform a module load.
It needs to release the mutex, perform the module load, grab the
mutex again and redo all checks that depend on the mutex. Check
out how ctnetlink does it (return -EAGAIN after successful load and
have nfnetlink replay the entire request).

> +		set->type = find_set_type_rcu(typename, family, revision);
> +		if (set->type == NULL) {
> +			pr_warning("Can't find ip_set type %s, family %s, "
> +				   "revision %u: set '%s' not created",
> +				   typename, family_name(family), revision,
> +				   name);
> +			ret = -IPSET_ERR_FIND_TYPE;
> +			goto out;
> +		}
> +	}
> +	if (!try_module_get(set->type->me)) {
> +		rcu_read_unlock();
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +	rcu_read_unlock();
> +
> +	...
> +}
> +
> +
> +/* Rename a set */
> +
> +static const struct nla_policy
> +ip_set_setname2_policy[IPSET_ATTR_CMD_MAX + 1] = {
> +	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
> +	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
> +				    .len = IPSET_MAXNAMELEN - 1 },
> +	[IPSET_ATTR_SETNAME2]	= { .type = NLA_NUL_STRING,
> +				    .len = IPSET_MAXNAMELEN - 1 },
> +};
> +
> +static int
> +ip_set_rename(struct sock *ctnl, struct sk_buff *skb,
> +	      const struct nlmsghdr *nlh,
> +	      const struct nlattr * const attr[])
> +{
> +	struct ip_set *set;
> +	const char *name2;
> +	ip_set_id_t i;
> +
> +	if (unlikely(protocol_failed(attr)
> +		     || attr[IPSET_ATTR_SETNAME] == NULL
> +		     || attr[IPSET_ATTR_SETNAME2] == NULL))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	set = find_set(nla_data(attr[IPSET_ATTR_SETNAME]));
> +	if (set == NULL)
> +		return -EEXIST;
> +	if (atomic_read(&set->ref) != 0)
> +		return -IPSET_ERR_REFERENCED;
> +
> +	name2 = nla_data(attr[IPSET_ATTR_SETNAME2]);
> +	for (i = 0; i < ip_set_max; i++) {
> +		if (ip_set_list[i] != NULL
> +		    && STREQ(ip_set_list[i]->name, name2))

There's also a nla_strcmp function, which can take the netlink
attribute as parameter directly.

> +			return -IPSET_ERR_EXIST_SETNAME2;
> +	}
> +	strncpy(set->name, name2, IPSET_MAXNAMELEN);

And a nla_strlcpy() function.
