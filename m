From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/33]: Fix PROC_FS=n warnings
Date: Wed, 29 Nov 2006 03:09:33 +0100 (MET)
Message-ID: <20061129020933.21082.68201.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Fix PROC_FS=n warnings

Fix some unused function/variable warnings.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8c6e0e883d2aa1ae8d07fb774cf8760f7f127ab8
tree e0374ef9545a5a681344d1e03c6bd4842d35dd13
parent dd917f544f23dd2581635ef3791a51dd7528bbcb
author Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:54 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:54 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |   22 +++++++++++++++-------
 net/ipv6/netfilter/ip6_queue.c     |    2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 5d43a63..0983650 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -167,7 +167,6 @@ clusterip_config_init(struct ipt_cluster
 			struct net_device *dev)
 {
 	struct clusterip_config *c;
-	char buffer[16];
 
 	c = kzalloc(sizeof(*c), GFP_ATOMIC);
 	if (!c)
@@ -184,12 +183,17 @@ clusterip_config_init(struct ipt_cluster
 	atomic_set(&c->entries, 1);
 
 #ifdef CONFIG_PROC_FS
-	/* create proc dir entry */
-	sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
-	c->pde = create_proc_entry(buffer, S_IWUSR|S_IRUSR, clusterip_procdir);
-	if (!c->pde) {
-		kfree(c);
-		return NULL;
+	{
+		char buffer[16];
+
+		/* create proc dir entry */
+		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
+		c->pde = create_proc_entry(buffer, S_IWUSR|S_IRUSR,
+					   clusterip_procdir);
+		if (!c->pde) {
+			kfree(c);
+			return NULL;
+		}
 	}
 	c->pde->proc_fops = &clusterip_proc_fops;
 	c->pde->data = c;
@@ -202,6 +206,7 @@ #endif
 	return c;
 }
 
+#ifdef CONFIG_PROC_FS
 static int
 clusterip_add_node(struct clusterip_config *c, u_int16_t nodenum)
 {
@@ -229,6 +234,7 @@ clusterip_del_node(struct clusterip_conf
 
 	return 1;
 }
+#endif
 
 static inline u_int32_t
 clusterip_hashfn(struct sk_buff *skb, struct clusterip_config *config)
@@ -734,8 +740,10 @@ #endif /* CONFIG_PROC_FS */
 		CLUSTERIP_VERSION);
 	return 0;
 
+#ifdef CONFIG_PROC_FS
 cleanup_hook:
 	nf_unregister_hook(&cip_arp_ops);
+#endif /* CONFIG_PROC_FS */
 cleanup_target:
 	ipt_unregister_target(&clusterip_tgt);
 	return ret;
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 21908c9..d4d9f18 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -620,6 +620,7 @@ static ctl_table ipq_root_table[] = {
 	{ .ctl_name = 0 }
 };
 
+#ifdef CONFIG_PROC_FS
 static int
 ipq_get_info(char *buffer, char **start, off_t offset, int length)
 {
@@ -653,6 +654,7 @@ ipq_get_info(char *buffer, char **start,
 		len = 0;
 	return len;
 }
+#endif /* CONFIG_PROC_FS */
 
 static struct nf_queue_handler nfqh = {
 	.name	= "ip6_queue",
