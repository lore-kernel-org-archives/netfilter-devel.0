From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/13]: Convert ip6_tables matches/targets to
	centralized error checking
Date: Thu, 16 Feb 2006 22:32:17 +0100 (MET)
Message-ID: <20060216213217.6933.79214.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert ip6_tables matches/targets to centralized error checking

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit dff18dfa6d3b6ad94a5c5b8d185cb37cb6d2af57
tree c3f4bea7849966a1152c4756f1d81a18da2bd3db
parent b5b1850e58154ca2646ec8f759164a967779d42b
author Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:05 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 16 Feb 2006 14:17:05 +0100

 net/ipv6/netfilter/ip6_tables.c      |   23 +++++++----------------
 net/ipv6/netfilter/ip6t_HL.c         |   17 ++---------------
 net/ipv6/netfilter/ip6t_LOG.c        |    9 +--------
 net/ipv6/netfilter/ip6t_REJECT.c     |   23 ++++-------------------
 net/ipv6/netfilter/ip6t_ah.c         |   10 +++-------
 net/ipv6/netfilter/ip6t_dst.c        |   11 +++--------
 net/ipv6/netfilter/ip6t_esp.c        |   10 +++-------
 net/ipv6/netfilter/ip6t_eui64.c      |   26 ++++----------------------
 net/ipv6/netfilter/ip6t_frag.c       |   11 +++--------
 net/ipv6/netfilter/ip6t_hbh.c        |   11 +++--------
 net/ipv6/netfilter/ip6t_hl.c         |   14 ++------------
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 +-----
 net/ipv6/netfilter/ip6t_multiport.c  |    9 +++------
 net/ipv6/netfilter/ip6t_owner.c      |   16 ++++------------
 net/ipv6/netfilter/ip6t_policy.c     |    6 +-----
 net/ipv6/netfilter/ip6t_rt.c         |   10 +++-------
 16 files changed, 47 insertions(+), 165 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 3d2fefe..88f5d29 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -544,21 +544,12 @@ standard_check(const struct ip6t_entry_t
 	struct ip6t_standard_target *targ = (void *)t;
 
 	/* Check standard info. */
-	if (t->u.target_size
-	    != IP6T_ALIGN(sizeof(struct ip6t_standard_target))) {
-		duprintf("standard_check: target size %u != %u\n",
-			 t->u.target_size,
-			 IP6T_ALIGN(sizeof(struct ip6t_standard_target)));
-		return 0;
-	}
-
 	if (targ->verdict >= 0
 	    && targ->verdict > max_offset - sizeof(struct ip6t_entry)) {
 		duprintf("ip6t_standard_check: bad verdict (%i)\n",
 			 targ->verdict);
 		return 0;
 	}
-
 	if (targ->verdict < -NF_MAX_VERDICT - 1) {
 		duprintf("ip6t_standard_check: bad negative verdict (%i)\n",
 			 targ->verdict);
@@ -1385,24 +1376,22 @@ icmp6_checkentry(const char *tablename,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct ip6t_ip6 *ipv6 = entry;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
-	/* Must specify proto == ICMP, and no unknown invflags */
-	return ipv6->proto == IPPROTO_ICMPV6
-		&& !(ipv6->invflags & IP6T_INV_PROTO)
-		&& matchsize == IP6T_ALIGN(sizeof(struct ip6t_icmp))
-		&& !(icmpinfo->invflags & ~IP6T_ICMP_INV);
+	/* Must specify no unknown invflags */
+	return !(icmpinfo->invflags & ~IP6T_ICMP_INV);
 }
 
 /* The built-in targets: standard (NULL) and error. */
 static struct ip6t_target ip6t_standard_target = {
 	.name		= IP6T_STANDARD_TARGET,
+	.targetsize	= sizeof(int),
 };
 
 static struct ip6t_target ip6t_error_target = {
 	.name		= IP6T_ERROR_TARGET,
 	.target		= ip6t_error,
+	.targetsize	= IP6T_FUNCTION_MAXNAMELEN,
 };
 
 static struct nf_sockopt_ops ip6t_sockopts = {
@@ -1418,7 +1407,9 @@ static struct nf_sockopt_ops ip6t_sockop
 static struct ip6t_match icmp6_matchstruct = {
 	.name		= "icmp6",
 	.match		= &icmp6_match,
-	.checkentry	= &icmp6_checkentry,
+	.matchsize	= sizeof(struct ip6t_icmp),
+	.checkentry	= icmp6_checkentry,
+	.proto		= IPPROTO_ICMPV6,
 };
 
 static int __init init(void)
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 306200c..ab39ee9 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -69,37 +69,24 @@ static int ip6t_hl_checkentry(const char
 {
 	struct ip6t_HL_info *info = targinfo;
 
-	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_HL_info))) {
-		printk(KERN_WARNING "ip6t_HL: targinfosize %u != %Zu\n",
-				targinfosize,
-				IP6T_ALIGN(sizeof(struct ip6t_HL_info)));
-		return 0;	
-	}	
-
-	if (strcmp(tablename, "mangle")) {
-		printk(KERN_WARNING "ip6t_HL: can only be called from "
-			"\"mangle\" table, not \"%s\"\n", tablename);
-		return 0;
-	}
-
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n", 
 			info->mode);
 		return 0;
 	}
-
 	if ((info->mode != IP6T_HL_SET) && (info->hop_limit == 0)) {
 		printk(KERN_WARNING "ip6t_HL: increment/decrement doesn't "
 			"make sense with value 0\n");
 		return 0;
 	}
-	
 	return 1;
 }
 
 static struct ip6t_target ip6t_HL = { 
 	.name 		= "HL", 
 	.target		= ip6t_hl_target, 
+	.targetsize	= sizeof(struct ip6t_HL_info),
+	.table		= "mangle",
 	.checkentry	= ip6t_hl_checkentry, 
 	.me		= THIS_MODULE
 };
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 77c7258..171c9ba 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -450,29 +450,22 @@ static int ip6t_log_checkentry(const cha
 {
 	const struct ip6t_log_info *loginfo = targinfo;
 
-	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_log_info))) {
-		DEBUGP("LOG: targinfosize %u != %u\n",
-		       targinfosize, IP6T_ALIGN(sizeof(struct ip6t_log_info)));
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
 
 static struct ip6t_target ip6t_log_reg = {
 	.name 		= "LOG",
 	.target 	= ip6t_log_target, 
+	.targetsize	= sizeof(struct ip6t_log_info),
 	.checkentry	= ip6t_log_checkentry, 
 	.me 		= THIS_MODULE,
 };
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 0e6d1d4..8640706 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -228,24 +228,6 @@ static int check(const char *tablename,
  	const struct ip6t_reject_info *rejinfo = targinfo;
 	const struct ip6t_entry *e = entry;
 
- 	if (targinfosize != IP6T_ALIGN(sizeof(struct ip6t_reject_info))) {
-  		DEBUGP("ip6t_REJECT: targinfosize %u != 0\n", targinfosize);
-  		return 0;
-  	}
-
-	/* Only allow these for packet filtering. */
-	if (strcmp(tablename, "filter") != 0) {
-		DEBUGP("ip6t_REJECT: bad table `%s'.\n", tablename);
-		return 0;
-	}
-
-	if ((hook_mask & ~((1 << NF_IP6_LOCAL_IN)
-			   | (1 << NF_IP6_FORWARD)
-			   | (1 << NF_IP6_LOCAL_OUT))) != 0) {
-		DEBUGP("ip6t_REJECT: bad hook mask %X\n", hook_mask);
-		return 0;
-	}
-
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
 		return 0;
@@ -257,13 +239,16 @@ static int check(const char *tablename,
 			return 0;
 		}
 	}
-
 	return 1;
 }
 
 static struct ip6t_target ip6t_reject_reg = {
 	.name		= "REJECT",
 	.target		= reject6_target,
+	.targetsize	= sizeof(struct ip6t_reject_info),
+	.table		= "filter",
+	.hooks		= (1 << NF_IP6_LOCAL_IN) | (1 << NF_IP6_FORWARD) |
+			  (1 << NF_IP6_LOCAL_OUT),
 	.checkentry	= check,
 	.me		= THIS_MODULE
 };
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 219a303..28710ed 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -105,11 +105,6 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_ah *ahinfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_ah))) {
-		DEBUGP("ip6t_ah: matchsize %u != %u\n",
-		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_ah)));
-		return 0;
-	}
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
 		DEBUGP("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
 		return 0;
@@ -119,8 +114,9 @@ checkentry(const char *tablename,
 
 static struct ip6t_match ah_match = {
 	.name		= "ah",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_ah),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index b4c153a..2fbde59 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -185,16 +185,10 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
-		DEBUGP("ip6t_opts: matchsize %u != %u\n",
-		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
-		return 0;
-	}
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 
@@ -204,8 +198,9 @@ static struct ip6t_match opts_match = {
 #else
 	.name		= "dst",
 #endif
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_opts),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
index 724285d..ede7223 100644
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ b/net/ipv6/netfilter/ip6t_esp.c
@@ -83,11 +83,6 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_esp *espinfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_esp))) {
-		DEBUGP("ip6t_esp: matchsize %u != %u\n",
-			 matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_esp)));
-		return 0;
-	}
 	if (espinfo->invflags & ~IP6T_ESP_INV_MASK) {
 		DEBUGP("ip6t_esp: unknown flags %X\n",
 			 espinfo->invflags);
@@ -98,8 +93,9 @@ checkentry(const char *tablename,
 
 static struct ip6t_match esp_match = {
 	.name		= "esp",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_esp),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index 27396ac..bfee5be 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -60,30 +60,12 @@ match(const struct sk_buff *skb,
 	return 0;
 }
 
-static int
-ip6t_eui64_checkentry(const char *tablename,
-		      const void *ip,
-		      void *matchinfo,
-		      unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	if (hook_mask
-	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
-		(1 << NF_IP6_FORWARD))) {
-		printk("ip6t_eui64: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
-		return 0;
-	}
-
-	if (matchsize != IP6T_ALIGN(sizeof(int)))
-		return 0;
-
-	return 1;
-}
-
 static struct ip6t_match eui64_match = {
 	.name		= "eui64",
-	.match		= &match,
-	.checkentry	= &ip6t_eui64_checkentry,
+	.match		= match,
+	.matchsize	= sizeof(int),
+	.hooks		= (1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
+			  (1 << NF_IP6_FORWARD),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 4c14125..305de9b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -122,23 +122,18 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_frag *fraginfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_frag))) {
-		DEBUGP("ip6t_frag: matchsize %u != %u\n",
-		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_frag)));
-		return 0;
-	}
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
 		DEBUGP("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ip6t_match frag_match = {
 	.name		= "frag",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_frag),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 37a8474..ac8d479 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -185,16 +185,10 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_opts *optsinfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
-		DEBUGP("ip6t_opts: matchsize %u != %u\n",
-		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
-		return 0;
-	}
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
 		return 0;
 	}
-
 	return 1;
 }
 
@@ -204,8 +198,9 @@ static struct ip6t_match opts_match = {
 #else
 	.name		= "dst",
 #endif
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_opts),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index c5d9079..1eabb65 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -48,20 +48,10 @@ static int match(const struct sk_buff *s
 	return 0;
 }
 
-static int checkentry(const char *tablename, const void *entry,
-		      void *matchinfo, unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_hl_info)))
-		return 0;
-
-	return 1;
-}
-
 static struct ip6t_match hl_match = {
 	.name		= "hl",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_hl_info),
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 83ad6b2..063032a 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -131,11 +131,6 @@ ipv6header_checkentry(const char *tablen
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
 
-	/* Check for obvious errors */
-	/* This match is valid in all hooks! */
-	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)))
-		return 0;
-
 	/* invflags is 0 or 0xff in hard mode */
 	if ((!info->modeflag) && info->invflags != 0x00 &&
 	    info->invflags != 0xFF)
@@ -147,6 +142,7 @@ ipv6header_checkentry(const char *tablen
 static struct ip6t_match ip6t_ipv6header_match = {
 	.name		= "ipv6header",
 	.match		= &ipv6header_match,
+	.matchsize	= sizeof(struct ip6t_ipv6header_info),
 	.checkentry	= &ipv6header_checkentry,
 	.destroy	= NULL,
 	.me		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
index 49f7829..b86774d 100644
--- a/net/ipv6/netfilter/ip6t_multiport.c
+++ b/net/ipv6/netfilter/ip6t_multiport.c
@@ -92,13 +92,9 @@ checkentry(const char *tablename,
 	const struct ip6t_ip6 *ip = info;
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
-	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_multiport)))
-		return 0;
-
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
 		&& !(ip->invflags & IP6T_INV_PROTO)
-		&& matchsize == IP6T_ALIGN(sizeof(struct ip6t_multiport))
 		&& (multiinfo->flags == IP6T_MULTIPORT_SOURCE
 		    || multiinfo->flags == IP6T_MULTIPORT_DESTINATION
 		    || multiinfo->flags == IP6T_MULTIPORT_EITHER)
@@ -107,8 +103,9 @@ checkentry(const char *tablename,
 
 static struct ip6t_match multiport_match = {
 	.name		= "multiport",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_multiport),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 8c8a4c7..e26cd6d 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -60,28 +60,20 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
-	if (hook_mask
-	    & ~((1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING))) {
-		printk("ip6t_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
-		return 0;
-	}
-
-	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_owner_info)))
-		return 0;
-
 	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
 		printk("ipt_owner: pid and sid matching "
 		       "not supported anymore\n");
 		return 0;
 	}
-
 	return 1;
 }
 
 static struct ip6t_match owner_match = {
 	.name		= "owner",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_owner_info),
+	.hooks		= (1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_policy.c b/net/ipv6/netfilter/ip6t_policy.c
index 3d39ec9..ac8a544 100644
--- a/net/ipv6/netfilter/ip6t_policy.c
+++ b/net/ipv6/netfilter/ip6t_policy.c
@@ -125,11 +125,6 @@ static int checkentry(const char *tablen
 {
 	struct ip6t_policy_info *info = matchinfo;
 
-	if (matchsize != IP6T_ALIGN(sizeof(*info))) {
-		printk(KERN_ERR "ip6t_policy: matchsize %u != %zu\n",
-		       matchsize, IP6T_ALIGN(sizeof(*info)));
-		return 0;
-	}
 	if (!(info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "ip6t_policy: neither incoming nor "
 		                "outgoing policy selected\n");
@@ -158,6 +153,7 @@ static int checkentry(const char *tablen
 static struct ip6t_match policy_match = {
 	.name		= "policy",
 	.match		= match,
+	.matchsize	= sizeof(struct ip6t_policy_info),
 	.checkentry 	= checkentry,
 	.me		= THIS_MODULE,
 };
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 8f82476..a381074 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -200,11 +200,6 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_rt *rtinfo = matchinfo;
 
-	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_rt))) {
-		DEBUGP("ip6t_rt: matchsize %u != %u\n",
-		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_rt)));
-		return 0;
-	}
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
 		DEBUGP("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
 		return 0;
@@ -222,8 +217,9 @@ checkentry(const char *tablename,
 
 static struct ip6t_match rt_match = {
 	.name		= "rt",
-	.match		= &match,
-	.checkentry	= &checkentry,
+	.match		= match,
+	.matchsize	= sizeof(struct ip6t_rt),
+	.checkentry	= checkentry,
 	.me		= THIS_MODULE,
 };
 
