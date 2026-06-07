Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA913876C3;
	Sun,  7 Jun 2026 09:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825805; cv=none; b=r+eSHLDsZ8HccTjEqd7EK1O7d5sSiLObPJbj6UQ7fskZqHFBAf7LO+qQ43epWr2lgkc98pGYLO52UocPTyYl6b6xn3PGnixnWVujF+9oNJNTUXCD92kQT9KQev9WzlQD9ouzpOkXAUQtsTaoRxyXlEi16kpiu2oguBQyfhYDbqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825805; c=relaxed/simple;
	bh=pHV0syaI5MU17ue++sexfebjTQlbFGatCziFzkjtydo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHliQCVRjCpFO//yZdzD2bySEfRc25Y0yKV9NCutvBCHTDEnVF5TzRYfJks5F77WvaGdVThwvX7m9ollO15Fk3Vz5IKL/04sh5sZwwP0zJ1QtzsiY9my7CVOAmNRWgt8gv/UMylZV8CwKu8QfK5hlnJ4RqbXuAvGVokGxifG4+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u33kifi0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u33kifi0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 488C76019B;
	Sun,  7 Jun 2026 11:50:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825801;
	bh=zu3RLgp/NTOvR5v2thZhrXbzoq82+1AexyqzIZS2MoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u33kifi0ahgG9r3FyIB9YBLSc4usygUd48LrkBBCgmVRZ/Zg5vNJIZUEmeTXbrzdN
	 7n35dVsgf9VSlsuNEh7YArlTUwhrqPbXLLIbNYFwrTw0yLRT64+bQvi5zqIrb3lFAq
	 TaisYXn/niXwOR37H/1FxNQ93sebV2ZW2DWJQtsPjLy84BU3iKC5Q/MoZ1mP6NCYrE
	 FO0TsxZcwtcvMqjWwxWKJA5M/u521Yafjqf/oexMHRn9/z6OBPgxN7wZTo4zGNqXaT
	 7ey2BgaOQzDQYttqxnS3Vb6edipK1sZ+qM7UJpwZNvlZtuehwBF0E1NYm+v+u4WTLa
	 pgryyVIEZqboA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 01/15] ipvs: add conn_max sysctl to limit connections
Date: Sun,  7 Jun 2026 11:49:40 +0200
Message-ID: <20260607094954.48892-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Currently, we are using atomic_t to track the number of
connections. On 64-bit setups with large memory there is
a risk this counter to overflow. Also, setups with many
containers may need to tune the limit for connections.

Add sysctl control to limit the number of connections to
1,073,741,824 (64-bit) and 16,777,216 (32-bit).
Depending on the admin's privilege, the value is
used to change a soft or hard limit allowing
unprivileged admins to change the soft limit in
range determined by privileged admins.

Link: https://sashiko.dev/#/patchset/20260523172715.94795-1-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260430074420.26697-7-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260522105546.13732-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/ipvs-sysctl.rst | 35 ++++++++++++++++
 include/net/ip_vs.h                      | 22 ++++++++++
 net/netfilter/ipvs/ip_vs_conn.c          | 10 ++++-
 net/netfilter/ipvs/ip_vs_ctl.c           | 53 ++++++++++++++++++++++++
 4 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index a556439f8be7..b6bac2612420 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -56,6 +56,41 @@ conn_lfactor - INTEGER
 	-4: grow if load goes above 6% (buckets = nodes * 16)
 	2: grow if load goes above 400% (buckets = nodes / 4)
 
+conn_max - INTEGER
+	Limit for number of connections, per netns.
+
+	Controls the soft and hard limit for number of connections.
+	Initially, the platform specific limit is assigned for init_net.
+	The value can be changed and later the soft limit propagated
+	to other networking namespaces.
+
+	Privileged admin can change both limits up to the value of the
+	platform limit while the unprivileged admin can change only the
+	soft limit up to the value of the hard limit.
+
+	For setups using conntrack=1 (CONFIG_IP_VS_NFCT for
+	Netfilter connection tracking) the connections can be
+	limited also by nf_conntrack_max.
+
+				soft limit	hard limit
+	=====================================================
+	init_net:
+	create netns		platform	platform
+	priv admin		0 .. platform	0 .. platform
+	=====================================================
+	new netns:
+	create netns		init_net:soft	init_net:soft
+	priv admin		0 .. platform	0 .. platform
+	unpriv admin		0 .. hard	N/A
+
+	Limits per platform:
+	1,073,741,824 (2^30 for 64-bit)
+	   16,777,216 (2^24 for 32-bit)
+
+	Possible values: 0 .. platform limit
+
+	Default: platform limit
+
 conn_reuse_mode - INTEGER
 	1 - default
 
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e517eaaa177b..49297fec448a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -44,6 +44,14 @@
 #define IP_VS_CONN_TAB_MAX_BITS	20
 #endif
 
+/* conn_max limits */
+#if BITS_PER_LONG > 32
+/* Limit of atomic_t but restricted by roundup_pow_of_two() in ip_vs_core.c */
+#define IP_VS_CONN_MAX	(1 << 30)
+#else
+#define IP_VS_CONN_MAX	(1 << 24)
+#endif
+
 /* svc_table limits */
 #define IP_VS_SVC_TAB_MIN_BITS	4
 #define IP_VS_SVC_TAB_MAX_BITS	20
@@ -1220,6 +1228,10 @@ struct netns_ipvs {
 	/* sysctl variables */
 	int			sysctl_amemthresh;
 	int			sysctl_am_droprate;
+#ifdef CONFIG_SYSCTL
+	int			sysctl_conn_max;/* soft limit for conns */
+	int			conn_max_limit;	/* hard limit for conn_max */
+#endif
 	int			sysctl_drop_entry;
 	int			sysctl_drop_packet;
 	int			sysctl_secure_tcp;
@@ -1317,6 +1329,11 @@ struct netns_ipvs {
 
 #ifdef CONFIG_SYSCTL
 
+static inline int sysctl_conn_max(struct netns_ipvs *ipvs)
+{
+	return READ_ONCE(ipvs->sysctl_conn_max);
+}
+
 static inline int sysctl_sync_threshold(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_sync_threshold[0];
@@ -1436,6 +1453,11 @@ static inline int sysctl_est_nice(struct netns_ipvs *ipvs)
 
 #else
 
+static inline int sysctl_conn_max(struct netns_ipvs *ipvs)
+{
+	return IP_VS_CONN_MAX;
+}
+
 static inline int sysctl_sync_threshold(struct netns_ipvs *ipvs)
 {
 	return DEFAULT_SYNC_THRESHOLD;
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 9ea6b4fa78bf..e76a73d183d5 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1358,9 +1358,18 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 	struct netns_ipvs *ipvs = p->ipvs;
 	struct ip_vs_proto_data *pd = ip_vs_proto_data_get(p->ipvs,
 							   p->protocol);
+	/* Increment conn_count up to conn_max */
+	int count = atomic_read(&ipvs->conn_count);
+	int max = sysctl_conn_max(ipvs);
+
+	do {
+		if (count >= max)
+			return NULL;
+	} while (!atomic_try_cmpxchg(&ipvs->conn_count, &count, count + 1));
 
 	cp = kmem_cache_alloc(ip_vs_conn_cachep, GFP_ATOMIC);
 	if (cp == NULL) {
+		atomic_dec(&ipvs->conn_count);
 		IP_VS_ERR_RL("%s(): no memory\n", __func__);
 		return NULL;
 	}
@@ -1414,7 +1423,6 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 	cp->in_seq.delta = 0;
 	cp->out_seq.delta = 0;
 
-	atomic_inc(&ipvs->conn_count);
 	if (unlikely(flags & IP_VS_CONN_F_NO_CPORT)) {
 		int af_id = ip_vs_af_index(cp->af);
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 16daba8cac83..f765d1506839 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2322,6 +2322,45 @@ static int ip_vs_zero_all(struct netns_ipvs *ipvs)
 
 #ifdef CONFIG_SYSCTL
 
+static int
+proc_do_conn_max(const struct ctl_table *table, int write,
+		 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int *valp = table->data;
+	/* We can not use *valp to check if new value is provided, use INT_MIN
+	 * for this because different admins change different limits.
+	 */
+	int unset = INT_MIN;
+	int val = write ? unset : READ_ONCE(*valp);
+	int rc;
+
+	const struct ctl_table tmp = {
+		.data = &val,
+		.maxlen = sizeof(int),
+	};
+
+	rc = proc_dointvec(&tmp, write, buffer, lenp, ppos);
+	if (write && !rc && val != unset) {
+		struct netns_ipvs *ipvs = table->extra2;
+		bool priv = capable(CAP_NET_ADMIN);
+		int max;
+
+		mutex_lock(&ipvs->service_mutex);
+		/* Unprivileged admins can not go above the hard limit */
+		max = priv ? IP_VS_CONN_MAX : ipvs->conn_max_limit;
+		if (val < 0 || val > max) {
+			rc = -EINVAL;
+		} else {
+			/* Privileged admin changes both limits */
+			if (priv)
+				ipvs->conn_max_limit = val;
+			WRITE_ONCE(*valp, val);
+		}
+		mutex_unlock(&ipvs->service_mutex);
+	}
+	return rc;
+}
+
 static int
 proc_do_defense_mode(const struct ctl_table *table, int write,
 		     void *buffer, size_t *lenp, loff_t *ppos)
@@ -2626,6 +2665,12 @@ static struct ctl_table vs_vars[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "conn_max",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_do_conn_max,
+	},
 	{
 		.procname	= "drop_entry",
 		.maxlen		= sizeof(int),
@@ -4980,6 +5025,14 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_amemthresh;
 	ipvs->sysctl_am_droprate = 10;
 	tbl[idx++].data = &ipvs->sysctl_am_droprate;
+
+	/* Inherit both limits from init_net:conn_max */
+	ipvs->conn_max_limit = net_eq(net, &init_net) ? IP_VS_CONN_MAX :
+			       READ_ONCE(*(int *)vs_vars[idx].data);
+	ipvs->sysctl_conn_max = ipvs->conn_max_limit;
+	tbl[idx].extra2 = ipvs;
+	tbl[idx++].data = &ipvs->sysctl_conn_max;
+
 	tbl[idx++].data = &ipvs->sysctl_drop_entry;
 	tbl[idx++].data = &ipvs->sysctl_drop_packet;
 #ifdef CONFIG_IP_VS_NFCT
-- 
2.47.3

