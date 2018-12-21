From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/37] netfilter: conntrack: register sysctl table for gre
Date: Fri, 21 Dec 2018 01:28:35 +0100
Message-ID: <20181221002841.28587-32-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

This patch adds two sysctl knobs for GRE:

	net.netfilter.nf_conntrack_gre_timeout = 30
	net.netfilter.nf_conntrack_gre_timeout_stream = 180

Update the Documentation as well.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.txt |  9 +++++
 net/netfilter/nf_conntrack_proto_gre.c           | 42 +++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index e69b2e6a4a29..f75c2ce6e136 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -161,3 +161,12 @@ nf_conntrack_udp_timeout_stream - INTEGER (seconds)
 
 	This extended timeout will be used in case there is an UDP stream
 	detected.
+
+nf_conntrack_gre_timeout - INTEGER (seconds)
+	default 30
+
+nf_conntrack_gre_timeout_stream - INTEGER (seconds)
+	default 180
+
+	This extended timeout will be used in case there is an GRE stream
+	detected.
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 9b48dc8b4b88..d5e76bc37b89 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -332,9 +332,49 @@ gre_timeout_nla_policy[CTA_TIMEOUT_GRE_MAX+1] = {
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table gre_sysctl_table[] = {
+	{
+		.procname       = "nf_conntrack_gre_timeout",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+	{
+		.procname       = "nf_conntrack_gre_timeout_stream",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+	{}
+};
+#endif
+
+static int gre_kmemdup_sysctl_table(struct net *net, struct nf_proto_net *nf,
+				    struct netns_proto_gre *net_gre)
+{
+#ifdef CONFIG_SYSCTL
+	int i;
+
+	if (nf->ctl_table)
+		return 0;
+
+	nf->ctl_table = kmemdup(gre_sysctl_table,
+				sizeof(gre_sysctl_table),
+				GFP_KERNEL);
+	if (!nf->ctl_table)
+		return -ENOMEM;
+
+	for (i = 0; i < GRE_CT_MAX; i++)
+		nf->ctl_table[i].data = &net_gre->gre_timeouts[i];
+#endif
+	return 0;
+}
+
 static int gre_init_net(struct net *net)
 {
 	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_proto_net *nf = &net_gre->nf;
 	int i;
 
 	rwlock_init(&net_gre->keymap_lock);
@@ -342,7 +382,7 @@ static int gre_init_net(struct net *net)
 	for (i = 0; i < GRE_CT_MAX; i++)
 		net_gre->gre_timeouts[i] = gre_timeouts[i];
 
-	return 0;
+	return gre_kmemdup_sysctl_table(net, nf, net_gre);
 }
 
 /* protocol helper struct */
-- 
2.11.0
