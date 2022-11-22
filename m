Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9390CC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 17:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiKVRHO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 12:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiKVRHN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 12:07:13 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D15D786DD;
        Tue, 22 Nov 2022 09:07:12 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 6AAB626206;
        Tue, 22 Nov 2022 19:07:11 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id ADF932600F;
        Tue, 22 Nov 2022 18:47:21 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 062143C043E;
        Tue, 22 Nov 2022 18:47:17 +0200 (EET)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2AMGlHoK066793;
        Tue, 22 Nov 2022 18:47:17 +0200
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 2AMGlHRG066792;
        Tue, 22 Nov 2022 18:47:17 +0200
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jiri Wiesner <jwiesner@suse.de>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        dust.li@linux.alibaba.com
Subject: [PATCHv7 2/6] ipvs: use common functions for stats allocation
Date:   Tue, 22 Nov 2022 18:46:00 +0200
Message-Id: <20221122164604.66621-3-ja@ssi.bg>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122164604.66621-1-ja@ssi.bg>
References: <20221122164604.66621-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move alloc_percpu/free_percpu logic in new functions

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Cc: yunhong-cgl jiang <xintian1976@gmail.com>
Cc: "dust.li" <dust.li@linux.alibaba.com>
Reviewed-by: Jiri Wiesner <jwiesner@suse.de>
---
 include/net/ip_vs.h            |  5 ++
 net/netfilter/ipvs/ip_vs_ctl.c | 96 +++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 41 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index bd8ae137e43b..e5582c01a4a3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -410,6 +410,11 @@ struct ip_vs_stats_rcu {
 	struct rcu_head		rcu_head;
 };
 
+int ip_vs_stats_init_alloc(struct ip_vs_stats *s);
+struct ip_vs_stats *ip_vs_stats_alloc(void);
+void ip_vs_stats_release(struct ip_vs_stats *stats);
+void ip_vs_stats_free(struct ip_vs_stats *stats);
+
 struct dst_entry;
 struct iphdr;
 struct ip_vs_conn;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 9016b641ae52..ec6db864ac36 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -471,7 +471,7 @@ __ip_vs_bind_svc(struct ip_vs_dest *dest, struct ip_vs_service *svc)
 
 static void ip_vs_service_free(struct ip_vs_service *svc)
 {
-	free_percpu(svc->stats.cpustats);
+	ip_vs_stats_release(&svc->stats);
 	kfree(svc);
 }
 
@@ -782,7 +782,7 @@ static void ip_vs_dest_rcu_free(struct rcu_head *head)
 	struct ip_vs_dest *dest;
 
 	dest = container_of(head, struct ip_vs_dest, rcu_head);
-	free_percpu(dest->stats.cpustats);
+	ip_vs_stats_release(&dest->stats);
 	ip_vs_dest_put_and_free(dest);
 }
 
@@ -822,7 +822,7 @@ static void ip_vs_stats_rcu_free(struct rcu_head *head)
 						  struct ip_vs_stats_rcu,
 						  rcu_head);
 
-	free_percpu(rs->s.cpustats);
+	ip_vs_stats_release(&rs->s);
 	kfree(rs);
 }
 
@@ -879,6 +879,47 @@ ip_vs_zero_stats(struct ip_vs_stats *stats)
 	spin_unlock_bh(&stats->lock);
 }
 
+/* Allocate fields after kzalloc */
+int ip_vs_stats_init_alloc(struct ip_vs_stats *s)
+{
+	int i;
+
+	spin_lock_init(&s->lock);
+	s->cpustats = alloc_percpu(struct ip_vs_cpu_stats);
+	if (!s->cpustats)
+		return -ENOMEM;
+
+	for_each_possible_cpu(i) {
+		struct ip_vs_cpu_stats *cs = per_cpu_ptr(s->cpustats, i);
+
+		u64_stats_init(&cs->syncp);
+	}
+	return 0;
+}
+
+struct ip_vs_stats *ip_vs_stats_alloc(void)
+{
+	struct ip_vs_stats *s = kzalloc(sizeof(*s), GFP_KERNEL);
+
+	if (s && ip_vs_stats_init_alloc(s) >= 0)
+		return s;
+	kfree(s);
+	return NULL;
+}
+
+void ip_vs_stats_release(struct ip_vs_stats *stats)
+{
+	free_percpu(stats->cpustats);
+}
+
+void ip_vs_stats_free(struct ip_vs_stats *stats)
+{
+	if (stats) {
+		ip_vs_stats_release(stats);
+		kfree(stats);
+	}
+}
+
 /*
  *	Update a destination in the given service
  */
@@ -978,14 +1019,13 @@ static int
 ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 {
 	struct ip_vs_dest *dest;
-	unsigned int atype, i;
+	unsigned int atype;
+	int ret;
 
 	EnterFunction(2);
 
 #ifdef CONFIG_IP_VS_IPV6
 	if (udest->af == AF_INET6) {
-		int ret;
-
 		atype = ipv6_addr_type(&udest->addr.in6);
 		if ((!(atype & IPV6_ADDR_UNICAST) ||
 			atype & IPV6_ADDR_LINKLOCAL) &&
@@ -1007,16 +1047,10 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	if (dest == NULL)
 		return -ENOMEM;
 
-	dest->stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (!dest->stats.cpustats)
+	ret = ip_vs_stats_init_alloc(&dest->stats);
+	if (ret < 0)
 		goto err_alloc;
 
-	for_each_possible_cpu(i) {
-		struct ip_vs_cpu_stats *ip_vs_dest_stats;
-		ip_vs_dest_stats = per_cpu_ptr(dest->stats.cpustats, i);
-		u64_stats_init(&ip_vs_dest_stats->syncp);
-	}
-
 	dest->af = udest->af;
 	dest->protocol = svc->protocol;
 	dest->vaddr = svc->addr;
@@ -1032,7 +1066,6 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 
 	INIT_HLIST_NODE(&dest->d_list);
 	spin_lock_init(&dest->dst_lock);
-	spin_lock_init(&dest->stats.lock);
 	__ip_vs_update_dest(svc, dest, udest, 1);
 
 	LeaveFunction(2);
@@ -1040,7 +1073,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 
 err_alloc:
 	kfree(dest);
-	return -ENOMEM;
+	return ret;
 }
 
 
@@ -1299,7 +1332,7 @@ static int
 ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 		  struct ip_vs_service **svc_p)
 {
-	int ret = 0, i;
+	int ret = 0;
 	struct ip_vs_scheduler *sched = NULL;
 	struct ip_vs_pe *pe = NULL;
 	struct ip_vs_service *svc = NULL;
@@ -1359,18 +1392,9 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 		ret = -ENOMEM;
 		goto out_err;
 	}
-	svc->stats.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (!svc->stats.cpustats) {
-		ret = -ENOMEM;
+	ret = ip_vs_stats_init_alloc(&svc->stats);
+	if (ret < 0)
 		goto out_err;
-	}
-
-	for_each_possible_cpu(i) {
-		struct ip_vs_cpu_stats *ip_vs_stats;
-		ip_vs_stats = per_cpu_ptr(svc->stats.cpustats, i);
-		u64_stats_init(&ip_vs_stats->syncp);
-	}
-
 
 	/* I'm the first user of the service */
 	atomic_set(&svc->refcnt, 0);
@@ -1387,7 +1411,6 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 
 	INIT_LIST_HEAD(&svc->destinations);
 	spin_lock_init(&svc->sched_lock);
-	spin_lock_init(&svc->stats.lock);
 
 	/* Bind the scheduler */
 	if (sched) {
@@ -4166,7 +4189,7 @@ static struct notifier_block ip_vs_dst_notifier = {
 
 int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 {
-	int i, idx;
+	int idx;
 
 	/* Initialize rs_table */
 	for (idx = 0; idx < IP_VS_RTAB_SIZE; idx++)
@@ -4183,18 +4206,9 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 	ipvs->tot_stats = kzalloc(sizeof(*ipvs->tot_stats), GFP_KERNEL);
 	if (!ipvs->tot_stats)
 		return -ENOMEM;
-	ipvs->tot_stats->s.cpustats = alloc_percpu(struct ip_vs_cpu_stats);
-	if (!ipvs->tot_stats->s.cpustats)
+	if (ip_vs_stats_init_alloc(&ipvs->tot_stats->s) < 0)
 		goto err_tot_stats;
 
-	for_each_possible_cpu(i) {
-		struct ip_vs_cpu_stats *ipvs_tot_stats;
-		ipvs_tot_stats = per_cpu_ptr(ipvs->tot_stats->s.cpustats, i);
-		u64_stats_init(&ipvs_tot_stats->syncp);
-	}
-
-	spin_lock_init(&ipvs->tot_stats->s.lock);
-
 #ifdef CONFIG_PROC_FS
 	if (!proc_create_net("ip_vs", 0, ipvs->net->proc_net,
 			     &ip_vs_info_seq_ops, sizeof(struct ip_vs_iter)))
@@ -4225,7 +4239,7 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 
 err_vs:
 #endif
-	free_percpu(ipvs->tot_stats->s.cpustats);
+	ip_vs_stats_release(&ipvs->tot_stats->s);
 
 err_tot_stats:
 	kfree(ipvs->tot_stats);
-- 
2.38.1


