From: pablo@netfilter.org
Subject: [PATCH 1/3] ipvs: fix oops in ip_vs_dst_event on rmmod
Date: Thu, 11 Oct 2012 12:07:32 +0200
Message-ID: <1349950054-12353-2-git-send-email-pablo@netfilter.org>
References: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48768 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312Ab2JKKHu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:07:50 -0400
In-Reply-To: <1349950054-12353-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>

	After commit 39f618b4fd95ae243d940ec64c961009c74e3333 (3.4)
"ipvs: reset ipvs pointer in netns" we can oops in
ip_vs_dst_event on rmmod ip_vs because ip_vs_control_cleanup
is called after the ipvs_core_ops subsys is unregistered and
net->ipvs is NULL. Fix it by exiting early from ip_vs_dst_event
if ipvs is NULL. It is safe because all services and dests
for the net are already freed.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d43e3c1..84444dd 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1521,11 +1521,12 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
 {
 	struct net_device *dev = ptr;
 	struct net *net = dev_net(dev);
+	struct netns_ipvs *ipvs = net_ipvs(net);
 	struct ip_vs_service *svc;
 	struct ip_vs_dest *dest;
 	unsigned int idx;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_UNREGISTER || !ipvs)
 		return NOTIFY_DONE;
 	IP_VS_DBG(3, "%s() dev=%s\n", __func__, dev->name);
 	EnterFunction(2);
@@ -1551,7 +1552,7 @@ static int ip_vs_dst_event(struct notifier_block *this, unsigned long event,
 		}
 	}
 
-	list_for_each_entry(dest, &net_ipvs(net)->dest_trash, n_list) {
+	list_for_each_entry(dest, &ipvs->dest_trash, n_list) {
 		__ip_vs_dev_reset(dest, dev);
 	}
 	mutex_unlock(&__ip_vs_mutex);
-- 
1.7.10.4

