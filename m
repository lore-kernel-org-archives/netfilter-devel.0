From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/13] iptables TPROXY target
Date: Mon, 01 Oct 2007 00:43:59 +0200
Message-ID: <470026AF.5060404@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205335.10969.91031.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49457 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXI3Wrk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:47:40 -0400
In-Reply-To: <20070930205335.10969.91031.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> The TPROXY target implements redirection of non-local TCP/UDP traffic to local
> sockets. Additionally, it's possible to manipulate the packet mark if and only
> if a socket has been found. (We need this because we cannot use multiple
> targets in the same iptables rule.)
>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
> ---
> +++ b/include/linux/netfilter_ipv4/ipt_TPROXY.h
> @@ -0,0 +1,14 @@
> +#ifndef _IPT_TPROXY_H_target
> +#define _IPT_TPROXY_H_target
> +
> +/* TPROXY target is capable of marking the packet to perform
> + * redirection. We can get rid of that whenever we get support for
> + * mutliple targets in the same rule. */
> +struct ipt_tproxy_target_info {
> +	__be32 laddr;
> +	__be16 lport;
> +	unsigned long mark_mask;
> +	unsigned long mark_value;
>   

This should use fixed size types.

> diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> new file mode 100644
> index 0000000..8603421
> --- /dev/null
> +++ b/net/netfilter/xt_TPROXY.c
> @@ -0,0 +1,139 @@
> +/*
> + * Transparent proxy support for Linux/iptables
> + *
> + * Copyright (c) 2006-2007 BalaBit IT Ltd.
> + * Author: Balazs Scheidler, Krisztian Kovacs
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/ip.h>
> +#include <net/checksum.h>
> +#include <net/udp.h>
> +#include <net/inet_sock.h>
> +
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter_ipv4/ipt_TPROXY.h>
> +
> +#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
> +#include <net/netfilter/nf_tproxy_core.h>
> +
> +static unsigned int
> +target(struct sk_buff **pskb,
> +       const struct net_device *in,
> +       const struct net_device *out,
> +       unsigned int hooknum,
> +       const struct xt_target *target,
> +       const void *targinfo)
> +{
> +	const struct iphdr *iph = ip_hdr(*pskb);
> +	const struct ipt_tproxy_target_info *tgi =
> +		(const struct ipt_tproxy_target_info *) targinfo;
> +	struct sk_buff *skb = *pskb;
> +	struct udphdr _hdr, *hp;
> +	struct sock *sk;
> +
> +	/* TCP/UDP only */
> +	if ((iph->protocol != IPPROTO_TCP) &&
> +	    (iph->protocol != IPPROTO_UDP))
> +		return NF_ACCEPT;
> +
> +	hp = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_hdr), &_hdr);
> +	if (hp == NULL)
> +		return NF_DROP;
> +
> +	sk = nf_tproxy_get_sock_v4(iph->protocol,
> +				   iph->saddr, tgi->laddr ? tgi->laddr : iph->daddr,
> +				   hp->source, tgi->lport ? tgi->lport : hp->dest,
> +				   in, true);
>   
> +
> +	/* NOTE: assign_sock consumes our sk reference */
> +	if (sk && nf_tproxy_assign_sock(skb, sk)) {
> +		/* This should be in a separate target, but we don't do multiple
> +		   targets on the same rule yet */
> +		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
> +
> +		pr_debug("redirecting: proto %d %08x:%d -> %08x:%d, mark: %x\n",
> +			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
> +			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
> +		return NF_ACCEPT;
> +	}
> +	else {
> +		pr_debug("no socket, dropping: proto %d %08x:%d -> %08x:%d, mark: %x\n",
> +			 iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
> +			 ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
> +		return NF_DROP;
> +	}
> +}
> +
> +#ifdef CONFIG_COMPAT

All this compat stuff becomes unnecessary with fixed size types.

