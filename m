From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 13:41:22 +0100
Message-ID: <20111214124122.GA2749@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
 <1323861408.2334.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44548 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1LNMl3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:41:29 -0500
Content-Disposition: inline
In-Reply-To: <1323861408.2334.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 12:16:48PM +0100, Eric Dumazet wrote:
> Le mercredi 14 d=E9cembre 2011 =E0 12:00 +0100, pablo@netfilter.org a
> =E9crit :
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> >=20
> > We currently have two ways to account traffic in netfilter:
> >=20
> > - iptables chain and rule counters:
> >=20
> >  # iptables -L -n -v
> > Chain INPUT (policy DROP 3 packets, 867 bytes)
> >  pkts bytes target     prot opt in     out     source              =
 destination
> >     8  1104 ACCEPT     all  --  lo     *       0.0.0.0/0           =
 0.0.0.0/0
> >=20
> > - use flow-based accounting provided by ctnetlink:
> >=20
> >  # conntrack -L
> > tcp      6 431999 ESTABLISHED src=3D192.168.1.130 dst=3D212.106.219=
=2E168 sport=3D58152 dport=3D80 packets=3D47 bytes=3D7654 src=3D212.106=
=2E219.168 dst=3D192.168.1.130 sport=3D80 dport=3D58152 packets=3D49 by=
tes=3D66340 [ASSURED] mark=3D0 use=3D1
> >=20
> > While trying to display real-time accounting statistics, we require
> > to pool the kernel periodically to obtain this information. This is
> > OK if the number of flows is relatively low. However, in case that
> > the number of flows is huge, we can spend a considerable amount of
> > cycles to iterate over the list of flows that have been obtained.
> >=20
> > Moreover, if we want to obtain the sum of the flow accounting resul=
ts
> > that match some criteria, we have to iterate over the whole list of
> > existing flows, look for matchings and update the counters.
> >=20
> > This patch adds the extended accounting infrastructure for
> > nfnetlink which aims to allow displaying real-time traffic accounti=
ng
> > without the need of complicated and resource-consuming implementati=
on
> > in user-space. Basically, this new infrastructure allows you to cre=
ate
> > accounting objects. One accounting object is composed of packet and
> > byte counters.
> >=20
> > In order to manipulate create accounting objects, you require the
> > new libnetfilter_acct library. It contains several examples of use:
> >=20
> > libnetfilter_acct/examples# ./nfacct-add http-traffic
> > libnetfilter_acct/examples# ./nfacct-get
> > http-traffic =3D { pkts =3D 000000000000,   bytes =3D 000000000000 =
};
> >=20
> > Then, you can use one of this accounting objects in several iptable=
s
> > rules using the new NFACCT target (which comes in a follow-up patch=
):
> >=20
> >  # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http=
-traffic
> >  # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name htt=
p-traffic
> >=20
> > The idea is simple: if one packet matches the rule, the NFACCT targ=
et
> > updates the counters.
> >=20
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/linux/netfilter/Kbuild           |    1 +
> >  include/linux/netfilter/nfnetlink.h      |    3 +-
> >  include/linux/netfilter/nfnetlink_acct.h |   34 +++
> >  net/netfilter/Kconfig                    |    8 +
> >  net/netfilter/Makefile                   |    1 +
> >  net/netfilter/nfnetlink_acct.c           |  352 ++++++++++++++++++=
++++++++++++
> >  6 files changed, 398 insertions(+), 1 deletions(-)
> >  create mode 100644 include/linux/netfilter/nfnetlink_acct.h
> >  create mode 100644 net/netfilter/nfnetlink_acct.c
> >=20
> > diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilt=
er/Kbuild
> > index a1b410c..8995867 100644
> > --- a/include/linux/netfilter/Kbuild
> > +++ b/include/linux/netfilter/Kbuild
> > @@ -6,6 +6,7 @@ header-y +=3D nf_conntrack_sctp.h
> >  header-y +=3D nf_conntrack_tcp.h
> >  header-y +=3D nf_conntrack_tuple_common.h
> >  header-y +=3D nfnetlink.h
> > +header-y +=3D nfnetlink_acct.h
> >  header-y +=3D nfnetlink_compat.h
> >  header-y +=3D nfnetlink_conntrack.h
> >  header-y +=3D nfnetlink_log.h
> > diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/ne=
tfilter/nfnetlink.h
> > index 74d3386..b64454c 100644
> > --- a/include/linux/netfilter/nfnetlink.h
> > +++ b/include/linux/netfilter/nfnetlink.h
> > @@ -48,7 +48,8 @@ struct nfgenmsg {
> >  #define NFNL_SUBSYS_ULOG		4
> >  #define NFNL_SUBSYS_OSF			5
> >  #define NFNL_SUBSYS_IPSET		6
> > -#define NFNL_SUBSYS_COUNT		7
> > +#define NFNL_SUBSYS_ACCT		7
> > +#define NFNL_SUBSYS_COUNT		8
> > =20
> >  #ifdef __KERNEL__
> > =20
> > diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/lin=
ux/netfilter/nfnetlink_acct.h
> > new file mode 100644
> > index 0000000..9a1a119
> > --- /dev/null
> > +++ b/include/linux/netfilter/nfnetlink_acct.h
> > @@ -0,0 +1,34 @@
> > +#ifndef _NFNL_ACCT_H_
> > +#define _NFNL_ACCT_H_
> > +#include <linux/netfilter/nfnetlink.h>
> > +
> > +#define NFACCT_NAME_MAX		64
> > +
> > +enum nfnl_acct_msg_types {
> > +	NFNL_MSG_ACCT_NEW,
> > +	NFNL_MSG_ACCT_GET,
> > +	NFNL_MSG_ACCT_GET_CTRZERO,
> > +	NFNL_MSG_ACCT_DEL,
> > +	NFNL_MSG_ACCT_MAX
> > +};
> > +
> > +enum nfnl_acct_type {
> > +	NFACCT_UNSPEC,
> > +	NFACCT_NAME,
> > +	NFACCT_PKTS,
> > +	NFACCT_BYTES,
> > +	__NFACCT_MAX
> > +};
> > +#define NFACCT_MAX (__NFACCT_MAX - 1)
> > +
> > +#ifdef __KERNEL__
> > +
> > +struct nf_acct;
> > +
> > +extern struct nf_acct *nfnl_acct_find_get(const char *filter_name)=
;
> > +extern void nfnl_acct_put(struct nf_acct *acct);
> > +extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_=
acct *nfacct);
> > +
> > +#endif /* __KERNEL__ */
> > +
> > +#endif /* _NFNL_ACCT_H */
> > diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> > index d5597b7..77326ac 100644
> > --- a/net/netfilter/Kconfig
> > +++ b/net/netfilter/Kconfig
> > @@ -4,6 +4,14 @@ menu "Core Netfilter Configuration"
> >  config NETFILTER_NETLINK
> >  	tristate
> > =20
> > +config NETFILTER_NETLINK_ACCT
> > +tristate "Netfilter NFACCT over NFNETLINK interface"
> > +	depends on NETFILTER_ADVANCED
> > +	select NETFILTER_NETLINK
> > +	help
> > +	  If this option is enabled, the kernel will include support
> > +	  for extended accounting via NFNETLINK.
> > +
> >  config NETFILTER_NETLINK_QUEUE
> >  	tristate "Netfilter NFQUEUE over NFNETLINK interface"
> >  	depends on NETFILTER_ADVANCED
> > diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> > index 1a02853..4da1c87 100644
> > --- a/net/netfilter/Makefile
> > +++ b/net/netfilter/Makefile
> > @@ -7,6 +7,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) +=3D nf_=
conntrack_ecache.o
> >  obj-$(CONFIG_NETFILTER) =3D netfilter.o
> > =20
> >  obj-$(CONFIG_NETFILTER_NETLINK) +=3D nfnetlink.o
> > +obj-$(CONFIG_NETFILTER_NETLINK_ACCT) +=3D nfnetlink_acct.o
> >  obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) +=3D nfnetlink_queue.o
> >  obj-$(CONFIG_NETFILTER_NETLINK_LOG) +=3D nfnetlink_log.o
> > =20
> > diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetli=
nk_acct.c
> > new file mode 100644
> > index 0000000..3ec407f
> > --- /dev/null
> > +++ b/net/netfilter/nfnetlink_acct.c
> > @@ -0,0 +1,352 @@
> > +/*
> > + * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
> > + * (C) 2011 Intra2net AG <http://www.intra2net.com>
> > + *
> > + * This program is free software; you can redistribute it and/or m=
odify
> > + * it under the terms of the GNU General Public License version 2 =
as
> > + * published by the Free Software Foundation (or any later at your=
 option).
> > + */
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/skbuff.h>
> > +#include <linux/netlink.h>
> > +#include <linux/rculist.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/errno.h>
> > +#include <net/netlink.h>
> > +#include <net/sock.h>
> > +#include <asm/atomic.h>
> > +
> > +#include <linux/netfilter.h>
> > +#include <linux/netfilter/nfnetlink.h>
> > +#include <linux/netfilter/nfnetlink_acct.h>
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
> > +MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastr=
ucture");
> > +
> > +static LIST_HEAD(nfnl_acct_list);
> > +
> > +struct nf_acct {
> > +	struct rcu_head		rcu_head;
> > +	struct list_head	head;
> > +	spinlock_t		lock;	/* to update the counters. */
> > +	atomic_t		refcnt;
> > +
> > +	char			name[NFACCT_NAME_MAX];
> > +	__u64			pkts;
> > +	__u64			bytes;
>=20
> atomic64_t ?
>
> This would remove use of spinlock in fast path

Good idea :-).

Not related to this, but we can also replace this in the connection
tracking system.

> Also, you put lock and pkts,bytes in different cache lines :(

Sorry, I added the locking in a later stage while in the rush, I
completely missed this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
