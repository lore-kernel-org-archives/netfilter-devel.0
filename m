From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 iptables,xlate4] extensions: rename xt_buf to xt_xlate
Date: Mon,  1 Feb 2016 19:43:35 +0100
Message-ID: <1454352216-18812-2-git-send-email-pablo@netfilter.org>
References: <1454352216-18812-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56517 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbcBASnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 13:43:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4D12C61E9F
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDA5DA808
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DC40FDA80C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:40 +0100 (CET)
In-Reply-To: <1454352216-18812-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use a more generic name for this object to prepare the introduction of
other translation specific fields.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libip6t_DNAT.c     | 20 +++++++++----------
 extensions/libip6t_LOG.c      |  8 ++++----
 extensions/libip6t_REDIRECT.c |  8 ++++----
 extensions/libip6t_REJECT.c   |  6 +++---
 extensions/libip6t_SNAT.c     | 22 ++++++++++-----------
 extensions/libip6t_ah.c       | 12 +++++------
 extensions/libip6t_hl.c       |  4 ++--
 extensions/libipt_DNAT.c      | 20 +++++++++----------
 extensions/libipt_LOG.c       |  8 ++++----
 extensions/libipt_REDIRECT.c  |  8 ++++----
 extensions/libipt_REJECT.c    |  6 +++---
 extensions/libipt_SNAT.c      | 24 +++++++++++-----------
 extensions/libipt_ah.c        |  8 ++++----
 extensions/libipt_realm.c     | 14 ++++++-------
 extensions/libipt_ttl.c       | 12 +++++------
 extensions/libxt_NFLOG.c      | 16 +++++++--------
 extensions/libxt_connmark.c   | 18 ++++++++---------
 extensions/libxt_conntrack.c  | 20 +++++++++----------
 extensions/libxt_cpu.c        |  4 ++--
 extensions/libxt_devgroup.c   | 22 ++++++++++-----------
 extensions/libxt_esp.c        |  8 ++++----
 extensions/libxt_helper.c     |  4 ++--
 extensions/libxt_iprange.c    | 46 +++++++++++++++++++++----------------------
 extensions/libxt_length.c     |  8 ++++----
 extensions/libxt_limit.c      | 14 ++++++-------
 extensions/libxt_mac.c        | 14 ++++++-------
 extensions/libxt_mark.c       | 18 ++++++++---------
 extensions/libxt_pkttype.c    | 12 +++++------
 extensions/libxt_tcp.c        | 28 +++++++++++++-------------
 extensions/libxt_udp.c        | 10 +++++-----
 include/xtables.h             | 16 +++++++--------
 iptables/nft-ipv4.c           | 20 +++++++++----------
 iptables/nft-ipv6.c           | 22 ++++++++++-----------
 iptables/nft-shared.h         |  4 ++--
 iptables/nft.h                |  4 ++--
 iptables/xtables-translate.c  | 30 ++++++++++++++--------------
 libxtables/xtables.c          | 42 +++++++++++++++++++--------------------
 37 files changed, 280 insertions(+), 280 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index 3959755..7fc21a3 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -232,43 +232,43 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void print_range_xlate(const struct nf_nat_range *range,
-			      struct xt_buf *buf)
+			      struct xt_xlate *xl)
 {
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_buf_add(buf, "%s",
+		xt_xlate_add(xl, "%s",
 			   xtables_ip6addr_to_numeric(&range->min_addr.in6));
 
 		if (memcmp(&range->min_addr, &range->max_addr,
 			   sizeof(range->min_addr)))
-			xt_buf_add(buf, "-%s",
+			xt_xlate_add(xl, "-%s",
 			     xtables_ip6addr_to_numeric(&range->max_addr.in6));
 	}
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, " :%hu", ntohs(range->min_proto.tcp.port));
+		xt_xlate_add(xl, " :%hu", ntohs(range->min_proto.tcp.port));
 
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			xt_buf_add(buf, "-%hu",
+			xt_xlate_add(xl, "-%hu",
 				   ntohs(range->max_proto.tcp.port));
 	}
 }
 
 static int DNAT_xlate(const struct xt_entry_target *target,
-		       struct xt_buf *buf, int numeric)
+		      struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
-	xt_buf_add(buf, "dnat ");
-	print_range_xlate(range, buf);
+	xt_xlate_add(xl, "dnat ");
+	print_range_xlate(range, xl);
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_buf_add(buf, " random");
+		xt_xlate_add(xl, " random");
 		sep_need = true;
 	}
 	if (range->flags & NF_NAT_RANGE_PERSISTENT) {
 		if (sep_need)
 			sep = ",";
-		xt_buf_add(buf, "%spersistent", sep);
+		xt_xlate_add(xl, "%spersistent", sep);
 	}
 
 	return 1;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 9df86fd..17d76a8 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -183,19 +183,19 @@ static const struct ip6t_log_xlate ip6t_log_xlate_names[] = {
 };
 
 static int LOG_xlate(const struct xt_entry_target *target,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	unsigned int i = 0;
 	const struct ip6t_log_info *loginfo =
 			(const struct ip6t_log_info *)target->data;
 
-	xt_buf_add(buf, "log ");
+	xt_xlate_add(xl, "log ");
 	if (strcmp(loginfo->prefix, "") != 0)
-		xt_buf_add(buf, "prefix \\\"%s\\\" ", loginfo->prefix);
+		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
 
 	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
 		if (loginfo->level == ip6t_log_xlate_names[i].level) {
-			xt_buf_add(buf, "level %s",
+			xt_xlate_add(xl, "level %s",
 				   ip6t_log_xlate_names[i].name);
 			break;
 		}
diff --git a/extensions/libip6t_REDIRECT.c b/extensions/libip6t_REDIRECT.c
index d907d94..fc4a4d8 100644
--- a/extensions/libip6t_REDIRECT.c
+++ b/extensions/libip6t_REDIRECT.c
@@ -133,18 +133,18 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static int REDIRECT_xlate(const struct xt_entry_target *target,
-			  struct xt_buf *buf, int numeric)
+			  struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
 
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, "redirect to %hu",
+		xt_xlate_add(xl, "redirect to %hu",
 			   ntohs(range->min_proto.tcp.port));
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			xt_buf_add(buf, "-%hu ",
+			xt_xlate_add(xl, "-%hu ",
 				   ntohs(range->max_proto.tcp.port));
 		if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-			xt_buf_add(buf, " random ");
+			xt_xlate_add(xl, " random ");
 	}
 
 	return 1;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 3b8431c..ad2a8ec 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -140,7 +140,7 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 };
 
 static int REJECT_xlate(const struct xt_entry_target *target,
-			struct xt_buf *buf, int numeric)
+			struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_reject_info *reject =
 				(const struct ip6t_reject_info *)target->data;
@@ -150,9 +150,9 @@ static int REJECT_xlate(const struct xt_entry_target *target,
 		if (reject_table_xlate[i].with == reject->with)
 			break;
 	if (reject->with == IP6T_TCP_RESET)
-		xt_buf_add(buf, "reject with %s", reject_table_xlate[i].name);
+		xt_xlate_add(xl, "reject with %s", reject_table_xlate[i].name);
 	else
-		xt_buf_add(buf, "reject with icmpv6 type %s",
+		xt_xlate_add(xl, "reject with icmpv6 type %s",
 			   reject_table_xlate[i].name);
 
 	return 1;
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index b85c86c..28e29da 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -242,49 +242,49 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void print_range_xlate(const struct nf_nat_range *range,
-			      struct xt_buf *buf)
+			      struct xt_xlate *xl)
 {
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_buf_add(buf, "%s",
+		xt_xlate_add(xl, "%s",
 			   xtables_ip6addr_to_numeric(&range->min_addr.in6));
 
 		if (memcmp(&range->min_addr, &range->max_addr,
 			   sizeof(range->min_addr)))
-			xt_buf_add(buf, "-%s",
+			xt_xlate_add(xl, "-%s",
 			     xtables_ip6addr_to_numeric(&range->max_addr.in6));
 	}
 	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, " :%hu", ntohs(range->min_proto.tcp.port));
+		xt_xlate_add(xl, " :%hu", ntohs(range->min_proto.tcp.port));
 
 		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			xt_buf_add(buf, "-%hu",
+			xt_xlate_add(xl, "-%hu",
 				   ntohs(range->max_proto.tcp.port));
 	}
 }
 
 static int SNAT_xlate(const struct xt_entry_target *target,
-		      struct xt_buf *buf, int numeric)
+		      struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_range *range = (const void *)target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
-	xt_buf_add(buf, "snat ");
-	print_range_xlate(range, buf);
+	xt_xlate_add(xl, "snat ");
+	print_range_xlate(range, xl);
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_buf_add(buf, " random");
+		xt_xlate_add(xl, " random");
 		sep_need = true;
 	}
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 		if (sep_need)
 			sep = ",";
-		xt_buf_add(buf, "%sfully-random", sep);
+		xt_xlate_add(xl, "%sfully-random", sep);
 		sep_need = true;
 	}
 	if (range->flags & NF_NAT_RANGE_PERSISTENT) {
 		if (sep_need)
 			sep = ",";
-		xt_buf_add(buf, "%spersistent", sep);
+		xt_xlate_add(xl, "%spersistent", sep);
 	}
 
 	return 1;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index f7c30f4..087b3ac 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -129,27 +129,27 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int ah_xlate(const struct xt_entry_match *match,
-		    struct xt_buf *buf, int numeric)
+		    struct xt_xlate *xl, int numeric)
 {
 	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
 
 	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_buf_add(buf, "ah spi%s ",
+		xt_xlate_add(xl, "ah spi%s ",
 			   (ahinfo->invflags & IP6T_AH_INV_SPI) ? " !=" : "");
 	if (ahinfo->spis[0] != ahinfo->spis[1])
-		xt_buf_add(buf, "%u-%u ", ahinfo->spis[0], ahinfo->spis[1]);
+		xt_xlate_add(xl, "%u-%u ", ahinfo->spis[0], ahinfo->spis[1]);
 	else
-		xt_buf_add(buf, "%u ", ahinfo->spis[0]);
+		xt_xlate_add(xl, "%u ", ahinfo->spis[0]);
 	}
 
 	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN)) {
-		xt_buf_add(buf, "ah hdrlength%s %u ",
+		xt_xlate_add(xl, "ah hdrlength%s %u ",
 			   (ahinfo->invflags & IP6T_AH_INV_LEN) ? " !=" : "",
 			   ahinfo->hdrlen);
 	}
 
 	if (ahinfo->hdrres != 0)
-		xt_buf_add(buf, "ah reserved %u ", ahinfo->hdrres);
+		xt_xlate_add(xl, "ah reserved %u ", ahinfo->hdrres);
 
 	return 1;
 }
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 226b69c..9fe893a 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -84,7 +84,7 @@ static void hl_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int hl_xlate(const struct xt_entry_match *match,
-		    struct xt_buf *buf, int numeric)
+		    struct xt_xlate *xl, int numeric)
 {
 	static const char *const op[] = {
 		[IP6T_HL_EQ] = "",
@@ -95,7 +95,7 @@ static int hl_xlate(const struct xt_entry_match *match,
 	const struct ip6t_hl_info *info =
 		(struct ip6t_hl_info *) match->data;
 
-	xt_buf_add(buf, "ip6 hoplimit %s%u ", op[info->mode], info->hop_limit);
+	xt_xlate_add(xl, "ip6 hoplimit %s%u ", op[info->mode], info->hop_limit);
 
 	return 1;
 }
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index e529141..45835a9 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -243,27 +243,27 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void print_range_xlate(const struct nf_nat_ipv4_range *r,
-			struct xt_buf *buf)
+			struct xt_xlate *xl)
 {
 	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		xt_buf_add(buf, "%s", xtables_ipaddr_to_numeric(&a));
+		xt_xlate_add(xl, "%s", xtables_ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			xt_buf_add(buf, "-%s", xtables_ipaddr_to_numeric(&a));
+			xt_xlate_add(xl, "-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, ":%hu", ntohs(r->min.tcp.port));
+		xt_xlate_add(xl, ":%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
-			xt_buf_add(buf, "-%hu", ntohs(r->max.tcp.port));
+			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
 	}
 }
 
 static int DNAT_xlate(const struct xt_entry_target *target,
-		      struct xt_buf *buf, int numeric)
+		      struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
@@ -271,16 +271,16 @@ static int DNAT_xlate(const struct xt_entry_target *target,
 	const char *sep = " ";
 
 	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_buf_add(buf, "dnat ");
-		print_range_xlate(&info->mr.range[i], buf);
+		xt_xlate_add(xl, "dnat ");
+		print_range_xlate(&info->mr.range[i], xl);
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
-			xt_buf_add(buf, " random");
+			xt_xlate_add(xl, " random");
 			sep_need = true;
 		}
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT) {
 			if (sep_need)
 				sep = ",";
-			xt_buf_add(buf, "%spersistent", sep);
+			xt_xlate_add(xl, "%spersistent", sep);
 		}
 	}
 
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index f2beee3..f3875b6 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -183,19 +183,19 @@ static const struct ipt_log_xlate ipt_log_xlate_names[] = {
 };
 
 static int LOG_xlate(const struct xt_entry_target *target,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	unsigned int i = 0;
 	const struct ipt_log_info *loginfo =
 			(const struct ipt_log_info *)target->data;
 
-	xt_buf_add(buf, "log ");
+	xt_xlate_add(xl, "log ");
 	if (strcmp(loginfo->prefix, "") != 0)
-		xt_buf_add(buf, "prefix \\\"%s\\\" ", loginfo->prefix);
+		xt_xlate_add(xl, "prefix \\\"%s\\\" ", loginfo->prefix);
 
 	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
 		if (loginfo->level == ipt_log_xlate_names[i].level) {
-			xt_buf_add(buf, "level %s ",
+			xt_xlate_add(xl, "level %s ",
 				   ipt_log_xlate_names[i].name);
 			break;
 		}
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 2e5b33d..68efe96 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -136,18 +136,18 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static int REDIRECT_xlate(const struct xt_entry_target *target,
-			  struct xt_buf *buf, int numeric)
+			  struct xt_xlate *xl, int numeric)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =
 					(const void *)target->data;
 	const struct nf_nat_ipv4_range *r = &mr->range[0];
 
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, "redirect to %hu", ntohs(r->min.tcp.port));
+		xt_xlate_add(xl, "redirect to %hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
-			xt_buf_add(buf, "-%hu ", ntohs(r->max.tcp.port));
+			xt_xlate_add(xl, "-%hu ", ntohs(r->max.tcp.port));
 		if (mr->range[0].flags & NF_NAT_RANGE_PROTO_RANDOM)
-			xt_buf_add(buf, " random ");
+			xt_xlate_add(xl, " random ");
 	}
 
 	return 1;
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index dd4ac62..56fc346 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -160,7 +160,7 @@ static const struct reject_names_xlate reject_table_xlate[] = {
 };
 
 static int REJECT_xlate(const struct xt_entry_target *target,
-			struct xt_buf *buf, int numeric)
+			struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_reject_info *reject =
 		(const struct ipt_reject_info *)target->data;
@@ -172,10 +172,10 @@ static int REJECT_xlate(const struct xt_entry_target *target,
 	}
 
 	if (reject->with == IPT_TCP_RESET)
-		xt_buf_add(buf, "reject with %s",
+		xt_xlate_add(xl, "reject with %s",
 			   reject_table_xlate[i].name);
 	else
-		xt_buf_add(buf, "reject with icmp type %s",
+		xt_xlate_add(xl, "reject with icmp type %s",
 			   reject_table_xlate[i].name);
 
 	return 1;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 42fe92d..1962e66 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -253,28 +253,28 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void print_range_xlate(const struct nf_nat_ipv4_range *r,
-			      struct xt_buf *buf)
+			      struct xt_xlate *xl)
 {
 	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		xt_buf_add(buf, "%s", xtables_ipaddr_to_numeric(&a));
+		xt_xlate_add(xl, "%s", xtables_ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			xt_buf_add(buf, "-%s", xtables_ipaddr_to_numeric(&a));
+			xt_xlate_add(xl, "-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_buf_add(buf, ":");
-		xt_buf_add(buf, "%hu", ntohs(r->min.tcp.port));
+		xt_xlate_add(xl, ":");
+		xt_xlate_add(xl, "%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
-			xt_buf_add(buf, "-%hu", ntohs(r->max.tcp.port));
+			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
 	}
 }
 
 static int SNAT_xlate(const struct xt_entry_target *target,
-		      struct xt_buf *buf, int numeric)
+		      struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
@@ -282,22 +282,22 @@ static int SNAT_xlate(const struct xt_entry_target *target,
 	const char *sep = " ";
 
 	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_buf_add(buf, "snat ");
-		print_range_xlate(&info->mr.range[i], buf);
+		xt_xlate_add(xl, "snat ");
+		print_range_xlate(&info->mr.range[i], xl);
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
-			xt_buf_add(buf, " random");
+			xt_xlate_add(xl, " random");
 			sep_need = true;
 		}
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
 			if (sep_need)
 				sep = ",";
-			xt_buf_add(buf, "%sfully-random", sep);
+			xt_xlate_add(xl, "%sfully-random", sep);
 			sep_need = true;
 		}
 		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT) {
 			if (sep_need)
 				sep = ",";
-			xt_buf_add(buf, "%spersistent", sep);
+			xt_xlate_add(xl, "%spersistent", sep);
 		}
 	}
 
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 8973e49..a7d1193 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -93,18 +93,18 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int ah_xlate(const struct xt_entry_match *match,
-		    struct xt_buf *buf, int numeric)
+		    struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
 
 	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_buf_add(buf, "ah spi%s ",
+		xt_xlate_add(xl, "ah spi%s ",
 			   (ahinfo->invflags & IPT_AH_INV_SPI) ? " !=" : "");
 		if (ahinfo->spis[0] != ahinfo->spis[1])
-			xt_buf_add(buf, "%u-%u ", ahinfo->spis[0],
+			xt_xlate_add(xl, "%u-%u ", ahinfo->spis[0],
 				   ahinfo->spis[1]);
 		else
-			xt_buf_add(buf, "%u ", ahinfo->spis[0]);
+			xt_xlate_add(xl, "%u ", ahinfo->spis[0]);
 	}
 
 	return 1;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index d016040..7dba93f 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -110,27 +110,27 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 
 static void
 print_realm_xlate(unsigned long id, unsigned long mask,
-		  int numeric, struct xt_buf *buf, uint32_t op)
+		  int numeric, struct xt_xlate *xl, uint32_t op)
 {
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_buf_add(buf, " and 0x%lx %s 0x%lx ", id,
+		xt_xlate_add(xl, " and 0x%lx %s 0x%lx ", id,
 			   op == XT_OP_EQ ? "==" : "!=", mask);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(realms, id);
 		if (name)
-			xt_buf_add(buf, "%s%s ",
+			xt_xlate_add(xl, "%s%s ",
 				   op == XT_OP_EQ ? "" : "!= ", name);
 		else
-			xt_buf_add(buf, " %s0x%lx ",
+			xt_xlate_add(xl, " %s0x%lx ",
 				   op == XT_OP_EQ ? "" : "!= ", id);
 	}
 }
 
 static int realm_xlate(const struct xt_entry_match *match,
-		       struct xt_buf *buf, int numeric)
+		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_realm_info *ri = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
@@ -138,8 +138,8 @@ static int realm_xlate(const struct xt_entry_match *match,
 	if (ri->invert)
 		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "rtclassid");
-	print_realm_xlate(ri->id, ri->mask, 0, buf, op);
+	xt_xlate_add(xl, "rtclassid");
+	print_realm_xlate(ri->id, ri->mask, 0, xl, op);
 
 	return 1;
 }
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index c952502..bd19cd2 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -101,30 +101,30 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int ttl_xlate(const struct xt_entry_match *match,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_ttl_info *info =
 			(struct ipt_ttl_info *) match->data;
 
 		switch (info->mode) {
 		case IPT_TTL_EQ:
-			xt_buf_add(buf, "ip ttl");
+			xt_xlate_add(xl, "ip ttl");
 			break;
 		case IPT_TTL_NE:
-			xt_buf_add(buf, "ip ttl !=");
+			xt_xlate_add(xl, "ip ttl !=");
 			break;
 		case IPT_TTL_LT:
-			xt_buf_add(buf, "ip ttl lt");
+			xt_xlate_add(xl, "ip ttl lt");
 			break;
 		case IPT_TTL_GT:
-			xt_buf_add(buf, "ip ttl gt");
+			xt_xlate_add(xl, "ip ttl gt");
 			break;
 		default:
 			/* Should not happen. */
 			break;
 	}
 
-	xt_buf_add(buf, " %u ", info->ttl);
+	xt_xlate_add(xl, " %u ", info->ttl);
 
 	return 1;
 }
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 4f9024a..e31a3c4 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -87,24 +87,24 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static void nflog_print_xlate(const struct xt_nflog_info *info,
-			      struct xt_buf *buf)
+			      struct xt_xlate *xl)
 {
-	xt_buf_add(buf, "log ");
+	xt_xlate_add(xl, "log ");
 	if (info->prefix[0] != '\0')
-		xt_buf_add(buf, "prefix \\\"%s\\\" ", info->prefix);
+		xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
 	if (info->len)
-		xt_buf_add(buf, "snaplen %u ", info->len);
+		xt_xlate_add(xl, "snaplen %u ", info->len);
 	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
-		xt_buf_add(buf, "queue-threshold %u ", info->threshold);
-	xt_buf_add(buf, "group %u ", info->group);
+		xt_xlate_add(xl, "queue-threshold %u ", info->threshold);
+	xt_xlate_add(xl, "group %u ", info->group);
 }
 
 static int NFLOG_xlate(const struct xt_entry_target *target,
-		       struct xt_buf *buf, int numeric)
+		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_nflog_info *info = (struct xt_nflog_info *)target->data;
 
-	nflog_print_xlate(info, buf);
+	nflog_print_xlate(info, xl);
 
 	return 1;
 }
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 087d4bf..3d1926f 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -124,18 +124,18 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static void print_mark_xlate(unsigned int mark, unsigned int mask,
-			     struct xt_buf *buf, uint32_t op)
+			     struct xt_xlate *xl, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark,
+		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mark,
 			   op == XT_OP_EQ ? "==" : "!=", mask);
 	else
-		xt_buf_add(buf, " %s0x%x ",
+		xt_xlate_add(xl, " %s0x%x ",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
 static int connmark_xlate(const struct xt_entry_match *match,
-			  struct xt_buf *buf, int numeric)
+			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_connmark_info *info = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
@@ -143,15 +143,15 @@ static int connmark_xlate(const struct xt_entry_match *match,
 	if (info->invert)
 		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "ct mark");
-	print_mark_xlate(info->mark, info->mask, buf, op);
+	xt_xlate_add(xl, "ct mark");
+	print_mark_xlate(info->mark, info->mask, xl, op);
 
 	return 1;
 }
 
 static int
 connmark_mt_xlate(const struct xt_entry_match *match,
-		 struct xt_buf *buf, int numeric)
+		 struct xt_xlate *xl, int numeric)
 {
 	const struct xt_connmark_mtinfo1 *info = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
@@ -159,8 +159,8 @@ connmark_mt_xlate(const struct xt_entry_match *match,
 	if (info->invert)
 		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "ct mark");
-	print_mark_xlate(info->mark, info->mask, buf, op);
+	xt_xlate_add(xl, "ct mark");
+	print_mark_xlate(info->mark, info->mask, xl, op);
 
 	return 1;
 }
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 4c5b6e9..7f66895 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1156,41 +1156,41 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 	state_print_state(sinfo->statemask);
 }
 
-static void state_xlate_print(struct xt_buf *buf, unsigned int statemask)
+static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 {
 	const char *sep = "";
 
 	if (statemask & XT_CONNTRACK_STATE_INVALID) {
-		xt_buf_add(buf, "%s%s", sep, "invalid");
+		xt_xlate_add(xl, "%s%s", sep, "invalid");
 		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
-		xt_buf_add(buf, "%s%s", sep, "new");
+		xt_xlate_add(xl, "%s%s", sep, "new");
 		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
-		xt_buf_add(buf, "%s%s", sep, "related");
+		xt_xlate_add(xl, "%s%s", sep, "related");
 		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
-		xt_buf_add(buf, "%s%s", sep, "established");
+		xt_xlate_add(xl, "%s%s", sep, "established");
 		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
-		xt_buf_add(buf, "%s%s", sep, "untracked");
+		xt_xlate_add(xl, "%s%s", sep, "untracked");
 		sep = ",";
 	}
 }
 
-static int state_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
+static int state_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
 		       int numeric)
 {
 	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
 
-	xt_buf_add(buf, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
+	xt_xlate_add(xl, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
 					"!= " : "");
-	state_xlate_print(buf, sinfo->state_mask);
-	xt_buf_add(buf, " ");
+	state_xlate_print(xl, sinfo->state_mask);
+	xt_xlate_add(xl, " ");
 	return 1;
 }
 
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 74e6077..02286c2 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -45,11 +45,11 @@ static void cpu_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int cpu_xlate(const struct xt_entry_match *match,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_cpu_info *info = (void *)match->data;
 
-	xt_buf_add(buf, "cpu%s %u ", info->invert ? " !=" : "", info->cpu);
+	xt_xlate_add(xl, "cpu%s %u ", info->invert ? " !=" : "", info->cpu);
 
 	return 1;
 }
diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 645f2f3..fd67bc3 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -153,52 +153,52 @@ static void devgroup_check(struct xt_fcheck_call *cb)
 
 static void
 print_devgroup_xlate(unsigned int id, uint32_t op,  unsigned int mask,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	const char *name = NULL;
 
 	if (mask != 0xffffffff)
-		xt_buf_add(buf, "and 0x%x %s 0x%x ", id,
+		xt_xlate_add(xl, "and 0x%x %s 0x%x ", id,
 			   op == XT_OP_EQ ? "==" : "!=", mask);
 	else {
 		if (numeric == 0)
 			name = xtables_lmap_id2name(devgroups, id);
 		if (name)
-			xt_buf_add(buf, "%s ", name);
+			xt_xlate_add(xl, "%s ", name);
 		else
-			xt_buf_add(buf, "%s0x%x ",
+			xt_xlate_add(xl, "%s0x%x ",
 				   op == XT_OP_EQ ? "" : "!= ", id);
 	}
 }
 
 static void devgroup_show_xlate(const struct xt_devgroup_info *info,
-				struct xt_buf *buf, int numeric)
+				struct xt_xlate *xl, int numeric)
 {
 	enum xt_op op = XT_OP_EQ;
 
 	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
 		if (info->flags & XT_DEVGROUP_INVERT_SRC)
 			op = XT_OP_NEQ;
-		xt_buf_add(buf, "iifgroup ");
+		xt_xlate_add(xl, "iifgroup ");
 		print_devgroup_xlate(info->src_group, op,
-				     info->src_mask, buf, numeric);
+				     info->src_mask, xl, numeric);
 	}
 
 	if (info->flags & XT_DEVGROUP_MATCH_DST) {
 		if (info->flags & XT_DEVGROUP_INVERT_DST)
 			op = XT_OP_NEQ;
-		xt_buf_add(buf, "oifgroup ");
+		xt_xlate_add(xl, "oifgroup ");
 		print_devgroup_xlate(info->dst_group, op,
-				     info->dst_mask, buf, numeric);
+				     info->dst_mask, xl, numeric);
 	}
 }
 
 static int devgroup_xlate(const struct xt_entry_match *match,
-			  struct xt_buf *buf, int numeric)
+			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_devgroup_info *info = (const void *)match->data;
 
-	devgroup_show_xlate(info, buf, 0);
+	devgroup_show_xlate(info, xl, 0);
 
 	return 1;
 }
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index e04daf8..b5219fd 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -87,18 +87,18 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int esp_xlate(const struct xt_entry_match *match,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
 
 	if (!(espinfo->spis[0] == 0 && espinfo->spis[1] == 0xFFFFFFFF)) {
-		xt_buf_add(buf, "esp spi%s",
+		xt_xlate_add(xl, "esp spi%s",
 			   (espinfo->invflags & XT_ESP_INV_SPI) ? " !=" : "");
 		if (espinfo->spis[0] != espinfo->spis[1])
-			xt_buf_add(buf, " %u-%u ", espinfo->spis[0],
+			xt_xlate_add(xl, " %u-%u ", espinfo->spis[0],
 				   espinfo->spis[1]);
 		else
-			xt_buf_add(buf, " %u ", espinfo->spis[0]);
+			xt_xlate_add(xl, " %u ", espinfo->spis[0]);
 	}
 
 	return 1;
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 971ce4a..9df4163 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -46,11 +46,11 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int helper_xlate(const struct xt_entry_match *match,
-			struct xt_buf *buf, int numeric)
+			struct xt_xlate *xl, int numeric)
 {
 	const struct xt_helper_info *info = (const void *)match->data;
 
-	xt_buf_add(buf, "ct helper%s \\\"%s\\\" ",
+	xt_xlate_add(xl, "ct helper%s \\\"%s\\\" ",
 		   info->invert ? " !=" : "", info->name);
 
 	return 1;
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 9cf6225..0b05651 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -304,57 +304,57 @@ static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
 
 static void
 print_iprange_xlate(const struct ipt_iprange *range,
-		    struct xt_buf *buf)
+		    struct xt_xlate *xl)
 {
 	const unsigned char *byte_min, *byte_max;
 
 	byte_min = (const unsigned char *)&range->min_ip;
 	byte_max = (const unsigned char *)&range->max_ip;
-	xt_buf_add(buf, " %u.%u.%u.%u-%u.%u.%u.%u ",
+	xt_xlate_add(xl, " %u.%u.%u.%u-%u.%u.%u.%u ",
 		   byte_min[0], byte_min[1], byte_min[2], byte_min[3],
 		   byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
 }
 
 static int iprange_xlate(const struct xt_entry_match *match,
-			 struct xt_buf *buf, int numeric)
+			 struct xt_xlate *xl, int numeric)
 {
 	const struct ipt_iprange_info *info = (const void *)match->data;
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip saddr");
-		print_iprange_xlate(&info->src, buf);
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip saddr");
+		print_iprange_xlate(&info->src, xl);
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip daddr");
-		print_iprange_xlate(&info->dst, buf);
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip daddr");
+		print_iprange_xlate(&info->dst, xl);
 	}
 
 	return 1;
 }
 
 static int iprange_mt4_xlate(const struct xt_entry_match *match,
-			     struct xt_buf *buf, int numeric)
+			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip saddr %s",
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip saddr %s",
 			   xtables_ipaddr_to_numeric(&info->src_min.in));
-		xt_buf_add(buf, "-%s ",
+		xt_xlate_add(xl, "-%s ",
 			   xtables_ipaddr_to_numeric(&info->src_max.in));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip daddr %s",
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip daddr %s",
 			   xtables_ipaddr_to_numeric(&info->dst_min.in));
-		xt_buf_add(buf, "-%s ",
+		xt_xlate_add(xl, "-%s ",
 			   xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 
@@ -362,24 +362,24 @@ static int iprange_mt4_xlate(const struct xt_entry_match *match,
 }
 
 static int iprange_mt6_xlate(const struct xt_entry_match *match,
-			     struct xt_buf *buf, int numeric)
+			     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
 
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip saddr %s",
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip saddr %s",
 			   xtables_ip6addr_to_numeric(&info->src_min.in6));
-		xt_buf_add(buf, "-%s ",
+		xt_xlate_add(xl, "-%s ",
 			   xtables_ip6addr_to_numeric(&info->src_max.in6));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
-			xt_buf_add(buf, " !=");
-		xt_buf_add(buf, " ip daddr %s",
+			xt_xlate_add(xl, " !=");
+		xt_xlate_add(xl, " ip daddr %s",
 			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
-		xt_buf_add(buf, "-%s ",
+		xt_xlate_add(xl, "-%s ",
 			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 96dab0c..00acae0 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -57,15 +57,15 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static int length_xlate(const struct xt_entry_match *match,
-			struct xt_buf *buf, int numeric)
+			struct xt_xlate *xl, int numeric)
 {
 	const struct xt_length_info *info = (void *)match->data;
 
-	xt_buf_add(buf, "meta length %s", info->invert ? "!= " : "");
+	xt_xlate_add(xl, "meta length %s", info->invert ? "!= " : "");
 	if (info->min == info->max)
-		xt_buf_add(buf, "%u ", info->min);
+		xt_xlate_add(xl, "%u ", info->min);
 	else
-		xt_buf_add(buf, "%u-%u ", info->min, info->max);
+		xt_xlate_add(xl, "%u-%u ", info->min, info->max);
 
 	return 1;
 }
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index a018f87..9ad00c1 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -159,12 +159,12 @@ static const struct rates rates_xlate[] = {
 	{ "second",	XT_LIMIT_SCALE }
 };
 
-static void print_rate_xlate(uint32_t period, struct xt_buf *buf)
+static void print_rate_xlate(uint32_t period, struct xt_xlate *xl)
 {
 	unsigned int i;
 
 	if (period == 0) {
-		xt_buf_add(buf, " %f ", INFINITY);
+		xt_xlate_add(xl, " %f ", INFINITY);
 		return;
 	}
 
@@ -173,19 +173,19 @@ static void print_rate_xlate(uint32_t period, struct xt_buf *buf)
 		    rates_xlate[i].mult / period < rates_xlate[i].mult % period)
 			break;
 
-	xt_buf_add(buf, " %u/%s ", rates_xlate[i - 1].mult / period,
+	xt_xlate_add(xl, " %u/%s ", rates_xlate[i - 1].mult / period,
 		   rates_xlate[i - 1].name);
 }
 
 static int limit_xlate(const struct xt_entry_match *match,
-		       struct xt_buf *buf, int numeric)
+		       struct xt_xlate *xl, int numeric)
 {
 	const struct xt_rateinfo *r = (const void *)match->data;
 
-	xt_buf_add(buf, "limit rate");
-	print_rate_xlate(r->avg, buf);
+	xt_xlate_add(xl, "limit rate");
+	print_rate_xlate(r->avg, xl);
 	if (r->burst != XT_LIMIT_BURST)
-		xt_buf_add(buf, "burst %u packets ", r->burst);
+		xt_xlate_add(xl, "burst %u packets ", r->burst);
 
 	return 1;
 }
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index d730344..85ed1b5 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -71,23 +71,23 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static void print_mac_xlate(const unsigned char *macaddress,
-			    struct xt_buf *buf)
+			    struct xt_xlate *xl)
 {
 	unsigned int i;
 
-	xt_buf_add(buf, "%02x", macaddress[0]);
+	xt_xlate_add(xl, "%02x", macaddress[0]);
 	for (i = 1; i < ETH_ALEN; ++i)
-		xt_buf_add(buf, ":%02x", macaddress[i]);
-	xt_buf_add(buf, " ");
+		xt_xlate_add(xl, ":%02x", macaddress[i]);
+	xt_xlate_add(xl, " ");
 }
 
 static int mac_xlate(const struct xt_entry_match *match,
-		     struct xt_buf *buf, int numeric)
+		     struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mac_info *info = (void *)match->data;
 
-	xt_buf_add(buf, "ether saddr%s ", info->invert ? " !=" : "");
-	print_mac_xlate(info->srcaddr, buf);
+	xt_xlate_add(xl, "ether saddr%s ", info->invert ? " !=" : "");
+	print_mac_xlate(info->srcaddr, xl);
 
 	return 1;
 }
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 93d38d9..b8c0ed6 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -103,20 +103,20 @@ mark_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static void
-print_mark_xlate(struct xt_buf *buf, unsigned int mark,
+print_mark_xlate(struct xt_xlate *xl, unsigned int mark,
 		 unsigned int mask, uint32_t op)
 {
 	if (mask != 0xffffffffU)
-		xt_buf_add(buf, " and 0x%x %s 0x%x ", mark,
+		xt_xlate_add(xl, " and 0x%x %s 0x%x ", mark,
 			   op == XT_OP_EQ ? "==" : "!=", mask);
 	else
-		xt_buf_add(buf, " %s0x%x ",
+		xt_xlate_add(xl, " %s0x%x ",
 			   op == XT_OP_EQ ? "" : "!= ", mark);
 }
 
 static int
 mark_mt_xlate(const struct xt_entry_match *match,
-	      struct xt_buf *buf, int numeric)
+	      struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mark_mtinfo1 *info = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
@@ -124,15 +124,15 @@ mark_mt_xlate(const struct xt_entry_match *match,
 	if (info->invert)
 		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "mark");
-	print_mark_xlate(buf, info->mark, info->mask, op);
+	xt_xlate_add(xl, "mark");
+	print_mark_xlate(xl, info->mark, info->mask, op);
 
 	return 1;
 }
 
 static int
 mark_xlate(const struct xt_entry_match *match,
-	   struct xt_buf *buf, int numeric)
+	   struct xt_xlate *xl, int numeric)
 {
 	const struct xt_mark_info *info = (const void *)match->data;
 	enum xt_op op = XT_OP_EQ;
@@ -140,8 +140,8 @@ mark_xlate(const struct xt_entry_match *match,
 	if (info->invert)
 		op = XT_OP_NEQ;
 
-	xt_buf_add(buf, "mark");
-	print_mark_xlate(buf, info->mark, info->mask, op);
+	xt_xlate_add(xl, "mark");
+	print_mark_xlate(xl, info->mark, info->mask, op);
 
 	return 1;
 }
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index f572e83..55edf27 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -127,26 +127,26 @@ static const struct pkttypes_xlate supported_types_xlate[] = {
 };
 
 static void print_pkttype_xlate(const struct xt_pkttype_info *info,
-				struct xt_buf *buf)
+				struct xt_xlate *xl)
 {
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(supported_types_xlate); ++i) {
 		if (supported_types_xlate[i].pkttype == info->pkttype) {
-			xt_buf_add(buf, "%s ", supported_types_xlate[i].name);
+			xt_xlate_add(xl, "%s ", supported_types_xlate[i].name);
 			return;
 		}
 	}
-	xt_buf_add(buf, "%d", info->pkttype);
+	xt_xlate_add(xl, "%d", info->pkttype);
 }
 
 static int pkttype_xlate(const struct xt_entry_match *match,
-			  struct xt_buf *buf, int numeric)
+			  struct xt_xlate *xl, int numeric)
 {
 	const struct xt_pkttype_info *info = (const void *)match->data;
 
-	xt_buf_add(buf, "pkttype%s ", info->invert ? " !=" : "");
-	print_pkttype_xlate(info, buf);
+	xt_xlate_add(xl, "pkttype%s ", info->invert ? " !=" : "");
+	print_pkttype_xlate(info, xl);
 
 	return 1;
 }
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 2a454ea..bd4ca77 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -371,7 +371,7 @@ static const struct tcp_flag_names tcp_flag_names_xlate[] = {
 	{ "urg", 0x20 },
 };
 
-static void print_tcp_xlate(struct xt_buf *buf, uint8_t flags)
+static void print_tcp_xlate(struct xt_xlate *xl, uint8_t flags)
 {
 	int have_flag = 0;
 
@@ -381,31 +381,31 @@ static void print_tcp_xlate(struct xt_buf *buf, uint8_t flags)
 		for (i = 0; (flags & tcp_flag_names_xlate[i].flag) == 0; i++);
 
 		if (have_flag)
-			xt_buf_add(buf, "|");
+			xt_xlate_add(xl, "|");
 
-		xt_buf_add(buf, "%s", tcp_flag_names_xlate[i].name);
+		xt_xlate_add(xl, "%s", tcp_flag_names_xlate[i].name);
 		have_flag = 1;
 
 		flags &= ~tcp_flag_names_xlate[i].flag;
 	}
 
 	if (!have_flag)
-		xt_buf_add(buf, "none");
+		xt_xlate_add(xl, "none");
 }
 
-static int tcp_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
+static int tcp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
 		     int numeric)
 {
 	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)match->data;
 
 	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
 		if (tcpinfo->spts[0] != tcpinfo->spts[1]) {
-			xt_buf_add(buf, "tcp sport %s%u-%u ",
+			xt_xlate_add(xl, "tcp sport %s%u-%u ",
 				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
 					"!= " : "",
 				   tcpinfo->spts[0], tcpinfo->spts[1]);
 		} else {
-			xt_buf_add(buf, "tcp sport %s%u ",
+			xt_xlate_add(xl, "tcp sport %s%u ",
 				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
 					"!= " : "",
 				   tcpinfo->spts[0]);
@@ -414,12 +414,12 @@ static int tcp_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
 
 	if (tcpinfo->dpts[0] != 0 || tcpinfo->dpts[1] != 0xffff) {
 		if (tcpinfo->dpts[0] != tcpinfo->dpts[1]) {
-			xt_buf_add(buf, "tcp dport %s%u-%u ",
+			xt_xlate_add(xl, "tcp dport %s%u-%u ",
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0], tcpinfo->dpts[1]);
 		} else {
-			xt_buf_add(buf, "tcp dport %s%u ",
+			xt_xlate_add(xl, "tcp dport %s%u ",
 				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
 					"!= " : "",
 				   tcpinfo->dpts[0]);
@@ -431,12 +431,12 @@ static int tcp_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
 		return 0;
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
-		xt_buf_add(buf, "tcp flags & ");
-		print_tcp_xlate(buf, tcpinfo->flg_mask);
-		xt_buf_add(buf, " %s ",
+		xt_xlate_add(xl, "tcp flags & ");
+		print_tcp_xlate(xl, tcpinfo->flg_mask);
+		xt_xlate_add(xl, " %s ",
 			   tcpinfo->invflags & XT_TCP_INV_FLAGS ? "!=": "==");
-		print_tcp_xlate(buf, tcpinfo->flg_cmp);
-		xt_buf_add(buf, " ");
+		print_tcp_xlate(xl, tcpinfo->flg_cmp);
+		xt_xlate_add(xl, " ");
 	}
 
 	return 1;
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 0b89df4..47c29e9 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -152,19 +152,19 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
-static int udp_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
+static int udp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
 		     int numeric)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
 
 	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
 		if (udpinfo->spts[0] != udpinfo->spts[1]) {
-			xt_buf_add(buf,"udp sport %s%u-%u ",
+			xt_xlate_add(xl,"udp sport %s%u-%u ",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->spts[0], udpinfo->spts[1]);
 		} else {
-			xt_buf_add(buf, "udp sport %s%u ",
+			xt_xlate_add(xl, "udp sport %s%u ",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->spts[0]);
@@ -173,12 +173,12 @@ static int udp_xlate(const struct xt_entry_match *match, struct xt_buf *buf,
 
 	if (udpinfo->dpts[0] != 0 || udpinfo->dpts[1] != 0xFFFF) {
 		if (udpinfo->dpts[0]  != udpinfo->dpts[1]) {
-			xt_buf_add(buf,"udp dport %s%u-%u ",
+			xt_xlate_add(xl,"udp dport %s%u-%u ",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0], udpinfo->dpts[1]);
 		} else {
-			xt_buf_add(buf,"udp dport %s%u ",
+			xt_xlate_add(xl,"udp dport %s%u ",
 				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
 					 "!= ": "",
 				   udpinfo->dpts[0]);
diff --git a/include/xtables.h b/include/xtables.h
index 175ae50..82aa2bb 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -205,7 +205,7 @@ enum xtables_ext_flags {
 	XTABLES_EXT_ALIAS = 1 << 0,
 };
 
-struct xt_buf;
+struct xt_xlate;
 
 /* Include file for additions: new matches and targets. */
 struct xtables_match
@@ -272,7 +272,7 @@ struct xtables_match
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const struct xt_entry_match *match, struct xt_buf *buf,
+	int (*xlate)(const struct xt_entry_match *match, struct xt_xlate *xl,
 		     int numeric);
 
 	/* Size of per-extension instance extra "global" scratch space */
@@ -353,7 +353,7 @@ struct xtables_target
 	const struct xt_option_entry *x6_options;
 
 	/* Translate iptables to nft */
-	int (*xlate)(const struct xt_entry_target *target, struct xt_buf *buf,
+	int (*xlate)(const struct xt_entry_target *target, struct xt_xlate *xl,
 		     int numeric);
 
 	size_t udata_size;
@@ -569,11 +569,11 @@ extern void xtables_lmap_free(struct xtables_lmap *);
 extern int xtables_lmap_name2id(const struct xtables_lmap *, const char *);
 extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
 
-/* generic buffer */
-struct xt_buf *xt_buf_alloc(int size);
-void xt_buf_free(struct xt_buf *buf);
-void xt_buf_add(struct xt_buf *buf, const char *fmt, ...);
-const char *xt_buf_get(struct xt_buf *buf);
+/* xlate infrastructure */
+struct xt_xlate *xt_xlate_alloc(int size);
+void xt_xlate_free(struct xt_xlate *xl);
+void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...);
+const char *xt_xlate_get(struct xt_xlate *xl);
 
 #ifdef XTABLES_INTERNAL
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ede8f17..5e2857d 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -429,24 +429,24 @@ static void nft_ipv4_save_counters(const void *data)
 	save_counters(cs->counters.pcnt, cs->counters.bcnt);
 }
 
-static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
+static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
 
 	if (cs->fw.ip.iniface[0] != '\0') {
-		xt_buf_add(buf, "iifname %s%s ",
+		xt_xlate_add(xl, "iifname %s%s ",
 			   cs->fw.ip.invflags & IPT_INV_VIA_IN ? "!= " : "",
 			   cs->fw.ip.iniface);
 	}
 	if (cs->fw.ip.outiface[0] != '\0') {
-		xt_buf_add(buf, "oifname %s%s ",
+		xt_xlate_add(xl, "oifname %s%s ",
 			   cs->fw.ip.invflags & IPT_INV_VIA_OUT? "!= " : "",
 			   cs->fw.ip.outiface);
 	}
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
-		xt_buf_add(buf, "ip frag-off %s%x ",
+		xt_xlate_add(xl, "ip frag-off %s%x ",
 			   cs->fw.ip.invflags & IPT_INV_FRAG? "" : "!= ", 0);
 	}
 
@@ -459,7 +459,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 			snprintf(protonum, sizeof(protonum), "%u",
 				 cs->fw.ip.proto);
 			protonum[sizeof(protonum) - 1] = '\0';
-			xt_buf_add(buf, "ip protocol %s%s ",
+			xt_xlate_add(xl, "ip protocol %s%s ",
 				   cs->fw.ip.invflags & IPT_INV_PROTO ?
 					"!= " : "",
 				   pent ? pent->p_name : protonum);
@@ -467,24 +467,24 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 	}
 
 	if (cs->fw.ip.src.s_addr != 0) {
-		xt_buf_add(buf, "ip saddr %s%s ",
+		xt_xlate_add(xl, "ip saddr %s%s ",
 			   cs->fw.ip.invflags & IPT_INV_SRCIP ? "!= " : "",
 			   inet_ntoa(cs->fw.ip.src));
 	}
 	if (cs->fw.ip.dst.s_addr != 0) {
-		xt_buf_add(buf, "ip daddr %s%s ",
+		xt_xlate_add(xl, "ip daddr %s%s ",
 			   cs->fw.ip.invflags & IPT_INV_DSTIP ? "!= " : "",
 			   inet_ntoa(cs->fw.ip.dst));
 	}
 
-	ret = xlate_matches(cs, buf);
+	ret = xlate_matches(cs, xl);
 	if (!ret)
 		return ret;
 
 	/* Always add counters per rule, as in iptables */
-	xt_buf_add(buf, "counter ");
+	xt_xlate_add(xl, "counter ");
 
-	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), buf);
+	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
 	return ret;
 }
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0b6ff97..77ac5b8 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -378,7 +378,7 @@ static void nft_ipv6_save_counters(const void *data)
 }
 
 static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
-			    int invert, struct xt_buf *buf)
+			    int invert, struct xt_xlate *xl)
 {
 	char addr_str[INET6_ADDRSTRLEN];
 
@@ -386,22 +386,22 @@ static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 		return;
 
 	inet_ntop(AF_INET6, addr, addr_str, INET6_ADDRSTRLEN);
-	xt_buf_add(buf, "%s %s%s ", selector, invert ? "!= " : "", addr_str);
+	xt_xlate_add(xl, "%s %s%s ", selector, invert ? "!= " : "", addr_str);
 }
 
-static int nft_ipv6_xlate(const void *data, struct xt_buf *buf)
+static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
-		xt_buf_add(buf, "iifname %s%s ",
+		xt_xlate_add(xl, "iifname %s%s ",
 			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_IN ?
 				"!= " : "",
 			   cs->fw6.ipv6.iniface);
 	}
 	if (cs->fw6.ipv6.outiface[0] != '\0') {
-		xt_buf_add(buf, "oifname %s%s ",
+		xt_xlate_add(xl, "oifname %s%s ",
 			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT ?
 				"!= " : "",
 			   cs->fw6.ipv6.outiface);
@@ -416,7 +416,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_buf *buf)
 			snprintf(protonum, sizeof(protonum), "%u",
 				 cs->fw6.ipv6.proto);
 			protonum[sizeof(protonum) - 1] = '\0';
-			xt_buf_add(buf, "ip6 nexthdr %s%s ",
+			xt_xlate_add(xl, "ip6 nexthdr %s%s ",
 				   cs->fw6.ipv6.invflags & IP6T_INV_PROTO ?
 					"!= " : "",
 				   pent ? pent->p_name : protonum);
@@ -424,18 +424,18 @@ static int nft_ipv6_xlate(const void *data, struct xt_buf *buf)
 	}
 
 	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src,
-			cs->fw6.ipv6.invflags & IP6T_INV_SRCIP, buf);
+			cs->fw6.ipv6.invflags & IP6T_INV_SRCIP, xl);
 	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst,
-			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, buf);
+			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, xl);
 
-	ret = xlate_matches(cs, buf);
+	ret = xlate_matches(cs, xl);
 	if (!ret)
 		return ret;
 
 	/* Always add counters per rule, as in iptables */
-	xt_buf_add(buf, "counter ");
+	xt_xlate_add(xl, "counter ");
 
-	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), buf);
+	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
 	return ret;
 }
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 7386183..c0948fd 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -37,7 +37,7 @@
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
 struct xtables_args;
-struct xt_buf;
+struct xt_xlate;
 
 enum {
 	NFT_XT_CTX_PAYLOAD	= (1 << 0),
@@ -102,7 +102,7 @@ struct nft_family_ops {
 	void (*parse_target)(struct xtables_target *t, void *data);
 	bool (*rule_find)(struct nft_family_ops *ops, struct nftnl_rule *r,
 			  void *data);
-	int (*xlate)(const void *data, struct xt_buf *buf);
+	int (*xlate)(const void *data, struct xt_xlate *xl);
 };
 
 void add_meta(struct nftnl_rule *r, uint32_t key);
diff --git a/iptables/nft.h b/iptables/nft.h
index 192050a..281e1c6 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -161,9 +161,9 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename, uint32_t
 struct xt_buf;
 
 bool xlate_find_match(const struct iptables_command_state *cs, const char *p_name);
-int xlate_matches(const struct iptables_command_state *cs, struct xt_buf *buf);
+int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl);
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
-		 struct xt_buf *buf);
+		 struct xt_xlate *xl);
 
 /*
  * ARP
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 30028c3..9e2c6ae 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -35,7 +35,7 @@
 #include "nft-shared.h"
 
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
-		 struct xt_buf *buf)
+		 struct xt_xlate *xl)
 {
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
 
@@ -43,27 +43,27 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 	if (cs->target != NULL) {
 		/* Standard target? */
 		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
-			xt_buf_add(buf, "accept");
+			xt_xlate_add(xl, "accept");
 		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
-			xt_buf_add(buf, "drop");
+			xt_xlate_add(xl, "drop");
 		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
-			xt_buf_add(buf, "return");
+			xt_xlate_add(xl, "return");
 		else if (cs->target->xlate)
-			ret = cs->target->xlate(cs->target->t, buf, numeric);
+			ret = cs->target->xlate(cs->target->t, xl, numeric);
 		else
 			return 0;
 	} else if (strlen(cs->jumpto) > 0) {
 		/* Not standard, then it's a go / jump to chain */
 		if (goto_set)
-			xt_buf_add(buf, "goto %s", cs->jumpto);
+			xt_xlate_add(xl, "goto %s", cs->jumpto);
 		else
-			xt_buf_add(buf, "jump %s", cs->jumpto);
+			xt_xlate_add(xl, "jump %s", cs->jumpto);
 	}
 
 	return ret;
 }
 
-int xlate_matches(const struct iptables_command_state *cs, struct xt_buf *buf)
+int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 {
 	struct xtables_rule_match *matchp;
 	int ret = 1, numeric = cs->options & OPT_NUMERIC;
@@ -72,7 +72,7 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_buf *buf)
 		if (!matchp->match->xlate)
 			return 0;
 
-		ret = matchp->match->xlate(matchp->match->m, buf, numeric);
+		ret = matchp->match->xlate(matchp->match->m, xl, numeric);
 		if (!ret)
 			break;
 	}
@@ -101,22 +101,22 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 			      const struct iptables_command_state *cs,
 			      bool append)
 {
-	struct xt_buf *buf = xt_buf_alloc(10240);
+	struct xt_xlate *xl = xt_xlate_alloc(10240);
 	int ret;
 
 	if (append) {
-		xt_buf_add(buf, "add rule %s %s %s ",
+		xt_xlate_add(xl, "add rule %s %s %s ",
 			   family2str[h->family], p->table, p->chain);
 	} else {
-		xt_buf_add(buf, "insert rule %s %s %s ",
+		xt_xlate_add(xl, "insert rule %s %s %s ",
 			   family2str[h->family], p->table, p->chain);
 	}
 
-	ret = h->ops->xlate(cs, buf);
+	ret = h->ops->xlate(cs, xl);
 	if (ret)
-		printf("%s\n", xt_buf_get(buf));
+		printf("%s\n", xt_xlate_get(xl));
 
-	xt_buf_free(buf);
+	xt_xlate_free(xl);
 	return ret;
 }
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 21e515d..32d6a5a 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1987,54 +1987,54 @@ void get_kernel_version(void)
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
-struct xt_buf {
+struct xt_xlate {
 	char	*data;
 	int	size;
 	int	rem;
 	int	off;
 };
 
-struct xt_buf *xt_buf_alloc(int size)
+struct xt_xlate *xt_xlate_alloc(int size)
 {
-	struct xt_buf *buf;
+	struct xt_xlate *xl;
 
-	buf = malloc(sizeof(struct xt_buf));
-	if (buf == NULL)
+	xl = malloc(sizeof(struct xt_xlate));
+	if (xl == NULL)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	buf->data = malloc(size);
-	if (buf->data == NULL)
+	xl->data = malloc(size);
+	if (xl->data == NULL)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
-	buf->size = size;
-	buf->rem = size;
-	buf->off = 0;
+	xl->size = size;
+	xl->rem = size;
+	xl->off = 0;
 
-	return buf;
+	return xl;
 }
 
-void xt_buf_free(struct xt_buf *buf)
+void xt_xlate_free(struct xt_xlate *xl)
 {
-	free(buf->data);
-	free(buf);
+	free(xl->data);
+	free(xl);
 }
 
-void xt_buf_add(struct xt_buf *buf, const char *fmt, ...)
+void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...)
 {
 	va_list ap;
 	int len;
 
 	va_start(ap, fmt);
-	len = vsnprintf(buf->data + buf->off, buf->rem, fmt, ap);
-	if (len < 0 || len >= buf->rem)
+	len = vsnprintf(xl->data + xl->off, xl->rem, fmt, ap);
+	if (len < 0 || len >= xl->rem)
 		xtables_error(RESOURCE_PROBLEM, "OOM");
 
 	va_end(ap);
-	buf->rem -= len;
-	buf->off += len;
+	xl->rem -= len;
+	xl->off += len;
 }
 
-const char *xt_buf_get(struct xt_buf *buf)
+const char *xt_xlate_get(struct xt_xlate *xl)
 {
-	return buf->data;
+	return xl->data;
 }
-- 
2.1.4

