From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp extension
Date: Sun, 24 Oct 2010 09:30:31 +0800
Message-ID: <AANLkTin=sDes5baeuvK3i1YGPvEFX-CVfSUURRzwnwuo@mail.gmail.com>
References: <20101023172359.3336.21431.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58655 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0JXBay convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:30:54 -0400
Received: by wyf28 with SMTP id 28so2182169wyf.19
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Oct 2010 18:30:53 -0700 (PDT)
In-Reply-To: <20101023172359.3336.21431.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 24, 2010 at 1:23 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> This patch adds flow-based timestamping for conntracks. This
> conntrack extension is disabled by default. Basically, we use
> two 64-bits variables to store the creation timestamp once the
> conntrack has been confirmed and the other to store the deletion
> time. This extension is disabled by default, to enable it, you
> have to:
>
> echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp

There is also a module parameter to change the default value.

>
> This patch allows to save memory for user-space flow-based
> loogers such as ulogd2. In short, ulogd2 does not need to
> keep a hashtable with the conntrack in user-space to know
> when they were created and destroyed, instead we use the
> kernel timestamp. If we want to have a sane IPFIX implementation
> in user-space, this nanosecs resolution timestamps are also
> useful. Other custom user-space applications can benefit from
> this via libnetfilter_conntrack.
>
> This patch does not modifies the /proc output to display
> the start timestamping in nanosecs (which is not very useful).
> We would need some generic functions similar to those in
> xt_time to convert that output to local time in the kernel.
> I think that ctnetlink is better for this, we pass the
> timestamps in nanosecs and we call localtime() in the
> user-space application. For that reason, I decided to only
> modify the ctnetlink part (including dumping and event
> notifications).
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> =A0include/linux/netfilter/nfnetlink_conntrack.h | =A0 =A09 ++
> =A0include/net/netfilter/nf_conntrack_extend.h =A0 | =A0 =A02
> =A0include/net/netns/conntrack.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 =A02
> =A0net/netfilter/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A02
> =A0net/netfilter/nf_conntrack_core.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 27=
 ++++++
> =A0net/netfilter/nf_conntrack_netlink.c =A0 =A0 =A0 =A0 =A0| =A0 42 +=
++++++++
> =A0net/netfilter/nf_conntrack_timestamp.c =A0 =A0 =A0 =A0| =A0120 +++=
++++++++++++++++++++++
> =A07 files changed, 202 insertions(+), 2 deletions(-)
> =A0create mode 100644 net/netfilter/nf_conntrack_timestamp.c
>
> diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/=
linux/netfilter/nfnetlink_conntrack.h
> index 455f0ce..e2d92c8 100644
> --- a/include/linux/netfilter/nfnetlink_conntrack.h
> +++ b/include/linux/netfilter/nfnetlink_conntrack.h
> @@ -41,6 +41,7 @@ enum ctattr_type {
> =A0 =A0 =A0 =A0CTA_NAT_SEQ_ADJ_REPLY,
> =A0 =A0 =A0 =A0CTA_SECMARK,
> =A0 =A0 =A0 =A0CTA_ZONE,
> + =A0 =A0 =A0 CTA_TIMESTAMP,
> =A0 =A0 =A0 =A0__CTA_MAX
> =A0};
> =A0#define CTA_MAX (__CTA_MAX - 1)
> @@ -126,6 +127,14 @@ enum ctattr_counters {
> =A0};
> =A0#define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
>
> +enum ctattr_tstamp {
> + =A0 =A0 =A0 CTA_TIMESTAMP_UNSPEC,
> + =A0 =A0 =A0 CTA_TIMESTAMP_START,
> + =A0 =A0 =A0 CTA_TIMESTAMP_STOP,
> + =A0 =A0 =A0 __CTA_TIMESTAMP_MAX
> +};
> +#define CTA_TIMESTAMP_MAX (__CTA_TIMESTAMP_MAX - 1)
> +
> =A0enum ctattr_nat {
> =A0 =A0 =A0 =A0CTA_NAT_UNSPEC,
> =A0 =A0 =A0 =A0CTA_NAT_MINIP,
> diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/ne=
t/netfilter/nf_conntrack_extend.h
> index 0772d29..057a0cd 100644
> --- a/include/net/netfilter/nf_conntrack_extend.h
> +++ b/include/net/netfilter/nf_conntrack_extend.h
> @@ -11,6 +11,7 @@ enum nf_ct_ext_id {
> =A0 =A0 =A0 =A0NF_CT_EXT_ACCT,
> =A0 =A0 =A0 =A0NF_CT_EXT_ECACHE,
> =A0 =A0 =A0 =A0NF_CT_EXT_ZONE,
> + =A0 =A0 =A0 NF_CT_EXT_TSTAMP,
> =A0 =A0 =A0 =A0NF_CT_EXT_NUM,
> =A0};
>
> @@ -19,6 +20,7 @@ enum nf_ct_ext_id {
> =A0#define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
> =A0#define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
> =A0#define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
> +#define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
>
> =A0/* Extensions: optional stuff which isn't permanently in struct. *=
/
> =A0struct nf_ct_ext {
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntr=
ack.h
> index d4958d4..54d1e52 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -21,11 +21,13 @@ struct netns_ct {
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysctl_eve=
nts;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0sysctl_events_retr=
y_timeout;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysctl_acc=
t;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysctl_tsta=
mp;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysctl_che=
cksum;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0sysctl_log_invalid=
; /* Log invalid packets */
> =A0#ifdef CONFIG_SYSCTL
> =A0 =A0 =A0 =A0struct ctl_table_header *sysctl_header;
> =A0 =A0 =A0 =A0struct ctl_table_header *acct_sysctl_header;
> + =A0 =A0 =A0 struct ctl_table_header *tstamp_sysctl_header;
> =A0 =A0 =A0 =A0struct ctl_table_header *event_sysctl_header;
> =A0#endif
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_vmall=
oc;
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 441050f..70c7d24 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -1,6 +1,6 @@
> =A0netfilter-objs :=3D core.o nf_log.o nf_queue.o nf_sockopt.o
>
> -nf_conntrack-y :=3D nf_conntrack_core.o nf_conntrack_standalone.o nf=
_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_connt=
rack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_=
tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.=
o
> +nf_conntrack-y :=3D nf_conntrack_core.o nf_conntrack_standalone.o nf=
_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_connt=
rack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_=
tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.=
o nf_conntrack_tstamp.o
> =A0nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) +=3D nf_conntrack_ecach=
e.o
>
> =A0obj-$(CONFIG_NETFILTER) =3D netfilter.o
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_con=
ntrack_core.c
> index df3eedb..492b879 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -41,6 +41,7 @@
> =A0#include <net/netfilter/nf_conntrack_core.h>
> =A0#include <net/netfilter/nf_conntrack_extend.h>
> =A0#include <net/netfilter/nf_conntrack_acct.h>
> +#include <net/netfilter/nf_conntrack_tstamp.h>

You missed this file in this patch, so nf_ct_tstamp_ext can't be found
when compiling.

> =A0#include <net/netfilter/nf_conntrack_ecache.h>
> =A0#include <net/netfilter/nf_conntrack_zones.h>
> =A0#include <net/netfilter/nf_nat.h>
> @@ -272,6 +273,11 @@ EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
> =A0static void death_by_timeout(unsigned long ul_conntrack)
> =A0{
> =A0 =A0 =A0 =A0struct nf_conn *ct =3D (void *)ul_conntrack;
> + =A0 =A0 =A0 struct nf_conn_tstamp *tstamp;
> +
> + =A0 =A0 =A0 tstamp =3D nf_conn_tstamp_find(ct);
> + =A0 =A0 =A0 if (tstamp && tstamp->stop =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstamp->stop =3D ktime_to_ns(ktime_get_=
real());
>
> =A0 =A0 =A0 =A0if (!test_bit(IPS_DYING_BIT, &ct->status) &&
> =A0 =A0 =A0 =A0 =A0 =A0unlikely(nf_conntrack_event(IPCT_DESTROY, ct) =
< 0)) {
> @@ -393,6 +399,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> =A0 =A0 =A0 =A0struct nf_conntrack_tuple_hash *h;
> =A0 =A0 =A0 =A0struct nf_conn *ct;
> =A0 =A0 =A0 =A0struct nf_conn_help *help;
> + =A0 =A0 =A0 struct nf_conn_tstamp *tstamp;
> =A0 =A0 =A0 =A0struct hlist_nulls_node *n;
> =A0 =A0 =A0 =A0enum ip_conntrack_info ctinfo;
> =A0 =A0 =A0 =A0struct net *net;
> @@ -459,6 +466,15 @@ __nf_conntrack_confirm(struct sk_buff *skb)
> =A0 =A0 =A0 =A0atomic_inc(&ct->ct_general.use);
> =A0 =A0 =A0 =A0set_bit(IPS_CONFIRMED_BIT, &ct->status);
>
> + =A0 =A0 =A0 /* set conntrack timestamp, if enabled. */
> + =A0 =A0 =A0 tstamp =3D nf_conn_tstamp_find(ct);
> + =A0 =A0 =A0 if (tstamp) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (skb->tstamp.tv64 =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __net_timestamp((struct=
 sk_buff *)skb);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstamp->start =3D ktime_to_ns(skb->tsta=
mp);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/* Since the lookup is lockless, hash insertion must b=
e done after
> =A0 =A0 =A0 =A0 * starting the timer and setting the CONFIRMED bit. T=
he RCU barriers
> =A0 =A0 =A0 =A0 * guarantee that no other CPU can find the conntrack =
before the above
> @@ -691,6 +707,7 @@ init_conntrack(struct net *net, struct nf_conn *t=
mpl,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0nf_ct_acct_ext_add(ct, GFP_ATOMIC);
> + =A0 =A0 =A0 nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
>
> =A0 =A0 =A0 =A0ecache =3D tmpl ? nf_ct_ecache_find(tmpl) : NULL;
> =A0 =A0 =A0 =A0nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
> @@ -1129,6 +1146,11 @@ struct __nf_ct_flush_report {
> =A0static int kill_report(struct nf_conn *i, void *data)
> =A0{
> =A0 =A0 =A0 =A0struct __nf_ct_flush_report *fr =3D (struct __nf_ct_fl=
ush_report *)data;
> + =A0 =A0 =A0 struct nf_conn_tstamp *tstamp;
> +
> + =A0 =A0 =A0 tstamp =3D nf_conn_tstamp_find(i);
> + =A0 =A0 =A0 if (tstamp && tstamp->stop =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tstamp->stop =3D ktime_to_ns(ktime_get_=
real());
>
> =A0 =A0 =A0 =A0/* If we fail to deliver the event, death_by_timeout()=
 will retry */
> =A0 =A0 =A0 =A0if (nf_conntrack_event_report(IPCT_DESTROY, i,
> @@ -1447,6 +1469,9 @@ static int nf_conntrack_init_net(struct net *ne=
t)
> =A0 =A0 =A0 =A0ret =3D nf_conntrack_acct_init(net);
> =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_acct;
> + =A0 =A0 =A0 ret =3D nf_conntrack_tstamp_init(net);
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_tstamp;
> =A0 =A0 =A0 =A0ret =3D nf_conntrack_ecache_init(net);
> =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_ecache;
> @@ -1454,6 +1479,8 @@ static int nf_conntrack_init_net(struct net *ne=
t)
> =A0 =A0 =A0 =A0return 0;
>
> =A0err_ecache:
> + =A0 =A0 =A0 nf_conntrack_tstamp_fini(net);
> +err_tstamp:
> =A0 =A0 =A0 =A0nf_conntrack_acct_fini(net);
> =A0err_acct:
> =A0 =A0 =A0 =A0nf_conntrack_expect_fini(net);
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_=
conntrack_netlink.c
> index 4b7989e..d8b50e9 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -40,6 +40,7 @@
> =A0#include <net/netfilter/nf_conntrack_l4proto.h>
> =A0#include <net/netfilter/nf_conntrack_tuple.h>
> =A0#include <net/netfilter/nf_conntrack_acct.h>
> +#include <net/netfilter/nf_conntrack_tstamp.h>
> =A0#include <net/netfilter/nf_conntrack_zones.h>
> =A0#ifdef CONFIG_NF_NAT_NEEDED
> =A0#include <net/netfilter/nf_nat_core.h>
> @@ -229,6 +230,33 @@ nla_put_failure:
> =A0 =A0 =A0 =A0return -1;
> =A0}
>
> +static int
> +ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *=
ct)
> +{
> + =A0 =A0 =A0 struct nlattr *nest_count;
> + =A0 =A0 =A0 const struct nf_conn_tstamp *tstamp;
> +
> + =A0 =A0 =A0 tstamp =3D nf_conn_tstamp_find(ct);
> + =A0 =A0 =A0 if (!tstamp)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 nest_count =3D nla_nest_start(skb, CTA_TIMESTAMP | NLA_=
=46_NESTED);
> + =A0 =A0 =A0 if (!nest_count)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nla_put_failure;
> +
> + =A0 =A0 =A0 NLA_PUT_BE64(skb, CTA_TIMESTAMP_START, cpu_to_be64(tsta=
mp->start));
> + =A0 =A0 =A0 if (tstamp->stop !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 NLA_PUT_BE64(skb, CTA_TIMESTAMP_STOP,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_be64(=
tstamp->stop));
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 nla_nest_end(skb, nest_count);
> +
> + =A0 =A0 =A0 return 0;
> +
> +nla_put_failure:
> + =A0 =A0 =A0 return -1;
> +}
> +
> =A0#ifdef CONFIG_NF_CONNTRACK_MARK
> =A0static inline int
> =A0ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
> @@ -388,6 +416,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid,=
 u32 seq,
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_timeout(skb, ct) < 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORI=
GINAL) < 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REP=
LY) < 0 ||
> + =A0 =A0 =A0 =A0 =A0 ctnetlink_dump_timestamp(skb, ct) < 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_protoinfo(skb, ct) < 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_helpinfo(skb, ct) < 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0ctnetlink_dump_mark(skb, ct) < 0 ||
> @@ -438,6 +467,14 @@ ctnetlink_counters_size(const struct nf_conn *ct=
)
> =A0}
>
> =A0static inline size_t
> +ctnetlink_timestamp_size(const struct nf_conn *ct)
> +{
> + =A0 =A0 =A0 if (!nf_ct_ext_exist(ct, NF_CT_EXT_TSTAMP))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 return nla_total_size(0) + 2 * nla_total_size(sizeof(ui=
nt64_t));
> +}
> +
> +static inline size_t
> =A0ctnetlink_nlmsg_size(const struct nf_conn *ct)
> =A0{
> =A0 =A0 =A0 =A0return NLMSG_ALIGN(sizeof(struct nfgenmsg))
> @@ -448,6 +485,7 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + nla_total_size(sizeof(u_int32_t)) /* CT=
A_ID */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + nla_total_size(sizeof(u_int32_t)) /* CT=
A_STATUS */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + ctnetlink_counters_size(ct)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0+ ctnetlink_timestamp_size(ct)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + nla_total_size(sizeof(u_int32_t)) /* CT=
A_TIMEOUT */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + nla_total_size(0) /* CTA_PROTOINFO */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 + nla_total_size(0) /* CTA_HELP */
> @@ -540,7 +578,8 @@ ctnetlink_conntrack_event(unsigned int events, st=
ruct nf_ct_event *item)
>
> =A0 =A0 =A0 =A0if (events & (1 << IPCT_DESTROY)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ctnetlink_dump_counters(skb, ct, I=
P_CT_DIR_ORIGINAL) < 0 ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctnetlink_dump_counters(skb, ct=
, IP_CT_DIR_REPLY) < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctnetlink_dump_counters(skb, ct=
, IP_CT_DIR_REPLY) < 0 ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctnetlink_dump_timestamp(skb, c=
t) < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto nla_put_failure;
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ctnetlink_dump_timeout(skb, ct) < =
0)
> @@ -1329,6 +1368,7 @@ ctnetlink_create_conntrack(struct net *net, u16=
 zone,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0nf_ct_acct_ext_add(ct, GFP_ATOMIC);
> + =A0 =A0 =A0 nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
> =A0 =A0 =A0 =A0nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
> =A0 =A0 =A0 =A0/* we must add conntrack extensions before confirmatio=
n. */
> =A0 =A0 =A0 =A0ct->status |=3D IPS_CONFIRMED;
> diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/n=
f_conntrack_timestamp.c
> new file mode 100644
> index 0000000..51c8c28
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_timestamp.c
> @@ -0,0 +1,120 @@
> +/*
> + * (C) 2010 Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation (or any later at your o=
ption).
> + */
> +
> +#include <linux/netfilter.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/moduleparam.h>
> +
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_extend.h>
> +#include <net/netfilter/nf_conntrack_tstamp.h>
> +
> +static int nf_ct_tstamp __read_mostly;
> +
> +module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
> +MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestampi=
ng.");
> +
> +#ifdef CONFIG_SYSCTL
> +static struct ctl_table tstamp_sysctl_table[] =3D {
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .procname =A0 =A0 =A0 =3D "nf_conntrack=
_timestamp",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .data =A0 =A0 =A0 =A0 =A0 =3D &init_net=
=2Ect.sysctl_tstamp,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .maxlen =A0 =A0 =A0 =A0 =3D sizeof(unsi=
gned int),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .mode =A0 =A0 =A0 =A0 =A0 =3D 0644,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .proc_handler =A0 =3D proc_dointvec,
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {}
> +};
> +#endif /* CONFIG_SYSCTL */
> +
> +static struct nf_ct_ext_type tstamp_extend __read_mostly =3D {
> + =A0 =A0 =A0 .len =A0 =A0=3D sizeof(struct nf_conn_tstamp),
> + =A0 =A0 =A0 .align =A0=3D __alignof__(struct nf_conn_tstamp),
> + =A0 =A0 =A0 .id =A0 =A0 =3D NF_CT_EXT_TSTAMP,
> +};
> +
> +#ifdef CONFIG_SYSCTL
> +static int nf_conntrack_tstamp_init_sysctl(struct net *net)
> +{
> + =A0 =A0 =A0 struct ctl_table *table;
> +
> + =A0 =A0 =A0 table =3D kmemdup(tstamp_sysctl_table, sizeof(tstamp_sy=
sctl_table),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> + =A0 =A0 =A0 if (!table)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 table[0].data =3D &net->ct.sysctl_tstamp;
> +
> + =A0 =A0 =A0 net->ct.tstamp_sysctl_header =3D register_net_sysctl_ta=
ble(net,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_net_netfilter_sysctl=
_path, table);
> + =A0 =A0 =A0 if (!net->ct.tstamp_sysctl_header) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "nf_ct_tstamp: can't re=
gister to sysctl.\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_register;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +
> +out_register:
> + =A0 =A0 =A0 kfree(table);
> +out:
> + =A0 =A0 =A0 return -ENOMEM;
> +}
> +
> +static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
> +{
> + =A0 =A0 =A0 struct ctl_table *table;
> +
> + =A0 =A0 =A0 table =3D net->ct.tstamp_sysctl_header->ctl_table_arg;
> + =A0 =A0 =A0 unregister_net_sysctl_table(net->ct.tstamp_sysctl_heade=
r);
> + =A0 =A0 =A0 kfree(table);
> +}
> +#else
> +static int nf_conntrack_tstamp_init_sysctl(struct net *net)
> +{
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void nf_conntrack_tstamp_fini_sysctl(struct net *net)
> +{
> +}
> +#endif
> +
> +int nf_conntrack_tstamp_init(struct net *net)
> +{
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 net->ct.sysctl_tstamp =3D nf_ct_tstamp;
> +
> + =A0 =A0 =A0 if (net_eq(net, &init_net)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D nf_ct_extend_register(&tstamp_e=
xtend);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "nf_ct_=
tstamp: Unable to register "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "extension\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_extend_registe=
r;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D nf_conntrack_tstamp_init_sysctl(net);
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_sysctl;
> +
> + =A0 =A0 =A0 return 0;
> +
> +out_sysctl:
> + =A0 =A0 =A0 if (net_eq(net, &init_net))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_ct_extend_unregister(&tstamp_extend)=
;
> +out_extend_register:
> + =A0 =A0 =A0 return ret;
> +}
> +
> +void nf_conntrack_tstamp_fini(struct net *net)
> +{
> + =A0 =A0 =A0 nf_conntrack_tstamp_fini_sysctl(net);
> + =A0 =A0 =A0 if (net_eq(net, &init_net))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nf_ct_extend_unregister(&tstamp_extend)=
;
> +}
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
