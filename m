From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/15] ipvs: register conntrack hooks for ftp
Date: Mon, 11 Jun 2018 11:22:21 +0200
Message-ID: <20180611092233.3219-4-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

ip_vs_ftp requires conntrack modules for mangling
of FTP command responses in passive mode.

Make sure the conntrack hooks are registered when
real servers use NAT method in FTP virtual service.
The hooks will be registered while the service is
present.

Fixes: 0c66dc1ea3f0 ("netfilter: conntrack: register hooks in netns when needed by ruleset")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h            | 30 ++++++++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_ctl.c |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index eb0bec043c96..ae72d9057eda 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -643,6 +643,7 @@ struct ip_vs_service {
 
 	/* alternate persistence engine */
 	struct ip_vs_pe __rcu	*pe;
+	int			conntrack_afmask;
 
 	struct rcu_head		rcu_head;
 };
@@ -1620,6 +1621,35 @@ static inline bool ip_vs_conn_uses_conntrack(struct ip_vs_conn *cp,
 	return false;
 }
 
+static inline int ip_vs_register_conntrack(struct ip_vs_service *svc)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	int afmask = (svc->af == AF_INET6) ? 2 : 1;
+	int ret = 0;
+
+	if (!(svc->conntrack_afmask & afmask)) {
+		ret = nf_ct_netns_get(svc->ipvs->net, svc->af);
+		if (ret >= 0)
+			svc->conntrack_afmask |= afmask;
+	}
+	return ret;
+#else
+	return 0;
+#endif
+}
+
+static inline void ip_vs_unregister_conntrack(struct ip_vs_service *svc)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	int afmask = (svc->af == AF_INET6) ? 2 : 1;
+
+	if (svc->conntrack_afmask & afmask) {
+		nf_ct_netns_put(svc->ipvs->net, svc->af);
+		svc->conntrack_afmask &= ~afmask;
+	}
+#endif
+}
+
 static inline int
 ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 {
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 3ecca0616d8c..ee0ab278f1f1 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -835,6 +835,9 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 		 *    For now only for NAT!
 		 */
 		ip_vs_rs_hash(ipvs, dest);
+		/* FTP-NAT requires conntrack for mangling */
+		if (svc->port == FTPPORT)
+			ip_vs_register_conntrack(svc);
 	}
 	atomic_set(&dest->conn_flags, conn_flags);
 
@@ -1458,6 +1461,7 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
  */
 static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
 {
+	ip_vs_unregister_conntrack(svc);
 	/* Hold svc to avoid double release from dest_trash */
 	atomic_inc(&svc->refcnt);
 	/*
-- 
2.11.0
