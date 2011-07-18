From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 18:21:04 +0200
Message-ID: <4E245D70.4030907@trash.net>
References: <87sjqqawmk.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46829 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1GRQVI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:21:08 -0400
In-Reply-To: <87sjqqawmk.fsf@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.07.2011 16:44, Rainer Weikusat wrote:
> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> 
> Presently, the nfnetlink_log.c file contains only very nominal support
> for network namespaces: While it is possible to create sockets which
> should theoretically receive NFLOG originated messages in arbitrary
> network namespaces, there is only one table of nfulnl_instance
> structures in the kernel and all log messages sent via __nfulnl_send
> are forced into the init_net namespace so that only sockets created
> in this namespace will ever actually receive log data. Likewise, the
> nfulnl_rcv_nl_event notification callback won't destroy logging
> instances created by processes in other network namespace upon process
> death. The patch included below changes the code to use a logging
> instance table per network namespace, to send messages generated from
> within a specific namespace to sockets also belonging to this
> namespace and to destroy logging instances created from other network
> namespaces than init_net when cleaning up after a logging process
> terminated. It doesn't touch the code dealing with nfnetlink_log /proc
> files which thus remain restricted to the init_net namespace because
> this isn't really needed in order to get per-namespace logging and
> would require changes to other files, in particular, nf_log.c
> 
> Signed-Off-By: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> ---
> This is a feature needed for the main product of my present employer
> and the patch is published here in the hope that it is more generally
> useful as well. A more thorough change of the logging infrastructure
> is unforunately way beyond the amount of time I'm allowed to spend on
> this.
> 
> diff -prNu nf-2.6/net/netfilter/nfnetlink_log.c nf-2.6.patched//net/netfilter/nfnetlink_log.c
> --- nf-2.6/net/netfilter/nfnetlink_log.c	2011-07-01 14:08:21.833369919 +0100
> +++ nf-2.6.patched//net/netfilter/nfnetlink_log.c	2011-07-01 14:57:01.277536330 +0100
> @@ -39,6 +39,12 @@
>  #include "../bridge/br_private.h"
>  #endif
>  
> +#ifdef CONFIG_NET_NS
> +#define NET_NS 1
> +#include <net/net_namespace.h>
> +#include <net/netns/generic.h>
> +#endif
> +
>  #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
>  #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
>  #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
> @@ -47,6 +53,18 @@
>  #define PRINTR(x, args...)	do { if (net_ratelimit()) \
>  				     printk(x, ## args); } while (0);
>  
> +#define INSTANCE_BUCKETS	16
> +
> +struct nfulnl_instances {
> +	spinlock_t lock;
> +	atomic_t global_seq;
> +	struct hlist_head table[INSTANCE_BUCKETS];
> +	unsigned hash_init;
> +#ifdef NET_NS
> +	struct net *net;
> +#endif
> +};
> +
>  struct nfulnl_instance {
>  	struct hlist_node hlist;	/* global list of instances */
>  	spinlock_t lock;
> @@ -67,14 +85,92 @@ struct nfulnl_instance {
>  	u_int16_t flags;
>  	u_int8_t copy_mode;
>  	struct rcu_head rcu;
> +#ifdef NET_NS
> +	struct nfulnl_instances *instances;
> +#endif

This seems odd, the usual way is to add the global data to the
net-ns structure.

> +#ifndef NET_NS
> +static struct nfulnl_instances instances;
>  
> -#define INSTANCE_BUCKETS	16
> -static struct hlist_head instance_table[INSTANCE_BUCKETS];
> -static unsigned int hash_init;
> +static inline struct nfulnl_instances *
> +instances_via_inst(struct nfulnl_instance *inst)
> +{
> +	(void)inst;
> +	return &instances;
> +}

... then you don't need all this because it will automatically
use the structures from init_net when CONFIG_NET_NS=n. Basically
everything depending on CONFIG_NET_NS is wrong, this is handled
automatically if you're using the API the proper way. A simple
example would be nfnetlink.c.
