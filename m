From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 2/5] netfilter: register sysctl table for gre
Date: Wed,  5 Dec 2018 20:56:27 +0800
Message-ID: <1544014590-14429-2-git-send-email-laoar.shao@gmail.com>
References: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, adobriyan@gmail.com, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

After this patch, there will be two sysctl knobs for GRE.

	net.netfilter.nf_conntrack_gre_timeout_replied = 180
	net.netfilter.nf_conntrack_gre_timeout_unreplied = 30

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 net/netfilter/nf_conntrack_proto_gre.c | 43 +++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 2a5e56c..a70894e 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -320,9 +320,50 @@ static int gre_timeout_nlattr_to_obj(struct nlattr *tb[],
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table gre_sysctl_table[] = {
+	{
+		.procname       = "nf_conntrack_gre_timeout_unreplied",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+	{
+		.procname       = "nf_conntrack_gre_timeout_replied",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
+	{}
+};
+#endif /* CONFIG_SYSCTL */
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
+
+	return 0;
+}
+
 static int gre_init_net(struct net *net)
 {
 	struct netns_proto_gre *net_gre = gre_pernet(net);
+	struct nf_proto_net *nf = &net_gre->nf;
 	int i;
 
 	rwlock_init(&net_gre->keymap_lock);
@@ -330,7 +371,7 @@ static int gre_init_net(struct net *net)
 	for (i = 0; i < GRE_CT_MAX; i++)
 		net_gre->gre_timeouts[i] = gre_timeouts[i];
 
-	return 0;
+	return gre_kmemdup_sysctl_table(net, nf, net_gre);
 }
 
 /* protocol helper struct */
-- 
1.8.3.1
