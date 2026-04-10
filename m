Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B209284B37;
	Fri, 10 Apr 2026 11:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820247; cv=none; b=CmTbuyXko3WPl7CohG55XkoqKu/w+xWIZvp2JzpAarKGytoUXjM2uf1TQuega+kT263STK6Glvimi6ltptqmCjl3iqUjvGQQRDxbRNsp4NgFZ1kUqP6B2XhHVPdqf1E8kTI6GfGD+wRg6OEMmk2FY/0ZtSJdj8Ik7ZuCaYdUIsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820247; c=relaxed/simple;
	bh=9AuAAHNhUFBBT3Jd+R7NHtBE6sStdcftR8LBWk6DYN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9UFyECi5UkPwmgzTUaVwyWpjcefgs6bpwTKVrnOb09uUB5U68Uzi2BWS0CwwbXMnESu+9GwBt5pVnn1wSvsd/Pj+P2jarhxErYSvYczl0hnbHN8wUpwqxr/91LN1IZJb0elCz/BqM+0YXoZgoTPd+r9tWNelRvWu3Qeil3NUeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E5F516065F; Fri, 10 Apr 2026 13:24:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 02/11] ipvs: add ip_vs_status info
Date: Fri, 10 Apr 2026 13:23:43 +0200
Message-ID: <20260410112352.23599-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Add /proc/net/ip_vs_status to show current state of IPVS.

The motivation for this new /proc interface is to provide the output
for the users to help them decide when to tune the load factor for
hash tables, which is possible with the new sysctl knobs coming in
followup patch.

The output also includes information for the kthreads used for stats.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 145 +++++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 1322dd54ed7c..fb1df61edfdd 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2924,6 +2924,144 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 
 	return 0;
 }
+
+static int ip_vs_status_show(struct seq_file *seq, void *v)
+{
+	struct net *net = seq_file_single_net(seq);
+	struct netns_ipvs *ipvs = net_ipvs(net);
+	unsigned int resched_score = 0;
+	struct ip_vs_conn_hnode *hn;
+	struct hlist_bl_head *head;
+	struct ip_vs_service *svc;
+	struct ip_vs_rht *t, *pt;
+	struct hlist_bl_node *e;
+	int old_gen, new_gen;
+	u32 counts[8];
+	u32 bucket;
+	int count;
+	u32 sum1;
+	u32 sum;
+	int i;
+
+	rcu_read_lock();
+
+	t = rcu_dereference(ipvs->conn_tab);
+
+	seq_printf(seq, "Conns:\t%d\n", atomic_read(&ipvs->conn_count));
+	seq_printf(seq, "Conn buckets:\t%d (%d bits, lfactor %d)\n",
+		   t ? t->size : 0, t ? t->bits : 0, t ? t->lfactor : 0);
+
+	if (!atomic_read(&ipvs->conn_count))
+		goto after_conns;
+	old_gen = atomic_read(&ipvs->conn_tab_changes);
+
+repeat_conn:
+	smp_rmb(); /* ipvs->conn_tab and conn_tab_changes */
+	memset(counts, 0, sizeof(counts));
+	ip_vs_rht_for_each_table_rcu(ipvs->conn_tab, t, pt) {
+		for (bucket = 0; bucket < t->size; bucket++) {
+			DECLARE_IP_VS_RHT_WALK_BUCKET_RCU();
+
+			count = 0;
+			resched_score++;
+			ip_vs_rht_walk_bucket_rcu(t, bucket, head) {
+				count = 0;
+				hlist_bl_for_each_entry_rcu(hn, e, head, node)
+					count++;
+			}
+			resched_score += count;
+			if (resched_score >= 100) {
+				resched_score = 0;
+				cond_resched_rcu();
+				new_gen = atomic_read(&ipvs->conn_tab_changes);
+				/* New table installed ? */
+				if (old_gen != new_gen) {
+					old_gen = new_gen;
+					goto repeat_conn;
+				}
+			}
+			counts[min(count, (int)ARRAY_SIZE(counts) - 1)]++;
+		}
+	}
+	for (sum = 0, i = 0; i < ARRAY_SIZE(counts); i++)
+		sum += counts[i];
+	sum1 = sum - counts[0];
+	seq_printf(seq, "Conn buckets empty:\t%u (%lu%%)\n",
+		   counts[0], (unsigned long)counts[0] * 100 / max(sum, 1U));
+	for (i = 1; i < ARRAY_SIZE(counts); i++) {
+		if (!counts[i])
+			continue;
+		seq_printf(seq, "Conn buckets len-%d:\t%u (%lu%%)\n",
+			   i, counts[i],
+			   (unsigned long)counts[i] * 100 / max(sum1, 1U));
+	}
+
+after_conns:
+	t = rcu_dereference(ipvs->svc_table);
+
+	count = ip_vs_get_num_services(ipvs);
+	seq_printf(seq, "Services:\t%d\n", count);
+	seq_printf(seq, "Service buckets:\t%d (%d bits, lfactor %d)\n",
+		   t ? t->size : 0, t ? t->bits : 0, t ? t->lfactor : 0);
+
+	if (!count)
+		goto after_svc;
+	old_gen = atomic_read(&ipvs->svc_table_changes);
+
+repeat_svc:
+	smp_rmb(); /* ipvs->svc_table and svc_table_changes */
+	memset(counts, 0, sizeof(counts));
+	ip_vs_rht_for_each_table_rcu(ipvs->svc_table, t, pt) {
+		for (bucket = 0; bucket < t->size; bucket++) {
+			DECLARE_IP_VS_RHT_WALK_BUCKET_RCU();
+
+			count = 0;
+			resched_score++;
+			ip_vs_rht_walk_bucket_rcu(t, bucket, head) {
+				count = 0;
+				hlist_bl_for_each_entry_rcu(svc, e, head,
+							    s_list)
+					count++;
+			}
+			resched_score += count;
+			if (resched_score >= 100) {
+				resched_score = 0;
+				cond_resched_rcu();
+				new_gen = atomic_read(&ipvs->svc_table_changes);
+				/* New table installed ? */
+				if (old_gen != new_gen) {
+					old_gen = new_gen;
+					goto repeat_svc;
+				}
+			}
+			counts[min(count, (int)ARRAY_SIZE(counts) - 1)]++;
+		}
+	}
+	for (sum = 0, i = 0; i < ARRAY_SIZE(counts); i++)
+		sum += counts[i];
+	sum1 = sum - counts[0];
+	seq_printf(seq, "Service buckets empty:\t%u (%lu%%)\n",
+		   counts[0], (unsigned long)counts[0] * 100 / max(sum, 1U));
+	for (i = 1; i < ARRAY_SIZE(counts); i++) {
+		if (!counts[i])
+			continue;
+		seq_printf(seq, "Service buckets len-%d:\t%u (%lu%%)\n",
+			   i, counts[i],
+			   (unsigned long)counts[i] * 100 / max(sum1, 1U));
+	}
+
+after_svc:
+	seq_printf(seq, "Stats thread slots:\t%d (max %lu)\n",
+		   ipvs->est_kt_count, ipvs->est_max_threads);
+	seq_printf(seq, "Stats chain max len:\t%d\n", ipvs->est_chain_max);
+	seq_printf(seq, "Stats thread ests:\t%d\n",
+		   ipvs->est_chain_max * IPVS_EST_CHAIN_FACTOR *
+		   IPVS_EST_NTICKS);
+
+	rcu_read_unlock();
+	return 0;
+}
+
 #endif
 
 /*
@@ -4825,6 +4963,9 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 				    ipvs->net->proc_net,
 				    ip_vs_stats_percpu_show, NULL))
 		goto err_percpu;
+	if (!proc_create_net_single("ip_vs_status", 0, ipvs->net->proc_net,
+				    ip_vs_status_show, NULL))
+		goto err_status;
 #endif
 
 	ret = ip_vs_control_net_init_sysctl(ipvs);
@@ -4835,6 +4976,9 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 
 err:
 #ifdef CONFIG_PROC_FS
+	remove_proc_entry("ip_vs_status", ipvs->net->proc_net);
+
+err_status:
 	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
 
 err_percpu:
@@ -4860,6 +5004,7 @@ void __net_exit ip_vs_control_net_cleanup(struct netns_ipvs *ipvs)
 	ip_vs_control_net_cleanup_sysctl(ipvs);
 	cancel_delayed_work_sync(&ipvs->est_reload_work);
 #ifdef CONFIG_PROC_FS
+	remove_proc_entry("ip_vs_status", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs", ipvs->net->proc_net);
-- 
2.52.0

