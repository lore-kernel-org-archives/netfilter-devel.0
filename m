Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF74F4A28;
	Wed,  9 Apr 2025 04:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744172765; cv=none; b=eqMs4I/ecXY/Ks4OzJDlEZK2E3+BbaPex4FZBPNP68WQEOIjJqJ6DbqsLBc6XS4vZVJ7WFosadyxOSecm3QqCBhkUybXbOhSNswIj3ky4vprMXD7auUYog9OxrOCgbG0hTVxFmFHEZlvGmcorfn4BbLW4u812sTvENYZ/IUa7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744172765; c=relaxed/simple;
	bh=y3Bcb+I+EjqZa5coanHB5n40UQkUGYjg7ViW4OCiMKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jL3wjpx35k6FApFMyJx6rTqK9N5DUMbN9fADZkykwR7YeFaP5taFcUI+JXZW+hOVQE5wWQIihDiAl4HLwshE42HPtRWDnpX6WKf90bi713X9033HTdFIHACTgiMSS5t4zUpiwOUD8FtvPE7Ze+u708fHcjRHMDsjetx0kP628Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bg6e5TW0; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bg6e5TW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=GFIaW
	/qf65vwC5RuDM6niXJXZwfRSNkkotaH+KV6kxo=; b=bg6e5TW0dj7Zaorca6prV
	HuC2HjnOcBuPgXUPFWeh9ReUZyiWQdglmwUleBgnbK/Dbk5tNiC+DZOuhFDa2rW8
	JnDQ1voQhqYFIunfG3/B6zFVjQTghBKvj0GbcF6qEs9RRh01+kgKvS+dY0LQBsiy
	qj2KM6uguiqMVir6RIN5F8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCXb9W89vVnbFWiFA--.62258S4;
	Wed, 09 Apr 2025 12:25:33 +0800 (CST)
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
Subject: [PATCH V3] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Wed,  9 Apr 2025 12:25:15 +0800
Message-Id: <20250409042515.64578-1-xiafei_xupt@163.com>
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
X-CM-TRANSID:_____wCXb9W89vVnbFWiFA--.62258S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw1DKF45CrW5uF4DAw17Awb_yoW7Gr48pF
	1rt3y7t3y7JrWYya1093ykAF45Kws3Ca4a9rn8AFyFywsIgry5Cw4rGFWxtr98Jr10yFy3
	Za1jqr17Aa1ktFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRov38UUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiKB0qU2f18POfVwAAsV

From: lvxiafei <lvxiafei@sensetime.com>

Support net.netfilter.nf_conntrack_max settings in
different netns, net.netfilter.nf_conntrack_max is
used to more flexibly limit the ct_count in different
netns. The default value belongs to the global (ancestral)
limit and no implicit limit is inherited from the parent
namespace.

After net.netfilter.nf_conntrack_max is set in different
netns, it is not allowed to be greater than the global
(ancestral) limit net.nf_conntrack_max when working.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 include/net/netns/conntrack.h           |  1 +
 net/netfilter/nf_conntrack_core.c       | 12 +++++++-----
 net/netfilter/nf_conntrack_standalone.c |  5 +++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index bae914815aa3..dd31ba205419 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -102,6 +102,7 @@ struct netns_ct {
 	u8			sysctl_acct;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
+	u8			sysctl_max;
 
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..4116c2f2b57f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1498,7 +1498,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned int i, hashsz;
 	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
 	unsigned int expired_count = 0;
@@ -1509,8 +1509,6 @@ static void gc_worker(struct work_struct *work)
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
-	if (gc_work->early_drop)
-		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
@@ -1538,6 +1536,7 @@ static void gc_worker(struct work_struct *work)
 		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
+			unsigned int nf_conntrack_max95 = 0;
 			struct nf_conntrack_net *cnet;
 			struct net *net;
 			long expires;
@@ -1567,11 +1566,14 @@ static void gc_worker(struct work_struct *work)
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
 			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
+			net = nf_ct_net(tmp);
+
+			if (gc_work->early_drop)
+				nf_conntrack_max95 = min(nf_conntrack_max, net->ct.sysctl_max) / 100u * 95u;
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
-			net = nf_ct_net(tmp);
 			cnet = nf_ct_pernet(net);
 			if (atomic_read(&cnet->count) < nf_conntrack_max95)
 				continue;
@@ -1654,7 +1656,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
 
-	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+	if (net->ct.sysctl_max && unlikely(ct_count > min(nf_conntrack_max, net->ct.sysctl_max))) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..4a073c4de1b7 100644
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
+	net->ct.sysctl_max = nf_conntrack_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-- 
2.40.1

