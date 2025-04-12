Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAC518C035;
	Sat, 12 Apr 2025 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744478821; cv=none; b=Gag2LDgJ1Fk8sGJWKYxyhHLxaFbay49ET5vAH5H3M4/jHEURum65bQ3POEKkH+tSLGv3KCNyB1TO+TnHr/U2RkY0hc+TVj8Bu9upakVhHsqTI2OPrgo6MiobXr3JRp5WCtARyVFSnbRnvE+Y4FKXyyNXAmv0Rp9m1Xy9Ab6vpHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744478821; c=relaxed/simple;
	bh=rntbUba3VSODfucFgd/aEty8d+8oEPtjZTsGP/8gO8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TGVUJQ/ng3HxkHPCpBF42cl2fH4TEWKBXA+1YqdGt9XE10ZhdXnVlGZYqivdI9arbGpYxzcMYx0c4UhE6pGBDDtdxELzMjyH4f7p6OVo86R4SexHXx4ZLucTB2JIad9Zwoi/UT/RcjLv34tyRHt5v5h3BxGLLoTmmYKaPrSPZJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=a+PylrlD; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="a+PylrlD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=1PbZA
	dHOMzXKSunlx61DMfXhxLlD4hJummMQ3WG5sXA=; b=a+PylrlDlO9dEhz+GuMCL
	wnBQ7vYSnHXrWd8vWjxGcY4YEECLei4Hk/3mtNUYcPcNKxezr7UbtCY27RYcYX/S
	x0zw66jLd9FhxH4ojuc12T9lzg0jF/+NLHUlN1Tlg28hoN1ta0Ebpdx5KLXXdAOy
	WqMVcd1udekvE6x9DkfIcQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wB3Vfg0ovpnzpIFGA--.26751S4;
	Sun, 13 Apr 2025 01:26:13 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: xiafei_xupt@163.com
Cc: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kadlec@netfilter.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org
Subject: [PATCH V5] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Sun, 13 Apr 2025 01:26:10 +0800
Message-Id: <20250412172610.37844-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250407095052.49526-1-xiafei_xupt@163.com>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3Vfg0ovpnzpIFGA--.26751S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3tFy5ZryUWry5AFy7GF43GFg_yoWDXw15pF
	1ft347Jw17Jr4Yya1j93yDAFsxG393Ca4a9rn8CFyrCwsI9r15CF4rKFyxJF98JrykAFy3
	ZF4jvr1UAan5taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRdsqAUUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMRQtU2f6mL7IKwAAsD

From: lvxiafei <lvxiafei@sensetime.com>

Support net.netfilter.nf_conntrack_max settings per
netns, net.netfilter.nf_conntrack_max is used to more
flexibly limit the ct_count in different netns. The
default value belongs to the init_net limit.

After net.netfilter.nf_conntrack_max is set in different
netns, it is not allowed to be greater than the init_net
limit when working.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 .../networking/nf_conntrack-sysctl.rst        | 29 +++++++++++++++----
 include/net/netfilter/nf_conntrack.h          |  8 ++++-
 include/net/netns/conntrack.h                 |  1 +
 net/netfilter/nf_conntrack_core.c             | 19 ++++++------
 net/netfilter/nf_conntrack_netlink.c          |  2 +-
 net/netfilter/nf_conntrack_standalone.c       |  7 +++--
 6 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 238b66d0e059..6e7f17f5959a 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -93,12 +93,29 @@ nf_conntrack_log_invalid - INTEGER
 	Log invalid packets of a type specified by value.
 
 nf_conntrack_max - INTEGER
-        Maximum number of allowed connection tracking entries. This value is set
-        to nf_conntrack_buckets by default.
-        Note that connection tracking entries are added to the table twice -- once
-        for the original direction and once for the reply direction (i.e., with
-        the reversed address). This means that with default settings a maxed-out
-        table will have a average hash chain length of 2, not 1.
+    - 0 - disabled (unlimited)
+    - not 0 - enabled
+
+    Maximum number of allowed connection tracking entries per netns. This value
+    is set to nf_conntrack_buckets by default.
+
+    Note that connection tracking entries are added to the table twice -- once
+    for the original direction and once for the reply direction (i.e., with
+    the reversed address). This means that with default settings a maxed-out
+    table will have a average hash chain length of 2, not 1.
+
+    The limit of other netns cannot be greater than init_net netns.
+    +----------------+-------------+----------------+
+    | init_net netns | other netns | limit behavior |
+    +----------------+-------------+----------------+
+    | 0              | 0           | unlimited      |
+    +----------------+-------------+----------------+
+    | 0              | not 0       | other          |
+    +----------------+-------------+----------------+
+    | not 0          | 0           | init_net       |
+    +----------------+-------------+----------------+
+    | not 0          | not 0       | min            |
+    +----------------+-------------+----------------+
 
 nf_conntrack_tcp_be_liberal - BOOLEAN
 	- 0 - disabled (default)
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3f02a45773e8..062e67b9a5d7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -320,7 +320,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
-extern unsigned int nf_conntrack_max;
 
 /* must be called with rcu read lock held */
 static inline void
@@ -360,6 +359,13 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 	return net_generic(net, nf_conntrack_net_id);
 }
 
+static inline unsigned int nf_conntrack_max(const struct net *net)
+{
+	return likely(init_net.ct.sysctl_max && net->ct.sysctl_max) ?
+	    min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
+	    max(init_net.ct.sysctl_max, net->ct.sysctl_max);
+}
+
 int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
 int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 			   u16 zone, u8 family, u8 *proto, u16 *mru);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index bae914815aa3..d3fcd0b92b2d 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -102,6 +102,7 @@ struct netns_ct {
 	u8			sysctl_acct;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
+	unsigned int		sysctl_max;
 
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..a738564923ec 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -202,8 +202,6 @@ static void nf_conntrack_all_unlock(void)
 unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
-unsigned int nf_conntrack_max __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -1498,7 +1496,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned int i, hashsz;
 	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
 	unsigned int expired_count = 0;
@@ -1509,8 +1507,6 @@ static void gc_worker(struct work_struct *work)
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
-	if (gc_work->early_drop)
-		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
@@ -1538,6 +1534,7 @@ static void gc_worker(struct work_struct *work)
 		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
+			unsigned int nf_conntrack_max95 = 0;
 			struct nf_conntrack_net *cnet;
 			struct net *net;
 			long expires;
@@ -1567,11 +1564,14 @@ static void gc_worker(struct work_struct *work)
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
@@ -1648,13 +1648,14 @@ __nf_conntrack_alloc(struct net *net,
 		     gfp_t gfp, u32 hash)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-	unsigned int ct_count;
+	unsigned int ct_max, ct_count;
 	struct nf_conn *ct;
 
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
+	ct_max = nf_conntrack_max(net);
 
-	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+	if (ct_max && unlikely(ct_count > ct_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
@@ -2650,7 +2651,7 @@ int nf_conntrack_init_start(void)
 	if (!nf_conntrack_hash)
 		return -ENOMEM;
 
-	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
+	init_net.ct.sysctl_max = max_factor * nf_conntrack_htable_size;
 
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2cc0fde23344..73e6bb1e939b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2608,7 +2608,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
+	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max(net))))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..5db6df0e4eb3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -615,7 +615,7 @@ enum nf_ct_sysctl_index {
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -948,7 +948,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -1063,6 +1063,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 	table[NF_SYSCTL_CT_COUNT].data = &cnet->count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
+	table[NF_SYSCTL_CT_MAX].data = &net->ct.sysctl_max;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
@@ -1087,7 +1088,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 	/* Don't allow non-init_net ns to alter global sysctls */
 	if (!net_eq(&init_net, net)) {
-		table[NF_SYSCTL_CT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
@@ -1139,6 +1139,7 @@ static int nf_conntrack_pernet_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_checksum = 1;
+	net->ct.sysctl_max = init_net.ct.sysctl_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-- 
2.40.1

