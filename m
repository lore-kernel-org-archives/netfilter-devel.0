From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 22/26] libip[6]t_LOG: use guided option parser
Date: Wed, 13 Apr 2011 18:13:43 +0200
Message-ID: <1302711228-15947-23-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42475 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab1DMQON (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:13 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c |  174 +++++++++++-----------------------------------
 extensions/libipt_LOG.c  |  174 +++++++++++-----------------------------------
 2 files changed, 82 insertions(+), 266 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index e9c738f..a419ec9 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -1,11 +1,6 @@
-/* Shared library add-on to ip6tables to add LOG support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
 #include <syslog.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_LOG.h>
 
@@ -17,6 +12,16 @@
 
 #define LOG_DEFAULT_LEVEL LOG_WARNING
 
+enum {
+	O_LOG_LEVEL = 0,
+	O_LOG_PREFIX,
+	O_LOG_TCPSEQ,
+	O_LOG_TCPOPTS,
+	O_LOG_IPOPTS,
+	O_LOG_UID,
+	O_LOG_MAC,
+};
+
 static void LOG_help(void)
 {
 	printf(
@@ -30,16 +35,20 @@ static void LOG_help(void)
 " --log-macdecode		Decode MAC addresses and protocol.\n");
 }
 
-static const struct option LOG_opts[] = {
-	{.name = "log-level",        .has_arg = true,  .val = '!'},
-	{.name = "log-prefix",       .has_arg = true,  .val = '#'},
-	{.name = "log-tcp-sequence", .has_arg = false, .val = '1'},
-	{.name = "log-tcp-options",  .has_arg = false, .val = '2'},
-	{.name = "log-ip-options",   .has_arg = false, .val = '3'},
-	{.name = "log-uid",          .has_arg = false, .val = '4'},
-	{.name = "log-macdecode",    .has_arg = false, .val = '5'},
-	XT_GETOPT_TABLEEND,
+#define s struct ip6t_log_info
+static const struct xt_option_entry LOG_opts[] = {
+	{.name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, level)},
+	{.name = "log-prefix", .id = O_LOG_PREFIX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, prefix), .min = 1},
+	{.name = "log-tcp-sequence", .id = O_LOG_TCPSEQ, .type = XTTYPE_NONE},
+	{.name = "log-tcp-options", .id = O_LOG_TCPOPTS, .type = XTTYPE_NONE},
+	{.name = "log-ip-options", .id = O_LOG_IPOPTS, .type = XTTYPE_NONE},
+	{.name = "log-uid", .id = O_LOG_UID, .type = XTTYPE_NONE},
+	{.name = "log-macdecode", .id = O_LOG_MAC, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void LOG_init(struct xt_entry_target *t)
 {
@@ -66,134 +75,33 @@ static const struct ip6t_log_names ip6t_log_names[]
     { .name = "warning", .level = LOG_WARNING }
 };
 
-static uint8_t
-parse_level(const char *level)
+static void LOG_parse(struct xt_option_call *cb)
 {
-	unsigned int lev = -1;
-	unsigned int set = 0;
-
-	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
-		unsigned int i = 0;
-
-		for (i = 0; i < ARRAY_SIZE(ip6t_log_names); ++i)
-			if (strncasecmp(level, ip6t_log_names[i].name,
-					strlen(level)) == 0) {
-				if (set++)
-					xtables_error(PARAMETER_PROBLEM,
-						   "log-level `%s' ambiguous",
-						   level);
-				lev = ip6t_log_names[i].level;
-			}
+	struct ip6t_log_info *info = cb->data;
 
-		if (!set)
-			xtables_error(PARAMETER_PROBLEM,
-				   "log-level `%s' unknown", level);
-	}
-
-	return lev;
-}
-
-#define IP6T_LOG_OPT_LEVEL 0x01
-#define IP6T_LOG_OPT_PREFIX 0x02
-#define IP6T_LOG_OPT_TCPSEQ 0x04
-#define IP6T_LOG_OPT_TCPOPT 0x08
-#define IP6T_LOG_OPT_IPOPT 0x10
-#define IP6T_LOG_OPT_UID 0x20
-#define IP6T_LOG_OPT_MACDECODE 0x40
-
-static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
-{
-	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
-
-	switch (c) {
-	case '!':
-		if (*flags & IP6T_LOG_OPT_LEVEL)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-level twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --log-level");
-
-		loginfo->level = parse_level(optarg);
-		*flags |= IP6T_LOG_OPT_LEVEL;
-		break;
-
-	case '#':
-		if (*flags & IP6T_LOG_OPT_PREFIX)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-prefix twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --log-prefix");
-
-		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Maximum prefix length %u for --log-prefix",
-				   (unsigned int)sizeof(loginfo->prefix) - 1);
-
-		if (strlen(optarg) == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "No prefix specified for --log-prefix");
-
-		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LOG_PREFIX:
+		if (strchr(cb->arg, '\n') != NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
-
-		strcpy(loginfo->prefix, optarg);
-		*flags |= IP6T_LOG_OPT_PREFIX;
 		break;
-
-	case '1':
-		if (*flags & IP6T_LOG_OPT_TCPSEQ)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-tcp-sequence "
-				   "twice");
-
-		loginfo->logflags |= IP6T_LOG_TCPSEQ;
-		*flags |= IP6T_LOG_OPT_TCPSEQ;
+	case O_LOG_TCPSEQ:
+		info->logflags = IP6T_LOG_TCPSEQ;
 		break;
-
-	case '2':
-		if (*flags & IP6T_LOG_OPT_TCPOPT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-tcp-options twice");
-
-		loginfo->logflags |= IP6T_LOG_TCPOPT;
-		*flags |= IP6T_LOG_OPT_TCPOPT;
+	case O_LOG_TCPOPTS:
+		info->logflags = IP6T_LOG_TCPOPT;
 		break;
-
-	case '3':
-		if (*flags & IP6T_LOG_OPT_IPOPT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-ip-options twice");
-
-		loginfo->logflags |= IP6T_LOG_IPOPT;
-		*flags |= IP6T_LOG_OPT_IPOPT;
+	case O_LOG_IPOPTS:
+		info->logflags = IP6T_LOG_IPOPT;
 		break;
-
-	case '4':
-		if (*flags & IP6T_LOG_OPT_UID)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-uid twice");
-
-		loginfo->logflags |= IP6T_LOG_UID;
-		*flags |= IP6T_LOG_OPT_UID;
+	case O_LOG_UID:
+		info->logflags = IP6T_LOG_UID;
 		break;
-
-	case '5':
-		if (*flags & IP6T_LOG_OPT_MACDECODE)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can't specify --log-macdecode twice");
-
-		loginfo->logflags |= IP6T_LOG_MACDECODE;
-		*flags |= IP6T_LOG_OPT_MACDECODE;
+	case O_LOG_MAC:
+		info->logflags = IP6T_LOG_MACDECODE;
 		break;
 	}
-
-	return 1;
 }
 
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
@@ -264,10 +172,10 @@ static struct xtables_target log_tg6_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_log_info)),
 	.help          = LOG_help,
 	.init          = LOG_init,
-	.parse         = LOG_parse,
 	.print         = LOG_print,
 	.save          = LOG_save,
-	.extra_opts    = LOG_opts,
+	.x6_parse      = LOG_parse,
+	.x6_options    = LOG_opts,
 };
 
 void _init(void)
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index ba6af04..b270bcf 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -1,11 +1,6 @@
-/* Shared library add-on to iptables to add LOG support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
 #include <syslog.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_LOG.h>
 
@@ -17,6 +12,16 @@
 #define IPT_LOG_MASK	0x0f
 #endif
 
+enum {
+	O_LOG_LEVEL = 0,
+	O_LOG_PREFIX,
+	O_LOG_TCPSEQ,
+	O_LOG_TCPOPTS,
+	O_LOG_IPOPTS,
+	O_LOG_UID,
+	O_LOG_MAC,
+};
+
 static void LOG_help(void)
 {
 	printf(
@@ -30,16 +35,20 @@ static void LOG_help(void)
 " --log-macdecode		Decode MAC addresses and protocol.\n\n");
 }
 
-static const struct option LOG_opts[] = {
-	{.name = "log-level",        .has_arg = true,  .val = '!'},
-	{.name = "log-prefix",       .has_arg = true,  .val = '#'},
-	{.name = "log-tcp-sequence", .has_arg = false, .val = '1'},
-	{.name = "log-tcp-options",  .has_arg = false, .val = '2'},
-	{.name = "log-ip-options",   .has_arg = false, .val = '3'},
-	{.name = "log-uid",          .has_arg = false, .val = '4'},
-	{.name = "log-macdecode",    .has_arg = false, .val = '5'},
-	XT_GETOPT_TABLEEND,
+#define s struct ipt_log_info
+static const struct xt_option_entry LOG_opts[] = {
+	{.name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, level)},
+	{.name = "log-prefix", .id = O_LOG_PREFIX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, prefix), .min = 1},
+	{.name = "log-tcp-sequence", .id = O_LOG_TCPSEQ, .type = XTTYPE_NONE},
+	{.name = "log-tcp-options", .id = O_LOG_TCPOPTS, .type = XTTYPE_NONE},
+	{.name = "log-ip-options", .id = O_LOG_IPOPTS, .type = XTTYPE_NONE},
+	{.name = "log-uid", .id = O_LOG_UID, .type = XTTYPE_NONE},
+	{.name = "log-macdecode", .id = O_LOG_MAC, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
+#undef s
 
 static void LOG_init(struct xt_entry_target *t)
 {
@@ -66,134 +75,33 @@ static const struct ipt_log_names ipt_log_names[]
     { .name = "warning", .level = LOG_WARNING }
 };
 
-static uint8_t
-parse_level(const char *level)
+static void LOG_parse(struct xt_option_call *cb)
 {
-	unsigned int lev = -1;
-	unsigned int set = 0;
-
-	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
-		unsigned int i = 0;
-
-		for (i = 0; i < ARRAY_SIZE(ipt_log_names); ++i)
-			if (strncasecmp(level, ipt_log_names[i].name,
-					strlen(level)) == 0) {
-				if (set++)
-					xtables_error(PARAMETER_PROBLEM,
-						   "log-level `%s' ambiguous",
-						   level);
-				lev = ipt_log_names[i].level;
-			}
+	struct ipt_log_info *info = cb->data;
 
-		if (!set)
-			xtables_error(PARAMETER_PROBLEM,
-				   "log-level `%s' unknown", level);
-	}
-
-	return lev;
-}
-
-#define IPT_LOG_OPT_LEVEL 0x01
-#define IPT_LOG_OPT_PREFIX 0x02
-#define IPT_LOG_OPT_TCPSEQ 0x04
-#define IPT_LOG_OPT_TCPOPT 0x08
-#define IPT_LOG_OPT_IPOPT 0x10
-#define IPT_LOG_OPT_UID 0x20
-#define IPT_LOG_OPT_MACDECODE 0x40
-
-static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
-{
-	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
-
-	switch (c) {
-	case '!':
-		if (*flags & IPT_LOG_OPT_LEVEL)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-level twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --log-level");
-
-		loginfo->level = parse_level(optarg);
-		*flags |= IPT_LOG_OPT_LEVEL;
-		break;
-
-	case '#':
-		if (*flags & IPT_LOG_OPT_PREFIX)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-prefix twice");
-
-		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unexpected `!' after --log-prefix");
-
-		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Maximum prefix length %u for --log-prefix",
-				   (unsigned int)sizeof(loginfo->prefix) - 1);
-
-		if (strlen(optarg) == 0)
-			xtables_error(PARAMETER_PROBLEM,
-				   "No prefix specified for --log-prefix");
-
-		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LOG_PREFIX:
+		if (strchr(cb->arg, '\n') != NULL)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
-
-		strcpy(loginfo->prefix, optarg);
-		*flags |= IPT_LOG_OPT_PREFIX;
 		break;
-
-	case '1':
-		if (*flags & IPT_LOG_OPT_TCPSEQ)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-tcp-sequence "
-				   "twice");
-
-		loginfo->logflags |= IPT_LOG_TCPSEQ;
-		*flags |= IPT_LOG_OPT_TCPSEQ;
+	case O_LOG_TCPSEQ:
+		info->logflags = IPT_LOG_TCPSEQ;
 		break;
-
-	case '2':
-		if (*flags & IPT_LOG_OPT_TCPOPT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-tcp-options twice");
-
-		loginfo->logflags |= IPT_LOG_TCPOPT;
-		*flags |= IPT_LOG_OPT_TCPOPT;
+	case O_LOG_TCPOPTS:
+		info->logflags = IPT_LOG_TCPOPT;
 		break;
-
-	case '3':
-		if (*flags & IPT_LOG_OPT_IPOPT)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-ip-options twice");
-
-		loginfo->logflags |= IPT_LOG_IPOPT;
-		*flags |= IPT_LOG_OPT_IPOPT;
+	case O_LOG_IPOPTS:
+		info->logflags = IPT_LOG_IPOPT;
 		break;
-
-	case '4':
-		if (*flags & IPT_LOG_OPT_UID)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Can't specify --log-uid twice");
-
-		loginfo->logflags |= IPT_LOG_UID;
-		*flags |= IPT_LOG_OPT_UID;
+	case O_LOG_UID:
+		info->logflags = IPT_LOG_UID;
 		break;
-
-	case '5':
-		if (*flags & IPT_LOG_OPT_MACDECODE)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Can't specifiy --log-macdecode twice");
-
-		loginfo->logflags |= IPT_LOG_MACDECODE;
-		*flags |= IPT_LOG_OPT_MACDECODE;
+	case O_LOG_MAC:
+		info->logflags = IPT_LOG_MACDECODE;
 		break;
 	}
-
-	return 1;
 }
 
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
@@ -266,10 +174,10 @@ static struct xtables_target log_tg_reg = {
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_log_info)),
 	.help          = LOG_help,
 	.init          = LOG_init,
-	.parse         = LOG_parse,
 	.print         = LOG_print,
 	.save          = LOG_save,
-	.extra_opts    = LOG_opts,
+	.x6_parse      = LOG_parse,
+	.x6_options    = LOG_opts,
 };
 
 void _init(void)
-- 
1.7.1

