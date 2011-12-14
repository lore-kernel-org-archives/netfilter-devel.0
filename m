From: Anand Raj Manickam <anandrm@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 19:19:37 +0530
Message-ID: <CAEyr1FREjhK=Y-A89GLictxLtw+Z5jixrVDa8J0BqJ6b0h_GOQ@mail.gmail.com>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
	<1323860443-7129-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42733 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1LNNtj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 08:49:39 -0500
Received: by eaaj10 with SMTP id j10so759458eaa.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Dec 2011 05:49:38 -0800 (PST)
In-Reply-To: <1323860443-7129-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A clarification :
If its about flow based accounting , wont the below rules double the co=
unter ?
# iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name
http-traffic# iptables -I OUTPUT -p tcp --dport 80 -j NFACCT
--nfacct-name http-traffic







On Wed, Dec 14, 2011 at 4:30 PM,  <pablo@netfilter.org> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> We currently have two ways to account traffic in netfilter:
>
> - iptables chain and rule counters:
>
> =A0# iptables -L -n -v
> Chain INPUT (policy DROP 3 packets, 867 bytes)
> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 destination
> =A0 =A08 =A01104 ACCEPT =A0 =A0 all =A0-- =A0lo =A0 =A0 * =A0 =A0 =A0=
 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 =A00.0.0.0/0
>
> - use flow-based accounting provided by ctnetlink:
>
> =A0# conntrack -L
> tcp =A0 =A0 =A06 431999 ESTABLISHED src=3D192.168.1.130 dst=3D212.106=
=2E219.168 sport=3D58152 dport=3D80 packets=3D47 bytes=3D7654 src=3D212=
=2E106.219.168 dst=3D192.168.1.130 sport=3D80 dport=3D58152 packets=3D4=
9 bytes=3D66340 [ASSURED] mark=3D0 use=3D1
>
> While trying to display real-time accounting statistics, we require
> to pool the kernel periodically to obtain this information. This is
> OK if the number of flows is relatively low. However, in case that
> the number of flows is huge, we can spend a considerable amount of
> cycles to iterate over the list of flows that have been obtained.
>
> Moreover, if we want to obtain the sum of the flow accounting results
> that match some criteria, we have to iterate over the whole list of
> existing flows, look for matchings and update the counters.
>
> This patch adds the extended accounting infrastructure for
> nfnetlink which aims to allow displaying real-time traffic accounting
> without the need of complicated and resource-consuming implementation
> in user-space. Basically, this new infrastructure allows you to creat=
e
> accounting objects. One accounting object is composed of packet and
> byte counters.
>
> In order to manipulate create accounting objects, you require the
> new libnetfilter_acct library. It contains several examples of use:
>
> libnetfilter_acct/examples# ./nfacct-add http-traffic
> libnetfilter_acct/examples# ./nfacct-get
> http-traffic =3D { pkts =3D 000000000000, =A0 bytes =3D 000000000000 =
};
>
> Then, you can use one of this accounting objects in several iptables
> rules using the new NFACCT target (which comes in a follow-up patch):
>
> =A0# iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http=
-traffic
> =A0# iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name htt=
p-traffic
>
> The idea is simple: if one packet matches the rule, the NFACCT target
> updates the counters.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> =A0include/linux/netfilter/Kbuild =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
> =A0include/linux/netfilter/nfnetlink.h =A0 =A0 =A0| =A0 =A03 +-
> =A0include/linux/netfilter/nfnetlink_acct.h | =A0 34 +++
> =A0net/netfilter/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0=
 =A08 +
> =A0net/netfilter/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0=
1 +
> =A0net/netfilter/nfnetlink_acct.c =A0 =A0 =A0 =A0 =A0 | =A0352 ++++++=
++++++++++++++++++++++++
> =A06 files changed, 398 insertions(+), 1 deletions(-)
> =A0create mode 100644 include/linux/netfilter/nfnetlink_acct.h
> =A0create mode 100644 net/netfilter/nfnetlink_acct.c
>
> diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter=
/Kbuild
> index a1b410c..8995867 100644
> --- a/include/linux/netfilter/Kbuild
> +++ b/include/linux/netfilter/Kbuild
> @@ -6,6 +6,7 @@ header-y +=3D nf_conntrack_sctp.h
> =A0header-y +=3D nf_conntrack_tcp.h
> =A0header-y +=3D nf_conntrack_tuple_common.h
> =A0header-y +=3D nfnetlink.h
> +header-y +=3D nfnetlink_acct.h
> =A0header-y +=3D nfnetlink_compat.h
> =A0header-y +=3D nfnetlink_conntrack.h
> =A0header-y +=3D nfnetlink_log.h
> diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netf=
ilter/nfnetlink.h
> index 74d3386..b64454c 100644
> --- a/include/linux/netfilter/nfnetlink.h
> +++ b/include/linux/netfilter/nfnetlink.h
> @@ -48,7 +48,8 @@ struct nfgenmsg {
> =A0#define NFNL_SUBSYS_ULOG =A0 =A0 =A0 =A0 =A0 =A0 =A0 4
> =A0#define NFNL_SUBSYS_OSF =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A05
> =A0#define NFNL_SUBSYS_IPSET =A0 =A0 =A0 =A0 =A0 =A0 =A06
> -#define NFNL_SUBSYS_COUNT =A0 =A0 =A0 =A0 =A0 =A0 =A07
> +#define NFNL_SUBSYS_ACCT =A0 =A0 =A0 =A0 =A0 =A0 =A0 7
> +#define NFNL_SUBSYS_COUNT =A0 =A0 =A0 =A0 =A0 =A0 =A08
>
> =A0#ifdef __KERNEL__
>
> diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux=
/netfilter/nfnetlink_acct.h
> new file mode 100644
> index 0000000..9a1a119
> --- /dev/null
> +++ b/include/linux/netfilter/nfnetlink_acct.h
> @@ -0,0 +1,34 @@
> +#ifndef _NFNL_ACCT_H_
> +#define _NFNL_ACCT_H_
> +#include <linux/netfilter/nfnetlink.h>
> +
> +#define NFACCT_NAME_MAX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A064
> +
> +enum nfnl_acct_msg_types {
> + =A0 =A0 =A0 NFNL_MSG_ACCT_NEW,
> + =A0 =A0 =A0 NFNL_MSG_ACCT_GET,
> + =A0 =A0 =A0 NFNL_MSG_ACCT_GET_CTRZERO,
> + =A0 =A0 =A0 NFNL_MSG_ACCT_DEL,
> + =A0 =A0 =A0 NFNL_MSG_ACCT_MAX
> +};
> +
> +enum nfnl_acct_type {
> + =A0 =A0 =A0 NFACCT_UNSPEC,
> + =A0 =A0 =A0 NFACCT_NAME,
> + =A0 =A0 =A0 NFACCT_PKTS,
> + =A0 =A0 =A0 NFACCT_BYTES,
> + =A0 =A0 =A0 __NFACCT_MAX
> +};
> +#define NFACCT_MAX (__NFACCT_MAX - 1)
> +
> +#ifdef __KERNEL__
> +
> +struct nf_acct;
> +
> +extern struct nf_acct *nfnl_acct_find_get(const char *filter_name);
> +extern void nfnl_acct_put(struct nf_acct *acct);
> +extern void nfnl_acct_update(const struct sk_buff *skb, struct nf_ac=
ct *nfacct);
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* _NFNL_ACCT_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index d5597b7..77326ac 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -4,6 +4,14 @@ menu "Core Netfilter Configuration"
> =A0config NETFILTER_NETLINK
> =A0 =A0 =A0 =A0tristate
>
> +config NETFILTER_NETLINK_ACCT
> +tristate "Netfilter NFACCT over NFNETLINK interface"
> + =A0 =A0 =A0 depends on NETFILTER_ADVANCED
> + =A0 =A0 =A0 select NETFILTER_NETLINK
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 If this option is enabled, the kernel will include =
support
> + =A0 =A0 =A0 =A0 for extended accounting via NFNETLINK.
> +
> =A0config NETFILTER_NETLINK_QUEUE
> =A0 =A0 =A0 =A0tristate "Netfilter NFQUEUE over NFNETLINK interface"
> =A0 =A0 =A0 =A0depends on NETFILTER_ADVANCED
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 1a02853..4da1c87 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -7,6 +7,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) +=3D nf_co=
nntrack_ecache.o
> =A0obj-$(CONFIG_NETFILTER) =3D netfilter.o
>
> =A0obj-$(CONFIG_NETFILTER_NETLINK) +=3D nfnetlink.o
> +obj-$(CONFIG_NETFILTER_NETLINK_ACCT) +=3D nfnetlink_acct.o
> =A0obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) +=3D nfnetlink_queue.o
> =A0obj-$(CONFIG_NETFILTER_NETLINK_LOG) +=3D nfnetlink_log.o
>
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink=
_acct.c
> new file mode 100644
> index 0000000..3ec407f
> --- /dev/null
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -0,0 +1,352 @@
> +/*
> + * (C) 2011 Pablo Neira Ayuso <pablo@netfilter.org>
> + * (C) 2011 Intra2net AG <http://www.intra2net.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation (or any later at your o=
ption).
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/skbuff.h>
> +#include <linux/netlink.h>
> +#include <linux/rculist.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <net/netlink.h>
> +#include <net/sock.h>
> +#include <asm/atomic.h>
> +
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nfnetlink_acct.h>
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
> +MODULE_DESCRIPTION("nfacct: Extended Netfilter accounting infrastruc=
ture");
> +
> +static LIST_HEAD(nfnl_acct_list);
> +
> +struct nf_acct {
> + =A0 =A0 =A0 struct rcu_head =A0 =A0 =A0 =A0 rcu_head;
> + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0head;
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0lock; =A0 /* to u=
pdate the counters. */
> + =A0 =A0 =A0 atomic_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0refcnt;
> +
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0name[NFACCT=
_NAME_MAX];
> + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pkts;
> + =A0 =A0 =A0 __u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes;
> +};
> +
> +static void nfnl_acct_free_rcu(struct rcu_head *rcu_head)
> +{
> + =A0 =A0 =A0 struct nf_acct *acct =3D container_of(rcu_head, struct =
nf_acct, rcu_head);
> +
> + =A0 =A0 =A0 kfree(acct);
> +}
> +
> +static int
> +nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
> + =A0 =A0 =A0 =A0 =A0 =A0const struct nlmsghdr *nlh, const struct nla=
ttr * const tb[])
> +{
> + =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 struct nf_acct *acct, *matching =3D NULL;
> + =A0 =A0 =A0 char *acct_name;
> +
> + =A0 =A0 =A0 if (!tb[NFACCT_NAME])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 acct_name =3D nla_data(tb[NFACCT_NAME]);
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(acct, &nfnl_acct_list, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(acct->name, acct_name, NFAC=
CT_NAME_MAX) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nlh->nlmsg_flags & NLM_F_EXCL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rcu_read_unlock();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EEXIST;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 matching =3D acct;
> + =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 rcu_read_unlock();
> +
> + =A0 =A0 =A0 acct =3D kzalloc(sizeof(struct nf_acct), GFP_KERNEL);
> + =A0 =A0 =A0 if (acct =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_lock_init(&acct->lock);
> + =A0 =A0 =A0 strncpy(acct->name, nla_data(tb[NFACCT_NAME]), NFACCT_N=
AME_MAX);
> + =A0 =A0 =A0 if (tb[NFACCT_BYTES])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acct->bytes =3D be64_to_cpu(nla_get_u64=
(tb[NFACCT_BYTES]));
> + =A0 =A0 =A0 if (tb[NFACCT_PKTS])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acct->pkts =3D be64_to_cpu(nla_get_u64(=
tb[NFACCT_PKTS]));
> +
> + =A0 =A0 =A0 atomic_inc(&acct->refcnt);
> +
> + =A0 =A0 =A0 /* We are protected by nfnl mutex. */
> + =A0 =A0 =A0 if (matching) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_rcu(&matching->head);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_and_test(&matching->refc=
nt))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 call_rcu(&matching->rcu=
_head, nfnl_acct_free_rcu);
> +
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 list_add_tail_rcu(&acct->head, &nfnl_acct_list);
> + =A0 =A0 =A0 return 0;
> +err:
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int
> +nfnl_acct_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int event, struct nf_acct *acct)
> +{
> + =A0 =A0 =A0 struct nlmsghdr *nlh;
> + =A0 =A0 =A0 struct nfgenmsg *nfmsg;
> + =A0 =A0 =A0 unsigned int flags =3D pid ? NLM_F_MULTI : 0;
> +
> + =A0 =A0 =A0 event |=3D NFNL_SUBSYS_ACCT << 8;
> + =A0 =A0 =A0 nlh =3D nlmsg_put(skb, pid, seq, event, sizeof(*nfmsg),=
 flags);
> + =A0 =A0 =A0 if (nlh =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nlmsg_failure;
> +
> + =A0 =A0 =A0 nfmsg =3D nlmsg_data(nlh);
> + =A0 =A0 =A0 nfmsg->nfgen_family =3D AF_UNSPEC;
> + =A0 =A0 =A0 nfmsg->version =3D NFNETLINK_V0;
> + =A0 =A0 =A0 nfmsg->res_id =3D 0;
> +
> + =A0 =A0 =A0 NLA_PUT_STRING(skb, NFACCT_NAME, acct->name);
> + =A0 =A0 =A0 NLA_PUT_BE64(skb, NFACCT_PKTS, cpu_to_be64(acct->pkts))=
;
> + =A0 =A0 =A0 NLA_PUT_BE64(skb, NFACCT_BYTES, cpu_to_be64(acct->bytes=
));
> +
> + =A0 =A0 =A0 nlmsg_end(skb, nlh);
> + =A0 =A0 =A0 return skb->len;
> +
> +nlmsg_failure:
> +nla_put_failure:
> + =A0 =A0 =A0 nlmsg_cancel(skb, nlh);
> + =A0 =A0 =A0 return -1;
> +}
> +
> +static int
> +nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> + =A0 =A0 =A0 struct nf_acct *cur, *last;
> +
> + =A0 =A0 =A0 if (cb->args[2])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 last =3D (struct nf_acct *)cb->args[1];
> + =A0 =A0 =A0 if (cb->args[1])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb->args[1] =3D 0;
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_list, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (last && cur !=3D last)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nfnl_acct_fill_info(skb, NETLINK_CB=
(cb->skb).pid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cb->nlh->nlmsg_seq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0NFNL_MSG_ACCT_NEW, cur) < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb->args[1] =3D (unsign=
ed long)cur;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) =
=3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NFNL_MSG_ACCT_GET_CTRZERO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_bh(&cur->lock=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur->pkts =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur->bytes =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_bh(&cur->lo=
ck);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (!cb->args[1])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cb->args[2] =3D 1;
> + =A0 =A0 =A0 rcu_read_unlock();
> + =A0 =A0 =A0 return skb->len;
> +}
> +
> +static int
> +nfnl_acct_get(struct sock *nfnl, struct sk_buff *skb,
> + =A0 =A0 =A0 =A0 =A0 =A0const struct nlmsghdr *nlh, const struct nla=
ttr * const tb[])
> +{
> + =A0 =A0 =A0 int ret =3D 0;
> + =A0 =A0 =A0 struct nf_acct *cur;
> + =A0 =A0 =A0 char *acct_name;
> +
> + =A0 =A0 =A0 if (nlh->nlmsg_flags & NLM_F_DUMP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return netlink_dump_start(nfnl, skb, nl=
h, nfnl_acct_dump,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 NULL, 0);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (!tb[NFACCT_NAME])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 acct_name =3D nla_data(tb[NFACCT_NAME]);
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_list, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sk_buff *skb2;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(cur->name, acct_name, NFACC=
T_NAME_MAX)!=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skb2 =3D nlmsg_new(NLMSG_DEFAULT_SIZE, =
GFP_ATOMIC);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (skb2 =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D nfnl_acct_fill_info(skb2, NETLI=
NK_CB(skb).pid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0nlh->nlmsg_seq,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0NFNL_MSG_ACCT_NEW, cur);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret <=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree_skb(skb2);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (NFNL_MSG_TYPE(nlh->nlmsg_type) =3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NFNL_MSG_ACCT_GET_CTRZERO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_bh(&cur->lock=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur->pkts =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur->bytes =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_bh(&cur->lo=
ck);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rcu_read_unlock();
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int
> +nfnl_acct_del(struct sock *nfnl, struct sk_buff *skb,
> + =A0 =A0 =A0 =A0 =A0 =A0const struct nlmsghdr *nlh, const struct nla=
ttr * const tb[])
> +{
> + =A0 =A0 =A0 char *acct_name;
> + =A0 =A0 =A0 struct nf_acct *cur;
> + =A0 =A0 =A0 int ret =3D -ENOENT;
> +
> + =A0 =A0 =A0 if (!tb[NFACCT_NAME]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_lis=
t, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We are protected by =
nfnl mutex. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_rcu(&cur->head=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_and_test=
(&cur->refcnt))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 call_rc=
u(&cur->rcu_head, nfnl_acct_free_rcu);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 acct_name =3D nla_data(tb[NFACCT_NAME]);
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_list, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(cur->name, acct_name, NFACC=
T_NAME_MAX) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We are protected by nfnl mutex. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_rcu(&cur->head);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_and_test(&cur->refcnt))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 call_rcu(&cur->rcu_head=
, nfnl_acct_free_rcu);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] =3D {
> + =A0 =A0 =A0 [NFACCT_NAME] =3D { .type =3D NLA_NUL_STRING, .len =3D =
NFACCT_NAME_MAX-1 },
> + =A0 =A0 =A0 [NFACCT_BYTES] =3D { .type =3D NLA_U64 },
> + =A0 =A0 =A0 [NFACCT_PKTS] =3D { .type =3D NLA_U64 },
> +};
> +
> +static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] =3D=
 {
> + =A0 =A0 =A0 [NFNL_MSG_ACCT_NEW] =A0 =A0 =A0 =A0 =A0 =A0 =3D { .call=
 =3D nfnl_acct_new,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .attr_count =3D NFACCT_MAX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .policy =3D nfnl_acct_policy },
> + =A0 =A0 =A0 [NFNL_MSG_ACCT_GET] =A0 =A0 =A0 =A0 =A0 =A0 =3D { .call=
 =3D nfnl_acct_get,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .attr_count =3D NFACCT_MAX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .policy =3D nfnl_acct_policy },
> + =A0 =A0 =A0 [NFNL_MSG_ACCT_GET_CTRZERO] =A0 =A0 =3D { .call =3D nfn=
l_acct_get,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .attr_count =3D NFACCT_MAX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .policy =3D nfnl_acct_policy },
> + =A0 =A0 =A0 [NFNL_MSG_ACCT_DEL] =A0 =A0 =A0 =A0 =A0 =A0 =3D { .call=
 =3D nfnl_acct_del,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .attr_count =3D NFACCT_MAX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 .policy =3D nfnl_acct_policy },
> +};
> +
> +static const struct nfnetlink_subsystem nfnl_acct_subsys =3D {
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D "acct",
> + =A0 =A0 =A0 .subsys_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 NFNL_SUBSYS_ACCT,
> + =A0 =A0 =A0 .cb_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 NFNL_MSG_ACCT_MAX,
> + =A0 =A0 =A0 .cb =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =3D nfnl_acct_cb,
> +};
> +
> +MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
> +
> +struct nf_acct *nfnl_acct_find_get(const char *acct_name)
> +{
> + =A0 =A0 =A0 struct nf_acct *cur, *acct =3D NULL;
> +
> + =A0 =A0 =A0 rcu_read_lock();
> + =A0 =A0 =A0 list_for_each_entry(cur, &nfnl_acct_list, head) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(cur->name, acct_name, NFACC=
T_NAME_MAX)!=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acct =3D cur;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&acct->refcnt);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rcu_read_unlock();
> + =A0 =A0 =A0 return acct;
> +}
> +EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
> +
> +void nfnl_acct_put(struct nf_acct *acct)
> +{
> + =A0 =A0 =A0 if (atomic_dec_and_test(&acct->refcnt))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 call_rcu(&acct->rcu_head, nfnl_acct_fre=
e_rcu);
> +}
> +EXPORT_SYMBOL_GPL(nfnl_acct_put);
> +
> +void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfa=
cct)
> +{
> + =A0 =A0 =A0 spin_lock_bh(&nfacct->lock);
> + =A0 =A0 =A0 nfacct->pkts++;
> + =A0 =A0 =A0 nfacct->bytes +=3D skb->len;
> + =A0 =A0 =A0 spin_unlock_bh(&nfacct->lock);
> +}
> +EXPORT_SYMBOL_GPL(nfnl_acct_update);
> +
> +static int __init nfnl_acct_init(void)
> +{
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 pr_info("nfnl_acct: registering with nfnetlink.\n");
> + =A0 =A0 =A0 ret =3D nfnetlink_subsys_register(&nfnl_acct_subsys);
> + =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("nfnl_acct_init: cannot register=
 with nfnetlink.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +err_out:
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static void __exit nfnl_acct_exit(void)
> +{
> + =A0 =A0 =A0 struct nf_acct *cur, *tmp;
> +
> + =A0 =A0 =A0 pr_info("nfnl_acct: unregistering from nfnetlink.\n");
> + =A0 =A0 =A0 nfnetlink_subsys_unregister(&nfnl_acct_subsys);
> +
> + =A0 =A0 =A0 /* if we can remove this module, it means that it has n=
o clients. */
> + =A0 =A0 =A0 list_for_each_entry_safe(cur, tmp, &nfnl_acct_list, hea=
d) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_rcu(&cur->head);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_and_test(&cur->refcnt))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cur);
> + =A0 =A0 =A0 }
> +}
> +
> +module_init(nfnl_acct_init);
> +module_exit(nfnl_acct_exit);
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
