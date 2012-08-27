From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Mon, 27 Aug 2012 11:33:29 +0200
Message-ID: <7353554.n89QJXU3eh@gentoovm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3756408.pNz4kmILVL"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:33223 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2H0Jml (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Aug 2012 05:42:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id E60CAA3303
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Aug 2012 10:33:37 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id QHMRYLOLN2b4 for <netfilter-devel@vger.kernel.org>;
	Mon, 27 Aug 2012 10:33:30 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nextPart3756408.pNz4kmILVL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

In a previous version of ctnetlink, a race condition could be caused as a 
result of ctnetlink_del_conntrack not setting the IPS_DYING_BIT that is 
checked by death_by_timeout()

I found that in 3.4.9 I could trigger a soft-lockup by packet flooding a pair 
of systems running conntrackd with NetlinkEventsReliable On.

I found that death_by_event() does not currently check the IPS_DYING_BIT and 
therefore, based on the panic stack trace, I added the bit check to 
death_by_event() and have since been unable to reproduce the crash.

I hope this patch is correct/useful - I'm not innately familiar with the 
conntrack code so perhaps I'm breaking the reliable event reporting with this 
change.

kernel panic is as follows:

Aug 24 14:02:39 fw02-lab [ 2544.350016] BUG: soft lockup - CPU#6 stuck for 
24s! [conntrackd:5119]
Aug 24 14:02:39 fw02-lab [ 2544.350536] Kernel panic - not syncing: 
softlockup: hung tasks
Aug 24 14:02:39 fw02-lab [ 2544.350662] Pid: 5119, comm: conntrackd Tainted: G        
W    3.4.9 #2
Aug 24 14:02:39 fw02-lab [ 2544.350786] Call Trace:
Aug 24 14:02:39 fw02-lab [ 2544.350903]  <IRQ>
Aug 24 14:02:39 fw02-lab [<ffffffff81683ab2>] ? panic+0xbe/0x1cd
Aug 24 14:02:39 fw02-lab [ 2544.351078]  [<ffffffff810a8493>] ? 
watchdog_timer_fn+0x173/0x180
Aug 24 14:02:39 fw02-lab [ 2544.351204]  [<ffffffff8106847e>] ? 
__run_hrtimer.clone.33+0x4e/0x110
Aug 24 14:02:39 fw02-lab [ 2544.351330]  [<ffffffff81068d34>] ? 
hrtimer_interrupt+0xf4/0x250
Aug 24 14:02:39 fw02-lab [ 2544.351455]  [<ffffffff8101ee43>] ? 
smp_apic_timer_interrupt+0x63/0xa0
Aug 24 14:02:39 fw02-lab [ 2544.351591]  [<ffffffff816878c7>] ? 
apic_timer_interrupt+0x67/0x70
Aug 24 14:02:39 fw02-lab [ 2544.351715]  [<ffffffff814ed7a1>] ? 
__kfree_skb+0x11/0x90
Aug 24 14:02:39 fw02-lab [ 2544.351837]  [<ffffffff815271e3>] ? 
netlink_broadcast_filtered+0x123/0x3c0
Aug 24 14:02:39 fw02-lab [ 2544.351962]  [<ffffffff8152e22e>] ? 
death_by_event+0x3e/0x1f0
Aug 24 14:02:39 fw02-lab [ 2544.352085]  [<ffffffff8152e3c5>] ? 
death_by_event+0x1d5/0x1f0
Aug 24 14:02:39 fw02-lab [ 2544.352209]  [<ffffffff8105445f>] ? 
run_timer_softirq+0x11f/0x240
Aug 24 14:02:39 fw02-lab [ 2544.352333]  [<ffffffff8152e1f0>] ? 
nf_conntrack_hash_check_insert+0x270/0x270
Aug 24 14:02:39 fw02-lab [ 2544.352524]  [<ffffffff8104f2c8>] ? 
__do_softirq+0x98/0x120
Aug 24 14:02:39 fw02-lab [ 2544.352647]  [<ffffffff8168820c>] ? 
call_softirq+0x1c/0x30
Aug 24 14:02:39 fw02-lab [ 2544.352767]  <EOI>
Aug 24 14:02:39 fw02-lab [<ffffffff8100460d>] ? do_softirq+0x4d/0x80
Aug 24 14:02:39 fw02-lab [ 2544.352938]  [<ffffffff8104f224>] ? 
local_bh_enable+0x94/0xa0
Aug 24 14:02:39 fw02-lab [ 2544.353061]  [<ffffffff8152dd5d>] ? 
____nf_conntrack_find+0x10d/0x120
Aug 24 14:02:39 fw02-lab [ 2544.353186]  [<ffffffff8152ddb9>] ? 
__nf_conntrack_find_get+0x49/0x170
Aug 24 14:02:39 fw02-lab [ 2544.353311]  [<ffffffff8153876c>] ? 
ctnetlink_del_conntrack+0xac/0x300
Aug 24 14:02:39 fw02-lab [ 2544.353435]  [<ffffffff81280f70>] ? 
nla_parse+0x80/0xd0
Aug 24 14:02:39 fw02-lab [ 2544.353558]  [<ffffffff8152c93e>] ? 
nfnetlink_rcv_msg+0x1ee/0x220
Aug 24 14:02:39 fw02-lab [ 2544.353682]  [<ffffffff8152c77a>] ? 
nfnetlink_rcv_msg+0x2a/0x220
Aug 24 14:02:39 fw02-lab [ 2544.353806]  [<ffffffff8152c750>] ? 
nfnl_lock+0x20/0x20
Aug 24 14:02:39 fw02-lab [ 2544.353927]  [<ffffffff81529389>] ? 
netlink_rcv_skb+0x99/0xc0
Aug 24 14:02:39 fw02-lab [ 2544.354050]  [<ffffffff81528d1f>] ? 
netlink_unicast+0x1af/0x200
Aug 24 14:02:39 fw02-lab [ 2544.354173]  [<ffffffff81528fa8>] ? 
netlink_sendmsg+0x238/0x350
Aug 24 14:02:39 fw02-lab [ 2544.354296]  [<ffffffff814e5084>] ? 
sock_sendmsg+0xe4/0x130
Aug 24 14:02:39 fw02-lab [ 2544.354418]  [<ffffffff814e4eed>] ? 
sock_recvmsg+0xed/0x140
Aug 24 14:02:39 fw02-lab [ 2544.354542]  [<ffffffff8111f5fd>] ? 
core_sys_select+0x22d/0x340
Aug 24 14:02:39 fw02-lab [ 2544.354665]  [<ffffffff814e64fb>] ? 
move_addr_to_kernel+0x2b/0xa0
Aug 24 14:02:39 fw02-lab [ 2544.354788]  [<ffffffff814e4272>] ? 
sockfd_lookup_light+0x22/0x90
Aug 24 14:02:39 fw02-lab [ 2544.354912]  [<ffffffff814e6fac>] ? 
sys_sendto+0x13c/0x1a0
Aug 24 14:02:39 fw02-lab [ 2544.355034]  [<ffffffff814ed7a1>] ? 
__kfree_skb+0x11/0x90
Aug 24 14:02:39 fw02-lab [ 2544.355157]  [<ffffffff8126c574>] ? 
rb_insert_color+0xa4/0x140
Aug 24 14:02:39 fw02-lab [ 2544.355279]  [<ffffffff81077e27>] ? 
dequeue_pushable_task+0x27/0x70
Aug 24 14:02:39 fw02-lab [ 2544.355404]  [<ffffffff81686e62>] ? 
system_call_fastpath+0x16/0x1b
Aug 24 14:02:39 fw02-lab [ 2544.355541] Rebooting in 5 seconds..

Thanks,
Oliver
--nextPart3756408.pNz4kmILVL
Content-Disposition: attachment; filename="death_by_event-check-dying-bit.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="death_by_event-check-dying-bit.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 729f157..5c274f3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -250,7 +250,8 @@ static void death_by_event(unsigned long ul_conntrack)
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
 
-	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
+	if (!test_bit(IPS_DYING_BIT, &ct->status) &&
+	    nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
 		/* bad luck, let's retry again */
 		ct->timeout.expires = jiffies +
 			(random32() % net->ct.sysctl_events_retry_timeout);

--nextPart3756408.pNz4kmILVL--

