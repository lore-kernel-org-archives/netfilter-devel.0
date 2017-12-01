From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] netfilter: Eliminate cond_resched_rcu_qs() in favor of cond_resched()
Date: Fri,  1 Dec 2017 11:21:37 -0800
Message-ID: <1512156104-20104-3-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20171201192122.GA19301@linux.vnet.ibm.com>
Cc: mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171201192122.GA19301@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
index 85f643c1e227..4efaa3066c78 100644
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
-- 
2.5.2
