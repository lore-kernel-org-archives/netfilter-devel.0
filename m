From: mathieu.poirier@linaro.org
Subject: [PATCH v4 1/2] netfilter: nfnetlink_acct: make shared objects SMP safe
Date: Mon, 10 Feb 2014 19:27:07 -0700
Message-ID: <1392085628-24804-2-git-send-email-mathieu.poirier@linaro.org>
References: <1392085628-24804-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	fw@strlen.de, mathieu.poirier@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1392085628-24804-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Introducing locking mechanism to protect accounting objects seen
and shared by multiple processors.  Under heavy traffic load
objects can be acted upon concurrently by more than one CPUs,
leading to inaccuracies between packet and byte counts.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 net/netfilter/nfnetlink_acct.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index c7b6d46..225a886 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -36,6 +36,7 @@ struct nf_acct {
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
+	spinlock_t		lock;
 };
 
 static int
@@ -66,8 +67,10 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 	if (matching) {
 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
 			/* reset counters if you request a replacement. */
+			spin_lock_bh(&matching->lock);
 			atomic64_set(&matching->pkts, 0);
 			atomic64_set(&matching->bytes, 0);
+			spin_unlock_bh(&matching->lock);
 			return 0;
 		}
 		return -EBUSY;
@@ -88,6 +91,7 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
 	atomic_set(&nfacct->refcnt, 1);
+	spin_lock_init(&nfacct->lock);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
 }
@@ -114,6 +118,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_string(skb, NFACCT_NAME, acct->name))
 		goto nla_put_failure;
 
+	spin_lock_bh(&acct->lock);
 	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
 		pkts = atomic64_xchg(&acct->pkts, 0);
 		bytes = atomic64_xchg(&acct->bytes, 0);
@@ -121,6 +126,8 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		pkts = atomic64_read(&acct->pkts);
 		bytes = atomic64_read(&acct->bytes);
 	}
+	spin_unlock_bh(&acct->lock);
+
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
@@ -331,8 +338,10 @@ EXPORT_SYMBOL_GPL(nfnl_acct_put);
 
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct)
 {
+	spin_lock_bh(&nfacct->lock);
 	atomic64_inc(&nfacct->pkts);
 	atomic64_add(skb->len, &nfacct->bytes);
+	spin_unlock_bh(&nfacct->lock);
 }
 EXPORT_SYMBOL_GPL(nfnl_acct_update);
 
-- 
1.8.3.2

