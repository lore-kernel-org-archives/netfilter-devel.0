From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/13]: Convert ip_tables matches/targets to centralized
	error checking
Date: Thu, 16 Feb 2006 22:32:14 +0100 (MET)
Message-ID: <20060216213214.6933.8546.sendpatchset@localhost.localdomain>
References: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert ip_tables matches/targets to centralized error checking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4f172068d4d24e663edc75a7679e887771a2d89e
tree 30a8183ee1887be4ba7ee86c4c3f2e46125a54d7
parent 21596d6b3f1a5d828a9dbe4e3db8430898a97f17
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:03 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:03 +0100

 net/ipv4/netfilter/ip_nat_rule.c    |   41 +++++------------------------------
 net/ipv4/netfilter/ip_tables.c      |   25 +++++++--------------
 net/ipv4/netfilter/ipt_CLUSTERIP.c  |   20 ++++++-----------
 net/ipv4/netfilter/ipt_DSCP.c       |   15 ++-----------
 net/ipv4/netfilter/ipt_ECN.c        |   16 ++------------
 net/ipv4/netfilter/ipt_LOG.c        |    9 +-------
 net/ipv4/netfilter/ipt_MASQUERADE.c |   16 +++-----------
 net/ipv4/netfilter/ipt_NETMAP.c     |   17 +++------------
 net/ipv4/netfilter/ipt_REDIRECT.c   |   15 +++----------
 net/ipv4/netfilter/ipt_REJECT.c     |   22 +++----------------
 net/ipv4/netfilter/ipt_SAME.c       |   15 +++----------
 net/ipv4/netfilter/ipt_TCPMSS.c     |   14 +++---------
 net/ipv4/netfilter/ipt_TOS.c        |   15 ++-----------
 net/ipv4/netfilter/ipt_TTL.c        |   17 ++-------------
 net/ipv4/netfilter/ipt_ULOG.c       |   10 ++-------
 net/ipv4/netfilter/ipt_addrtype.c   |   15 +------------
 net/ipv4/netfilter/ipt_ah.c         |   23 +++++---------------
 net/ipv4/netfilter/ipt_dscp.c       |   14 ++----------
 net/ipv4/netfilter/ipt_ecn.c        |    8 +++----
 net/ipv4/netfilter/ipt_esp.c        |   23 +++++---------------
 net/ipv4/netfilter/ipt_hashlimit.c  |   16 ++++++--------
 net/ipv4/netfilter/ipt_iprange.c    |   27 +++++------------------
 net/ipv4/netfilter/ipt_multiport.c  |   29 +++----------------------
 net/ipv4/netfilter/ipt_owner.c      |   19 +++-------------
 net/ipv4/netfilter/ipt_policy.c     |    6 +----
 net/ipv4/netfilter/ipt_recent.c     |   15 ++++++-------
 net/ipv4/netfilter/ipt_tos.c        |   17 ++-------------
 net/ipv4/netfilter/ipt_ttl.c        |   14 ++----------
 28 files changed, 103 insertions(+), 390 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index 1de8628..ef4be3d 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -181,23 +181,6 @@ static int ipt_snat_checkentry(const cha
 		printk("SNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
-
-	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
-		DEBUGP("SNAT: Target size %u wrong for %u ranges\n",
-		       targinfosize, mr->rangesize);
-		return 0;
-	}
-
-	/* Only allow these for NAT. */
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("SNAT: wrong table %s\n", tablename);
-		return 0;
-	}
-
-	if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
-		DEBUGP("SNAT: hook mask 0x%x bad\n", hook_mask);
-		return 0;
-	}
 	return 1;
 }
 
@@ -214,24 +197,6 @@ static int ipt_dnat_checkentry(const cha
 		printk("DNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
-
-	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
-		DEBUGP("DNAT: Target size %u wrong for %u ranges\n",
-		       targinfosize, mr->rangesize);
-		return 0;
-	}
-
-	/* Only allow these for NAT. */
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("DNAT: wrong table %s\n", tablename);
-		return 0;
-	}
-
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))) {
-		DEBUGP("DNAT: hook mask 0x%x bad\n", hook_mask);
-		return 0;
-	}
-	
 	return 1;
 }
 
@@ -299,12 +264,18 @@ int ip_nat_rule_find(struct sk_buff **ps
 static struct ipt_target ipt_snat_reg = {
 	.name		= "SNAT",
 	.target		= ipt_snat_target,
+	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= 1 << NF_IP_POST_ROUTING,
 	.checkentry	= ipt_snat_checkentry,
 };
 
 static struct ipt_target ipt_dnat_reg = {
 	.name		= "DNAT",
 	.target		= ipt_dnat_target,
+	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= 1 << NF_IP_PRE_ROUTING,
 	.checkentry	= ipt_dnat_checkentry,
 };
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f884ca2..62f8d63 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -477,21 +477,12 @@ standard_check(const struct ipt_entry_ta
 	struct ipt_standard_target *targ = (void *)t;
 
 	/* Check standard info. */
-	if (t->u.target_size
-	    != IPT_ALIGN(sizeof(struct ipt_standard_target))) {
-		duprintf("standard_check: target size %u != %u\n",
-			 t->u.target_size,
-			 IPT_ALIGN(sizeof(struct ipt_standard_target)));
-		return 0;
-	}
-
 	if (targ->verdict >= 0
 	    && targ->verdict > max_offset - sizeof(struct ipt_entry)) {
 		duprintf("ipt_standard_check: bad verdict (%i)\n",
 			 targ->verdict);
 		return 0;
 	}
-
 	if (targ->verdict < -NF_MAX_VERDICT - 1) {
 		duprintf("ipt_standard_check: bad negative verdict (%i)\n",
 			 targ->verdict);
@@ -1330,24 +1321,22 @@ icmp_checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct ipt_ip *ip = info;
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
-	/* Must specify proto == ICMP, and no unknown invflags */
-	return ip->proto == IPPROTO_ICMP
-		&& !(ip->invflags & IPT_INV_PROTO)
-		&& matchsize == IPT_ALIGN(sizeof(struct ipt_icmp))
-		&& !(icmpinfo->invflags & ~IPT_ICMP_INV);
+	/* Must specify no unknown invflags */
+	return !(icmpinfo->invflags & ~IPT_ICMP_INV);
 }
 
 /* The built-in targets: standard (NULL) and error. */
 static struct ipt_target ipt_standard_target = {
 	.name		= IPT_STANDARD_TARGET,
+	.targetsize	= sizeof(int),
 };
 
 static struct ipt_target ipt_error_target = {
 	.name		= IPT_ERROR_TARGET,
 	.target		= ipt_error,
+	.targetsize	= IPT_FUNCTION_MAXNAMELEN,
 };
 
 static struct nf_sockopt_ops ipt_sockopts = {
@@ -1362,8 +1351,10 @@ static struct nf_sockopt_ops ipt_sockopt
 
 static struct ipt_match icmp_matchstruct = {
 	.name		= "icmp",
-	.match		= &icmp_match,
-	.checkentry	= &icmp_checkentry,
+	.match		= icmp_match,
+	.matchsize	= sizeof(struct ipt_icmp),
+	.proto		= IPPROTO_ICMP,
+	.checkentry	= icmp_checkentry,
 };
 
 static int __init init(void)
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index d9bc971..24f88dd 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -389,13 +389,6 @@ checkentry(const char *tablename,
 
 	struct clusterip_config *config;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info))) {
-		printk(KERN_WARNING "CLUSTERIP: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)));
-		return 0;
-	}
-
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
@@ -476,12 +469,13 @@ static void destroy(void *matchinfo, uns
 	clusterip_config_put(cipinfo->config);
 }
 
-static struct ipt_target clusterip_tgt = { 
-	.name = "CLUSTERIP",
-	.target = &target, 
-	.checkentry = &checkentry, 
-	.destroy = &destroy,
-	.me = THIS_MODULE
+static struct ipt_target clusterip_tgt = {
+	.name		= "CLUSTERIP",
+	.target		= target,
+	.targetsize	= sizeof(struct ipt_clusterip_tgt_info),
+	.checkentry	= checkentry,
+	.destroy	= destroy,
+	.me		= THIS_MODULE
 };
 
 
diff --git a/net/ipv4/netfilter/ipt_DSCP.c b/net/ipv4/netfilter/ipt_DSCP.c
index 898cdf7..a202467 100644
--- a/net/ipv4/netfilter/ipt_DSCP.c
+++ b/net/ipv4/netfilter/ipt_DSCP.c
@@ -64,29 +64,18 @@ checkentry(const char *tablename,
 {
 	const u_int8_t dscp = ((struct ipt_DSCP_info *)targinfo)->dscp;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_DSCP_info))) {
-		printk(KERN_WARNING "DSCP: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_DSCP_info)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "DSCP: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if ((dscp > IPT_DSCP_MAX)) {
 		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_dscp_reg = {
 	.name		= "DSCP",
 	.target		= target,
+	.targetsize	= sizeof(struct ipt_DSCP_info),
+	.table		= "mangle",
 	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 7064454..1bf1a40 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -121,18 +121,6 @@ checkentry(const char *tablename,
 	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
 	const struct ipt_entry *e = e_void;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_ECN_info))) {
-		printk(KERN_WARNING "ECN: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_ECN_info)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "ECN: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
 			einfo->operation);
@@ -143,20 +131,20 @@ checkentry(const char *tablename,
 			einfo->ip_ect);
 		return 0;
 	}
-
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR))
 	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & IPT_INV_PROTO))) {
 		printk(KERN_WARNING "ECN: cannot use TCP operations on a "
 		       "non-tcp rule\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_ecn_reg = {
 	.name		= "ECN",
 	.target		= target,
+	.targetsize	= sizeof(struct ipt_ECN_info),
+	.table		= "mangle",
 	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 6606ddb..24f1495 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -438,29 +438,22 @@ static int ipt_log_checkentry(const char
 {
 	const struct ipt_log_info *loginfo = targinfo;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_log_info))) {
-		DEBUGP("LOG: targinfosize %u != %u\n",
-		       targinfosize, IPT_ALIGN(sizeof(struct ipt_log_info)));
-		return 0;
-	}
-
 	if (loginfo->level >= 8) {
 		DEBUGP("LOG: level %u >= 8\n", loginfo->level);
 		return 0;
 	}
-
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		DEBUGP("LOG: prefix term %i\n",
 		       loginfo->prefix[sizeof(loginfo->prefix)-1]);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_log_reg = {
 	.name		= "LOG",
 	.target		= ipt_log_target,
+	.targetsize	= sizeof(struct ipt_log_info),
 	.checkentry	= ipt_log_checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 12c56d3..df5ea08 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -47,19 +47,6 @@ masquerade_check(const char *tablename,
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("masquerade_check: bad table `%s'.\n", tablename);
-		return 0;
-	}
-	if (targinfosize != IPT_ALIGN(sizeof(*mr))) {
-		DEBUGP("masquerade_check: size %u != %u.\n",
-		       targinfosize, sizeof(*mr));
-		return 0;
-	}
-	if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
-		DEBUGP("masquerade_check: bad hooks %x.\n", hook_mask);
-		return 0;
-	}
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		DEBUGP("masquerade_check: bad MAP_IPS.\n");
 		return 0;
@@ -179,6 +166,9 @@ static struct notifier_block masq_inet_n
 static struct ipt_target masquerade = {
 	.name		= "MASQUERADE",
 	.target		= masquerade_target,
+	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= 1 << NF_IP_POST_ROUTING,
 	.checkentry	= masquerade_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index b074467..836d67e 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -38,19 +38,6 @@ check(const char *tablename,
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP(MODULENAME":check: bad table `%s'.\n", tablename);
-		return 0;
-	}
-	if (targinfosize != IPT_ALIGN(sizeof(*mr))) {
-		DEBUGP(MODULENAME":check: size %u.\n", targinfosize);
-		return 0;
-	}
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
-	                  (1 << NF_IP_LOCAL_OUT))) {
-		DEBUGP(MODULENAME":check: bad hooks %x.\n", hook_mask);
-		return 0;
-	}
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		DEBUGP(MODULENAME":check: bad MAP_IPS.\n");
 		return 0;
@@ -101,6 +88,10 @@ target(struct sk_buff **pskb,
 static struct ipt_target target_module = { 
 	.name 		= MODULENAME,
 	.target 	= target, 
+	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_POST_ROUTING) |
+			  (1 << NF_IP_LOCAL_OUT),
 	.checkentry 	= check,
     	.me 		= THIS_MODULE 
 };
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 140be51..cc165e0 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -40,18 +40,6 @@ redirect_check(const char *tablename,
 {
 	const struct ip_nat_multi_range_compat *mr = targinfo;
 
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("redirect_check: bad table `%s'.\n", table);
-		return 0;
-	}
-	if (targinfosize != IPT_ALIGN(sizeof(*mr))) {
-		DEBUGP("redirect_check: size %u.\n", targinfosize);
-		return 0;
-	}
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))) {
-		DEBUGP("redirect_check: bad hooks %x.\n", hook_mask);
-		return 0;
-	}
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		DEBUGP("redirect_check: bad MAP_IPS.\n");
 		return 0;
@@ -115,6 +103,9 @@ redirect_target(struct sk_buff **pskb,
 static struct ipt_target redirect_reg = {
 	.name		= "REDIRECT",
 	.target		= redirect_target,
+	.targetsize	= sizeof(struct ip_nat_multi_range_compat),
+	.table		= "nat",
+	.hooks		= (1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT),
 	.checkentry	= redirect_check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 3eb47aa..ddd6bd1 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -290,23 +290,6 @@ static int check(const char *tablename,
  	const struct ipt_reject_info *rejinfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
- 	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_reject_info))) {
-  		DEBUGP("REJECT: targinfosize %u != 0\n", targinfosize);
-  		return 0;
-  	}
-
-	/* Only allow these for packet filtering. */
-	if (strcmp(tablename, "filter") != 0) {
-		DEBUGP("REJECT: bad table `%s'.\n", tablename);
-		return 0;
-	}
-	if ((hook_mask & ~((1 << NF_IP_LOCAL_IN)
-			   | (1 << NF_IP_FORWARD)
-			   | (1 << NF_IP_LOCAL_OUT))) != 0) {
-		DEBUGP("REJECT: bad hook mask %X\n", hook_mask);
-		return 0;
-	}
-
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		printk("REJECT: ECHOREPLY no longer supported.\n");
 		return 0;
@@ -318,13 +301,16 @@ static int check(const char *tablename,
 			return 0;
 		}
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_reject_reg = {
 	.name		= "REJECT",
 	.target		= reject,
+	.targetsize	= sizeof(struct ipt_reject_info),
+	.table		= "filter",
+	.hooks		= (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_FORWARD) |
+			  (1 << NF_IP_LOCAL_OUT),
 	.checkentry	= check,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index a22de59..8743c3a 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -59,18 +59,6 @@ same_check(const char *tablename,
 
 	mr->ipnum = 0;
 
-	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("same_check: bad table `%s'.\n", tablename);
-		return 0;
-	}
-	if (targinfosize != IPT_ALIGN(sizeof(*mr))) {
-		DEBUGP("same_check: size %u.\n", targinfosize);
-		return 0;
-	}
-	if (hook_mask & ~(1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING)) {
-		DEBUGP("same_check: bad hooks %x.\n", hook_mask);
-		return 0;
-	}
 	if (mr->rangesize < 1) {
 		DEBUGP("same_check: need at least one dest range.\n");
 		return 0;
@@ -191,6 +179,9 @@ same_target(struct sk_buff **pskb,
 static struct ipt_target same_reg = { 
 	.name		= "SAME",
 	.target		= same_target,
+	.targetsize	= sizeof(struct ipt_same_info),
+	.table		= "nat",
+	.hooks		= (1 << NF_IP_PRE_ROUTING | 1 << NF_IP_POST_ROUTING),
 	.checkentry	= same_check,
 	.destroy	= same_destroy,
 	.me		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index c122841..4be6e2b 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -218,13 +218,6 @@ ipt_tcpmss_checkentry(const char *tablen
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_tcpmss_info))) {
-		DEBUGP("ipt_tcpmss_checkentry: targinfosize %u != %u\n",
-		       targinfosize, IPT_ALIGN(sizeof(struct ipt_tcpmss_info)));
-		return 0;
-	}
-
-
 	if((tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) && 
 			((hook_mask & ~((1 << NF_IP_FORWARD)
 			   	| (1 << NF_IP_LOCAL_OUT)
@@ -233,11 +226,8 @@ ipt_tcpmss_checkentry(const char *tablen
 		return 0;
 	}
 
-	if (e->ip.proto == IPPROTO_TCP
-	    && !(e->ip.invflags & IPT_INV_PROTO)
-	    && IPT_MATCH_ITERATE(e, find_syn_match))
+	if (IPT_MATCH_ITERATE(e, find_syn_match))
 		return 1;
-
 	printk("TCPMSS: Only works on TCP SYN packets\n");
 	return 0;
 }
@@ -245,6 +235,8 @@ ipt_tcpmss_checkentry(const char *tablen
 static struct ipt_target ipt_tcpmss_reg = {
 	.name		= "TCPMSS",
 	.target		= ipt_tcpmss_target,
+	.targetsize	= sizeof(struct ipt_tcpmss_info),
+	.proto		= IPPROTO_TCP,
 	.checkentry	= ipt_tcpmss_checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_TOS.c b/net/ipv4/netfilter/ipt_TOS.c
index 3a44a56..6568e3e 100644
--- a/net/ipv4/netfilter/ipt_TOS.c
+++ b/net/ipv4/netfilter/ipt_TOS.c
@@ -59,18 +59,6 @@ checkentry(const char *tablename,
 {
 	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_tos_target_info))) {
-		printk(KERN_WARNING "TOS: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_tos_target_info)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "TOS: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (tos != IPTOS_LOWDELAY
 	    && tos != IPTOS_THROUGHPUT
 	    && tos != IPTOS_RELIABILITY
@@ -79,13 +67,14 @@ checkentry(const char *tablename,
 		printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_tos_reg = {
 	.name		= "TOS",
 	.target		= target,
+	.targetsize	= sizeof(struct ipt_tos_target_info),
+	.table		= "mangle",
 	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index b769eb2..61d94e0 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -73,34 +73,21 @@ static int ipt_ttl_checkentry(const char
 {
 	struct ipt_TTL_info *info = targinfo;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_TTL_info))) {
-		printk(KERN_WARNING "ipt_TTL: targinfosize %u != %Zu\n",
-				targinfosize,
-				IPT_ALIGN(sizeof(struct ipt_TTL_info)));
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle")) {
-		printk(KERN_WARNING "ipt_TTL: can only be called from "
-			"\"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n", 
 			info->mode);
 		return 0;
 	}
-
 	if ((info->mode != IPT_TTL_SET) && (info->ttl == 0))
 		return 0;
-
 	return 1;
 }
 
 static struct ipt_target ipt_TTL = { 
 	.name 		= "TTL",
 	.target 	= ipt_ttl_target, 
+	.targetsize	= sizeof(struct ipt_TTL_info),
+	.table		= "mangle",
 	.checkentry 	= ipt_ttl_checkentry, 
 	.me 		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 180a9ea..c95e7e9 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -345,36 +345,30 @@ static int ipt_ulog_checkentry(const cha
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
 
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_ulog_info))) {
-		DEBUGP("ipt_ULOG: targinfosize %u != 0\n", targinfosize);
-		return 0;
-	}
-
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		DEBUGP("ipt_ULOG: prefix term %i\n",
 		       loginfo->prefix[sizeof(loginfo->prefix) - 1]);
 		return 0;
 	}
-
 	if (loginfo->qthreshold > ULOG_MAX_QLEN) {
 		DEBUGP("ipt_ULOG: queue threshold %i > MAX_QLEN\n",
 			loginfo->qthreshold);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_target ipt_ulog_reg = {
 	.name		= "ULOG",
 	.target		= ipt_ulog_target,
+	.targetsize	= sizeof(struct ipt_ulog_info),
 	.checkentry	= ipt_ulog_checkentry,
 	.me		= THIS_MODULE,
 };
 
 static struct nf_logger ipt_ulog_logger = {
 	.name		= "ipt_ULOG",
-	.logfn		= &ipt_logfn,
+	.logfn		= ipt_logfn,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index d6b83a9..ad5dc46 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -43,23 +43,10 @@ static int match(const struct sk_buff *s
 	return ret;
 }
 
-static int checkentry(const char *tablename, const void *ip,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_addrtype_info))) {
-		printk(KERN_ERR "ipt_addrtype: invalid size (%u != %Zu)\n",
-		       matchsize, IPT_ALIGN(sizeof(struct ipt_addrtype_info)));
-		return 0;
-	}
-
-	return 1;
-}
-
 static struct ipt_match addrtype_match = {
 	.name		= "addrtype",
 	.match		= match,
-	.checkentry	= checkentry,
+	.matchsize	= sizeof(struct ipt_addrtype_info),
 	.me		= THIS_MODULE
 };
 
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 144adfe..a33eeea 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -76,32 +76,21 @@ checkentry(const char *tablename,
 	   unsigned int hook_mask)
 {
 	const struct ipt_ah *ahinfo = matchinfo;
-	const struct ipt_ip *ip = ip_void;
 
-	/* Must specify proto == AH, and no unknown invflags */
-	if (ip->proto != IPPROTO_AH || (ip->invflags & IPT_INV_PROTO)) {
-		duprintf("ipt_ah: Protocol %u != %u\n", ip->proto,
-			 IPPROTO_AH);
-		return 0;
-	}
-	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_ah))) {
-		duprintf("ipt_ah: matchsize %u != %u\n",
-			 matchinfosize, IPT_ALIGN(sizeof(struct ipt_ah)));
-		return 0;
-	}
+	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
-		duprintf("ipt_ah: unknown flags %X\n",
-			 ahinfo->invflags);
+		duprintf("ipt_ah: unknown flags %X\n", ahinfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_match ah_match = {
 	.name		= "ah",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_ah),
+	.proto		= IPPROTO_AH,
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_dscp.c b/net/ipv4/netfilter/ipt_dscp.c
index 92063b4..e7889ba 100644
--- a/net/ipv4/netfilter/ipt_dscp.c
+++ b/net/ipv4/netfilter/ipt_dscp.c
@@ -31,20 +31,10 @@ static int match(const struct sk_buff *s
 	return ((iph->tos&IPT_DSCP_MASK) == sh_dscp) ^ info->invert;
 }
 
-static int checkentry(const char *tablename, const void *ip,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_dscp_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct ipt_match dscp_match = {
 	.name		= "dscp",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_dscp_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index e68b0c7..723957f 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -92,9 +92,6 @@ static int checkentry(const char *tablen
 	const struct ipt_ecn_info *info = matchinfo;
 	const struct ipt_ip *ip = ip_void;
 
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_ecn_info)))
-		return 0;
-
 	if (info->operation & IPT_ECN_OP_MATCH_MASK)
 		return 0;
 
@@ -113,8 +110,9 @@ static int checkentry(const char *tablen
 
 static struct ipt_match ecn_match = {
 	.name		= "ecn",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_ecn_info),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_esp.c b/net/ipv4/netfilter/ipt_esp.c
index 9de191a..984fa48 100644
--- a/net/ipv4/netfilter/ipt_esp.c
+++ b/net/ipv4/netfilter/ipt_esp.c
@@ -77,32 +77,21 @@ checkentry(const char *tablename,
 	   unsigned int hook_mask)
 {
 	const struct ipt_esp *espinfo = matchinfo;
-	const struct ipt_ip *ip = ip_void;
 
-	/* Must specify proto == ESP, and no unknown invflags */
-	if (ip->proto != IPPROTO_ESP || (ip->invflags & IPT_INV_PROTO)) {
-		duprintf("ipt_esp: Protocol %u != %u\n", ip->proto,
-			 IPPROTO_ESP);
-		return 0;
-	}
-	if (matchinfosize != IPT_ALIGN(sizeof(struct ipt_esp))) {
-		duprintf("ipt_esp: matchsize %u != %u\n",
-			 matchinfosize, IPT_ALIGN(sizeof(struct ipt_esp)));
-		return 0;
-	}
+	/* Must specify no unknown invflags */
 	if (espinfo->invflags & ~IPT_ESP_INV_MASK) {
-		duprintf("ipt_esp: unknown flags %X\n",
-			 espinfo->invflags);
+		duprintf("ipt_esp: unknown flags %X\n", espinfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_match esp_match = {
 	.name		= "esp",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_esp),
+	.proto		= IPPROTO_ESP,
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 4fe48c1..156d9c2 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -512,9 +512,6 @@ hashlimit_checkentry(const char *tablena
 {
 	struct ipt_hashlimit_info *r = matchinfo;
 
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_hashlimit_info)))
-		return 0;
-
 	/* Check for overflow. */
 	if (r->cfg.burst == 0
 	    || user2credits(r->cfg.avg * r->cfg.burst) < 
@@ -565,12 +562,13 @@ hashlimit_destroy(void *matchinfo, unsig
 	htable_put(r->hinfo);
 }
 
-static struct ipt_match ipt_hashlimit = { 
-	.name = "hashlimit", 
-	.match = hashlimit_match, 
-	.checkentry = hashlimit_checkentry, 
-	.destroy = hashlimit_destroy,
-	.me = THIS_MODULE 
+static struct ipt_match ipt_hashlimit = {
+	.name		= "hashlimit",
+	.match		= hashlimit_match,
+	.matchsize	= sizeof(struct ipt_hashlimit_info),
+	.checkentry	= hashlimit_checkentry,
+	.destroy	= hashlimit_destroy,
+	.me		= THIS_MODULE
 };
 
 /* PROC stuff */
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 13fb16f..0885ff5 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -62,27 +62,12 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
-static int check(const char *tablename,
-		 const void *inf,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
-{
-	/* verify size */
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_iprange_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match iprange_match = 
-{ 
-	.list = { NULL, NULL }, 
-	.name = "iprange", 
-	.match = &match, 
-	.checkentry = &check, 
-	.destroy = NULL, 
-	.me = THIS_MODULE
+static struct ipt_match iprange_match = {
+	.name		= "iprange",
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_iprange_info),
+	.destroy	= NULL,
+	.me		= THIS_MODULE
 };
 
 static int __init init(void)
diff --git a/net/ipv4/netfilter/ipt_multiport.c b/net/ipv4/netfilter/ipt_multiport.c
index 2d52326..8f1684c 100644
--- a/net/ipv4/netfilter/ipt_multiport.c
+++ b/net/ipv4/netfilter/ipt_multiport.c
@@ -153,40 +153,19 @@ match_v1(const struct sk_buff *skb,
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static int
-checkentry(const char *tablename,
-	   const void *ip,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
-{
-	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport)));
-}
-
-static int
-checkentry_v1(const char *tablename,
-	      const void *ip,
-	      void *matchinfo,
-	      unsigned int matchsize,
-	      unsigned int hook_mask)
-{
-	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport_v1)));
-}
-
 static struct ipt_match multiport_match = {
 	.name		= "multiport",
 	.revision	= 0,
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_multiport),
 	.me		= THIS_MODULE,
 };
 
 static struct ipt_match multiport_match_v1 = {
 	.name		= "multiport",
 	.revision	= 1,
-	.match		= &match_v1,
-	.checkentry	= &checkentry_v1,
+	.match		= match_v1,
+	.matchsize	= sizeof(struct ipt_multiport_v1),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
index 4843d0c..18adc1d 100644
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -59,31 +59,20 @@ checkentry(const char *tablename,
 {
 	const struct ipt_owner_info *info = matchinfo;
 
-        if (hook_mask
-            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
-                printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
-                return 0;
-        }
-
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_owner_info))) {
-		printk("Matchsize %u != %Zu\n", matchsize,
-		       IPT_ALIGN(sizeof(struct ipt_owner_info)));
-		return 0;
-	}
-
 	if (info->match & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
 		printk("ipt_owner: pid, sid and command matching "
 		       "not supported anymore\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ipt_match owner_match = {
 	.name		= "owner",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_owner_info),
+	.hooks		= (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_policy.c b/net/ipv4/netfilter/ipt_policy.c
index 5a7a265..3fa6607 100644
--- a/net/ipv4/netfilter/ipt_policy.c
+++ b/net/ipv4/netfilter/ipt_policy.c
@@ -125,11 +125,6 @@ static int checkentry(const char *tablen
 {
 	struct ipt_policy_info *info = matchinfo;
 
-	if (matchsize != IPT_ALIGN(sizeof(*info))) {
-		printk(KERN_ERR "ipt_policy: matchsize %u != %zu\n",
-		       matchsize, IPT_ALIGN(sizeof(*info)));
-		return 0;
-	}
 	if (!(info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "ipt_policy: neither incoming nor "
 		                "outgoing policy selected\n");
@@ -158,6 +153,7 @@ static int checkentry(const char *tablen
 static struct ipt_match policy_match = {
 	.name		= "policy",
 	.match		= match,
+	.matchsize	= sizeof(struct ipt_policy_info),
 	.checkentry 	= checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 44611d6..e2ccd42 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -670,8 +670,6 @@ checkentry(const char *tablename,
 	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() entered.\n");
 #endif
 
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_recent_info))) return 0;
-
 	/* seconds and hit_count only valid for CHECK/UPDATE */
 	if(info->check_set & IPT_RECENT_SET) { flag++; if(info->seconds || info->hit_count) return 0; }
 	if(info->check_set & IPT_RECENT_REMOVE) { flag++; if(info->seconds || info->hit_count) return 0; }
@@ -951,12 +949,13 @@ destroy(void *matchinfo, unsigned int ma
 /* This is the structure we pass to ipt_register to register our
  * module with iptables.
  */
-static struct ipt_match recent_match = { 
-  .name = "recent", 
-  .match = &match, 
-  .checkentry = &checkentry, 
-  .destroy = &destroy, 
-  .me = THIS_MODULE
+static struct ipt_match recent_match = {
+	.name		= "recent",
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_recent_info),
+	.checkentry	= checkentry,
+	.destroy	= destroy,
+	.me		= THIS_MODULE
 };
 
 /* Kernel module initialization. */
diff --git a/net/ipv4/netfilter/ipt_tos.c b/net/ipv4/netfilter/ipt_tos.c
index 9ab765e..4675c78 100644
--- a/net/ipv4/netfilter/ipt_tos.c
+++ b/net/ipv4/netfilter/ipt_tos.c
@@ -31,23 +31,10 @@ match(const struct sk_buff *skb,
 	return (skb->nh.iph->tos == info->tos) ^ info->invert;
 }
 
-static int
-checkentry(const char *tablename,
-           const void *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_tos_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct ipt_match tos_match = {
 	.name		= "tos",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_tos_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index 82da53f..bb694a0 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -47,20 +47,10 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static int checkentry(const char *tablename, const void  *ip,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_ttl_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct ipt_match ttl_match = {
 	.name		= "ttl",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ipt_ttl_info),
 	.me		= THIS_MODULE,
 };
 
