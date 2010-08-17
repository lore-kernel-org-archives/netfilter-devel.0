From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: 2.6.36-rc1 ip6tables-resto: inconsistent lock state
Date: Tue, 17 Aug 2010 19:18:44 +0200
Message-ID: <1282065524.2448.117.camel@edumazet-laptop>
References: <4C6AC2F8.90307@odi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0HQRSu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:18:50 -0400
In-Reply-To: <4C6AC2F8.90307@odi.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 17 ao=C3=BBt 2010 =C3=A0 19:12 +0200, Ortwin Gl=C3=BCck a =C3=A9=
crit :
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: inconsistent lock state ]
> 2.6.36-rc1 #1
> ---------------------------------
> inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> ip6tables-resto/3098 [HC0[0]:SC0[0]:HE1:SE1] takes:
>  (&(&lock->lock)->rlock){+.?...}, at: [<c152ae2c>] get_counters+0xcc/=
0x160
> {IN-SOFTIRQ-W} state was registered at:
>   [<c108df53>] __lock_acquire+0x9b3/0x1850
>   [<c108ee54>] lock_acquire+0x64/0x80
>   [<c159817d>] _raw_spin_lock+0x3d/0x50
>   [<c152b99f>] ip6t_do_table+0x5f/0x440
>   [<c152c932>] ip6table_filter_hook+0x22/0x30
>   [<c148e5f1>] nf_iterate+0x71/0x90
>   [<c148e90f>] nf_hook_slow+0xcf/0x120
>   [<c151c996>] mld_sendpack+0x276/0x4d0
>   [<c151d338>] mld_ifc_timer_expire+0x258/0x2f0
>   [<c106bd70>] run_timer_softirq+0x130/0x280
>   [<c10668b1>] __do_softirq+0x91/0x130
>   [<c10669ad>] do_softirq+0x5d/0x70
>   [<c1066bd5>] irq_exit+0x75/0x80
>   [<c1042166>] smp_apic_timer_interrupt+0x56/0x90
>   [<c159927f>] apic_timer_interrupt+0x2f/0x34
>   [<c159817d>] _raw_spin_lock+0x3d/0x50
>   [<c10fa92a>] __d_lookup+0xca/0x160
>   [<c10f095d>] do_lookup+0x3d/0x1c0
>   [<c10f2706>] link_path_walk+0x3a6/0xa40
>   [<c10f2ea4>] path_walk+0x44/0xa0
>   [<c10f2fd1>] do_path_lookup+0x51/0x60
>   [<c10f3acc>] user_path_at+0x3c/0x80
>   [<c10e6e0a>] sys_faccessat+0x9a/0x180
>   [<c10e6f10>] sys_access+0x20/0x30
>   [<c1598e25>] syscall_call+0x7/0xb
> irq event stamp: 5463
> hardirqs last  enabled at (5463): [<c1066d22>] local_bh_enable+0x62/0=
xe0
> hardirqs last disabled at (5461): [<c1066ce4>] local_bh_enable+0x24/0=
xe0
> softirqs last  enabled at (5462): [<c152addd>] get_counters+0x7d/0x16=
0
> softirqs last disabled at (5460): [<c152ad86>] get_counters+0x26/0x16=
0
>=20
> other info that might help us debug this:
> 2 locks held by ip6tables-resto/3098:
>  #0:  (sk_lock-AF_INET6){+.+.+.}, at: [<c150ea18>] ipv6_getsockopt+0x=
98/0xe0
>  #1:  (&xt[i].mutex){+.+.+.}, at: [<c149f8fc>] xt_find_table_lock+0x2=
c/0xe0
>=20
> stack backtrace:
> Pid: 3098, comm: ip6tables-resto Not tainted 2.6.36-rc1 #1
> Call Trace:
>  [<c1594e46>] ? printk+0x18/0x1a
>  [<c108be3c>] print_usage_bug+0x15c/0x1a0
>  [<c108c225>] mark_lock+0x3a5/0x5b0
>  [<c108cbb0>] ? check_usage_backwards+0x0/0xe0
>  [<c108df94>] __lock_acquire+0x9f4/0x1850
>  [<c11df263>] ? rb_insert_color+0xd3/0x110
>  [<c10e1fdf>] ? __kmalloc+0x6f/0xf0
>  [<c108ee54>] lock_acquire+0x64/0x80
>  [<c152ae2c>] ? get_counters+0xcc/0x160
>  [<c159817d>] _raw_spin_lock+0x3d/0x50
>  [<c152ae2c>] ? get_counters+0xcc/0x160
>  [<c152ae2c>] get_counters+0xcc/0x160
>  [<c152c37d>] do_ip6t_get_ctl+0x1ad/0x2d0
>  [<c159691a>] ? mutex_lock_interruptible_nested+0x23a/0x3c0
>  [<c148fd35>] nf_sockopt+0x105/0x180
>  [<c1066d0a>] ? local_bh_enable+0x4a/0xe0
>  [<c148fdd4>] nf_getsockopt+0x24/0x30
>  [<c150ea33>] ipv6_getsockopt+0xb3/0xe0
>  [<c1516bab>] rawv6_getsockopt+0x3b/0x170
>  [<c10c8efa>] ? might_fault+0x5a/0xb0
>  [<c1468692>] sock_common_getsockopt+0x22/0x30
>  [<c1466bcc>] sys_getsockopt+0x4c/0xa0
>  [<c14680bc>] sys_socketcall+0xfc/0x270
>  [<c1029010>] sysenter_do_call+0x12/0x36
>=20
>=20
> Full log attached.


Yes, this is the fourth time it is reported here ;)

http://marc.info/?l=3Dlinux-kernel&m=3D128199018321130&w=3D2

Thanks




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
