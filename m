From: Krzysztof Oledzki <olenf@ans.pl>
Subject: nfnetlink/ctnetlink - OOPS&panic
Date: Tue, 19 Apr 2005 12:31:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-869831779-1113906691=:27543"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-869831779-1113906691=:27543
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I have just compiled 2.6.11.7 kernel with nfnetlink/ctnetlink support=20
(from pom-ng-20050418). Unfortunately, during system startup, kernel=20
panics:

Unable to handle kernel NULL pointer dereference at virtual address 000000b=
3
  printing eip:
*pde =3D 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: bonding
CPU:    0
EIP:    0060:[<c037d8f3>]    Not tainted VLI
EFLAGS: 00010246   (2.6.11.7)
EIP is at netlink_broadcast+0xb3/0x390
eax: 00000000   ebx: 00000000   ecx: 00000001   edx: 00000001
esi: 00000000   edi: 00000000   ebp: 00000000   esp: c05a4cf8
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=3Dc05a4000 task=3Dc04c0b20)
Stack: df4c5760 00000000 fffff0e4 00000020 df4c5760 00000000 00000000 00000=
002
        00000000 00000000 00000000 00000020 df4c5760 00000000 c05a4d68 0000=
0000
        c0121b53 df4c5760 00000000 00000000 00000000 c03e371a 00000000 df4c=
5760
Call Trace:
  [<c0121b53>] local_bh_enable+0x33/0x90
  [<c03e371a>] nfnetlink_send+0x6a/0xb0
  [<c03c38e3>] ctnetlink_conntrack_event+0x323/0x460
  [<c03caf43>] ip_nat_setup_info+0x83/0x230
  [<c0125715>] __mod_timer+0x135/0x1c0
  [<c0121b53>] local_bh_enable+0x33/0x90
  [<c03bfc9d>] __ip_conntrack_confirm+0x21d/0x310
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c012a2ad>] notifier_call_chain+0x2d/0x50
  [<c03bec78>] ip_confirm+0x98/0xd0
  [<c03638ba>] nf_iterate+0x7a/0xb0
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c0363cb2>] nf_hook_slow+0x82/0x130
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c03842a0>] ip_local_deliver+0x250/0x280
  [<c0384790>] ip_local_deliver_finish+0x0/0x1f0
  [<c0384aa9>] ip_rcv_finish+0x129/0x2a0
  [<c0384980>] ip_rcv_finish+0x0/0x2a0
  [<c0384980>] ip_rcv_finish+0x0/0x2a0
  [<c0363d28>] nf_hook_slow+0xf8/0x130
  [<c0384980>] ip_rcv_finish+0x0/0x2a0
  [<c0384980>] ip_rcv_finish+0x0/0x2a0
  [<c03846cc>] ip_rcv+0x3fc/0x4c0
  [<c0384980>] ip_rcv_finish+0x0/0x2a0
  [<c03587d7>] netif_receive_skb+0x147/0x1d0
  [<c03588df>] process_backlog+0x7f/0x100
  [<c03589d4>] net_rx_action+0x74/0x100
  [<c0121b06>] __do_softirq+0x76/0x90
  [<c01056f1>] do_softirq+0x41/0x50
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  [<c0121be5>] irq_exit+0x35/0x40
  [<c01055ee>] do_IRQ+0x4e/0x70
  [<c0103b1e>] common_interrupt+0x1a/0x20
  [<c0101053>] default_idle+0x23/0x30
  [<c01010f0>] cpu_idle+0x50/0x60
  [<c052b7fe>] start_kernel+0x14e/0x170
  [<c052b3a0>] unknown_bootoption+0x0/0x1e0
Code: 01 00 00 00 e8 cf bb d9 ff ff 05 04 81 5e c0 b8 01 00 00 00 e8 ff bb =
d9 ff b8 00 f0 ff ff 21 e0 8b 40 08 a8 08 0f 85 4d 02 00 00 <0f> b6 85 b3 0=
0 00 00 8b 15 08 81 5e c0 8d 04 c0 c1 e0 02 01 d0
  <0>Kernel panic - not syncing: Fatal exception in interrupt

It happens shortly after networks devices initialization.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-869831779-1113906691=:27543--
