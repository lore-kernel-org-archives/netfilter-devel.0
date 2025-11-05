Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C25338597
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361308; cv=none; b=YN0nCv6mLKVEExDz17Lve4KvkqKC2k+BkJSmXg0mANNTBTH0nUzkXXHucI9TiS/x4yCvaMGqqeHsLfCDtfU3xH7v7XgW03QI4fQz/QttCWiCz6AFCKtLEPuMvmOsS1I7qXKvWa2R3vGdypPKNc5EmE1QJ65EUxLvx/0Q2w/dHEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361308; c=relaxed/simple;
	bh=weovkV4PtMDHoYBky2ag8Zz7giF2Da93+PW6FRi3d5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um7tjTpKurYYARpXZcD78l45lRmAIAjd31CKTnj3CjI73Bcx8V1+ddYstK0Z+Dpk3Emua8rdThOv8vviuzyUsEYcsQnpbbcvlF/K+qNMjNe7LSLlW091thK4tuHysBOgqDgRlYTL2t0nPsBlZdKZA6hnfoTQMXRdkWmPZfF9b3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 05532603B8; Wed,  5 Nov 2025 17:48:18 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 01/11] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Wed,  5 Nov 2025 17:47:55 +0100
Message-ID: <20251105164805.3992-2-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: lvxiafei <lvxiafei@sensetime.com>

Support net.netfilter.nf_conntrack_max settings per
netns, net.netfilter.nf_conntrack_max is used to more
flexibly limit the ct_count in different netns. The
default value belongs to the init_net limit.

After net.netfilter.nf_conntrack_max is set in different
netns, it is not allowed to be greater than the init_net
limit when working.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../networking/nf_conntrack-sysctl.rst        |  7 +++++--
 include/net/netfilter/nf_conntrack.h          | 10 +++++++++-
 include/net/netns/conntrack.h                 |  1 +
 net/netfilter/nf_conntrack_core.c             | 20 ++++++++++---------
 net/netfilter/nf_conntrack_netlink.c          |  2 +-
 net/netfilter/nf_conntrack_standalone.c       |  7 ++++---
 6 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 35f889259fcd..eaf11ec1f4dc 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -92,13 +92,16 @@ nf_conntrack_log_invalid - INTEGER
 	Log invalid packets of a type specified by value.
 
 nf_conntrack_max - INTEGER
-        Maximum number of allowed connection tracking entries. This value is set
-        to nf_conntrack_buckets by default.
+        Maximum number of allowed connection tracking entries per netns.
+        This value is set to nf_conntrack_buckets by default.
+
         Note that connection tracking entries are added to the table twice -- once
         for the original direction and once for the reply direction (i.e., with
         the reversed address). This means that with default settings a maxed-out
         table will have a average hash chain length of 2, not 1.
 
+        The limit of other netns cannot be greater than init_net netns.
+
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
 	- not 0 - enabled
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index aa0a7c82199e..d404e1352737 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -329,7 +329,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
-extern unsigned int nf_conntrack_max;
 
 /* must be called with rcu read lock held */
 static inline void
@@ -369,6 +368,15 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 	return net_generic(net, nf_conntrack_net_id);
 }
 
+static inline unsigned int nf_conntrack_max(const struct net *net)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	return min(init_net.ct.sysctl_max, net->ct.sysctl_max);
+#else
+	return 0;
+#endif
+}
+
 int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
 int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 			   u16 zone, u8 family, u8 *proto, u16 *mru);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index ab74b5ed0b01..2e7707b7d349 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -89,6 +89,7 @@ struct netns_ct {
 	u8			sysctl_acct;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
+	unsigned int		sysctl_max;
 
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0b95f226f211..210792a2275d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -202,8 +202,6 @@ static void nf_conntrack_all_unlock(void)
 unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
-unsigned int nf_conntrack_max __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -1512,7 +1510,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned int i, hashsz;
 	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
 	unsigned int expired_count = 0;
@@ -1523,8 +1521,6 @@ static void gc_worker(struct work_struct *work)
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
-	if (gc_work->early_drop)
-		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
@@ -1552,6 +1548,7 @@ static void gc_worker(struct work_struct *work)
 		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
+			unsigned int nf_conntrack_max95 = 0;
 			struct nf_conntrack_net *cnet;
 			struct net *net;
 			long expires;
@@ -1581,11 +1578,14 @@ static void gc_worker(struct work_struct *work)
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
 			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
+			net = nf_ct_net(tmp);
+
+			if (gc_work->early_drop)
+				nf_conntrack_max95 = nf_conntrack_max(net) / 100u * 95u;
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
-			net = nf_ct_net(tmp);
 			cnet = nf_ct_pernet(net);
 			if (atomic_read(&cnet->count) < nf_conntrack_max95)
 				continue;
@@ -1662,13 +1662,15 @@ __nf_conntrack_alloc(struct net *net,
 		     gfp_t gfp, u32 hash)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-	unsigned int ct_count;
+	unsigned int ct_max, ct_count;
 	struct nf_conn *ct;
 
+	ct_max = nf_conntrack_max(net);
+
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
 
-	if (unlikely(ct_count > nf_conntrack_max)) {
+	if (unlikely(ct_count > ct_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
@@ -2663,7 +2665,7 @@ int nf_conntrack_init_start(void)
 	if (!nf_conntrack_hash)
 		return -ENOMEM;
 
-	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
+	init_net.ct.sysctl_max = max_factor * nf_conntrack_htable_size;
 
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a04665adf99..df243d494afd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2590,7 +2590,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
+	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max(net))))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 207b240b14e5..787c506c15bd 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -644,7 +644,7 @@ enum nf_ct_sysctl_index {
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -925,7 +925,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -1017,6 +1017,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 	table[NF_SYSCTL_CT_COUNT].data = &cnet->count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
+	table[NF_SYSCTL_CT_MAX].data = &net->ct.sysctl_max;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -1040,7 +1041,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 	/* Don't allow non-init_net ns to alter global sysctls */
 	if (!net_eq(&init_net, net)) {
-		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
@@ -1092,6 +1092,7 @@ static int nf_conntrack_pernet_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_checksum = 1;
+	net->ct.sysctl_max = init_net.ct.sysctl_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-- 
2.51.0

