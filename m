From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/9] netfilter: nf_tables: fix module unload race
Date: Wed, 13 Jun 2018 12:56:55 +0200
Message-ID: <20180613105700.12894-5-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We must first remove the nfnetlink protocol handler when nf_tables module
is unloaded -- we don't want userspace to submit new change requests once
we've started to tear down nft state.

Furthermore, nfnetlink must not call any subsystem function after
call_batch returned -EAGAIN.

EAGAIN means the subsys mutex was dropped, so its unlikely but possible that
nf_tables subsystem was removed due to 'rmmod nf_tables' on another cpu.

Therefore, we must abort batch completely and not move on to next part of
the batch.

Last, we can't invoke ->abort unless we've checked that the subsystem is
still registered.

Change netns exit path of nf_tables to make sure any incompleted
transaction gets removed on exit.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 net/netfilter/nfnetlink.c     | 10 +++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7979095b69b0..ae312b31db28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6439,7 +6439,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb)
+static int __nf_tables_abort(struct net *net)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
@@ -6555,6 +6555,11 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
+static int nf_tables_abort(struct net *net, struct sk_buff *skb)
+{
+	return __nf_tables_abort(net);
+}
+
 static bool nf_tables_valid_genid(struct net *net, u32 genid)
 {
 	return net->nft.base_seq == genid;
@@ -7149,9 +7154,10 @@ static int __net_init nf_tables_init_net(struct net *net)
 
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
+	if (!list_empty(&net->nft.commit_list))
+		__nf_tables_abort(net);
 	__nft_release_tables(net);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
-	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
@@ -7193,9 +7199,9 @@ static int __init nf_tables_module_init(void)
 
 static void __exit nf_tables_module_exit(void)
 {
-	unregister_pernet_subsys(&nf_tables_net_ops);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
+	unregister_pernet_subsys(&nf_tables_net_ops);
 	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4d0da7042aff..e1b6be29848d 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -429,7 +429,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			 */
 			if (err == -EAGAIN) {
 				status |= NFNL_BATCH_REPLAY;
-				goto next;
+				goto done;
 			}
 		}
 ack:
@@ -456,7 +456,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			if (err)
 				status |= NFNL_BATCH_FAILURE;
 		}
-next:
+
 		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (msglen > skb->len)
 			msglen = skb->len;
@@ -464,7 +464,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb);
+		const struct nfnetlink_subsystem *ss2;
+
+		ss2 = nfnl_dereference_protected(subsys_id);
+		if (ss2 == ss)
+			ss->abort(net, oskb);
 		nfnl_err_reset(&err_list);
 		nfnl_unlock(subsys_id);
 		kfree_skb(skb);
-- 
2.11.0
