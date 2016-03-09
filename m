From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables-translate: pass ipt_entry and ip6t_entry to ->xlate()
Date: Wed,  9 Mar 2016 18:25:13 +0100
Message-ID: <1457544313-10508-1-git-send-email-pablo@netfilter.org>
Cc: shivanib134@gmail.com, gokuvsvegita@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbcCIRZb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 12:25:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 556F873ED
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:25:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3AE47DA8F9
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:25:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 96362DA8F9
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Mar 2016 18:25:25 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The multiport match needs it, this basically leaves ->xlate() indirection
with almost the same interface as ->print().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
You need this for the multiport match so you can access the protocol
information using ipt_ip and ip6t_ip. Have a look at multiport_print()
and multiport_print6().

 extensions/libip6t_DNAT.c       |  2 +-
 extensions/libip6t_LOG.c        |  2 +-
 extensions/libip6t_MASQUERADE.c |  2 +-
 extensions/libip6t_REDIRECT.c   |  2 +-
 extensions/libip6t_REJECT.c     |  2 +-
 extensions/libip6t_SNAT.c       |  2 +-
 extensions/libip6t_ah.c         |  2 +-
 extensions/libip6t_hl.c         |  2 +-
 extensions/libip6t_icmp6.c      |  4 ++--
 extensions/libip6t_mh.c         |  2 +-
 extensions/libip6t_rt.c         |  4 ++--
 extensions/libipt_DNAT.c        |  2 +-
 extensions/libipt_LOG.c         |  2 +-
 extensions/libipt_MASQUERADE.c  |  2 +-
 extensions/libipt_REDIRECT.c    |  2 +-
 extensions/libipt_REJECT.c      |  2 +-
 extensions/libipt_SNAT.c        |  2 +-
 extensions/libipt_ah.c          |  2 +-
 extensions/libipt_realm.c       |  2 +-
 extensions/libipt_ttl.c         |  2 +-
 extensions/libxt_NFLOG.c        |  2 +-
 extensions/libxt_NFQUEUE.c      | 15 +++++++++------
 extensions/libxt_comment.c      |  2 +-
 extensions/libxt_connmark.c     |  6 +++---
 extensions/libxt_conntrack.c    |  4 ++--
 extensions/libxt_cpu.c          |  2 +-
 extensions/libxt_dccp.c         |  2 +-
 extensions/libxt_devgroup.c     |  2 +-
 extensions/libxt_esp.c          |  2 +-
 extensions/libxt_helper.c       |  2 +-
 extensions/libxt_iprange.c      |  6 +++---
 extensions/libxt_length.c       |  2 +-
 extensions/libxt_limit.c        |  2 +-
 extensions/libxt_mac.c          |  2 +-
 extensions/libxt_mark.c         |  4 ++--
 extensions/libxt_owner.c        |  2 +-
 extensions/libxt_pkttype.c      |  4 ++--
 extensions/libxt_sctp.c         |  2 +-
 extensions/libxt_tcp.c          |  4 ++--
 extensions/libxt_udp.c          |  4 ++--
 include/xtables.h               |  8 ++++----
 iptables/xtables-translate.c    |  6 ++++--
 42 files changed, 67 insertions(+), 62 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 7fc21a3..8bd6231 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -252,7 +252,7 @@ static void print_range_xlate(const struct nf_nat_range *range,
 	}
 }
 
-static int DNAT_xlate(const struct xt_entry_target *target,
+static int DNAT_xlate(const void *ip, const struct xt_entry_target *target,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 17d76a8..7841e57 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -182,7 +182,7 @@ static const struct ip6t_log_xlate ip6t_log_xlate_names[] = {
 	{"warn",        LOG_WARNING }
 };
 
-static int LOG_xlate(const struct xt_entry_target *target,
+static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
 		     struct xt_xlate *xl, int numeric)
 {
 	unsigned int i = 0;
diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
index 5a309ac..15ca141 100644
--- a/extensions/libip6t_MASQUERADE.c
+++ b/extensions/libip6t_MASQUERADE.c
@@ -132,7 +132,7 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static int
-MASQUERADE_xlate(const struct xt_entry_target *target,
+MASQUERADE_xlate(const void *ip, const struct xt_entry_target *target,
 		 struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *r = (const void *)target->data;
diff --git a/extensions/libip6t_REDIRECT.c b/extensions/libip6t_REDIRECT.c
index fc4a4d8..9c5f14c 100644
--- a/extensions/libip6t_REDIRECT.c
+++ b/extensions/libip6t_REDIRECT.c
@@ -132,7 +132,7 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static int REDIRECT_xlate(const struct xt_entry_target *target,
+static int REDIRECT_xlate(const void *ip, const struct xt_entry_target *target,
 			  struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index ad2a8ec..c30f292 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -139,7 +139,7 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 	{"reject-route",	IP6T_ICMP6_REJECT_ROUTE}
 };
 
-static int REJECT_xlate(const struct xt_entry_target *target,
+static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 			struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_reject_info *reject =
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 28e29da..ab7713b 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -262,7 +262,7 @@ static void print_range_xlate(const struct nf_nat_range *range,
 	}
 }
 
-static int SNAT_xlate(const struct xt_entry_target *target,
+static int SNAT_xlate(const void *ip, const struct xt_entry_target *target,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 087b3ac..9c7bdd7 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -128,7 +128,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --ahres");
 }
 
-static int ah_xlate(const struct xt_entry_match *match,
+static int ah_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 9fe893a..ee9c36b 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -83,7 +83,7 @@ static void hl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %s %u", op[info->mode], info->hop_limit);
 }
 
-static int hl_xlate(const struct xt_entry_match *match,
+static int hl_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	static const char *const op[] = {
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 2c5aadd..ddb1673 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -271,8 +271,8 @@ static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
 	return 1;
 }
 
-static int icmp6_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
-		       int numeric)
+static int icmp6_xlate(const void *ip, const struct xt_entry_match *match,
+		       struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
 
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index c48582c..f4672da 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -202,7 +202,7 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --mh-type %u", mhinfo->types[0]);
 }
 
-static int mh_xlate(const struct xt_entry_match *match,
+static int mh_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 59adfad..14a7f7e 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -245,8 +245,8 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int rt_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
-		    int numeric)
+static int rt_xlate(const void *ip, const struct xt_entry_match *match,
+		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 45835a9..79f5024 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -262,7 +262,7 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 	}
 }
 
-static int DNAT_xlate(const struct xt_entry_target *target,
+static int DNAT_xlate(const void *ip, const struct xt_entry_target *target,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_natinfo *info = (const void *)target;
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index f3875b6..afe8c9f 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -182,7 +182,7 @@ static const struct ipt_log_xlate ipt_log_xlate_names[] = {
 	{"warn",	LOG_WARNING }
 };
 
-static int LOG_xlate(const struct xt_entry_target *target,
+static int LOG_xlate(const void *ip, const struct xt_entry_target *target,
 		     struct xt_xlate *xl, int numeric)
 {
 	unsigned int i = 0;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index d1393c1..2d11fa9 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -135,7 +135,7 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static int
-MASQUERADE_xlate(const struct xt_entry_target *target,
+MASQUERADE_xlate(const void *ip, const struct xt_entry_target *target,
 		 struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 68efe96..1ffb3dd 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -135,7 +135,7 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
-static int REDIRECT_xlate(const struct xt_entry_target *target,
+static int REDIRECT_xlate(const void *ip, const struct xt_entry_target *target,
 			  struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 56fc346..4148776 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -159,7 +159,7 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 	{"admin-prohibited",	IPT_ICMP_ADMIN_PROHIBITED}
 };
 
-static int REJECT_xlate(const struct xt_entry_target *target,
+static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 			struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_reject_info *reject =
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 1962e66..6613316 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -273,7 +273,7 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 	}
 }
 
-static int SNAT_xlate(const struct xt_entry_target *target,
+static int SNAT_xlate(const void *ip, const struct xt_entry_target *target,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_natinfo *info = (const void *)target;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index a7d1193..b8953d7 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -92,7 +92,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int ah_xlate(const struct xt_entry_match *match,
+static int ah_xlate(const void *ip, const struct xt_entry_match *match,
 		    struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 7dba93f..beb2491 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -129,7 +129,7 @@ print_realm_xlate(unsigned long id, unsigned long mask,
 	}
 }
 
-static int realm_xlate(const struct xt_entry_match *match,
+static int realm_xlate(const void *ip, const struct xt_entry_match *match,
 		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_realm_info *ri = (const void *)match->data;
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index bd19cd2..01e085d 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -100,7 +100,7 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %u", info->ttl);
 }
 
-static int ttl_xlate(const struct xt_entry_match *match,
+static int ttl_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_ttl_info *info =
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index e31a3c4..f611631 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -99,7 +99,7 @@ static void nflog_print_xlate(const struct xt_nflog_info *info,
 	xt_xlate_add(xl, "group %u ", info->group);
 }
 
-static int NFLOG_xlate(const struct xt_entry_target *target,
+static int NFLOG_xlate(const void *ip, const struct xt_entry_target *target,
 		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index fe005cb..8115457 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -205,7 +205,7 @@ static void NFQUEUE_init_v1(struct xt_entry_target *t)
 	tinfo->queues_total = 1;
 }
 
-static int NFQUEUE_xlate(const struct xt_entry_target *target,
+static int NFQUEUE_xlate(const void *ip, const struct xt_entry_target *target,
 			 struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info *tinfo =
@@ -216,7 +216,8 @@ static int NFQUEUE_xlate(const struct xt_entry_target *target,
 	return 1;
 }
 
-static int NFQUEUE_xlate_v1(const struct xt_entry_target *target,
+static int NFQUEUE_xlate_v1(const void *ip,
+			    const struct xt_entry_target *target,
 			    struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info_v1 *tinfo = (const void *)target->data;
@@ -232,12 +233,13 @@ static int NFQUEUE_xlate_v1(const struct xt_entry_target *target,
 	return 1;
 }
 
-static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
+static int NFQUEUE_xlate_v2(const void *ip,
+			    const struct xt_entry_target *target,
 			    struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info_v2 *info = (void *) target->data;
 
-	NFQUEUE_xlate_v1(target, xl, numeric);
+	NFQUEUE_xlate_v1(ip, target, xl, numeric);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
 		xt_xlate_add(xl, "bypass");
@@ -245,12 +247,13 @@ static int NFQUEUE_xlate_v2(const struct xt_entry_target *target,
 	return 1;
 }
 
-static int NFQUEUE_xlate_v3(const struct xt_entry_target *target,
+static int NFQUEUE_xlate_v3(const void *ip,
+			    const struct xt_entry_target *target,
 			    struct xt_xlate *xl, int numeric)
 {
 	const struct xt_NFQ_info_v3 *info = (void *)target->data;
 
-	NFQUEUE_xlate_v2(target, xl, numeric);
+	NFQUEUE_xlate_v2(ip, target, xl, numeric);
 	if (info->flags & NFQ_FLAG_CPU_FANOUT)
 		xt_xlate_add(xl, "%sfanout ", info->flags & NFQ_FLAG_BYPASS ? "," : "");
 
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 3fcb8b4..ab229e0 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -49,7 +49,7 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int
-comment_xlate(const struct xt_entry_match *match,
+comment_xlate(const void *ip, const struct xt_entry_match *match,
 	      struct xt_xlate *xl, int numeric)
 {
 	struct xt_comment_info *commentinfo = (void *)match->data;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 3d1926f..fbfeb74 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -134,7 +134,7 @@ static void print_mark_xlate(unsigned int mark, unsigned int mask,
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
-static int connmark_xlate(const struct xt_entry_match *match,
+static int connmark_xlate(const void *ip, const struct xt_entry_match *match,
 			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_connmark_info *info = (const void *)match->data;
@@ -150,8 +150,8 @@ static int connmark_xlate(const struct xt_entry_match *match,
 }
 
 static int
-connmark_mt_xlate(const struct xt_entry_match *match,
-		 struct xt_xlate *xl, int numeric)
+connmark_mt_xlate(const void *ip, const struct xt_entry_match *match,
+		  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 7f66895..310a468 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1182,8 +1182,8 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 	}
 }
 
-static int state_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
-		       int numeric)
+static int state_xlate(const void *ip, const struct xt_entry_match *match,
+		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
 
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 02286c2..d453fad 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -44,7 +44,7 @@ static void cpu_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s --cpu %u", info->invert ? " !" : "", info->cpu);
 }
 
-static int cpu_xlate(const struct xt_entry_match *match,
+static int cpu_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_cpu_info *info = (void *)match->data;
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 0d4f369..d442e37 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -329,7 +329,7 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	return 1;
 }
 
-static int dccp_xlate(const struct xt_entry_match *match,
+static int dccp_xlate(const void *ip, const struct xt_entry_match *match,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct xt_dccp_info *einfo =
diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index fd67bc3..a30fff0 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -193,7 +193,7 @@ static void devgroup_show_xlate(const struct xt_devgroup_info *info,
 	}
 }
 
-static int devgroup_xlate(const struct xt_entry_match *match,
+static int devgroup_xlate(const void *ip, const struct xt_entry_match *match,
 			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_devgroup_info *info = (const void *)match->data;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index b5219fd..bd7b643 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -86,7 +86,7 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
-static int esp_xlate(const struct xt_entry_match *match,
+static int esp_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 9df4163..a8b7c68 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -45,7 +45,7 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(info->name);
 }
 
-static int helper_xlate(const struct xt_entry_match *match,
+static int helper_xlate(const void *ip, const struct xt_entry_match *match,
 			struct xt_xlate *xl, int numeric)
 {
 	const struct xt_helper_info *info = (const void *)match->data;
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 0b05651..c2d51e9 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -315,7 +315,7 @@ print_iprange_xlate(const struct ipt_iprange *range,
 		   byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
 }
 
-static int iprange_xlate(const struct xt_entry_match *match,
+static int iprange_xlate(const void *ip, const struct xt_entry_match *match,
 			 struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_iprange_info *info = (const void *)match->data;
@@ -336,7 +336,7 @@ static int iprange_xlate(const struct xt_entry_match *match,
 	return 1;
 }
 
-static int iprange_mt4_xlate(const struct xt_entry_match *match,
+static int iprange_mt4_xlate(const void *ip, const struct xt_entry_match *match,
 			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
@@ -361,7 +361,7 @@ static int iprange_mt4_xlate(const struct xt_entry_match *match,
 	return 1;
 }
 
-static int iprange_mt6_xlate(const struct xt_entry_match *match,
+static int iprange_mt6_xlate(const void *ip, const struct xt_entry_match *match,
 			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 00acae0..1335b4e 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -56,7 +56,7 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 		printf("%u:%u", info->min, info->max);
 }
 
-static int length_xlate(const struct xt_entry_match *match,
+static int length_xlate(const void *ip, const struct xt_entry_match *match,
 			struct xt_xlate *xl, int numeric)
 {
 	const struct xt_length_info *info = (void *)match->data;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 9ad00c1..c88d26b 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -177,7 +177,7 @@ static void print_rate_xlate(uint32_t period, struct xt_xlate *xl)
 		   rates_xlate[i - 1].name);
 }
 
-static int limit_xlate(const struct xt_entry_match *match,
+static int limit_xlate(const void *ip, const struct xt_entry_match *match,
 		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_rateinfo *r = (const void *)match->data;
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 85ed1b5..b416487 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -81,7 +81,7 @@ static void print_mac_xlate(const unsigned char *macaddress,
 	xt_xlate_add(xl, " ");
 }
 
-static int mac_xlate(const struct xt_entry_match *match,
+static int mac_xlate(const void *ip, const struct xt_entry_match *match,
 		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mac_info *info = (void *)match->data;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index b8c0ed6..939b4ac 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -115,7 +115,7 @@ print_mark_xlate(struct xt_xlate *xl, unsigned int mark,
 }
 
 static int
-mark_mt_xlate(const struct xt_entry_match *match,
+mark_mt_xlate(const void *ip, const struct xt_entry_match *match,
 	      struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
@@ -131,7 +131,7 @@ mark_mt_xlate(const struct xt_entry_match *match,
 }
 
 static int
-mark_xlate(const struct xt_entry_match *match,
+mark_xlate(const void *ip, const struct xt_entry_match *match,
 	   struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mark_info *info = (const void *)match->data;
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 2085de8..1ee58ff 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -522,7 +522,7 @@ owner_mt_print_gid_xlate(const struct xt_owner_match_info *info,
 	return 1;
 }
 
-static int owner_mt_xlate(const struct xt_entry_match *match,
+static int owner_mt_xlate(const void *ip, const struct xt_entry_match *match,
 			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 55edf27..c8123a2 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -140,8 +140,8 @@ static void print_pkttype_xlate(const struct xt_pkttype_info *info,
 	xt_xlate_add(xl, "%d", info->pkttype);
 }
 
-static int pkttype_xlate(const struct xt_entry_match *match,
-			  struct xt_xlate *xl, int numeric)
+static int pkttype_xlate(const void *ip, const struct xt_entry_match *match,
+			 struct xt_xlate *xl, int numeric)
 {
 	const struct xt_pkttype_info *info = (const void *)match->data;
 
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 3b0b048..ae1969a 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -485,7 +485,7 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int sctp_xlate(const struct xt_entry_match *match,
+static int sctp_xlate(const void *ip, const struct xt_entry_match *match,
 		      struct xt_xlate *xl, int numeric)
 {
 	const struct xt_sctp_info *einfo =
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index bd4ca77..6a85ed4 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -393,8 +393,8 @@ static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 		xt_xlate_add(xl, "none");
 }
 
-static int tcp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
-		     int numeric)
+static int tcp_xlate(const void *ip, const struct xt_entry_match *match,
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)match->data;
 
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 47c29e9..9af782e 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -152,8 +152,8 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int udp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
-		     int numeric)
+static int udp_xlate(const void *ip, const struct xt_entry_match *match,
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
 
diff --git a/include/xtables.h b/include/xtables.h
index e219c9f..48be514 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -272,8 +272,8 @@ struct xtables_match
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const struct xt_entry_match *match, struct xt_xlate *xl,
-		     int numeric);
+	int (*xlate)(const void *ip, const struct xt_entry_match *match,
+		     struct xt_xlate *xl, int numeric);
 
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
@@ -353,8 +353,8 @@ struct xtables_target
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const struct xt_entry_target *target, struct xt_xlate *xl,
-		     int numeric);
+	int (*xlate)(const void *ip, const struct xt_entry_target *target,
+		     struct xt_xlate *xl, int numeric);
 
 	size_t udata_size;
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3c5b577..13a0bc7 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -49,7 +49,8 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
 			xt_xlate_add(xl, "return");
 		else if (cs->target->xlate)
-			ret = cs->target->xlate(cs->target->t, xl, numeric);
+			ret = cs->target->xlate((const void *)&cs->fw,
+						cs->target->t, xl, numeric);
 		else
 			return 0;
 	} else if (strlen(cs->jumpto) > 0) {
@@ -72,7 +73,8 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 		if (!matchp->match->xlate)
 			return 0;
 
-		ret = matchp->match->xlate(matchp->match->m, xl, numeric);
+		ret = matchp->match->xlate((const void *)&cs->fw,
+					   matchp->match->m, xl, numeric);
 		if (!ret)
 			break;
 	}
-- 
2.1.4

