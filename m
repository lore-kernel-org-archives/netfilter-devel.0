From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/50]: nf_nat: remove unused nf_nat_module_is_loaded
Date: Sat,  7 Jul 2007 14:23:28 +0200 (MEST)
Message-ID: <20070707122243.1589.52855.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: remove unused nf_nat_module_is_loaded

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a47b56942fdd070a95294e86a1fbae308e035f3a
tree 6d777c1925284d14627ef405a483de592563a272
parent 1beacacb7e0276120e88d5e3cef800e179930d83
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 07 Jul 2007 12:15:32 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:32 +0200

 include/net/netfilter/nf_nat.h                 |    2 --
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 ---
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 --
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0425e28..0541eed 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -95,8 +95,6 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
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
index 51a2708..30eeaa4 100644
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
