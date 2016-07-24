From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] src: introduce struct xt_xlate_{mt,tg}_params
Date: Sun, 24 Jul 2016 12:47:56 +0200
Message-ID: <1469357276-12051-1-git-send-email-pablo@netfilter.org>
Cc: pablombg@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60836 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbcGXKsJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Jul 2016 06:48:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DFCD1C5107
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:48:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0F609EBB7
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:48:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0C39C9EBB7
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Jul 2016 12:48:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This structure is an extensible containers of parameters, so we don't
need to propagate interface updates in every extension file in case
we need to add new parameters in the future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libip6t_DNAT.c       |  6 ++---
 extensions/libip6t_LOG.c        |  8 +++----
 extensions/libip6t_MASQUERADE.c |  7 +++---
 extensions/libip6t_REDIRECT.c   |  6 ++---
 extensions/libip6t_REJECT.c     |  6 ++---
 extensions/libip6t_SNAT.c       |  6 ++---
 extensions/libip6t_ah.c         |  6 ++---
 extensions/libip6t_frag.c       |  7 +++---
 extensions/libip6t_hbh.c        |  7 +++---
 extensions/libip6t_hl.c         | 19 ++++++++--------
 extensions/libip6t_icmp6.c      |  6 ++---
 extensions/libip6t_mh.c         |  6 ++---
 extensions/libip6t_rt.c         |  6 ++---
 extensions/libipt_DNAT.c        |  6 ++---
 extensions/libipt_LOG.c         |  8 +++----
 extensions/libipt_MASQUERADE.c  |  7 +++---
 extensions/libipt_REDIRECT.c    |  6 ++---
 extensions/libipt_REJECT.c      |  6 ++---
 extensions/libipt_SNAT.c        |  6 ++---
 extensions/libipt_ah.c          |  6 ++---
 extensions/libipt_icmp.c        |  6 ++---
 extensions/libipt_realm.c       |  6 ++---
 extensions/libipt_ttl.c         |  6 ++---
 extensions/libxt_CONNMARK.c     |  8 +++----
 extensions/libxt_MARK.c         | 12 +++++-----
 extensions/libxt_NFLOG.c        |  7 +++---
 extensions/libxt_NFQUEUE.c      | 27 ++++++++++-------------
 extensions/libxt_TEE.c          | 17 +++++++-------
 extensions/libxt_TRACE.c        |  4 ++--
 extensions/libxt_cgroup.c       | 12 +++++-----
 extensions/libxt_comment.c      |  7 +++---
 extensions/libxt_connlabel.c    |  8 +++----
 extensions/libxt_connmark.c     | 13 ++++++-----
 extensions/libxt_conntrack.c    | 29 ++++++++++++------------
 extensions/libxt_cpu.c          |  6 ++---
 extensions/libxt_dccp.c         |  8 +++----
 extensions/libxt_devgroup.c     |  6 ++---
 extensions/libxt_dscp.c         | 18 +++++++--------
 extensions/libxt_ecn.c          |  6 ++---
 extensions/libxt_esp.c          |  6 ++---
 extensions/libxt_helper.c       |  6 ++---
 extensions/libxt_ipcomp.c       |  7 +++---
 extensions/libxt_iprange.c      | 20 +++++++++--------
 extensions/libxt_length.c       |  6 ++---
 extensions/libxt_limit.c        |  6 ++---
 extensions/libxt_mac.c          |  6 ++---
 extensions/libxt_mark.c         | 14 +++++-------
 extensions/libxt_multiport.c    | 49 +++++++++++++++++++----------------------
 extensions/libxt_owner.c        |  6 ++---
 extensions/libxt_pkttype.c      |  6 ++---
 extensions/libxt_sctp.c         |  6 ++---
 extensions/libxt_tcp.c          |  7 +++---
 extensions/libxt_udp.c          |  6 ++---
 include/xtables.h               | 20 +++++++++++++----
 iptables/xtables-translate.c    | 20 ++++++++++++-----
 55 files changed, 278 insertions(+), 260 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 8bd6231..3925c3b 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -252,10 +252,10 @@ static void print_range_xlate(const struct nf_nat_range *range,
 	}
 }
 
-static int DNAT_xlate(const void *ip, const struct xt_entry_target *target,
-		      struct xt_xlate *xl, int numeric)
+static int DNAT_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range *range = (const void *)target->data;
+	const struct nf_nat_range *range = (const void *)params->target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 3c5075e..cf5f8df 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -182,12 +182,12 @@ static const struct ip6t_log_xlate ip6t_log_xlate_names[] = {
 	{"warn",        LOG_WARNING }
 };
 
-static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
-		     struct xt_xlate *xl, int numeric)
+static int LOG_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
 {
-	unsigned int i = 0;
 	const struct ip6t_log_info *loginfo =
-			(const struct ip6t_log_info *)target->data;
+		(const struct ip6t_log_info *)params->target->data;
+	unsigned int i = 0;
 
 	xt_xlate_add(xl, "log ");
 	if (strcmp(loginfo->prefix, "") != 0)
diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index 15ca141..3b59e43 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -131,11 +131,10 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --random");
 }
 
-static int
-MASQUERADE_xlate(const void *ip, const struct xt_entry_target *target,
-		 struct xt_xlate *xl, int numeric)
+static int MASQUERADE_xlate(struct xt_xlate *xl,
+			    const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range *r = (const void *)target->data;
+	const struct nf_nat_range *r = (const void *)params->target->data;
 
 	xt_xlate_add(xl, "masquerade");
 
diff --git a/extensions/libip6t_REDIRECT.c b/extensions/libip6t_REDIRECT.c
index 9c5f14c..32f85b9 100644
--- a/extensions/libip6t_REDIRECT.c
+++ b/extensions/libip6t_REDIRECT.c
@@ -132,10 +132,10 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static int REDIRECT_xlate(const void *ip, const struct xt_entry_target *target,
-			  struct xt_xlate *xl, int numeric)
+static int REDIRECT_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range *range = (const void *)target->data;
+	const struct nf_nat_range *range = (const void *)params->target->data;
 
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		xt_xlate_add(xl, "redirect to %hu",
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 5fa551e..c5b980d 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -139,11 +139,11 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 	{"reject-route",	IP6T_ICMP6_REJECT_ROUTE}
 };
 
-static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
-			struct xt_xlate *xl, int numeric)
+static int REJECT_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_tg_params *params)
 {
 	const struct ip6t_reject_info *reject =
-				(const struct ip6t_reject_info *)target->data;
+		(const struct ip6t_reject_info *)params->target->data;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index ab7713b..4d742ea 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -262,10 +262,10 @@ static void print_range_xlate(const struct nf_nat_range *range,
 	}
 }
 
-static int SNAT_xlate(const void *ip, const struct xt_entry_target *target,
-		      struct xt_xlate *xl, int numeric)
+static int SNAT_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range *range = (const void *)target->data;
+	const struct nf_nat_range *range = (const void *)params->target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 0bac313..5c2fe55 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -128,10 +128,10 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --ahres");
 }
 
-static int ah_xlate(const void *ip, const struct xt_entry_match *match,
-		    struct xt_xlate *xl, int numeric)
+static int ah_xlate(struct xt_xlate *xl,
+		    const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
+	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)params->match->data;
 	char *space = "";
 
 	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index e7a51d3..3842496 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -173,10 +173,11 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --fraglast");
 }
 
-static int frag_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int frag_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+	const struct ip6t_frag *fraginfo =
+		(struct ip6t_frag *)params->match->data;
 	char *space= "";
 
 	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index cb7e4e8..76b4ff0 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -164,10 +164,11 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 }
 
-static int hbh_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int hbh_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
+	const struct ip6t_opts *optinfo =
+		(struct ip6t_opts *)params->match->data;
 
 	if (!(optinfo->flags & IP6T_OPTS_LEN) ||
 	    (optinfo->flags & IP6T_OPTS_OPTS))
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 50b47f4..37922f6 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -83,17 +83,18 @@ static void hl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %s %u", op[info->mode], info->hop_limit);
 }
 
-static int hl_xlate(const void *ip, const struct xt_entry_match *match,
-		    struct xt_xlate *xl, int numeric)
-{
-	static const char *const op[] = {
-		[IP6T_HL_EQ] = "",
-		[IP6T_HL_NE] = "!= ",
-		[IP6T_HL_LT] = "lt ",
-		[IP6T_HL_GT] = "gt " };
+static const char *const op[] = {
+	[IP6T_HL_EQ] = "",
+	[IP6T_HL_NE] = "!= ",
+	[IP6T_HL_LT] = "lt ",
+	[IP6T_HL_GT] = "gt "
+};
 
+static int hl_xlate(struct xt_xlate *xl,
+		    const struct xt_xlate_mt_params *params)
+{
 	const struct ip6t_hl_info *info =
-		(struct ip6t_hl_info *) match->data;
+		(struct ip6t_hl_info *) params->match->data;
 
 	xt_xlate_add(xl, "ip6 hoplimit %s%u", op[info->mode], info->hop_limit);
 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index ddb1673..b49a241 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -271,10 +271,10 @@ static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
 	return 1;
 }
 
-static int icmp6_xlate(const void *ip, const struct xt_entry_match *match,
-		       struct xt_xlate *xl, int numeric)
+static int icmp6_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
+	const struct ip6t_icmp *info = (struct ip6t_icmp *)params->match->data;
 
 	xt_xlate_add(xl, "icmpv6 type%s ",
 		     (info->invflags & IP6T_ICMP_INV) ? " !=" : "");
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 4cf20c2..f4c0fd9 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -202,10 +202,10 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --mh-type %u", mhinfo->types[0]);
 }
 
-static int mh_xlate(const void *ip, const struct xt_entry_match *match,
-		    struct xt_xlate *xl, int numeric)
+static int mh_xlate(struct xt_xlate *xl,
+		    const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)params->match->data;
 
 	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xff)
 		return 1;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 81e222e..3cb3b24 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -245,10 +245,10 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int rt_xlate(const void *ip, const struct xt_entry_match *match,
-		    struct xt_xlate *xl, int numeric)
+static int rt_xlate(struct xt_xlate *xl,
+		    const struct xt_xlate_mt_params *params)
 {
-	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
+	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)params->match->data;
 	char *space = "";
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 79f5024..c463f07 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -262,10 +262,10 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 	}
 }
 
-static int DNAT_xlate(const void *ip, const struct xt_entry_target *target,
-		      struct xt_xlate *xl, int numeric)
+static int DNAT_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)target;
+	const struct ipt_natinfo *info = (const void *)params->target->data;
 	unsigned int i = 0;
 	bool sep_need = false;
 	const char *sep = " ";
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index f81eb8d..996dfb6 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -182,12 +182,12 @@ static const struct ipt_log_xlate ipt_log_xlate_names[] = {
 	{"warn",	LOG_WARNING }
 };
 
-static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
-		     struct xt_xlate *xl, int numeric)
+static int LOG_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params)
 {
-	unsigned int i = 0;
 	const struct ipt_log_info *loginfo =
-			(const struct ipt_log_info *)target->data;
+		(const struct ipt_log_info *)params->target->data;
+	unsigned int i = 0;
 
 	xt_xlate_add(xl, "log ");
 	if (strcmp(loginfo->prefix, "") != 0)
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 2d11fa9..b7b5fc7 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -134,12 +134,11 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --random");
 }
 
-static int
-MASQUERADE_xlate(const void *ip, const struct xt_entry_target *target,
-		 struct xt_xlate *xl, int numeric)
+static int MASQUERADE_xlate(struct xt_xlate *xl,
+			    const struct xt_xlate_tg_params *params)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =
-					(const void *)target->data;
+		(const void *)params->target->data;
 	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
 	xt_xlate_add(xl, "masquerade");
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 1ffb3dd..31ca88c 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -135,11 +135,11 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static int REDIRECT_xlate(const void *ip, const struct xt_entry_target *target,
-			  struct xt_xlate *xl, int numeric)
+static int REDIRECT_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_tg_params *params)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =
-					(const void *)target->data;
+		(const void *)params->target->data;
 	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index c211da9..ba815ba 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -159,11 +159,11 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 	{"admin-prohibited",	IPT_ICMP_ADMIN_PROHIBITED}
 };
 
-static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
-			struct xt_xlate *xl, int numeric)
+static int REJECT_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_tg_params *params)
 {
 	const struct ipt_reject_info *reject =
-		(const struct ipt_reject_info *)target->data;
+		(const struct ipt_reject_info *)params->target->data;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i) {
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 6613316..71717fd 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -273,10 +273,10 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 	}
 }
 
-static int SNAT_xlate(const void *ip, const struct xt_entry_target *target,
-		      struct xt_xlate *xl, int numeric)
+static int SNAT_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)target;
+	const struct ipt_natinfo *info = (const void *)params->target->data;
 	unsigned int i = 0;
 	bool sep_need = false;
 	const char *sep = " ";
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 7dff93d..fec5705 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -92,10 +92,10 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int ah_xlate(const void *ip, const struct xt_entry_match *match,
-		    struct xt_xlate *xl, int numeric)
+static int ah_xlate(struct xt_xlate *xl,
+		    const struct xt_xlate_mt_params *params)
 {
-	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
+	const struct ipt_ah *ahinfo = (struct ipt_ah *)params->match->data;
 
 	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "ah spi%s ",
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 342659e..680a5b0 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -268,10 +268,10 @@ static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
 	return 0;
 }
 
-static int icmp_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int icmp_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
-	const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
+	const struct ipt_icmp *info = (struct ipt_icmp *)params->match->data;
 
 	if (info->type != 0xFF) {
 		xt_xlate_add(xl, "icmp type%s ",
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index b5c9032..fd0622a 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -129,10 +129,10 @@ print_realm_xlate(unsigned long id, unsigned long mask,
 	}
 }
 
-static int realm_xlate(const void *ip, const struct xt_entry_match *match,
-		       struct xt_xlate *xl, int numeric)
+static int realm_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
 {
-	const struct xt_realm_info *ri = (const void *)match->data;
+	const struct xt_realm_info *ri = (const void *)params->match->data;
 	enum xt_op op = XT_OP_EQ;
 
 	if (ri->invert)
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index e1db0df..6bdd219 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -100,11 +100,11 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %u", info->ttl);
 }
 
-static int ttl_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int ttl_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
 	const struct ipt_ttl_info *info =
-			(struct ipt_ttl_info *) match->data;
+		(struct ipt_ttl_info *) params->match->data;
 
 		switch (info->mode) {
 		case IPT_TTL_EQ:
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 358facf..f60be58 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -347,11 +347,11 @@ connmark_tg_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static int
-connmark_tg_xlate(const void *ip, const struct xt_entry_target *target,
-		  struct xt_xlate *xl, int numeric)
+static int connmark_tg_xlate(struct xt_xlate *xl,
+			     const struct xt_xlate_tg_params *params)
 {
-	const struct xt_connmark_tginfo1 *info = (const void *)target->data;
+	const struct xt_connmark_tginfo1 *info =
+		(const void *)params->target->data;
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index c7b1794..c2f15e3 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -245,10 +245,10 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
 }
 
-static int mark_tg_xlate(const void *ip, const struct xt_entry_target *target,
-			 struct xt_xlate *xl, int numeric)
+static int mark_tg_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_tg_params *params)
 {
-	const struct xt_mark_tginfo2 *info = (const void *)target->data;
+	const struct xt_mark_tginfo2 *info = (const void *)params->target->data;
 
 	xt_xlate_add(xl, "meta mark set ");
 
@@ -267,11 +267,11 @@ static int mark_tg_xlate(const void *ip, const struct xt_entry_target *target,
 	return 1;
 }
 
-static int MARK_xlate(const void *ip, const struct xt_entry_target *target,
-			 struct xt_xlate *xl, int numeric)
+static int MARK_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_tg_params *params)
 {
 	const struct xt_mark_target_info_v1 *markinfo =
-		(const struct xt_mark_target_info_v1 *)target->data;
+		(const struct xt_mark_target_info_v1 *)params->target->data;
 
 	xt_xlate_add(xl, "meta mark set ");
 
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index dad83f6..e6d627a 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -119,10 +119,11 @@ static void nflog_print_xlate(const struct xt_nflog_info *info,
 	xt_xlate_add(xl, "group %u ", info->group);
 }
 
-static int NFLOG_xlate(const void *ip, const struct xt_entry_target *target,
-		       struct xt_xlate *xl, int numeric)
+static int NFLOG_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_tg_params *params)
 {
-	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
+	const struct xt_nflog_info *info =
+		(struct xt_nflog_info *)params->target->data;
 
 	nflog_print_xlate(info, xl);
 
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index e8b81b6..fe51907 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -270,22 +270,21 @@ static void NFQUEUE_init_v1(struct xt_entry_target *t)
 	tinfo->queues_total = 1;
 }
 
-static int NFQUEUE_xlate(const void *ip, const struct xt_entry_target *target,
-			 struct xt_xlate *xl, int numeric)
+static int NFQUEUE_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_tg_params *params)
 {
 	const struct xt_NFQ_info *tinfo =
-		(const struct xt_NFQ_info *)target->data;
+		(const struct xt_NFQ_info *)params->target->data;
 
 	xt_xlate_add(xl, "queue num %u ", tinfo->queuenum);
 
 	return 1;
 }
 
-static int NFQUEUE_xlate_v1(const void *ip,
-			    const struct xt_entry_target *target,
-			    struct xt_xlate *xl, int numeric)
+static int NFQUEUE_xlate_v1(struct xt_xlate *xl,
+			    const struct xt_xlate_tg_params *params)
 {
-	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
+	const struct xt_NFQ_info_v1 *tinfo = (const void *)params->target->data;
 	unsigned int last = tinfo->queues_total;
 
 	if (last > 1) {
@@ -298,11 +297,10 @@ static int NFQUEUE_xlate_v1(const void *ip,
 	return 1;
 }
 
-static int NFQUEUE_xlate_v2(const void *ip,
-			    const struct xt_entry_target *target,
-			    struct xt_xlate *xl, int numeric)
+static int NFQUEUE_xlate_v2(struct xt_xlate *xl,
+			    const struct xt_xlate_tg_params *params)
 {
-	const struct xt_NFQ_info_v2 *info = (void *) target->data;
+	const struct xt_NFQ_info_v2 *info = (void *)params->target->data;
 	unsigned int last = info->queues_total;
 
 	if (last > 1) {
@@ -317,11 +315,10 @@ static int NFQUEUE_xlate_v2(const void *ip,
 	return 1;
 }
 
-static int NFQUEUE_xlate_v3(const void *ip,
-			    const struct xt_entry_target *target,
-			    struct xt_xlate *xl, int numeric)
+static int NFQUEUE_xlate_v3(struct xt_xlate *xl,
+			    const struct xt_xlate_tg_params *params)
 {
-	const struct xt_NFQ_info_v3 *info = (void *)target->data;
+	const struct xt_NFQ_info_v3 *info = (void *)params->target->data;
 	unsigned int last = info->queues_total;
 
 	if (last > 1) {
diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index 5044a34..4676e33 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -92,13 +92,12 @@ static void tee_tg6_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --oif %s", info->oif);
 }
 
-static int tee_tg_xlate(const void *ip, const struct xt_entry_target *target,
-			struct xt_xlate *xl, int numeric)
+static int tee_tg_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_tg_params *params)
 {
-	const struct xt_tee_tginfo *info =
-		(const void *)target->data;
+	const struct xt_tee_tginfo *info = (const void *)params->target->data;
 
-	if (numeric)
+	if (params->numeric)
 		xt_xlate_add(xl, "dup to %s",
 			     xtables_ipaddr_to_numeric(&info->gw.in));
 	else
@@ -110,12 +109,12 @@ static int tee_tg_xlate(const void *ip, const struct xt_entry_target *target,
 	return 1;
 }
 
-static int tee_tg6_xlate(const void *ip, const struct xt_entry_target *target,
-			 struct xt_xlate *xl, int numeric)
+static int tee_tg6_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_tg_params *params)
 {
-	const struct xt_tee_tginfo *info = (const void *)target->data;
+	const struct xt_tee_tginfo *info = (const void *)params->target->data;
 
-	if (numeric)
+	if (params->numeric)
 		xt_xlate_add(xl, "dup to %s",
 			     xtables_ip6addr_to_numeric(&info->gw.in6));
 	else
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 7cb3585..ac4f6fa 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -7,8 +7,8 @@
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
 
-static int trace_xlate(const void *ip, const struct xt_entry_target *target,
-		       struct xt_xlate *xl, int numeric)
+static int trace_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_tg_params *params)
 {
 	xt_xlate_add(xl, "nftrace set 1");
 	return 1;
diff --git a/extensions/libxt_cgroup.c b/extensions/libxt_cgroup.c
index fcd77c3..480d64c 100644
--- a/extensions/libxt_cgroup.c
+++ b/extensions/libxt_cgroup.c
@@ -121,20 +121,20 @@ static void cgroup_save_v1(const void *ip, const struct xt_entry_match *match)
 		       info->classid);
 }
 
-static int cgroup_xlate_v0(const void *ip, const struct xt_entry_match *match,
-			   struct xt_xlate *xl, int numeric)
+static int cgroup_xlate_v0(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
 {
-	const struct xt_cgroup_info_v0 *info = (void *)match->data;
+	const struct xt_cgroup_info_v0 *info = (void *)params->match->data;
 
 	xt_xlate_add(xl, "meta cgroup %s%u", info->invert ? "!= " : "",
 		     info->id);
 	return 1;
 }
 
-static int cgroup_xlate_v1(const void *ip, const struct xt_entry_match *match,
-			   struct xt_xlate *xl, int numeric)
+static int cgroup_xlate_v1(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
 {
-	const struct xt_cgroup_info_v1 *info = (void *)match->data;
+	const struct xt_cgroup_info_v1 *info = (void *)params->match->data;
 
 	if (info->has_path)
 		return 0;
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index ab229e0..0e31edd 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -48,11 +48,10 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(commentinfo->comment);
 }
 
-static int
-comment_xlate(const void *ip, const struct xt_entry_match *match,
-	      struct xt_xlate *xl, int numeric)
+static int comment_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_mt_params *params)
 {
-	struct xt_comment_info *commentinfo = (void *)match->data;
+	struct xt_comment_info *commentinfo = (void *)params->match->data;
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
 	xt_xlate_add_comment(xl, commentinfo->comment);
diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 7e4ff26..f685645 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -125,11 +125,11 @@ connlabel_mt_save(const void *ip, const struct xt_entry_match *match)
 	connlabel_mt_print_op(info, "--");
 }
 
-static int
-connlabel_mt_xlate(const void *ip, const struct xt_entry_match *match,
-		   struct xt_xlate *xl, int numeric)
+static int connlabel_mt_xlate(struct xt_xlate *xl,
+			      const struct xt_xlate_mt_params *params)
 {
-	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
+	const struct xt_connlabel_mtinfo *info =
+		(const void *)params->match->data;
 	const char *name = connlabel_get_name(info->bit);
 
 	if (name == NULL)
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 1630858..be3499b 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -134,10 +134,10 @@ static void print_mark_xlate(unsigned int mark, unsigned int mask,
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
-static int connmark_xlate(const void *ip, const struct xt_entry_match *match,
-			  struct xt_xlate *xl, int numeric)
+static int connmark_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_mt_params *params)
 {
-	const struct xt_connmark_info *info = (const void *)match->data;
+	const struct xt_connmark_info *info = (const void *)params->match->data;
 	enum xt_op op = XT_OP_EQ;
 
 	if (info->invert)
@@ -150,10 +150,11 @@ static int connmark_xlate(const void *ip, const struct xt_entry_match *match,
 }
 
 static int
-connmark_mt_xlate(const void *ip, const struct xt_entry_match *match,
-		  struct xt_xlate *xl, int numeric)
+connmark_mt_xlate(struct xt_xlate *xl,
+		  const struct xt_xlate_mt_params *params)
 {
-	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
+	const struct xt_connmark_mtinfo1 *info =
+		(const void *)params->match->data;
 	enum xt_op op = XT_OP_EQ;
 
 	if (info->invert)
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 4f3853c..72c5220 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1182,10 +1182,11 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 	}
 }
 
-static int state_xlate(const void *ip, const struct xt_entry_match *match,
-		       struct xt_xlate *xl, int numeric)
+static int state_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
 {
-	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
+	const struct xt_conntrack_mtinfo3 *sinfo =
+		(const void *)params->match->data;
 
 	xt_xlate_add(xl, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
 					"!= " : "");
@@ -1230,12 +1231,12 @@ static void addr_xlate_print(struct xt_xlate *xl,
 	}
 }
 
-static int _conntrack3_mt_xlate(const void *ip,
-				const struct xt_entry_match *match,
-				struct xt_xlate *xl, int numeric,
+static int _conntrack3_mt_xlate(struct xt_xlate *xl,
+				const struct xt_xlate_mt_params *params,
 				int family)
 {
-	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
+	const struct xt_conntrack_mtinfo3 *sinfo =
+		(const void *)params->match->data;
 	char *space = "";
 
 	if (sinfo->match_flags & XT_CONNTRACK_DIRECTION) {
@@ -1383,18 +1384,16 @@ static int _conntrack3_mt_xlate(const void *ip,
 	return 1;
 }
 
-static int conntrack3_mt4_xlate(const void *ip,
-				const struct xt_entry_match *match,
-				struct xt_xlate *xl, int numeric)
+static int conntrack3_mt4_xlate(struct xt_xlate *xl,
+				const struct xt_xlate_mt_params *params)
 {
-	return _conntrack3_mt_xlate(ip, match, xl, numeric, NFPROTO_IPV4);
+	return _conntrack3_mt_xlate(xl, params, NFPROTO_IPV4);
 }
 
-static int conntrack3_mt6_xlate(const void *ip,
-				const struct xt_entry_match *match,
-				struct xt_xlate *xl, int numeric)
+static int conntrack3_mt6_xlate(struct xt_xlate *xl,
+				const struct xt_xlate_mt_params *params)
 {
-	return _conntrack3_mt_xlate(ip, match, xl, numeric, NFPROTO_IPV6);
+	return _conntrack3_mt_xlate(xl, params, NFPROTO_IPV6);
 }
 
 static struct xtables_match conntrack_mt_reg[] = {
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 97927fa..41c13c3 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -44,10 +44,10 @@ static void cpu_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --cpu %u", info->invert ? " !" : "", info->cpu);
 }
 
-static int cpu_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int cpu_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_cpu_info *info = (void *)match->data;
+	const struct xt_cpu_info *info = (void *)params->match->data;
 
 	xt_xlate_add(xl, "cpu%s %u", info->invert ? " !=" : "", info->cpu);
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 179261f..5e67c26 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -327,13 +327,13 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	return 1;
 }
 
-static int dccp_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int dccp_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
 	const struct xt_dccp_info *einfo =
-			(const struct xt_dccp_info *)match->data;
-	int ret = 1;
+		(const struct xt_dccp_info *)params->match->data;
 	char *space = "";
+	int ret = 1;
 
 	xt_xlate_add(xl, "dccp ");
 
diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 41dae2f..d155680 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -195,10 +195,10 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 	}
 }
 
-static int devgroup_xlate(const void *ip, const struct xt_entry_match *match,
-			  struct xt_xlate *xl, int numeric)
+static int devgroup_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_mt_params *params)
 {
-	const struct xt_devgroup_info *info = (const void *)match->data;
+	const struct xt_devgroup_info *info = (const void *)params->match->data;
 
 	devgroup_show_xlate(info, xl, 0);
 
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 17433ef..d5c7323 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -91,11 +91,11 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --dscp 0x%02x", dinfo->invert ? " !" : "", dinfo->dscp);
 }
 
-static int __dscp_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int __dscp_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_mt_params *params)
 {
 	const struct xt_dscp_info *dinfo =
-		(const struct xt_dscp_info *)match->data;
+		(const struct xt_dscp_info *)params->match->data;
 
 	xt_xlate_add(xl, "dscp %s0x%02x", dinfo->invert ? "!= " : "",
 		     dinfo->dscp);
@@ -103,20 +103,20 @@ static int __dscp_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
-static int dscp_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int dscp_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
 	xt_xlate_add(xl, "ip ");
 
-	return __dscp_xlate(ip, match, xl, numeric);
+	return __dscp_xlate(xl, params);
 }
 
-static int dscp_xlate6(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int dscp_xlate6(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
 {
 	xt_xlate_add(xl, "ip6 ");
 
-	return __dscp_xlate(ip, match, xl, numeric);
+	return __dscp_xlate(xl, params);
 }
 
 static struct xtables_match dscp_mt_reg[] = {
diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
index 969920d..aeba01b 100644
--- a/extensions/libxt_ecn.c
+++ b/extensions/libxt_ecn.c
@@ -118,11 +118,11 @@ static void ecn_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int ecn_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int ecn_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
 	const struct xt_ecn_info *einfo =
-		(const struct xt_ecn_info *)match->data;
+		(const struct xt_ecn_info *)params->match->data;
 
 	if (!(einfo->operation & XT_ECN_OP_MATCH_IP))
 		return 0;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 5e8c58d..2c7ff94 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -86,10 +86,10 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int esp_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int esp_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
+	const struct xt_esp *espinfo = (struct xt_esp *)params->match->data;
 
 	if (!(espinfo->spis[0] == 0 && espinfo->spis[1] == 0xFFFFFFFF)) {
 		xt_xlate_add(xl, "esp spi%s",
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 26e9569..6860127 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -45,10 +45,10 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(info->name);
 }
 
-static int helper_xlate(const void *ip, const struct xt_entry_match *match,
-			struct xt_xlate *xl, int numeric)
+static int helper_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_mt_params *params)
 {
-	const struct xt_helper_info *info = (const void *)match->data;
+	const struct xt_helper_info *info = (const void *)params->match->data;
 
 	xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
 		   info->invert ? " !=" : "", info->name);
diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index 5e72154..9f7c0ef 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -95,10 +95,11 @@ static void comp_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --compres");
 }
 
-static int comp_xlate(const void *ip, const struct xt_entry_match *match,
-			struct xt_xlate *xl, int numeric)
+static int comp_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
-	const struct xt_ipcomp *compinfo = (struct xt_ipcomp *)match->data;
+	const struct xt_ipcomp *compinfo =
+		(struct xt_ipcomp *)params->match->data;
 
 	xt_xlate_add(xl, "comp cpi %s%u",
 		     (compinfo->invflags & XT_IPCOMP_INV_SPI) ? "!= " : "",
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index d68df48..9e6f555 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -315,10 +315,10 @@ print_iprange_xlate(const struct ipt_iprange *range,
 		   byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
 }
 
-static int iprange_xlate(const void *ip, const struct xt_entry_match *match,
-			 struct xt_xlate *xl, int numeric)
+static int iprange_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_mt_params *params)
 {
-	const struct ipt_iprange_info *info = (const void *)match->data;
+	const struct ipt_iprange_info *info = (const void *)params->match->data;
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
@@ -340,10 +340,11 @@ static int iprange_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
-static int iprange_mt4_xlate(const void *ip, const struct xt_entry_match *match,
-			     struct xt_xlate *xl, int numeric)
+static int iprange_mt4_xlate(struct xt_xlate *xl,
+			     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+	const struct xt_iprange_mtinfo *info =
+		(const void *)params->match->data;
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
@@ -369,10 +370,11 @@ static int iprange_mt4_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
-static int iprange_mt6_xlate(const void *ip, const struct xt_entry_match *match,
-			     struct xt_xlate *xl, int numeric)
+static int iprange_mt6_xlate(struct xt_xlate *xl,
+			     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+	const struct xt_iprange_mtinfo *info =
+		(const void *)params->match->data;
 	char *space = "";
 
 	if (info->flags & IPRANGE_SRC) {
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index feb1d2b..04eac4a 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -56,10 +56,10 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 		printf("%u:%u", info->min, info->max);
 }
 
-static int length_xlate(const void *ip, const struct xt_entry_match *match,
-			struct xt_xlate *xl, int numeric)
+static int length_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_mt_params *params)
 {
-	const struct xt_length_info *info = (void *)match->data;
+	const struct xt_length_info *info = (void *)params->match->data;
 
 	xt_xlate_add(xl, "meta length %s", info->invert ? "!= " : "");
 	if (info->min == info->max)
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index c82d4df..5cc95c2 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -177,10 +177,10 @@ static void print_rate_xlate(uint32_t period, struct xt_xlate *xl)
 		   rates_xlate[i - 1].name);
 }
 
-static int limit_xlate(const void *ip, const struct xt_entry_match *match,
-		       struct xt_xlate *xl, int numeric)
+static int limit_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
 {
-	const struct xt_rateinfo *r = (const void *)match->data;
+	const struct xt_rateinfo *r = (const void *)params->match->data;
 
 	xt_xlate_add(xl, "limit rate");
 	print_rate_xlate(r->avg, xl);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 251134a..b6d717b 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -80,10 +80,10 @@ static void print_mac_xlate(const unsigned char *macaddress,
 		xt_xlate_add(xl, ":%02x", macaddress[i]);
 }
 
-static int mac_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int mac_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_mac_info *info = (void *)match->data;
+	const struct xt_mac_info *info = (void *)params->match->data;
 
 	xt_xlate_add(xl, "ether saddr%s ", info->invert ? " !=" : "");
 	print_mac_xlate(info->srcaddr, xl);
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 3711ec3..e1d00de 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -114,11 +114,10 @@ print_mark_xlate(struct xt_xlate *xl, unsigned int mark,
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
-static int
-mark_mt_xlate(const void *ip, const struct xt_entry_match *match,
-	      struct xt_xlate *xl, int numeric)
+static int mark_mt_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_mt_params *params)
 {
-	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
+	const struct xt_mark_mtinfo1 *info = (const void *)params->match->data;
 	enum xt_op op = XT_OP_EQ;
 
 	if (info->invert)
@@ -130,11 +129,10 @@ mark_mt_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
-static int
-mark_xlate(const void *ip, const struct xt_entry_match *match,
-	   struct xt_xlate *xl, int numeric)
+static int mark_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
-	const struct xt_mark_info *info = (const void *)match->data;
+	const struct xt_mark_info *info = (const void *)params->match->data;
 	enum xt_op op = XT_OP_EQ;
 
 	if (info->invert)
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 94b3f54..5c5cbe0 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -468,11 +468,11 @@ static void multiport_save6_v1(const void *ip_void,
 	__multiport_save_v1(match, ip->proto);
 }
 
-static int __multiport_xlate(const void *ip, const struct xt_entry_match *match,
-			     struct xt_xlate *xl, int numeric)
+static int __multiport_xlate(struct xt_xlate *xl,
+			     const struct xt_xlate_mt_params *params)
 {
 	const struct xt_multiport *multiinfo
-		= (const struct xt_multiport *)match->data;
+		= (const struct xt_multiport *)params->match->data;
 	unsigned int i;
 
 	switch (multiinfo->flags) {
@@ -498,30 +498,29 @@ static int __multiport_xlate(const void *ip, const struct xt_entry_match *match,
 	return 1;
 }
 
-static int multiport_xlate(const void *ip, const struct xt_entry_match *match,
-			   struct xt_xlate *xl, int numeric)
+static int multiport_xlate(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
 {
-	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
+	uint8_t proto = ((const struct ipt_ip *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate(ip, match, xl, numeric);
+	return __multiport_xlate(xl, params);
 }
 
-static int multiport_xlate6(const void *ip, const struct xt_entry_match *match,
-			    struct xt_xlate *xl, int numeric)
+static int multiport_xlate6(struct xt_xlate *xl,
+			    const struct xt_xlate_mt_params *params)
 {
-	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
+	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate(ip, match, xl, numeric);
+	return __multiport_xlate(xl, params);
 }
 
-static int __multiport_xlate_v1(const void *ip,
-				const struct xt_entry_match *match,
-				struct xt_xlate *xl, int numeric)
+static int __multiport_xlate_v1(struct xt_xlate *xl,
+				const struct xt_xlate_mt_params *params)
 {
-	const struct xt_multiport_v1 *multiinfo
-		= (const struct xt_multiport_v1 *)match->data;
+	const struct xt_multiport_v1 *multiinfo =
+		(const struct xt_multiport_v1 *)params->match->data;
 	unsigned int i;
 
 	switch (multiinfo->flags) {
@@ -555,24 +554,22 @@ static int __multiport_xlate_v1(const void *ip,
 	return 1;
 }
 
-static int multiport_xlate_v1(const void *ip,
-			      const struct xt_entry_match *match,
-			      struct xt_xlate *xl, int numeric)
+static int multiport_xlate_v1(struct xt_xlate *xl,
+			      const struct xt_xlate_mt_params *params)
 {
-	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
+	uint8_t proto = ((const struct ipt_ip *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate_v1(ip, match, xl, numeric);
+	return __multiport_xlate_v1(xl, params);
 }
 
-static int multiport_xlate6_v1(const void *ip,
-			       const struct xt_entry_match *match,
-			       struct xt_xlate *xl, int numeric)
+static int multiport_xlate6_v1(struct xt_xlate *xl,
+			       const struct xt_xlate_mt_params *params)
 {
-	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
+	uint8_t proto = ((const struct ip6t_ip6 *)params->ip)->proto;
 
 	xt_xlate_add(xl, "%s", proto_to_name(proto));
-	return __multiport_xlate_v1(ip, match, xl, numeric);
+	return __multiport_xlate_v1(xl, params);
 }
 
 static struct xtables_match multiport_mt_reg[] = {
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 249ba5a..87e4df3 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -522,10 +522,10 @@ owner_mt_print_gid_xlate(const struct xt_owner_match_info *info,
 	return 1;
 }
 
-static int owner_mt_xlate(const void *ip, const struct xt_entry_match *match,
-			  struct xt_xlate *xl, int numeric)
+static int owner_mt_xlate(struct xt_xlate *xl,
+			  const struct xt_xlate_mt_params *params)
 {
-	const struct xt_owner_match_info *info = (void *)match->data;
+	const struct xt_owner_match_info *info = (void *)params->match->data;
 	int ret;
 
 	switch (info->match) {
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index a14409d..bf6f5b9 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -140,10 +140,10 @@ static void print_pkttype_xlate(const struct xt_pkttype_info *info,
 	xt_xlate_add(xl, "%d", info->pkttype);
 }
 
-static int pkttype_xlate(const void *ip, const struct xt_entry_match *match,
-			 struct xt_xlate *xl, int numeric)
+static int pkttype_xlate(struct xt_xlate *xl,
+			 const struct xt_xlate_mt_params *params)
 {
-	const struct xt_pkttype_info *info = (const void *)match->data;
+	const struct xt_pkttype_info *info = (const void *)params->match->data;
 
 	xt_xlate_add(xl, "pkttype%s ", info->invert ? " !=" : "");
 	print_pkttype_xlate(info, xl);
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index a04b4fc..df1936b 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -485,11 +485,11 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int sctp_xlate(const void *ip, const struct xt_entry_match *match,
-		      struct xt_xlate *xl, int numeric)
+static int sctp_xlate(struct xt_xlate *xl,
+		      const struct xt_xlate_mt_params *params)
 {
 	const struct xt_sctp_info *einfo =
-		(const struct xt_sctp_info *)match->data;
+		(const struct xt_sctp_info *)params->match->data;
 	char *space = "";
 
 	if (!einfo->flags)
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index bc1d0af..7f68b81 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -393,10 +393,11 @@ static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 		xt_xlate_add(xl, "0x0");
 }
 
-static int tcp_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int tcp_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)match->data;
+	const struct xt_tcp *tcpinfo =
+		(const struct xt_tcp *)params->match->data;
 	char *space= "";
 
 	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index d8e286a..0c7a4bc 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -152,10 +152,10 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int udp_xlate(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric)
+static int udp_xlate(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params)
 {
-	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
+	const struct xt_udp *udpinfo = (struct xt_udp *)params->match->data;
 	char *space= "";
 
 	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
diff --git a/include/xtables.h b/include/xtables.h
index 48be514..9701612 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -207,6 +207,18 @@ enum xtables_ext_flags {
 
 struct xt_xlate;
 
+struct xt_xlate_mt_params {
+	const void			*ip;
+	const struct xt_entry_match	*match;
+	int				numeric;
+};
+
+struct xt_xlate_tg_params {
+	const void			*ip;
+	const struct xt_entry_target	*target;
+	int				numeric;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -272,8 +284,8 @@ struct xtables_match
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const void *ip, const struct xt_entry_match *match,
-		     struct xt_xlate *xl, int numeric);
+	int (*xlate)(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params);
 
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
@@ -353,8 +365,8 @@ struct xtables_target
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const void *ip, const struct xt_entry_target *target,
-		     struct xt_xlate *xl, int numeric);
+	int (*xlate)(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params);
 
 	size_t udata_size;
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 71f1356..678228b 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -48,9 +48,14 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 			xt_xlate_add(xl, "drop");
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			xt_xlate_add(xl, "return");
-		else if (cs->target->xlate)
-			ret = cs->target->xlate((const void *)&cs->fw,
-						cs->target->t, xl, numeric);
+		else if (cs->target->xlate) {
+			struct xt_xlate_tg_params params = {
+				.ip		= (const void *)&cs->fw,
+				.target		= cs->target->t,
+				.numeric	= numeric,
+			};
+			ret = cs->target->xlate(xl, &params);
+		}
 		else
 			return 0;
 	} else if (strlen(cs->jumpto) > 0) {
@@ -70,11 +75,16 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		struct xt_xlate_mt_params params = {
+			.ip		= (const void *)&cs->fw,
+			.match		= matchp->match->m,
+			.numeric	= numeric,
+		};
+
 		if (!matchp->match->xlate)
 			return 0;
 
-		ret = matchp->match->xlate((const void *)&cs->fw,
-					   matchp->match->m, xl, numeric);
+		ret = matchp->match->xlate(xl, &params);
 
 		if (strcmp(matchp->match->name, "comment") != 0)
 			xt_xlate_add(xl, " ");
-- 
2.1.4

