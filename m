From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/20]: ipt_CLUSTERIP: add compat code
Date: Fri, 29 Jun 2007 02:45:22 +0200 (MEST)
Message-ID: <20070629004421.25566.43404.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_CLUSTERIP: add compat code

Adjust structure size and don't expect pointers passed in from
userspace to be valid. Also replace an enum in an ABI structure
by a fixed size type.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 67e311cc8a1824345d5ca10a403e93f02ffa5697
tree 52f90efaf5fef264c50e842a9b65da5075cc4fab
parent 9e2478bf5637fa674b2e902e6c220a4ddf787be2
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:19:58 +0200

 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |    4 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c           |   39 +++++++++++++-------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
index d9bceed..daf50be 100644
--- a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -18,13 +18,13 @@ struct clusterip_config;
 struct ipt_clusterip_tgt_info {
 
 	u_int32_t flags;
-	
+
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
 	u_int16_t num_total_nodes;
 	u_int16_t num_local_nodes;
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
-	enum clusterip_hashmode hash_mode;
+	u_int32_t hash_mode;
 	u_int32_t hash_initval;
 
 	struct clusterip_config *config;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1cef3b0..1981ace 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -397,23 +397,7 @@ checkentry(const char *tablename,
 	/* FIXME: further sanity checks */
 
 	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
-	if (config) {
-		if (cipinfo->config != NULL) {
-			/* Case A: This is an entry that gets reloaded, since
-			 * it still has a cipinfo->config pointer. Simply
-			 * increase the entry refcount and return */
-			if (cipinfo->config != config) {
-				printk(KERN_ERR "CLUSTERIP: Reloaded entry "
-				       "has invalid config pointer!\n");
-				return false;
-			}
-		} else {
-			/* Case B: This is a new rule referring to an existing
-			 * clusterip config. */
-			cipinfo->config = config;
-		}
-	} else {
-		/* Case C: This is a completely new clusterip config */
+	if (!config) {
 		if (!(cipinfo->flags & CLUSTERIP_FLAG_NEW)) {
 			printk(KERN_WARNING "CLUSTERIP: no config found for %u.%u.%u.%u, need 'new'\n", NIPQUAD(e->ip.dst.s_addr));
 			return false;
@@ -440,8 +424,8 @@ checkentry(const char *tablename,
 			}
 			dev_mc_add(config->dev,config->clustermac, ETH_ALEN, 0);
 		}
-		cipinfo->config = config;
 	}
+	cipinfo->config = config;
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
@@ -466,13 +450,30 @@ static void destroy(const struct xt_target *target, void *targinfo)
 	nf_ct_l3proto_module_put(target->family);
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ipt_clusterip_tgt_info
+{
+	u_int32_t	flags;
+	u_int8_t	clustermac[6];
+	u_int16_t	num_total_nodes;
+	u_int16_t	num_local_nodes;
+	u_int16_t	local_nodes[CLUSTERIP_MAX_NODES];
+	u_int32_t	hash_mode;
+	u_int32_t	hash_initval;
+	compat_uptr_t	config;
+};
+#endif /* CONFIG_COMPAT */
+
 static struct xt_target clusterip_tgt __read_mostly = {
 	.name		= "CLUSTERIP",
 	.family		= AF_INET,
 	.target		= target,
-	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
 	.checkentry	= checkentry,
 	.destroy	= destroy,
+	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(struct compat_ipt_clusterip_tgt_info),
+#endif /* CONFIG_COMPAT */
 	.me		= THIS_MODULE
 };
 
