From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink_queue: use hash table to speed up entry
	finding.
Date: Thu, 15 Apr 2010 23:11:34 +0800
Message-ID: <m2l412e6f7f1004150811p3009f238if492b139770a0ea8@mail.gmail.com>
References: <4BBEA97A.5020303@gmail.com> <1271164991.16881.346.camel@edumazet-laptop>
	<4BC470B3.4030007@trash.net> <h2n412e6f7f1004142353uac023edfqc59d076c0d8a1784@mail.gmail.com>
	<4BC6EC15.4070205@trash.net> <t2t412e6f7f1004150735l54619e32t3e7fcdce7b118bd9@mail.gmail.com>
	<4BC72572.1050507@trash.net> <4BC726B4.1030003@trash.net>
	<j2w412e6f7f1004150801m66503602wbd0296c09aa45e90@mail.gmail.com>
	<4BC72B2B.9010104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:39573 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab0DOPLy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:11:54 -0400
Received: by pzk42 with SMTP id 42so1142065pzk.4
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Apr 2010 08:11:54 -0700 (PDT)
In-Reply-To: <4BC72B2B.9010104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 15, 2010 at 11:05 PM, Patrick McHardy <kaber@trash.net> wro=
te:
>
> No its not:
>
> static void nfnetlink_rcv(struct sk_buff *skb)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0nfnl_lock();
> =C2=A0 =C2=A0 =C2=A0 =C2=A0netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0nfnl_unlock();
> }
>
>

static int
nfqnl_rcv_nl_event(struct notifier_block *this,
                   unsigned long event, void *ptr)
{
        struct netlink_notify *n =3D ptr;

        if (event =3D=3D NETLINK_URELEASE && n->protocol =3D=3D NETLINK=
_NETFILTER) {
                int i;

                /* destroy all instances for this pid */
                spin_lock(&instances_lock);
                for (i =3D 0; i < INSTANCE_BUCKETS; i++) {
                        struct hlist_node *tmp, *t2;
                        struct nfqnl_instance *inst;
                        struct hlist_head *head =3D &instance_table[i];

                        hlist_for_each_entry_safe(inst, tmp, t2, head, =
hlist) {
                                if ((n->net =3D=3D &init_net) &&
                                    (n->pid =3D=3D inst->peer_pid))
                                        __instance_destroy(inst);
                        }
                }
                spin_unlock(&instances_lock);
        }
        return NOTIFY_DONE;
}

static struct notifier_block nfqnl_rtnl_notifier =3D {
        .notifier_call  =3D nfqnl_rcv_nl_event,
};

=2E..

netlink_register_notifier(&nfqnl_rtnl_notifier);

=2E..

int netlink_register_notifier(struct notifier_block *nb)
{
        return atomic_notifier_chain_register(&netlink_chain, nb);
}

=2E..

static int netlink_release(struct socket *sock)
{
        struct sock *sk =3D sock->sk;
        struct netlink_sock *nlk;

        if (!sk)
                return 0;

        netlink_remove(sk);
        sock_orphan(sk);
        nlk =3D nlk_sk(sk);

        /*
         * OK. Socket is unlinked, any packets that arrive now
         * will be purged.
         */

        sock->sk =3D NULL;
        wake_up_interruptible_all(&nlk->wait);

        skb_queue_purge(&sk->sk_write_queue);

        if (nlk->pid) {
                struct netlink_notify n =3D {
                                                .net =3D sock_net(sk),
                                                .protocol =3D sk->sk_pr=
otocol,
                                                .pid =3D nlk->pid,
                                          };
                atomic_notifier_call_chain(&netlink_chain,
                                NETLINK_URELEASE, &n);
        }

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
