Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30810230BCD;
	Mon,  7 Apr 2025 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744019645; cv=none; b=gZRAr/X/4UMfywZJdb54dmpw/h33pupbBCGqI4xrElmUm6IWU0zqKJMHDB2okSxskZUAIdOF+hpV4uKZwfgGZ4DtlN9azaUHK4C0hp1X3m9Zyaib27GigYWDqmuN3BPlUM4j7t1ZFc+HB7hOFRCG4Lx0rcF8od449YL76HaGgtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744019645; c=relaxed/simple;
	bh=AMs5E/7vQcoP8JN9w616wirweniY6V8tlDMDX8ZpMuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DXfwnBzmKqprSzYQXqsVfFotHgELDMdgk7h6EAD72lQYCGFa4qPZqgUkDhrBmrU/uXcVdLROGjdYCfRkBXBRr5O+KMEphJGGTaNU+LS43QrLRCltHxD+J1OjAGTLCZxNl8J6iKqGrL19B8lFJQ+Zf68y+uuXyuiobVYnnMt6YxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=beIMauX9; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="beIMauX9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=u3iQT
	sgB3fD+GDZqARLvaV5AEywdpsJ78jzKEjbTXJk=; b=beIMauX98rUS6wmxCp8VD
	LDc5admd8h6chAxW6WyYyfGEEyIMK8wHPvmrPjnN0ywF1Q02fr1ht6c1y2RHdTrm
	bscSqEdCHCzbEYrPYGHFV3FVOvYOoIageM/qOaXk0SZz4nwBVCnL6B5njz4iKYMQ
	G3j6i1vR/1SFQ2q+8lF8lU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDnJwOToPNnTOavEg--.16370S4;
	Mon, 07 Apr 2025 17:53:25 +0800 (CST)
From: lvxiafei <xiafei_xupt@163.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: lvxiafei <lvxiafei@sensetime.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Mon,  7 Apr 2025 17:50:51 +0800
Message-Id: <20250407095052.49526-1-xiafei_xupt@163.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnJwOToPNnTOavEg--.16370S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWDtr1rZw1kGrWrCFWUCFg_yoWruF1DpF
	n5t3y7tw47Jr4Yya18u3ykZF43Kws3C34a9rn8Ja4FywsxKry5Ga1rGFyxtF98tr40yFy3
	ZF4jqr17Aa1ktFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZ0edUUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/xtbBMRIoU2fzmdGv8QAAsa

From: lvxiafei <lvxiafei@sensetime.com>

The modification of nf_conntrack_max in one netns
should not affect the value in another one.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 include/net/netns/conntrack.h           |  1 +
 net/netfilter/nf_conntrack_core.c       | 12 +++++++-----
 net/netfilter/nf_conntrack_standalone.c |  6 ++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

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
index 7f8b245e287a..5f0dbd358d66 100644
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
+				nf_conntrack_max95 = net->ct.sysctl_max / 100u * 95u;
 
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
+	if (net->ct.sysctl_max && unlikely(ct_count > net->ct.sysctl_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 2f666751c7e7..5ac1893e9045 100644
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
@@ -1139,6 +1140,7 @@ static int nf_conntrack_pernet_init(struct net *net)
 	int ret;
 
 	net->ct.sysctl_checksum = 1;
+	net->ct.sysctl_max = nf_conntrack_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-- 
2.40.1

