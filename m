From: gfree.wind@foxmail.com
Subject: [PATCH nf 1/1] netfilter: cttimeout: Fix one possible use-after-free issue
Date: Thu,  6 Apr 2017 19:09:09 +0800
Message-ID: <1491476949-92872-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau2.qq.com ([54.206.34.216]:48214 "EHLO smtpbgau2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933338AbdDFLJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 07:09:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The function ctnl_untimeout is used to untimeout every conntrack
which is using the timeout. But it is necessary to add one barrier
synchronize_rcu because of racing. Maybe one conntrack has already
owned this timeout, but it is not inserted into unconfirmed list or
the hash list, when ctnl_untimeout untimeout the conntracks

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
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




