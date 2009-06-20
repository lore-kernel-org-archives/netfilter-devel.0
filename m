From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 4/4] libxt_* extensions
Date: Sun, 21 Jun 2009 00:07:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210007060.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50875 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190AbZFTWH6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:07:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id BF6601F429B
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:07:59 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UAdgo8qP-rA8 for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:07:59 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 90C3F1F4292
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:07:59 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libixt_* extensions with the error reporting function.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 extensions/libxt_CLASSIFY.c              |   22 +++++++++++
 extensions/libxt_CONNMARK.c              |   30 ++++++++++++++++
 extensions/libxt_CONNSECMARK.c           |   33 +++++++++++++++++
 extensions/libxt_DSCP.c                  |   25 +++++++++++++
 extensions/libxt_MARK.c                  |   58 ++++++++++++++++++++++++++++++
 extensions/libxt_NFLOG.c                 |   26 +++++++++++++
 extensions/libxt_NOTRACK.c               |   19 ++++++++++
 extensions/libxt_RATEEST.c               |   27 ++++++++++++++
 extensions/libxt_SECMARK.c               |   46 ++++++++++++++++++++++++
 extensions/libxt_TCPMSS.c                |   27 ++++++++++++++
 extensions/libxt_TCPOPTSTRIP.c           |   22 +++++++++++
 extensions/libxt_TOS.c                   |   26 +++++++++++++
 extensions/libxt_TPROXY.c                |   27 ++++++++++++++
 extensions/libxt_TRACE.c                 |   18 +++++++++
 extensions/libxt_cluster.c               |   27 ++++++++++++++
 extensions/libxt_connbytes.c             |   36 +++++++++++++++++++
 extensions/libxt_connlimit.c             |   22 +++++++++++
 extensions/libxt_connmark.c              |   25 +++++++++++++
 extensions/libxt_conntrack.c             |   19 ++++++++++
 extensions/libxt_dccp.c                  |   41 +++++++++++++++++++++
 extensions/libxt_dscp.c                  |   20 ++++++++++
 extensions/libxt_esp.c                   |   28 ++++++++++++++
 extensions/libxt_hashlimit.c             |   56 +++++++++++++++++++++++++++++
 extensions/libxt_helper.c                |   18 +++++++++
 extensions/libxt_limit.c                 |   21 +++++++++++
 extensions/libxt_mac.c                   |   17 +++++++++
 extensions/libxt_mark.c                  |   18 +++++++++
 extensions/libxt_multiport.c             |   41 +++++++++++++++++++++
 extensions/libxt_owner.c                 |   41 +++++++++++++++++++++
 extensions/libxt_physdev.c               |   35 ++++++++++++++++++
 extensions/libxt_policy.c                |   31 ++++++++++++++++
 extensions/libxt_quota.c                 |   23 ++++++++++++
 extensions/libxt_rateest.c               |   35 ++++++++++++++++++
 extensions/libxt_recent.c                |   46 ++++++++++++++++++++++++
 extensions/libxt_sctp.c                  |   45 +++++++++++++++++++++++
 extensions/libxt_socket.c                |   19 ++++++++++
 extensions/libxt_state.c                 |   18 +++++++++
 extensions/libxt_statistic.c             |   34 ++++++++++++++++++
 extensions/libxt_string.c                |   37 +++++++++++++++++++
 extensions/libxt_tcp.c                   |   33 +++++++++++++++++
 extensions/libxt_tcpmss.c                |   17 +++++++++
 extensions/libxt_time.c                  |   17 +++++++++
 extensions/libxt_udp.c                   |   31 ++++++++++++++++
 include/linux/netfilter/xt_CLASSIFY.h    |    7 ++++
 include/linux/netfilter/xt_CONNMARK.h    |    8 ++++
 include/linux/netfilter/xt_CONNSECMARK.h |    8 ++++
 include/linux/netfilter/xt_MARK.h        |    8 ++++
 include/linux/netfilter/xt_NFLOG.h       |    7 ++++
 include/linux/netfilter/xt_NFQUEUE.h     |    7 ++++
 include/linux/netfilter/xt_NOTRACK.h     |   10 +++++
 include/linux/netfilter/xt_RATEEST.h     |    8 ++++
 include/linux/netfilter/xt_SECMARK.h     |   11 ++++++
 include/linux/netfilter/xt_TCPMSS.h      |    8 ++++
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    7 ++++
 include/linux/netfilter/xt_TPROXY.h      |    8 ++++
 include/linux/netfilter/xt_TRACE.h       |   10 +++++
 include/linux/netfilter/xt_cluster.h     |    7 ++++
 include/linux/netfilter/xt_connbytes.h   |    8 ++++
 include/linux/netfilter/xt_connlimit.h   |    7 ++++
 include/linux/netfilter/xt_connmark.h    |    7 ++++
 include/linux/netfilter/xt_conntrack.h   |    6 +++
 include/linux/netfilter/xt_dccp.h        |    8 ++++
 include/linux/netfilter/xt_dscp.h        |    8 ++++
 include/linux/netfilter/xt_esp.h         |    7 ++++
 include/linux/netfilter/xt_hashlimit.h   |   12 ++++++
 include/linux/netfilter/xt_helper.h      |    6 +++
 include/linux/netfilter/xt_limit.h       |    7 ++++
 include/linux/netfilter/xt_mac.h         |    6 +++
 include/linux/netfilter/xt_mark.h        |    6 +++
 include/linux/netfilter/xt_multiport.h   |    9 +++++
 include/linux/netfilter/xt_owner.h       |    7 ++++
 include/linux/netfilter/xt_physdev.h     |    8 ++++
 include/linux/netfilter/xt_policy.h      |    9 +++++
 include/linux/netfilter/xt_quota.h       |    7 ++++
 include/linux/netfilter/xt_rateest.h     |   10 +++++
 include/linux/netfilter/xt_realm.h       |    6 +++
 include/linux/netfilter/xt_recent.h      |   12 ++++++
 include/linux/netfilter/xt_sctp.h        |    9 +++++
 include/linux/netfilter/xt_socket.h      |   10 +++++
 include/linux/netfilter/xt_state.h       |    6 +++
 include/linux/netfilter/xt_statistic.h   |    8 ++++
 include/linux/netfilter/xt_string.h      |   10 +++++
 include/linux/netfilter/xt_tcpmss.h      |    6 +++
 include/linux/netfilter/xt_tcpudp.h      |    7 ++++
 include/linux/netfilter/xt_time.h        |    6 +++
 85 files changed, 1589 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 82b8f4e..1ea245e 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -69,6 +69,27 @@ CLASSIFY_final_check(unsigned int flags)
 }
 
 static void
+CLASSIFY_error(u_int8_t errcode, u_int8_t family,
+	       const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_CLASSIFY_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"CLASSIFY target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_CLASSIFY_ERR_HOOKS_234:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"CLASSIFY target can only be used in the "
+			"FORWARD, OUTPUT and POSTROUTING chains.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 CLASSIFY_print_class(unsigned int priority, int numeric)
 {
 	printf("%x:%x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
@@ -104,6 +125,7 @@ static struct xtables_target classify_target = {
 	.help		= CLASSIFY_help,
 	.parse		= CLASSIFY_parse,
 	.final_check	= CLASSIFY_final_check,
+	.kernel_error	= CLASSIFY_error,
 	.print		= CLASSIFY_print,
 	.save		= CLASSIFY_save,
 	.extra_opts	= CLASSIFY_opts,
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 6e42898..54f83c8 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -250,6 +250,32 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 	return false;
 }
 
+static void
+connmark_tg_error(u_int8_t errcode, u_int8_t family,
+		  const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case  XT_CONNMARK_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"CONNMARK in restore mode can only be called "
+			"from the \"mangle\" table.");
+		break;
+	case XT_CONNMARK_ERR_32BIT_MARK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark value too high, only 32bit mark values "
+			"are supported by the kernel.");
+		break;
+	case XT_CONNMARK_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void connmark_tg_check(unsigned int flags)
 {
 	if (!flags)
@@ -409,6 +435,7 @@ static struct xtables_target connmark_target = {
 	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
 	.final_check	= connmark_tg_check,
+	.kernel_error	= connmark_tg_error,
 	.print		= CONNMARK_print,
 	.save		= CONNMARK_save,
 	.extra_opts	= CONNMARK_opts,
@@ -425,6 +452,7 @@ static struct xtables_target connmark_target6 = {
 	.init           = CONNMARK_init,
 	.parse		= CONNMARK_parse,
 	.final_check	= connmark_tg_check,
+	.kernel_error	= connmark_tg_error,
 	.print		= CONNMARK_print,
 	.save		= CONNMARK_save,
 	.extra_opts	= CONNMARK_opts,
@@ -441,6 +469,7 @@ static struct xtables_target connmark_tg_reg = {
 	.init           = connmark_tg_init,
 	.parse          = connmark_tg_parse,
 	.final_check    = connmark_tg_check,
+	.kernel_error	= connmark_tg_error,
 	.print          = connmark_tg_print,
 	.save           = connmark_tg_save,
 	.extra_opts     = connmark_tg_opts,
@@ -457,6 +486,7 @@ static struct xtables_target connmark_tg6_reg = {
 	.init           = connmark_tg_init,
 	.parse          = connmark_tg_parse,
 	.final_check    = connmark_tg_check,
+	.kernel_error	= connmark_tg_error,
 	.print          = connmark_tg_print,
 	.save           = connmark_tg_save,
 	.extra_opts     = connmark_tg_opts,
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 11ec01a..92a2ca7 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -69,6 +69,37 @@ static void CONNSECMARK_check(unsigned int flags)
 		           "or --restore is allowed");
 }
 
+static void
+CONNSECMARK_error(u_int8_t errcode, u_int8_t family,
+		  const struct xt_entry_target *target)
+{
+	const struct xt_connsecmark_target_info *info =
+		(struct xt_connsecmark_target_info*)(target)->data;
+
+	switch (errcode) {
+	case  XT_CONNSECMARK_ERR_MANGLE_SECURITY_TABLES:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"CONNSECMARK can only be called "
+			"from the \"mangle\" or \"security\" tables.");
+		break;
+	case XT_CONNSECMARK_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			info->mode == CONNSECMARK_SAVE ? "save" :
+			info->mode == CONNSECMARK_RESTORE ? "restore" :
+			"fixme");
+		break;
+	case XT_CONNSECMARK_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_connsecmark(const struct xt_connsecmark_target_info *info)
 {
 	switch (info->mode) {
@@ -116,6 +147,7 @@ static struct xtables_target connsecmark_target = {
 	.parse		= CONNSECMARK_parse,
 	.help		= CONNSECMARK_help,
 	.final_check	= CONNSECMARK_check,
+	.kernel_error	= CONNSECMARK_error,
 	.print		= CONNSECMARK_print,
 	.save		= CONNSECMARK_save,
 	.extra_opts	= CONNSECMARK_opts,
@@ -131,6 +163,7 @@ static struct xtables_target connsecmark_target6 = {
 	.parse		= CONNSECMARK_parse,
 	.help		= CONNSECMARK_help,
 	.final_check	= CONNSECMARK_check,
+	.kernel_error	= CONNSECMARK_error,
 	.print		= CONNSECMARK_print,
 	.save		= CONNSECMARK_save,
 	.extra_opts	= CONNSECMARK_opts,
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index ddb9c99..5e1c390 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -107,6 +107,29 @@ static void DSCP_check(unsigned int flags)
 }
 
 static void
+DSCP_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_target *target)
+{
+	const struct xt_DSCP_info *dinfo =
+		(const struct xt_DSCP_info *)target->data;
+
+	switch (errcode) {
+	case XT_DSCP_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"DSCP target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_DSCP_ERR_RANGE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"--dscp `%x' is out of range.", dinfo->dscp);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_dscp(u_int8_t dscp, int numeric)
 {
  	printf("0x%02x ", dscp);
@@ -138,6 +161,7 @@ static struct xtables_target dscp_target = {
 	.help		= DSCP_help,
 	.parse		= DSCP_parse,
 	.final_check	= DSCP_check,
+	.kernel_error	= DSCP_error,
 	.print		= DSCP_print,
 	.save		= DSCP_save,
 	.extra_opts	= DSCP_opts,
@@ -152,6 +176,7 @@ static struct xtables_target dscp_target6 = {
 	.help		= DSCP_help,
 	.parse		= DSCP_parse,
 	.final_check	= DSCP_check,
+	.kernel_error	= DSCP_error,
 	.print		= DSCP_print,
 	.save		= DSCP_save,
 	.extra_opts	= DSCP_opts,
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ff48a76..0cbf256 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -193,6 +193,60 @@ static void mark_tg_check(unsigned int flags)
 }
 
 static void
+MARK_error_v1(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_target *target)
+{
+	const struct xt_mark_target_info_v1 *info = 
+		(struct xt_mark_target_info_v1 *) target->data;
+
+	switch (errcode) {
+	case XT_MARK_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"MARK target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_MARK_ERR_32BIT_MARK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark value too high, only 32bit mark values "
+			"are supported by the kernel.");
+		break;
+	case XT_MARK_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark mode `%s' is unknown for the kernel.",
+			info->mode == XT_MARK_SET ? "--set-mark" :
+			info->mode == XT_MARK_AND ? "--and-mark" :
+			info->mode == XT_MARK_OR ? "--or-mark" :
+			"fixme");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
+mark_tg_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_MARK_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"MARK target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_MARK_ERR_32BIT_MARK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark value too high, only 32bit mark values "
+			"are supported by the kernel.");
+		break;
+	case XT_MARK_ERR_MODE:
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_mark(unsigned long mark)
 {
 	printf("0x%lx ", mark);
@@ -287,6 +341,7 @@ static struct xtables_target mark_target_v0 = {
 	.help		= MARK_help,
 	.parse		= MARK_parse_v0,
 	.final_check	= MARK_check,
+	.kernel_error	= mark_tg_error,
 	.print		= MARK_print_v0,
 	.save		= MARK_save_v0,
 	.extra_opts	= MARK_opts,
@@ -302,6 +357,7 @@ static struct xtables_target mark_target_v1 = {
 	.help		= MARK_help,
 	.parse		= MARK_parse_v1,
 	.final_check	= MARK_check,
+	.kernel_error	= MARK_error_v1,
 	.print		= MARK_print_v1,
 	.save		= MARK_save_v1,
 	.extra_opts	= MARK_opts,
@@ -317,6 +373,7 @@ static struct xtables_target mark_target6_v0 = {
 	.help		= MARK_help,
 	.parse		= MARK_parse_v0,
 	.final_check	= MARK_check,
+	.kernel_error	= mark_tg_error,
 	.print		= MARK_print_v0,
 	.save		= MARK_save_v0,
 	.extra_opts	= MARK_opts,
@@ -332,6 +389,7 @@ static struct xtables_target mark_tg_reg_v2 = {
 	.help          = mark_tg_help,
 	.parse         = mark_tg_parse,
 	.final_check   = mark_tg_check,
+	.kernel_error  = mark_tg_error,
 	.print         = mark_tg_print,
 	.save          = mark_tg_save,
 	.extra_opts    = mark_tg_opts,
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 007c7b4..6872c1a 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -109,6 +109,30 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+NFLOG_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_target *target)
+{
+	const struct xt_nflog_info *info = 
+		(struct xt_nflog_info *)target->data;
+
+	switch (errcode) {
+	case  XT_NFLOG_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal `flag' parameter should be zero.");
+		break;
+	case XT_NFLOG_ERR_PREFIXLEN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Log prefix is too long for the kernel, "
+			"it would be truncated to `%s'.",
+			info->prefix);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 {
 	if (info->prefix[0] != '\0') {
@@ -148,6 +172,7 @@ static struct xtables_target nflog_target = {
 	.init		= NFLOG_init,
 	.parse		= NFLOG_parse,
 	.print		= NFLOG_print,
+	.kernel_error	= NFLOG_error,
 	.save		= NFLOG_save,
 	.extra_opts	= NFLOG_opts,
 };
@@ -161,6 +186,7 @@ static struct xtables_target nflog_target6 = {
 	.help		= NFLOG_help,
 	.init		= NFLOG_init,
 	.parse		= NFLOG_parse,
+	.kernel_error	= NFLOG_error,
 	.print		= NFLOG_print,
 	.save		= NFLOG_save,
 	.extra_opts	= NFLOG_opts,
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index ef26654..8cd46eb 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -6,6 +6,7 @@
 
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NOTRACK.h>
 
 static void NOTRACK_help(void)
 {
@@ -19,6 +20,22 @@ NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+NOTRACK_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_NOTRACK_ERR_RAW_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"NOTRACK target can only be used in the "
+			"\"raw\" table.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_target notrack_target = {
 	.family		= NFPROTO_IPV4,
 	.name		= "NOTRACK",
@@ -27,6 +44,7 @@ static struct xtables_target notrack_target = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= NOTRACK_help,
 	.parse		= NOTRACK_parse,
+	.kernel_error	= NOTRACK_error,
 };
 
 static struct xtables_target notrack_target6 = {
@@ -37,6 +55,7 @@ static struct xtables_target notrack_target6 = {
 	.userspacesize	= XT_ALIGN(0),
 	.help		= NOTRACK_help,
 	.parse		= NOTRACK_parse,
+	.kernel_error	= NOTRACK_error,
 };
 
 void _init(void)
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 4b7831f..4a02d67 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -172,6 +172,32 @@ RATEEST_final_check(unsigned int flags)
 }
 
 static void
+RATEEST_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_target *target)
+{
+	struct xt_rateest_target_info *info = 
+		(struct xt_rateest_target_info *) target->data;
+
+	switch (errcode) {
+	case XT_RATEEST_ERR_NAME:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown rate estimator `%s'.", info->name);
+		break;
+	case XT_RATEEST_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	case XT_RATEEST_ERR_GEN_NEW:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel failed to create the new estimator.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 __RATEEST_print(const struct xt_entry_target *target, const char *prefix)
 {
 	const struct xt_rateest_target_info *info = (const void *)target->data;
@@ -211,6 +237,7 @@ static struct xtables_target rateest_tg_reg = {
 	.init		= RATEEST_init,
 	.parse		= RATEEST_parse,
 	.final_check	= RATEEST_final_check,
+	.kernel_error	= RATEEST_error,
 	.print		= RATEEST_print,
 	.save		= RATEEST_save,
 	.extra_opts	= RATEEST_opts,
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 2152b6f..465af75 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -61,6 +61,51 @@ static void SECMARK_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
 }
 
+static void
+SECMARK_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_target *target)
+{
+	const struct xt_secmark_target_info *info =
+		(struct xt_secmark_target_info*)(target)->data;
+
+	const struct xt_secmark_target_selinux_info *sel = &info->u.sel;
+	
+	switch (errcode) {
+	case XT_SECMARK_ERR_MANGLE_SECURITY_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"mangle\" or \"security\" tables.");
+		break;
+	case XT_SECMARK_ERR_MIXED_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode already set, cannot mix with rules "
+			"for mode %hu",
+			info->mode);
+		break;
+	case XT_SECMARK_ERR_INVALID_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Invalid mode %hu.", info->mode);
+		break;
+	case XT_SECMARK_ERR_CONTEXT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Invalid SELinux context `%s'.",
+			sel->selctx);
+		break;
+	case XT_SECMARK_ERR_MAP_CONTEXT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unable to map SELinux context `%s'.",
+			sel->selctx);
+		break;
+	case XT_SECMARK_ERR_PERM:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unable to obtain relabeling permission.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_secmark(const struct xt_secmark_target_info *info)
 {
 	switch (info->mode) {
@@ -102,6 +147,7 @@ static struct xtables_target secmark_target = {
 	.help		= SECMARK_help,
 	.parse		= SECMARK_parse,
 	.final_check	= SECMARK_check,
+	.kernel_error	= SECMARK_error,
 	.print		= SECMARK_print,
 	.save		= SECMARK_save,
 	.extra_opts	= SECMARK_opts,
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index ac9e2d0..ebbcca4 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -97,6 +97,31 @@ static void TCPMSS_check(unsigned int flags)
 		           "TCPMSS target: At least one parameter is required");
 }
 
+static void
+TCPMSS_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_TCPMSS_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target is only valid for protocol TCP.");
+		break;
+	case XT_TCPMSS_ERR_HOOKS_234:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Path-MTU clamping only supported in the "
+			"FORWARD, OUTPUT and POSTROUTING chains.");
+		break;
+	case XT_TCPMSS_ERR_SYN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"The target can only be used in a rule which "
+			"matches TCP SYN packets.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void TCPMSS_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
@@ -128,6 +153,7 @@ static struct xtables_target tcpmss_target = {
 	.help		= TCPMSS_help,
 	.parse		= TCPMSS_parse,
 	.final_check	= TCPMSS_check,
+	.kernel_error	= TCPMSS_error,
 	.print		= TCPMSS_print,
 	.save		= TCPMSS_save,
 	.extra_opts	= TCPMSS_opts,
@@ -142,6 +168,7 @@ static struct xtables_target tcpmss_target6 = {
 	.help		= TCPMSS_help6,
 	.parse		= TCPMSS_parse6,
 	.final_check	= TCPMSS_check,
+	.kernel_error	= TCPMSS_error,
 	.print		= TCPMSS_print,
 	.save		= TCPMSS_save,
 	.extra_opts	= TCPMSS_opts,
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index cf946fc..6abafdc 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -129,6 +129,26 @@ static void tcpoptstrip_tg_check(unsigned int flags)
 }
 
 static void
+tcpoptstrip_tg_error(u_int8_t errcode, u_int8_t family,
+		     const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_TCPOPTSTRIP_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_TCPOPTSTRIP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target is only valid for protocol TCP.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 tcpoptstrip_print_list(const struct xt_tcpoptstrip_target_info *info,
                        bool numeric)
 {
@@ -187,6 +207,7 @@ static struct xtables_target tcpoptstrip_tg_reg = {
 	.init          = tcpoptstrip_tg_init,
 	.parse         = tcpoptstrip_tg_parse,
 	.final_check   = tcpoptstrip_tg_check,
+	.kernel_error  = tcpoptstrip_tg_error,
 	.print         = tcpoptstrip_tg_print,
 	.save          = tcpoptstrip_tg_save,
 	.extra_opts    = tcpoptstrip_tg_opts,
@@ -202,6 +223,7 @@ static struct xtables_target tcpoptstrip_tg6_reg = {
 	.init          = tcpoptstrip_tg_init,
 	.parse         = tcpoptstrip_tg_parse,
 	.final_check   = tcpoptstrip_tg_check,
+	.kernel_error  = tcpoptstrip_tg_error,
 	.print         = tcpoptstrip_tg_print,
 	.save          = tcpoptstrip_tg_save,
 	.extra_opts    = tcpoptstrip_tg_opts,
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index c08f53b..d2b31e4 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -157,6 +157,29 @@ static void tos_tg_check(unsigned int flags)
 		           "TOS: The --set-tos parameter is required");
 }
 
+static void
+tos_tg_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_target *target)
+{
+	const struct ipt_tos_target_info *info = (const void *)target->data;
+	
+	switch (errcode) {
+	case XT_DSCP_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"TOS target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_DSCP_ERR_VALUE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"TOS value `%#x' not supported by the kernel.",
+			info->tos);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void tos_tg_print_v0(const void *ip,
                             const struct xt_entry_target *target, int numeric)
 {
@@ -215,6 +238,7 @@ static struct xtables_target tos_tg_reg_v0 = {
 	.help          = tos_tg_help_v0,
 	.parse         = tos_tg_parse_v0,
 	.final_check   = tos_tg_check,
+	.kernel_error  = tos_tg_error,
 	.print         = tos_tg_print_v0,
 	.save          = tos_tg_save_v0,
 	.extra_opts    = tos_tg_opts_v0,
@@ -230,6 +254,7 @@ static struct xtables_target tos_tg_reg = {
 	.help          = tos_tg_help,
 	.parse         = tos_tg_parse,
 	.final_check   = tos_tg_check,
+	.kernel_error  = tos_tg_error,
 	.print         = tos_tg_print,
 	.save          = tos_tg_save,
 	.extra_opts    = tos_tg_opts,
@@ -245,6 +270,7 @@ static struct xtables_target tos_tg6_reg = {
 	.help          = tos_tg_help,
 	.parse         = tos_tg_parse,
 	.final_check   = tos_tg_check,
+	.kernel_error  = tos_tg_error,
 	.print         = tos_tg_print,
 	.save          = tos_tg_save,
 	.extra_opts    = tos_tg_opts,
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d410c52..1714702 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -109,6 +109,32 @@ static void tproxy_tg_check(unsigned int flags)
 			   "TPROXY target: Parameter --on-port is required");
 }
 
+static void
+tproxy_tg_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_TPROXY_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_TPROXY_ERR_HOOKS_0:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"PREROUTING chain.");
+		break;
+	case XT_TPROXY_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"The target can only be used in a rule which "
+			"matches either TCP or UDP packets.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void tproxy_tg_print(const void *ip, const struct xt_entry_target *target,
 			 int numeric)
 {
@@ -139,6 +165,7 @@ static struct xtables_target tproxy_tg_reg = {
 	.help	       = tproxy_tg_help,
 	.parse	       = tproxy_tg_parse,
 	.final_check   = tproxy_tg_check,
+	.kernel_error  = tproxy_tg_error,
 	.print	       = tproxy_tg_print,
 	.save	       = tproxy_tg_save,
 	.extra_opts    = tproxy_tg_opts,
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 344b80d..f17bc05 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -6,6 +6,7 @@
 
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TRACE.h>
 
 static void TRACE_help(void)
 {
@@ -18,12 +19,29 @@ static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+TRACE_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case XT_TRACE_ERR_RAW_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"TRACE target can only be used in the "
+			"\"raw\" table.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_target trace_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "TRACE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
+	.kernel_error	= TRACE_error,
 	.help		= TRACE_help,
 	.parse		= TRACE_parse,
 };
diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index c80afe6..d321eb6 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -190,6 +190,32 @@ cluster_check(unsigned int flags)
 }
 
 static void
+cluster_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_match *match)
+{
+	const struct xt_cluster_match_info *info = (void *)match->data;
+
+	switch (errcode) {
+	case XT_CLUSTER_ERR_TOTAL_NODES:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"The number of total nodes cannot exceed %u, "
+			"the maximum number of cluster nodes supported "
+			"by the kernel.",
+			info->total_nodes);
+		break;
+	case XT_CLUSTER_ERR_NODE_MASK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"This node mask %u is higher than "
+			"the mask of the total number of nodes %lu.",
+			info->node_mask, 1UL << info->total_nodes);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 cluster_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_cluster_match_info *info = (void *)match->data;
@@ -227,6 +253,7 @@ static struct xtables_match cluster_mt_reg = {
  	.help		= cluster_help,
 	.parse		= cluster_parse,
 	.final_check	= cluster_check,
+	.kernel_error	= cluster_error,
 	.print		= cluster_print,
 	.save		= cluster_save,
 	.extra_opts	= cluster_opts,
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index c7bdff0..1d046c5 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -102,6 +102,40 @@ static void connbytes_check(unsigned int flags)
 			   "`--connbytes-dir' and `--connbytes-mode'");
 }
 
+static void
+connbytes_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_match *match)
+{
+	const struct xt_connbytes_info *sinfo = (const void *)match->data;
+
+	switch (errcode) {
+	case XT_CONNBYTES_ERR_WHAT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			sinfo->what == XT_CONNBYTES_PKTS ? "pakets" :
+			sinfo->what == XT_CONNBYTES_BYTES ? "bytes" :
+			sinfo->what == XT_CONNBYTES_AVGPKT ? "avgpkt" :
+			"fixme");
+		break;
+	case XT_CONNBYTES_ERR_DIR:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Direction `%s' is unknown for the kernel.",
+			sinfo->direction == XT_CONNBYTES_DIR_ORIGINAL ? "original" :
+			sinfo->direction == XT_CONNBYTES_DIR_REPLY ? "reply" :
+			sinfo->direction == XT_CONNBYTES_DIR_BOTH ? "both" :
+			"fixme");
+		break;
+	case XT_CONNBYTES_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_mode(const struct xt_connbytes_info *sinfo)
 {
 	switch (sinfo->what) {
@@ -188,6 +222,7 @@ static struct xtables_match connbytes_match = {
 	.help		= connbytes_help,
 	.parse		= connbytes_parse,
 	.final_check	= connbytes_check,
+	.kernel_error	= connbytes_error,
 	.print		= connbytes_print,
 	.save 		= connbytes_save,
 	.extra_opts	= connbytes_opts,
@@ -202,6 +237,7 @@ static struct xtables_match connbytes_match6 = {
 	.help		= connbytes_help,
 	.parse		= connbytes_parse,
 	.final_check	= connbytes_check,
+	.kernel_error	= connbytes_error,
 	.print		= connbytes_print,
 	.save 		= connbytes_save,
 	.extra_opts	= connbytes_opts,
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 403e7e6..0e4b28c 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -123,6 +123,26 @@ static void connlimit_check(unsigned int flags)
 			"You must specify \"--connlimit-above\"");
 }
 
+static void
+connlimit_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_CONNLIMIT_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	case XT_CONNLIMIT_ERR_INIT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static unsigned int count_bits4(u_int32_t mask)
 {
 	unsigned int bits = 0;
@@ -189,6 +209,7 @@ static struct xtables_match connlimit_match = {
 	.init          = connlimit_init,
 	.parse         = connlimit_parse4,
 	.final_check   = connlimit_check,
+	.kernel_error  = connlimit_error,
 	.print         = connlimit_print4,
 	.save          = connlimit_save4,
 	.extra_opts    = connlimit_opts,
@@ -204,6 +225,7 @@ static struct xtables_match connlimit_match6 = {
 	.init          = connlimit_init,
 	.parse         = connlimit_parse6,
 	.final_check   = connlimit_check,
+	.kernel_error  = connlimit_error,
 	.print         = connlimit_print6,
 	.save          = connlimit_save6,
 	.extra_opts    = connlimit_opts,
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index ce2002c..d6cfff7 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -119,6 +119,27 @@ static void connmark_mt_check(unsigned int flags)
 }
 
 static void
+connmark_error(u_int8_t errcode, u_int8_t family,
+	       const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_CONNMARK_ERR_32BIT_MARK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark value too high, only 32bit mark values "
+			"are supported by the kernel.");
+		break;
+	case XT_CONNMARK_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_connmark_info *info = (const void *)match->data;
@@ -173,6 +194,7 @@ static struct xtables_match connmark_mt_reg_v0 = {
 	.help		= connmark_mt_help,
 	.parse		= connmark_parse,
 	.final_check	= connmark_mt_check,
+	.kernel_error	= connmark_error,
 	.print		= connmark_print,
 	.save		= connmark_save,
 	.extra_opts	= connmark_mt_opts,
@@ -188,6 +210,7 @@ static struct xtables_match connmark_mt6_reg_v0 = {
 	.help		= connmark_mt_help,
 	.parse		= connmark_parse,
 	.final_check	= connmark_mt_check,
+	.kernel_error	= connmark_error,
 	.print		= connmark_print,
 	.save		= connmark_save,
 	.extra_opts	= connmark_mt_opts,
@@ -203,6 +226,7 @@ static struct xtables_match connmark_mt_reg = {
 	.help           = connmark_mt_help,
 	.parse          = connmark_mt_parse,
 	.final_check    = connmark_mt_check,
+	.kernel_error	= connmark_error,
 	.print          = connmark_mt_print,
 	.save           = connmark_mt_save,
 	.extra_opts     = connmark_mt_opts,
@@ -218,6 +242,7 @@ static struct xtables_match connmark_mt6_reg = {
 	.help           = connmark_mt_help,
 	.parse          = connmark_mt_parse,
 	.final_check    = connmark_mt_check,
+	.kernel_error	= connmark_error,
 	.print          = connmark_mt_print,
 	.save           = connmark_mt_save,
 	.extra_opts     = connmark_mt_opts,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 96ea3ec..b43e500 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -690,6 +690,22 @@ static void conntrack_mt_check(unsigned int flags)
 }
 
 static void
+conntrack_mt_error(u_int8_t errcode, u_int8_t family,
+		   const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_CONNTRACK_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_state(unsigned int statemask)
 {
 	const char *sep = "";
@@ -1044,6 +1060,7 @@ static struct xtables_match conntrack_match = {
 	.help          = conntrack_mt_help,
 	.parse         = conntrack_parse,
 	.final_check   = conntrack_mt_check,
+	.kernel_error  = conntrack_mt_error,
 	.print         = conntrack_print,
 	.save          = conntrack_save,
 	.extra_opts    = conntrack_mt_opts_v0,
@@ -1059,6 +1076,7 @@ static struct xtables_match conntrack_mt_reg = {
 	.help          = conntrack_mt_help,
 	.parse         = conntrack_mt4_parse,
 	.final_check   = conntrack_mt_check,
+	.kernel_error  = conntrack_mt_error,
 	.print         = conntrack_mt_print,
 	.save          = conntrack_mt_save,
 	.extra_opts    = conntrack_mt_opts,
@@ -1074,6 +1092,7 @@ static struct xtables_match conntrack_mt6_reg = {
 	.help          = conntrack_mt_help,
 	.parse         = conntrack_mt6_parse,
 	.final_check   = conntrack_mt_check,
+	.kernel_error  = conntrack_mt_error,
 	.print         = conntrack_mt6_print,
 	.save          = conntrack_mt6_save,
 	.extra_opts    = conntrack_mt_opts,
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 7321145..212c15c 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -188,6 +188,45 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static inline const char * print_flags(u_int16_t flags)
+{
+	return (flags & XT_DCCP_SRC_PORTS ? "spt" :
+		flags & XT_DCCP_DEST_PORTS ? "dpt" :
+		flags & XT_DCCP_TYPE ? "dccp-types" :
+		flags & XT_DCCP_OPTION ? "dccp-option" :
+		"fixme");
+}
+
+static void
+dccp_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{
+	const struct xt_dccp_info *info =
+		(const struct xt_dccp_info *)match->data;
+
+	switch (errcode) {
+	case XT_DCCP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol DCCP.");
+		break;
+	case XT_DCCP_ERR_INVALID_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown %s`%s' option for the kernel.",
+			info->flags ? " " : "negated ",
+			print_flags(info->flags | info->invflags));
+		break;
+	case XT_DCCP_ERR_FLAG_INVFLAG:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' cannot be specified both "
+			"in plain and negated form.",
+			print_flags(info->invflags & ~info->flags));
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static char *
 port_to_service(int port)
 {
@@ -343,6 +382,7 @@ static struct xtables_match dccp_match = {
 	.help		= dccp_help,
 	.init		= dccp_init,
 	.parse		= dccp_parse,
+	.kernel_error	= dccp_error,
 	.print		= dccp_print,
 	.save		= dccp_save,
 	.extra_opts	= dccp_opts,
@@ -357,6 +397,7 @@ static struct xtables_match dccp_match6 = {
 	.help		= dccp_help,
 	.init		= dccp_init,
 	.parse		= dccp_parse,
+	.kernel_error	= dccp_error,
 	.print		= dccp_print,
 	.save		= dccp_save,
 	.extra_opts	= dccp_opts,
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 62fa6af..ca39620 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -115,6 +115,24 @@ static void dscp_check(unsigned int flags)
 }
 
 static void
+dscp_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{
+	const struct xt_dscp_info *dinfo =
+		(const struct xt_dscp_info *)match->data;
+
+	switch (errcode) {
+	case XT_DSCP_ERR_RANGE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"`--dscp %x' is out of range.", dinfo->dscp);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 dscp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_dscp_info *dinfo =
@@ -139,6 +157,7 @@ static struct xtables_match dscp_match = {
 	.help		= dscp_help,
 	.parse		= dscp_parse,
 	.final_check	= dscp_check,
+	.kernel_error	= dscp_error,
 	.print		= dscp_print,
 	.save		= dscp_save,
 	.extra_opts	= dscp_opts,
@@ -153,6 +172,7 @@ static struct xtables_match dscp_match6 = {
 	.help		= dscp_help,
 	.parse		= dscp_parse,
 	.final_check	= dscp_check,
+	.kernel_error	= dscp_error,
 	.print		= dscp_print,
 	.save		= dscp_save,
 	.extra_opts	= dscp_opts,
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 5769edb..ac908be 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -102,6 +102,32 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+esp_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
+
+	switch (errcode) {
+	case XT_ESP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol ESP.");
+		break;
+	case XT_ESP_ERR_FLAGS:
+		if (espinfo->invflags & XT_ESP_INV_MASK)
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Negation iss not recognized by the kernel.");
+		else
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Unknown invflags value `%u'.",
+				espinfo->invflags);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_spis(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
 {
@@ -157,6 +183,7 @@ static struct xtables_match esp_match = {
 	.help		= esp_help,
 	.init		= esp_init,
 	.parse		= esp_parse,
+	.kernel_error	= esp_error,
 	.print		= esp_print,
 	.save		= esp_save,
 	.extra_opts	= esp_opts,
@@ -171,6 +198,7 @@ static struct xtables_match esp_match6 = {
 	.help		= esp_help,
 	.init		= esp_init,
 	.parse		= esp_parse,
+	.kernel_error	= esp_error,
 	.print		= esp_print,
 	.save		= esp_save,
 	.extra_opts	= esp_opts,
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 84dd786..521db9d 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -472,6 +472,58 @@ static void hashlimit_mt_check(unsigned int flags)
 		           "You have to specify --hashlimit-name");
 }
 
+static void
+hashlimit_mt_error(u_int8_t errcode, u_int8_t family,
+		   const struct xt_entry_match *match)
+{
+	const struct xt_hashlimit_info *r = (const void *)match->data;
+
+	switch (errcode) {
+	case XT_HASHLIMIT_ERR_OVERFLOW:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Overflow detected, choose lower --hashlimit/"
+			"--hashlimit-burst ratio.");
+		break;
+	case XT_HASHLIMIT_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			r->cfg.mode == 0 ? "none" :
+			r->cfg.mode & XT_HASHLIMIT_HASH_SIP ? "srcip" :
+			r->cfg.mode & XT_HASHLIMIT_HASH_SPT ? "srcport" :
+			r->cfg.mode & XT_HASHLIMIT_HASH_DIP ? "dstip" :
+			r->cfg.mode & XT_HASHLIMIT_HASH_DPT ? "dstport" :
+			"fixme");
+		break;
+	case XT_HASHLIMIT_ERR_INTERVAL:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Garbage collection interval cannot be zero.");
+		break;
+	case XT_HASHLIMIT_ERR_EXPIRE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Expire time cannot be zero.");
+		break;
+	case XT_HASHLIMIT_ERR_NAMELEN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Entry name is too long for the kernel, "
+			"it would be truncated to `%s'.",
+			r->name);
+		break;
+	case XT_HASHLIMIT_ERR_NETMASK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"`--hashlimit-srcmask' and `--hashlimit-dstmask` "
+			"cannot be greater than %u.",
+			family == AF_INET ? 32 : 128);
+		break;
+	case XT_HASHLIMIT_ERR_INIT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel couldn't create private data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static const struct rates
 {
 	const char *name;
@@ -670,6 +722,7 @@ static struct xtables_match hashlimit_match = {
 	.init		= hashlimit_init,
 	.parse		= hashlimit_parse,
 	.final_check	= hashlimit_check,
+	.kernel_error	= hashlimit_mt_error,
 	.print		= hashlimit_print,
 	.save		= hashlimit_save,
 	.extra_opts	= hashlimit_opts,
@@ -686,6 +739,7 @@ static struct xtables_match hashlimit_match6 = {
 	.init		= hashlimit_init,
 	.parse		= hashlimit_parse,
 	.final_check	= hashlimit_check,
+	.kernel_error	= hashlimit_mt_error,
 	.print		= hashlimit_print,
 	.save		= hashlimit_save,
 	.extra_opts	= hashlimit_opts,
@@ -702,6 +756,7 @@ static struct xtables_match hashlimit_mt_reg = {
 	.init           = hashlimit_mt4_init,
 	.parse          = hashlimit_mt4_parse,
 	.final_check	= hashlimit_mt_check,
+	.kernel_error	= hashlimit_mt_error,
 	.print          = hashlimit_mt4_print,
 	.save           = hashlimit_mt4_save,
 	.extra_opts     = hashlimit_mt_opts,
@@ -718,6 +773,7 @@ static struct xtables_match hashlimit_mt6_reg = {
 	.init           = hashlimit_mt6_init,
 	.parse          = hashlimit_mt6_parse,
 	.final_check	= hashlimit_mt_check,
+	.kernel_error	= hashlimit_mt_error,
 	.print          = hashlimit_mt6_print,
 	.save           = hashlimit_mt6_save,
 	.extra_opts     = hashlimit_mt_opts,
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 7b56bef..d8da66d 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -53,6 +53,22 @@ static void helper_check(unsigned int flags)
 }
 
 static void
+helper_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_HELPER_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 helper_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_helper_info *info = (const void *)match->data;
@@ -76,6 +92,7 @@ static struct xtables_match helper_match = {
 	.help		= helper_help,
 	.parse		= helper_parse,
 	.final_check	= helper_check,
+	.kernel_error	= helper_error,
 	.print		= helper_print,
 	.save		= helper_save,
 	.extra_opts	= helper_opts,
@@ -89,6 +106,7 @@ static struct xtables_match helper_match6 = {
 	.help		= helper_help,
 	.parse		= helper_parse,
 	.final_check	= helper_check,
+	.kernel_error	= helper_error,
 	.print		= helper_print,
 	.save		= helper_save,
 	.extra_opts	= helper_opts,
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 8ca921c..513c7e2 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -119,6 +119,26 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+limit_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_LIMIT_ERR_OVERFLOW:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Overflow detected, choose lower --limit/"
+			"--limit-burst ratio.");
+		break;
+	case XT_LIMIT_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel couldn't create private data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static const struct rates
 {
 	const char *name;
@@ -166,6 +186,7 @@ static struct xtables_match limit_match = {
 	.help		= limit_help,
 	.init		= limit_init,
 	.parse		= limit_parse,
+	.kernel_error	= limit_error,
 	.print		= limit_print,
 	.save		= limit_save,
 	.extra_opts	= limit_opts,
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index a57e341..41620d6 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -71,6 +71,22 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+mac_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_MAC_ERR_HOOKS_012:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"mac match can only be used in the "
+			"PREROUTING, INPUT and FORWARD chains.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_mac(const unsigned char macaddress[ETH_ALEN])
 {
 	unsigned int i;
@@ -120,6 +136,7 @@ static struct xtables_match mac_match = {
 	.help		= mac_help,
 	.parse		= mac_parse,
 	.final_check	= mac_check,
+	.kernel_error	= mac_error,
 	.print		= mac_print,
 	.save		= mac_save,
 	.extra_opts	= mac_opts,
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 6f8cc57..4a53e3f 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -81,6 +81,22 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+mark_mt_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_MARK_ERR_32BIT_MARK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mark value too high, only 32bit mark values "
+			"are supported by the kernel.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_mark(unsigned int mark, unsigned int mask)
 {
 	if (mask != 0xffffffffU)
@@ -153,6 +169,7 @@ static struct xtables_match mark_match = {
 	.help		= mark_mt_help,
 	.parse		= mark_parse,
 	.final_check	= mark_mt_check,
+	.kernel_error	= mark_mt_error,
 	.print		= mark_print,
 	.save		= mark_save,
 	.extra_opts	= mark_mt_opts,
@@ -168,6 +185,7 @@ static struct xtables_match mark_mt_reg = {
 	.help           = mark_mt_help,
 	.parse          = mark_mt_parse,
 	.final_check    = mark_mt_check,
+	.kernel_error	= mark_mt_error,
 	.print          = mark_mt_print,
 	.save           = mark_mt_save,
 	.extra_opts     = mark_mt_opts,
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 9959a20..2d83447 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -290,6 +290,43 @@ static void multiport_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, "multiport expection an option");
 }
 
+static void
+multiport_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_match *match)
+{
+	const struct xt_multiport *info
+		= (const struct xt_multiport *)match->data;
+
+	switch (errcode) {
+	case XT_MULTIPORT_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Transport protocol of the rule not specified "
+			"or not supported by the multiport kernel module "
+			"(supported protocols: tcp, udp, udplite, sctp, dccp).");
+		break;
+	case XT_MULTIPORT_ERR_INV_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Transport protocol matching may not be negated "
+			"when the multiport match is used.");
+		break;
+	case XT_MULTIPORT_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' not supported by the kernel.",
+			info->flags == XT_MULTIPORT_SOURCE ? "--source-ports" :
+			info->flags == XT_MULTIPORT_DESTINATION ? "--destination-ports" :
+			info->flags == XT_MULTIPORT_EITHER ? "--ports" :
+			"fixme");
+		break;
+	case XT_MULTIPORT_ERR_COUNT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Too many ports specified.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static char *
 port_to_service(int port, u_int8_t proto)
 {
@@ -519,6 +556,7 @@ static struct xtables_match multiport_match = {
 	.help		= multiport_help,
 	.parse		= multiport_parse,
 	.final_check	= multiport_check,
+	.kernel_error	= multiport_error,
 	.print		= multiport_print,
 	.save		= multiport_save,
 	.extra_opts	= multiport_opts,
@@ -534,6 +572,7 @@ static struct xtables_match multiport_match6 = {
 	.help		= multiport_help,
 	.parse		= multiport_parse6,
 	.final_check	= multiport_check,
+	.kernel_error	= multiport_error,
 	.print		= multiport_print6,
 	.save		= multiport_save6,
 	.extra_opts	= multiport_opts,
@@ -549,6 +588,7 @@ static struct xtables_match multiport_match_v1 = {
 	.help		= multiport_help_v1,
 	.parse		= multiport_parse_v1,
 	.final_check	= multiport_check,
+	.kernel_error	= multiport_error,
 	.print		= multiport_print_v1,
 	.save		= multiport_save_v1,
 	.extra_opts	= multiport_opts,
@@ -564,6 +604,7 @@ static struct xtables_match multiport_match6_v1 = {
 	.help		= multiport_help_v1,
 	.parse		= multiport_parse6_v1,
 	.final_check	= multiport_check,
+	.kernel_error	= multiport_error,
 	.print		= multiport_print6_v1,
 	.save		= multiport_save6_v1,
 	.extra_opts	= multiport_opts,
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index d27b3ae..6951738 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -322,6 +322,43 @@ static void owner_mt_check(unsigned int flags)
 }
 
 static void
+owner_mt_error(u_int8_t errcode, u_int8_t family,
+	       const struct xt_entry_match *match)
+{
+
+	switch (errcode) {
+	case XT_OWNER_ERR_HOOKS_34:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match can only be used in the "
+			"OUTPUT and POSTROUTING chains.");
+		break;
+	case XT_OWNER_ERR_UNSUPPORTED:
+		switch (family) {
+		case AF_INET: {
+			const struct ipt_owner_info *info = (void *)match->data;
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"%s matching not supported by the kernel anymore.",
+				info->match & IPT_OWNER_PID ? "PID" :
+				info->match & IPT_OWNER_SID ? "SID" :
+				"command");
+			break;
+			}
+		case AF_INET6: {
+			const struct ip6t_owner_info *info = (void *)match->data;
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"%s matching not supported by the kernel anymore.",
+				info->match & IP6T_OWNER_PID ? "PID" : "SID");
+			break;
+			}
+		}
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 owner_mt_print_item_v0(const struct ipt_owner_info *info, const char *label,
                        u_int8_t flag, bool numeric)
 {
@@ -543,6 +580,7 @@ static struct xtables_match owner_mt_reg_v0 = {
 	.help          = owner_mt_help_v0,
 	.parse         = owner_mt_parse_v0,
 	.final_check   = owner_mt_check,
+	.kernel_error  = owner_mt_error,
 	.print         = owner_mt_print_v0,
 	.save          = owner_mt_save_v0,
 	.extra_opts    = owner_mt_opts_v0,
@@ -558,6 +596,7 @@ static struct xtables_match owner_mt6_reg_v0 = {
 	.help          = owner_mt6_help_v0,
 	.parse         = owner_mt6_parse_v0,
 	.final_check   = owner_mt_check,
+	.kernel_error  = owner_mt_error,
 	.print         = owner_mt6_print_v0,
 	.save          = owner_mt6_save_v0,
 	.extra_opts    = owner_mt6_opts_v0,
@@ -573,6 +612,7 @@ static struct xtables_match owner_mt_reg = {
 	.help          = owner_mt_help,
 	.parse         = owner_mt_parse,
 	.final_check   = owner_mt_check,
+	.kernel_error  = owner_mt_error,
 	.print         = owner_mt_print,
 	.save          = owner_mt_save,
 	.extra_opts    = owner_mt_opts,
@@ -588,6 +628,7 @@ static struct xtables_match owner_mt6_reg = {
 	.help          = owner_mt_help,
 	.parse         = owner_mt_parse,
 	.final_check   = owner_mt_check,
+	.kernel_error  = owner_mt_error,
 	.print         = owner_mt_print,
 	.save          = owner_mt_save,
 	.extra_opts    = owner_mt_opts,
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 5522a32..d8210c0 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -112,6 +112,39 @@ static void physdev_check(unsigned int flags)
 }
 
 static void
+physdev_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_match *match)
+{
+	const struct xt_physdev_info *info = (const void *)match->data;
+
+	switch (errcode) {
+	case XT_PHYSDEV_ERR_MASK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Missing mandatory options.");
+		break;
+	case XT_PHYSDEV_ERR_UNKNOWN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' does not supported by the kernel.",
+			info->bitmask & XT_PHYSDEV_OP_ISIN ? "physdev-is-in" :
+			info->bitmask & XT_PHYSDEV_OP_IN ? "physdev-in" :
+			info->bitmask & XT_PHYSDEV_OP_ISOUT ? "physdev-is-out" :
+			info->bitmask & XT_PHYSDEV_OP_OUT ? "physdev-out" :
+			info->bitmask & XT_PHYSDEV_OP_BRIDGED ? "physdev-is-bridged" :
+			"fixme");
+		break;
+	case XT_PHYSDEV_ERR_UNSUPPORTED_HOOKS_234:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Using --physdev-out in the OUTPUT, FORWARD and "
+			"POSTROUTING chains for non-bridged "
+			"traffic is not supported anymore.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 physdev_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_physdev_info *info = (const void *)match->data;
@@ -169,6 +202,7 @@ static struct xtables_match physdev_match = {
 	.help		= physdev_help,
 	.parse		= physdev_parse,
 	.final_check	= physdev_check,
+	.kernel_error	= physdev_error,
 	.print		= physdev_print,
 	.save		= physdev_save,
 	.extra_opts	= physdev_opts,
@@ -183,6 +217,7 @@ static struct xtables_match physdev_match6 = {
 	.help		= physdev_help,
 	.parse		= physdev_parse,
 	.final_check	= physdev_check,
+	.kernel_error	= physdev_error,
 	.print		= physdev_print,
 	.save		= physdev_save,
 	.extra_opts	= physdev_opts,
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index d17b1bb..93b7cac 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -327,6 +327,35 @@ static void policy_check(unsigned int flags)
 	}
 }
 
+static void
+policy_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_POLICY_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Neither incoming nor outgoing policy selected.");
+		break;
+	case XT_POLICY_ERR_INVALID_OUTPUT_HOOKS_01:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Output policy not valid in the "
+			"PREROUTING and INPUT chains.");
+		break;
+	case XT_POLICY_ERR_INVALID_INPUT_HOOKS_34:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Input policy not valid in the "
+			"POSTROUTING and OUTPUT chains.");
+		break;
+	case XT_POLICY_ERR_MAX_ELEM:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Too many policy elements specified.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_mode(const char *prefix, u_int8_t mode, int numeric)
 {
 	printf("%smode ", prefix);
@@ -487,6 +516,7 @@ static struct xtables_match policy_mt_reg = {
 	.help		= policy_help,
 	.parse		= policy4_parse,
 	.final_check	= policy_check,
+	.kernel_error	= policy_error,
 	.print		= policy4_print,
 	.save		= policy4_save,
 	.extra_opts	= policy_opts,
@@ -501,6 +531,7 @@ static struct xtables_match policy_mt6_reg = {
 	.help		= policy_help,
 	.parse		= policy6_parse,
 	.final_check	= policy_check,
+	.kernel_error	= policy_error,
 	.print		= policy6_print,
 	.save		= policy6_save,
 	.extra_opts	= policy_opts,
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 0ccc94b..16457a4 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -73,6 +73,28 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+quota_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+	struct xt_quota_info *info = (struct xt_quota_info *) match->data;
+
+	switch (errcode) {
+	case XT_QUOTA_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' is unknown for the kernel.",
+			info->flags & XT_QUOTA_INVERT ? "!" : "fixme");
+		break;
+	case XT_QUOTA_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_match quota_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "quota",
@@ -81,6 +103,7 @@ static struct xtables_match quota_match = {
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
 	.help		= quota_help,
 	.parse		= quota_parse,
+	.kernel_error	= quota_error,
 	.print		= quota_print,
 	.save		= quota_save,
 	.extra_opts	= quota_opts,
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 54a7579..4727b9f 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -317,6 +317,40 @@ rateest_final_check(unsigned int flags)
 }
 
 static void
+rateest_error(u_int8_t errcode, u_int8_t family,
+	      const struct xt_entry_match *match)
+{
+	struct xt_rateest_match_info *info = 
+		(struct xt_rateest_match_info *) match->data;
+
+	switch (errcode) {
+	case XT_RATEEST_ERR_ABS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"No rate estimator specified.");
+		break;
+	case XT_RATEEST_ERR_BPS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"No bytes per second or packets per second comparison specified.");
+		break;
+	case XT_RATEEST_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Missing comparison method (rateest-lt/rateest-gt/-rateest-eq).");
+		break;
+	case XT_RATEEST_ERR_NAME1:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown first rate estimator `%s'.", info->name1);
+		break;
+	case XT_RATEEST_ERR_NAME2:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown second rate estimator `%s'.", info->name2);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 rateest_print_rate(u_int32_t rate, int numeric)
 {
 	double tmp = (double)rate*8;
@@ -440,6 +474,7 @@ static struct xtables_match rateest_mt_reg = {
 	.help		= rateest_help,
 	.parse		= rateest_parse,
 	.final_check	= rateest_final_check,
+	.kernel_error	= rateest_error,
 	.print		= rateest_print,
 	.save		= rateest_save,
 	.extra_opts	= rateest_opts,
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 47c35ff..a4a3e26 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -158,6 +158,50 @@ static void recent_check(unsigned int flags)
 		           "--update");
 }
 
+static void
+recent_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_match *match)
+{
+	struct xt_recent_mtinfo *info = (struct xt_recent_mtinfo *) match->data;
+
+	switch (errcode) {
+	case XT_RECENT_ERR_CHECK_SET:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"No mode (--set, --remove, --check or --update) specified.");
+		break;
+	case XT_RECENT_ERR_SET:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' cannot be used with mode `%s'.",
+			info->seconds ? "--seconds" : "--hitcount",
+			info->check_set & XT_RECENT_SET ? "--set" : "--remove");
+		break;
+	case XT_RECENT_ERR_HIT_COUNT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"--hit-count parameter may not exceed %lu.",
+			(long unsigned)info->hit_count);
+		break;
+	case XT_RECENT_ERR_NAME:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Missing or too long list name `%s'.", info->name);
+		break;
+	case XT_RECENT_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	case XT_RECENT_ERR_PROC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate /proc data.");
+		break;
+	case XT_RECENT_ERR_PROC_ENTRY:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not create /proc entry.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void recent_print(const void *ip, const struct xt_entry_match *match,
                          int numeric)
 {
@@ -222,6 +266,7 @@ static struct xtables_match recent_mt_reg = {
     .init          = recent_init,
     .parse         = recent_parse,
     .final_check   = recent_check,
+    .kernel_error  = recent_error,
     .print         = recent_print,
     .save          = recent_save,
     .extra_opts    = recent_opts,
@@ -238,6 +283,7 @@ static struct xtables_match recent_mt6_reg = {
 	.init          = recent_init,
 	.parse         = recent_parse,
 	.final_check   = recent_check,
+	.kernel_error  = recent_error,
 	.print         = recent_print,
 	.save          = recent_save,
 	.extra_opts    = recent_opts,
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 829eade..6649c42 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -301,6 +301,49 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static inline const char * print_flags(u_int8_t flags)
+{
+	return (flags & XT_SCTP_SRC_PORTS ? "spt" :
+		flags & XT_SCTP_DEST_PORTS ? "dpt" :
+		flags & XT_SCTP_CHUNK_TYPES ? "chunk-types" :
+		"fixme");
+}
+
+static void
+sctp_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{
+	const struct xt_sctp_info *info =
+		(const struct xt_sctp_info *)match->data;
+
+	switch (errcode) {
+	case XT_SCTP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol SCTP.");
+		break;
+	case XT_SCTP_ERR_INVALID_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown %s`%s' option for the kernel.",
+			info->flags ? " " : "negated ",
+			print_flags(info->flags | info->invflags));
+		break;
+	case XT_SCTP_ERR_FLAG_INVFLAG:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Option `%s' cannot be specified both "
+			"in plain and negated form.",
+			print_flags(info->invflags & ~info->flags));
+		break;
+	case XT_SCTP_ERR_CHUNK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"--chunk-types are set but mode (all|any|only) "
+			"is missing.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static char *
 port_to_service(int port)
 {
@@ -503,6 +546,7 @@ static struct xtables_match sctp_match = {
 	.help		= sctp_help,
 	.init		= sctp_init,
 	.parse		= sctp_parse,
+	.kernel_error	= sctp_error,
 	.print		= sctp_print,
 	.save		= sctp_save,
 	.extra_opts	= sctp_opts,
@@ -517,6 +561,7 @@ static struct xtables_match sctp_match6 = {
 	.help		= sctp_help,
 	.init		= sctp_init,
 	.parse		= sctp_parse,
+	.kernel_error	= sctp_error,
 	.print		= sctp_print,
 	.save		= sctp_save,
 	.extra_opts	= sctp_opts,
diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index eebc7c5..fffb3ef 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <getopt.h>
 #include <xtables.h>
+#include <linux/netfilter/xt_socket.h>
 
 static void socket_mt_help(void)
 {
@@ -22,6 +23,23 @@ static void socket_mt_check(unsigned int flags)
 {
 }
 
+static void
+socket_mt_error(u_int8_t errcode, u_int8_t family,
+	        const struct xt_entry_match *match)
+{
+
+	switch (errcode) {
+	case XT_SOCKET_ERR_HOOKS_0:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match can only be used in the "
+			"PREROUTING chain.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_match socket_mt_reg = {
 	.name	       = "socket",
 	.version       = XTABLES_VERSION,
@@ -30,6 +48,7 @@ static struct xtables_match socket_mt_reg = {
 	.userspacesize = XT_ALIGN(0),
 	.parse	       = socket_mt_parse,
 	.final_check   = socket_mt_check,
+	.kernel_error  = socket_mt_error,
 	.help	       = socket_mt_help,
 };
 
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 7387e26..5ed2e00 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -92,6 +92,22 @@ static void state_final_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, "You must specify \"--state\"");
 }
 
+static void
+state_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_STATE_ERR_CONNTRACK:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't load conntrack support for protocol %s.",
+			family == AF_INET ? "IPv4" : "IPv6");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void state_print_state(unsigned int statemask)
 {
 	const char *sep = "";
@@ -147,6 +163,7 @@ static struct xtables_match state_match = {
 	.help		= state_help,
 	.parse		= state_parse,
 	.final_check	= state_final_check,
+	.kernel_error	= state_error,
 	.print		= state_print,
 	.save		= state_save,
 	.extra_opts	= state_opts,
@@ -161,6 +178,7 @@ static struct xtables_match state_match6 = {
 	.help		= state_help,
 	.parse		= state_parse,
 	.final_check	= state_final_check,
+	.kernel_error	= state_error,
 	.print		= state_print,
 	.save		= state_save,
 	.extra_opts	= state_opts,
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 913aa2c..12beba1 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -124,6 +124,39 @@ static void statistic_check(unsigned int flags)
 	                           global_info->u.nth.packet;
 }
 
+static void
+statistic_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_match *match)
+{
+	const struct xt_statistic_info *info =
+		(const struct xt_statistic_info *)match->data;
+
+	switch (errcode) {
+	case XT_STATISTIC_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' unknown for the kernel.",
+			info->mode == XT_STATISTIC_MODE_RANDOM ? "random" :
+			info->mode == XT_STATISTIC_MODE_NTH ? "nth" :
+			"fixme");
+		break;
+	case  XT_STATISTIC_ERR_FLAGS:
+		if (info->flags & XT_STATISTIC_INVERT)
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Negation is not recognized by the kernel.");
+		else
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Unknown flags value `%u'.", info->flags);
+		break;
+	case XT_STATISTIC_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_match(const struct xt_statistic_info *info, char *prefix)
 {
 	if (info->flags & XT_STATISTIC_INVERT)
@@ -169,6 +202,7 @@ static struct xtables_match statistic_match = {
 	.help		= statistic_help,
 	.parse		= statistic_parse,
 	.final_check	= statistic_check,
+	.kernel_error	= statistic_error,
 	.print		= statistic_print,
 	.save		= statistic_save,
 	.extra_opts	= statistic_opts,
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 18e3ed2..2087a5f 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -255,6 +255,41 @@ static void string_check(unsigned int flags)
 			   "STRING match: You must specify `--algo'");
 }
 
+static void
+string_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_match *match)
+{
+	const struct xt_string_info *info =
+	    (const struct xt_string_info*) match->data;
+	
+	switch (errcode) {
+	case XT_STRING_ERR_OFFSET:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"`--from' offset %u greater than `--to' offset %u.",
+			info->from_offset, info->to_offset);
+		break;
+	case XT_STRING_ERR_ALGO_NAME:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Pattern-matching strategy name too long, "
+			"would be truncated to `%s'.",
+			info->algo);
+		break;
+	case XT_STRING_ERR_PATLEN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Pattern length exceeds the maximum of "
+			"%u characters.",
+			info->patlen);
+		break;
+	case XT_STRING_ERR_PREPARE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not prepare pattern matching data.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 /* Test to see if the string contains non-printable chars or quotes */
 static unsigned short int
 is_hex_string(const char *str, const unsigned short int len)
@@ -361,6 +396,7 @@ static struct xtables_match string_match = {
     .init		= string_init,
     .parse		= string_parse,
     .final_check	= string_check,
+    .kernel_error	= string_error,
     .print		= string_print,
     .save		= string_save,
     .extra_opts		= string_opts,
@@ -377,6 +413,7 @@ static struct xtables_match string_match_v1 = {
     .init		= string_init,
     .parse		= string_parse,
     .final_check	= string_check,
+    .kernel_error	= string_error,
     .print		= string_print,
     .save		= string_save,
     .extra_opts		= string_opts,
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 5ea9ebd..4f4ba31 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -210,6 +210,37 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static inline const char * print_invflags(u_int8_t flags)
+{
+	return (flags & XT_TCP_INV_SRCPT ? "! --sport" :
+		flags & XT_TCP_INV_DSTPT ? "! --dport" :
+		flags & XT_TCP_INV_FLAGS ? "! --tcp-flags" :
+		flags & XT_TCP_INV_OPTION ? "! --tcp-option" :
+		"fixme");
+}
+
+static void
+tcp_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct xt_tcp *info = (const struct xt_tcp *)match->data;
+
+	switch (errcode) {
+	case XT_TCPUDP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol TCP.");
+		break;
+	case XT_TCPUDP_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown `%s' option for the kernel.",
+			print_invflags(info->invflags));
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static char *
 port_to_service(int port)
 {
@@ -383,6 +414,7 @@ static struct xtables_match tcp_match = {
 	.help		= tcp_help,
 	.init		= tcp_init,
 	.parse		= tcp_parse,
+	.kernel_error	= tcp_error,
 	.print		= tcp_print,
 	.save		= tcp_save,
 	.extra_opts	= tcp_opts,
@@ -397,6 +429,7 @@ static struct xtables_match tcp_match6 = {
 	.help		= tcp_help,
 	.init		= tcp_init,
 	.parse		= tcp_parse,
+	.kernel_error	= tcp_error,
 	.print		= tcp_print,
 	.save		= tcp_save,
 	.extra_opts	= tcp_opts,
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 46529f9..2dcb9b9 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -86,6 +86,21 @@ static void tcpmss_check(unsigned int flags)
 }
 
 static void
+tcpmss_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_TCPMSS_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol TCP.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 tcpmss_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_tcpmss_match_info *info = (void *)match->data;
@@ -117,6 +132,7 @@ static struct xtables_match tcpmss_match = {
 	.help		= tcpmss_help,
 	.parse		= tcpmss_parse,
 	.final_check	= tcpmss_check,
+	.kernel_error	= tcpmss_error,
 	.print		= tcpmss_print,
 	.save		= tcpmss_save,
 	.extra_opts	= tcpmss_opts,
@@ -131,6 +147,7 @@ static struct xtables_match tcpmss_match6 = {
 	.help		= tcpmss_help,
 	.parse		= tcpmss_parse,
 	.final_check	= tcpmss_check,
+	.kernel_error	= tcpmss_error,
 	.print		= tcpmss_print,
 	.save		= tcpmss_save,
 	.extra_opts	= tcpmss_opts,
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 098fc9c..2de1240 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -328,6 +328,22 @@ static int time_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+time_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case XT_TIME_ERR_INVALID:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Invalid argument - start or "
+			"stop time greater than 23:59:59.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void time_print_date(time_t date, const char *command)
 {
 	struct tm *t;
@@ -474,6 +490,7 @@ static struct xtables_match time_match = {
 	.help          = time_help,
 	.init          = time_init,
 	.parse         = time_parse,
+	.kernel_error  = time_error,
 	.print         = time_print,
 	.save          = time_save,
 	.extra_opts    = time_opts,
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 4b4e84f..15ff7b9 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -97,6 +97,35 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static inline const char * print_flags(u_int8_t flags)
+{
+	return (flags & XT_UDP_INV_SRCPT ? "! --sport" :
+		flags & XT_UDP_INV_DSTPT ? "! --dport" :
+		"fixme");
+}
+
+static void
+udp_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct xt_udp *info = (const struct xt_udp *)match->data;
+
+	switch (errcode) {
+	case XT_TCPUDP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol UDP.");
+		break;
+	case XT_TCPUDP_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown `%s' option for the kernel.",
+			print_flags(info->invflags));
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static char *
 port_to_service(int port)
 {
@@ -199,6 +228,7 @@ static struct xtables_match udp_match = {
 	.help		= udp_help,
 	.init		= udp_init,
 	.parse		= udp_parse,
+	.kernel_error	= udp_error,
 	.print		= udp_print,
 	.save		= udp_save,
 	.extra_opts	= udp_opts,
@@ -213,6 +243,7 @@ static struct xtables_match udp_match6 = {
 	.help		= udp_help,
 	.init		= udp_init,
 	.parse		= udp_parse,
+	.kernel_error	= udp_error,
 	.print		= udp_print,
 	.save		= udp_save,
 	.extra_opts	= udp_opts,
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
index 5811135..ca68425 100644
--- a/include/linux/netfilter/xt_CLASSIFY.h
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -1,6 +1,13 @@
 #ifndef _XT_CLASSIFY_H
 #define _XT_CLASSIFY_H
 
+enum {
+	XT_CLASSIFY_ERR_NONE,
+	XT_CLASSIFY_ERR_MANGLE_TABLE,
+	XT_CLASSIFY_ERR_HOOKS_234,
+	XT_CLASSIFY_ERR_MAX,
+};
+
 struct xt_classify_target_info {
 	u_int32_t priority;
 };
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 4e58ba4..1280650 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -11,6 +11,14 @@
  */
 
 enum {
+	XT_CONNMARK_ERR_NONE,
+	XT_CONNMARK_ERR_MANGLE_TABLE,
+	XT_CONNMARK_ERR_32BIT_MARK,
+	XT_CONNMARK_ERR_CONNTRACK,
+	XT_CONNMARK_ERR_MAX,
+};	
+
+enum {
 	XT_CONNMARK_SET = 0,
 	XT_CONNMARK_SAVE,
 	XT_CONNMARK_RESTORE
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
index c6bd754..1327201 100644
--- a/include/linux/netfilter/xt_CONNSECMARK.h
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -2,6 +2,14 @@
 #define _XT_CONNSECMARK_H_target
 
 enum {
+	XT_CONNSECMARK_ERR_NONE,
+	XT_CONNSECMARK_ERR_MANGLE_SECURITY_TABLES,
+	XT_CONNSECMARK_ERR_MODE,
+	XT_CONNSECMARK_ERR_CONNTRACK,
+	XT_CONNSECMARK_ERR_MAX,
+};
+
+enum {
 	CONNSECMARK_SAVE = 1,
 	CONNSECMARK_RESTORE,
 };
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
index 778b278..b2bd30c 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -1,6 +1,14 @@
 #ifndef _XT_MARK_H_target
 #define _XT_MARK_H_target
 
+enum {
+	XT_MARK_ERR_NONE,
+	XT_MARK_ERR_MANGLE_TABLE,
+	XT_MARK_ERR_32BIT_MARK,
+	XT_MARK_ERR_MODE,
+	XT_MARK_ERR_MAX,
+};
+
 /* Version 0 */
 struct xt_mark_target_info {
 	unsigned long mark;
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index cdcd0ed..1dc29b4 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -6,6 +6,13 @@
 
 #define XT_NFLOG_MASK			0x0
 
+enum {
+	XT_NFLOG_ERR_NONE,
+	XT_NFLOG_ERR_FLAGS,
+	XT_NFLOG_ERR_PREFIXLEN,
+	XT_NFLOG_ERR_MAX,
+};
+
 struct xt_nflog_info {
 	u_int32_t	len;
 	u_int16_t	group;
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 9a9af79..8307a99 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -8,6 +8,13 @@
 #ifndef _XT_NFQ_TARGET_H
 #define _XT_NFQ_TARGET_H
 
+enum {
+	XT_NFQUEUE_ERR_NONE,
+	XT_NFQUEUE_ERR_TOTAL_QUEUES,
+	XT_NFQUEUE_ERR_RANGE,
+	XT_NFQUEUE_ERR_MAX,
+};
+
 /* target info */
 struct xt_NFQ_info {
 	u_int16_t queuenum;
diff --git a/include/linux/netfilter/xt_NOTRACK.h b/include/linux/netfilter/xt_NOTRACK.h
new file mode 100644
index 0000000..a095f97
--- /dev/null
+++ b/include/linux/netfilter/xt_NOTRACK.h
@@ -0,0 +1,10 @@
+#ifndef _X_NOTRACK_H
+#define _X_NOTRACK_H
+
+enum {
+	XT_NOTRACK_ERR_NONE,
+	XT_NOTRACK_ERR_RAW_TABLE,
+	XT_NOTRACK_ERR_MAX,
+};
+
+#endif /*_X_NOTRACK_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index f79e313..391d23b 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -1,6 +1,14 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
+enum {
+	XT_RATEEST_ERR_NONE,
+	XT_RATEEST_ERR_NAME,
+	XT_RATEEST_ERR_ALLOC,
+	XT_RATEEST_ERR_GEN_NEW,
+	XT_RATEEST_ERR_MAX,
+};
+
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
 	int8_t			interval;
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index c53fbff..07d481a 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -11,6 +11,17 @@
 #define SECMARK_MODE_SEL	0x01		/* SELinux */
 #define SECMARK_SELCTX_MAX	256
 
+enum {
+	XT_SECMARK_ERR_NONE,
+	XT_SECMARK_ERR_MANGLE_SECURITY_TABLE,
+	XT_SECMARK_ERR_MIXED_MODE,
+	XT_SECMARK_ERR_INVALID_MODE,
+	XT_SECMARK_ERR_CONTEXT,
+	XT_SECMARK_ERR_MAP_CONTEXT,
+	XT_SECMARK_ERR_PERM,
+	XT_SECMARK_ERR_MAX,
+};
+
 struct xt_secmark_target_selinux_info {
 	u_int32_t selsid;
 	char selctx[SECMARK_SELCTX_MAX];
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
index 53a292c..4999e6d 100644
--- a/include/linux/netfilter/xt_TCPMSS.h
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -1,6 +1,14 @@
 #ifndef _XT_TCPMSS_H
 #define _XT_TCPMSS_H
 
+enum {
+	XT_TCPMSS_ERR_NONE,
+	XT_TCPMSS_ERR_PROTO,
+	XT_TCPMSS_ERR_HOOKS_234,
+	XT_TCPMSS_ERR_SYN,
+	XT_TCPMSS_ERR_MAX,
+};
+
 struct xt_tcpmss_info {
 	u_int16_t mss;
 };
diff --git a/include/linux/netfilter/xt_TCPOPTSTRIP.h b/include/linux/netfilter/xt_TCPOPTSTRIP.h
index 2db5432..0cec1e1 100644
--- a/include/linux/netfilter/xt_TCPOPTSTRIP.h
+++ b/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -6,6 +6,13 @@
 #define tcpoptstrip_test_bit(bmap, idx) \
 	(((1U << (idx & 31)) & bmap[(idx) >> 5]) != 0)
 
+enum {
+	XT_TCPOPTSTRIP_ERR_NONE,
+	XT_TCPOPTSTRIP_ERR_MANGLE_TABLE,
+	XT_TCPOPTSTRIP_ERR_PROTO,
+	XT_TCPOPTSTRIP_ERR_MAX,
+};
+
 struct xt_tcpoptstrip_target_info {
 	u_int32_t strip_bmap[8];
 };
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
index 152e8f9..068a385 100644
--- a/include/linux/netfilter/xt_TPROXY.h
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -1,6 +1,14 @@
 #ifndef _XT_TPROXY_H_target
 #define _XT_TPROXY_H_target
 
+enum {
+	XT_TPROXY_ERR_NONE,
+	XT_TPROXY_ERR_MANGLE_TABLE,
+	XT_TPROXY_ERR_HOOKS_0,
+	XT_TPROXY_ERR_PROTO,
+	XT_TPROXY_ERR_MAX,
+};
+
 /* TPROXY target is capable of marking the packet to perform
  * redirection. We can get rid of that whenever we get support for
  * mutliple targets in the same rule. */
diff --git a/include/linux/netfilter/xt_TRACE.h b/include/linux/netfilter/xt_TRACE.h
new file mode 100644
index 0000000..1440c1a
--- /dev/null
+++ b/include/linux/netfilter/xt_TRACE.h
@@ -0,0 +1,10 @@
+#ifndef _X_TRACE_H
+#define _X_TRACE_H
+
+enum {
+	XT_TRACE_ERR_NONE,
+	XT_TRACE_ERR_RAW_TABLE,
+	XT_TRACE_ERR_MAX,
+};
+
+#endif /*_X_TRACE_H */
diff --git a/include/linux/netfilter/xt_cluster.h b/include/linux/netfilter/xt_cluster.h
index 8866826..978b688 100644
--- a/include/linux/netfilter/xt_cluster.h
+++ b/include/linux/netfilter/xt_cluster.h
@@ -1,6 +1,13 @@
 #ifndef _XT_CLUSTER_MATCH_H
 #define _XT_CLUSTER_MATCH_H
 
+enum {
+	XT_CLUSTER_ERR_NONE,
+	XT_CLUSTER_ERR_TOTAL_NODES,
+	XT_CLUSTER_ERR_NODE_MASK,
+	XT_CLUSTER_ERR_MAX,
+};
+
 enum xt_cluster_flags {
 	XT_CLUSTER_F_INV	= (1 << 0)
 };
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
index c022c98..9c163c8 100644
--- a/include/linux/netfilter/xt_connbytes.h
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -1,6 +1,14 @@
 #ifndef _XT_CONNBYTES_H
 #define _XT_CONNBYTES_H
 
+enum {
+	XT_CONNBYTES_ERR_NONE,
+	XT_CONNBYTES_ERR_WHAT,
+	XT_CONNBYTES_ERR_DIR,
+	XT_CONNBYTES_ERR_CONNTRACK,
+	XT_CONNBYTES_ERR_MAX,
+};
+
 enum xt_connbytes_what {
 	XT_CONNBYTES_PKTS,
 	XT_CONNBYTES_BYTES,
diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 9ba54e4..99b7380 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -1,6 +1,13 @@
 #ifndef _XT_CONNLIMIT_H
 #define _XT_CONNLIMIT_H
 
+enum {
+	XT_CONNLIMIT_ERR_NONE,
+	XT_CONNLIMIT_ERR_CONNTRACK,
+	XT_CONNLIMIT_ERR_INIT,
+	XT_CONNLIMIT_ERR_MAX,
+};
+
 struct xt_connlimit_data;
 
 struct xt_connlimit_info {
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index 359ef86..bd46956 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -10,6 +10,13 @@
  * (at your option) any later version.
  */
 
+enum {
+	XT_CONNMARK_ERR_NONE,
+	XT_CONNMARK_ERR_32BIT_MARK,
+	XT_CONNMARK_ERR_CONNTRACK,
+	XT_CONNMARK_ERR_MAX,
+};
+
 struct xt_connmark_info {
 	unsigned long mark, mask;
 	u_int8_t invert;
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 8f53452..884df22 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -15,6 +15,12 @@
 #define XT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
 #define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
 
+enum {
+	XT_CONNTRACK_ERR_NONE,
+	XT_CONNTRACK_ERR_CONNTRACK,
+	XT_CONNTRACK_ERR_MAX,
+};
+
 /* flags, invflags: */
 enum {
 	XT_CONNTRACK_STATE        = 1 << 0,
diff --git a/include/linux/netfilter/xt_dccp.h b/include/linux/netfilter/xt_dccp.h
index e0221b9..fc70d9b 100644
--- a/include/linux/netfilter/xt_dccp.h
+++ b/include/linux/netfilter/xt_dccp.h
@@ -8,6 +8,14 @@
 
 #define XT_DCCP_VALID_FLAGS		0x0f
 
+enum {
+	XT_DCCP_ERR_NONE,
+	XT_DCCP_ERR_PROTO,
+	XT_DCCP_ERR_INVALID_FLAGS,
+	XT_DCCP_ERR_FLAG_INVFLAG,
+	XT_DCCP_ERR_MAX,
+};
+
 struct xt_dccp_info {
 	u_int16_t dpts[2];  /* Min, Max */
 	u_int16_t spts[2];  /* Min, Max */
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index f49bc1a..e17a811 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
@@ -14,6 +14,14 @@
 #define XT_DSCP_SHIFT	2
 #define XT_DSCP_MAX	0x3f	/* 00111111 */
 
+enum {
+	XT_DSCP_ERR_NONE,
+	XT_DSCP_ERR_MANGLE_TABLE,
+	XT_DSCP_ERR_RANGE,
+	XT_DSCP_ERR_VALUE,
+	XT_DSCP_ERR_MAX,
+};
+
 /* match info */
 struct xt_dscp_info {
 	u_int8_t dscp;
diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
index 9380fb1..78c146c 100644
--- a/include/linux/netfilter/xt_esp.h
+++ b/include/linux/netfilter/xt_esp.h
@@ -1,6 +1,13 @@
 #ifndef _XT_ESP_H
 #define _XT_ESP_H
 
+enum {
+	XT_ESP_ERR_NONE,
+	XT_ESP_ERR_PROTO,
+	XT_ESP_ERR_FLAGS,
+	XT_ESP_ERR_MAX,
+};
+
 struct xt_esp
 {
 	u_int32_t spis[2];	/* Security Parameter Index */
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 51b18d8..d1bc64c 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -6,6 +6,18 @@
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 
+enum {
+	XT_HASHLIMIT_ERR_NONE,
+	XT_HASHLIMIT_ERR_OVERFLOW,
+	XT_HASHLIMIT_ERR_MODE,
+	XT_HASHLIMIT_ERR_INTERVAL,
+	XT_HASHLIMIT_ERR_EXPIRE,
+	XT_HASHLIMIT_ERR_NAMELEN,
+	XT_HASHLIMIT_ERR_INIT,
+	XT_HASHLIMIT_ERR_NETMASK,
+	XT_HASHLIMIT_ERR_MAX,
+};
+
 /* details of this structure hidden by the implementation */
 struct xt_hashlimit_htable;
 
diff --git a/include/linux/netfilter/xt_helper.h b/include/linux/netfilter/xt_helper.h
index 6b42763..1b43471 100644
--- a/include/linux/netfilter/xt_helper.h
+++ b/include/linux/netfilter/xt_helper.h
@@ -1,6 +1,12 @@
 #ifndef _XT_HELPER_H
 #define _XT_HELPER_H
 
+enum {
+	XT_HELPER_ERR_NONE,
+	XT_HELPER_ERR_CONNTRACK,
+	XT_HELPER_ERR_MAX,
+};
+
 struct xt_helper_info {
 	int invert;
 	char name[30];
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index b3ce653..3368d29 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -4,6 +4,13 @@
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
+enum {
+	XT_LIMIT_ERR_NONE,
+	XT_LIMIT_ERR_OVERFLOW,
+	XT_LIMIT_ERR_ALLOC,
+	XT_LIMIT_ERR_MAX,
+};
+
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct xt_rateinfo {
diff --git a/include/linux/netfilter/xt_mac.h b/include/linux/netfilter/xt_mac.h
index b892cdc..c91695c 100644
--- a/include/linux/netfilter/xt_mac.h
+++ b/include/linux/netfilter/xt_mac.h
@@ -1,6 +1,12 @@
 #ifndef _XT_MAC_H
 #define _XT_MAC_H
 
+enum {
+	XT_MAC_ERR_NONE,
+	XT_MAC_ERR_HOOKS_012,
+	XT_MAC_ERR_MAX,
+};
+
 struct xt_mac_info {
     unsigned char srcaddr[ETH_ALEN];
     int invert;
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
index fae74bc..4d3aa3d 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -1,6 +1,12 @@
 #ifndef _XT_MARK_H
 #define _XT_MARK_H
 
+enum {
+	XT_MARK_ERR_NONE,
+	XT_MARK_ERR_32BIT_MARK,
+	XT_MARK_ERR_MAX,
+};
+
 struct xt_mark_info {
     unsigned long mark, mask;
     u_int8_t invert;
diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
index d49ee41..457ec82 100644
--- a/include/linux/netfilter/xt_multiport.h
+++ b/include/linux/netfilter/xt_multiport.h
@@ -1,6 +1,15 @@
 #ifndef _XT_MULTIPORT_H
 #define _XT_MULTIPORT_H
 
+enum {
+	XT_MULTIPORT_ERR_NONE,
+	XT_MULTIPORT_ERR_PROTO,
+	XT_MULTIPORT_ERR_INV_PROTO,
+	XT_MULTIPORT_ERR_FLAGS,
+	XT_MULTIPORT_ERR_COUNT,
+	XT_MULTIPORT_ERR_MAX,
+};
+
 enum xt_multiport_flags
 {
 	XT_MULTIPORT_SOURCE,
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index c84e52c..3ad4119 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -2,6 +2,13 @@
 #define _XT_OWNER_MATCH_H
 
 enum {
+	XT_OWNER_ERR_NONE,
+	XT_OWNER_ERR_HOOKS_34,
+	XT_OWNER_ERR_UNSUPPORTED,
+	XT_OWNER_ERR_MAX,
+};
+
+enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
 	XT_OWNER_SOCKET = 1 << 2,
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 9d33619..461c517 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -9,6 +9,14 @@
 #define XT_PHYSDEV_OP_ISOUT		0x10
 #define XT_PHYSDEV_OP_MASK		(0x20 - 1)
 
+enum {
+	XT_PHYSDEV_ERR_NONE,
+	XT_PHYSDEV_ERR_MASK,
+	XT_PHYSDEV_ERR_UNKNOWN,
+	XT_PHYSDEV_ERR_UNSUPPORTED_HOOKS_234,
+	XT_PHYSDEV_ERR_MAX,
+};
+
 struct xt_physdev_info {
 	char physindev[IFNAMSIZ];
 	char in_mask[IFNAMSIZ];
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index 303e380..b8c2b1c 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -3,6 +3,15 @@
 
 #define XT_POLICY_MAX_ELEM	4
 
+enum {
+	XT_POLICY_ERR_NONE,
+	XT_POLICY_ERR_FLAGS,
+	XT_POLICY_ERR_INVALID_OUTPUT_HOOKS_01,
+	XT_POLICY_ERR_INVALID_INPUT_HOOKS_34,
+	XT_POLICY_ERR_MAX_ELEM,
+	XT_POLICY_ERR_MAX,
+};
+
 enum xt_policy_flags
 {
 	XT_POLICY_MATCH_IN	= 0x1,
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 4c8368d..9325c0e 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -1,6 +1,13 @@
 #ifndef _XT_QUOTA_H
 #define _XT_QUOTA_H
 
+enum {
+	XT_QUOTA_ERR_NONE,
+	XT_QUOTA_ERR_FLAGS,
+	XT_QUOTA_ERR_ALLOC,
+	XT_QUOTA_ERR_MAX,
+};
+
 enum xt_quota_flags {
 	XT_QUOTA_INVERT		= 0x1,
 };
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 2010cb7..2766f8e 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -1,6 +1,16 @@
 #ifndef _XT_RATEEST_MATCH_H
 #define _XT_RATEEST_MATCH_H
 
+enum {
+	XT_RATEEST_ERR_NONE,
+	XT_RATEEST_ERR_ABS,
+	XT_RATEEST_ERR_BPS,
+	XT_RATEEST_ERR_MODE,
+	XT_RATEEST_ERR_NAME1,
+	XT_RATEEST_ERR_NAME2,
+	XT_RATEEST_ERR_MAX,
+};
+
 enum xt_rateest_match_flags {
 	XT_RATEEST_MATCH_INVERT	= 1<<0,
 	XT_RATEEST_MATCH_ABS	= 1<<1,
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/xt_realm.h
index 220e872..21d1876 100644
--- a/include/linux/netfilter/xt_realm.h
+++ b/include/linux/netfilter/xt_realm.h
@@ -1,6 +1,12 @@
 #ifndef _XT_REALM_H
 #define _XT_REALM_H
 
+enum {
+	XT_REALM_ERR_NONE,
+	XT_REALM_ERR_HOOKS_1234,
+	XT_REALM_ERR_MAX,
+};
+
 struct xt_realm_info {
 	u_int32_t id;
 	u_int32_t mask;
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index 5cfeb81..03bab63 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -2,6 +2,18 @@
 #define _LINUX_NETFILTER_XT_RECENT_H 1
 
 enum {
+	XT_RECENT_ERR_NONE,
+	XT_RECENT_ERR_CHECK_SET,
+	XT_RECENT_ERR_SET,
+	XT_RECENT_ERR_HIT_COUNT,
+	XT_RECENT_ERR_NAME,
+	XT_RECENT_ERR_ALLOC,
+	XT_RECENT_ERR_PROC,
+	XT_RECENT_ERR_PROC_ENTRY,
+	XT_RECENT_ERR_MAX,
+};
+
+enum {
 	XT_RECENT_CHECK    = 1 << 0,
 	XT_RECENT_SET      = 1 << 1,
 	XT_RECENT_UPDATE   = 1 << 2,
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index d41af84..00c18a7 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -7,6 +7,15 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
+enum {
+	XT_SCTP_ERR_NONE,
+	XT_SCTP_ERR_PROTO,
+	XT_SCTP_ERR_INVALID_FLAGS,
+	XT_SCTP_ERR_FLAG_INVFLAG,
+	XT_SCTP_ERR_CHUNK,
+	XT_SCTP_ERR_MAX,
+};
+
 struct xt_sctp_flag_info {
 	u_int8_t chunktype;
 	u_int8_t flag;
diff --git a/include/linux/netfilter/xt_socket.h b/include/linux/netfilter/xt_socket.h
new file mode 100644
index 0000000..f607349
--- /dev/null
+++ b/include/linux/netfilter/xt_socket.h
@@ -0,0 +1,10 @@
+#ifndef _XT_SOCKET_H
+#define _XT_SOCKET_H
+
+enum {
+	XT_SOCKET_ERR_NONE,
+	XT_SOCKET_ERR_HOOKS_0,
+	XT_SOCKET_ERR_MAX,
+};
+
+#endif /* _XT_SOCKET_H */
diff --git a/include/linux/netfilter/xt_state.h b/include/linux/netfilter/xt_state.h
index c06f32e..14c9ea1 100644
--- a/include/linux/netfilter/xt_state.h
+++ b/include/linux/netfilter/xt_state.h
@@ -6,6 +6,12 @@
 
 #define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 
+enum {
+	XT_STATE_ERR_NONE,
+	XT_STATE_ERR_CONNTRACK,
+	XT_STATE_ERR_MAX,
+};
+
 struct xt_state_info
 {
 	unsigned int statemask;
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 3d38bc9..57a6b80 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -1,6 +1,14 @@
 #ifndef _XT_STATISTIC_H
 #define _XT_STATISTIC_H
 
+enum {
+	XT_STATISTIC_ERR_NONE,
+	XT_STATISTIC_ERR_MODE,
+	XT_STATISTIC_ERR_FLAGS,
+	XT_STATISTIC_ERR_ALLOC,
+	XT_STATISTIC_ERR_MAX,
+};
+
 enum xt_statistic_mode {
 	XT_STATISTIC_MODE_RANDOM,
 	XT_STATISTIC_MODE_NTH,
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index 8a6ba7b..62fd101 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -5,6 +5,16 @@
 #define XT_STRING_MAX_ALGO_NAME_SIZE 16
 
 enum {
+	XT_STRING_ERR_NONE,
+	XT_STRING_ERR_OFFSET,
+	XT_STRING_ERR_ALGO_NAME,
+	XT_STRING_ERR_PATLEN,
+	XT_STRING_ERR_IGNORECASE,
+	XT_STRING_ERR_PREPARE,
+	XT_STRING_ERR_MAX,
+};
+
+enum {
 	XT_STRING_FLAG_INVERT		= 0x01,
 	XT_STRING_FLAG_IGNORECASE	= 0x02
 };
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
index e03274c..60f92b4 100644
--- a/include/linux/netfilter/xt_tcpmss.h
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -1,6 +1,12 @@
 #ifndef _XT_TCPMSS_MATCH_H
 #define _XT_TCPMSS_MATCH_H
 
+enum {
+	XT_TCPMSS_ERR_NONE,
+	XT_TCPMSS_ERR_PROTO,
+	XT_TCPMSS_ERR_MAX,
+};
+
 struct xt_tcpmss_match_info {
     u_int16_t mss_min, mss_max;
     u_int8_t invert;
diff --git a/include/linux/netfilter/xt_tcpudp.h b/include/linux/netfilter/xt_tcpudp.h
index 78bc65f..c127f62 100644
--- a/include/linux/netfilter/xt_tcpudp.h
+++ b/include/linux/netfilter/xt_tcpudp.h
@@ -1,6 +1,13 @@
 #ifndef _XT_TCPUDP_H
 #define _XT_TCPUDP_H
 
+enum {
+	XT_TCPUDP_ERR_NONE,
+	XT_TCPUDP_ERR_PROTO,
+	XT_TCPUDP_ERR_FLAGS,
+	XT_TCPUDP_ERR_MAX,
+};
+
 /* TCP matching stuff */
 struct xt_tcp
 {
diff --git a/include/linux/netfilter/xt_time.h b/include/linux/netfilter/xt_time.h
index 14b6df4..dae46c2 100644
--- a/include/linux/netfilter/xt_time.h
+++ b/include/linux/netfilter/xt_time.h
@@ -1,6 +1,12 @@
 #ifndef _XT_TIME_H
 #define _XT_TIME_H 1
 
+enum {
+	XT_TIME_ERR_NONE,
+	XT_TIME_ERR_INVALID,
+	XT_TIME_ERR_MAX,
+};
+
 struct xt_time_info {
 	u_int32_t date_start;
 	u_int32_t date_stop;


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
