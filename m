From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/7] netfilter: x_tables: prefer pr_debug where possible
Date: Wed,  7 Feb 2018 14:48:23 +0100
Message-ID: <20180207134828.18691-3-fw@strlen.de>
References: <20180207134828.18691-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38818 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754258AbeBGNtv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:49:51 -0500
In-Reply-To: <20180207134828.18691-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

prefer pr_debug for cases where error is usually not seen by users.
checkpatch complains due to lines > 80 but adding a newline doesn't
make things any more readable.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 2 +-
 net/ipv6/netfilter/ip6t_rpfilter.c | 2 +-
 net/netfilter/xt_SECMARK.c         | 2 +-
 net/netfilter/xt_bpf.c             | 2 +-
 net/netfilter/xt_connlabel.c       | 2 +-
 net/netfilter/xt_ipcomp.c          | 2 +-
 net/netfilter/xt_ipvs.c            | 2 +-
 net/netfilter/xt_l2tp.c            | 2 +-
 net/netfilter/xt_recent.c          | 4 ++--
 net/netfilter/xt_socket.c          | 8 ++++----
 net/netfilter/xt_time.c            | 2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 37fb9552e858..ffd1cf65af3a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -105,7 +105,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 	const struct xt_rpfilter_info *info = par->matchinfo;
 	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
 	if (info->flags & options) {
-		pr_info("unknown options encountered");
+		pr_debug("unknown options");
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index b12e61b7b16c..c9e27d4687a2 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -103,7 +103,7 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 	unsigned int options = ~XT_RPFILTER_OPTION_MASK;
 
 	if (info->flags & options) {
-		pr_info("unknown options encountered");
+		pr_debug("unknown options");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 9faf5e050b79..36f7ad881a7e 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -101,7 +101,7 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 	case SECMARK_MODE_SEL:
 		break;
 	default:
-		pr_info("invalid mode: %hu\n", info->mode);
+		pr_debug("invalid mode: %hu\n", info->mode);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index 06b090d8e901..77a12ef9e11e 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -34,7 +34,7 @@ static int __bpf_mt_check_bytecode(struct sock_filter *insns, __u16 len,
 	program.filter = insns;
 
 	if (bpf_prog_create(ret, &program)) {
-		pr_info("bpf: check failed: parse error\n");
+		pr_debug("bpf: check failed: parse error\n");
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 23372879e6e3..cf3031e4ff61 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -57,7 +57,7 @@ static int connlabel_mt_check(const struct xt_mtchk_param *par)
 	int ret;
 
 	if (info->options & ~options) {
-		pr_err("Unknown options in mask %x\n", info->options);
+		pr_debug("Unknown options in mask %x\n", info->options);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_ipcomp.c b/net/netfilter/xt_ipcomp.c
index 7ca64a50db04..1ecde0efe879 100644
--- a/net/netfilter/xt_ipcomp.c
+++ b/net/netfilter/xt_ipcomp.c
@@ -72,7 +72,7 @@ static int comp_mt_check(const struct xt_mtchk_param *par)
 
 	/* Must specify no unknown invflags */
 	if (compinfo->invflags & ~XT_IPCOMP_INV_MASK) {
-		pr_err("unknown flags %X\n", compinfo->invflags);
+		pr_debug("unknown flags %X\n", compinfo->invflags);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index 42540d26c2b8..e5ffc2f1424c 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -158,7 +158,7 @@ static int ipvs_mt_check(const struct xt_mtchk_param *par)
 	    && par->family != NFPROTO_IPV6
 #endif
 		) {
-		pr_info("protocol family %u not supported\n", par->family);
+		pr_debug("protocol family %u not supported\n", par->family);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
index 8aee572771f2..54ac58b309e5 100644
--- a/net/netfilter/xt_l2tp.c
+++ b/net/netfilter/xt_l2tp.c
@@ -216,7 +216,7 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 	/* Check for invalid flags */
 	if (info->flags & ~(XT_L2TP_TID | XT_L2TP_SID | XT_L2TP_VERSION |
 			    XT_L2TP_TYPE)) {
-		pr_info("unknown flags: %x\n", info->flags);
+		pr_debug("unknown flags: %x\n", info->flags);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 245fa350a7a8..db6a2d43bb30 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -342,8 +342,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	net_get_random_once(&hash_rnd, sizeof(hash_rnd));
 
 	if (info->check_set & ~XT_RECENT_VALID_FLAGS) {
-		pr_info("Unsupported user space flags (%08x)\n",
-			info->check_set);
+		pr_debug("Unsupported userspace flags (%08x)\n",
+			 info->check_set);
 		return -EINVAL;
 	}
 	if (hweight8(info->check_set &
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 575d2153e3b8..5a0b16bc29c8 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -171,7 +171,7 @@ static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V1) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
+		pr_debug("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
 	return 0;
@@ -187,7 +187,7 @@ static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V2) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
+		pr_debug("unknown flags 0x%x\n", info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
 	return 0;
@@ -203,8 +203,8 @@ static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 	if (err)
 		return err;
 	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
-		pr_info("unknown flags 0x%x\n",
-			info->flags & ~XT_SOCKET_FLAGS_V3);
+		pr_debug("unknown flags 0x%x\n",
+			 info->flags & ~XT_SOCKET_FLAGS_V3);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 1b01eec1fbda..aea2b5a12ed7 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -241,7 +241,7 @@ static int time_mt_check(const struct xt_mtchk_param *par)
 	}
 
 	if (info->flags & ~XT_TIME_ALL_FLAGS) {
-		pr_info("unknown flags 0x%x\n", info->flags & ~XT_TIME_ALL_FLAGS);
+		pr_debug("unknown flags 0x%x\n", info->flags & ~XT_TIME_ALL_FLAGS);
 		return -EINVAL;
 	}
 
-- 
2.13.6

