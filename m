From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 06/10] nf_nat: Removes unused nf_nat_module_is_loaded
Date: Tue, 26 Jun 2007 02:22:07 +0900 (JST)
Message-ID: <200706251722.l5PHM8FW004526@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_nat.h                 |    2 --
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 ---
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 --
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 712edec..b642dae 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -93,8 +93,6 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 	return nf_ct_ext_find(ct, NF_CT_EXT_NAT);
 }
 
-extern int nf_nat_module_is_loaded;
-
 #else  /* !__KERNEL__: iptables wants this to compile. */
 #define nf_nat_multi_range nf_nat_multi_range_compat
 #endif /*__KERNEL__*/
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 96f641d..7411dd1 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -103,9 +103,6 @@ ipv4_prepare(struct sk_buff **pskb, unsigned int hooknum, unsigned int *dataoff,
 	return NF_ACCEPT;
 }
 
-int nf_nat_module_is_loaded = 0;
-EXPORT_SYMBOL_GPL(nf_nat_module_is_loaded);
-
 static u_int32_t ipv4_get_features(const struct nf_conntrack_tuple *tuple)
 {
 	return NF_CT_F_BASIC;
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 2dfa931..16dfa5a 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -350,7 +350,6 @@ static int __init nf_nat_standalone_init(void)
 		printk("nf_nat_init: can't register hooks.\n");
 		goto cleanup_rule_init;
 	}
-	nf_nat_module_is_loaded = 1;
 	return ret;
 
  cleanup_rule_init:
@@ -367,7 +366,6 @@ static void __exit nf_nat_standalone_fini(void)
 {
 	nf_unregister_hooks(nf_nat_ops, ARRAY_SIZE(nf_nat_ops));
 	nf_nat_rule_cleanup();
-	nf_nat_module_is_loaded = 0;
 #ifdef CONFIG_XFRM
 	ip_nat_decode_session = NULL;
 	synchronize_net();
-- 
1.5.2.2
