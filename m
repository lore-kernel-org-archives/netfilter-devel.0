From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/10]: x_tables: set the protocol family in x_tables
	targets/matches
Date: Wed, 22 Mar 2006 19:47:50 +0100 (MET)
Message-ID: <20060322184750.5655.24522.sendpatchset@localhost.localdomain>
References: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060322184740.5655.7960.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: set the protocol family in x_tables targets/matches

Set the family field in xt_[matches|targets] registered.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 502310b7e97c6bef65b331cd558abd11f5b6a77c
tree 83dbc73b4bb091155db4fd2367cb4a1843a314b6
parent cd2e541eb6c94db1a40862885fd89ccae23dc7ac
author Pablo Neira Ayuso <pablo@netfilter.org> Tue, 21 Mar 2006 22:30:23 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Mar 2006 22:30:23 +0100

 include/linux/netfilter/x_tables.h        |    8 ++++----
 include/linux/netfilter_arp/arp_tables.h  |    6 ++++--
 include/linux/netfilter_ipv4/ip_tables.h  |   14 +++++++++-----
 include/linux/netfilter_ipv6/ip6_tables.h |   14 +++++++++-----
 net/ipv4/netfilter/arp_tables.c           |    6 ++++--
 net/ipv4/netfilter/ip_tables.c            |   15 +++++++++------
 net/ipv6/netfilter/ip6_tables.c           |   15 +++++++++------
 net/netfilter/x_tables.c                  |   16 ++++++++++------
 net/netfilter/xt_CLASSIFY.c               |   12 +++++++-----
 net/netfilter/xt_CONNMARK.c               |   12 +++++++-----
 net/netfilter/xt_MARK.c                   |   21 ++++++++++++---------
 net/netfilter/xt_NFQUEUE.c                |   19 +++++++++++--------
 net/netfilter/xt_NOTRACK.c                |   12 +++++++-----
 net/netfilter/xt_comment.c                |   12 +++++++-----
 net/netfilter/xt_connbytes.c              |   12 +++++++-----
 net/netfilter/xt_connmark.c               |   12 +++++++-----
 net/netfilter/xt_conntrack.c              |    5 +++--
 net/netfilter/xt_dccp.c                   |   12 +++++++-----
 net/netfilter/xt_helper.c                 |   12 +++++++-----
 net/netfilter/xt_length.c                 |   12 +++++++-----
 net/netfilter/xt_limit.c                  |   12 +++++++-----
 net/netfilter/xt_mac.c                    |   12 +++++++-----
 net/netfilter/xt_mark.c                   |   12 +++++++-----
 net/netfilter/xt_physdev.c                |   12 +++++++-----
 net/netfilter/xt_pkttype.c                |   12 +++++++-----
 net/netfilter/xt_policy.c                 |   12 +++++++-----
 net/netfilter/xt_realm.c                  |    5 +++--
 net/netfilter/xt_sctp.c                   |   12 +++++++-----
 net/netfilter/xt_state.c                  |   12 +++++++-----
 net/netfilter/xt_string.c                 |   12 +++++++-----
 net/netfilter/xt_tcpmss.c                 |   12 +++++++-----
 net/netfilter/xt_tcpudp.c                 |   26 +++++++++++++++-----------
 32 files changed, 235 insertions(+), 163 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 46a0f97..bf71efb 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -220,10 +220,10 @@ struct xt_table_info
 	char *entries[NR_CPUS];
 };
 
-extern int xt_register_target(int af, struct xt_target *target);
-extern void xt_unregister_target(int af, struct xt_target *target);
-extern int xt_register_match(int af, struct xt_match *target);
-extern void xt_unregister_match(int af, struct xt_match *target);
+extern int xt_register_target(struct xt_target *target);
+extern void xt_unregister_target(struct xt_target *target);
+extern int xt_register_match(struct xt_match *target);
+extern void xt_unregister_match(struct xt_match *target);
 
 extern int xt_check_match(const struct xt_match *match, unsigned short family,
 			  unsigned int size, const char *table, unsigned int hook,
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index fd21796..a27be05 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -263,8 +263,10 @@ static __inline__ struct arpt_entry_targ
  */
 #ifdef __KERNEL__
 
-#define arpt_register_target(tgt) xt_register_target(NF_ARP, tgt)
-#define arpt_unregister_target(tgt) xt_unregister_target(NF_ARP, tgt)
+#define arpt_register_target(tgt) 	\
+({	(tgt)->family = NF_ARP;		\
+ 	xt_register_target(tgt); })
+#define arpt_unregister_target(tgt) xt_unregister_target(tgt)
 
 extern int arpt_register_table(struct arpt_table *table,
 			       const struct arpt_replace *repl);
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 76ba24b..ee262b5 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -321,11 +321,15 @@ ipt_get_target(struct ipt_entry *e)
 #include <linux/init.h>
 extern void ipt_init(void) __init;
 
-#define ipt_register_target(tgt) xt_register_target(AF_INET, tgt)
-#define ipt_unregister_target(tgt) xt_unregister_target(AF_INET, tgt)
-
-#define ipt_register_match(mtch) xt_register_match(AF_INET, mtch)
-#define ipt_unregister_match(mtch) xt_unregister_match(AF_INET, mtch)
+#define ipt_register_target(tgt) 	\
+({	(tgt)->family = AF_INET;	\
+ 	xt_register_target(tgt); })
+#define ipt_unregister_target(tgt) xt_unregister_target(tgt)
+
+#define ipt_register_match(mtch) 	\
+({	(mtch)->family = AF_INET;	\
+	xt_register_match(mtch); })
+#define ipt_unregister_match(mtch) xt_unregister_match(mtch)
 
 //#define ipt_register_table(tbl, repl) xt_register_table(AF_INET, tbl, repl)
 //#define ipt_unregister_table(tbl) xt_unregister_table(AF_INET, tbl)
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index f249b57..7107f94 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -334,11 +334,15 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
 
-#define ip6t_register_target(tgt) xt_register_target(AF_INET6, tgt)
-#define ip6t_unregister_target(tgt) xt_unregister_target(AF_INET6, tgt)
-
-#define ip6t_register_match(match) xt_register_match(AF_INET6, match)
-#define ip6t_unregister_match(match) xt_unregister_match(AF_INET6, match)
+#define ip6t_register_target(tgt) 		\
+({	(tgt)->family = AF_INET6;		\
+ 	xt_register_target(tgt); })
+#define ip6t_unregister_target(tgt) xt_unregister_target(tgt)
+
+#define ip6t_register_match(match)		\
+({	(match)->family = AF_INET6;		\
+	xt_register_match(match); })
+#define ip6t_unregister_match(match) xt_unregister_match(match)
 
 extern int ip6t_register_table(struct ip6t_table *table,
 			       const struct ip6t_replace *repl);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f7efb3f..ff0c594 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1146,12 +1146,14 @@ void arpt_unregister_table(struct arpt_t
 static struct arpt_target arpt_standard_target = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
+	.family		= NF_ARP,
 };
 
 static struct arpt_target arpt_error_target = {
 	.name		= ARPT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
+	.family		= NF_ARP,
 };
 
 static struct nf_sockopt_ops arpt_sockopts = {
@@ -1171,8 +1173,8 @@ static int __init init(void)
 	xt_proto_init(NF_ARP);
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(NF_ARP, &arpt_standard_target);
-	xt_register_target(NF_ARP, &arpt_error_target);
+	xt_register_target(&arpt_standard_target);
+	xt_register_target(&arpt_error_target);
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&arpt_sockopts);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 39705f9..a7b194c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1335,12 +1335,14 @@ icmp_checkentry(const char *tablename,
 static struct ipt_target ipt_standard_target = {
 	.name		= IPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
+	.family		= AF_INET,
 };
 
 static struct ipt_target ipt_error_target = {
 	.name		= IPT_ERROR_TARGET,
 	.target		= ipt_error,
 	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
+	.family		= AF_INET,
 };
 
 static struct nf_sockopt_ops ipt_sockopts = {
@@ -1358,6 +1360,7 @@ static struct ipt_match icmp_matchstruct
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
 	.proto		= IPPROTO_ICMP,
+	.family		= AF_INET,
 	.checkentry	= icmp_checkentry,
 };
 
@@ -1368,9 +1371,9 @@ static int __init init(void)
 	xt_proto_init(AF_INET);
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(AF_INET, &ipt_standard_target);
-	xt_register_target(AF_INET, &ipt_error_target);
-	xt_register_match(AF_INET, &icmp_matchstruct);
+	xt_register_target(&ipt_standard_target);
+	xt_register_target(&ipt_error_target);
+	xt_register_match(&icmp_matchstruct);
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ipt_sockopts);
@@ -1387,9 +1390,9 @@ static void __exit fini(void)
 {
 	nf_unregister_sockopt(&ipt_sockopts);
 
-	xt_unregister_match(AF_INET, &icmp_matchstruct);
-	xt_unregister_target(AF_INET, &ipt_error_target);
-	xt_unregister_target(AF_INET, &ipt_standard_target);
+	xt_unregister_match(&icmp_matchstruct);
+	xt_unregister_target(&ipt_error_target);
+	xt_unregister_target(&ipt_standard_target);
 
 	xt_proto_fini(AF_INET);
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5a2063b..db3c9ae 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1377,12 +1377,14 @@ icmp6_checkentry(const char *tablename,
 static struct ip6t_target ip6t_standard_target = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
+	.family		= AF_INET6,
 };
 
 static struct ip6t_target ip6t_error_target = {
 	.name		= IP6T_ERROR_TARGET,
 	.target		= ip6t_error,
 	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
+	.family		= AF_INET6,
 };
 
 static struct nf_sockopt_ops ip6t_sockopts = {
@@ -1401,6 +1403,7 @@ static struct ip6t_match icmp6_matchstru
 	.matchsize	= sizeof(struct ip6t_icmp),
 	.checkentry	= icmp6_checkentry,
 	.proto		= IPPROTO_ICMPV6,
+	.family		= AF_INET6,
 };
 
 static int __init init(void)
@@ -1410,9 +1413,9 @@ static int __init init(void)
 	xt_proto_init(AF_INET6);
 
 	/* Noone else will be downing sem now, so we won't sleep */
-	xt_register_target(AF_INET6, &ip6t_standard_target);
-	xt_register_target(AF_INET6, &ip6t_error_target);
-	xt_register_match(AF_INET6, &icmp6_matchstruct);
+	xt_register_target(&ip6t_standard_target);
+	xt_register_target(&ip6t_error_target);
+	xt_register_match(&icmp6_matchstruct);
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&ip6t_sockopts);
@@ -1429,9 +1432,9 @@ static int __init init(void)
 static void __exit fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
-	xt_unregister_match(AF_INET6, &icmp6_matchstruct);
-	xt_unregister_target(AF_INET6, &ip6t_error_target);
-	xt_unregister_target(AF_INET6, &ip6t_standard_target);
+	xt_unregister_match(&icmp6_matchstruct);
+	xt_unregister_target(&ip6t_error_target);
+	xt_unregister_target(&ip6t_standard_target);
 	xt_proto_fini(AF_INET6);
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 750b928..0a29a24 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -60,9 +60,9 @@ static const char *xt_prefix[NPROTO] = {
 
 /* Registration hooks for targets. */
 int
-xt_register_target(int af, struct xt_target *target)
+xt_register_target(struct xt_target *target)
 {
-	int ret;
+	int ret, af = target->family;
 
 	ret = down_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -74,8 +74,10 @@ xt_register_target(int af, struct xt_tar
 EXPORT_SYMBOL(xt_register_target);
 
 void
-xt_unregister_target(int af, struct xt_target *target)
+xt_unregister_target(struct xt_target *target)
 {
+	int af = target->family;
+
 	down(&xt[af].mutex);
 	LIST_DELETE(&xt[af].target, target);
 	up(&xt[af].mutex);
@@ -83,9 +85,9 @@ xt_unregister_target(int af, struct xt_t
 EXPORT_SYMBOL(xt_unregister_target);
 
 int
-xt_register_match(int af, struct xt_match *match)
+xt_register_match(struct xt_match *match)
 {
-	int ret;
+	int ret, af = match->family;
 
 	ret = down_interruptible(&xt[af].mutex);
 	if (ret != 0)
@@ -99,8 +101,10 @@ xt_register_match(int af, struct xt_matc
 EXPORT_SYMBOL(xt_register_match);
 
 void
-xt_unregister_match(int af, struct xt_match *match)
+xt_unregister_match(struct xt_match *match)
 {
+	int af =  match->family;
+
 	down(&xt[af].mutex);
 	LIST_DELETE(&xt[af].match, match);
 	up(&xt[af].mutex);
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 3224ed8..3cd2ac9 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -47,6 +47,7 @@ static struct xt_target classify_reg = {
 	.table		= "mangle",
 	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
 		          (1 << NF_IP_POST_ROUTING),
+	.family		= AF_INET,
 	.me 		= THIS_MODULE,
 };
 static struct xt_target classify6_reg = { 
@@ -56,6 +57,7 @@ static struct xt_target classify6_reg = 
 	.table		= "mangle",
 	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
 		          (1 << NF_IP_POST_ROUTING),
+	.family		= AF_INET6,
 	.me 		= THIS_MODULE,
 };
 
@@ -64,21 +66,21 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_target(AF_INET, &classify_reg);
+	ret = xt_register_target(&classify_reg);
 	if (ret)
 		return ret;
 
-	ret = xt_register_target(AF_INET6, &classify6_reg);
+	ret = xt_register_target(&classify6_reg);
 	if (ret)
-		xt_unregister_target(AF_INET, &classify_reg);
+		xt_unregister_target(&classify_reg);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_target(AF_INET, &classify_reg);
-	xt_unregister_target(AF_INET6, &classify6_reg);
+	xt_unregister_target(&classify_reg);
+	xt_unregister_target(&classify6_reg);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index df2486a..35448b8 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -102,6 +102,7 @@ static struct xt_target connmark_reg = {
 	.target		= target,
 	.targetsize	= sizeof(struct xt_connmark_target_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 
@@ -110,6 +111,7 @@ static struct xt_target connmark6_reg = 
 	.target		= target,
 	.targetsize	= sizeof(struct xt_connmark_target_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
 
@@ -119,21 +121,21 @@ static int __init init(void)
 
 	need_conntrack();
 
-	ret = xt_register_target(AF_INET, &connmark_reg);
+	ret = xt_register_target(&connmark_reg);
 	if (ret)
 		return ret;
 
-	ret = xt_register_target(AF_INET6, &connmark6_reg);
+	ret = xt_register_target(&connmark6_reg);
 	if (ret)
-		xt_unregister_target(AF_INET, &connmark_reg);
+		xt_unregister_target(&connmark_reg);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_target(AF_INET, &connmark_reg);
-	xt_unregister_target(AF_INET6, &connmark6_reg);
+	xt_unregister_target(&connmark_reg);
+	xt_unregister_target(&connmark6_reg);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index dcb5266..73bdd5c 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -119,6 +119,7 @@ static struct xt_target ipt_mark_reg_v0 
 	.table		= "mangle",
 	.checkentry	= checkentry_v0,
 	.me		= THIS_MODULE,
+	.family		= AF_INET,
 	.revision	= 0,
 };
 
@@ -129,6 +130,7 @@ static struct xt_target ipt_mark_reg_v1 
 	.table		= "mangle",
 	.checkentry	= checkentry_v1,
 	.me		= THIS_MODULE,
+	.family		= AF_INET,
 	.revision	= 1,
 };
 
@@ -139,6 +141,7 @@ static struct xt_target ip6t_mark_reg_v0
 	.table		= "mangle",
 	.checkentry	= checkentry_v0,
 	.me		= THIS_MODULE,
+	.family		= AF_INET6,
 	.revision	= 0,
 };
 
@@ -146,18 +149,18 @@ static int __init init(void)
 {
 	int err;
 
-	err = xt_register_target(AF_INET, &ipt_mark_reg_v0);
+	err = xt_register_target(&ipt_mark_reg_v0);
 	if (err)
 		return err;
 
-	err = xt_register_target(AF_INET, &ipt_mark_reg_v1);
+	err = xt_register_target(&ipt_mark_reg_v1);
 	if (err)
-		xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
+		xt_unregister_target(&ipt_mark_reg_v0);
 
-	err = xt_register_target(AF_INET6, &ip6t_mark_reg_v0);
+	err = xt_register_target(&ip6t_mark_reg_v0);
 	if (err) {
-		xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
-		xt_unregister_target(AF_INET, &ipt_mark_reg_v1);
+		xt_unregister_target(&ipt_mark_reg_v0);
+		xt_unregister_target(&ipt_mark_reg_v1);
 	}
 
 	return err;
@@ -165,9 +168,9 @@ static int __init init(void)
 
 static void __exit fini(void)
 {
-	xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
-	xt_unregister_target(AF_INET, &ipt_mark_reg_v1);
-	xt_unregister_target(AF_INET6, &ip6t_mark_reg_v0);
+	xt_unregister_target(&ipt_mark_reg_v0);
+	xt_unregister_target(&ipt_mark_reg_v1);
+	xt_unregister_target(&ip6t_mark_reg_v0);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 39a963e..2873e1c 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -41,6 +41,7 @@ static struct xt_target ipt_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
 	.targetsize	= sizeof(struct xt_NFQ_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -48,6 +49,7 @@ static struct xt_target ip6t_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
 	.targetsize	= sizeof(struct xt_NFQ_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -55,36 +57,37 @@ static struct xt_target arpt_NFQ_reg = {
 	.name		= "NFQUEUE",
 	.target		= target,
 	.targetsize	= sizeof(struct xt_NFQ_info),
+	.family		= NF_ARP,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_target(AF_INET, &ipt_NFQ_reg);
+	ret = xt_register_target(&ipt_NFQ_reg);
 	if (ret)
 		return ret;
-	ret = xt_register_target(AF_INET6, &ip6t_NFQ_reg);
+	ret = xt_register_target(&ip6t_NFQ_reg);
 	if (ret)
 		goto out_ip;
-	ret = xt_register_target(NF_ARP, &arpt_NFQ_reg);
+	ret = xt_register_target(&arpt_NFQ_reg);
 	if (ret)
 		goto out_ip6;
 
 	return ret;
 out_ip6:
-	xt_unregister_target(AF_INET6, &ip6t_NFQ_reg);
+	xt_unregister_target(&ip6t_NFQ_reg);
 out_ip:
-	xt_unregister_target(AF_INET, &ipt_NFQ_reg);
+	xt_unregister_target(&ipt_NFQ_reg);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_target(NF_ARP, &arpt_NFQ_reg);
-	xt_unregister_target(AF_INET6, &ip6t_NFQ_reg);
-	xt_unregister_target(AF_INET, &ipt_NFQ_reg);
+	xt_unregister_target(&arpt_NFQ_reg);
+	xt_unregister_target(&ip6t_NFQ_reg);
+	xt_unregister_target(&ipt_NFQ_reg);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index b8634e3..cf2ebd7 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -39,6 +39,7 @@ static struct xt_target notrack_reg = {
 	.target		= target,
 	.targetsize	= 0,
 	.table		= "raw",
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -47,6 +48,7 @@ static struct xt_target notrack6_reg = {
 	.target		= target,
 	.targetsize	= 0,
 	.table		= "raw",
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -54,21 +56,21 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_target(AF_INET, &notrack_reg);
+	ret = xt_register_target(&notrack_reg);
 	if (ret)
 		return ret;
 
-	ret = xt_register_target(AF_INET6, &notrack6_reg);
+	ret = xt_register_target(&notrack6_reg);
 	if (ret)
-		xt_unregister_target(AF_INET, &notrack_reg);
+		xt_unregister_target(&notrack_reg);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_target(AF_INET6, &notrack6_reg);
-	xt_unregister_target(AF_INET, &notrack_reg);
+	xt_unregister_target(&notrack6_reg);
+	xt_unregister_target(&notrack_reg);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 03d9d74..2637724 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -33,6 +33,7 @@ static struct xt_match comment_match = {
 	.name		= "comment",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_comment_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 
@@ -40,6 +41,7 @@ static struct xt_match comment6_match = 
 	.name		= "comment",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_comment_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
 
@@ -47,21 +49,21 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_match(AF_INET, &comment_match);
+	ret = xt_register_match(&comment_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &comment6_match);
+	ret = xt_register_match(&comment6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &comment_match);
+		xt_unregister_match(&comment_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &comment_match);
-	xt_unregister_match(AF_INET6, &comment6_match);
+	xt_unregister_match(&comment_match);
+	xt_unregister_match(&comment6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index f34ecb9..4985f5e 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -148,6 +148,7 @@ static struct xt_match connbytes_match =
 	.match		= match,
 	.checkentry	= check,
 	.matchsize	= sizeof(struct xt_connbytes_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 static struct xt_match connbytes6_match = {
@@ -155,26 +156,27 @@ static struct xt_match connbytes6_match 
 	.match		= match,
 	.checkentry	= check,
 	.matchsize	= sizeof(struct xt_connbytes_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &connbytes_match);
+	ret = xt_register_match(&connbytes_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &connbytes6_match);
+	ret = xt_register_match(&connbytes6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &connbytes_match);
+		xt_unregister_match(&connbytes_match);
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &connbytes_match);
-	xt_unregister_match(AF_INET6, &connbytes6_match);
+	xt_unregister_match(&connbytes_match);
+	xt_unregister_match(&connbytes6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 5182247..e810600 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -72,6 +72,7 @@ static struct xt_match connmark_match = 
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 
@@ -80,6 +81,7 @@ static struct xt_match connmark6_match =
 	.match		= match,
 	.matchsize	= sizeof(struct xt_connmark_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
 
@@ -89,20 +91,20 @@ static int __init init(void)
 
 	need_conntrack();
 
-	ret = xt_register_match(AF_INET, &connmark_match);
+	ret = xt_register_match(&connmark_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &connmark6_match);
+	ret = xt_register_match(&connmark6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &connmark_match);
+		xt_unregister_match(&connmark_match);
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &connmark6_match);
-	xt_unregister_match(AF_INET, &connmark_match);
+	xt_unregister_match(&connmark6_match);
+	xt_unregister_match(&connmark_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 39fc294..7d20caa 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -207,6 +207,7 @@ static struct xt_match conntrack_match =
 	.name		= "conntrack",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_conntrack_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -214,14 +215,14 @@ static int __init init(void)
 {
 	int ret;
 	need_conntrack();
-	ret = xt_register_match(AF_INET, &conntrack_match);
+	ret = xt_register_match(&conntrack_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &conntrack_match);
+	xt_unregister_match(&conntrack_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index db6b70c..2f331de 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -149,6 +149,7 @@ static struct xt_match dccp_match = 
 	.matchsize	= sizeof(struct xt_dccp_info),
 	.proto		= IPPROTO_DCCP,
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me 		= THIS_MODULE,
 };
 static struct xt_match dccp6_match = 
@@ -158,6 +159,7 @@ static struct xt_match dccp6_match = 
 	.matchsize	= sizeof(struct xt_dccp_info),
 	.proto		= IPPROTO_DCCP,
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me 		= THIS_MODULE,
 };
 
@@ -172,17 +174,17 @@ static int __init init(void)
 	dccp_optbuf = kmalloc(256 * 4, GFP_KERNEL);
 	if (!dccp_optbuf)
 		return -ENOMEM;
-	ret = xt_register_match(AF_INET, &dccp_match);
+	ret = xt_register_match(&dccp_match);
 	if (ret)
 		goto out_kfree;
-	ret = xt_register_match(AF_INET6, &dccp6_match);
+	ret = xt_register_match(&dccp6_match);
 	if (ret)
 		goto out_unreg;
 
 	return ret;
 
 out_unreg:
-	xt_unregister_match(AF_INET, &dccp_match);
+	xt_unregister_match(&dccp_match);
 out_kfree:
 	kfree(dccp_optbuf);
 
@@ -191,8 +193,8 @@ out_kfree:
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &dccp6_match);
-	xt_unregister_match(AF_INET, &dccp_match);
+	xt_unregister_match(&dccp6_match);
+	xt_unregister_match(&dccp_match);
 	kfree(dccp_optbuf);
 }
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index ef8e54d..7d2d68b 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -153,6 +153,7 @@ static struct xt_match helper_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
 	.checkentry	= check,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 static struct xt_match helper6_match = {
@@ -160,6 +161,7 @@ static struct xt_match helper6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_helper_info),
 	.checkentry	= check,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -168,21 +170,21 @@ static int __init init(void)
 	int ret;
 	need_conntrack();
 
-	ret = xt_register_match(AF_INET, &helper_match);
+	ret = xt_register_match(&helper_match);
 	if (ret < 0)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &helper6_match);
+	ret = xt_register_match(&helper6_match);
 	if (ret < 0)
-		xt_unregister_match(AF_INET, &helper_match);
+		xt_unregister_match(&helper_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &helper_match);
-	xt_unregister_match(AF_INET6, &helper6_match);
+	xt_unregister_match(&helper_match);
+	xt_unregister_match(&helper6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index b9e60f0..38560ca 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -56,6 +56,7 @@ static struct xt_match length_match = {
 	.name		= "length",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_length_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -63,26 +64,27 @@ static struct xt_match length6_match = {
 	.name		= "length",
 	.match		= match6,
 	.matchsize	= sizeof(struct xt_length_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &length_match);
+	ret = xt_register_match(&length_match);
 	if (ret)
 		return ret;
-	ret = xt_register_match(AF_INET6, &length6_match);
+	ret = xt_register_match(&length6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &length_match);
+		xt_unregister_match(&length_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &length_match);
-	xt_unregister_match(AF_INET6, &length6_match);
+	xt_unregister_match(&length_match);
+	xt_unregister_match(&length6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 3049e6f..e91c1a4 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -141,6 +141,7 @@ static struct xt_match ipt_limit_reg = {
 	.match		= ipt_limit_match,
 	.matchsize	= sizeof(struct xt_rateinfo),
 	.checkentry	= ipt_limit_checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 static struct xt_match limit6_reg = {
@@ -148,6 +149,7 @@ static struct xt_match limit6_reg = {
 	.match		= ipt_limit_match,
 	.matchsize	= sizeof(struct xt_rateinfo),
 	.checkentry	= ipt_limit_checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -155,21 +157,21 @@ static int __init init(void)
 {
 	int ret;
 	
-	ret = xt_register_match(AF_INET, &ipt_limit_reg);
+	ret = xt_register_match(&ipt_limit_reg);
 	if (ret)
 		return ret;
 	
-	ret = xt_register_match(AF_INET6, &limit6_reg);
+	ret = xt_register_match(&limit6_reg);
 	if (ret)
-		xt_unregister_match(AF_INET, &ipt_limit_reg);
+		xt_unregister_match(&ipt_limit_reg);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &ipt_limit_reg);
-	xt_unregister_match(AF_INET6, &limit6_reg);
+	xt_unregister_match(&ipt_limit_reg);
+	xt_unregister_match(&limit6_reg);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index b4559a4..f4defa2 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -49,6 +49,7 @@ static struct xt_match mac_match = {
 	.matchsize	= sizeof(struct xt_mac_info),
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
 			  (1 << NF_IP_FORWARD),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 static struct xt_match mac6_match = {
@@ -57,27 +58,28 @@ static struct xt_match mac6_match = {
 	.matchsize	= sizeof(struct xt_mac_info),
 	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN) |
 			  (1 << NF_IP_FORWARD),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &mac_match);
+	ret = xt_register_match(&mac_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &mac6_match);
+	ret = xt_register_match(&mac6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &mac_match);
+		xt_unregister_match(&mac_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &mac_match);
-	xt_unregister_match(AF_INET6, &mac6_match);
+	xt_unregister_match(&mac_match);
+	xt_unregister_match(&mac6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index c1a8f0f..ce0badf 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -56,6 +56,7 @@ static struct xt_match mark_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_mark_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -64,27 +65,28 @@ static struct xt_match mark6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_mark_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &mark_match);
+	ret = xt_register_match(&mark_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &mark6_match);
+	ret = xt_register_match(&mark6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &mark_match);
+		xt_unregister_match(&mark_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &mark_match);
-	xt_unregister_match(AF_INET6, &mark6_match);
+	xt_unregister_match(&mark_match);
+	xt_unregister_match(&mark6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index f788e8e..089f4f7 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -121,6 +121,7 @@ static struct xt_match physdev_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_physdev_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -129,6 +130,7 @@ static struct xt_match physdev6_match = 
 	.match		= match,
 	.matchsize	= sizeof(struct xt_physdev_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -136,21 +138,21 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_match(AF_INET, &physdev_match);
+	ret = xt_register_match(&physdev_match);
 	if (ret < 0)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &physdev6_match);
+	ret = xt_register_match(&physdev6_match);
 	if (ret < 0)
-		xt_unregister_match(AF_INET, &physdev_match);
+		xt_unregister_match(&physdev_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &physdev_match);
-	xt_unregister_match(AF_INET6, &physdev6_match);
+	xt_unregister_match(&physdev_match);
+	xt_unregister_match(&physdev6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index f38638d..8b8bca9 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -37,6 +37,7 @@ static struct xt_match pkttype_match = {
 	.name		= "pkttype",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_pkttype_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -44,27 +45,28 @@ static struct xt_match pkttype6_match = 
 	.name		= "pkttype",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_pkttype_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &pkttype_match);
+	ret = xt_register_match(&pkttype_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &pkttype6_match);
+	ret = xt_register_match(&pkttype6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &pkttype_match);
+		xt_unregister_match(&pkttype_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &pkttype_match);
-	xt_unregister_match(AF_INET6, &pkttype6_match);
+	xt_unregister_match(&pkttype_match);
+	xt_unregister_match(&pkttype6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 1ec2208..d57a611 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -172,6 +172,7 @@ static struct xt_match policy_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
 	.checkentry 	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -181,6 +182,7 @@ static struct xt_match policy6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_policy_info),
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -188,19 +190,19 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_match(AF_INET, &policy_match);
+	ret = xt_register_match(&policy_match);
 	if (ret)
 		return ret;
-	ret = xt_register_match(AF_INET6, &policy6_match);
+	ret = xt_register_match(&policy6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &policy_match);
+		xt_unregister_match(&policy_match);
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &policy6_match);
-	xt_unregister_match(AF_INET, &policy_match);
+	xt_unregister_match(&policy6_match);
+	xt_unregister_match(&policy_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 57815a0..5e31a4a 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -45,17 +45,18 @@ static struct xt_match realm_match = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
 			  (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN),
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 
 static int __init init(void)
 {
-	return xt_register_match(AF_INET, &realm_match);
+	return xt_register_match(&realm_match);
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &realm_match);
+	xt_unregister_match(&realm_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index f5d698b..c6eb24a 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -186,6 +186,7 @@ static struct xt_match sctp_match = {
 	.matchsize	= sizeof(struct xt_sctp_info),
 	.proto		= IPPROTO_SCTP,
 	.checkentry	= checkentry,
+	.family		= AF_INET,
 	.me		= THIS_MODULE
 };
 
@@ -195,27 +196,28 @@ static struct xt_match sctp6_match = {
 	.matchsize	= sizeof(struct xt_sctp_info),
 	.proto		= IPPROTO_SCTP,
 	.checkentry	= checkentry,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE
 };
 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &sctp_match);
+	ret = xt_register_match(&sctp_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &sctp6_match);
+	ret = xt_register_match(&sctp6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &sctp_match);
+		xt_unregister_match(&sctp_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &sctp6_match);
-	xt_unregister_match(AF_INET, &sctp_match);
+	xt_unregister_match(&sctp6_match);
+	xt_unregister_match(&sctp_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index b8ec00c..7cd557c 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -48,6 +48,7 @@ static struct xt_match state_match = {
 	.name		= "state",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_state_info),
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -55,6 +56,7 @@ static struct xt_match state6_match = {
 	.name		= "state",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_state_info),
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -64,21 +66,21 @@ static int __init init(void)
 
 	need_conntrack();
 
-	ret = xt_register_match(AF_INET, &state_match);
+	ret = xt_register_match(&state_match);
 	if (ret < 0)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &state6_match);
+	ret = xt_register_match(&state6_match);
 	if (ret < 0)
-		xt_unregister_match(AF_INET,&state_match);
+		xt_unregister_match(&state_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &state_match);
-	xt_unregister_match(AF_INET6, &state6_match);
+	xt_unregister_match(&state_match);
+	xt_unregister_match(&state6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index fccbad6..703d80f 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -78,6 +78,7 @@ static struct xt_match string_match = {
 	.matchsize	= sizeof(struct xt_string_info),
 	.checkentry	= checkentry,
 	.destroy 	= destroy,
+	.family		= AF_INET,
 	.me 		= THIS_MODULE
 };
 static struct xt_match string6_match = {
@@ -86,6 +87,7 @@ static struct xt_match string6_match = {
 	.matchsize	= sizeof(struct xt_string_info),
 	.checkentry	= checkentry,
 	.destroy 	= destroy,
+	.family		= AF_INET6,
 	.me 		= THIS_MODULE
 };
 
@@ -93,20 +95,20 @@ static int __init init(void)
 {
 	int ret;
 
-	ret = xt_register_match(AF_INET, &string_match);
+	ret = xt_register_match(&string_match);
 	if (ret)
 		return ret;
-	ret = xt_register_match(AF_INET6, &string6_match);
+	ret = xt_register_match(&string6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &string_match);
+		xt_unregister_match(&string_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET, &string_match);
-	xt_unregister_match(AF_INET6, &string6_match);
+	xt_unregister_match(&string_match);
+	xt_unregister_match(&string6_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 4925fc9..70a8858 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -98,6 +98,7 @@ static struct xt_match tcpmss_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_tcpmss_match_info),
 	.proto		= IPPROTO_TCP,
+	.family		= AF_INET,
 	.me		= THIS_MODULE,
 };
 
@@ -106,6 +107,7 @@ static struct xt_match tcpmss6_match = {
 	.match		= match,
 	.matchsize	= sizeof(struct xt_tcpmss_match_info),
 	.proto		= IPPROTO_TCP,
+	.family		= AF_INET6,
 	.me		= THIS_MODULE,
 };
 
@@ -113,21 +115,21 @@ static struct xt_match tcpmss6_match = {
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &tcpmss_match);
+	ret = xt_register_match(&tcpmss_match);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &tcpmss6_match);
+	ret = xt_register_match(&tcpmss6_match);
 	if (ret)
-		xt_unregister_match(AF_INET, &tcpmss_match);
+		xt_unregister_match(&tcpmss_match);
 
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &tcpmss6_match);
-	xt_unregister_match(AF_INET, &tcpmss_match);
+	xt_unregister_match(&tcpmss6_match);
+	xt_unregister_match(&tcpmss_match);
 }
 
 module_init(init);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index b5cd0dd..14a990e 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -204,6 +204,7 @@ static struct xt_match tcp_matchstruct =
 	.match		= tcp_match,
 	.matchsize	= sizeof(struct xt_tcp),
 	.proto		= IPPROTO_TCP,
+	.family		= AF_INET,
 	.checkentry	= tcp_checkentry,
 	.me		= THIS_MODULE,
 };
@@ -213,6 +214,7 @@ static struct xt_match tcp6_matchstruct 
 	.match		= tcp_match,
 	.matchsize	= sizeof(struct xt_tcp),
 	.proto		= IPPROTO_TCP,
+	.family		= AF_INET6,
 	.checkentry	= tcp_checkentry,
 	.me		= THIS_MODULE,
 };
@@ -222,6 +224,7 @@ static struct xt_match udp_matchstruct =
 	.match		= udp_match,
 	.matchsize	= sizeof(struct xt_udp),
 	.proto		= IPPROTO_UDP,
+	.family		= AF_INET,
 	.checkentry	= udp_checkentry,
 	.me		= THIS_MODULE,
 };
@@ -230,6 +233,7 @@ static struct xt_match udp6_matchstruct 
 	.match		= udp_match,
 	.matchsize	= sizeof(struct xt_udp),
 	.proto		= IPPROTO_UDP,
+	.family		= AF_INET6,
 	.checkentry	= udp_checkentry,
 	.me		= THIS_MODULE,
 };
@@ -237,39 +241,39 @@ static struct xt_match udp6_matchstruct 
 static int __init init(void)
 {
 	int ret;
-	ret = xt_register_match(AF_INET, &tcp_matchstruct);
+	ret = xt_register_match(&tcp_matchstruct);
 	if (ret)
 		return ret;
 
-	ret = xt_register_match(AF_INET6, &tcp6_matchstruct);
+	ret = xt_register_match(&tcp6_matchstruct);
 	if (ret)
 		goto out_unreg_tcp;
 
-	ret = xt_register_match(AF_INET, &udp_matchstruct);
+	ret = xt_register_match(&udp_matchstruct);
 	if (ret)
 		goto out_unreg_tcp6;
 	
-	ret = xt_register_match(AF_INET6, &udp6_matchstruct);
+	ret = xt_register_match(&udp6_matchstruct);
 	if (ret)
 		goto out_unreg_udp;
 
 	return ret;
 
 out_unreg_udp:
-	xt_unregister_match(AF_INET, &tcp_matchstruct);
+	xt_unregister_match(&tcp_matchstruct);
 out_unreg_tcp6:
-	xt_unregister_match(AF_INET6, &tcp6_matchstruct);
+	xt_unregister_match(&tcp6_matchstruct);
 out_unreg_tcp:
-	xt_unregister_match(AF_INET, &tcp_matchstruct);
+	xt_unregister_match(&tcp_matchstruct);
 	return ret;
 }
 
 static void __exit fini(void)
 {
-	xt_unregister_match(AF_INET6, &udp6_matchstruct);
-	xt_unregister_match(AF_INET, &udp_matchstruct);
-	xt_unregister_match(AF_INET6, &tcp6_matchstruct);
-	xt_unregister_match(AF_INET, &tcp_matchstruct);
+	xt_unregister_match(&udp6_matchstruct);
+	xt_unregister_match(&udp_matchstruct);
+	xt_unregister_match(&tcp6_matchstruct);
+	xt_unregister_match(&tcp_matchstruct);
 }
 
 module_init(init);
