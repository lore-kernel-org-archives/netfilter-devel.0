From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [RFC] netfilter: add xt_skbuff xtables match
Date: Sat, 8 Dec 2012 04:23:51 +0100
Message-ID: <20121208032351.GA28114@1984>
References: <1354735339-13402-2-git-send-email-willemb@google.com>
 <1354925044-15135-1-git-send-email-willemb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab2LHDXz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Dec 2012 22:23:55 -0500
Content-Disposition: inline
In-Reply-To: <1354925044-15135-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 07, 2012 at 07:04:04PM -0500, Willem de Bruijn wrote:
> Add an iptables match based on skb fields, such as mark, priority,
> input interface and rxhash. The match supports range based matching
> on one field, with optional inversion and masking.
> 
> v2: switches from xt_priority to xt_skbuff. Pablo, is this what
> you had in mind? It doesn't perfectly duplicate the values from
> nftables xt_meta. Needs more testing to cover the field-specific
> codepaths.

Yes, I think this is the good direction for it.

> Tested by inserting
> 
> iptables -t mangle -A PREROUTING -s $SRC -j MARK --set-mark 10
> iptables -A INPUT -m skbuff --min 10 --max 10 -j TRACE

Hm, you have to specify the field type in the iptables rule, right?i

> The userspace tool needs work, too. For one, I just hardcoded the
> field_id to be skb_field_mark for this test. That's why it's missing
> from the command line.

Please, once you're done with the user-space part, post it to the ML
in order to help testing this.

> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/linux/netfilter/xt_skbuff.h |   33 ++++++++
>  net/netfilter/Kconfig               |    9 ++
>  net/netfilter/Makefile              |    1 +
>  net/netfilter/xt_skbuff.c           |  141 +++++++++++++++++++++++++++++++++++
>  4 files changed, 184 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/netfilter/xt_skbuff.h
>  create mode 100644 net/netfilter/xt_skbuff.c
> 
> diff --git a/include/linux/netfilter/xt_skbuff.h b/include/linux/netfilter/xt_skbuff.h
> new file mode 100644
> index 0000000..10eb8d8
> --- /dev/null
> +++ b/include/linux/netfilter/xt_skbuff.h
> @@ -0,0 +1,33 @@
> +#ifndef _XT_SKBUFF_H
> +#define _XT_SKBUFF_H
> +
> +#include <linux/types.h>
> +
> +enum xt_skbuff_field_selector {

these enums in uppercase.

> +	skb_field_csum = 0,
> +	skb_field_hatype,
> +	skb_field_iif,
> +	skb_field_len,
> +	skb_field_mark,
> +	skb_field_pkt_type,
> +	skb_field_priority,
> +	skb_field_protocol,
> +	skb_field_queue_mapping,
> +	skb_field_rt_classid,
> +	skb_field_rxhash,
> +	skb_field_secmark,
> +	skb_field_sk_uid,
> +	skb_field_sk_gid,
> +	skb_field_tstamp,
> +	skb_field_vlan_tci,

Please, check if these all are worth to be exposed to user-space via
iptables.

> +};
> +
> +struct xt_skbuff_info {
> +	__u16 field_id;		/* an xt_skbuff_field_selector value */
> +	__u8  invert;
> +	__u64 min;
> +	__u64 max;
> +	__u64 mask;
> +};
> +
> +#endif /*_XT_SKBUFF_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index fefa514..3a07a86 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -1093,6 +1093,15 @@ config NETFILTER_XT_MATCH_PKTTYPE
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> +config NETFILTER_XT_MATCH_SKBUFF
> +	tristate '"skbuff" match support'
> +	depends on NETFILTER_ADVANCED
> +	help
> +	  This option adds a match based on the value of a chosen sk_buff
> +	  field.
> +
> +	  To compile it as a module, choose M here.  If unsure, say N.
> +
>  config NETFILTER_XT_MATCH_QUOTA
>  	tristate '"quota" match support'
>  	depends on NETFILTER_ADVANCED
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 3259697..9bc95e0 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -129,6 +129,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
> +obj-$(CONFIG_NETFILTER_XT_MATCH_SKBUFF) += xt_skbuff.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
>  obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
> diff --git a/net/netfilter/xt_skbuff.c b/net/netfilter/xt_skbuff.c
> new file mode 100644
> index 0000000..5ca30eb
> --- /dev/null
> +++ b/net/netfilter/xt_skbuff.c
> @@ -0,0 +1,141 @@
> +/* Xtables module to match packets based on sk_buff fields.
> + * Copyright 2012 Google Inc.
> + * Written by Willem de Bruijn <willemb@google.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <net/sock.h>
> +
> +#include <linux/netfilter/xt_skbuff.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +MODULE_AUTHOR("Willem de Bruijn <willemb@google.com>");
> +MODULE_DESCRIPTION("Xtables: skbuff match");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_priority");
> +MODULE_ALIAS("ip6t_priority");

you'll have to remove this aliasing support. There was not previous
priority match in mainstream.

> +static bool skbuff_mt(const struct sk_buff *skb,
> +			struct xt_action_param *par)
> +{
> +	const struct xt_skbuff_info *info = par->matchinfo;
> +	u64 value;
> +
> +	switch (info->field_id) {
> +	case skb_field_csum:
> +		if (skb->ip_summed != CHECKSUM_COMPLETE)
> +			return false;
> +		value = skb->csum;
> +		break;
> +	case skb_field_hatype:
> +		if (!skb->dev)
> +			return false;
> +		value = skb->dev->type;
> +		break;
> +	case skb_field_iif:
> +		value = skb->skb_iif;
> +		break;
> +	case skb_field_len:
> +		value = skb->len;
> +		break;
> +	case skb_field_mark:
> +		value = skb->mark;
> +		break;
> +	case skb_field_pkt_type:
> +		value = skb->pkt_type;
> +		break;
> +	case skb_field_priority:
> +		value = skb->priority;
> +		break;
> +	case skb_field_protocol:
> +		value = skb->protocol;
> +		break;
> +	case skb_field_queue_mapping:
> +		value = skb->queue_mapping;
> +		break;
> +	case skb_field_rt_classid:
> +#ifdef CONFIG_NET_CLS_ROUTE
> +		const struct dst_entry *dst;
> +
> +		rcu_read_lock();
> +		dst = skb_dst(skb);
> +		if (dst)
> +			value = dst->tclassid;
> +		rcu_read_unlock();
> +		if (!dst)
> +			return false;
> +		break;
> +#else
> +		return false;
> +#endif
> +	case skb_field_rxhash:
> +		value = skb->rxhash;
> +		break;
> +	case skb_field_secmark:
> +#ifdef CONFIG_NETWORK_SECMARK
> +		value = skb->secmark;
> +		break;
> +#else
> +		return false;
> +#endif
> +	case skb_field_sk_uid:
> +		if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
> +			return false;
> +		value = skb->sk->sk_socket->file->f_cred->fsuid;
> +		break;
> +	case skb_field_sk_gid:
> +		if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
> +			return false;
> +		value = skb->sk->sk_socket->file->f_cred->fsgid;
> +		break;
> +	case skb_field_tstamp:
> +		value = skb->tstamp.tv64;
> +		break;
> +	case skb_field_vlan_tci:
> +		value = skb->vlan_tci;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	value &= info->mask;
> +	return (value >= info->min && value <= info->max) ^ info->invert;
> +}
> +
> +static int skbuff_mt_check(const struct xt_mtchk_param *par)
> +{
> +	const struct xt_skbuff_info *info = par->matchinfo;
> +
> +	if (info->field_id > skb_field_vlan_tci)

Better define SKB_FIELD_MAX ?

> +		return -EINVAL;

probably -EOPNOTSUPP is better in case we add some new skbuff field
that we support.

> +
> +	return 0;
> +}
> +
> +static struct xt_match skbuff_mt_reg __read_mostly = {
> +	.name		= "skbuff",
> +	.revision	= 0,
> +	.family		= NFPROTO_UNSPEC,
> +	.match		= skbuff_mt,
> +	.matchsize	= sizeof(struct xt_skbuff_info),
> +	.checkentry	= skbuff_mt_check,
> +	.me		= THIS_MODULE,
> +};
> +
> +static int __init skbuff_mt_init(void)
> +{
> +	return xt_register_match(&skbuff_mt_reg);
> +}
> +
> +static void __exit skbuff_mt_exit(void)
> +{
> +	xt_unregister_match(&skbuff_mt_reg);
> +}
> +
> +module_init(skbuff_mt_init);
> +module_exit(skbuff_mt_exit);
> -- 
> 1.7.7.3
> 
