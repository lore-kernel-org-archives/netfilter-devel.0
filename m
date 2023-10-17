Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAA7CDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 09:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbjJQJ0i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 05:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbjJQJ0g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 05:26:36 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A565093
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 02:26:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0423ECC02B7;
        Tue, 17 Oct 2023 11:26:31 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 17 Oct 2023 11:26:28 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5919ACC02B0;
        Tue, 17 Oct 2023 11:26:22 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 4A5AC3431A9; Tue, 17 Oct 2023 11:26:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 491533431A8;
        Tue, 17 Oct 2023 11:26:22 +0200 (CEST)
Date:   Tue, 17 Oct 2023 11:26:22 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Linkui Xiao <xiaolinkui@gmail.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, justinstitt@google.com,
        kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: Re: [PATCH 2/2] netfilter: ipset: fix race condition in ipset swap,
 destroy and test
In-Reply-To: <96163a1d-81ed-1739-96da-f1a7b5f63dd7@gmail.com>
Message-ID: <69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org>
References: <20231016135204.27443-1-xiaolinkui@gmail.com> <20231016135204.27443-2-xiaolinkui@gmail.com> <3ad078fa-fa61-95a8-dbd2-33d5faa2a8b@netfilter.org> <96163a1d-81ed-1739-96da-f1a7b5f63dd7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-331312904-1697534782=:739764"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-331312904-1697534782=:739764
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 17 Oct 2023, Linkui Xiao wrote:

> On 10/17/23 03:52, Jozsef Kadlecsik wrote:
> > Hello,
> >=20
> > On Mon, 16 Oct 2023, xiaolinkui wrote:
> >=20
> > > From: Linkui Xiao <xiaolinkui@kylinos.cn>
> > >=20
> > > There is a race condition which can be demonstrated by the followin=
g
> > > script:
> > >=20
> > > ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 10=
48576
> > > ipset add hash_ip1 172.20.0.0/16
> > > ipset add hash_ip1 192.168.0.0/16
> > > iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> > > while [ 1 ]
> > > do
> > > 	ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem
> > > 1048576
> > > 	ipset add hash_ip2 172.20.0.0/16
> > > 	ipset swap hash_ip1 hash_ip2
> > > 	ipset destroy hash_ip2
> > > 	sleep 0.05
> > > done
> > I have been running the script above for more than two hours and noth=
ing
> > happened. What else is needed to trigger the bug? (I have been
> > continuously sending ping to the tested host.)
> This is an extremely low probability event. In our k8s cluster, hundred=
s=20
> of virtual machines ran for several months before experiencing a crash.
> Perhaps due to some special reasons, the ip_set_test run time has been
> increased, during this period, other CPU completed the swap and destroy
> operations on the ipset.
> In order to quickly trigger this bug, we can add a delay and destroy=20
> operations to the test kernel to simulate the actual environment, such=20
> as:
>=20
> @@ -733,11 +733,13 @@ ip_set_unlock(struct ip_set *set)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 spin_unlock_bh(&set->lock);
> =C2=A0}
>=20
> +static void ip_set_destroy_set(struct ip_set *set);
> =C2=A0int
> =C2=A0ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cons=
t struct xt_action_param *par, struct ip_set_adt_opt *opt)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ip_set *set =3D ip_se=
t_rcu_get(xt_net(par), index);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ip_set_net *inst =3D ip_se=
t_pernet(xt_net(par));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(!set);
> @@ -747,6 +749,17 @@ ip_set_test(ip_set_id_t index, const struct sk_buf=
f *skb,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(op=
t->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSPEC))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return 0;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mdelay(100); // Waiting for swap =
to complete
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read_lock_bh(&ip_set_ref_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (set->ref =3D=3D 0 && set->ref=
_netlink =3D=3D 0) { // set can be destroyed
> with ref =3D 0
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 pr_warn("set %s, index %u, ref %u\n", set->name, index,
> set->ref);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 read_unlock_bh(&ip_set_ref_lock);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ip_set(inst, index) =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ip_set_destroy_set(set);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 read_unlock_bh(&ip_set_ref_lock);
> +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D set->variant->kadt(s=
et, skb, par, IPSET_TEST, opt);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EAGAIN) {
>=20
> Then run the above script on the test kernel, crash will appear on=20
> hash_net4_kadt: (need sending ping to the tested host.)

I understand the intent but that's a sure way to crash the kernel indeed.
=20
> [=C2=A0=C2=A0 93.021792] BUG: kernel NULL pointer dereference, address:=
 000000000000009c
> [=C2=A0=C2=A0 93.021796] #PF: supervisor read access in kernel mode
> [=C2=A0=C2=A0 93.021798] #PF: error_code(0x0000) - not-present page
> [=C2=A0=C2=A0 93.021800] PGD 0 P4D 0
> [=C2=A0=C2=A0 93.021804] Oops: 0000 [#1] PREEMPT SMP PTI
> [=C2=A0=C2=A0 93.021807] CPU: 4 PID: 0 Comm: swapper/4 Kdump: loaded No=
t tainted
> 6.6.0-rc5 #29
> [=C2=A0=C2=A0 93.021811] Hardware name: VMware, Inc. VMware Virtual Pla=
tform/440BX
> Desktop Reference Platform, BIOS 6.00 11/12/2020
> [=C2=A0=C2=A0 93.021813] RIP: 0010:hash_net4_kadt+0x5f/0x1b0 [ip_set_ha=
sh_net]
> [=C2=A0=C2=A0 93.021825] Code: 00 48 89 44 24 48 48 8b 87 80 00 00 00 4=
5 8b 60 30 c7 44
> 24 08 00 00 00 00 4c 8b 54 ca 10 31 d2 c6 44 24 0e 00 66 89 54 24 0c <0=
f> b6
> b0 9c 00 00 00 40 84 f6 0f 84 bf 00 00 00 48 8d 54 24 10 83
> [=C2=A0=C2=A0 93.021827] RSP: 0018:ffffb0180058c9c0 EFLAGS: 00010246
> [=C2=A0=C2=A0 93.021830] RAX: 0000000000000000 RBX: 0000000000000002 RC=
X:
> 0000000000000002
> [=C2=A0=C2=A0 93.021832] RDX: 0000000000000000 RSI: ffff956d747cdd00 RD=
I:
> ffff956d9348ba80
> [=C2=A0=C2=A0 93.021835] RBP: ffffb0180058ca30 R08: ffffb0180058ca88 R0=
9:
> ffff956d9348ba80
> [=C2=A0=C2=A0 93.021837] R10: ffffffffc102f4f0 R11: ffff956d747cdd00 R1=
2:
> 00000000ffffffff
> [=C2=A0=C2=A0 93.021839] R13: 0000000000000054 R14: ffffb0180058ca88 R1=
5:
> ffff956d747cdd00
> [=C2=A0=C2=A0 93.021862] FS:=C2=A0 0000000000000000(0000) GS:ffff956d9b=
100000(0000)
> knlGS:0000000000000000
> [=C2=A0=C2=A0 93.021870] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
> [=C2=A0=C2=A0 93.021873] CR2: 000000000000009c CR3: 0000000031e3a006 CR=
4:
> 00000000003706e0
> [=C2=A0=C2=A0 93.021887] Call Trace:
> [=C2=A0=C2=A0 93.021891]=C2=A0 <IRQ>
> [=C2=A0=C2=A0 93.021893]=C2=A0 ? __die+0x24/0x70
> [=C2=A0=C2=A0 93.021900]=C2=A0 ? page_fault_oops+0x82/0x150
> [=C2=A0=C2=A0 93.021905]=C2=A0 ? exc_page_fault+0x69/0x150
> [=C2=A0=C2=A0 93.021911]=C2=A0 ? asm_exc_page_fault+0x26/0x30
> [=C2=A0=C2=A0 93.021915]=C2=A0 ? __pfx_hash_net4_test+0x10/0x10 [ip_set=
_hash_net]
> [=C2=A0=C2=A0 93.021922]=C2=A0 ? hash_net4_kadt+0x5f/0x1b0 [ip_set_hash=
_net]
> [=C2=A0=C2=A0 93.021931]=C2=A0 ip_set_test+0x119/0x250 [ip_set]
> [=C2=A0=C2=A0 93.021943]=C2=A0 set_match_v4+0xa2/0xe0 [xt_set]
> [=C2=A0=C2=A0 93.021973]=C2=A0 nft_match_eval+0x65/0xb0 [nft_compat]
> [=C2=A0=C2=A0 93.021982]=C2=A0 nft_do_chain+0xe1/0x430 [nf_tables]
> [=C2=A0=C2=A0 93.022008]=C2=A0 ? resolve_normal_ct+0xc1/0x200 [nf_connt=
rack]
> [=C2=A0=C2=A0 93.022026]=C2=A0 ? nf_conntrack_icmpv4_error+0x123/0x1a0 =
[nf_conntrack]
> [=C2=A0=C2=A0 93.022046]=C2=A0 nft_do_chain_ipv4+0x6b/0x90 [nf_tables]
> [=C2=A0=C2=A0 93.022066]=C2=A0 nf_hook_slow+0x40/0xc0
> [=C2=A0=C2=A0 93.022071]=C2=A0 ip_local_deliver+0xdb/0x130
> [=C2=A0=C2=A0 93.022075]=C2=A0 ? __pfx_ip_local_deliver_finish+0x10/0x1=
0
> [=C2=A0=C2=A0 93.022078]=C2=A0 __netif_receive_skb_core.constprop.0+0x6=
e1/0x10a0
> [=C2=A0=C2=A0 93.022086]=C2=A0 ? find_busiest_group+0x43/0x240
> [=C2=A0=C2=A0 93.022091]=C2=A0 __netif_receive_skb_list_core+0x136/0x2c=
0
> [=C2=A0=C2=A0 93.022096]=C2=A0 netif_receive_skb_list_internal+0x1c9/0x=
300
> [=C2=A0=C2=A0 93.022101]=C2=A0 ? e1000_clean_rx_irq+0x316/0x4c0 [e1000]
> [=C2=A0=C2=A0 93.022113]=C2=A0 napi_complete_done+0x73/0x1b0
> [=C2=A0=C2=A0 93.022117]=C2=A0 e1000_clean+0x7c/0x1e0 [e1000]
> [=C2=A0=C2=A0 93.022127]=C2=A0 __napi_poll+0x29/0x1b0
> [=C2=A0=C2=A0 93.022131]=C2=A0 net_rx_action+0x29f/0x370
> [=C2=A0=C2=A0 93.022136]=C2=A0 __do_softirq+0xcc/0x2af
> [=C2=A0=C2=A0 93.022142]=C2=A0 __irq_exit_rcu+0xa1/0xc0
> [=C2=A0=C2=A0 93.022147]=C2=A0 sysvec_apic_timer_interrupt+0x76/0x90
> >=20
> > > Swap will exchange the values of ref so destroy will see ref =3D 0 =
instead
> > > of
> > > ref =3D 1. So after running this script for a period of time, the f=
ollowing
> > > race situations may occur:
> > > 	CPU0:                CPU1:
> > > 	ipt_do_table
> > > 	->set_match_v4
> > > 	->ip_set_test
> > > 			ipset swap hash_ip1 hash_ip2
> > > 			ipset destroy hash_ip2
> > > 	->hash_net4_kadt
> > >=20
> > > CPU0 found ipset through the index, and at this time, hash_ip2 has =
been
> > > destroyed by CPU1 through name search. So CPU0 will crash when acce=
ssing
> > > set->data in the function hash_net4_kadt.
> > >=20
> > > With this fix in place swap will not succeed because ip_set_test st=
ill has
> > > ref_swapping on the set.
> > >=20
> > > Both destroy and swap will error out if ref_swapping !=3D 0 on the =
set.
> > >=20
> > > Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> > > ---
> > >   net/netfilter/ipset/ip_set_core.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/net/netfilter/ipset/ip_set_core.c
> > > b/net/netfilter/ipset/ip_set_core.c
> > > index e5d25df5c64c..d6bd37010bfb 100644
> > > --- a/net/netfilter/ipset/ip_set_core.c
> > > +++ b/net/netfilter/ipset/ip_set_core.c
> > > @@ -741,11 +741,13 @@ ip_set_test(ip_set_id_t index, const struct s=
k_buff
> > > *skb,
> > >   	int ret =3D 0;
> > >     	BUG_ON(!set);
> > > +
> > > +	__ip_set_get_swapping(set);
> > >   	pr_debug("set %s, index %u\n", set->name, index);
> > >     	if (opt->dim < set->type->dimension ||
> > >   	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPRO=
TO_UNSPEC))
> > > -		return 0;
> > > +		goto out;
> > >     	ret =3D set->variant->kadt(set, skb, par, IPSET_TEST, opt);
> > >   @@ -764,6 +766,8 @@ ip_set_test(ip_set_id_t index, const struct s=
k_buff
> > > *skb,
> > >   			ret =3D -ret;
> > >   	}
> > >   +out:
> > > +	__ip_set_put_swapping(set);
> > >   	/* Convert error codes to nomatch */
> > >   	return (ret < 0 ? 0 : ret);
> > >   }
> > > --=20
> > > 2.17.1
> > The patch above alas is also not acceptable: it adds locking to a loc=
kless
> > area and thus slows down the execution unnecessarily.
> Use seq of cpu in destroy can avoid this issue, but Florian Westphal sa=
ys
> it's not suitable:
> https://lore.kernel.org/all/20231005123107.GB9350@breakpoint.cc/

No, because there are other, non-iptables usage of ipset in the kernel=20
too. And Florian is right that synchonize_rcu() is the proper way to solv=
e=20
the issue.
=20
> > If there's a bug, then that must be handled in ip_set_swap() itself, =
like
> > for example adding a quiescent time and waiting for the ongoing users=
 of
> > the swapped set to finish their job. You can make it slow there, beca=
use
> > swapping is not performance critical.
> Can we add read seq of cpu to swap to wait for the test to complete? Su=
ch as:
>=20
> @@ -1357,6 +1357,7 @@ static int ip_set_swap(struct sk_buff *skb, const=
 struct
> nfnl_info *info,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ip_set *from, *to;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ip_set_id_t from_id, to_id;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char from_name[IPSET_MAXNAME=
LEN];
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int cpu;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(protocol_min_fa=
iled(attr) ||
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !attr[IPSET_ATTR_SETNAME=
] ||
> @@ -1395,8 +1396,21 @@ static int ip_set_swap(struct sk_buff *skb, cons=
t
> struct nfnl_info *info,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 swap(from->ref, to->ref);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ip_set(inst, from_id) =3D to=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ip_set(inst, to_id) =3D from=
;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_unlock_bh(&ip_set_ref_lock)=
;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* wait for even xt_recseq on all=
 cpus */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for_each_possible_cpu(cpu) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 seqcount_t *s =3D &per_cpu(xt_recseq, cpu);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 u32 seq =3D raw_read_seqcount(s);
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (seq & 1) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cond_resched();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cpu_relax();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (seq=
 =3D=3D raw_read_seqcount(s));
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_unlock_bh(&ip_set_ref_lock)=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0}
>=20
> Of course, this solution cannot be verified in the test kernel above.

Also, it does not solve all possible cases, as it was mentioned.

I'd go with using synchonize_rcu() but in the swap function instead of th=
e=20
destroy one. The patch below should solve the problem. (The patching abov=
e=20
is not suitable to verify it at all.):

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 35d2f9c9ada0..35bd1c1e09de 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -712,13 +712,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
 	struct ip_set_net *inst =3D ip_set_pernet(net);
=20
 	rcu_read_lock();
-	/* ip_set_list itself needs to be protected */
+	/* ip_set_list and the set pointer need to be protected */
 	set =3D rcu_dereference(inst->ip_set_list)[index];
-	rcu_read_unlock();
=20
 	return set;
 }
=20
+static inline void
+ip_set_rcu_put(struct ip_set *set __always_unused)
+{
+	rcu_read_unlock();
+}
+
 static inline void
 ip_set_lock(struct ip_set *set)
 {
@@ -744,8 +749,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return 0;
+	}
=20
 	ret =3D set->variant->kadt(set, skb, par, IPSET_TEST, opt);
=20
@@ -764,6 +771,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *=
skb,
 			ret =3D -ret;
 	}
=20
+	ip_set_rcu_put(set);
 	/* Convert error codes to nomatch */
 	return (ret < 0 ? 0 : ret);
 }
@@ -780,12 +788,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
=20
 	ip_set_lock(set);
 	ret =3D set->variant->kadt(set, skb, par, IPSET_ADD, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
=20
 	return ret;
 }
@@ -802,12 +813,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff =
*skb,
 	pr_debug("set %s, index %u\n", set->name, index);
=20
 	if (opt->dim < set->type->dimension ||
-	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC))
+	    !(opt->family =3D=3D set->family || set->family =3D=3D NFPROTO_UNSP=
EC)) {
+		ip_set_rcu_put(set);
 		return -IPSET_ERR_TYPE_MISMATCH;
+	}
=20
 	ip_set_lock(set);
 	ret =3D set->variant->kadt(set, skb, par, IPSET_DEL, opt);
 	ip_set_unlock(set);
+	ip_set_rcu_put(set);
=20
 	return ret;
 }
@@ -882,6 +896,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t inde=
x, char *name)
 	read_lock_bh(&ip_set_ref_lock);
 	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
 	read_unlock_bh(&ip_set_ref_lock);
+	ip_set_rcu_put(set);
 }
 EXPORT_SYMBOL_GPL(ip_set_name_byindex);
=20
@@ -1348,6 +1363,9 @@ static int ip_set_rename(struct sk_buff *skb, const=
 struct nfnl_info *info,
  * protected by the ip_set_ref_lock. The kernel interfaces
  * do not hold the mutex but the pointer settings are atomic
  * so the ip_set_list always contains valid pointers to the sets.
+ * However after swapping, an userspace set destroy command could
+ * remove a set still processed by kernel side add/del/test.
+ * Therefore we need to wait for the ongoing operations to be finished.
  */
=20
 static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info=
,
@@ -1397,6 +1415,9 @@ static int ip_set_swap(struct sk_buff *skb, const s=
truct nfnl_info *info,
 	ip_set(inst, to_id) =3D from;
 	write_unlock_bh(&ip_set_ref_lock);
=20
+	/* Make sure all readers of the old set pointers are completed. */
+	synchronize_rcu();
+
 	return 0;
 }
=20

Best regards,
Jozsef
--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-331312904-1697534782=:739764--
