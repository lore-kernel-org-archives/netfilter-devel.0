From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Tue, 24 Jun 2008 17:38:17 +0200
Message-ID: <486114E9.9000809@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Piotr Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYFXPiW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:38:22 -0400
In-Reply-To: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A few minor nits - a patch on top to fix them is fine, I'll
just fold them together.

Krzysztof Piotr Oledzki wrote:
> diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
> new file mode 100644
> index 0000000..6b26e5e
> --- /dev/null
> +++ b/include/net/netfilter/nf_conntrack_acct.h
> @@ -0,0 +1,22 @@
> +#ifndef _NF_CONNTRACK_ACCT_H
> +#define _NF_CONNTRACK_ACCT_H
> +#include <linux/netfilter/nf_conntrack_common.h>
> +#include <linux/netfilter/nf_conntrack_tuple_common.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_extend.h>
> +
> +static inline
> +struct ip_conntrack_counter *nf_conn_acct_find(const struct nf_conn *ct)
> +{
> +	return nf_ct_ext_find(ct, NF_CT_EXT_ACCT);
> +}
> +
> +struct ip_conntrack_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp);
> +
> +unsigned int
> +seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir);
> +
> +int nf_conntrack_acct_init(void);
> +void nf_conntrack_acct_fini(void);

extern for function declarations please. Also using ip_conntrack in the
struct name doesn't make much sense, please use nf_conntrack as prefix.
Or maybe for consistency with the other extensions, nf_conn.

> diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
> new file mode 100644
> index 0000000..9d87a05
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_acct.c
> @@ -0,0 +1,117 @@
> +/* Accouting handling for netfilter. */
> +
> +/*
> + * (C) 2008 Krzysztof Piotr Oledzki <ole@ans.pl>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/netfilter.h>
> +#include <linux/kernel.h>
> +#include <linux/moduleparam.h>
> +
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_extend.h>
> +#include <net/netfilter/nf_conntrack_acct.h>
> +
> +#ifdef CONFIG_NF_CT_ACCT
> +#define NF_CT_ACCT_DEFAULT 1
> +#else
> +#define NF_CT_ACCT_DEFAULT 0
> +#endif
> +
> +static unsigned int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;

Perhaps this should be bool instead?

> +
> +module_param_named(acct, nf_ct_acct, bool, 0644);
> +MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
> +
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table_header *acct_sysctl_header;
> +static struct ctl_table acct_sysctl_table[] = {
> +	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "nf_conntrack_acct",
> +		.data		= &nf_ct_acct,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +	{}
> +};
> +#endif /* CONFIG_SYSCTL */
> +
> +struct ip_conntrack_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
> +{
> +	struct ip_conntrack_counter *acct;
> +
> +	if (!nf_ct_acct)
> +		return NULL;
> +
> +	acct = nf_ct_ext_add(ct, NF_CT_EXT_ACCT, gfp);
> +	if (!acct)
> +		pr_debug("failed to add accounting extension area");
> +
> +	return acct;
> +};

Missing EXPORT_SYMBOL_GPL for ctnetlink:

ERROR: "nf_ct_acct_ext_add" [net/netfilter/nf_conntrack_netlink.ko] 
undefined!

Perhaps this should be inlined or at least the nf_ct_acct
check so we can avoid the unnecessary function call for
disabled accounting?

> +
> +unsigned int
> +seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
> +{
> +	struct ip_conntrack_counter *acct;
> +
> +	acct = nf_conn_acct_find(ct);
> +	if (!acct)
> +		return 0;
> +
> +	return seq_printf(s, "packets=%llu bytes=%llu ",
> +			  (unsigned long long)acct[dir].packets,
> +			  (unsigned long long)acct[dir].bytes);
> +};
> +EXPORT_SYMBOL_GPL(seq_print_acct);
> +
> +static struct nf_ct_ext_type acct_extend __read_mostly = {
> +	.len	= sizeof(struct ip_conntrack_counter[IP_CT_DIR_MAX]),
> +	.align	= __alignof__(struct ip_conntrack_counter[IP_CT_DIR_MAX]),
> +	.id	= NF_CT_EXT_ACCT,
> +};
> +
> +int nf_conntrack_acct_init(void)
> +{
> +	int ret;
> +
> +#ifdef CONFIG_NF_CT_ACCT
> +	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use\n");
> +	printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or\n");
> +	printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");

Since sysctls are deprecated (or are they still?), better to just
mention the kernel and module options.

> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ab655f6..165e7f3 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -229,9 +234,6 @@ ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
>  nla_put_failure:
>  	return -1;
>  }
> -#else
> -#define ctnetlink_dump_counters(a, b, c) (0)
> -#endif
>  
>  #ifdef CONFIG_NF_CONNTRACK_MARK
>  static inline int
> @@ -389,8 +391,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
>  
>  	if (ctnetlink_dump_status(skb, ct) < 0 ||
>  	    ctnetlink_dump_timeout(skb, ct) < 0 ||
> -	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
> -	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
> +	    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
> +	    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_REPLY) < 0 ||

This rename seems pointless. I also like the old name better.
