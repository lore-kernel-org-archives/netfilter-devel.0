From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] iprange: do accept non-ranges for xt_iprange v1
Date: Wed, 23 Sep 2009 23:26:31 +0200
Message-ID: <1253741194-26060-2-git-send-email-jengelh@medozas.de>
References: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52870 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZIWV0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:26:36 -0400
In-Reply-To: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugs.debian.org/547139

iprange v0 used to accept single addresses and treat them as a range
of size 1, but this was so far absent in v1, and this patch adds
recognition for such non-range specifications.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |  119 +++++++++++++++++--------------------------
 1 files changed, 47 insertions(+), 72 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 7b3ccc2..fc9abbb 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -20,8 +20,8 @@ static void iprange_mt_help(void)
 {
 	printf(
 "iprange match options:\n"
-"[!] --src-range ip-ip        Match source IP in the specified range\n"
-"[!] --dst-range ip-ip        Match destination IP in the specified range\n");
+"[!] --src-range ip[-ip]    Match source IP in the specified range\n"
+"[!] --dst-range ip[-ip]    Match destination IP in the specified range\n");
 }
 
 static const struct option iprange_mt_opts[] = {
@@ -30,30 +30,48 @@ static const struct option iprange_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static void
-parse_iprange(char *arg, struct ipt_iprange *range)
+static void iprange_parse_range(char *arg, union nf_inet_addr *range,
+				u_int8_t family, const char *optname)
 {
+	struct in6_addr *ia6;
+	struct in_addr *ia4;
 	char *dash;
-	const struct in_addr *ip;
 
+	memset(range, 0, sizeof(union nf_inet_addr) * 2);
 	dash = strchr(arg, '-');
 	if (dash != NULL)
 		*dash = '\0';
 
-	ip = xtables_numeric_to_ipaddr(arg);
-	if (!ip)
-		xtables_error(PARAMETER_PROBLEM, "iprange match: Bad IP address \"%s\"\n",
-			   arg);
-	range->min_ip = ip->s_addr;
-
-	if (dash != NULL) {
-		ip = xtables_numeric_to_ipaddr(dash+1);
-		if (!ip)
-			xtables_error(PARAMETER_PROBLEM, "iprange match: Bad IP address \"%s\"\n",
-				   dash+1);
-		range->max_ip = ip->s_addr;
+	if (family == NFPROTO_IPV6) {
+		ia6 = xtables_numeric_to_ip6addr(arg);
+		if (ia6 == NULL)
+			xtables_param_act(XTF_BAD_VALUE, "iprange",
+				optname, arg);
+		range[0].in6 = *ia6;
+		if (dash == NULL) {
+			range[1] = range[0];
+			return;
+		}
+		ia6 = xtables_numeric_to_ip6addr(dash + 1);
+		if (ia6 == NULL)
+			xtables_param_act(XTF_BAD_VALUE, "iprange",
+				optname, dash + 1);
+		range[1].in6 = *ia6;
 	} else {
-		range->max_ip = range->min_ip;
+		ia4 = xtables_numeric_to_ipaddr(arg);
+		if (ia4 == NULL)
+			xtables_param_act(XTF_BAD_VALUE, "iprange",
+				optname, arg);
+		range[0].in = *ia4;
+		if (dash == NULL) {
+			range[1] = range[0];
+			return;
+		}
+		ia4 = xtables_numeric_to_ipaddr(dash + 1);
+		if (ia4 == NULL)
+			xtables_param_act(XTF_BAD_VALUE, "iprange",
+				optname, dash + 1);
+		range[1].in = *ia4;
 	}
 }
 
@@ -61,6 +79,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
+	union nf_inet_addr range[2];
 
 	switch (c) {
 	case '1':
@@ -73,7 +92,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
-		parse_iprange(optarg, &info->src);
+		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
 
 		break;
 
@@ -88,7 +107,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
 
-		parse_iprange(optarg, &info->dst);
+		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
 
 		break;
 
@@ -103,23 +122,11 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
-	const struct in_addr *ia;
-	char *end;
 
 	switch (c) {
 	case '1': /* --src-range */
-		end = strchr(optarg, '-');
-		if (end == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
-		*end = '\0';
-		ia = xtables_numeric_to_ipaddr(optarg);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
-		memcpy(&info->src_min.in, ia, sizeof(*ia));
-		ia = xtables_numeric_to_ipaddr(end+1);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
-		memcpy(&info->src_max.in, ia, sizeof(*ia));
+		iprange_parse_range(optarg, &info->src_min, NFPROTO_IPV4,
+			"--src-range");
 		info->flags |= IPRANGE_SRC;
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
@@ -127,18 +134,8 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case '2': /* --dst-range */
-		end = strchr(optarg, '-');
-		if (end == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
-		*end = '\0';
-		ia = xtables_numeric_to_ipaddr(optarg);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
-		memcpy(&info->dst_min.in, ia, sizeof(*ia));
-		ia = xtables_numeric_to_ipaddr(end + 1);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
-		memcpy(&info->dst_max.in, ia, sizeof(*ia));
+		iprange_parse_range(optarg, &info->dst_min, NFPROTO_IPV4,
+			"--dst-range");
 		info->flags |= IPRANGE_DST;
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
@@ -153,23 +150,11 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
-	const struct in6_addr *ia;
-	char *end;
 
 	switch (c) {
 	case '1': /* --src-range */
-		end = strchr(optarg, '-');
-		if (end == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
-		*end = '\0';
-		ia = xtables_numeric_to_ip6addr(optarg);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
-		memcpy(&info->src_min.in, ia, sizeof(*ia));
-		ia = xtables_numeric_to_ip6addr(end+1);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
-		memcpy(&info->src_max.in, ia, sizeof(*ia));
+		iprange_parse_range(optarg, &info->src_min, NFPROTO_IPV6,
+			"--src-range");
 		info->flags |= IPRANGE_SRC;
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
@@ -177,18 +162,8 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case '2': /* --dst-range */
-		end = strchr(optarg, '-');
-		if (end == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
-		*end = '\0';
-		ia = xtables_numeric_to_ip6addr(optarg);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
-		memcpy(&info->dst_min.in, ia, sizeof(*ia));
-		ia = xtables_numeric_to_ip6addr(end + 1);
-		if (ia == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
-		memcpy(&info->dst_max.in, ia, sizeof(*ia));
+		iprange_parse_range(optarg, &info->dst_min, NFPROTO_IPV6,
+			"--dst-range");
 		info->flags |= IPRANGE_DST;
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
-- 
1.6.4.4

