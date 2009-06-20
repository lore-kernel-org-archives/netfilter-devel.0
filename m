From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 5/6] IPv6 specific extensions
Date: Sun, 21 Jun 2009 00:01:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210000310.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:55959 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZFTWBi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:01:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id C80088827D
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:01:39 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ktg2B-B-3lGh for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:01:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id AE2978825F
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:01:39 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The IPv6 specific extensions with the new error reporting methods.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter_ipv6/ip6t_HL.h         |    8 ++++++
 include/linux/netfilter_ipv6/ip6t_LOG.h        |    7 ++++++
 include/linux/netfilter_ipv6/ip6t_REJECT.h     |    9 +++++++
 include/linux/netfilter_ipv6/ip6t_ah.h         |    6 +++++
 include/linux/netfilter_ipv6/ip6t_eui64.h      |   10 ++++++++
 include/linux/netfilter_ipv6/ip6t_frag.h       |    6 +++++
 include/linux/netfilter_ipv6/ip6t_ipv6header.h |    6 +++++
 include/linux/netfilter_ipv6/ip6t_mh.h         |    7 ++++++
 include/linux/netfilter_ipv6/ip6t_opts.h       |    7 ++++++
 include/linux/netfilter_ipv6/ip6t_rt.h         |    7 ++++++
 net/ipv6/netfilter/ip6t_LOG.c                  |   11 +++++----
 net/ipv6/netfilter/ip6t_REJECT.c               |   30 ++++++++++++++++--------
 net/ipv6/netfilter/ip6t_ah.c                   |    9 ++++---
 net/ipv6/netfilter/ip6t_eui64.c                |   18 +++++++++++++-
 net/ipv6/netfilter/ip6t_frag.c                 |    9 ++++---
 net/ipv6/netfilter/ip6t_hbh.c                  |   11 +++++----
 net/ipv6/netfilter/ip6t_ipv6header.c           |    6 ++---
 net/ipv6/netfilter/ip6t_mh.c                   |   17 ++++++++++----
 net/ipv6/netfilter/ip6t_rt.c                   |    8 +++---
 19 files changed, 151 insertions(+), 41 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6t_HL.h b/include/linux/netfilter_ipv6/ip6t_HL.h
index afb7813..a529fc2 100644
--- a/include/linux/netfilter_ipv6/ip6t_HL.h
+++ b/include/linux/netfilter_ipv6/ip6t_HL.h
@@ -6,6 +6,14 @@
 #define _IP6T_HL_H
 
 enum {
+	XT_HL_ERR_NONE,
+	XT_HL_ERR_MANGLE_TABLE,
+	XT_HL_ERR_MODE,
+	XT_HL_ERR_SET,
+	XT_HL_ERR_MAX,
+};
+
+enum {
 	IP6T_HL_SET = 0,
 	IP6T_HL_INC,
 	IP6T_HL_DEC
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 0d0119b..17f3c4d 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -9,6 +9,13 @@
 #define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
 #define IP6T_LOG_MASK		0x1f
 
+enum {
+	IP6T_LOG_ERR_NONE,
+	IP6T_LOG_ERR_LEVEL,
+	IP6T_LOG_ERR_PREFIXLEN,
+	IP6T_LOG_ERR_MAX,
+};
+
 struct ip6t_log_info {
 	unsigned char level;
 	unsigned char logflags;
diff --git a/include/linux/netfilter_ipv6/ip6t_REJECT.h b/include/linux/netfilter_ipv6/ip6t_REJECT.h
index 6be6504..02f8dcd 100644
--- a/include/linux/netfilter_ipv6/ip6t_REJECT.h
+++ b/include/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -11,6 +11,15 @@ enum ip6t_reject_with {
 	IP6T_TCP_RESET
 };
 
+enum {
+	IP6T_REJECT_ERR_NONE,
+	IP6T_REJECT_ERR_FILTER_TABLE,
+	IP6T_REJECT_ERR_HOOKS_123,
+	IP6T_REJECT_ERR_ECHOREPLY,
+	IP6T_REJECT_ERR_NOT_TCP,
+	IP6T_REJECT_ERR_MAX,
+};
+
 struct ip6t_reject_info {
 	u_int32_t	with;	/* reject type */
 };
diff --git a/include/linux/netfilter_ipv6/ip6t_ah.h b/include/linux/netfilter_ipv6/ip6t_ah.h
index 8531879..7c664c6 100644
--- a/include/linux/netfilter_ipv6/ip6t_ah.h
+++ b/include/linux/netfilter_ipv6/ip6t_ah.h
@@ -1,6 +1,12 @@
 #ifndef _IP6T_AH_H
 #define _IP6T_AH_H
 
+enum {
+	IP6T_AH_ERR_NONE,
+	IP6T_AH_ERR_FLAGS,
+	IP6T_AH_ERR_MAX,
+};
+
 struct ip6t_ah
 {
 	u_int32_t spis[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv6/ip6t_eui64.h b/include/linux/netfilter_ipv6/ip6t_eui64.h
new file mode 100644
index 0000000..b9fe28b
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_eui64.h
@@ -0,0 +1,10 @@
+#ifndef _IP6T_EUI64_H
+#define _IP6T_EUI64_H
+
+enum {
+	IP6T_EUI64_ERR_NONE,
+	IP6T_EUI64_ERR_HOOKS_012,
+	IP6T_EUI64_ERR_MAX,
+};
+
+#endif /*_IP6T_EUI64_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_frag.h b/include/linux/netfilter_ipv6/ip6t_frag.h
index 66070a0..22be05c 100644
--- a/include/linux/netfilter_ipv6/ip6t_frag.h
+++ b/include/linux/netfilter_ipv6/ip6t_frag.h
@@ -1,6 +1,12 @@
 #ifndef _IP6T_FRAG_H
 #define _IP6T_FRAG_H
 
+enum {
+	IP6T_FRAG_ERR_NONE,
+	IP6T_FRAG_ERR_FLAGS,
+	IP6T_FRAG_ERR_MAX,
+};
+
 struct ip6t_frag
 {
 	u_int32_t ids[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv6/ip6t_ipv6header.h b/include/linux/netfilter_ipv6/ip6t_ipv6header.h
index 51c53fc..d516f67 100644
--- a/include/linux/netfilter_ipv6/ip6t_ipv6header.h
+++ b/include/linux/netfilter_ipv6/ip6t_ipv6header.h
@@ -8,6 +8,12 @@ on whether they contain certain headers */
 #ifndef __IPV6HEADER_H
 #define __IPV6HEADER_H
 
+enum {
+	IP6T_IPV6HEADER_ERR_NONE,
+	IP6T_IPV6HEADER_ERR_FLAGS,
+	IP6T_IPV6HEADER_ERR_MAX,
+};
+
 struct ip6t_ipv6header_info
 {
 	u_int8_t matchflags;
diff --git a/include/linux/netfilter_ipv6/ip6t_mh.h b/include/linux/netfilter_ipv6/ip6t_mh.h
index b9ca9a5..0da311c 100644
--- a/include/linux/netfilter_ipv6/ip6t_mh.h
+++ b/include/linux/netfilter_ipv6/ip6t_mh.h
@@ -1,6 +1,13 @@
 #ifndef _IP6T_MH_H
 #define _IP6T_MH_H
 
+enum {
+	IP6T_MH_ERR_NONE,
+	IP6T_MH_ERR_PROTO,
+	IP6T_MH_ERR_FLAGS,
+	IP6T_MH_ERR_MAX,
+};
+
 /* MH matching stuff */
 struct ip6t_mh
 {
diff --git a/include/linux/netfilter_ipv6/ip6t_opts.h b/include/linux/netfilter_ipv6/ip6t_opts.h
index a07e363..21a4f60 100644
--- a/include/linux/netfilter_ipv6/ip6t_opts.h
+++ b/include/linux/netfilter_ipv6/ip6t_opts.h
@@ -3,6 +3,13 @@
 
 #define IP6T_OPTS_OPTSNR 16
 
+enum {
+	IP6T_OPTS_ERR_NONE,
+	IP6T_OPTS_ERR_FLAGS,
+	IP6T_OPTS_ERR_STRICT,
+	IP6T_OPTS_ERR_MAX,
+};
+
 struct ip6t_opts
 {
 	u_int32_t hdrlen;			/* Header Length */
diff --git a/include/linux/netfilter_ipv6/ip6t_rt.h b/include/linux/netfilter_ipv6/ip6t_rt.h
index 5215602..ccd6185 100644
--- a/include/linux/netfilter_ipv6/ip6t_rt.h
+++ b/include/linux/netfilter_ipv6/ip6t_rt.h
@@ -5,6 +5,13 @@
 
 #define IP6T_RT_HOPS 16
 
+enum {
+	IP6T_RT_ERR_NONE,
+	IP6T_RT_ERR_FLAGS,
+	IP6T_RT_ERR_RT0,
+	IP6T_RT_ERR_MAX,
+};
+
 struct ip6t_rt
 {
 	u_int32_t rt_type;			/* Routing Type */
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 7018cac..f4c240f 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -452,20 +452,21 @@ log_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 
 
-static bool log_tg6_check(const struct xt_tgchk_param *par)
+static unsigned int log_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct ip6t_log_info *loginfo = par->targinfo;
+	struct ip6t_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
-		return false;
+		return IP6T_LOG_ERR_LEVEL;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		pr_debug("LOG: prefix term %i\n",
 			 loginfo->prefix[sizeof(loginfo->prefix)-1]);
-		return false;
+		loginfo->prefix[sizeof(loginfo->prefix)-1] = '\0';
+		return IP6T_LOG_ERR_PREFIXLEN;
 	}
-	return true;
+	return IP6T_LOG_ERR_NONE;
 }
 
 static struct xt_target log_tg6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 5a7f00c..20d94d9 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -213,23 +213,36 @@ reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool reject_tg6_check(const struct xt_tgchk_param *par)
+static unsigned int reject_tg6_check(const struct xt_tgchk_param *par)
 {
 	const struct ip6t_reject_info *rejinfo = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
-
+	unsigned int valid_hooks = (1 << NF_INET_LOCAL_IN) |
+		(1 << NF_INET_FORWARD) |
+		(1 << NF_INET_LOCAL_OUT);
+
+	if (strcmp(par->table, "filter") != 0) {
+		xt_compat_log(par, "REJECT target can only be used in the "
+			      "\"filter\" table.");
+	    	return IP6T_REJECT_ERR_FILTER_TABLE;
+	}
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "REJECT target can only be used in the "
+			      "INPUT, FORWARD and OUTPUT chains.");
+		return IP6T_REJECT_ERR_HOOKS_123;
+	}
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
-		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
-		return false;
+		xt_compat_log(par, "ip6t_REJECT: ECHOREPLY is not supported.");
+		return IP6T_REJECT_ERR_ECHOREPLY;
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ipv6.proto != IPPROTO_TCP
 		    || (e->ipv6.invflags & XT_INV_PROTO)) {
-			printk("ip6t_REJECT: TCP_RESET illegal for non-tcp\n");
-			return false;
+			printk("ip6t_REJECT: TCP_RESET illegal for non-tcp");
+			return IP6T_REJECT_ERR_NOT_TCP;
 		}
 	}
-	return true;
+	return IP6T_REJECT_ERR_NONE;
 }
 
 static struct xt_target reject_tg6_reg __read_mostly = {
@@ -237,9 +250,6 @@ static struct xt_target reject_tg6_reg __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.target		= reject_tg6,
 	.targetsize	= sizeof(struct ip6t_reject_info),
-	.table		= "filter",
-	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT),
 	.checkentry	= reject_tg6_check,
 	.me		= THIS_MODULE
 };
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 3a82f24..79879dd 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -90,15 +90,16 @@ static bool ah_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	       !(ahinfo->hdrres && ah->reserved);
 }
 
-static bool ah_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int ah_mt6_check(const struct xt_mtchk_param *par)
 {
-	const struct ip6t_ah *ahinfo = par->matchinfo;
+	struct ip6t_ah *ahinfo = par->matchinfo;
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
 		pr_debug("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
-		return false;
+		ahinfo->invflags &= ~IP6T_AH_INV_MASK;
+		return IP6T_AH_ERR_FLAGS;
 	}
-	return true;
+	return IP6T_AH_ERR_NONE;
 }
 
 static struct xt_match ah_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index db610ba..837468e 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -14,6 +14,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_eui64.h>
 
 MODULE_DESCRIPTION("Xtables: IPv6 EUI64 address match");
 MODULE_LICENSE("GPL");
@@ -55,13 +56,26 @@ eui64_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
+static unsigned int eui64_mt6_checkentry(const struct xt_mtchk_param *par)
+{
+	unsigned int valid_hooks = (1 << NF_INET_PRE_ROUTING) |
+		(1 << NF_INET_LOCAL_IN) |
+		(1 << NF_INET_FORWARD);
+
+	if ((par->hook_mask & ~valid_hooks) != 0) {
+		xt_compat_log(par, "eui64 match can only be used in the "
+			      "PREROUTING, INPUT and FORWARD chains.");
+		return IP6T_EUI64_ERR_HOOKS_012;
+	}
+	return IP6T_EUI64_ERR_NONE;
+}
+
 static struct xt_match eui64_mt6_reg __read_mostly = {
 	.name		= "eui64",
 	.family		= NFPROTO_IPV6,
 	.match		= eui64_mt6,
 	.matchsize	= sizeof(int),
-	.hooks		= (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_FORWARD),
+	.checkentry	= eui64_mt6_checkentry,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 673aa0a..465c5b5 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -107,15 +107,16 @@ frag_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 		 && (ntohs(fh->frag_off) & IP6_MF));
 }
 
-static bool frag_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int frag_mt6_check(const struct xt_mtchk_param *par)
 {
-	const struct ip6t_frag *fraginfo = par->matchinfo;
+	struct ip6t_frag *fraginfo = par->matchinfo;
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
 		pr_debug("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
-		return false;
+		fraginfo->invflags &= ~IP6T_FRAG_INV_MASK;
+		return IP6T_FRAG_ERR_FLAGS;
 	}
-	return true;
+	return IP6T_FRAG_ERR_NONE;
 }
 
 static struct xt_match frag_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index cbe8dec..24c55db 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -160,21 +160,22 @@ hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool hbh_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int hbh_mt6_check(const struct xt_mtchk_param *par)
 {
-	const struct ip6t_opts *optsinfo = par->matchinfo;
+	struct ip6t_opts *optsinfo = par->matchinfo;
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		pr_debug("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
-		return false;
+		optsinfo->invflags &= ~IP6T_OPTS_INV_MASK;
+		return IP6T_OPTS_ERR_FLAGS;
 	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
 		pr_debug("ip6t_opts: Not strict - not implemented");
-		return false;
+		return IP6T_OPTS_ERR_STRICT;
 	}
 
-	return true;
+	return IP6T_OPTS_ERR_NONE;
 }
 
 static struct xt_match hbh_mt6_reg[] __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 91490ad..69b5d1f 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -118,16 +118,16 @@ ipv6header_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	}
 }
 
-static bool ipv6header_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int ipv6header_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_ipv6header_info *info = par->matchinfo;
 
 	/* invflags is 0 or 0xff in hard mode */
 	if ((!info->modeflag) && info->invflags != 0x00 &&
 	    info->invflags != 0xFF)
-		return false;
+		return IP6T_IPV6HEADER_ERR_FLAGS;
 
-	return true;
+	return IP6T_IPV6HEADER_ERR_NONE;
 }
 
 static struct xt_match ipv6header_mt6_reg __read_mostly = {
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index aafe4e6..b47ae46 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -67,12 +67,22 @@ static bool mh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
 
-static bool mh_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int mh_mt6_check(const struct xt_mtchk_param *par)
 {
-	const struct ip6t_mh *mhinfo = par->matchinfo;
+	struct ip6t_mh *mhinfo = par->matchinfo;
+
+	if (par->proto != IPPROTO_MH || par->inverted) {
+		xt_compat_log(par, "mh match: only valid for protocol ipv6-mh");
+		return IP6T_MH_ERR_PROTO;
+	}
 
 	/* Must specify no unknown invflags */
-	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
+	if (mhinfo->invflags & ~IP6T_MH_INV_MASK) {
+		mhinfo->invflags &= ~IP6T_MH_INV_MASK;
+		return IP6T_MH_ERR_FLAGS;
+	}
+	
+	return IP6T_MH_ERR_NONE;
 }
 
 static struct xt_match mh_mt6_reg __read_mostly = {
@@ -81,7 +91,6 @@ static struct xt_match mh_mt6_reg __read_mostly = {
 	.checkentry	= mh_mt6_check,
 	.match		= mh_mt6,
 	.matchsize	= sizeof(struct ip6t_mh),
-	.proto		= IPPROTO_MH,
 	.me		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 356b8d6..998f0d4 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -186,23 +186,23 @@ static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 	return false;
 }
 
-static bool rt_mt6_check(const struct xt_mtchk_param *par)
+static unsigned int rt_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_rt *rtinfo = par->matchinfo;
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
 		pr_debug("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
-		return false;
+		return IP6T_RT_ERR_FLAGS;
 	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
 	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
 		pr_debug("`--rt-type 0' required before `--rt-0-*'");
-		return false;
+		return IP6T_RT_ERR_RT0;
 	}
 
-	return true;
+	return IP6T_RT_ERR_NONE;
 }
 
 static struct xt_match rt_mt6_reg __read_mostly = {


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
