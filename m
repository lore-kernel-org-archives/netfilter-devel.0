From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Date: Mon, 18 Jul 2011 22:19:56 +0300
Message-ID: <20110718191956.GA2489@p183.telecom.by>
References: <87sjqqawmk.fsf@sapphire.mobileactivedefense.com>
 <4E245D70.4030907@trash.net>
 <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44517 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1GRTUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:20:03 -0400
Content-Disposition: inline
In-Reply-To: <8739i3fp6s.fsf@sapphire.mobileactivedefense.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2011 at 06:56:11PM +0100, Rainer Weikusat wrote:
> Patrick McHardy <kaber@trash.net> writes:
> > On 01.07.2011 16:44, Rainer Weikusat wrote:
> >> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> >> 
> >> Presently, the nfnetlink_log.c file contains only very nominal support
> >> for network namespaces: While it is possible to create sockets which
> >> should theoretically receive NFLOG originated messages in arbitrary
> >> network namespaces, there is only one table of nfulnl_instance
> >> structures in the kernel and all log messages sent via __nfulnl_send
> >> are forced into the init_net namespace so that only sockets created
> >> in this namespace will ever actually receive log data.
> 
> [...]
> 
> >> +#define INSTANCE_BUCKETS	16
> >> +
> >> +struct nfulnl_instances {
> >> +	spinlock_t lock;
> >> +	atomic_t global_seq;
> >> +	struct hlist_head table[INSTANCE_BUCKETS];
> >> +	unsigned hash_init;
> >> +#ifdef NET_NS
> >> +	struct net *net;
> >> +#endif
> >> +};
> >> +
> >>  struct nfulnl_instance {
> >>  	struct hlist_node hlist;	/* global list of instances */
> >>  	spinlock_t lock;
> >> @@ -67,14 +85,92 @@ struct nfulnl_instance {
> >>  	u_int16_t flags;
> >>  	u_int8_t copy_mode;
> >>  	struct rcu_head rcu;
> >> +#ifdef NET_NS
> >> +	struct nfulnl_instances *instances;
> >> +#endif
> >
> > This seems odd, the usual way is to add the global data to the
> > net-ns structure.
> 
> Since a facility for having 'per subsystem' network namespace specific
> data exists, there seems to be little reason to not use it. The
> interface is defined in include/net/netns/generic.h and documented as
> 
>  * Generic net pointers are to be used by modules to put some private
>  * stuff on the struct net without explicit struct net modification
> 
> >> +#ifndef NET_NS
> >> +static struct nfulnl_instances instances;
> >>  
> >> -#define INSTANCE_BUCKETS	16
> >> -static struct hlist_head instance_table[INSTANCE_BUCKETS];
> >> -static unsigned int hash_init;
> >> +static inline struct nfulnl_instances *
> >> +instances_via_inst(struct nfulnl_instance *inst)
> >> +{
> >> +	(void)inst;
> >> +	return &instances;
> >> +}
> >
> > ... then you don't need all this because it will automatically
> > use the structures from init_net when CONFIG_NET_NS=n
> 
> But then, the more complicated access method via struct net will
> always be used while anything resembling network namespace support
> will be removed at compile-time if the kernel is configured without
> network namespace support for this code. Which happened to be the
> point of this exercise.
> 
> > Basically everything depending on CONFIG_NET_NS is wrong,
> > this is handled automatically if you're using the API the proper
> > way.
> 
> There is no such thing as 'an API which can be used in the proper way'
> here for the simple reason that not even functional documentation on
> this exists (AFAIK), let alone documentation about usage policies
> someone would like to mandate.

We did whole networking without sprinkling ifdefs and left them only at
few strategic places, now how did we manage to do it?
This functional doc argument, well, we aren't corporate IT shop
where it counts.

Briefly looking, there is no need for instances_via_skb(),
it's badly named and netns can be found at netlink control socket.

_instances struct is unnecessary.
