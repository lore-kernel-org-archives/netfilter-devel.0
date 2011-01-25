From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 13/13] "set" match and "SET" target support
Date: Tue, 25 Jan 2011 16:18:28 +0100
Message-ID: <4D3EE9C4.3020804@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-5-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-6-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-7-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-8-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-9-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-10-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-11-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-12-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-13-git-send-email-kadlec@blackhole.kfki.hu> <129
 5618527-9583-14-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1AYPSf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:18:35 -0500
In-Reply-To: <1295618527-9583-14-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.01.2011 15:02, Jozsef Kadlecsik wrote:
> --- /dev/null
> +++ b/net/netfilter/xt_set.c
> @@ -0,0 +1,370 @@
> +/* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
> + *                         Patrick Schaaf <bof@bof.de>
> + *                         Martin Josefsson <gandalf@wlug.westbo.se>
> + * Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/* Kernel module which implements the set match and SET target
> + * for netfilter/iptables. */
> +
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/version.h>
> +
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_set.h>
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> +MODULE_DESCRIPTION("Xtables: IP set match and target module");
> +MODULE_ALIAS("xt_SET");
> +MODULE_ALIAS("ipt_set");
> +MODULE_ALIAS("ip6t_set");
> +MODULE_ALIAS("ipt_SET");
> +MODULE_ALIAS("ip6t_SET");
> +
> +static inline int
> +match_set(ip_set_id_t index, const struct sk_buff *skb,
> +	  u8 pf, u8 dim, u8 flags, int inv)
> +{
> +	if (ip_set_test(index, skb, pf, dim, flags))
> +		inv = !inv;
> +	return inv;
> +}
> +
> +/* Revision 0 interface: backward compatible with netfilter/iptables */
> +
> +/* Backward compatibility constrains (incomplete):
> + *  2.6.24: [NETLINK]: Introduce nested and byteorder flag to netlink attribute
> + *  2.6.25: is_vmalloc_addr(): Check if an address is within the vmalloc
> + *	    boundaries
> + *  2.6.27: rcu: split list.h and move rcu-protected lists into rculist.h
> + *  2.6.28: netfilter: ctnetlink: remove bogus module dependency between
> + *	    ctnetlink and nf_nat (nfnl_lock/nfnl_unlock)
> + *  2.6.29: generic swap(): introduce global macro swap(a, b)
> + *  2.6.31: netfilter: passive OS fingerprint xtables match
> + *  2.6.34: rcu: Add lockdep-enabled variants of rcu_dereference()

These are just implementation details about what changed in previous
versions and don't really matter for the current kernel version.
I think this comment can be removed.

> + */
> +
> +#define	CHECK_OK	0
> +#define CHECK_FAIL	(-EINVAL)

This is not making the code easier to read, its a common convention
to return 0 for no error and errno codes otherwise.

> +static int
> +set_match_v0_checkentry(const struct xt_mtchk_param *par)
> +{
> +	struct xt_set_info_match_v0 *info = par->matchinfo;
> +	ip_set_id_t index;
> +
> +	index = ip_set_nfnl_get_byindex(info->match_set.index);
> +
> +	if (index == IPSET_INVALID_ID) {
> +		pr_warning("Cannot find set indentified by id %u to match\n",
> +			   info->match_set.index);
> +		return CHECK_FAIL;	/* error */

ENOENT?

> +	}
> +	if (info->match_set.u.flags[IPSET_DIM_MAX-1] != 0) {
> +		pr_warning("That's nasty!\n");
> +		return CHECK_FAIL;	/* error */
> +	}
> +
> +	/* Fill out compatibility data */
> +	compat_flags(&info->match_set);
> +
> +	return CHECK_OK;
> +}
> +
> +static int
> +set_target_v0_checkentry(const struct xt_tgchk_param *par)
> +{
> +	struct xt_set_info_target_v0 *info = par->targinfo;
> +	ip_set_id_t index;
> +
> +	if (info->add_set.index != IPSET_INVALID_ID) {
> +		index = ip_set_nfnl_get_byindex(info->add_set.index);
> +		if (index == IPSET_INVALID_ID) {
> +			pr_warning("cannot find add_set index %u as target\n",
> +				   info->add_set.index);
> +			return CHECK_FAIL;	/* error */

Same here.

> +		}
> +	}
> +
> +	if (info->del_set.index != IPSET_INVALID_ID) {
> +		index = ip_set_nfnl_get_byindex(info->del_set.index);
> +		if (index == IPSET_INVALID_ID) {
> +			pr_warning("cannot find del_set index %u as target\n",
> +				   info->del_set.index);
> +			return CHECK_FAIL;	/* error */
> +		}
> +	}
> +	if (info->add_set.u.flags[IPSET_DIM_MAX-1] != 0 ||
> +	    info->del_set.u.flags[IPSET_DIM_MAX-1] != 0) {
> +		pr_warning("That's nasty!\n");

This message doesn't seem very helpful. Assuming a structure
mismatch and no mischief, it would be better to print something
the user can understand.

> +		return CHECK_FAIL;	/* error */
> +	}
> +
> +	/* Fill out compatibility data */
> +	compat_flags(&info->add_set);
> +	compat_flags(&info->del_set);
> +
> +	return CHECK_OK;
> +}

> +static int
> +set_match_checkentry(const struct xt_mtchk_param *par)
> +{
> +	struct xt_set_info_match *info = par->matchinfo;
> +	ip_set_id_t index;
> +
> +	index = ip_set_nfnl_get_byindex(info->match_set.index);
> +
> +	if (index == IPSET_INVALID_ID) {
> +		pr_warning("Cannot find set indentified by id %u to match\n",
> +			   info->match_set.index);
> +		return CHECK_FAIL;	/* error */
> +	}
> +	if (info->match_set.dim > IPSET_DIM_MAX) {
> +		pr_warning("That's nasty!\n");

Even more so in this case, a future userspace version might support
more dimensions.

> +		return CHECK_FAIL;	/* error */
> +	}
> +
> +	return CHECK_OK;
> +}

> +
> +static int
> +set_target_checkentry(const struct xt_tgchk_param *par)
> +{
> +	const struct xt_set_info_target *info = par->targinfo;
> +	ip_set_id_t index;
> +
> +	if (info->add_set.index != IPSET_INVALID_ID) {
> +		index = ip_set_nfnl_get_byindex(info->add_set.index);
> +		if (index == IPSET_INVALID_ID) {
> +			pr_warning("cannot find add_set index %u as target\n",
> +				   info->add_set.index);
> +			return CHECK_FAIL;	/* error */

ENOENT?

> +		}
> +	}
> +
> +	if (info->del_set.index != IPSET_INVALID_ID) {
> +		index = ip_set_nfnl_get_byindex(info->del_set.index);
> +		if (index == IPSET_INVALID_ID) {
> +			pr_warning("cannot find del_set index %u as target\n",
> +				   info->del_set.index);
> +			return CHECK_FAIL;	/* error */
> +		}
> +	}
> +	if (info->add_set.dim > IPSET_DIM_MAX ||
> +	    info->del_set.flags > IPSET_DIM_MAX) {
> +		pr_warning("That's nasty!\n");
> +		return CHECK_FAIL;	/* error */
> +	}
> +
> +	return CHECK_OK;
> +}
> +

