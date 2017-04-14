From: gfree.wind@foxmail.com
Subject: [PATCH nf v2] netfilter: cttimeout: Fix one possible use-after-free issue
Date: Fri, 14 Apr 2017 09:13:40 +0800
Message-ID: <1492132420-70400-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau2.qq.com ([54.206.34.216]:53086 "EHLO smtpbgau2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdDNBOh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:14:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The function ctnl_untimeout is used to untimeout every conntrack
which is using the timeout. But it is necessary to add one barrier
synchronize_rcu because of racing. Maybe one conntrack has already
owned this timeout, but it is not inserted into unconfirmed list or
the hash list, when ctnl_untimeout untimeout the conntracks

Let me describe it with a call path
CPU1				CPU2
alloc new conn
add timeout ext
				ctnl_timeout_try_del
				untimeout all conns in list
				kfree_rcu.
conn is confirmed.

As the show above, when cpu2 untimeout all conns in list and the new
conn of cpu1 is not confirmed, the new conn still owns the timeout
pointer. After the timeout mem is freed really, it points to one
invalid mem.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Add the call path in the comment
 v1: initial version

 net/netfilter/nfnetlink_cttimeout.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 47d6656..af0cc87 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -304,6 +304,11 @@ static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
 	spinlock_t *lock;
 	int i, cpu;
 
+	/* Make sure the conntrack using the timeout already in the unconfirmed
+	 * list or in the hash table.
+	 */
+	synchronize_rcu();
+
 	for_each_possible_cpu(cpu) {
 		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 
-- 
1.9.1




