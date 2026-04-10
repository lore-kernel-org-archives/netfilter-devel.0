Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B730939A06E;
	Fri, 10 Apr 2026 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820252; cv=none; b=fgaaOJE3WhaJhnh38y0FaCnYI2mIf69Ptq/Qr2rn7V7q9GSNwRK7bzSVJG15NnqmBMwiIME2QLubC/9ZirY3xn7znwqveHDiSmwuPP2Ztp42yJ30SUN2mEK6/zGt4ToOfrah8mKoKdktqA0xMY1M4lJtg/ktdlKdcuTdmu4OLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820252; c=relaxed/simple;
	bh=1tE7XB8kMZHHljrDiTAqlkOhu6G0o8VWm+a5sDa+8Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbT8ZT4gGbk8VhrKsSaorPwKgExv+KO1KqMh9a0IuJ5+BBBj96sz20gdokUU6B11NNpprxD0+zVmQ0HbZR9ui4P/j9PcrNx8FHOSoh/Zy0J1viQE64tVJTP1xNG7wmIhJF/gSXZbkCEWyIIkS1iUcBEgGyoBt2zBUO/Du0iYDWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45F9560B78; Fri, 10 Apr 2026 13:24:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 03/11] ipvs: add conn_lfactor and svc_lfactor sysctl vars
Date: Fri, 10 Apr 2026 13:23:44 +0200
Message-ID: <20260410112352.23599-4-fw@strlen.de>
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

Allow the default load factor for the connection and service tables
to be configured.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Documentation/networking/ipvs-sysctl.rst | 37 ++++++++++++
 net/netfilter/ipvs/ip_vs_ctl.c           | 76 ++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index 3fb5fa142eef..a556439f8be7 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -29,6 +29,33 @@ backup_only - BOOLEAN
 	If set, disable the director function while the server is
 	in backup mode to avoid packet loops for DR/TUN methods.
 
+conn_lfactor - INTEGER
+	Possible values: -8 (larger table) .. 8 (smaller table)
+
+	Default: -4
+
+	Controls the sizing of the connection hash table based on the
+	load factor (number of connections per table buckets):
+
+		2^conn_lfactor = nodes / buckets
+
+	As result, the table grows if load increases and shrinks when
+	load decreases in the range of 2^8 - 2^conn_tab_bits (module
+	parameter).
+	The value is a shift count where negative values select
+	buckets = (connection hash nodes << -value) while positive
+	values select buckets = (connection hash nodes >> value). The
+	negative values reduce the collisions and reduce the time for
+	lookups but increase the table size. Positive values will
+	tolerate load above 100% when using smaller table is
+	preferred with the cost of more collisions. If using NAT
+	connections consider decreasing the value with one because
+	they add two nodes in the hash table.
+
+	Example:
+	-4: grow if load goes above 6% (buckets = nodes * 16)
+	2: grow if load goes above 400% (buckets = nodes / 4)
+
 conn_reuse_mode - INTEGER
 	1 - default
 
@@ -219,6 +246,16 @@ secure_tcp - INTEGER
 	The value definition is the same as that of drop_entry and
 	drop_packet.
 
+svc_lfactor - INTEGER
+	Possible values: -8 (larger table) .. 8 (smaller table)
+
+	Default: -3
+
+	Controls the sizing of the service hash table based on the
+	load factor (number of services per table buckets). The table
+	will grow and shrink in the range of 2^4 - 2^20.
+	See conn_lfactor for explanation.
+
 sync_threshold - vector of 2 INTEGERs: sync_threshold, sync_period
 	default 3 50
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index fb1df61edfdd..6632daa87ded 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2445,6 +2445,60 @@ static int ipvs_proc_run_estimation(const struct ctl_table *table, int write,
 	return ret;
 }
 
+static int ipvs_proc_conn_lfactor(const struct ctl_table *table, int write,
+				  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct netns_ipvs *ipvs = table->extra2;
+	int *valp = table->data;
+	int val = *valp;
+	int ret;
+
+	struct ctl_table tmp_table = {
+		.data = &val,
+		.maxlen = sizeof(int),
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (write && ret >= 0) {
+		if (val < -8 || val > 8) {
+			ret = -EINVAL;
+		} else {
+			*valp = val;
+			if (rcu_access_pointer(ipvs->conn_tab))
+				mod_delayed_work(system_unbound_wq,
+						 &ipvs->conn_resize_work, 0);
+		}
+	}
+	return ret;
+}
+
+static int ipvs_proc_svc_lfactor(const struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct netns_ipvs *ipvs = table->extra2;
+	int *valp = table->data;
+	int val = *valp;
+	int ret;
+
+	struct ctl_table tmp_table = {
+		.data = &val,
+		.maxlen = sizeof(int),
+	};
+
+	ret = proc_dointvec(&tmp_table, write, buffer, lenp, ppos);
+	if (write && ret >= 0) {
+		if (val < -8 || val > 8) {
+			ret = -EINVAL;
+		} else {
+			*valp = val;
+			if (rcu_access_pointer(ipvs->svc_table))
+				mod_delayed_work(system_unbound_wq,
+						 &ipvs->svc_resize_work, 0);
+		}
+	}
+	return ret;
+}
+
 /*
  *	IPVS sysctl table (under the /proc/sys/net/ipv4/vs/)
  *	Do not change order or insert new entries without
@@ -2633,6 +2687,18 @@ static struct ctl_table vs_vars[] = {
 		.mode		= 0644,
 		.proc_handler	= ipvs_proc_est_nice,
 	},
+	{
+		.procname	= "conn_lfactor",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= ipvs_proc_conn_lfactor,
+	},
+	{
+		.procname	= "svc_lfactor",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= ipvs_proc_svc_lfactor,
+	},
 #ifdef CONFIG_IP_VS_DEBUG
 	{
 		.procname	= "debug_level",
@@ -4853,6 +4919,16 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx].extra2 = ipvs;
 	tbl[idx++].data = &ipvs->sysctl_est_nice;
 
+	if (unpriv)
+		tbl[idx].mode = 0444;
+	tbl[idx].extra2 = ipvs;
+	tbl[idx++].data = &ipvs->sysctl_conn_lfactor;
+
+	if (unpriv)
+		tbl[idx].mode = 0444;
+	tbl[idx].extra2 = ipvs;
+	tbl[idx++].data = &ipvs->sysctl_svc_lfactor;
+
 #ifdef CONFIG_IP_VS_DEBUG
 	/* Global sysctls must be ro in non-init netns */
 	if (!net_eq(net, &init_net))
-- 
2.52.0

