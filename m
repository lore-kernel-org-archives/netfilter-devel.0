From: Aft nix <aftnix@gmail.com>
Subject: Re: What happened to struct xt_match_param
Date: Tue, 5 Jun 2012 18:33:06 +0600
Message-ID: <CAGuaRCv=L3aXBZPtkq=ze1Ww0yB35QxHOy=14-4k3Dd9cR=N-g@mail.gmail.com>
References: <CAGuaRCunyPyyot8jqYj_U_Fh041Y_v9LdcxPfx_37RmNF-F6nQ@mail.gmail.com>
	<alpine.LNX.2.01.1206051415540.2829@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57617 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2FEMdH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:33:07 -0400
Received: by ghrr11 with SMTP id r11so4208139ghr.19
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jun 2012 05:33:07 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1206051415540.2829@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 5, 2012 at 6:18 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Tuesday 2012-06-05 14:09, Aft nix wrote:
>
>>-----BEGIN PGP SIGNED MESSAGE-----
>>Hash: SHA1
>>
>>Hi,
>>
>>It seems in both 2.6 and mainline git tree, there is no reference to
>>struct xt_match_param. I verified in lxr, it seems older kernels like
>>2.6.32 has struct xt_match_param in <linux/netfilter/x_tables.h>
>
> `git log` to the rescue.
>
>
> parent ef53d702c3614fb919e8a8291033e3dbccfd1aea (v2.6.34-rc3-1342-gef=
53d70)
> commit de74c16996287250f0d947663127f80c6beebd3c
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date: =A0 Sun Jul 5 18:26:37 2009 +0200
>
> netfilter: xtables: combine struct xt_match_param and xt_target_param
>

Hi Jan,

Thanks for the reply. I also recalled i've seen a PATCH mail regarding
this commit. I was just reading your
netfilter modules pdf. It mentions xt_match_param(). Thats why i asked.

In between, do you happen to know any updated version of "linux kernel
networking walkthrough"? The original one seems very outdated :
http://gicl.cs.drexel.edu/people/sevy/network/Linux_network_stack_walkt=
hrough.html.

cheers


> The structures carried - besides match/target - almost the same data.
> It is possible to combine them, as extensions are evaluated serially,
> and so, the callers end up a little smaller.
>
> =A0text =A0data =A0bss =A0filename
> -15318 740 104 =A0net/ipv4/netfilter/ip_tables.o
> +15286 =A0 740 =A0104 =A0net/ipv4/netfilter/ip_tables.o
> -15333 540 152 =A0net/ipv6/netfilter/ip6_tables.o
> +15269 =A0 540 =A0152 =A0net/ipv6/netfilter/ip6_tables.o
>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
> =A0include/linux/netfilter/x_tables.h | =A0 42 +++++++++++-----------=
-----
> =A0net/bridge/netfilter/ebtables.c =A0 =A0| =A0 30 ++++++++++--------=
--
> =A0net/ipv4/netfilter/arp_tables.c =A0 =A0| =A0 16 +++++-----
> =A0net/ipv4/netfilter/ip_tables.c =A0 =A0 | =A0 32 ++++++++++--------=
---
> =A0net/ipv6/netfilter/ip6_tables.c =A0 =A0| =A0 27 ++++++++---------
> =A05 files changed, 68 insertions(+), 79 deletions(-)
>
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfi=
lter/x_tables.h
> index eeb4884..5efa375 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -182,13 +182,17 @@ struct xt_counters_info {
>
> =A0#include <linux/netdevice.h>
>
> +#define xt_match_param xt_action_param
> +#define xt_target_param xt_action_param
> =A0/**
> - * struct xt_match_param - parameters for match extensions' match fu=
nctions
> + * struct xt_action_param - parameters for matches/targets
> =A0*
> + * @match: =A0 =A0 the match extension
> + * @target: =A0 =A0the target extension
> + * @matchinfo: per-match data
> + * @targetinfo: =A0 =A0 =A0 =A0per-target data
> =A0* @in: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0input netdevice
> =A0* @out: =A0 =A0 =A0 output netdevice
> - * @match: =A0 =A0 struct xt_match through which this function was i=
nvoked
> - * @matchinfo: per-match data
> =A0* @fragoff: =A0 packet is a fragment, this is the data offset
> =A0* @thoff: =A0 =A0 position of transport header relative to skb->da=
ta
> =A0* @hook: =A0 =A0 =A0hook number given packet came from
> @@ -197,10 +201,15 @@ struct xt_counters_info {
> =A0* @hotdrop: =A0 drop packet if we had inspection problems
> =A0* Network namespace obtainable using dev_net(in/out)
> =A0*/
> -struct xt_match_param {
> +struct xt_action_param {
> + =A0 =A0 =A0 union {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct xt_match *match;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct xt_target *target;
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 union {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const void *matchinfo, *targinfo;
> + =A0 =A0 =A0 };
> =A0 =A0 =A0 =A0const struct net_device *in, *out;
> - =A0 =A0 =A0 const struct xt_match *match;
> - =A0 =A0 =A0 const void *matchinfo;
> =A0 =A0 =A0 =A0int fragoff;
> =A0 =A0 =A0 =A0unsigned int thoff;
> =A0 =A0 =A0 =A0unsigned int hooknum;
> @@ -243,23 +252,6 @@ struct xt_mtdtor_param {
> =A0};
>
> =A0/**
> - * struct xt_target_param - parameters for target extensions' target=
 functions
> - *
> - * @hooknum: =A0 hook through which this target was invoked
> - * @target: =A0 =A0struct xt_target through which this function was =
invoked
> - * @targinfo: =A0per-target data
> - *
> - * Other fields see above.
> - */
> -struct xt_target_param {
> - =A0 =A0 =A0 const struct net_device *in, *out;
> - =A0 =A0 =A0 const struct xt_target *target;
> - =A0 =A0 =A0 const void *targinfo;
> - =A0 =A0 =A0 unsigned int hooknum;
> - =A0 =A0 =A0 u_int8_t family;
> -};
> -
> -/**
> =A0* struct xt_tgchk_param - parameters for target extensions'
> =A0* checkentry functions
> =A0*
> @@ -298,7 +290,7 @@ struct xt_match {
> =A0 =A0 =A0 =A0 =A0 non-linear skb, using skb_header_pointer and
> =A0 =A0 =A0 =A0 =A0 skb_ip_make_writable. */
> =A0 =A0 =A0 =A0bool (*match)(const struct sk_buff *skb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct xt_match_param=
 *);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct xt_action_para=
m *);
>
> =A0 =A0 =A0 =A0/* Called when user tries to insert an entry of this t=
ype. */
> =A0 =A0 =A0 =A0int (*checkentry)(const struct xt_mtchk_param *);
> @@ -335,7 +327,7 @@ struct xt_target {
> =A0 =A0 =A0 =A0 =A0 must now handle non-linear skbs, using skb_copy_b=
its and
> =A0 =A0 =A0 =A0 =A0 skb_ip_make_writable. */
> =A0 =A0 =A0 =A0unsigned int (*target)(struct sk_buff *skb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const st=
ruct xt_target_param *);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const st=
ruct xt_action_param *);
>
> =A0 =A0 =A0 =A0/* Called when user tries to insert an entry of this t=
ype:
> =A0 =A0 =A0 =A0 =A0 =A0hook_mask is a bitmask of hooks from which it =
can be
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/e=
btables.c
> index 1d8c2c0..290d435 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -86,7 +86,7 @@ static struct xt_target ebt_standard_target =3D {
>
> =A0static inline int
> =A0ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *=
skb,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xt_target_param *par)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xt_action_param *par)
> =A0{
> =A0 =A0 =A0 =A0par->target =A0 =3D w->u.watcher;
> =A0 =A0 =A0 =A0par->targinfo =3D w->data;
> @@ -95,8 +95,9 @@ ebt_do_watcher(const struct ebt_entry_watcher *w, s=
truct sk_buff *skb,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static inline int ebt_do_match (struct ebt_entry_match *m,
> - =A0 const struct sk_buff *skb, struct xt_match_param *par)
> +static inline int
> +ebt_do_match(struct ebt_entry_match *m, const struct sk_buff *skb,
> + =A0 =A0 =A0 =A0 =A0 =A0struct xt_action_param *par)
> =A0{
> =A0 =A0 =A0 =A0par->match =A0 =A0 =3D m->u.match;
> =A0 =A0 =A0 =A0par->matchinfo =3D m->data;
> @@ -186,14 +187,13 @@ unsigned int ebt_do_table (unsigned int hook, s=
truct sk_buff *skb,
> =A0 =A0 =A0 =A0const char *base;
> =A0 =A0 =A0 =A0const struct ebt_table_info *private;
> =A0 =A0 =A0 =A0bool hotdrop =3D false;
> - =A0 =A0 =A0 struct xt_match_param mtpar;
> - =A0 =A0 =A0 struct xt_target_param tgpar;
> + =A0 =A0 =A0 struct xt_action_param acpar;
>
> - =A0 =A0 =A0 mtpar.family =A0=3D tgpar.family =3D NFPROTO_BRIDGE;
> - =A0 =A0 =A0 mtpar.in =A0 =A0 =A0=3D tgpar.in =A0=3D in;
> - =A0 =A0 =A0 mtpar.out =A0 =A0 =3D tgpar.out =3D out;
> - =A0 =A0 =A0 mtpar.hotdrop =3D &hotdrop;
> - =A0 =A0 =A0 mtpar.hooknum =3D tgpar.hooknum =3D hook;
> + =A0 =A0 =A0 acpar.family =A0=3D NFPROTO_BRIDGE;
> + =A0 =A0 =A0 acpar.in =A0 =A0 =A0=3D in;
> + =A0 =A0 =A0 acpar.out =A0 =A0 =3D out;
> + =A0 =A0 =A0 acpar.hotdrop =3D &hotdrop;
> + =A0 =A0 =A0 acpar.hooknum =3D hook;
>
> =A0 =A0 =A0 =A0read_lock_bh(&table->lock);
> =A0 =A0 =A0 =A0private =3D table->private;
> @@ -214,7 +214,7 @@ unsigned int ebt_do_table (unsigned int hook, str=
uct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ebt_basic_match(point, eth_hdr(skb=
), in, out))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto letscontinue;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (EBT_MATCH_ITERATE(point, ebt_do_mat=
ch, skb, &mtpar) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (EBT_MATCH_ITERATE(point, ebt_do_mat=
ch, skb, &acpar) !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto letscontinue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (hotdrop) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_unlock_bh(&table-=
>lock);
> @@ -227,7 +227,7 @@ unsigned int ebt_do_table (unsigned int hook, str=
uct sk_buff *skb,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* these should only watch: not modify=
, nor tell us
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 what to do with the packet */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 EBT_WATCHER_ITERATE(point, ebt_do_watch=
er, skb, &tgpar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 EBT_WATCHER_ITERATE(point, ebt_do_watch=
er, skb, &acpar);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t =3D (struct ebt_entry_target *)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (((char *)point) + point->target_=
offset);
> @@ -235,9 +235,9 @@ unsigned int ebt_do_table (unsigned int hook, str=
uct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!t->u.target->target)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0verdict =3D ((struct e=
bt_standard_target *)t)->verdict;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.target =A0 =3D t-=
>u.target;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.targinfo =3D t->d=
ata;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.target=
->target(skb, &tgpar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.target =A0 =3D t-=
>u.target;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.targinfo =3D t->d=
ata;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.target=
->target(skb, &acpar);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (verdict =3D=3D EBT_ACCEPT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_unlock_bh(&table-=
>lock);
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp=
_tables.c
> index 07a69905..73d924b8 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -265,7 +265,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0const char *indev, *outdev;
> =A0 =A0 =A0 =A0void *table_base;
> =A0 =A0 =A0 =A0const struct xt_table_info *private;
> - =A0 =A0 =A0 struct xt_target_param tgpar;
> + =A0 =A0 =A0 struct xt_action_param acpar;
>
> =A0 =A0 =A0 =A0if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NF_DROP;
> @@ -280,10 +280,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0e =3D get_entry(table_base, private->hook_entry[hook])=
;
> =A0 =A0 =A0 =A0back =3D get_entry(table_base, private->underflow[hook=
]);
>
> - =A0 =A0 =A0 tgpar.in =A0 =A0 =A0=3D in;
> - =A0 =A0 =A0 tgpar.out =A0 =A0 =3D out;
> - =A0 =A0 =A0 tgpar.hooknum =3D hook;
> - =A0 =A0 =A0 tgpar.family =A0=3D NFPROTO_ARP;
> + =A0 =A0 =A0 acpar.in =A0 =A0 =A0=3D in;
> + =A0 =A0 =A0 acpar.out =A0 =A0 =3D out;
> + =A0 =A0 =A0 acpar.hooknum =3D hook;
> + =A0 =A0 =A0 acpar.family =A0=3D NFPROTO_ARP;
>
> =A0 =A0 =A0 =A0arp =3D arp_hdr(skb);
> =A0 =A0 =A0 =A0do {
> @@ -333,9 +333,9 @@ unsigned int arpt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Targets which reenter must return
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * abs. verdicts
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.target =A0 =3D t->u.kernel.target=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.targinfo =3D t->data;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &tgpar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.target =A0 =3D t->u.kernel.target=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.targinfo =3D t->data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &acpar);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Target might have changed stuff. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0arp =3D arp_hdr(skb);
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_t=
ables.c
> index 265cedf..e1a53c2 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -316,8 +316,7 @@ ipt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0struct ipt_entry *e, **jumpstack;
> =A0 =A0 =A0 =A0unsigned int *stackptr, origptr, cpu;
> =A0 =A0 =A0 =A0const struct xt_table_info *private;
> - =A0 =A0 =A0 struct xt_match_param mtpar;
> - =A0 =A0 =A0 struct xt_target_param tgpar;
> + =A0 =A0 =A0 struct xt_action_param acpar;
>
> =A0 =A0 =A0 =A0/* Initialization */
> =A0 =A0 =A0 =A0ip =3D ip_hdr(skb);
> @@ -329,13 +328,13 @@ ipt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 * things we don't know, ie. tcp syn flag or ports). =A0=
If the
> =A0 =A0 =A0 =A0 * rule is also a fragment-specific rule, non-fragment=
s won't
> =A0 =A0 =A0 =A0 * match it. */
> - =A0 =A0 =A0 mtpar.fragoff =3D ntohs(ip->frag_off) & IP_OFFSET;
> - =A0 =A0 =A0 mtpar.thoff =A0 =3D ip_hdrlen(skb);
> - =A0 =A0 =A0 mtpar.hotdrop =3D &hotdrop;
> - =A0 =A0 =A0 mtpar.in =A0 =A0 =A0=3D tgpar.in =A0=3D in;
> - =A0 =A0 =A0 mtpar.out =A0 =A0 =3D tgpar.out =3D out;
> - =A0 =A0 =A0 mtpar.family =A0=3D tgpar.family =3D NFPROTO_IPV4;
> - =A0 =A0 =A0 mtpar.hooknum =3D tgpar.hooknum =3D hook;
> + =A0 =A0 =A0 acpar.fragoff =3D ntohs(ip->frag_off) & IP_OFFSET;
> + =A0 =A0 =A0 acpar.thoff =A0 =3D ip_hdrlen(skb);
> + =A0 =A0 =A0 acpar.hotdrop =3D &hotdrop;
> + =A0 =A0 =A0 acpar.in =A0 =A0 =A0=3D in;
> + =A0 =A0 =A0 acpar.out =A0 =A0 =3D out;
> + =A0 =A0 =A0 acpar.family =A0=3D NFPROTO_IPV4;
> + =A0 =A0 =A0 acpar.hooknum =3D hook;
>
> =A0 =A0 =A0 =A0IP_NF_ASSERT(table->valid_hooks & (1 << hook));
> =A0 =A0 =A0 =A0xt_info_rdlock_bh();
> @@ -358,16 +357,16 @@ ipt_do_table(struct sk_buff *skb,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IP_NF_ASSERT(e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ip_packet_match(ip, indev, outdev=
,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &e->ip, mtpar.fragoff)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &e->ip, acpar.fragoff)) {
> =A0no_match:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e =3D ipt_next_entry(e=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xt_ematch_foreach(ematch, e) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mtpar.match =A0 =A0 =3D=
 ematch->u.kernel.match;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mtpar.matchinfo =3D ema=
tch->data;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mtpar.match->match=
(skb, &mtpar))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.match =A0 =A0 =3D=
 ematch->u.kernel.match;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.matchinfo =3D ema=
tch->data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!acpar.match->match=
(skb, &acpar))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto n=
o_match;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -422,11 +421,10 @@ ipt_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.target =A0 =3D t->u.kernel.target=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.targinfo =3D t->data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.target =A0 =3D t->u.kernel.target=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.targinfo =3D t->data;
>
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &tgpar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &acpar);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Target might have changed stuff. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ip =3D ip_hdr(skb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (verdict =3D=3D IPT_CONTINUE)
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6=
_tables.c
> index f8ac4a0..076308c 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -345,8 +345,7 @@ ip6t_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0struct ip6t_entry *e, **jumpstack;
> =A0 =A0 =A0 =A0unsigned int *stackptr, origptr, cpu;
> =A0 =A0 =A0 =A0const struct xt_table_info *private;
> - =A0 =A0 =A0 struct xt_match_param mtpar;
> - =A0 =A0 =A0 struct xt_target_param tgpar;
> + =A0 =A0 =A0 struct xt_action_param acpar;
>
> =A0 =A0 =A0 =A0/* Initialization */
> =A0 =A0 =A0 =A0indev =3D in ? in->name : nulldevname;
> @@ -357,11 +356,11 @@ ip6t_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 * things we don't know, ie. tcp syn flag or ports). =A0=
If the
> =A0 =A0 =A0 =A0 * rule is also a fragment-specific rule, non-fragment=
s won't
> =A0 =A0 =A0 =A0 * match it. */
> - =A0 =A0 =A0 mtpar.hotdrop =3D &hotdrop;
> - =A0 =A0 =A0 mtpar.in =A0 =A0 =A0=3D tgpar.in =A0=3D in;
> - =A0 =A0 =A0 mtpar.out =A0 =A0 =3D tgpar.out =3D out;
> - =A0 =A0 =A0 mtpar.family =A0=3D tgpar.family =3D NFPROTO_IPV6;
> - =A0 =A0 =A0 mtpar.hooknum =3D tgpar.hooknum =3D hook;
> + =A0 =A0 =A0 acpar.hotdrop =3D &hotdrop;
> + =A0 =A0 =A0 acpar.in =A0 =A0 =A0=3D in;
> + =A0 =A0 =A0 acpar.out =A0 =A0 =3D out;
> + =A0 =A0 =A0 acpar.family =A0=3D NFPROTO_IPV6;
> + =A0 =A0 =A0 acpar.hooknum =3D hook;
>
> =A0 =A0 =A0 =A0IP_NF_ASSERT(table->valid_hooks & (1 << hook));
>
> @@ -381,16 +380,16 @@ ip6t_do_table(struct sk_buff *skb,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0IP_NF_ASSERT(e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ip6_packet_match(skb, indev, outd=
ev, &e->ipv6,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &mtpar.thoff, &mtpar.fragoff, &=
hotdrop)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &acpar.thoff, &acpar.fragoff, &=
hotdrop)) {
> =A0no_match:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e =3D ip6t_next_entry(=
e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xt_ematch_foreach(ematch, e) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mtpar.match =A0 =A0 =3D=
 ematch->u.kernel.match;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mtpar.matchinfo =3D ema=
tch->data;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!mtpar.match->match=
(skb, &mtpar))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.match =A0 =A0 =3D=
 ematch->u.kernel.match;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.matchinfo =3D ema=
tch->data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!acpar.match->match=
(skb, &acpar))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto n=
o_match;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -439,10 +438,10 @@ ip6t_do_table(struct sk_buff *skb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.target =A0 =3D t->u.kernel.target=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tgpar.targinfo =3D t->data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.target =A0 =3D t->u.kernel.target=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 acpar.targinfo =3D t->data;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &tgpar);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verdict =3D t->u.kernel.target->target(=
skb, &acpar);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (verdict =3D=3D IP6T_CONTINUE)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0e =3D ip6t_next_entry(=
e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> --
> # Created with git-export-patch



--=20
-aft
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
