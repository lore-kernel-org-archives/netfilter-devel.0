From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH net-next 1/5] net: Introduce net_rwsem to protect
 net_namespace_list
Date: Thu, 29 Mar 2018 19:20:32 +0300
Message-ID: <152234043276.19153.12772428640357395360.stgit__4299.10066673091$1522340361$gmane$org@localhost.localdomain>
References: <152234005959.19153.17907173734141707348.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org,
	kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, pshelar-LZ6Gd1LRuIk@public.gmane.org,
	johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org,
	eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org,
	leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
	ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org,
	vyasevic-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org,
	jakub.kicinski-wFxRvT7yatFl57MIdRCFDg@public.gmane.org,
	ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, brouer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org,
	john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
	idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org,
	roman.kapl-uSbOeAmDUekAvxtiuMwx3w@public.gmane.org, lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org,
	jbenc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pombredanne-od1rfyK75/E@public.gmane.org, linux-rdma@vger.k
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <152234005959.19153.17907173734141707348.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

rtnl_lock() is used everywhere, and contention is very high.
When someone wants to iterate over alive net namespaces,
he/she has no a possibility to do that without exclusive lock.
But the exclusive rtnl_lock() in such places is overkill,
and it just increases the contention. Yes, there is already
for_each_net_rcu() in kernel, but it requires rcu_read_lock(),
and this can't be sleepable. Also, sometimes it may be need
really prevent net_namespace_list growth, so for_each_net_rcu()
is not fit there.

This patch introduces new rw_semaphore, which will be used
instead of rtnl_mutex to protect net_namespace_list. It is
sleepable and allows not-exclusive iterations over net
namespaces list. It allows to stop using rtnl_lock()
in several places (what is made in next patches) and makes
less the time, we keep rtnl_mutex. Here we just add new lock,
while the explanation of we can remove rtnl_lock() there are
in next patches.

Fine grained locks generally are better, then one big lock,
so let's do that with net_namespace_list, while the situation
allows that.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 drivers/infiniband/core/roce_gid_mgmt.c |    2 ++
 include/linux/rtnetlink.h               |    1 +
 include/net/net_namespace.h             |    1 +
 net/core/dev.c                          |    5 +++++
 net/core/fib_notifier.c                 |    2 ++
 net/core/net_namespace.c                |   18 +++++++++++++-----
 net/core/rtnetlink.c                    |    5 +++++
 net/netfilter/nf_conntrack_core.c       |    2 ++
 net/openvswitch/datapath.c              |    2 ++
 net/wireless/wext-core.c                |    2 ++
 security/selinux/include/xfrm.h         |    2 ++
 11 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 5a52ec77940a..cc2966380c0c 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -403,10 +403,12 @@ static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
 	 * our feet
 	 */
 	rtnl_lock();
+	down_read(&net_rwsem);
 	for_each_net(net)
 		for_each_netdev(net, ndev)
 			if (is_eth_port_of_netdev(ib_dev, port, rdma_ndev, ndev))
 				add_netdev_ips(ib_dev, port, rdma_ndev, ndev);
+	up_read(&net_rwsem);
 	rtnl_unlock();
 }
 
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index c7d1e4689325..5225832bd6ff 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -37,6 +37,7 @@ extern int rtnl_lock_killable(void);
 
 extern wait_queue_head_t netdev_unregistering_wq;
 extern struct rw_semaphore pernet_ops_rwsem;
+extern struct rw_semaphore net_rwsem;
 
 #ifdef CONFIG_PROVE_LOCKING
 extern bool lockdep_rtnl_is_held(void);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1ab4f920f109..47e35cce3b64 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -291,6 +291,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #endif
 }
 
+/* Protected by net_rwsem */
 #define for_each_net(VAR)				\
 	list_for_each_entry(VAR, &net_namespace_list, list)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index e13807b5c84d..eca5458b2753 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1629,6 +1629,7 @@ int register_netdevice_notifier(struct notifier_block *nb)
 		goto unlock;
 	if (dev_boot_phase)
 		goto unlock;
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		for_each_netdev(net, dev) {
 			err = call_netdevice_notifier(nb, NETDEV_REGISTER, dev);
@@ -1642,6 +1643,7 @@ int register_netdevice_notifier(struct notifier_block *nb)
 			call_netdevice_notifier(nb, NETDEV_UP, dev);
 		}
 	}
+	up_read(&net_rwsem);
 
 unlock:
 	rtnl_unlock();
@@ -1664,6 +1666,7 @@ int register_netdevice_notifier(struct notifier_block *nb)
 	}
 
 outroll:
+	up_read(&net_rwsem);
 	raw_notifier_chain_unregister(&netdev_chain, nb);
 	goto unlock;
 }
@@ -1694,6 +1697,7 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 	if (err)
 		goto unlock;
 
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		for_each_netdev(net, dev) {
 			if (dev->flags & IFF_UP) {
@@ -1704,6 +1708,7 @@ int unregister_netdevice_notifier(struct notifier_block *nb)
 			call_netdevice_notifier(nb, NETDEV_UNREGISTER, dev);
 		}
 	}
+	up_read(&net_rwsem);
 unlock:
 	rtnl_unlock();
 	return err;
diff --git a/net/core/fib_notifier.c b/net/core/fib_notifier.c
index 0c048bdeb016..614b985c92a4 100644
--- a/net/core/fib_notifier.c
+++ b/net/core/fib_notifier.c
@@ -33,6 +33,7 @@ static unsigned int fib_seq_sum(void)
 	struct net *net;
 
 	rtnl_lock();
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(ops, &net->fib_notifier_ops, list) {
@@ -43,6 +44,7 @@ static unsigned int fib_seq_sum(void)
 		}
 		rcu_read_unlock();
 	}
+	up_read(&net_rwsem);
 	rtnl_unlock();
 
 	return fib_seq;
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index b5796d17a302..7fdf321d4997 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -33,6 +33,10 @@ static struct list_head *first_device = &pernet_list;
 LIST_HEAD(net_namespace_list);
 EXPORT_SYMBOL_GPL(net_namespace_list);
 
+/* Protects net_namespace_list. Nests iside rtnl_lock() */
+DECLARE_RWSEM(net_rwsem);
+EXPORT_SYMBOL_GPL(net_rwsem);
+
 struct net init_net = {
 	.count		= REFCOUNT_INIT(1),
 	.dev_base_head	= LIST_HEAD_INIT(init_net.dev_base_head),
@@ -309,9 +313,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 		if (error < 0)
 			goto out_undo;
 	}
-	rtnl_lock();
+	down_write(&net_rwsem);
 	list_add_tail_rcu(&net->list, &net_namespace_list);
-	rtnl_unlock();
+	up_write(&net_rwsem);
 out:
 	return error;
 
@@ -450,7 +454,7 @@ static void unhash_nsid(struct net *net, struct net *last)
 	 * and this work is the only process, that may delete
 	 * a net from net_namespace_list. So, when the below
 	 * is executing, the list may only grow. Thus, we do not
-	 * use for_each_net_rcu() or rtnl_lock().
+	 * use for_each_net_rcu() or net_rwsem.
 	 */
 	for_each_net(tmp) {
 		int id;
@@ -485,7 +489,7 @@ static void cleanup_net(struct work_struct *work)
 	down_read(&pernet_ops_rwsem);
 
 	/* Don't let anyone else find us. */
-	rtnl_lock();
+	down_write(&net_rwsem);
 	llist_for_each_entry(net, net_kill_list, cleanup_list)
 		list_del_rcu(&net->list);
 	/* Cache last net. After we unlock rtnl, no one new net
@@ -499,7 +503,7 @@ static void cleanup_net(struct work_struct *work)
 	 * useless anyway, as netns_ids are destroyed there.
 	 */
 	last = list_last_entry(&net_namespace_list, struct net, list);
-	rtnl_unlock();
+	up_write(&net_rwsem);
 
 	llist_for_each_entry(net, net_kill_list, cleanup_list) {
 		unhash_nsid(net, last);
@@ -900,6 +904,9 @@ static int __register_pernet_operations(struct list_head *list,
 
 	list_add_tail(&ops->list, list);
 	if (ops->init || (ops->id && ops->size)) {
+		/* We held write locked pernet_ops_rwsem, and parallel
+		 * setup_net() and cleanup_net() are not possible.
+		 */
 		for_each_net(net) {
 			error = ops_init(ops, net);
 			if (error)
@@ -923,6 +930,7 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	LIST_HEAD(net_exit_list);
 
 	list_del(&ops->list);
+	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
 	ops_exit_list(ops, &net_exit_list);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2d3949789cef..e86b28482ca7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -418,9 +418,11 @@ void __rtnl_link_unregister(struct rtnl_link_ops *ops)
 {
 	struct net *net;
 
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		__rtnl_kill_links(net, ops);
 	}
+	up_read(&net_rwsem);
 	list_del(&ops->list);
 }
 EXPORT_SYMBOL_GPL(__rtnl_link_unregister);
@@ -438,6 +440,9 @@ static void rtnl_lock_unregistering_all(void)
 	for (;;) {
 		unregistering = false;
 		rtnl_lock();
+		/* We held write locked pernet_ops_rwsem, and parallel
+		 * setup_net() and cleanup_net() are not possible.
+		 */
 		for_each_net(net) {
 			if (net->dev_unreg_count > 0) {
 				unregistering = true;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 705198de671d..370f9b7f051b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1764,12 +1764,14 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 	struct net *net;
 
 	rtnl_lock();
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		if (atomic_read(&net->ct.count) == 0)
 			continue;
 		__nf_ct_unconfirmed_destroy(net);
 		nf_queue_nf_hook_drop(net);
 	}
+	up_read(&net_rwsem);
 	rtnl_unlock();
 
 	/* Need to wait for netns cleanup worker to finish, if its
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index ef38e5aecd28..9746ee30a99b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2364,8 +2364,10 @@ static void __net_exit ovs_exit_net(struct net *dnet)
 		__dp_destroy(dp);
 
 	rtnl_lock();
+	down_read(&net_rwsem);
 	for_each_net(net)
 		list_vports_from_net(net, dnet, &head);
+	up_read(&net_rwsem);
 	rtnl_unlock();
 
 	/* Detach all vports from given namespace. */
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 9efbfc753347..544d7b62d7ca 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -349,11 +349,13 @@ void wireless_nlevent_flush(void)
 
 	ASSERT_RTNL();
 
+	down_read(&net_rwsem);
 	for_each_net(net) {
 		while ((skb = skb_dequeue(&net->wext_nlevents)))
 			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
 				    GFP_KERNEL);
 	}
+	up_read(&net_rwsem);
 }
 EXPORT_SYMBOL_GPL(wireless_nlevent_flush);
 
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 1f173a7a4daa..31d66431be1e 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -48,8 +48,10 @@ static inline void selinux_xfrm_notify_policyload(void)
 	struct net *net;
 
 	rtnl_lock();
+	down_read(&net_rwsem);
 	for_each_net(net)
 		rt_genid_bump_all(net);
+	up_read(&net_rwsem);
 	rtnl_unlock();
 }
 #else
