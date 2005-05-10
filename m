From: "Mateusz" <mateusz@republika.pl>
Subject: connlimit patch crashes 2.6.11 kernel
Date: Tue, 10 May 2005 09:11:15 +0200
Message-ID: <20050510071032Z2651506-22927+755@kps3.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi

I experience the problem with connlimit patch included in
patch-o-matic-ng
snapshot from 2005.05.04 and earlier.

I have tested it with 2.6.11.7 kernel and iptables-1.3.1, when on
NATed machine
a go to any website or i send any packet from this machine to
internet via my
server - kernel crashes immediately. When any machines don't send
any
packet (I have also tested it with only my machine connect to
switch with server)
kernel is working fine.

Problem does not occur when I don't apply connlimit patch to
kernel.

I rewrite oops dump here.


[<c03b42aa>] ipt_do_table+0x1fa/0x3b0
[<c037b740>] ip_forward_finish+0x0/0x80
[<c03b7b37>] ipt_hook+0x37/0x40
[<c0362651>] nf_iterate+0x37/0x40
[<c037b740>] ip_forward_finish+0x0/0x80
[<c037b740>] ip_forward_finish+0x0/0x80
[<c0362a55>] nf_hook_slow+0x75/0x120
[<c037b740>] ip_forward_finish+0x0/0x80
[<c037b6ee>] ip_forward+0x1ee/0x240
[<c037b740>] ip_forward_finish+0x0/0x80
[<c037a356>] ip_rcv_finish+0x126/0x290
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c0362d1f>] nf_reinject+0x21f/0x260
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c031869b>] imq_dev_xmit+0x4b/0x60
[<c0363c4b>] qdisc_restart+0x8b/0x200
[<c0318777>] imq_nf_queue+0xc7/0x1a0
[<c03628d3>] nf_queue+0x173/0x280
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c0362a8c>] nf_hook_slow+0xac/0x120
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c037a007>] ip_rcv+0x427/0x4f0
[<c037a230>] ip_rcv_finish+0x0/0x290
[<c0135d9a>] do_gettimeofday+0x1a/0xb0
[<c0357446>] netif_receive_skb+0x126/0x1b0
[<c03509a7>] alloc_skb+0x47/0xe0
[<c031a1f2>] rtl8139_rx+0x1a2/0x360
[<c031a5a6>] rtl8139_poll+0x56/0x100
[<c035763a>] net_rx_action+0x6a/0xf0
[<c0149b3b>] __do_softirq+0x7b/0x90
[<c01337a1>] do_softirq+0x41/0x50
=======================
[<c0149c25>] irq_exit+0x35/0x40
[<c0133693>] do_IRQ+0x53/0x80
[<c012f5b0>] default_idle+0x0/0x30
[<c0131b5a>] common_interfupt+0x1a/0x20
[<c012f5b0>] default_idle+0x0/0x30
[<c012f5d4>] default_idle+0x24/0x30
[<c012f66c>] cpu_idle+0x4c/0x60
[<c010f880>] start_kernel+0x150/0x170
[<c010f430>] unknown_bootoption+0x0/0x1e0
[<c012f1b1>] L6+0x0/0x2
Code: 43 17 89 d9 8d 04 40 c1 e0 03 29 c1 89 cd 81 ed a8 00 00 00
74 0d 80 7d 54 07 0f 44 54 24 1c 89 54 24 1c 85 db 0f 84 47 01 00
00 <80> 7d 54 07 0f 84 08 01 00 00 8b 54 24 0c 8b 44 24 4c 23 42
08
<0>Kernel panic - not syncing: Fatal exception in interrupt


I could answer at any question about environement.
Thanks in advance for any reply.

Best regards, Mateusz Pluta

PS: sorry for my poor english
