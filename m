From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Implement connection tracking event over netlink unicast
Date: Mon, 25 Feb 2008 14:02:33 +0100
Message-ID: <47C2BC69.4070609@trash.net>
References: <47BF22E2.1010204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:10662 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYBYNCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:02:42 -0500
In-Reply-To: <47BF22E2.1010204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Hi,
> 
> Time ago I came up with the idea of adding a new target which marks
> events as volatile to explicitly tell ctnetlink not to deliver events
> over netlink for the traffic that matches the rule.
> 
> Although this approach is simple, it has serious limitations. For
> example, in a ulogd + conntrackd setup the user may want to log all the
> traffic but only replicate certain connections to the backup node. Also,
> the conntrackd user may want to replicate only ESTABLISHED states
> instead of all states to reduce resource consumption in a busy firewall
> but log only the destroy messages coming from ctnetlink for accounting
> purposes. In both cases, this target would not help.
> 
> For that reason, I decided to start a patch which implements connection
> tracking event delivery over netlink unicast in a similar fashion as
> other netfilter subsystems such as log and queue.
> 
> Attached a RFC patch (yet untested with no IPv6 support and no userspace
> part) that implements connection tracking event delivery over netlink
> unicast. This patch introduces the NFCONNTRACK target which is similar
> to NFQUEUE and NFLOG. An example of usage is:
> 
> iptables -I POSTROUTING -t events -m state ESTABLISHED -j NFCONNTRACK
> --queue-num 1
> 
> With this rule, only the ESTABLISHED connection tracking events are
> delivered over netlink unicast to the userspace program listening in the
> queue number 1. This enables events filtering through iptables, so that
> a user can tell what events are propagated to userspace. This approach
> removes the limitation of my initial idea since we can do specific
> filtering for ulogd and conntrackd, both listeing in different queue
> numbers, without disturbing each other.

Makes sense.

> This patch introduces several important changes:
> 
> * A new table, so-called 'events', which is placed at the end of
> postrouting once the connection tracking has successfully confirmed a
> conntrack entry to avoid event delivery of possibly dropped packets in
> the 'filter' table. In practise, this table is only loaded as module
> when the user wants to perform event filtering so that it does not
> introduce any overhead for users that do not need this feature.

I hate new tables :) Its a bit sad that we need this, its not exactly
consistent that NOTRACK works in the raw table and this in the events
table.

Will there also be a new match to filter on connection state?
Using ESTABLISHED is pretty useless since in the events table
all connections will be ESTABLISHED.

> * A new target, so-called NFCONNTRACK, which can only be inserted in the
> events table.
> 
> * An extra hook which is only present if connection tracking event
> delivery is enabled.
> 
> In terms of hooks, the changes are the following:
> 
>         NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
>         NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
>         NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,
>         NF_IP_PRI_LAST = INT_MAX,
> 
> The 'events' table is placed after the conntrack confirmation, and the
> final event delivery through the ecache infrastructure is placed at the
> end. If we schedule for removal events delivery over netlink broadcast
> we can get rid of NF_IP_PRI_CONNTRACK_EVENTS hook, however, this would
> break backward anyway. Another choice to remove this hook can be to
> recover the idea of the per-skbuff event cache, however, this means 4
> bytes extra per skbuff.
> 
> Another argument in favor of this patch is that it homogenize the
> netfilter subsystem so that they all require a target to enable netlink
> features.

I don't think we should remove broadcast event delivery. QUEUE and LOG
are different from conntrack in the sense that conntrack really does
react to internal events, which are non-existant for QUEUE and LOG.

> Comments welcome.

A general comment: it would make this easier to review if you'd
split it up more fine-grained, for example:

- 1: conntrack event delivery changes
- 2: conntrack unicast event delivery
- 3: event table
- 4: NFCONNTRACK target

Some implementation-specific comments below:

>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> ...

This stuff shouldn't depend on conntrack-events in my opinion.
Conntrack-events should merely control whether the event cache
and similar stuff is included in nf_conntrack, without which
the ctnetlink event delivery does not work, but the manual
unicast delivery should work regardless, right?

OK I see below that it needs the event cache, still it would
be nice to have this working without the notifications from
conntrack.

> +
> +static HLIST_HEAD(equeue_list);

Are you sure you don't want a small hash table for this?

> +static DEFINE_SPINLOCK(equeue_lock);
> +
> +struct nfct_equeue {
> +	struct hlist_node hlist;
> +	struct rcu_head rcu;
> +
> +	int queue_num;

unsigned or u16 would make more sense.

> +	int peer_pid;
> +};
> +
> +static struct nfct_equeue *ctnetlink_lookup_equeue(int queue_num)
> +{
> +	struct hlist_node *pos;
> +	struct nfct_equeue *this;
> +
> +	hlist_for_each_entry_rcu(this, pos, &equeue_list, hlist) {
> +		if (this->queue_num == queue_num)
> +			return this;
> +	}
> +	return NULL;
> +}
> +
> +static int ctnetlink_create_equeue(u_int16_t queue_num, int pid)

netlink uses u32 for the pids, this should too for consistency.

> +static void ctnetlink_destroy_equeue(u_int16_t queue_num, int pid)
> +{
> +	struct nfct_equeue *equeue;
> +
> +	spin_lock(&equeue_lock);
> +
> +	equeue = ctnetlink_lookup_equeue(queue_num);
> +	BUG_ON(equeue == NULL);

This is wrong, we shouldn't crash just because userspace specified
an invalid queue number.

> +
> +	__ctnetlink_destroy_equeue(equeue);
> +
> +	spin_unlock(&equeue_lock);
> +}
> +
> +static const struct nla_policy ct_events_nla_policy[CTA_UEVENT_MAX+1] = {
> +	[CTA_UEVENT_CFG_BIND] 	= { .type = NLA_U16 },
> +	[CTA_UEVENT_CFG_UNBIND] = { .type = NLA_U16 },
> +};
> +
> +static int
> +ctnetlink_uevents_conntrack(struct sock *ctnl, struct sk_buff *skb,
> +			    struct nlmsghdr *nlh, struct nlattr *cda[])
> +{
> +	int ret;
> +
> +	if (cda[CTA_UEVENT_CFG_BIND]) {
> +		u_int16_t queue_num = nla_get_be16(cda[CTA_UEVENT_CFG_BIND]);
> +
> +		ret = ctnetlink_create_equeue(queue_num, NETLINK_CB(skb).pid);
> +		if (ret < 0)
> +			return ret;

This will return -ENOTSUPP below in case no error occured.

> +	}
> +	if (cda[CTA_UEVENT_CFG_UNBIND]) {
> +		u_int16_t queue_num = nla_get_be16(cda[CTA_UEVENT_CFG_UNBIND]);
> +
> +		ctnetlink_destroy_equeue(queue_num, NETLINK_CB(skb).pid);
> +		return 0;
> +	}
> +
> +	return -ENOTSUPP;
> +}
> +
> +static int
> +ctnetlink_nl_event(struct notifier_block *this, unsigned long event, void *ptr)
> +{
> +	struct nfct_equeue *equeue;
> +	struct hlist_node *tmp, *tmp2;
> +	struct netlink_notify *n = ptr;
> +
> +	if (event != NETLINK_URELEASE ||
> +	    n->protocol != NETLINK_NETFILTER || !n->pid)
> +	    	return NOTIFY_DONE;
> +
> +	spin_lock(&equeue_lock);
> +	hlist_for_each_entry_safe(equeue, tmp, tmp2, &equeue_list, hlist) {
> +		if ((n->net == &init_net) && (n->pid == equeue->peer_pid)) {
> +		    	__ctnetlink_destroy_equeue(equeue);
> +		}

No unnecessary parens please (both the conditions and the expression).

> +	}
> +	spin_unlock(&equeue_lock);
> +
> +	return NOTIFY_DONE;
> +}

> +int nf_ct_send_uevent(const struct nf_conn *ct, int queue_num)
> +{
> +	struct sk_buff *skb;
> +	struct nfct_equeue *equeue;
> +	unsigned int group;
> +	unsigned int events;
> +
> +	equeue = ctnetlink_lookup_equeue(queue_num);
> +	if (!equeue)
> +		return -1;
> +
> +	if (!nf_ct_get_current_events(ct, &events))
> +		return -1;

I don't think this will work. nf_ct_get_current_events does a lookup
in the event cache, which assumes we're still running on the same
CPU, which is not necessarily true.

> +
> +	skb = ctnetlink_build_event_msg(ct, events, &group);
> +	if (!skb)
> +		return -1;
> +
> +	return nfnetlink_unicast(skb, equeue->peer_pid, MSG_DONTWAIT);
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_send_uevent);


> Index: net-2.6.git/net/netfilter/xt_NFCONNTRACK.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ net-2.6.git/net/netfilter/xt_NFCONNTRACK.c	2008-02-22 19:33:35.000000000 +0100
> @@ -0,0 +1,75 @@
> +/* iptables module for using new netfilter netlink conntrack unicast events
> + *
> + * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_NFCONNTRACK.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <linux/netfilter/nfnetlink_conntrack.h>
> +
> +MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
> +MODULE_DESCRIPTION("[ip,ip6]_tables NFCONNTRACK target");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_NFCONNTRACK");
> +MODULE_ALIAS("ip6t_NFCONNTRACK");


Not directly related, but this alias stuff sucks. We should probe
the x_tables modules and only use aliases for compatibility with
old scripts doing manual module loading.

> +static unsigned int
> +nfct_tg(struct sk_buff *skb, const struct net_device *in,
> +	const struct net_device *out, unsigned int hooknum,
> +	const struct xt_target *target, const void *targinfo)
> +{
> +	const struct xt_NFCT_info *tinfo = targinfo;
> +	const struct nf_conn *ct;
> +	enum ip_conntrack_info ctinfo;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct)
> +		return XT_CONTINUE;
> +
> +	/* ignore our fake conntrack entry */
> +	if (ct == &nf_conntrack_untracked)
> +		return XT_CONTINUE;
> +
> +	return nf_ct_send_uevent(ct, tinfo->queuenum);
> +}
> +
> +static struct xt_target nfct_tg_reg[] __read_mostly = {
> +	{
> +		.name		= "NFCONNTRACK",
> +		.family		= AF_INET,
> +		.target		= nfct_tg,
> +		.targetsize	= sizeof(struct xt_NFCT_info),
> +		.table		= "events",
> +		.me		= THIS_MODULE,
> +	},
> +	{
> +		.name		= "NFCONNTRACK",
> +		.family		= AF_INET6,
> +		.target		= nfct_tg,
> +		.targetsize	= sizeof(struct xt_NFCT_info),
> +		.table		= "events",
> +		.me		= THIS_MODULE,
> +	},
> +};
> +
> +static int __init nfct_tg_init(void)
> +{
> +	return xt_register_targets(nfct_tg_reg, ARRAY_SIZE(nfct_tg_reg));
> +}
> +
> +static void __exit nfct_tg_exit(void)
> +{
> +	xt_unregister_targets(nfct_tg_reg, ARRAY_SIZE(nfct_tg_reg));
> +}
> +
> +module_init(nfct_tg_init);
> +module_exit(nfct_tg_exit);
> Index: net-2.6.git/include/linux/netfilter_ipv4.h
> ===================================================================
> --- net-2.6.git.orig/include/linux/netfilter_ipv4.h	2008-02-22 18:51:48.000000000 +0100
> +++ net-2.6.git/include/linux/netfilter_ipv4.h	2008-02-22 18:53:39.000000000 +0100
> @@ -62,9 +62,11 @@ enum nf_ip_hook_priorities {
>  	NF_IP_PRI_FILTER = 0,
>  	NF_IP_PRI_NAT_SRC = 100,
>  	NF_IP_PRI_SELINUX_LAST = 225,
> -	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
> -	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
> -	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
> +	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 4,
> +	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 3,
> +	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX - 2,
> +	NF_IP_PRI_EVENTS_TABLE = INT_MAX - 1,
> +	NF_IP_PRI_CONNTRACK_EVENTS = INT_MAX,

Why do you need the CONNTRACK_EVENTS hook exactly?
