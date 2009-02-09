From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/16] libxtables: prefix/order - ascii to ipaddr/ipmask input
Date: Mon,  9 Feb 2009 18:34:55 +0100
Message-ID: <1234200900-5964-12-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZBIRfF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:05 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c   |    4 ++--
 extensions/libipt_NETMAP.c |    4 ++--
 extensions/libipt_SAME.c   |    4 ++--
 extensions/libipt_SNAT.c   |    4 ++--
 extensions/libxt_TPROXY.c  |    2 +-
 extensions/libxt_iprange.c |   20 ++++++++++----------
 include/xtables.h.in       |    6 +++---
 xtables.c                  |   14 +++++++-------
 8 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 42695bb..0d355a0 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -117,13 +117,13 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	if (dash)
 		*dash = '\0';
 
-	ip = numeric_to_ipaddr(arg);
+	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
-		ip = numeric_to_ipaddr(dash+1);
+		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 33f48c9..f6c8bfd 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -75,14 +75,14 @@ parse_to(char *arg, struct ip_nat_range *range)
 	if (slash)
 		*slash = '\0';
 
-	ip = numeric_to_ipaddr(arg);
+	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 	if (slash) {
 		if (strchr(slash+1, '.')) {
-			ip = numeric_to_ipmask(slash+1);
+			ip = xtables_numeric_to_ipmask(slash+1);
 			if (!ip)
 				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
 					   slash+1);
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 1ca38ff..6882242 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -56,14 +56,14 @@ parse_to(char *arg, struct ip_nat_range *range)
 	if (dash)
 		*dash = '\0';
 
-	ip = numeric_to_ipaddr(arg);
+	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash) {
-		ip = numeric_to_ipaddr(dash+1);
+		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 2afcbb1..0780aa1 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -117,13 +117,13 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	if (dash)
 		*dash = '\0';
 
-	ip = numeric_to_ipaddr(arg);
+	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
-		ip = numeric_to_ipaddr(dash+1);
+		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 2398c84..54ae96d 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -50,7 +50,7 @@ static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info
 {
 	struct in_addr *laddr;
 
-	if ((laddr = numeric_to_ipaddr(s)) == NULL)
+	if ((laddr = xtables_numeric_to_ipaddr(s)) == NULL)
 		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-ip", s);
 
 	info->laddr = laddr->s_addr;
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 9fdc70a..de079cb 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -40,14 +40,14 @@ parse_iprange(char *arg, struct ipt_iprange *range)
 	if (dash != NULL)
 		*dash = '\0';
 
-	ip = numeric_to_ipaddr(arg);
+	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash != NULL) {
-		ip = numeric_to_ipaddr(dash+1);
+		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
 				   dash+1);
@@ -112,11 +112,11 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (end == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
-		ia = numeric_to_ipaddr(optarg);
+		ia = xtables_numeric_to_ipaddr(optarg);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
-		ia = numeric_to_ipaddr(end+1);
+		ia = xtables_numeric_to_ipaddr(end+1);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
@@ -131,11 +131,11 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (end == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
-		ia = numeric_to_ipaddr(optarg);
+		ia = xtables_numeric_to_ipaddr(optarg);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
-		ia = numeric_to_ipaddr(end + 1);
+		ia = xtables_numeric_to_ipaddr(end + 1);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
@@ -162,11 +162,11 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (end == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
-		ia = numeric_to_ip6addr(optarg);
+		ia = xtables_numeric_to_ip6addr(optarg);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
-		ia = numeric_to_ip6addr(end+1);
+		ia = xtables_numeric_to_ip6addr(end+1);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
@@ -181,11 +181,11 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (end == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
-		ia = numeric_to_ip6addr(optarg);
+		ia = xtables_numeric_to_ip6addr(optarg);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
-		ia = numeric_to_ip6addr(end + 1);
+		ia = xtables_numeric_to_ip6addr(end + 1);
 		if (ia == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 3099de8..936bbcc 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -210,12 +210,12 @@ extern void xtables_param_act(unsigned int, const char *, ...);
 extern const char *xtables_ipaddr_to_numeric(const struct in_addr *);
 extern const char *xtables_ipaddr_to_anyname(const struct in_addr *);
 extern const char *xtables_ipmask_to_numeric(const struct in_addr *);
-extern struct in_addr *numeric_to_ipaddr(const char *);
-extern struct in_addr *numeric_to_ipmask(const char *);
+extern struct in_addr *xtables_numeric_to_ipaddr(const char *);
+extern struct in_addr *xtables_numeric_to_ipmask(const char *);
 extern void ipparse_hostnetworkmask(const char *, struct in_addr **,
 	struct in_addr *, unsigned int *);
 
-extern struct in6_addr *numeric_to_ip6addr(const char *);
+extern struct in6_addr *xtables_numeric_to_ip6addr(const char *);
 extern const char *xtables_ip6addr_to_numeric(const struct in6_addr *);
 extern const char *xtables_ip6addr_to_anyname(const struct in6_addr *);
 extern const char *xtables_ip6mask_to_numeric(const struct in6_addr *);
diff --git a/xtables.c b/xtables.c
index 07275f6..859a82a 100644
--- a/xtables.c
+++ b/xtables.c
@@ -860,12 +860,12 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 	return &addr;
 }
 
-struct in_addr *numeric_to_ipaddr(const char *dotted)
+struct in_addr *xtables_numeric_to_ipaddr(const char *dotted)
 {
 	return __numeric_to_ipaddr(dotted, false);
 }
 
-struct in_addr *numeric_to_ipmask(const char *dotted)
+struct in_addr *xtables_numeric_to_ipmask(const char *dotted)
 {
 	return __numeric_to_ipaddr(dotted, true);
 }
@@ -914,7 +914,7 @@ ipparse_hostnetwork(const char *name, unsigned int *naddrs)
 {
 	struct in_addr *addrptmp, *addrp;
 
-	if ((addrptmp = numeric_to_ipaddr(name)) != NULL ||
+	if ((addrptmp = xtables_numeric_to_ipaddr(name)) != NULL ||
 	    (addrptmp = network_to_ipaddr(name)) != NULL) {
 		addrp = xtables_malloc(sizeof(struct in_addr));
 		memcpy(addrp, addrptmp, sizeof(*addrp));
@@ -938,7 +938,7 @@ static struct in_addr *parse_ipmask(const char *mask)
 		maskaddr.s_addr = 0xFFFFFFFF;
 		return &maskaddr;
 	}
-	if ((addrp = numeric_to_ipmask(mask)) != NULL)
+	if ((addrp = xtables_numeric_to_ipmask(mask)) != NULL)
 		/* dotted_to_addr already returns a network byte order addr */
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 32))
@@ -1068,7 +1068,7 @@ const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 	return buf;
 }
 
-struct in6_addr *numeric_to_ip6addr(const char *num)
+struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
 {
 	static struct in6_addr ap;
 	int err;
@@ -1136,7 +1136,7 @@ ip6parse_hostnetwork(const char *name, unsigned int *naddrs)
 {
 	struct in6_addr *addrp, *addrptmp;
 
-	if ((addrptmp = numeric_to_ip6addr(name)) != NULL ||
+	if ((addrptmp = xtables_numeric_to_ip6addr(name)) != NULL ||
 	    (addrptmp = network_to_ip6addr(name)) != NULL) {
 		addrp = xtables_malloc(sizeof(struct in6_addr));
 		memcpy(addrp, addrptmp, sizeof(*addrp));
@@ -1160,7 +1160,7 @@ static struct in6_addr *parse_ip6mask(char *mask)
 		memset(&maskaddr, 0xff, sizeof maskaddr);
 		return &maskaddr;
 	}
-	if ((addrp = numeric_to_ip6addr(mask)) != NULL)
+	if ((addrp = xtables_numeric_to_ip6addr(mask)) != NULL)
 		return addrp;
 	if (!xtables_strtoui(mask, NULL, &bits, 0, 128))
 		exit_error(PARAMETER_PROBLEM,
-- 
1.6.1.2

