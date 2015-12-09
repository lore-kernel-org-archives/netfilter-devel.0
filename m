From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Wed,  9 Dec 2015 18:30:09 +0100
Message-ID: <1449682209-20330-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44968 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbbLIRaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 12:30:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulrich reports soft lockup with following (shortened) callchain:

NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
__netif_receive_skb_core+0x6e4/0x774
process_backlog+0x94/0x160
net_rx_action+0x88/0x178
call_do_softirq+0x24/0x3c
do_softirq+0x54/0x6c
__local_bh_enable_ip+0x7c/0xbc
nf_ct_iterate_cleanup+0x11c/0x22c [nf_conntrack]
masq_inet_event+0x20/0x30 [nf_nat_masquerade_ipv6]
atomic_notifier_call_chain+0x1c/0x2c
ipv6_del_addr+0x1bc/0x220 [ipv6]

Problem is that nf_ct_iterate_cleanup can run for a very long time
since it can be interrupted by softirq processing.
Moreover, atomic_notifier_call_chain runs with rcu readlock held.

So lets call cond_resched() in nf_ct_iterate_cleanup loop and defer
the call to a work queue for the atomic_notifier_call_chain case.

Reported-by: Ulrich Weber <uw@ocedo.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Patch also applies to nf-next tree in case you think nf tree isn't appropriate.

 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 46 +++++++++++++++++++++++++++--
 net/netfilter/nf_conntrack_core.c           |  3 ++
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 31ba7ca..a877dee 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -78,14 +78,54 @@ static struct notifier_block masq_dev_notifier = {
 	.notifier_call	= masq_device_event,
 };
 
+struct masq_dev_slow_work {
+	struct work_struct work;
+	struct net *net;
+	int ifindex;
+};
+
+static void iterate_cleanup_work(struct work_struct *work)
+{
+	struct masq_dev_slow_work *w;
+	struct net *net;
+	int ifindex;
+
+	w = container_of(work, struct masq_dev_slow_work, work);
+
+	net = w->net;
+	ifindex = w->ifindex;
+	kfree(w);
+
+	nf_ct_iterate_cleanup(net, device_cmp, (void *)(long)ifindex, 0, 0);
+
+	put_net(net);
+	module_put(THIS_MODULE);
+}
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event, void *ptr)
 {
 	struct inet6_ifaddr *ifa = ptr;
-	struct netdev_notifier_info info;
+	struct masq_dev_slow_work *w;
+
+	if (event != NETDEV_DOWN || !try_module_get(THIS_MODULE))
+		return NOTIFY_DONE;
+
+	/* can't call nf_ct_iterate_cleanup in atomic context */
+	w = kmalloc(sizeof(*w), GFP_ATOMIC);
+	if (w) {
+		const struct net_device *dev = ifa->idev->dev;
 
-	netdev_notifier_info_init(&info, ifa->idev->dev);
-	return masq_device_event(this, event, &info);
+		INIT_WORK(&w->work, iterate_cleanup_work);
+
+		w->ifindex = dev->ifindex;
+		w->net = get_net(dev_net(dev));
+		schedule_work(&w->work);
+	} else {
+		module_put(THIS_MODULE);
+	}
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block masq_inet_notifier = {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3cb3cb8..cffeb68 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1422,6 +1422,8 @@ void nf_ct_iterate_cleanup(struct net *net,
 	struct nf_conn *ct;
 	unsigned int bucket = 0;
 
+	might_sleep();
+
 	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&ct->timeout))
@@ -1430,6 +1432,7 @@ void nf_ct_iterate_cleanup(struct net *net,
 		/* ... else the timer will get him soon. */
 
 		nf_ct_put(ct);
+		cond_resched();
 	}
 }
 EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
-- 
2.4.10

