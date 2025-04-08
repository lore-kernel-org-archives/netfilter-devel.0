Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93670263C7D;
	Tue,  8 Apr 2025 09:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744103077; cv=none; b=BftlNbswQukge1adBnJh6gmOaqUczbxl99QHrBsoBiKN13l5SjPVPjM/Zd5H5x9xSKlO/Zc8EAq+YZRvr0uvw09qxAx8RZuYAAi8aJFvsDdZKqLngq6NWXSDvRE70fZw0wYzXcVN0LBZGn1og9YxrDh/SHHlZV3sZUpxgEV+RM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744103077; c=relaxed/simple;
	bh=OTyX75lDMU3gMXAaEeIZlu19SOkg8wcprcXK2/EG9ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uDYui5cD0ORWgXwXzdOLl8WaZvQtGz48mZnw3yxCgnlNMWfvqLItQfkGZMD4K6GA7PmqBOk12IrH9aTIejKhKG+rvo0N5ywRbLkGsFmLOQ+RRpgulzeNiX7SsANjCk/O4Pk0gmlCZJ+SJFe6Of2vSjYNAN5TMfoqDUXUBZE62zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Gc2ZCxtj; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Gc2ZCxtj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Etl63
	S/uH+mMzwNBGz9DMtiXsfI/z8eSAez5OtoJqlA=; b=Gc2ZCxtjRJ/ZBd54Hf+kb
	6ioAGHT30PQco8OQHIS91idd1NVNnhneAp5Nnn54THnOnb/wBrw7nF0B/2q+HyM0
	z6zmJw3sK/20aOL3MVB1ApJnbzvLvR8iIuXJVHc9VZEI6R+QLQ7xaECtcXJ1vJyx
	BbRzWwJRwNyDPehJAPco74=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnd4R+5vRn0J0jEw--.13512S4;
	Tue, 08 Apr 2025 17:04:00 +0800 (CST)
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
Subject: [PATCH V2] netfilter: netns nf_conntrack: per-netns net.netfilter.nf_conntrack_max sysctl
Date: Tue,  8 Apr 2025 17:03:32 +0800
Message-Id: <20250408090332.65296-1-xiafei_xupt@163.com>
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
X-CM-TRANSID:_____wDnd4R+5vRn0J0jEw--.13512S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3JF1UCFWfGFWDtw4UWFWUCFg_yoW7Xr1xpF
	n5t3y7t3y7Jr4Yya18u3ykZF43Kws3CFya9rn8Ja4FywsIgry5Ca1rGFWxtF98tr40yFy3
	ZF4jqr17Aa1ktFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRY2NtUUUUU=
X-CM-SenderInfo: x0ldwvplb031rw6rljoofrz/1tbiEA8pU2f03D+DxQABsS

From: lvxiafei <lvxiafei@sensetime.com>

Support nf_conntrack_max settings in different netns,
nf_conntrack_max is used to more flexibly limit the
ct_count in different netns, which may be greater than
the value in the parent namespace. The default value
belongs to the global (ancestral) limit and no implicit
limit is inherited from the parent namespace.

Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
---
 include/net/netns/conntrack.h           |  1 +
 net/netfilter/nf_conntrack_core.c       | 12 +++++++-----
 net/netfilter/nf_conntrack_standalone.c |  7 ++++---
 3 files changed, 12 insertions(+), 8 deletions(-)

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
index 2f666751c7e7..77c9c01c7278 100644
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
+	net->ct.sysctl_max = nf_conntrack_max;
 
 	ret = nf_conntrack_standalone_init_sysctl(net);
 	if (ret < 0)
-- 
2.40.1

