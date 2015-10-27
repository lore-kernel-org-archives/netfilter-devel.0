From: Munehisa Kamata <kamatam@amazon.com>
Subject: [PATCH] netfilter: add missing NULL pointer check
Date: Mon, 26 Oct 2015 19:10:52 -0700
Message-ID: <1445911852-4838-1-git-send-email-kamatam@amazon.com>
Cc: msw@amazon.com, aliguori@amazon.com, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu, davem@davemloft.net,
	Munehisa Kamata <kamatam@amazon.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:27376 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbJ0CM3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 22:12:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 8b13eddfdf04cbfa561725cfc42d6868fe896f56 ("netfilter: refactor NAT
redirect IPv4 to use it from nf_tables") has introduced a trivial logic
change which can result in the following crash.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffffa033002d>] nf_nat_redirect_ipv4+0x2d/0xa0 [nf_nat_redirect]
PGD 3ba662067 PUD 3ba661067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: ipv6(E) xt_REDIRECT(E) nf_nat_redirect(E) xt_tcpudp(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) ip_tables(E) x_tables(E) binfmt_misc(E) xfs(E) libcrc32c(E) evbug(E) evdev(E) psmouse(E) i2c_piix4(E) i2c_core(E) acpi_cpufreq(E) button(E) ext4(E) crc16(E) jbd2(E) mbcache(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
CPU: 0 PID: 2536 Comm: ip Tainted: G            E   4.1.7-15.23.amzn1.x86_64 #1
Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/06/2015
task: ffff8800eb438000 ti: ffff8803ba664000 task.ti: ffff8803ba664000
RIP: 0010:[<ffffffffa033002d>]  [<ffffffffa033002d>] nf_nat_redirect_ipv4+0x2d/0xa0 [nf_nat_redirect]
RSP: 0018:ffff8803cfc039c8  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8803ba4c9400 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff8803ba4c94c0 RDI: ffff8803bb204000
RBP: ffff8803cfc039f8 R08: ffff8803be069000 R09: ffff8803ba4c9400
R10: ffff8803ba4c94a0 R11: ffffffffa02e3ad8 R12: ffff8803bdb2f3ce
R13: ffff8803be069000 R14: ffff8803ba4c94a0 R15: ffff8803be076600
FS:  00007f94bf8ee740(0000) GS:ffff8803cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000030 CR3: 00000003bdcaf000 CR4: 00000000001406f0
Stack:
 ffffffff00000000 0000000000000246 0000002000000002 ffff8803ba4c9400
 ffff8803bdb2f3ce ffff8803be069000 ffff8803cfc03a08 ffffffffa0334065
 ffff8803cfc03b48 ffffffffa02e2e99 00008803cfc03a48 0000000000000000
Call Trace:
 <IRQ>
 [<ffffffffa0334065>] redirect_tg4+0x15/0x20 [xt_REDIRECT]
 [<ffffffffa02e2e99>] ipt_do_table+0x2b9/0x5e1 [ip_tables]
 [<ffffffffa0328045>] iptable_nat_do_chain+0x25/0x30 [iptable_nat]
 [<ffffffffa031777d>] nf_nat_ipv4_fn+0x13d/0x1f0 [nf_nat_ipv4]
 [<ffffffffa0328020>] ? iptable_nat_ipv4_fn+0x20/0x20 [iptable_nat]
 [<ffffffffa031785e>] nf_nat_ipv4_in+0x2e/0x90 [nf_nat_ipv4]
 [<ffffffffa03280a5>] iptable_nat_ipv4_in+0x15/0x20 [iptable_nat]
 [<ffffffff81449137>] nf_iterate+0x57/0x80
 [<ffffffff814491f7>] nf_hook_slow+0x97/0x100
 [<ffffffff814504d4>] ip_rcv+0x314/0x400
 [<ffffffff81402302>] ? reqsk_fastopen_remove+0x102/0x160
 [<ffffffff8144fa50>] ? inet_del_offload+0x40/0x40
 [<ffffffff81416243>] __netif_receive_skb_core+0x6c3/0x9a0
 [<ffffffff81416538>] __netif_receive_skb+0x18/0x60
 [<ffffffff814165a3>] netif_receive_skb_internal+0x23/0x90
 [<ffffffff814171e8>] napi_gro_receive+0xc8/0x100
 [<ffffffff813b2d94>] xennet_poll+0x934/0xbb0
 [<ffffffff813862c6>] ? add_interrupt_randomness+0x176/0x1e0
 [<ffffffff814169f9>] net_rx_action+0x159/0x340
 [<ffffffff8106db94>] __do_softirq+0xe4/0x270
 [<ffffffff814e267c>] do_softirq_own_stack+0x1c/0x30
 <EOI>
 [<ffffffff8106ddc5>] do_softirq+0x55/0x60
 [<ffffffff8106de5b>] __local_bh_enable_ip+0x8b/0xa0
 [<ffffffff814e0830>] _raw_spin_unlock_bh+0x20/0x50
 [<ffffffff813b43ce>] xennet_open+0x11e/0x180
 [<ffffffff8141934f>] __dev_open+0xbf/0x140
 [<ffffffff81419661>] __dev_change_flags+0xa1/0x160
 [<ffffffff81419749>] dev_change_flags+0x29/0x60
 [<ffffffff81426a42>] do_setlink+0x2d2/0x7c0
 [<ffffffff81177500>] ? zone_statistics+0x80/0xa0
 [<ffffffff81177500>] ? zone_statistics+0x80/0xa0
 [<ffffffff8142812f>] rtnl_newlink+0x51f/0x8d0
 [<ffffffff81427cf9>] ? rtnl_newlink+0xe9/0x8d0
 [<ffffffff81425855>] rtnetlink_rcv_msg+0x95/0x250
 [<ffffffff81161d72>] ? get_page_from_freelist+0x4f2/0x950
 [<ffffffff8140472e>] ? __alloc_skb+0x7e/0x1d0
 [<ffffffff814257c0>] ? rtnetlink_rcv+0x40/0x40
 [<ffffffff81446a91>] netlink_rcv_skb+0xc1/0xe0
 [<ffffffff814257ac>] rtnetlink_rcv+0x2c/0x40
 [<ffffffff81446136>] netlink_unicast+0xf6/0x200
 [<ffffffff8144665c>] netlink_sendmsg+0x41c/0x670
 [<ffffffff813fb49d>] sock_sendmsg+0x3d/0x50
 [<ffffffff813fbdbf>] ___sys_sendmsg+0x28f/0x2a0
 [<ffffffff811a7935>] ? alloc_pages_vma+0xb5/0x200
 [<ffffffff81167d9b>] ? lru_cache_add_active_or_unevictable+0x2b/0xa0
 [<ffffffff8118789a>] ? handle_mm_fault+0xbba/0x1770
 [<ffffffff811df42f>] ? dentry_free+0x5f/0xa0
 [<ffffffff813fc6a2>] __sys_sendmsg+0x42/0x80
 [<ffffffff813fc6f2>] SyS_sendmsg+0x12/0x20
 [<ffffffff814e0b6e>] system_call_fastpath+0x12/0x71

unsigned int
nf_nat_redirect_ipv4(struct sk_buff *skb,
...
{
...
		rcu_read_lock();
		indev = __in_dev_get_rcu(skb->dev);
		if (indev != NULL) {
			ifa = indev->ifa_list;
			newdst = ifa->ifa_local; <---
		}
		rcu_read_unlock();
...
}

Before the commit, 'ifa' had been always checked before access. After the
commit, however, it could be accessed even if it's NULL. Interestingly,
this was once fixed in 2003.

http://marc.info/?l=netfilter-devel&m=106668497403047&w=2

In addition to the original one, we have seen the crash when packets that
need to be redirected somehow arrive on an interface which hasn't been
yet fully configured.

This change just reverts the logic to the old behavior to avoid the crash.

Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
---
 net/netfilter/nf_nat_redirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 97b75f9..d438698 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -55,7 +55,7 @@ nf_nat_redirect_ipv4(struct sk_buff *skb,
 
 		rcu_read_lock();
 		indev = __in_dev_get_rcu(skb->dev);
-		if (indev != NULL) {
+		if (indev && indev->ifa_list) {
 			ifa = indev->ifa_list;
 			newdst = ifa->ifa_local;
 		}
-- 
2.6.2

