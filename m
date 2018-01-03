From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Subject: [tip:core/rcu] netfilter: Eliminate cond_resched_rcu_qs() in favor
 of cond_resched()
Date: Wed, 3 Jan 2018 07:56:02 -0800
Message-ID: <tip-ffa53c5863ddb265f9a25729023f4d0409cdacf7@git.kernel.org>
Reply-To: fw@strlen.de, pablo@netfilter.org, mingo@kernel.org,
          kadlec@blackhole.kfki.hu, hpa@zytor.com,
          paulmck@linux.vnet.ibm.com, davem@davemloft.net,
          linux-kernel@vger.kernel.org, tglx@linutronix.de,
          netfilter-devel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: tglx@linutronix.de, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        fw@strlen.de, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        mingo@kernel.org
To: linux-tip-commits@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([65.50.211.136]:36761 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbeACQEo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 11:04:44 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit-ID:  ffa53c5863ddb265f9a25729023f4d0409cdacf7
Gitweb:     https://git.kernel.org/tip/ffa53c5863ddb265f9a25729023f4d0409cdacf7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 24 Oct 2017 06:48:39 -0700
Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Tue, 28 Nov 2017 16:00:27 -0800

netfilter: Eliminate cond_resched_rcu_qs() in favor of cond_resched()

Now that cond_resched() also provides RCU quiescent states when
needed, it can be used in place of cond_resched_rcu_qs().  This
commit therefore makes this change.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netfilter-devel@vger.kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 85f643c..4efaa30 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1044,7 +1044,7 @@ static void gc_worker(struct work_struct *work)
 		 * we will just continue with next hash slot.
 		 */
 		rcu_read_unlock();
-		cond_resched_rcu_qs();
+		cond_resched();
 	} while (++buckets < goal);
 
 	if (gc_work->exiting)
