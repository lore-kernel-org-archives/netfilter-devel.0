From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/16] libxtables: prefix - parse and escaped output func
Date: Mon,  9 Feb 2009 18:34:57 +0100
Message-ID: <1234200900-5964-14-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51473 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbZBIRfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:06 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c  |    4 ++--
 extensions/libipt_LOG.c      |    2 +-
 extensions/libipt_ULOG.c     |    2 +-
 extensions/libipt_policy.c   |    4 ++--
 extensions/libxt_NFLOG.c     |    2 +-
 extensions/libxt_conntrack.c |   24 ++++++++++++------------
 extensions/libxt_helper.c    |    2 +-
 include/xtables.h.in         |    6 +++---
 ip6tables.c                  |    4 ++--
 iptables.c                   |    4 ++--
 xtables.c                    |   17 ++++++++++++-----
 11 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 357cbea..fa855c1 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -214,7 +214,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
-		ip6parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		xtables_ip6parse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
@@ -229,7 +229,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
 
-		ip6parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		xtables_ip6parse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index aefb54a..23790a0 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -235,7 +235,7 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 
 	if (strcmp(loginfo->prefix, "") != 0) {
 		printf("--log-prefix ");
-		save_string(loginfo->prefix);
+		xtables_save_string(loginfo->prefix);
 	}
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index d73a3f6..6e346d8 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -151,7 +151,7 @@ static void ULOG_save(const void *ip, const struct xt_entry_target *target)
 
 	if (strcmp(loginfo->prefix, "") != 0) {
 		fputs("--ulog-prefix ", stdout);
-		save_string(loginfo->prefix);
+		xtables_save_string(loginfo->prefix);
 	}
 
 	if (loginfo->nl_group != ULOG_DEFAULT_NLGROUP) {
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 6b044d8..c9ce850 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -182,7 +182,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
-		ipparse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		xtables_ipparse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
@@ -197,7 +197,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
 
-		ipparse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		xtables_ipparse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index fe22e98..bedfbe9 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -113,7 +113,7 @@ static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 {
 	if (info->prefix[0] != '\0') {
 		printf("%snflog-prefix ", prefix);
-		save_string(info->prefix);
+		xtables_save_string(info->prefix);
 	}
 	if (info->group)
 		printf("%snflog-group %u ", prefix, info->group);
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index ffa279c..958f842 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -333,7 +333,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
 
-		ipparse_hostnetworkmask(argv[optind-1], &addrs,
+		xtables_ipparse_any(argv[optind-1], &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -353,7 +353,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
 
-		ipparse_hostnetworkmask(argv[optind-1], &addrs,
+		xtables_ipparse_any(argv[optind-1], &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -373,7 +373,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
 
-		ipparse_hostnetworkmask(argv[optind-1], &addrs,
+		xtables_ipparse_any(argv[optind-1], &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
@@ -393,7 +393,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLDST;
 
-		ipparse_hostnetworkmask(argv[optind-1], &addrs,
+		xtables_ipparse_any(argv[optind-1], &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
@@ -551,7 +551,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '3': /* --ctorigsrc */
-		ipparse_hostnetworkmask(optarg, &addr, &info->origsrc_mask.in,
+		xtables_ipparse_any(optarg, &addr, &info->origsrc_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -564,7 +564,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '4': /* --ctorigdst */
-		ipparse_hostnetworkmask(optarg, &addr, &info->origdst_mask.in,
+		xtables_ipparse_any(optarg, &addr, &info->origdst_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -577,7 +577,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '5': /* --ctreplsrc */
-		ipparse_hostnetworkmask(optarg, &addr, &info->replsrc_mask.in,
+		xtables_ipparse_any(optarg, &addr, &info->replsrc_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -590,7 +590,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '6': /* --ctrepldst */
-		ipparse_hostnetworkmask(optarg, &addr, &info->repldst_mask.in,
+		xtables_ipparse_any(optarg, &addr, &info->repldst_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -621,7 +621,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '3': /* --ctorigsrc */
-		ip6parse_hostnetworkmask(optarg, &addr,
+		xtables_ip6parse_any(optarg, &addr,
 		                         &info->origsrc_mask.in6, &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -634,7 +634,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '4': /* --ctorigdst */
-		ip6parse_hostnetworkmask(optarg, &addr,
+		xtables_ip6parse_any(optarg, &addr,
 		                         &info->origdst_mask.in6, &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -647,7 +647,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '5': /* --ctreplsrc */
-		ip6parse_hostnetworkmask(optarg, &addr,
+		xtables_ip6parse_any(optarg, &addr,
 		                         &info->replsrc_mask.in6, &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
@@ -660,7 +660,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '6': /* --ctrepldst */
-		ip6parse_hostnetworkmask(optarg, &addr,
+		xtables_ip6parse_any(optarg, &addr,
 		                         &info->repldst_mask.in6, &naddrs);
 		if (naddrs > 1)
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index b60c982..23025cd 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -65,7 +65,7 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
 
 	printf("%s--helper ",info->invert ? "! " : "");
-	save_string(info->name);
+	xtables_save_string(info->name);
 }
 
 static struct xtables_match helper_match = {
diff --git a/include/xtables.h.in b/include/xtables.h.in
index abde4d8..c3c960b 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -212,21 +212,21 @@ extern const char *xtables_ipaddr_to_anyname(const struct in_addr *);
 extern const char *xtables_ipmask_to_numeric(const struct in_addr *);
 extern struct in_addr *xtables_numeric_to_ipaddr(const char *);
 extern struct in_addr *xtables_numeric_to_ipmask(const char *);
-extern void ipparse_hostnetworkmask(const char *, struct in_addr **,
+extern void xtables_ipparse_any(const char *, struct in_addr **,
 	struct in_addr *, unsigned int *);
 
 extern struct in6_addr *xtables_numeric_to_ip6addr(const char *);
 extern const char *xtables_ip6addr_to_numeric(const struct in6_addr *);
 extern const char *xtables_ip6addr_to_anyname(const struct in6_addr *);
 extern const char *xtables_ip6mask_to_numeric(const struct in6_addr *);
-extern void ip6parse_hostnetworkmask(const char *, struct in6_addr **,
+extern void xtables_ip6parse_any(const char *, struct in6_addr **,
 	struct in6_addr *, unsigned int *);
 
 /**
  * Print the specified value to standard output, quoting dangerous
  * characters if required.
  */
-extern void save_string(const char *value);
+extern void xtables_save_string(const char *value);
 
 #ifdef NO_SHARED_LIBS
 #	ifdef _INIT
diff --git a/ip6tables.c b/ip6tables.c
index fd73276..48a6bec 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1945,11 +1945,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	}
 
 	if (shostnetworkmask)
-		ip6parse_hostnetworkmask(shostnetworkmask, &saddrs,
+		xtables_ip6parse_any(shostnetworkmask, &saddrs,
 		                         &fw.ipv6.smsk, &nsaddrs);
 
 	if (dhostnetworkmask)
-		ip6parse_hostnetworkmask(dhostnetworkmask, &daddrs,
+		xtables_ip6parse_any(dhostnetworkmask, &daddrs,
 		                         &fw.ipv6.dmsk, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
diff --git a/iptables.c b/iptables.c
index aeb40d8..925464c 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1974,11 +1974,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	}
 
 	if (shostnetworkmask)
-		ipparse_hostnetworkmask(shostnetworkmask, &saddrs,
+		xtables_ipparse_any(shostnetworkmask, &saddrs,
 					&fw.ip.smsk, &nsaddrs);
 
 	if (dhostnetworkmask)
-		ipparse_hostnetworkmask(dhostnetworkmask, &daddrs,
+		xtables_ipparse_any(dhostnetworkmask, &daddrs,
 					&fw.ip.dmsk, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
diff --git a/xtables.c b/xtables.c
index a387ae0..8a79c5b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -954,8 +954,15 @@ static struct in_addr *parse_ipmask(const char *mask)
 	return &maskaddr;
 }
 
-void ipparse_hostnetworkmask(const char *name, struct in_addr **addrpp,
-                             struct in_addr *maskp, unsigned int *naddrs)
+/**
+ * xtables_ipparse_any - transform arbitrary name to in_addr
+ *
+ * Possible inputs (pseudo regex):
+ * 	m{^($hostname|$networkname|$ipaddr)(/$mask)?}
+ * "1.2.3.4/5", "1.2.3.4", "hostname", "networkname"
+ */
+void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
+                         struct in_addr *maskp, unsigned int *naddrs)
 {
 	unsigned int i, j, k, n;
 	struct in_addr *addrp;
@@ -1178,8 +1185,8 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	return &maskaddr;
 }
 
-void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
-                              struct in6_addr *maskp, unsigned int *naddrs)
+void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
+                          struct in6_addr *maskp, unsigned int *naddrs)
 {
 	struct in6_addr *addrp;
 	unsigned int i, j, k, n;
@@ -1214,7 +1221,7 @@ void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
 	}
 }
 
-void save_string(const char *value)
+void xtables_save_string(const char *value)
 {
 	static const char no_quote_chars[] = "_-0123456789"
 		"abcdefghijklmnopqrstuvwxyz"
-- 
1.6.1.2

