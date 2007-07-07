From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/50]: x_tables: mark matches and targets __read_mostly
Date: Sat,  7 Jul 2007 14:23:19 +0200 (MEST)
Message-ID: <20070707122235.1589.25449.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: mark matches and targets __read_mostly

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1a88670786aabfcb521f6efcafe8556d86fe5487
tree beabece42e2c96b3c6ebada2076867c71342ee7f
parent a13747b0585f14ff5523cf3f52b4175334e65038
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:24 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:24 +0200

 net/ipv4/netfilter/arp_tables.c      |    4 ++--
 net/ipv4/netfilter/arpt_mangle.c     |    2 +-
 net/ipv4/netfilter/ip_tables.c       |    6 +++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c      |    2 +-
 net/ipv4/netfilter/ipt_SAME.c        |    2 +-
 net/ipv4/netfilter/ipt_TOS.c         |    2 +-
 net/ipv4/netfilter/ipt_TTL.c         |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    2 +-
 net/ipv4/netfilter/ipt_ah.c          |    2 +-
 net/ipv4/netfilter/ipt_ecn.c         |    2 +-
 net/ipv4/netfilter/ipt_iprange.c     |    2 +-
 net/ipv4/netfilter/ipt_owner.c       |    2 +-
 net/ipv4/netfilter/ipt_recent.c      |    2 +-
 net/ipv4/netfilter/ipt_tos.c         |    2 +-
 net/ipv4/netfilter/ipt_ttl.c         |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c     |    4 ++--
 net/ipv6/netfilter/ip6_tables.c      |    6 +++---
 net/ipv6/netfilter/ip6t_HL.c         |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c        |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    2 +-
 net/ipv6/netfilter/ip6t_eui64.c      |    2 +-
 net/ipv6/netfilter/ip6t_frag.c       |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    2 +-
 net/ipv6/netfilter/ip6t_hl.c         |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_owner.c      |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    2 +-
 net/netfilter/xt_CLASSIFY.c          |    2 +-
 net/netfilter/xt_CONNMARK.c          |    2 +-
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_MARK.c              |    2 +-
 net/netfilter/xt_NFLOG.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 net/netfilter/xt_NOTRACK.c           |    2 +-
 net/netfilter/xt_SECMARK.c           |    2 +-
 net/netfilter/xt_TCPMSS.c            |    2 +-
 net/netfilter/xt_TRACE.c             |    2 +-
 net/netfilter/xt_comment.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_conntrack.c         |    2 +-
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    2 +-
 net/netfilter/xt_esp.c               |    2 +-
 net/netfilter/xt_hashlimit.c         |    2 +-
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_length.c            |    2 +-
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_mac.c               |    2 +-
 net/netfilter/xt_mark.c              |    2 +-
 net/netfilter/xt_multiport.c         |    2 +-
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_pkttype.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_state.c             |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpmss.c            |    2 +-
 net/netfilter/xt_tcpudp.c            |    2 +-
 net/netfilter/xt_u32.c               |    2 +-
 73 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1d75a5c..e981232 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1140,13 +1140,13 @@ void arpt_unregister_table(struct arpt_table *table)
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct arpt_target arpt_standard_target = {
+static struct arpt_target arpt_standard_target __read_mostly = {
 	.name		= ARPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= NF_ARP,
 };
 
-static struct arpt_target arpt_error_target = {
+static struct arpt_target arpt_error_target __read_mostly = {
 	.name		= ARPT_ERROR_TARGET,
 	.target		= arpt_error,
 	.targetsize	= ARPT_FUNCTION_MAXNAMELEN,
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 497a16e..c4bdab4 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -81,7 +81,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 	return true;
 }
 
-static struct arpt_target arpt_mangle_reg = {
+static struct arpt_target arpt_mangle_reg __read_mostly = {
 	.name		= "mangle",
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 650ab52..2ba5bd9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2264,7 +2264,7 @@ icmp_checkentry(const char *tablename,
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct xt_target ipt_standard_target = {
+static struct xt_target ipt_standard_target __read_mostly = {
 	.name		= IPT_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET,
@@ -2275,7 +2275,7 @@ static struct xt_target ipt_standard_target = {
 #endif
 };
 
-static struct xt_target ipt_error_target = {
+static struct xt_target ipt_error_target __read_mostly = {
 	.name		= IPT_ERROR_TARGET,
 	.target		= ipt_error,
 	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
@@ -2298,7 +2298,7 @@ static struct nf_sockopt_ops ipt_sockopts = {
 #endif
 };
 
-static struct xt_match icmp_matchstruct = {
+static struct xt_match icmp_matchstruct __read_mostly = {
 	.name		= "icmp",
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 5de13b4..1cef3b0 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -466,7 +466,7 @@ static void destroy(const struct xt_target *target, void *targinfo)
 	nf_ct_l3proto_module_put(target->family);
 }
 
-static struct xt_target clusterip_tgt = {
+static struct xt_target clusterip_tgt __read_mostly = {
 	.name		= "CLUSTERIP",
 	.family		= AF_INET,
 	.target		= target,
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index a647c1d..f1253bd 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -128,7 +128,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ipt_ecn_reg = {
+static struct xt_target ipt_ecn_reg __read_mostly = {
 	.name		= "ECN",
 	.family		= AF_INET,
 	.target		= target,
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index bcc43a6..9bfce61 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -463,7 +463,7 @@ static bool ipt_log_checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ipt_log_reg = {
+static struct xt_target ipt_log_reg __read_mostly = {
 	.name		= "LOG",
 	.family		= AF_INET,
 	.target		= ipt_log_target,
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index f136ef7..bc033e0 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -169,7 +169,7 @@ static struct notifier_block masq_inet_notifier = {
 	.notifier_call	= masq_inet_event,
 };
 
-static struct xt_target masquerade = {
+static struct xt_target masquerade __read_mostly = {
 	.name		= "MASQUERADE",
 	.family		= AF_INET,
 	.target		= masquerade_target,
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index a902c71..0a7ce15 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -85,7 +85,7 @@ target(struct sk_buff **pskb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct xt_target target_module = {
+static struct xt_target target_module __read_mostly = {
 	.name 		= MODULENAME,
 	.family		= AF_INET,
 	.target 	= target,
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 2a04103..61e1e47 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -101,7 +101,7 @@ redirect_target(struct sk_buff **pskb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct xt_target redirect_reg = {
+static struct xt_target redirect_reg __read_mostly = {
 	.name		= "REDIRECT",
 	.family		= AF_INET,
 	.target		= redirect_target,
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 90f7b70..dd5432c 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -240,7 +240,7 @@ static bool check(const char *tablename,
 	return true;
 }
 
-static struct xt_target ipt_reject_reg = {
+static struct xt_target ipt_reject_reg __read_mostly = {
 	.name		= "REJECT",
 	.family		= AF_INET,
 	.target		= reject,
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index 3649fab..3a0d7da 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -161,7 +161,7 @@ same_target(struct sk_buff **pskb,
 	return nf_nat_setup_info(ct, &newrange, hooknum);
 }
 
-static struct xt_target same_reg = {
+static struct xt_target same_reg __read_mostly = {
 	.name		= "SAME",
 	.family		= AF_INET,
 	.target		= same_target,
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index ac43e86..25f5d0b 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -63,7 +63,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ipt_tos_reg = {
+static struct xt_target ipt_tos_reg __read_mostly = {
 	.name		= "TOS",
 	.family		= AF_INET,
 	.target		= target,
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 737830b..2b54e7b 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -80,7 +80,7 @@ static bool ipt_ttl_checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ipt_TTL = {
+static struct xt_target ipt_TTL __read_mostly = {
 	.name 		= "TTL",
 	.family		= AF_INET,
 	.target 	= ipt_ttl_target,
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 5b25ca6..226750d 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -381,7 +381,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_target ipt_ulog_reg = {
+static struct xt_target ipt_ulog_reg __read_mostly = {
 	.name		= "ULOG",
 	.family		= AF_INET,
 	.target		= ipt_ulog_target,
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index abea446..59f01f7 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -44,7 +44,7 @@ static bool match(const struct sk_buff *skb,
 	return ret;
 }
 
-static struct xt_match addrtype_match = {
+static struct xt_match addrtype_match __read_mostly = {
 	.name		= "addrtype",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 49d503c..61b017f 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -88,7 +88,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match ah_match = {
+static struct xt_match ah_match __read_mostly = {
 	.name		= "ah",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 3129e31..d6925c6 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -111,7 +111,7 @@ static bool checkentry(const char *tablename, const void *ip_void,
 	return true;
 }
 
-static struct xt_match ecn_match = {
+static struct xt_match ecn_match __read_mostly = {
 	.name		= "ecn",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 854281c..6a3a033 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -63,7 +63,7 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static struct xt_match iprange_match = {
+static struct xt_match iprange_match __read_mostly = {
 	.name		= "iprange",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index deea4b8..b14e77d 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -68,7 +68,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match owner_match = {
+static struct xt_match owner_match __read_mostly = {
 	.name		= "owner",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 68f7181..a7b14f2 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -460,7 +460,7 @@ static const struct file_operations recent_fops = {
 };
 #endif /* CONFIG_PROC_FS */
 
-static struct xt_match recent_match = {
+static struct xt_match recent_match __read_mostly = {
 	.name		= "recent",
 	.family		= AF_INET,
 	.match		= ipt_recent_match,
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index 67699ae..e740441 100644
--- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -33,7 +33,7 @@ match(const struct sk_buff *skb,
 	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
 }
 
-static struct xt_match tos_match = {
+static struct xt_match tos_match __read_mostly = {
 	.name		= "tos",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index 59a644d..a439900 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -44,7 +44,7 @@ static bool match(const struct sk_buff *skb,
 	return false;
 }
 
-static struct xt_match ttl_match = {
+static struct xt_match ttl_match __read_mostly = {
 	.name		= "ttl",
 	.family		= AF_INET,
 	.match		= match,
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index ea1a07c..080393a 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -228,7 +228,7 @@ int nf_nat_rule_find(struct sk_buff **pskb,
 	return ret;
 }
 
-static struct xt_target ipt_snat_reg = {
+static struct xt_target ipt_snat_reg __read_mostly = {
 	.name		= "SNAT",
 	.target		= ipt_snat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
@@ -238,7 +238,7 @@ static struct xt_target ipt_snat_reg = {
 	.family		= AF_INET,
 };
 
-static struct xt_target ipt_dnat_reg = {
+static struct xt_target ipt_dnat_reg __read_mostly = {
 	.name		= "DNAT",
 	.target		= ipt_dnat_target,
 	.targetsize	= sizeof(struct nf_nat_multi_range_compat),
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 4f93b79..254c769 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1441,13 +1441,13 @@ icmp6_checkentry(const char *tablename,
 }
 
 /* The built-in targets: standard (NULL) and error. */
-static struct xt_target ip6t_standard_target = {
+static struct xt_target ip6t_standard_target __read_mostly = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET6,
 };
 
-static struct xt_target ip6t_error_target = {
+static struct xt_target ip6t_error_target __read_mostly = {
 	.name		= IP6T_ERROR_TARGET,
 	.target		= ip6t_error,
 	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
@@ -1464,7 +1464,7 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.get		= do_ip6t_get_ctl,
 };
 
-static struct xt_match icmp6_matchstruct = {
+static struct xt_match icmp6_matchstruct __read_mostly = {
 	.name		= "icmp6",
 	.match		= &icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 33c4cb8..ad4d943 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -79,7 +79,7 @@ static bool ip6t_hl_checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ip6t_HL = {
+static struct xt_target ip6t_HL __read_mostly = {
 	.name 		= "HL",
 	.family		= AF_INET6,
 	.target		= ip6t_hl_target,
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 996168d..540bf14 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -477,7 +477,7 @@ static bool ip6t_log_checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target ip6t_log_reg = {
+static struct xt_target ip6t_log_reg __read_mostly = {
 	.name 		= "LOG",
 	.family		= AF_INET6,
 	.target 	= ip6t_log_target,
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 0fa1f2c..14008dc 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -244,7 +244,7 @@ static bool check(const char *tablename,
 	return true;
 }
 
-static struct xt_target ip6t_reject_reg = {
+static struct xt_target ip6t_reject_reg __read_mostly = {
 	.name		= "REJECT",
 	.family		= AF_INET6,
 	.target		= reject6_target,
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index fbf3d77..a9fe2aa 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -120,7 +120,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match ah_match = {
+static struct xt_match ah_match __read_mostly = {
 	.name		= "ah",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 2af99fc..34ba150 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -62,7 +62,7 @@ match(const struct sk_buff *skb,
 	return false;
 }
 
-static struct xt_match eui64_match = {
+static struct xt_match eui64_match __read_mostly = {
 	.name		= "eui64",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 65482af..bb1cfa8 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -137,7 +137,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match frag_match = {
+static struct xt_match frag_match __read_mostly = {
 	.name		= "frag",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 8eecac1..6247d4c 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -193,7 +193,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match opts_match[] = {
+static struct xt_match opts_match[] __read_mostly = {
 	{
 		.name		= "hbh",
 		.family		= AF_INET6,
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index ddee088..ca29ec0 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -49,7 +49,7 @@ static bool match(const struct sk_buff *skb,
 	return false;
 }
 
-static struct xt_match hl_match = {
+static struct xt_match hl_match __read_mostly = {
 	.name		= "hl",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index ca020ce..2c65c2f 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -141,7 +141,7 @@ ipv6header_checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match ip6t_ipv6header_match = {
+static struct xt_match ip6t_ipv6header_match __read_mostly = {
 	.name		= "ipv6header",
 	.family		= AF_INET6,
 	.match		= &ipv6header_match,
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index e94fdd8..0fa7140 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -89,7 +89,7 @@ mh_checkentry(const char *tablename,
 	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
 }
 
-static struct xt_match mh_match = {
+static struct xt_match mh_match __read_mostly = {
 	.name		= "mh",
 	.family		= AF_INET6,
 	.checkentry	= mh_checkentry,
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index d2bf320..6036613 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -68,7 +68,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match owner_match = {
+static struct xt_match owner_match __read_mostly = {
 	.name		= "owner",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index f86fdcd..549deea 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -224,7 +224,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match rt_match = {
+static struct xt_match rt_match __read_mostly = {
 	.name		= "rt",
 	.family		= AF_INET6,
 	.match		= match,
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 3088483..5194285 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -39,7 +39,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static struct xt_target xt_classify_target[] = {
+static struct xt_target xt_classify_target[] __read_mostly = {
 	{
 		.family		= AF_INET,
 		.name 		= "CLASSIFY",
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 4284a59..5a00c54 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -142,7 +142,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_target xt_connmark_target[] = {
+static struct xt_target xt_connmark_target[] __read_mostly = {
 	{
 		.name		= "CONNMARK",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 8d5e154..63d7313 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -115,7 +115,7 @@ destroy(const struct xt_target *target, void *targinfo)
 	nf_ct_l3proto_module_put(target->family);
 }
 
-static struct xt_target xt_connsecmark_target[] = {
+static struct xt_target xt_connsecmark_target[] __read_mostly = {
 	{
 		.name		= "CONNSECMARK",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index ed6b524..798ab73 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -81,7 +81,7 @@ static bool checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_target xt_dscp_target[] = {
+static struct xt_target xt_dscp_target[] __read_mostly = {
 	{
 		.name		= "DSCP",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 6b7369f..f30fe0b 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -133,7 +133,7 @@ static int compat_to_user_v1(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_target xt_mark_target[] = {
+static struct xt_target xt_mark_target[] __read_mostly = {
 	{
 		.name		= "MARK",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 20e55d5..d3594c7 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -52,7 +52,7 @@ nflog_checkentry(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_target xt_nflog_target[] = {
+static struct xt_target xt_nflog_target[] __read_mostly = {
 	{
 		.name		= "NFLOG",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 201155b..13f59f3 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -36,7 +36,7 @@ target(struct sk_buff **pskb,
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
 
-static struct xt_target xt_nfqueue_target[] = {
+static struct xt_target xt_nfqueue_target[] __read_mostly = {
 	{
 		.name		= "NFQUEUE",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 5085fb3..b7d6312 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -33,7 +33,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static struct xt_target xt_notrack_target[] = {
+static struct xt_target xt_notrack_target[] __read_mostly = {
 	{
 		.name		= "NOTRACK",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index f3e78c5..c83779a 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -109,7 +109,7 @@ static bool checkentry(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_target xt_secmark_target[] = {
+static struct xt_target xt_secmark_target[] __read_mostly = {
 	{
 		.name		= "SECMARK",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 6ae6df9..d40f7e4 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -259,7 +259,7 @@ xt_tcpmss_checkentry6(const char *tablename,
 }
 #endif
 
-static struct xt_target xt_tcpmss_reg[] = {
+static struct xt_target xt_tcpmss_reg[] __read_mostly = {
 	{
 		.family		= AF_INET,
 		.name		= "TCPMSS",
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index b82fc46..4df2ded 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -21,7 +21,7 @@ target(struct sk_buff **pskb,
 	return XT_CONTINUE;
 }
 
-static struct xt_target xt_trace_target[] = {
+static struct xt_target xt_trace_target[] __read_mostly = {
 	{
 		.name		= "TRACE",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index aa9503f..64bcdb0 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -29,7 +29,7 @@ match(const struct sk_buff *skb,
 	return true;
 }
 
-static struct xt_match xt_comment_match[] = {
+static struct xt_match xt_comment_match[] __read_mostly = {
 	{
 		.name		= "comment",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d9b2e75..dd4d79b 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -128,7 +128,7 @@ destroy(const struct xt_match *match, void *matchinfo)
 	nf_ct_l3proto_module_put(match->family);
 }
 
-static struct xt_match xt_connbytes_match[] = {
+static struct xt_match xt_connbytes_match[] __read_mostly = {
 	{
 		.name		= "connbytes",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 3a6e16d..e73fa9b 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -109,7 +109,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_match xt_connmark_match[] = {
+static struct xt_match xt_connmark_match[] __read_mostly = {
 	{
 		.name		= "connmark",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 9e3ec31..ca4b69f 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -183,7 +183,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif
 
-static struct xt_match conntrack_match = {
+static struct xt_match conntrack_match __read_mostly = {
 	.name		= "conntrack",
 	.match		= match,
 	.checkentry	= checkentry,
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index f07a68d..83224ec 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -140,7 +140,7 @@ checkentry(const char *tablename,
 		&& !(info->invflags & ~info->flags);
 }
 
-static struct xt_match xt_dccp_match[] = {
+static struct xt_match xt_dccp_match[] __read_mostly = {
 	{
 		.name 		= "dccp",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 35cabca..dde6d66 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -68,7 +68,7 @@ static bool checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match xt_dscp_match[] = {
+static struct xt_match xt_dscp_match[] __read_mostly = {
 	{
 		.name		= "dscp",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 1a6ae8a..b11378e 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -91,7 +91,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match xt_esp_match[] = {
+static struct xt_match xt_esp_match[] __read_mostly = {
 	{
 		.name		= "esp",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 094da6e..5a6ea9b 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -578,7 +578,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif
 
-static struct xt_match xt_hashlimit[] = {
+static struct xt_match xt_hashlimit[] __read_mostly = {
 	{
 		.name		= "hashlimit",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 047d004..d03acb0 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -99,7 +99,7 @@ destroy(const struct xt_match *match, void *matchinfo)
 	nf_ct_l3proto_module_put(match->family);
 }
 
-static struct xt_match xt_helper_match[] = {
+static struct xt_match xt_helper_match[] __read_mostly = {
 	{
 		.name		= "helper",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index ea4880b..3dad173 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -53,7 +53,7 @@ match6(const struct sk_buff *skb,
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
-static struct xt_match xt_length_match[] = {
+static struct xt_match xt_length_match[] __read_mostly = {
 	{
 		.name		= "length",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index b042419..4fcca79 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -173,7 +173,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_match xt_limit_match[] = {
+static struct xt_match xt_limit_match[] __read_mostly = {
 	{
 		.name		= "limit",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 28ec08e..00490d7 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -44,7 +44,7 @@ match(const struct sk_buff *skb,
 		^ info->invert);
 }
 
-static struct xt_match xt_mac_match[] = {
+static struct xt_match xt_mac_match[] __read_mostly = {
 	{
 		.name		= "mac",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index b8ab794..c02a7f8 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -81,7 +81,7 @@ static int compat_to_user(void __user *dst, void *src)
 }
 #endif /* CONFIG_COMPAT */
 
-static struct xt_match xt_mark_match[] = {
+static struct xt_match xt_mark_match[] __read_mostly = {
 	{
 		.name		= "mark",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 3d69d62..e8ae102 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -228,7 +228,7 @@ checkentry6_v1(const char *tablename,
 		     multiinfo->count);
 }
 
-static struct xt_match xt_multiport_match[] = {
+static struct xt_match xt_multiport_match[] __read_mostly = {
 	{
 		.name		= "multiport",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 467b2dc..f47cab7 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -125,7 +125,7 @@ checkentry(const char *tablename,
 	return true;
 }
 
-static struct xt_match xt_physdev_match[] = {
+static struct xt_match xt_physdev_match[] __read_mostly = {
 	{
 		.name		= "physdev",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index e4c420b..a52925f 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -43,7 +43,7 @@ static bool match(const struct sk_buff *skb,
 	return (type == info->pkttype) ^ info->invert;
 }
 
-static struct xt_match xt_pkttype_match[] = {
+static struct xt_match xt_pkttype_match[] __read_mostly = {
 	{
 		.name		= "pkttype",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 5ab6d71..6d6d3b7 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -164,7 +164,7 @@ static bool checkentry(const char *tablename, const void *ip_void,
 	return true;
 }
 
-static struct xt_match xt_policy_match[] = {
+static struct xt_match xt_policy_match[] __read_mostly = {
 	{
 		.name		= "policy",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index feb130d..dae9744 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -53,7 +53,7 @@ checkentry(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match xt_quota_match[] = {
+static struct xt_match xt_quota_match[] __read_mostly = {
 	{
 		.name		= "quota",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 44b807d..cc3e76d 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -37,7 +37,7 @@ match(const struct sk_buff *skb,
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static struct xt_match realm_match = {
+static struct xt_match realm_match __read_mostly = {
 	.name		= "realm",
 	.match		= match,
 	.matchsize	= sizeof(struct xt_realm_info),
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index fefc846..c002153 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -172,7 +172,7 @@ checkentry(const char *tablename,
 				| SCTP_CHUNK_MATCH_ONLY)));
 }
 
-static struct xt_match xt_sctp_match[] = {
+static struct xt_match xt_sctp_match[] __read_mostly = {
 	{
 		.name		= "sctp",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 5b9c59a..e0a528d 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -64,7 +64,7 @@ destroy(const struct xt_match *match, void *matchinfo)
 	nf_ct_l3proto_module_put(match->family);
 }
 
-static struct xt_match xt_state_match[] = {
+static struct xt_match xt_state_match[] __read_mostly = {
 	{
 		.name		= "state",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 3da4978..4089dae 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -66,7 +66,7 @@ checkentry(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct xt_match xt_statistic_match[] = {
+static struct xt_match xt_statistic_match[] __read_mostly = {
 	{
 		.name		= "statistic",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index ab761b1..8641334 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -73,7 +73,7 @@ static void destroy(const struct xt_match *match, void *matchinfo)
 	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
 }
 
-static struct xt_match xt_string_match[] = {
+static struct xt_match xt_string_match[] __read_mostly = {
 	{
 		.name 		= "string",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index e9bfd3d..cd5f6d7 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -81,7 +81,7 @@ dropit:
 	return false;
 }
 
-static struct xt_match xt_tcpmss_match[] = {
+static struct xt_match xt_tcpmss_match[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 5cb345a..ab7d845 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -194,7 +194,7 @@ udp_checkentry(const char *tablename,
 	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
 }
 
-static struct xt_match xt_tcpudp_match[] = {
+static struct xt_match xt_tcpudp_match[] __read_mostly = {
 	{
 		.name		= "tcp",
 		.family		= AF_INET,
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 685e311..4f16585 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -99,7 +99,7 @@ static bool u32_match(const struct sk_buff *skb,
 	return ret ^ data->invert;
 }
 
-static struct xt_match u32_reg[] = {
+static struct xt_match u32_reg[] __read_mostly = {
 	{
 		.name       = "u32",
 		.family     = AF_INET,
