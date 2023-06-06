Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB67C7EE45
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbjFFW7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbjFFW7E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:59:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6DFF173A;
        Tue,  6 Jun 2023 15:58:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 4/5] netfilter: ipset: Add schedule point in call_ad().
Date:   Wed,  7 Jun 2023 00:58:50 +0200
Message-Id: <20230606225851.67394-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606225851.67394-1-pablo@netfilter.org>
References: <20230606225851.67394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

syzkaller found a repro that causes Hung Task [0] with ipset.  The repro
first creates an ipset and then tries to delete a large number of IPs
from the ipset concurrently:

  IPSET_ATTR_IPADDR_IPV4 : 172.20.20.187
  IPSET_ATTR_CIDR        : 2

The first deleting thread hogs a CPU with nfnl_lock(NFNL_SUBSYS_IPSET)
held, and other threads wait for it to be released.

Previously, the same issue existed in set->variant->uadt() that could run
so long under ip_set_lock(set).  Commit 5e29dc36bd5e ("netfilter: ipset:
Rework long task execution when adding/deleting entries") tried to fix it,
but the issue still exists in the caller with another mutex.

While adding/deleting many IPs, we should release the CPU periodically to
prevent someone from abusing ipset to hang the system.

Note we need to increment the ipset's refcnt to prevent the ipset from
being destroyed while rescheduling.

[0]:
INFO: task syz-executor174:268 blocked for more than 143 seconds.
      Not tainted 6.4.0-rc1-00145-gba79e9a73284 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor174 state:D stack:0     pid:268   ppid:260    flags:0x0000000d
Call trace:
 __switch_to+0x308/0x714 arch/arm64/kernel/process.c:556
 context_switch kernel/sched/core.c:5343 [inline]
 __schedule+0xd84/0x1648 kernel/sched/core.c:6669
 schedule+0xf0/0x214 kernel/sched/core.c:6745
 schedule_preempt_disabled+0x58/0xf0 kernel/sched/core.c:6804
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0x6fc/0xdb0 kernel/locking/mutex.c:747
 __mutex_lock_slowpath+0x14/0x20 kernel/locking/mutex.c:1035
 mutex_lock+0x98/0xf0 kernel/locking/mutex.c:286
 nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 nfnetlink_rcv_msg+0x480/0x70c net/netfilter/nfnetlink.c:295
 netlink_rcv_skb+0x1c0/0x350 net/netlink/af_netlink.c:2546
 nfnetlink_rcv+0x18c/0x199c net/netfilter/nfnetlink.c:658
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x664/0x8cc net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x6d0/0xa4c net/netlink/af_netlink.c:1913
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0x4b8/0x810 net/socket.c:2503
 ___sys_sendmsg net/socket.c:2557 [inline]
 __sys_sendmsg+0x1f8/0x2a4 net/socket.c:2586
 __do_sys_sendmsg net/socket.c:2595 [inline]
 __se_sys_sendmsg net/socket.c:2593 [inline]
 __arm64_sys_sendmsg+0x80/0x94 net/socket.c:2593
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x84/0x270 arch/arm64/kernel/syscall.c:52
 el0_svc_common+0x134/0x24c arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
 el0_svc+0x2c/0x7c arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591

Reported-by: syzkaller <syzkaller@googlegroups.com>
Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 46ebee9400da..9a6b64779e64 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1694,6 +1694,14 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	bool eexist = flags & IPSET_FLAG_EXIST, retried = false;
 
 	do {
+		if (retried) {
+			__ip_set_get(set);
+			nfnl_unlock(NFNL_SUBSYS_IPSET);
+			cond_resched();
+			nfnl_lock(NFNL_SUBSYS_IPSET);
+			__ip_set_put(set);
+		}
+
 		ip_set_lock(set);
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
-- 
2.30.2

