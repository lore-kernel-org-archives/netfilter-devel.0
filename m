From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2.6.20 09/10] nfnetlink_log: fix NULL pointer dereference
Date: Mon, 12 Feb 2007 01:40:30 +0100
Message-ID: <20070212004030.GJ8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964796AbXBLJJg@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46ix the nasty NULL dereference on multiple packets per netlink messag=
e.

BUG: unable to handle kernel NULL pointer dereference at virtual addres=
s 00000004
 printing eip:
f8a4b3bf
*pde =3D 00000000
Oops: 0002 [#1]
SMP=20
Modules linked in: nfnetlink_log ipt_ttl ipt_REDIRECT xt_tcpudp iptable=
_nat nf_nat nf_conntrack_ipv4 xt_state ipt_ipp2p xt_NFLOG xt_hashlimit =
ip6_tables iptable_filter xt_multiport xt_mark ipt_set iptable_raw xt_M=
ARK iptable_mangle ip_tables cls_fw cls_u32 sch_esfq sch_htb ip_set_ipm=
ap ip_set ipt_ULOG x_tables dm_snapshot dm_mirror loop e1000 parport_pc=
 parport e100 floppy ide_cd cdrom
CPU:    0
EIP:    0060:[<f8a4b3bf>]    Not tainted VLI
EFLAGS: 00010206   (2.6.20 #5)
EIP is at __nfulnl_send+0x24/0x51 [nfnetlink_log]
eax: 00000000   ebx: f2b5cbc0   ecx: c03f5f54   edx: c03f4000
esi: f2b5cbc8   edi: c03f5f54   ebp: f8a4b3ec   esp: c03f5f30
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, ti=3Dc03f4000 task=3Dc03bece0 task.ti=3Dc03f40=
00)
Stack: f2b5cbc0 f8a4b401 00000100 c0444080 c012af49 00000000 f6f19100 f=
6f19000=20
       c1707800 c03f5f54 c03f5f54 00000123 00000021 c03e8d08 c0426380 0=
0000009=20
       c0126932 00000000 00000046 c03e9980 c03e6000 0047b007 c01269bd 0=
0000000=20
Call Trace:
 [<f8a4b401>] nfulnl_timer+0x15/0x25 [nfnetlink_log]
 [<c012af49>] run_timer_softirq+0x10a/0x164
 [<c0126932>] __do_softirq+0x60/0xba
 [<c01269bd>] do_softirq+0x31/0x35
 [<c0104f6e>] do_IRQ+0x62/0x74
 [<c01036cb>] common_interrupt+0x23/0x28
 [<c0101018>] default_idle+0x0/0x3f
 [<c0101045>] default_idle+0x2d/0x3f
 [<c01010fa>] cpu_idle+0xa0/0xb9
 [<c03fb7f5>] start_kernel+0x1a8/0x1ac
 [<c03fb293>] unknown_bootoption+0x0/0x181
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 5e 5f 5b 5e 5f 5d c3 53 89 c3 8d 40 1c 83 7b 1c 00 74 05 e8 2c ee=
 6d c7 83 7b 14 00 75 04 31 c0 eb 34 83 7b 10 01 76 09 8b 43 18 <66> c7=
 40 04 03 00 8b 53 34 8b 43 14 b9 40 00 00 00 e8 08 9a 84=20
EIP: [<f8a4b3bf>] __nfulnl_send+0x24/0x51 [nfnetlink_log] SS:ESP 0068:c=
03f5f30
 <0>Kernel panic - not syncing: Fatal exception in interrupt
 <0>Rebooting in 5 seconds..

Panic no more!

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.7	2007-02-11 22:41:18.00=
0000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 23:59:01.0000=
00000 +0100
@@ -560,6 +560,7 @@ __build_packet_message(struct nfulnl_ins
 	}
 	=09
 	nlh->nlmsg_len =3D inst->skb->tail - old_tail;
+	inst->lastnlh =3D nlh;
 	return 0;
=20
 nlmsg_failure:
