From: Russell King <rmk@arm.linux.org.uk>
Subject: 2.6.22-rc6: local_bh_enable warning
Date: Sat, 30 Jun 2007 18:08:53 +0100
Message-ID: <20070630170853.GA17467@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Having upgraded from 2.6.16 to 2.6.22-rc6, I'm now seeing the following.

Looks like netfilter is calling local_bh_enable() with IRQs disabled,
which would appear to be illegal.  Thankfully, this is a warn-once
warning.

WARNING: at /home/rmk/git/linux-2.6-rmk/kernel/softirq.c:138 local_bh_enable()
[<c0021c70>] (dump_stack+0x0/0x14) from [<c00358c0>] (local_bh_enable+0x50/0xac)
[<c0035870>] (local_bh_enable+0x0/0xac) from [<bf0090cc>] (nf_nat_cleanup_conntrack+0x54/0x60 [nf_nat])
 r6:c1a9aa00 r5:c1a9aa00 r4:c15bad3c
[<bf009078>] (nf_nat_cleanup_conntrack+0x0/0x60 [nf_nat]) from [<c0146d50>] (destroy_conntrack+0x6c/0x118)
 r4:c15bac58
[<c0146ce4>] (destroy_conntrack+0x0/0x118) from [<c0144820>] (nf_conntrack_destroy+0x24/0x2c)
 r4:c05d2a80
[<c01447fc>] (nf_conntrack_destroy+0x0/0x2c) from [<c012c05c>] (__kfree_skb+0xd0/0x100)
[<c012bf8c>] (__kfree_skb+0x0/0x100) from [<c012c0d8>] (kfree_skb+0x4c/0x50)
 r5:c12a3800 r4:00000300
[<c012c08c>] (kfree_skb+0x0/0x50) from [<bf03cbb0>] (el3_start_xmit+0xb8/0xd0 [3c589_cs])
[<bf03caf8>] (el3_start_xmit+0x0/0xd0 [3c589_cs]) from [<c01324dc>] (dev_hard_start_xmit+0x1a8/0x244)
 r7:c12a3800 r6:c1a9aa00 r5:c1a9aa00 r4:c12a3800
[<c0132334>] (dev_hard_start_xmit+0x0/0x244) from [<c013fcc0>] (__qdisc_run+0xb0/0x198)
 r8:00000000 r7:c12a382c r6:c1a9aa00 r5:00000000 r4:c12a3800
[<c013fc10>] (__qdisc_run+0x0/0x198) from [<c01326dc>] (dev_queue_xmit+0x164/0x234)
 r7:c0ed2560 r6:00000000 r5:c1a9aa00 r4:c12a3800
[<c0132578>] (dev_queue_xmit+0x0/0x234) from [<c01572d0>] (ip_output+0x2c0/0x324)
 r6:0000000e r5:c1a9aa00 r4:00000000
[<c0157010>] (ip_output+0x0/0x324) from [<c0158b94>] (ip_push_pending_frames+0x438/0x53c)
 r7:c05d2a80 r6:00000040 r5:c02e8e40 r4:c11fdc10
[<c015875c>] (ip_push_pending_frames+0x0/0x53c) from [<c0158fa0>] (ip_send_reply+0x1c8/0x22c)
[<c0158dd8>] (ip_send_reply+0x0/0x22c) from [<c016dd2c>] (tcp_v4_send_reset+0x148/0x17c)
[<c016dbe4>] (tcp_v4_send_reset+0x0/0x17c) from [<c016ecb4>] (tcp_v4_do_rcv+0x368/0x3a8)
 r7:22a7d38c r6:c0a71060 r5:c1a9a8c0 r4:c0a71060
[<c016e94c>] (tcp_v4_do_rcv+0x0/0x3a8) from [<c016f2b0>] (tcp_v4_rcv+0x5bc/0x8c4)
[<c016ecf4>] (tcp_v4_rcv+0x0/0x8c4) from [<c0152a30>] (ip_local_deliver+0x188/0x218)
[<c01528a8>] (ip_local_deliver+0x0/0x218) from [<c0153374>] (ip_rcv+0x568/0x5c0)
 r6:c1a9a8c0 r5:c1a9a8c0 r4:c11fd420
[<c0152e0c>] (ip_rcv+0x0/0x5c0) from [<c0132ca8>] (netif_receive_skb+0x268/0x29c)
 r7:c12a3800 r6:00000008 r5:c025d96c r4:c1a9a8c0
[<c0132a40>] (netif_receive_skb+0x0/0x29c) from [<c0132d88>] (process_backlog+0xac/0x18c)
 r8:0002f9af r7:c0241ee8 r6:00000000 r5:c025d60c r4:c12a3800
[<c0132cdc>] (process_backlog+0x0/0x18c) from [<c0132ef8>] (net_rx_action+0x90/0x168)
[<c0132e68>] (net_rx_action+0x0/0x168) from [<c0035750>] (__do_softirq+0x5c/0xc8)
 r8:000189c0 r7:c0257960 r6:0000000a r5:c02579b4 r4:00000001
[<c00356f4>] (__do_softirq+0x0/0xc8) from [<c0035980>] (irq_exit+0x40/0x48)
 r7:00000000 r6:c025c280 r5:c0245950 r4:00000006
[<c0035940>] (irq_exit+0x0/0x48) from [<c001d04c>] (asm_do_IRQ+0x4c/0x60)
[<c001d000>] (asm_do_IRQ+0x0/0x60) from [<c001da28>] (__irq_svc+0x28/0x80)

-- 
Russell King
