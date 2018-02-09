From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 9/9] netfilter: x_tables: use pr ratelimiting in all remaining spots
Date: Fri,  9 Feb 2018 15:52:07 +0100
Message-ID: <20180209145207.2097-10-fw@strlen.de>
References: <20180209145207.2097-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46654 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751041AbeBIOzs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Feb 2018 09:55:48 -0500
In-Reply-To: <20180209145207.2097-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_ECN.c       |  2 +-
 net/ipv4/netfilter/ipt_REJECT.c    |  4 ++--
 net/ipv4/netfilter/ipt_rpfilter.c  |  2 +-
 net/ipv6/netfilter/ip6t_REJECT.c   |  4 ++--
 net/ipv6/netfilter/ip6t_rpfilter.c |  2 +-
 net/ipv6/netfilter/ip6t_srh.c      |  6 ++++--
 net/netfilter/xt_AUDIT.c           |  4 ++--
 net/netfilter/xt_CHECKSUM.c        |  3 ++-
 net/netfilter/xt_CONNSECMARK.c     |  6 +++---
 net/netfilter/xt_LED.c             |  2 +-
 net/netfilter/xt_SECMARK.c         | 14 ++++++++------
 net/netfilter/xt_TCPMSS.c          | 10 ++++------
 net/netfilter/xt_TPROXY.c          |  6 ++----
 net/netfilter/xt_bpf.c             |  4 +++-
 net/netfilter/xt_cgroup.c          |  8 +++++---
 net/netfilter/xt_cluster.c         |  8 +++-----
 net/netfilter/xt_connbytes.c       |  4 ++--
 net/netfilter/xt_connlabel.c       |  7 ++++---
 net/netfilter/xt_connmark.c        |  8 ++++----
 net/netfilter/xt_conntrack.c       |  4 ++--
 net/netfilter/xt_ecn.c             |  4 ++--
 net/netfilter/xt_hashlimit.c       | 24 +++++++++++++-----------
 net/netfilter/xt_helper.c          |  4 ++--
 net/netfilter/xt_ipcomp.c          |  2 +-
 net/netfilter/xt_ipvs.c            |  3 ++-
 net/netfilter/xt_l2tp.c            | 22 +++++++++++++---------
 net/netfilter/xt_limit.c           |  4 ++--
 net/netfilter/xt_nat.c             |  5 +++--
 net/netfilter/xt_nfacct.c          |  6 ++++--
 net/netfilter/xt_physdev.c         |  4 +---
 net/netfilter/xt_recent.c          | 14 ++++++--------
 net/netfilter/xt_socket.c          | 10 ++++++----
 net/netfilter/xt_state.c           |  4 ++--
 net/netfilter/xt_time.c            |  6 +++---
 34 files changed, 116 insertions(+), 104 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 39ff167e6d86..aaaf9a81fbc9 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -106,7 +106,7 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
 
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR)) &&
 	    (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & XT_INV_PROTO))) {
-		pr_info("cannot use TCP operations on a non-tcp rule\n");
+		pr_info_ratelimited("cannot use operation on non-tcp rule\n");
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 8bd0d7b26632..e8bed3390e58 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -74,13 +74,13 @@ static int reject_tg_check(const struct xt_tgchk_param *par)
 	const struct ipt_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
-		pr_info("ECHOREPLY no longer supported.\n");
+		pr_info_ratelimited("ECHOREPLY no longer supported.\n");
 		return -EINVAL;
 	} else if (rejinfo->with == IPT_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (e->ip.proto != IPPROTO_TCP ||
 		    (e->ip.invflags & XT_INV_PROTO)) {
-			pr_info("TCP_RESET invalid for non-tcp\n");
+			pr_info_ratelimited("TCP_RESET invalid for non-tcp\n");
 			return -EINVAL;
 		}
 	}
diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 5d107dd9098e..fd01f13c896a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -105,7 +105,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 	const struct xt_rpfilter_info *info = par->matchinfo;
 	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
 	if (info->flags & options) {
-		pr_info("unknown options encountered");
+		pr_info_ratelimited("unknown options\n");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index fa51a205918d..38dea8ff680f 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -85,14 +85,14 @@ static int reject_tg6_check(const struct xt_tgchk_param *par)
 	const struct ip6t_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
-		pr_info("ECHOREPLY is not supported.\n");
+		pr_info_ratelimited("ECHOREPLY is not supported\n");
 		return -EINVAL;
 	} else if (rejinfo->with == IP6T_TCP_RESET) {
 		/* Must specify that it's a TCP packet */
 		if (!(e->ipv6.flags & IP6T_F_PROTO) ||
 		    e->ipv6.proto != IPPROTO_TCP ||
 		    (e->ipv6.invflags & XT_INV_PROTO)) {
-			pr_info("TCP_RESET illegal for non-tcp\n");
+			pr_info_ratelimited("TCP_RESET illegal for non-tcp\n");
 			return -EINVAL;
 		}
 	}
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index ddf3111f9810..94deb69bbbda 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -103,7 +103,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
 
 	if (info->flags & options) {
-		pr_info("unknown options encountered");
+		pr_info_ratelimited("unknown options\n");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 9642164107ce..33719d5560c8 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -122,12 +122,14 @@ static int srh_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_srh *srhinfo = par->matchinfo;
 
 	if (srhinfo->mt_flags & ~IP6T_SRH_MASK) {
-		pr_err("unknown srh match flags  %X\n", srhinfo->mt_flags);
+		pr_info_ratelimited("unknown srh match flags  %X\n",
+				    srhinfo->mt_flags);
 		return -EINVAL;
 	}
 
 	if (srhinfo->mt_invflags & ~IP6T_SRH_INV_MASK) {
-		pr_err("unknown srh invflags %X\n", srhinfo->mt_invflags);
+		pr_info_ratelimited("unknown srh invflags %X\n",
+				    srhinfo->mt_invflags);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index c502419d6306..f368ee6741db 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -120,8 +120,8 @@ static int audit_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_audit_info *info = par->targinfo;
 
 	if (info->type > XT_AUDIT_TYPE_MAX) {
-		pr_info("Audit type out of range (valid range: 0..%hhu)\n",
-			XT_AUDIT_TYPE_MAX);
+		pr_info_ratelimited("Audit type out of range (valid range: 0..%hhu)\n",
+				    XT_AUDIT_TYPE_MAX);
 		return -ERANGE;
 	}
 
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_CHECKSUM.c
index ea3c5701fb0f..9f4151ec3e06 100644
--- a/net/netfilter/xt_CHECKSUM.c
+++ b/net/netfilter/xt_CHECKSUM.c
@@ -36,7 +36,8 @@ static int checksum_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_CHECKSUM_info *einfo = par->targinfo;
 
 	if (einfo->operation & ~XT_CHECKSUM_OP_FILL) {
-		pr_info("unsupported CHECKSUM operation %x\n", einfo->operation);
+		pr_info_ratelimited("unsupported CHECKSUM operation %x\n",
+				    einfo->operation);
 		return -EINVAL;
 	}
 	if (!einfo->operation)
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 6f30cd399e42..f3f1caac949b 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -102,14 +102,14 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 		break;
 
 	default:
-		pr_info("invalid mode: %hu\n", info->mode);
+		pr_info_ratelimited("invalid mode: %hu\n", info->mode);
 		return -EINVAL;
 	}
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 	return ret;
 }
 
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index ece311c11fdc..4472424e7ead 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -136,7 +136,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
 	if (err) {
-		pr_err("Trigger name is already in use.\n");
+		pr_info_ratelimited("Trigger name is already in use.\n");
 		goto exit_alloc;
 	}
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 5c5cd782fab5..4ad5fe27e08b 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -60,18 +60,20 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 				       &info->secid);
 	if (err) {
 		if (err == -EINVAL)
-			pr_info("invalid security context \'%s\'\n", info->secctx);
+			pr_info_ratelimited("invalid security context \'%s\'\n",
+					    info->secctx);
 		return err;
 	}
 
 	if (!info->secid) {
-		pr_info("unable to map security context \'%s\'\n", info->secctx);
+		pr_info_ratelimited("unable to map security context \'%s\'\n",
+				    info->secctx);
 		return -ENOENT;
 	}
 
 	err = security_secmark_relabel_packet(info->secid);
 	if (err) {
-		pr_info("unable to obtain relabeling permission\n");
+		pr_info_ratelimited("unable to obtain relabeling permission\n");
 		return err;
 	}
 
@@ -92,8 +94,8 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 	}
 
 	if (mode && mode != info->mode) {
-		pr_info("mode already set to %hu cannot mix with "
-			"rules for mode %hu\n", mode, info->mode);
+		pr_info_ratelimited("mode already set to %hu cannot mix with rules for mode %hu\n",
+				    mode, info->mode);
 		return -EINVAL;
 	}
 
@@ -101,7 +103,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 	case SECMARK_MODE_SEL:
 		break;
 	default:
-		pr_info("invalid mode: %hu\n", info->mode);
+		pr_info_ratelimited("invalid mode: %hu\n", info->mode);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 99bb8e410f22..98efb202f8b4 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -273,8 +273,7 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info("path-MTU clamping only supported in "
-			"FORWARD, OUTPUT and POSTROUTING hooks\n");
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
 	if (par->nft_compat)
@@ -283,7 +282,7 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
-	pr_info("Only works on TCP SYN packets\n");
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
 	return -EINVAL;
 }
 
@@ -298,8 +297,7 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info("path-MTU clamping only supported in "
-			"FORWARD, OUTPUT and POSTROUTING hooks\n");
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
 	if (par->nft_compat)
@@ -308,7 +306,7 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
-	pr_info("Only works on TCP SYN packets\n");
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
 	return -EINVAL;
 }
 #endif
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 17d7705e3bd4..8c89323c06af 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -540,8 +540,7 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
 
-	pr_info("Can be used only in combination with "
-		"either -p tcp or -p udp\n");
+	pr_info_ratelimited("Can be used only with -p tcp or -p udp\n");
 	return -EINVAL;
 }
 #endif
@@ -559,8 +558,7 @@ static int tproxy_tg4_check(const struct xt_tgchk_param *par)
 	    && !(i->invflags & IPT_INV_PROTO))
 		return 0;
 
-	pr_info("Can be used only in combination with "
-		"either -p tcp or -p udp\n");
+	pr_info_ratelimited("Can be used only with -p tcp or -p udp\n");
 	return -EINVAL;
 }
 
diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index 06b090d8e901..a2cf8a6236d6 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -7,6 +7,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/skbuff.h>
@@ -34,7 +36,7 @@ static int __bpf_mt_check_bytecode(struct sock_filter *insns, __u16 len,
 	program.filter = insns;
 
 	if (bpf_prog_create(ret, &program)) {
-		pr_info("bpf: check failed: parse error\n");
+		pr_info_ratelimited("check failed: parse error\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 891f4e7e8ea7..7df2dece57d3 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -12,6 +12,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/skbuff.h>
 #include <linux/module.h>
 #include <linux/netfilter/x_tables.h>
@@ -48,7 +50,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_path && info->has_classid) {
-		pr_info("xt_cgroup: both path and classid specified\n");
+		pr_info_ratelimited("path and classid specified\n");
 		return -EINVAL;
 	}
 
@@ -56,8 +58,8 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
-			pr_info("xt_cgroup: invalid path, errno=%ld\n",
-				PTR_ERR(cgrp));
+			pr_info_ratelimited("invalid path, errno=%ld\n",
+					    PTR_ERR(cgrp));
 			return -EINVAL;
 		}
 		info->priv = cgrp;
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 57ef175dfbfa..0068688995c8 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -135,14 +135,12 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 	struct xt_cluster_match_info *info = par->matchinfo;
 
 	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
-		pr_info("you have exceeded the maximum "
-			"number of cluster nodes (%u > %u)\n",
-			info->total_nodes, XT_CLUSTER_NODES_MAX);
+		pr_info_ratelimited("you have exceeded the maximum number of cluster nodes (%u > %u)\n",
+				    info->total_nodes, XT_CLUSTER_NODES_MAX);
 		return -EINVAL;
 	}
 	if (info->node_mask >= (1ULL << info->total_nodes)) {
-		pr_info("this node mask cannot be "
-			"higher than the total number of nodes\n");
+		pr_info_ratelimited("node mask cannot exceed total number of nodes\n");
 		return -EDOM;
 	}
 	return 0;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index cad0b7b5eb35..93cb018c3055 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -112,8 +112,8 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 
 	/*
 	 * This filter cannot function correctly unless connection tracking
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 23372879e6e3..4fa4efd24353 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -57,14 +57,15 @@ static int connlabel_mt_check(const struct xt_mtchk_param *par)
 	int ret;
 
 	if (info->options & ~options) {
-		pr_err("Unknown options in mask %x\n", info->options);
+		pr_info_ratelimited("Unknown options in mask %x\n",
+				    info->options);
 		return -EINVAL;
 	}
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0) {
-		pr_info("cannot load conntrack support for proto=%u\n",
-							par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 		return ret;
 	}
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index ec377cc6a369..809639ce6f5a 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -79,8 +79,8 @@ static int connmark_tg_check(const struct xt_tgchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 	return ret;
 }
 
@@ -109,8 +109,8 @@ static int connmark_mt_check(const struct xt_mtchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 	return ret;
 }
 
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 39cf1d019240..df80fe7d391c 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -272,8 +272,8 @@ static int conntrack_mt_check(const struct xt_mtchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 	return ret;
 }
 
diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index 3c831a8efebc..c7ad4afa5fb8 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -97,7 +97,7 @@ static int ecn_mt_check4(const struct xt_mtchk_param *par)
 
 	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
 	    (ip->proto != IPPROTO_TCP || ip->invflags & IPT_INV_PROTO)) {
-		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
+		pr_info_ratelimited("cannot match TCP bits for non-tcp packets\n");
 		return -EINVAL;
 	}
 
@@ -139,7 +139,7 @@ static int ecn_mt_check6(const struct xt_mtchk_param *par)
 
 	if (info->operation & (XT_ECN_OP_MATCH_ECE | XT_ECN_OP_MATCH_CWR) &&
 	    (ip->proto != IPPROTO_TCP || ip->invflags & IP6T_INV_PROTO)) {
-		pr_info("cannot match TCP bits in rule for non-tcp packets\n");
+		pr_info_ratelimited("cannot match TCP bits for non-tcp packets\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index ca6847403ca2..aa96027f4418 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -523,7 +523,8 @@ static u64 user2rate(u64 user)
 	if (user != 0) {
 		return div64_u64(XT_HASHLIMIT_SCALE_v2, user);
 	} else {
-		pr_warn("invalid rate from userspace: %llu\n", user);
+		pr_info_ratelimited("invalid rate from userspace: %llu\n",
+				    user);
 		return 0;
 	}
 }
@@ -865,33 +866,34 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 	}
 
 	if (cfg->mode & ~XT_HASHLIMIT_ALL) {
-		pr_info("Unknown mode mask %X, kernel too old?\n",
-						cfg->mode);
+		pr_info_ratelimited("Unknown mode mask %X, kernel too old?\n",
+				    cfg->mode);
 		return -EINVAL;
 	}
 
 	/* Check for overflow. */
 	if (revision >= 3 && cfg->mode & XT_HASHLIMIT_RATE_MATCH) {
 		if (cfg->avg == 0 || cfg->avg > U32_MAX) {
-			pr_info("hashlimit invalid rate\n");
+			pr_info_ratelimited("invalid rate\n");
 			return -ERANGE;
 		}
 
 		if (cfg->interval == 0) {
-			pr_info("hashlimit invalid interval\n");
+			pr_info_ratelimited("invalid interval\n");
 			return -EINVAL;
 		}
 	} else if (cfg->mode & XT_HASHLIMIT_BYTES) {
 		if (user2credits_byte(cfg->avg) == 0) {
-			pr_info("overflow, rate too high: %llu\n", cfg->avg);
+			pr_info_ratelimited("overflow, rate too high: %llu\n",
+					    cfg->avg);
 			return -EINVAL;
 		}
 	} else if (cfg->burst == 0 ||
-		    user2credits(cfg->avg * cfg->burst, revision) <
-		    user2credits(cfg->avg, revision)) {
-			pr_info("overflow, try lower: %llu/%llu\n",
-				cfg->avg, cfg->burst);
-			return -ERANGE;
+		   user2credits(cfg->avg * cfg->burst, revision) <
+		   user2credits(cfg->avg, revision)) {
+		pr_info_ratelimited("overflow, try lower: %llu/%llu\n",
+				    cfg->avg, cfg->burst);
+		return -ERANGE;
 	}
 
 	mutex_lock(&hashlimit_mutex);
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 38a78151c0e9..fd077aeaaed9 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -61,8 +61,8 @@ static int helper_mt_check(const struct xt_mtchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0) {
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 		return ret;
 	}
 	info->name[sizeof(info->name) - 1] = '\0';
diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 7ca64a50db04..57f1df575701 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -72,7 +72,7 @@ static int comp_mt_check(const struct xt_mtchk_param *par)
 
 	/* Must specify no unknown invflags */
 	if (compinfo->invflags & ~XT_IPCOMP_INV_MASK) {
-		pr_err("unknown flags %X\n", compinfo->invflags);
+		pr_info_ratelimited("unknown flags %X\n", compinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 42540d26c2b8..1d950a6100af 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -158,7 +158,8 @@ static int ipvs_mt_check(const struct xt_mtchk_param *par)
 	    && par->family != NFPROTO_IPV6
 #endif
 		) {
-		pr_info("protocol family %u not supported\n", par->family);
+		pr_info_ratelimited("protocol family %u not supported\n",
+				    par->family);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
index 8aee572771f2..c43482bf48e6 100644
--- a/net/netfilter/xt_l2tp.c
+++ b/net/netfilter/xt_l2tp.c
@@ -216,7 +216,7 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 	/* Check for invalid flags */
 	if (info->flags & ~(XT_L2TP_TID | XT_L2TP_SID | XT_L2TP_VERSION |
 			    XT_L2TP_TYPE)) {
-		pr_info("unknown flags: %x\n", info->flags);
+		pr_info_ratelimited("unknown flags: %x\n", info->flags);
 		return -EINVAL;
 	}
 
@@ -225,7 +225,8 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 	    (!(info->flags & XT_L2TP_SID)) &&
 	    ((!(info->flags & XT_L2TP_TYPE)) ||
 	     (info->type != XT_L2TP_TYPE_CONTROL))) {
-		pr_info("invalid flags combination: %x\n", info->flags);
+		pr_info_ratelimited("invalid flags combination: %x\n",
+				    info->flags);
 		return -EINVAL;
 	}
 
@@ -234,19 +235,22 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 	 */
 	if (info->flags & XT_L2TP_VERSION) {
 		if ((info->version < 2) || (info->version > 3)) {
-			pr_info("wrong L2TP version: %u\n", info->version);
+			pr_info_ratelimited("wrong L2TP version: %u\n",
+					    info->version);
 			return -EINVAL;
 		}
 
 		if (info->version == 2) {
 			if ((info->flags & XT_L2TP_TID) &&
 			    (info->tid > 0xffff)) {
-				pr_info("v2 tid > 0xffff: %u\n", info->tid);
+				pr_info_ratelimited("v2 tid > 0xffff: %u\n",
+						    info->tid);
 				return -EINVAL;
 			}
 			if ((info->flags & XT_L2TP_SID) &&
 			    (info->sid > 0xffff)) {
-				pr_info("v2 sid > 0xffff: %u\n", info->sid);
+				pr_info_ratelimited("v2 sid > 0xffff: %u\n",
+						    info->sid);
 				return -EINVAL;
 			}
 		}
@@ -268,13 +272,13 @@ static int l2tp_mt_check4(const struct xt_mtchk_param *par)
 
 	if ((ip->proto != IPPROTO_UDP) &&
 	    (ip->proto != IPPROTO_L2TP)) {
-		pr_info("missing protocol rule (udp|l2tpip)\n");
+		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
 
 	if ((ip->proto == IPPROTO_L2TP) &&
 	    (info->version == 2)) {
-		pr_info("v2 doesn't support IP mode\n");
+		pr_info_ratelimited("v2 doesn't support IP mode\n");
 		return -EINVAL;
 	}
 
@@ -295,13 +299,13 @@ static int l2tp_mt_check6(const struct xt_mtchk_param *par)
 
 	if ((ip->proto != IPPROTO_UDP) &&
 	    (ip->proto != IPPROTO_L2TP)) {
-		pr_info("missing protocol rule (udp|l2tpip)\n");
+		pr_info_ratelimited("missing protocol rule (udp|l2tpip)\n");
 		return -EINVAL;
 	}
 
 	if ((ip->proto == IPPROTO_L2TP) &&
 	    (info->version == 2)) {
-		pr_info("v2 doesn't support IP mode\n");
+		pr_info_ratelimited("v2 doesn't support IP mode\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 61403b77361c..55d18cd67635 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -106,8 +106,8 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 	/* Check for overflow. */
 	if (r->burst == 0
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
-		pr_info("Overflow, try lower: %u/%u\n",
-			r->avg, r->burst);
+		pr_info_ratelimited("Overflow, try lower: %u/%u\n",
+				    r->avg, r->burst);
 		return -ERANGE;
 	}
 
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index 0fd14d1eb09d..bdb689cdc829 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
@@ -19,8 +21,7 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 
 	if (mr->rangesize != 1) {
-		pr_info("%s: multiple ranges no longer supported\n",
-			par->target->name);
+		pr_info_ratelimited("multiple ranges no longer supported\n");
 		return -EINVAL;
 	}
 	return nf_ct_netns_get(par->net, par->family);
diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index 6f92d25590a8..c8674deed4eb 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -6,6 +6,8 @@
  * it under the terms of the GNU General Public License version 2 (or any
  * later at your option) as published by the Free Software Foundation.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 
@@ -39,8 +41,8 @@ nfacct_mt_checkentry(const struct xt_mtchk_param *par)
 
 	nfacct = nfnl_acct_find_get(par->net, info->name);
 	if (nfacct == NULL) {
-		pr_info("xt_nfacct: accounting object with name `%s' "
-			"does not exists\n", info->name);
+		pr_info_ratelimited("accounting object `%s' does not exists\n",
+				    info->name);
 		return -ENOENT;
 	}
 	info->nfacct = nfacct;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index bb33598e4530..9d6d67b953ac 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -107,9 +107,7 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
 	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
 	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
-		pr_info("using --physdev-out and --physdev-is-out are only "
-			"supported in the FORWARD and POSTROUTING chains with "
-			"bridged traffic.\n");
+		pr_info_ratelimited("--physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic\n");
 		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
 			return -EINVAL;
 	}
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 245fa350a7a8..6d232d18faff 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -342,8 +342,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	net_get_random_once(&hash_rnd, sizeof(hash_rnd));
 
 	if (info->check_set & ~XT_RECENT_VALID_FLAGS) {
-		pr_info("Unsupported user space flags (%08x)\n",
-			info->check_set);
+		pr_info_ratelimited("Unsupported userspace flags (%08x)\n",
+				    info->check_set);
 		return -EINVAL;
 	}
 	if (hweight8(info->check_set &
@@ -357,8 +357,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	if ((info->check_set & XT_RECENT_REAP) && !info->seconds)
 		return -EINVAL;
 	if (info->hit_count >= XT_RECENT_MAX_NSTAMPS) {
-		pr_info("hitcount (%u) is larger than allowed maximum (%u)\n",
-			info->hit_count, XT_RECENT_MAX_NSTAMPS - 1);
+		pr_info_ratelimited("hitcount (%u) is larger than allowed maximum (%u)\n",
+				    info->hit_count, XT_RECENT_MAX_NSTAMPS - 1);
 		return -EINVAL;
 	}
 	if (info->name[0] == '\0' ||
@@ -587,7 +587,7 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 		add = true;
 		break;
 	default:
-		pr_info("Need \"+ip\", \"-ip\" or \"/\"\n");
+		pr_info_ratelimited("Need \"+ip\", \"-ip\" or \"/\"\n");
 		return -EINVAL;
 	}
 
@@ -601,10 +601,8 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 		succ   = in4_pton(c, size, (void *)&addr, '\n', NULL);
 	}
 
-	if (!succ) {
-		pr_info("illegal address written to procfs\n");
+	if (!succ)
 		return -EINVAL;
-	}
 
 	spin_lock_bh(&recent_lock);
 	e = recent_entry_lookup(t, &addr, family, 0);
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 575d2153e3b8..2ac7f674d19b 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -171,7 +171,8 @@ static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V1) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
+		pr_info_ratelimited("unknown flags 0x%x\n",
+				    info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
 	return 0;
@@ -187,7 +188,8 @@ static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V2) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
+		pr_info_ratelimited("unknown flags 0x%x\n",
+				    info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
 	return 0;
@@ -203,8 +205,8 @@ static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 	if (err)
 		return err;
 	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
-		pr_info("unknown flags 0x%x\n",
-			info->flags & ~XT_SOCKET_FLAGS_V3);
+		pr_info_ratelimited("unknown flags 0x%x\n",
+				    info->flags & ~XT_SOCKET_FLAGS_V3);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 5fbd79194d21..0b41c0befe3c 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -44,8 +44,8 @@ static int state_mt_check(const struct xt_mtchk_param *par)
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0)
-		pr_info("cannot load conntrack support for proto=%u\n",
-			par->family);
+		pr_info_ratelimited("cannot load conntrack support for proto=%u\n",
+				    par->family);
 	return ret;
 }
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 1b01eec1fbda..0160f505e337 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -235,13 +235,13 @@ static int time_mt_check(const struct xt_mtchk_param *par)
 
 	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
 	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
-		pr_info("invalid argument - start or "
-			"stop time greater than 23:59:59\n");
+		pr_info_ratelimited("invalid argument - start or stop time greater than 23:59:59\n");
 		return -EDOM;
 	}
 
 	if (info->flags & ~XT_TIME_ALL_FLAGS) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_TIME_ALL_FLAGS);
+		pr_info_ratelimited("unknown flags 0x%x\n",
+				    info->flags & ~XT_TIME_ALL_FLAGS);
 		return -EINVAL;
 	}
 
-- 
2.13.6

