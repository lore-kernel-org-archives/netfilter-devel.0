Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97A284B37;
	Fri, 10 Apr 2026 11:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820244; cv=none; b=kphW/GrCl/YM+Bl/LRY60uXpwExDJQ5yOEEtEmXdso7cRnBDnMQxcG9m6l1nXWYC9LG1wNRIsknamYCkInkeW2jgT9AUMjoYZrpen9F4i6HsUORMNgUD8UrmKZpOQghZRexqDKDDUZxbcEd9C1JoZue6vhRH5hfmBSjQnYBbm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820244; c=relaxed/simple;
	bh=1fWEgmOFVGjp9hv2Jv4wS+znp2ySD6MMvhLvl8kgT7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWqWM3vG+d+WtSV0ysBWUSRon4nq7G3ZtOosEKy+wlfwYxBh7bmehg7DbxAVT085Py07VNubNwGfjm+9vmd0uLcYmwfxwUBMjbB4Giq56H7tIV+dcJkjRDViO31sZQqkYXrVzWxYmLTYnPOWhx7B/A9HaYaJGoNox7gwIz+MLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 966566065F; Fri, 10 Apr 2026 13:24:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/11] ipvs: show the current conn_tab size to users
Date: Fri, 10 Apr 2026 13:23:42 +0200
Message-ID: <20260410112352.23599-2-fw@strlen.de>
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

As conn_tab is per-net, better to show the current hash table size
to users instead of the ip_vs_conn_tab_size (max).

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index a1f070cb76c3..1322dd54ed7c 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -281,6 +281,20 @@ static void est_reload_work_handler(struct work_struct *work)
 	mutex_unlock(&ipvs->est_mutex);
 }
 
+static int get_conn_tab_size(struct netns_ipvs *ipvs)
+{
+	const struct ip_vs_rht *t;
+	int size = 0;
+
+	rcu_read_lock();
+	t = rcu_dereference(ipvs->conn_tab);
+	if (t)
+		size = t->size;
+	rcu_read_unlock();
+
+	return size;
+}
+
 int
 ip_vs_use_count_inc(void)
 {
@@ -2741,10 +2755,13 @@ static void ip_vs_info_seq_stop(struct seq_file *seq, void *v)
 
 static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 {
+	struct net *net = seq_file_net(seq);
+	struct netns_ipvs *ipvs = net_ipvs(net);
+
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq,
 			"IP Virtual Server version %d.%d.%d (size=%d)\n",
-			NVERSION(IP_VS_VERSION_CODE), ip_vs_conn_tab_size);
+			NVERSION(IP_VS_VERSION_CODE), get_conn_tab_size(ipvs));
 		seq_puts(seq,
 			 "Prot LocalAddress:Port Scheduler Flags\n");
 		seq_puts(seq,
@@ -3425,7 +3442,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		char buf[64];
 
 		sprintf(buf, "IP Virtual Server version %d.%d.%d (size=%d)",
-			NVERSION(IP_VS_VERSION_CODE), ip_vs_conn_tab_size);
+			NVERSION(IP_VS_VERSION_CODE), get_conn_tab_size(ipvs));
 		if (copy_to_user(user, buf, strlen(buf)+1) != 0) {
 			ret = -EFAULT;
 			goto out;
@@ -3437,8 +3454,9 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_INFO:
 	{
 		struct ip_vs_getinfo info;
+
 		info.version = IP_VS_VERSION_CODE;
-		info.size = ip_vs_conn_tab_size;
+		info.size = get_conn_tab_size(ipvs);
 		info.num_services =
 			atomic_read(&ipvs->num_services[IP_VS_AF_INET]);
 		if (copy_to_user(user, &info, sizeof(info)) != 0)
@@ -4447,7 +4465,7 @@ static int ip_vs_genl_get_cmd(struct sk_buff *skb, struct genl_info *info)
 		if (nla_put_u32(msg, IPVS_INFO_ATTR_VERSION,
 				IP_VS_VERSION_CODE) ||
 		    nla_put_u32(msg, IPVS_INFO_ATTR_CONN_TAB_SIZE,
-				ip_vs_conn_tab_size))
+				get_conn_tab_size(ipvs)))
 			goto nla_put_failure;
 		break;
 	}
-- 
2.52.0

