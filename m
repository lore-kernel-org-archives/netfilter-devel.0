From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/38]: Annotate start of kernel fields in NF headers
Date: Tue, 15 Jan 2008 07:19:20 +0100 (MET)
Message-ID: <20080115061915.3184.82204.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYAOGTV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:21 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Annotate start of kernel fields in NF headers

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cf9efd38322201c52e424d16a304ce9970697f8f
tree fa34f1a03d9dc898c7e446b7a74ea02c616b4d5f
parent 89efd08437074cc2005dc258622866efa187c46a
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:21 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:24 +0100

 include/linux/netfilter/xt_RATEEST.h         |    2 ++
 include/linux/netfilter/xt_connlimit.h       |    2 +-
 include/linux/netfilter/xt_hashlimit.h       |    2 +-
 include/linux/netfilter/xt_quota.h           |    2 ++
 include/linux/netfilter/xt_rateest.h         |    2 ++
 include/linux/netfilter/xt_statistic.h       |    1 +
 include/linux/netfilter/xt_string.h          |    2 ++
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |    1 +
 8 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index 670f2e4..f79e313 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -5,6 +5,8 @@ struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
 	int8_t			interval;
 	u_int8_t		ewma_log;
+
+	/* Used internally by the kernel */
 	struct xt_rateest	*est __attribute__((aligned(8)));
 };
 
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 315d2dc..7e3284b 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -15,7 +15,7 @@ struct xt_connlimit_info {
 	};
 	unsigned int limit, inverse;
 
-	/* this needs to be at the end */
+	/* Used internally by the kernel */
 	struct xt_connlimit_data *data __attribute__((aligned(8)));
 };
 
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index b4556b8..c19972e 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -29,9 +29,9 @@ struct hashlimit_cfg {
 struct xt_hashlimit_info {
 	char name [IFNAMSIZ];		/* name */
 	struct hashlimit_cfg cfg;
-	struct xt_hashlimit_htable *hinfo;
 
 	/* Used internally by the kernel */
+	struct xt_hashlimit_htable *hinfo;
 	union {
 		void *ptr;
 		struct xt_hashlimit_info *master;
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index acd7fd7..4c8368d 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -9,6 +9,8 @@ enum xt_quota_flags {
 struct xt_quota_info {
 	u_int32_t		flags;
 	u_int32_t		pad;
+
+	/* Used internally by the kernel */
 	aligned_u64		quota;
 	struct xt_quota_info	*master;
 };
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 51948e1..2010cb7 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -26,6 +26,8 @@ struct xt_rateest_match_info {
 	u_int32_t		pps1;
 	u_int32_t		bps2;
 	u_int32_t		pps2;
+
+	/* Used internally by the kernel */
 	struct xt_rateest	*est1 __attribute__((aligned(8)));
 	struct xt_rateest	*est2 __attribute__((aligned(8)));
 };
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index c344e99..3d38bc9 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -23,6 +23,7 @@ struct xt_statistic_info {
 		struct {
 			u_int32_t	every;
 			u_int32_t	packet;
+			/* Used internally by the kernel */
 			u_int32_t	count;
 		} nth;
 	} u;
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index 3b3419f..bb21dd1 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -12,6 +12,8 @@ struct xt_string_info
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
 	u_int8_t  patlen;
 	u_int8_t  invert;
+
+	/* Used internally by the kernel */
 	struct ts_config __attribute__((aligned(8))) *config;
 };
 
diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
index daf50be..e5a3687 100644
--- a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -27,6 +27,7 @@ struct ipt_clusterip_tgt_info {
 	u_int32_t hash_mode;
 	u_int32_t hash_initval;
 
+	/* Used internally by the kernel */
 	struct clusterip_config *config;
 };
 
