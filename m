From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Bug 16317] New: oops in nf_nat_setup_info
Date: Wed, 30 Jun 2010 14:59:54 +0200
Message-ID: <4C2B3FCA.9000505@trash.net>
References: <bug-16317-4010@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: bugzilla-daemon@bugzilla.kernel.org, siim@p6drad-teel.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37702 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab0F3M7z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:59:55 -0400
In-Reply-To: <bug-16317-4010@https.bugzilla.kernel.org/>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=16317
>
>            Summary: oops in nf_nat_setup_info
>            Product: Networking
>            Version: 2.5
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Netfilter/Iptables
>         AssignedTo: networking_netfilter-iptables@kernel-bugs.osdl.org
>         ReportedBy: siim@p6drad-teel.net
>         Regression: No
>
>
> I've gotten the following a few times (twice so far, about once per week) after
> switching singlequeue intel e1000 nics for multiqueue igb nics (also moving
> from 2.6.24.5 -> 2.6.32.10):
>
> [581172.269340] ------------[ cut here ]------------
> [581172.280485] kernel BUG at net/ipv4/netfilter/nf_nat_core.c:300!
>   

NAT is attempting to set up mappings a second time for an existing
conntrack.

> [581172.284503] invalid opcode: 0000 [#1] SMP
> [581172.288497] last sysfs file:
> /sys/devices/pci0000:00/0000:00:09.0/0000:04:00.1/irq
> [581172.300440] CPU 6
> [581172.306337] Modules linked in: ipt_LOG xt_limit ipt_REJECT xt_tcpudp
> xt_mark xt_comment xt_statistic xt_conntrack iptable_nat nf_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 ipt_set xt_MARK iptable_mangle ip_set_iphash
> ip_set iptable_filter ip_tables x_tables ipmi_devintf nf_conntrack_netlink
> nfnetlink bonding nf_conntrack ipmi_si igb ipmi_msghandler dca bnx2
> [581172.345986] Pid: 18507, comm: sh Not tainted 2.6.32.10-noinitrd #1 ProLiant
> DL360 G6
> [581172.358259] RIP: 0010:[<ffffffffa00b26a1>]  [<ffffffffa00b26a1>]
> nf_nat_setup_info+0x7f/0x573 [nf_nat]
> [581172.379289] RSP: 0018:ffff8800282c3b70  EFLAGS: 00010202
> [581172.384767] RAX: 0000000000000001 RBX: ffff8800bedec578 RCX:
> 0000000000000000
> [581172.403478] RDX: ffff8800b3cb0998 RSI: ffff8800282c3c70 RDI:
> ffff8800bedec578
> [581172.423265] RBP: ffff8800282c3c70 R08: ffff8800bedec578 R09:
> ffff88010210eb00
> [581172.439725] R10: ffff88011d3a0e00 R11: ffffc90007aa91c8 R12:
> ffff8800dd3d6400
> [581172.447530] R13: ffff8800bedec578 R14: 0000000000000002 R15:
> 0000000000000000
> [581172.454798] FS:  0000000000000000(0000) GS:ffff8800282c0000(0000)
> knlGS:0000000000000000
> [581172.473152] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [581172.481398] CR2: 00007faced36ed50 CR3: 00000000912b5000 CR4:
> 00000000000006e0
> [581172.504086] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [581172.515060] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [581172.529246] Process sh (pid: 18507, threadinfo ffff8800349fc000, task
> ffff88011e25e300)
> [581172.536664] Stack:
> [581172.542552]  ffffc90007aa9000 ffffc90007aa9010 ffff88007c675e00
> 0000000000000128
> [581172.546630] <0> ffffffff8177c5e0 ffffffff813da3bd 0000000000000004
> ffff88011e0b7000
> [581172.561632] <0> 0000000000000000 000000048164cf20 0000000000000000
> ffff88011e0b7000
> [581172.581289] Call Trace:
> [581172.594094]  <IRQ>
> [581172.595386]  [<ffffffff813da3bd>] ? udp_conn_out_get+0x87/0x92
> [581172.603532]  [<ffffffffa00bc120>] ? alloc_null_binding+0x47/0x4c
> [iptable_nat]
> [581172.611137]  [<ffffffffa00bc34e>] ? nf_nat_fn+0x11a/0x14d [iptable_nat]
> [581172.624376]  [<ffffffffa00bc477>] ? nf_nat_out+0x3c/0xb0 [iptable_nat]
> [581172.633493]  [<ffffffff813cee4e>] ? nf_iterate+0x41/0x7d
> [581172.643783]  [<ffffffff813e4756>] ? ip_finish_output+0x0/0x297
> [581172.647668]  [<ffffffff813ceeec>] ? nf_hook_slow+0x62/0xc3
> [581172.652001]  [<ffffffff813e4756>] ? ip_finish_output+0x0/0x297
> [581172.669876]  [<ffffffff813e4a8a>] ? ip_output+0x9d/0xb3
> [581172.673195]  [<ffffffff813dfadf>] ? ip_rcv_finish+0x373/0x38d
> [581172.677529]  [<ffffffff813dfd99>] ? ip_rcv+0x2a0/0x2ed
> [581172.684019]  [<ffffffffa002b604>] ? igb_poll+0x54e/0x86a [igb]
> [581172.690275]  [<ffffffff813b4712>] ? net_rx_action+0xa2/0x17a
> [581172.702637]  [<ffffffff81042d94>] ? __do_softirq+0x8b/0x107
> [581172.711844]  [<ffffffff8100c9bc>] ? call_softirq+0x1c/0x28
> [581172.719905]  [<ffffffff8100e399>] ? do_softirq+0x31/0x66
> [581172.730570]  [<ffffffff8100da9e>] ? do_IRQ+0xa0/0xb6
> [581172.738723]  [<ffffffff8100c253>] ? ret_from_intr+0x0/0xa
> [581172.749714]  <EOI>
> [581172.751032]  [<ffffffff81095555>] ? page_remove_rmap+0x8/0x25
> [581172.773691]  [<ffffffff8108d30c>] ? unmap_vmas+0x50f/0x8d4
> [581172.784991]  [<ffffffff8109180a>] ? exit_mmap+0xa5/0x127
> [581172.793770]  [<ffffffff8103c27e>] ? mmput+0x34/0xca
> [581172.796635]  [<ffffffff810b2565>] ? flush_old_exec+0x4d6/0x5c2
> [581172.805084]  [<ffffffff810ae1aa>] ? vfs_read+0x131/0x166
> [581172.817333]  [<ffffffff810e4fb2>] ? load_elf_binary+0x35a/0x1888
> [581172.824178]  [<ffffffff8108cdaa>] ? follow_page+0x266/0x2b9
> [581172.835566]  [<ffffffff8108cdaa>] ? follow_page+0x266/0x2b9
> [581172.848510]  [<ffffffff810e2a58>] ? load_misc_binary+0x5d/0x308
> [581172.855035]  [<ffffffff810b18c0>] ? get_arg_page+0x4b/0xa4
> [581172.858149]  [<ffffffff810b1ccc>] ? search_binary_handler+0xdc/0x26b
> [581172.862855]  [<ffffffff810b3153>] ? do_execve+0x215/0x30f
> [581172.868522]  [<ffffffff8100a4f2>] ? sys_execve+0x35/0x4c
> [581172.879439]  [<ffffffff8100bd4a>] ? stub_execve+0x6a/0xc0
> [581172.887665] Code: 4c 89 ef e8 2c 43 fa ff 48 85 c0 0f 84 dd 04 00 00 45 85
> ff 49 8b 45 78 75 06 48 c1 e8 07 eb 04 48 c1 e8 08 83 e0 01 85 c0 74 04 <0f> 0b
> eb fe 48 8d bc 24 90 00 00 00 49 8d 75 50 e8 46 f8 f9 ff
> [581172.900930] RIP  [<ffffffffa00b26a1>] nf_nat_setup_info+0x7f/0x573 [nf_nat]
> [581172.911971]  RSP <ffff8800282c3b70>
> [581172.914326] ---[ end trace ef33146fce302ddf ]---
> [581172.919418] Kernel panic - not syncing: Fatal exception in interrupt
> [581172.935238] Pid: 18507, comm: sh Tainted: G      D    2.6.32.10-noinitrd #1
> [581172.941620] Call Trace:
> [581172.943447]  <IRQ>  [<ffffffff8145b6d2>] ? panic+0x86/0x136
> [581172.949940]  [<ffffffff8100c3b3>] ? apic_timer_interrupt+0x13/0x20
> [581172.960766]  [<ffffffff8100f528>] ? oops_end+0x61/0xac
> [581172.974773]  [<ffffffff8100f566>] ? oops_end+0x9f/0xac
> [581172.979696]  [<ffffffff8100d42b>] ? do_invalid_op+0x85/0x8f
> [581172.982898]  [<ffffffffa00b26a1>] ? nf_nat_setup_info+0x7f/0x573 [nf_nat]
> [581172.991136]  [<ffffffff810bbd60>] ? pollwake+0x53/0x5b
> [581173.001130]  [<ffffffff8103ae35>] ? default_wake_function+0x0/0x9
> [581173.011734]  [<ffffffffa0081412>] ? ip_set_testip_kernel+0x5f/0x70 [ip_set]
> [581173.019268]  [<ffffffff8100c655>] ? invalid_op+0x15/0x20
> [581173.027347]  [<ffffffffa00b26a1>] ? nf_nat_setup_info+0x7f/0x573 [nf_nat]
> [581173.035213]  [<ffffffff813da3bd>] ? udp_conn_out_get+0x87/0x92
> [581173.046448]  [<ffffffffa00bc120>] ? alloc_null_binding+0x47/0x4c
> [iptable_nat]
> [581173.051585]  [<ffffffffa00bc34e>] ? nf_nat_fn+0x11a/0x14d [iptable_nat]
> [581173.055327]  [<ffffffffa00bc477>] ? nf_nat_out+0x3c/0xb0 [iptable_nat]
> [581173.067511]  [<ffffffff813cee4e>] ? nf_iterate+0x41/0x7d
> [581173.078859]  [<ffffffff813e4756>] ? ip_finish_output+0x0/0x297
> [581173.092105]  [<ffffffff813ceeec>] ? nf_hook_slow+0x62/0xc3
> [581173.113089]  [<ffffffff813e4756>] ? ip_finish_output+0x0/0x297
> [581173.125995]  [<ffffffff813e4a8a>] ? ip_output+0x9d/0xb3
> [581173.141463]  [<ffffffff813dfadf>] ? ip_rcv_finish+0x373/0x38d
> [581173.152258]  [<ffffffff813dfd99>] ? ip_rcv+0x2a0/0x2ed
> [581173.177490]  [<ffffffffa002b604>] ? igb_poll+0x54e/0x86a [igb]
> [581173.192157]  [<ffffffff813b4712>] ? net_rx_action+0xa2/0x17a
> [581173.203036]  [<ffffffff81042d94>] ? __do_softirq+0x8b/0x107
> [581173.216455]  [<ffffffff8100c9bc>] ? call_softirq+0x1c/0x28
> [581173.229748]  [<ffffffff8100e399>] ? do_softirq+0x31/0x66
> [581173.240130]  [<ffffffff8100da9e>] ? do_IRQ+0xa0/0xb6
> [581173.248723]  [<ffffffff8100c253>] ? ret_from_intr+0x0/0xa
> [581173.257027]  <EOI>  [<ffffffff81095555>] ? page_remove_rmap+0x8/0x25
> [581173.264045]  [<ffffffff8108d30c>] ? unmap_vmas+0x50f/0x8d4
> [581173.283148]  [<ffffffff8109180a>] ? exit_mmap+0xa5/0x127
> [581173.300061]  [<ffffffff8103c27e>] ? mmput+0x34/0xca
> [581173.302792]  [<ffffffff810b2565>] ? flush_old_exec+0x4d6/0x5c2
> [581173.315762]  [<ffffffff810ae1aa>] ? vfs_read+0x131/0x166
> [581173.327459]  [<ffffffff810e4fb2>] ? load_elf_binary+0x35a/0x1888
> [581173.342685]  [<ffffffff8108cdaa>] ? follow_page+0x266/0x2b9
> [581173.348121]  [<ffffffff8108cdaa>] ? follow_page+0x266/0x2b9
> [581173.361690]  [<ffffffff810e2a58>] ? load_misc_binary+0x5d/0x308
> [581173.375648]  [<ffffffff810b18c0>] ? get_arg_page+0x4b/0xa4
> [581173.382023]  [<ffffffff810b1ccc>] ? search_binary_handler+0xdc/0x26b
> [581173.391139]  [<ffffffff810b3153>] ? do_execve+0x215/0x30f
> [581173.400584]  [<ffffffff8100a4f2>] ? sys_execve+0x35/0x4c
> [581173.406051]  [<ffffffff8100bd4a>] ? stub_execve+0x6a/0xc0
>
> Sadly, i'm not good enough to debug this myself but I'll do my best to try any
> scenarios/patches/versions/configurations or give any kind of extra info if
> needed.
>
> some background info:
> the machine this happened on is doing SNAT and DNAT (for pretty much every
> connection) at up to 60Kpps and 150K conntrack entries. Also, 2 conntrackd
> daemons are running, one synchronizing conntracks to a failover node and the
> other writing out stats. We're also running conntrackd -c every minute to keep
> long-running connections working immediately after failover.
>   

So the failover node is purely passive and is not synchronizing connections
back to the one which is crashing? That would rule out a race condition
between creating a new conntrack using ctnetlink and the lookup done during
packet processing.

I can't spot the problem right now, but it would be interesting whether
this still happens without running the (synchronizing) conntrack daemon.

> Other somewhat weird stuff started happening after the NIC (and kernel) switch
> - conntrackd (the syncing one) started going up in memory consumption (almost
> up to 4GB in a few hours) and the rate of UDP inErrors went up (up to 1.5K/sec
> at times).
>
>   

