From: Hans Schillstrom <hans.schillstrom@ericsson.com>
Subject: conntrack, suspicious RCU usage
Date: Wed, 11 Jan 2012 10:25:50 +0100
Message-ID: <201201111025.50994.hans.schillstrom@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:46262 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2AKJZy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:25:54 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello
I got this the first time using conntrack -L when there is a lot of traffic.
It doesn't result in any thing bad yet.

Is this a know thing ?
or should I dig into it..

I'm running the latest and greatest conntrack / netfilter tools and libs.

===============================
[ INFO: suspicious RCU usage. ]
-------------------------------
/home/hans/evip.git/kvm/net-next.git/include/net/netfilter/nf_conntrack_l3proto.h:92 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
3 locks held by conntrack/2249:
 #0:  (nfnl_mutex){+.+.+.}, at: [<ffffffff812cd29f>] nfnl_lock+0x17/0x19
 #1:  (nlk->cb_mutex){+.+.+.}, at: [<ffffffff812c7211>] netlink_dump+0x27/0x1ec
 #2:  (nf_conntrack_lock){+.-...}, at: [<ffffffffa00b8922>] 0xffffffffa00b8922

stack backtrace:
Pid: 2249, comm: conntrack Tainted: G        W    3.2.0+ #34
Call Trace:
 [<ffffffff8102ee61>] ? console_unlock+0x164/0x20c
 [<ffffffff81078542>] lockdep_rcu_suspicious+0xd8/0xe1
 [<ffffffffa00b78aa>] 0xffffffffa00b78a9
 [<ffffffffa00b819c>] 0xffffffffa00b819b
 [<ffffffffa00b898f>] 0xffffffffa00b898e
 [<ffffffff812c725e>] netlink_dump+0x74/0x1ec
 [<ffffffffa00b88e4>] ? 0xffffffffa00b88e3
 [<ffffffff812c7a43>] netlink_dump_start+0x103/0x135
 [<ffffffffa00b77fa>] ? 0xffffffffa00b77f9
 [<ffffffffa00b86a8>] 0xffffffffa00b86a7
 [<ffffffff812cd29f>] ? nfnl_lock+0x17/0x19
 [<ffffffff812cd734>] nfnetlink_rcv_msg+0x493/0x4cd
 [<ffffffff812cd3bc>] ? nfnetlink_rcv_msg+0x11b/0x4cd
 [<ffffffff812cd359>] ? nfnetlink_rcv_msg+0xb8/0x4cd
 [<ffffffff812c6c51>] ? netlink_lookup+0xc4/0xcf
 [<ffffffff812cd2a1>] ? nfnl_lock+0x19/0x19
 [<ffffffff812c87d2>] netlink_rcv_skb+0x43/0x94
 [<ffffffff812cd207>] nfnetlink_rcv+0x15/0x17
 [<ffffffff812c853a>] netlink_unicast+0x13d/0x1b4
 [<ffffffff812c8e32>] netlink_sendmsg+0x201/0x269
 [<ffffffff812962ef>] sock_sendmsg+0xea/0x109
 [<ffffffff81077fdf>] ? lock_release_holdtime+0xfd/0x102
 [<ffffffff810e2755>] ? might_fault+0x40/0x90
 [<ffffffff810e2755>] ? might_fault+0x40/0x90
 [<ffffffff810e2755>] ? might_fault+0x40/0x90
 [<ffffffff810e279e>] ? might_fault+0x89/0x90
 [<ffffffff810e2755>] ? might_fault+0x40/0x90
 [<ffffffff812948ec>] ? move_addr_to_kernel+0x3f/0x56
 [<ffffffff81296a65>] sys_sendto+0x102/0x12a
 [<ffffffff810faf10>] ? kmem_cache_free+0xc7/0x1b2
 [<ffffffff81079651>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff813ba612>] system_call_fastpath+0x16/0x1b


-- 
Regards
Hans Schillstrom <hans.schillstrom@ericsson.com>
