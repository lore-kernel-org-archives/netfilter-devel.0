From: Hans Schillstrom <hans.schillstrom@ericsson.com>
Subject: Re: conntrack, suspicious RCU usage
Date: Wed, 11 Jan 2012 14:24:26 +0100
Message-ID: <201201111424.27282.hans.schillstrom@ericsson.com>
References: <201201111025.50994.hans.schillstrom@ericsson.com> <1326276111.2767.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:45932 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2AKNYa convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:24:30 -0500
In-Reply-To: <1326276111.2767.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 11 January 2012 11:01:51 Eric Dumazet wrote:
> Le mercredi 11 janvier 2012 =C3=A0 10:25 +0100, Hans Schillstrom a =C3=
=A9crit :
> > Hello
> > I got this the first time using conntrack -L when there is a lot of=
 traffic.
> > It doesn't result in any thing bad yet.
> >=20
> > Is this a know thing ?
> > or should I dig into it..
> >=20
> > I'm running the latest and greatest conntrack / netfilter tools and=
 libs.
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > [ INFO: suspicious RCU usage. ]
> > -------------------------------
> > /home/hans/evip.git/kvm/net-next.git/include/net/netfilter/nf_connt=
rack_l3proto.h:92 suspicious rcu_dereference_check() usage!
> >=20
> > other info that might help us debug this:
> >=20
> >=20
> > rcu_scheduler_active =3D 1, debug_locks =3D 0
> > 3 locks held by conntrack/2249:
> >  #0:  (nfnl_mutex){+.+.+.}, at: [<ffffffff812cd29f>] nfnl_lock+0x17=
/0x19
> >  #1:  (nlk->cb_mutex){+.+.+.}, at: [<ffffffff812c7211>] netlink_dum=
p+0x27/0x1ec
> >  #2:  (nf_conntrack_lock){+.-...}, at: [<ffffffffa00b8922>] 0xfffff=
fffa00b8922
> >=20
> > stack backtrace:
> > Pid: 2249, comm: conntrack Tainted: G        W    3.2.0+ #34
> > Call Trace:
> >  [<ffffffff8102ee61>] ? console_unlock+0x164/0x20c
> >  [<ffffffff81078542>] lockdep_rcu_suspicious+0xd8/0xe1
> >  [<ffffffffa00b78aa>] 0xffffffffa00b78a9
> >  [<ffffffffa00b819c>] 0xffffffffa00b819b
> >  [<ffffffffa00b898f>] 0xffffffffa00b898e
> >  [<ffffffff812c725e>] netlink_dump+0x74/0x1ec
> >  [<ffffffffa00b88e4>] ? 0xffffffffa00b88e3
> >  [<ffffffff812c7a43>] netlink_dump_start+0x103/0x135
> >  [<ffffffffa00b77fa>] ? 0xffffffffa00b77f9
> >  [<ffffffffa00b86a8>] 0xffffffffa00b86a7
> >  [<ffffffff812cd29f>] ? nfnl_lock+0x17/0x19
> >  [<ffffffff812cd734>] nfnetlink_rcv_msg+0x493/0x4cd
> >  [<ffffffff812cd3bc>] ? nfnetlink_rcv_msg+0x11b/0x4cd
> >  [<ffffffff812cd359>] ? nfnetlink_rcv_msg+0xb8/0x4cd
> >  [<ffffffff812c6c51>] ? netlink_lookup+0xc4/0xcf
> >  [<ffffffff812cd2a1>] ? nfnl_lock+0x19/0x19
> >  [<ffffffff812c87d2>] netlink_rcv_skb+0x43/0x94
> >  [<ffffffff812cd207>] nfnetlink_rcv+0x15/0x17
> >  [<ffffffff812c853a>] netlink_unicast+0x13d/0x1b4
> >  [<ffffffff812c8e32>] netlink_sendmsg+0x201/0x269
> >  [<ffffffff812962ef>] sock_sendmsg+0xea/0x109
> >  [<ffffffff81077fdf>] ? lock_release_holdtime+0xfd/0x102
> >  [<ffffffff810e2755>] ? might_fault+0x40/0x90
> >  [<ffffffff810e2755>] ? might_fault+0x40/0x90
> >  [<ffffffff810e2755>] ? might_fault+0x40/0x90
> >  [<ffffffff810e279e>] ? might_fault+0x89/0x90
> >  [<ffffffff810e2755>] ? might_fault+0x40/0x90
> >  [<ffffffff812948ec>] ? move_addr_to_kernel+0x3f/0x56
> >  [<ffffffff81296a65>] sys_sendto+0x102/0x12a
> >  [<ffffffff810faf10>] ? kmem_cache_free+0xc7/0x1b2
> >  [<ffffffff81079651>] ? trace_hardirqs_on+0xd/0xf
> >  [<ffffffff813ba612>] system_call_fastpath+0x16/0x1b
> >=20
> >=20
>=20
> Hmm, we either need to take rcu_read_lock() while calling
> __nf_ct_l3proto_find(), or define a variant using
> rcu_dereference_protected() in places we hold nf_conntrack_lock
>=20
I made a qick test with locks /unlocks in
__nf_ct_l3proto_find() and __nf_ct_l4proto_find()

	rcu_read_lock();
=2E..
	rcu_read_unlock();
	return retp;

It seems to help, I cant see the dump anymore and everything else that =
I run works ...


--=20
Regards
Hans Schillstrom <hans.schillstrom@ericsson.com>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
