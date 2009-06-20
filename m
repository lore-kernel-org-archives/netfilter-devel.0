From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/4] libipt_* extensions
Date: Sun, 21 Jun 2009 00:06:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210005090.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:57565 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbZFTWGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:06:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 8DEC18828D
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:06:10 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0YDRiWQI3Eqo for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:06:10 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id 6F4748828C
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:06:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libipt_* extensions with the error reporting function.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 extensions/libipt_CLUSTERIP.c                |   52 ++++++++++++++++++++++++++
 extensions/libipt_DNAT.c                     |   35 ++++++++++++++++++
 extensions/libipt_ECN.c                      |   43 ++++++++++++++++++++++
 extensions/libipt_LOG.c                      |   25 +++++++++++++
 extensions/libipt_MASQUERADE.c               |   32 ++++++++++++++++
 extensions/libipt_NETMAP.c                   |   32 ++++++++++++++++
 extensions/libipt_REDIRECT.c                 |   32 ++++++++++++++++
 extensions/libipt_REJECT.c                   |   31 ++++++++++++++++
 extensions/libipt_SNAT.c                     |   35 ++++++++++++++++++
 extensions/libipt_TTL.c                      |   35 ++++++++++++++++++
 extensions/libipt_ULOG.c                     |   26 +++++++++++++
 extensions/libipt_addrtype.c                 |   28 ++++++++++++++
 extensions/libipt_ah.c                       |   26 +++++++++++++
 extensions/libipt_ecn.c                      |   38 +++++++++++++++++++
 extensions/libipt_icmp.c                     |   22 +++++++++++
 extensions/libipt_realm.c                    |   18 +++++++++
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h |   12 ++++++
 include/linux/netfilter_ipv4/ipt_ECN.h       |    9 +++++
 include/linux/netfilter_ipv4/ipt_LOG.h       |    7 ++++
 include/linux/netfilter_ipv4/ipt_NAT.h       |   17 +++++++++
 include/linux/netfilter_ipv4/ipt_REJECT.h    |    9 +++++
 include/linux/netfilter_ipv4/ipt_ULOG.h      |    7 ++++
 include/linux/netfilter_ipv4/ipt_addrtype.h  |    8 ++++
 include/linux/netfilter_ipv4/ipt_ah.h        |    7 ++++
 include/linux/netfilter_ipv4/ipt_ecn.h       |    8 ++++
 25 files changed, 594 insertions(+), 0 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 279aacf..0339aaa 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -164,6 +164,57 @@ static void CLUSTERIP_check(unsigned int flags)
 	xtables_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
 }
 
+static void
+CLUSTERIP_error(u_int8_t errcode, u_int8_t family,
+		const struct xt_entry_target *target)
+{
+	const struct ipt_clusterip_tgt_info *info =
+		(const struct ipt_clusterip_tgt_info *)target->data;
+
+	switch (errcode) {
+	case IPT_CLUSTERIP_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			info->hash_mode == CLUSTERIP_HASHMODE_SIP
+				? "sourceip" :
+			info->hash_mode == CLUSTERIP_HASHMODE_SIP_SPT
+				? "sourceip-sourceport" :
+			info->hash_mode == CLUSTERIP_HASHMODE_SIP_SPT_DPT
+				? "sourceip-sourceport-destport" :
+			"fixme");
+		break;
+	case IPT_CLUSTERIP_ERR_DEST:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Destination IP not specfified.");
+		break;
+	case IPT_CLUSTERIP_ERR_CONFIG:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"No configuration found for the destination "
+			"IP address, you need a rule with 'new' option first.");
+		break;
+	case IPT_CLUSTERIP_ERR_NO_IFACE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Interface specification in the rule required.");
+		break;
+	case IPT_CLUSTERIP_ERR_UNKNOWN_IFACE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Interface specified in the rule cannot be found.");
+		break;
+	case IPT_CLUSTERIP_ERR_ALLOC:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Kernel could not allocate memory area for private data.");
+		break;
+	case IPT_CLUSTERIP_ERR_CONNTRACK:
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
 static char *hashmode2str(enum clusterip_hashmode mode)
 {
 	char *retstr;
@@ -238,6 +289,7 @@ static struct xtables_target clusterip_tg_reg = {
  	.help		= CLUSTERIP_help,
 	.parse		= CLUSTERIP_parse,
 	.final_check	= CLUSTERIP_check,
+	.kernel_error	= CLUSTERIP_error,
 	.print		= CLUSTERIP_print,
 	.save		= CLUSTERIP_save,
 	.extra_opts	= CLUSTERIP_opts,
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 8b2caec..96569ce 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -8,6 +8,7 @@
 #include <iptables.h> /* get_kernel_version */
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat.h>
 
 #define IPT_DNAT_OPT_DEST 0x1
@@ -216,6 +217,39 @@ static void print_range(const struct nf_nat_range *r)
 	}
 }
 
+static void
+DNAT_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_NAT_ERR_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"nat\" table.");
+		break;
+	case IPT_NAT_ERR_DNAT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"PREROUTING and OUTPUT chains.");
+		break;
+	case IPT_NAT_ERR_RANGESIZE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Multiple ranges no longer supported.");
+		break;
+	case IPT_NAT_ERR_MAP_IPS:
+	case IPT_NAT_ERR_MASQ_HOOKS_4:
+	case IPT_NAT_ERR_NETMAP_HOOKS_034:
+	case IPT_NAT_ERR_REDIRECT_HOOKS_03:
+	case IPT_NAT_ERR_SNAT_HOOKS_4:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Something screwed up: report it!");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void DNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
@@ -258,6 +292,7 @@ static struct xtables_target dnat_tg_reg = {
 	.help		= DNAT_help,
 	.parse		= DNAT_parse,
 	.final_check	= DNAT_check,
+	.kernel_error	= DNAT_error,
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.extra_opts	= DNAT_opts,
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index bf1f8a5..dceb775 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -103,6 +103,48 @@ static void ECN_check(unsigned int flags)
 		           "ECN target: Parameter --ecn-tcp-remove is required");
 }
 
+static inline const char * print_flags(u_int16_t flags)
+{
+	return (flags & IPT_ECN_OP_SET_CWR ? "--ecn-tcp-cwr" :
+		flags & IPT_ECN_OP_SET_ECE ? "--ecn-tcp-ece" :
+		flags & IPT_ECN_OP_SET_IP ? "--ecn-ip-ect" :
+		"fixme");
+}
+
+static void
+ECN_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_target *target)
+{
+	const struct ipt_ECN_info *info =
+		(const struct ipt_ECN_info *)target->data;
+
+	switch (errcode) {
+	case IPT_ECN_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"ECN target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case IPT_ECN_ERR_OPERATION:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown `%s' option for the kernel.",
+			print_flags(info->operation));
+		break;
+	case IPT_ECN_ERR_ECT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"New ECT codepoint `%x' is out of mask.",
+			info->ip_ect);
+		break;
+	case IPT_ECN_ERR_NOT_TCP:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Cannot use TCP operation in a rule "
+			"which does not match TCP packets.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void ECN_print(const void *ip, const struct xt_entry_target *target,
                       int numeric)
 {
@@ -158,6 +200,7 @@ static struct xtables_target ecn_tg_reg = {
 	.help		= ECN_help,
 	.parse		= ECN_parse,
 	.final_check	= ECN_check,
+	.kernel_error	= ECN_error,
 	.print		= ECN_print,
 	.save		= ECN_save,
 	.extra_opts	= ECN_opts,
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 5b90033..43b0b91 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -186,6 +186,30 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+LOG_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_target *target)
+{
+	const struct ipt_log_info *info = 
+		(struct ipt_log_info *)target->data;
+
+	switch (errcode) {
+	case IPT_LOG_ERR_LEVEL:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Invalid log level: %u >= 8.", info->level);
+		break;
+	case IPT_LOG_ERR_PREFIXLEN:
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
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
                       int numeric)
 {
@@ -253,6 +277,7 @@ static struct xtables_target log_tg_reg = {
     .help          = LOG_help,
     .init          = LOG_init,
     .parse         = LOG_parse,
+    .kernel_error  = LOG_error,
     .print         = LOG_print,
     .save          = LOG_save,
     .extra_opts    = LOG_opts,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 90084d8..3f37f69 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -7,6 +7,7 @@
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat.h>
 
 static void MASQUERADE_help(void)
@@ -108,6 +109,36 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+MASQUERADE_error(u_int8_t errcode, u_int8_t family,
+		 const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_NAT_ERR_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"nat\" table.");
+		break;
+	case IPT_NAT_ERR_MASQ_HOOKS_4:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"POSTROUTING chain.");
+		break;
+	case IPT_NAT_ERR_MAP_IPS:
+	case IPT_NAT_ERR_RANGESIZE:
+	case IPT_NAT_ERR_NETMAP_HOOKS_034:
+	case IPT_NAT_ERR_REDIRECT_HOOKS_03:
+	case IPT_NAT_ERR_SNAT_HOOKS_4:
+	case IPT_NAT_ERR_DNAT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Something screwed up: report it!");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
                  int numeric)
 {
@@ -152,6 +183,7 @@ static struct xtables_target masquerade_tg_reg = {
 	.help		= MASQUERADE_help,
 	.init		= MASQUERADE_init,
 	.parse		= MASQUERADE_parse,
+	.kernel_error	= MASQUERADE_error,
 	.print		= MASQUERADE_print,
 	.save		= MASQUERADE_save,
 	.extra_opts	= MASQUERADE_opts,
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f03c05b..fdb5c21 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -9,6 +9,7 @@
 #include <getopt.h>
 #include <xtables.h>
 #include <net/netfilter/nf_nat.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 
 #define MODULENAME "NETMAP"
 
@@ -137,6 +138,36 @@ static void NETMAP_check(unsigned int flags)
 			   MODULENAME" needs --%s", NETMAP_opts[0].name);
 }
 
+static void
+NETMAP_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_NAT_ERR_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"nat\" table.");
+		break;
+	case IPT_NAT_ERR_NETMAP_HOOKS_034:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"PREROUTING, OUTPUT and POSTROUTING chains.");
+		break;
+	case IPT_NAT_ERR_MAP_IPS:
+	case IPT_NAT_ERR_RANGESIZE:
+	case IPT_NAT_ERR_MASQ_HOOKS_4:
+	case IPT_NAT_ERR_REDIRECT_HOOKS_03:
+	case IPT_NAT_ERR_SNAT_HOOKS_4:
+	case IPT_NAT_ERR_DNAT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Something screwed up: report it!");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
@@ -171,6 +202,7 @@ static struct xtables_target netmap_tg_reg = {
 	.init		= NETMAP_init,
 	.parse		= NETMAP_parse,
 	.final_check	= NETMAP_check,
+	.kernel_error	= NETMAP_error,
 	.print		= NETMAP_print,
 	.save		= NETMAP_save,
 	.extra_opts	= NETMAP_opts,
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 01f9d0f..efbec5e 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -7,6 +7,7 @@
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat.h>
 
 #define IPT_REDIRECT_OPT_DEST	0x01
@@ -121,6 +122,36 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	}
 }
 
+static void
+REDIRECT_error(u_int8_t errcode, u_int8_t family,
+	       const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_NAT_ERR_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"nat\" table.");
+		break;
+	case IPT_NAT_ERR_REDIRECT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"PREROUTING and OUTPUT chains.");
+		break;
+	case IPT_NAT_ERR_MAP_IPS:
+	case IPT_NAT_ERR_RANGESIZE:
+	case IPT_NAT_ERR_MASQ_HOOKS_4:
+	case IPT_NAT_ERR_NETMAP_HOOKS_034:
+	case IPT_NAT_ERR_SNAT_HOOKS_4:
+	case IPT_NAT_ERR_DNAT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Something screwed up: report it!");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
                            int numeric)
 {
@@ -163,6 +194,7 @@ static struct xtables_target redirect_tg_reg = {
 	.help		= REDIRECT_help,
 	.init		= REDIRECT_init,
  	.parse		= REDIRECT_parse,
+ 	.kernel_error	= REDIRECT_error,
 	.print		= REDIRECT_print,
 	.save		= REDIRECT_save,
 	.extra_opts	= REDIRECT_opts,
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 888ff39..52d6707 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -121,6 +121,36 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+REJECT_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_REJECT_ERR_FILTER_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"filter\" table.");
+		break;
+	case IPT_REJECT_ERR_HOOKS_123:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"INPUT, FORWARD and OUTPUT chains.");
+		break;
+	case IPT_REJECT_ERR_ECHOREPLY:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Reject with echo-reply is no longer supported.");
+		break;
+	case IPT_REJECT_ERR_NOT_TCP:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Reject with TCP RESET cannot be used in a rule "
+			"which does not match TCP packets.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void REJECT_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
@@ -156,6 +186,7 @@ static struct xtables_target reject_tg_reg = {
 	.help		= REJECT_help,
 	.init		= REJECT_init,
 	.parse		= REJECT_parse,
+	.kernel_error	= REJECT_error,
 	.print		= REJECT_print,
 	.save		= REJECT_save,
 	.extra_opts	= REJECT_opts,
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index e592d80..bdbddf7 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -8,6 +8,7 @@
 #include <iptables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_NAT.h>
 #include <net/netfilter/nf_nat.h>
 
 #define IPT_SNAT_OPT_SOURCE 0x01
@@ -216,6 +217,39 @@ static void print_range(const struct nf_nat_range *r)
 	}
 }
 
+static void
+SNAT_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IPT_NAT_ERR_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"nat\" table.");
+		break;
+	case IPT_NAT_ERR_SNAT_HOOKS_4:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"POSTROUTING chain.");
+		break;
+	case IPT_NAT_ERR_RANGESIZE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Multiple ranges no longer supported.");
+		break;
+	case IPT_NAT_ERR_MAP_IPS:
+	case IPT_NAT_ERR_MASQ_HOOKS_4:
+	case IPT_NAT_ERR_NETMAP_HOOKS_034:
+	case IPT_NAT_ERR_REDIRECT_HOOKS_03:
+	case IPT_NAT_ERR_DNAT_HOOKS_03:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Something screwed up: report it!");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void SNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
@@ -258,6 +292,7 @@ static struct xtables_target snat_tg_reg = {
 	.help		= SNAT_help,
 	.parse		= SNAT_parse,
 	.final_check	= SNAT_check,
+	.kernel_error	= SNAT_error,
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.extra_opts	= SNAT_opts,
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 0e2be0b..411de1c 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -12,6 +12,7 @@
 #include <xtables.h>
 
 #include <linux/netfilter_ipv4/ipt_TTL.h>
+#include <linux/netfilter_ipv6/ip6t_HL.h>
 
 #define IPT_TTL_USED	1
 
@@ -89,6 +90,39 @@ static void TTL_check(unsigned int flags)
 				"TTL: You must specify an action");
 }
 
+static void
+TTL_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_target *target)
+{
+	const struct ipt_TTL_info *info = 
+		(struct ipt_TTL_info *) target->data;
+
+	switch (errcode) {
+	case XT_HL_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"TTL target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_HL_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			info->mode == IPT_TTL_SET ? "--ttl-set" :
+			info->mode == IPT_TTL_INC ? "--ttl-inc" :
+			info->mode == IPT_TTL_DEC ? "--ttl-dec" :
+			"fixme");
+		break;
+	case XT_HL_ERR_SET:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"TTL value cannot be %s by zero.",
+			info->mode == IPT_TTL_INC ? "incremented" :
+			"decremented");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void TTL_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_TTL_info *info = 
@@ -146,6 +180,7 @@ static struct xtables_target ttl_tg_reg = {
 	.help		= TTL_help,
 	.parse		= TTL_parse,
 	.final_check	= TTL_check,
+	.kernel_error	= TTL_error,
 	.print		= TTL_print,
 	.save		= TTL_save,
 	.extra_opts	= TTL_opts,
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 3fa91f2..00bad82 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -143,6 +143,31 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+ULOG_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_target *target)
+{
+	const struct ipt_ulog_info *info = 
+		(struct ipt_ulog_info *)target->data;
+
+	switch (errcode) {
+	case IPT_ULOG_ERR_PREFIXLEN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Log prefix is too long for the kernel, "
+			"it would be truncated to `%s'.",
+			info->prefix);
+		break;
+	case IPT_ULOG_ERR_QLEN:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"The value of the parameter `--ulog-qthreshold' cannot be "
+			"larger than %zu.", info->qthreshold);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void ULOG_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_ulog_info *loginfo
@@ -187,6 +212,7 @@ static struct xtables_target ulog_tg_reg = {
 	.help		= ULOG_help,
 	.init		= ULOG_init,
 	.parse		= ULOG_parse,
+	.kernel_error	= ULOG_error,
 	.print		= ULOG_print,
 	.save		= ULOG_save,
 	.extra_opts	= ULOG_opts,
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index ecd51b5..5101184 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -197,6 +197,32 @@ static void addrtype_check_v1(unsigned int flags)
 			   "and --limit-iface-out");
 }
 
+static void
+addrtype_error(u_int8_t errcode, u_int8_t family,
+	       const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case IPT_ADDRTYPE_ERR_IFACE_BOTH:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Both incoming and outgoing  "
+			"interface limitation cannot be selected.");
+		break;
+	case IPT_ADDRTYPE_ERR_IFACE_IN_HOOKS_34:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Input interface limitation "
+			"not valid in the POSTROUTING and OUTPUT chains.");
+		break;
+	case IPT_ADDRTYPE_ERR_IFACE_OUT_HOOKS_01:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Output interface limitation "
+			"not valid in the PREROUTING and INPUT chains.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_types(u_int16_t mask)
 {
 	const char *sep = "";
@@ -332,6 +358,7 @@ static struct xtables_match addrtype_mt_reg_v0 = {
 	.help 		= addrtype_help_v0,
 	.parse 		= addrtype_parse_v0,
 	.final_check 	= addrtype_check_v0,
+	.kernel_error	= addrtype_error,
 	.print 		= addrtype_print_v0,
 	.save 		= addrtype_save_v0,
 	.extra_opts 	= addrtype_opts_v0,
@@ -346,6 +373,7 @@ static struct xtables_match addrtype_mt_reg_v1 = {
 	.help 		= addrtype_help_v1,
 	.parse 		= addrtype_parse_v1,
 	.final_check 	= addrtype_check_v1,
+	.kernel_error	= addrtype_error,
 	.print 		= addrtype_print_v1,
 	.save 		= addrtype_save_v1,
 	.extra_opts 	= addrtype_opts_v1,
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index d049b42..e049997 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -96,6 +96,31 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+ah_error(u_int8_t errcode, u_int8_t family,
+	 const struct xt_entry_match *match)
+{
+	const struct ipt_ah *info = (struct ipt_ah *)match->data;
+
+	switch (errcode) {
+	case IPT_AH_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match is only valid for protocol AH.");
+		break;
+	case IPT_AH_ERR_FLAGS:
+		if (info->invflags & IPT_AH_INV_SPI)
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Negation is not recognized by the kernel.");
+		else
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Unknown invflags value `%u'.", info->invflags);
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
@@ -158,6 +183,7 @@ static struct xtables_match ah_mt_reg = {
 	.help 		= ah_help,
 	.init 		= ah_init,
 	.parse 		= ah_parse,
+	.kernel_error	= ah_error,
 	.print 		= ah_print,
 	.save 		= ah_save,
 	.extra_opts 	= ah_opts,
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 3ee190e..20af30a 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -89,6 +89,43 @@ static void ecn_check(unsigned int flags)
 		           "ECN match: some option required");
 }
 
+static inline const char * print_flags(u_int16_t flags)
+{
+	return (flags & IPT_ECN_OP_MATCH_CWR ? "--ecn-tcp-cwr" :
+		flags & IPT_ECN_OP_MATCH_ECE ? "--ecn-tcp-ece" :
+		flags & IPT_ECN_OP_MATCH_IP ? "--ecn-ip-ect" :
+		"fixme");
+}
+
+static void
+ecn_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct ipt_ecn_info *info =
+		(const struct ipt_ecn_info *)match->data;
+
+	switch (errcode) {
+	case IPT_ECN_ERR_OPERATION:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown `%s' option for the kernel.",
+			 print_flags(info->operation));
+		break;
+	case IPT_ECN_ERR_INVERT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown `! %s' option for the kernel.",
+			print_flags(info->invert));
+		break;
+	case IPT_ECN_ERR_NOT_TCP:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Can't match TCP bits in a rule "
+			"which does not match TCP packets.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void ecn_print(const void *ip, const struct xt_entry_match *match,
                       int numeric)
 {
@@ -149,6 +186,7 @@ static struct xtables_match ecn_mt_reg = {
     .help          = ecn_help,
     .parse         = ecn_parse,
     .final_check   = ecn_check,
+    .kernel_error  = ecn_error,
     .print         = ecn_print,
     .save          = ecn_save,
     .extra_opts    = ecn_opts,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 5667955..bfd5231 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -198,6 +198,27 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+icmp_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{
+	const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
+
+	switch (errcode) {
+	case IPT_ICMP_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"icmp match is only valid for protocol ICMP.");
+		break;
+	case IPT_ICMP_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown invflags value `%u'.", info->invflags);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_icmptype(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
 			   int invert,
@@ -274,6 +295,7 @@ static struct xtables_match icmp_mt_reg = {
 	.help		= icmp_help,
 	.init		= icmp_init,
 	.parse		= icmp_parse,
+	.kernel_error	= icmp_error,
 	.print		= icmp_print,
 	.save		= icmp_save,
 	.extra_opts	= icmp_opts,
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index c9e1760..b3aae1a 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -234,6 +234,23 @@ static void realm_check(unsigned int flags)
 			   "realm match: You must specify `--realm'");
 }
 
+static void
+realm_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+
+	switch (errcode) {
+	case XT_REALM_ERR_HOOKS_1234:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match can only be used in the "
+			"POSTROUTING, FORWARD, INPUT and OUTPUT chains.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_match realm_mt_reg = {
 	.name		= "realm",
 	.version	= XTABLES_VERSION,
@@ -243,6 +260,7 @@ static struct xtables_match realm_mt_reg = {
 	.help		= realm_help,
 	.parse		= realm_parse,
 	.final_check	= realm_check,
+	.kernel_error	= realm_error,
 	.print		= realm_print,
 	.save		= realm_save,
 	.extra_opts	= realm_opts,
diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
index e5a3687..257a4bf 100644
--- a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -7,6 +7,18 @@ enum clusterip_hashmode {
     CLUSTERIP_HASHMODE_SIP_SPT_DPT,
 };
 
+enum {
+	IPT_CLUSTERIP_ERR_NONE,
+	IPT_CLUSTERIP_ERR_MODE,
+	IPT_CLUSTERIP_ERR_DEST,
+	IPT_CLUSTERIP_ERR_CONFIG,
+	IPT_CLUSTERIP_ERR_NO_IFACE,
+	IPT_CLUSTERIP_ERR_UNKNOWN_IFACE,
+	IPT_CLUSTERIP_ERR_ALLOC,
+	IPT_CLUSTERIP_ERR_CONNTRACK,
+	IPT_CLUSTERIP_ERR_MAX,
+};
+
 #define CLUSTERIP_HASHMODE_MAX CLUSTERIP_HASHMODE_SIP_SPT_DPT
 
 #define CLUSTERIP_MAX_NODES 16
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter_ipv4/ipt_ECN.h
index 94e0d98..ddf4f6e 100644
--- a/include/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/linux/netfilter_ipv4/ipt_ECN.h
@@ -18,6 +18,15 @@
 
 #define IPT_ECN_OP_MASK		0xce
 
+enum {
+	IPT_ECN_ERR_NONE,
+	IPT_ECN_ERR_MANGLE_TABLE,
+	IPT_ECN_ERR_OPERATION,
+	IPT_ECN_ERR_ECT,
+	IPT_ECN_ERR_NOT_TCP,
+	IPT_ECN_ERR_MAX,
+};
+
 struct ipt_ECN_info {
 	u_int8_t operation;	/* bitset of operations */
 	u_int8_t ip_ect;	/* ECT codepoint of IPv4 header, pre-shifted */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
index 90fa652..b227905 100644
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h
@@ -9,6 +9,13 @@
 #define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
 #define IPT_LOG_MASK		0x1f
 
+enum {
+	IPT_LOG_ERR_NONE,
+	IPT_LOG_ERR_LEVEL,
+	IPT_LOG_ERR_PREFIXLEN,
+	IPT_LOG_ERR_MAX,
+};
+
 struct ipt_log_info {
 	unsigned char level;
 	unsigned char logflags;
diff --git a/include/linux/netfilter_ipv4/ipt_NAT.h b/include/linux/netfilter_ipv4/ipt_NAT.h
new file mode 100644
index 0000000..564ecf4
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_NAT.h
@@ -0,0 +1,17 @@
+#ifndef _IPT_NAT_H
+#define _IPT_NAT_H
+
+enum {
+	IPT_NAT_ERR_NONE,
+	IPT_NAT_ERR_TABLE,
+	IPT_NAT_ERR_MASQ_HOOKS_4,
+	IPT_NAT_ERR_NETMAP_HOOKS_034,
+	IPT_NAT_ERR_REDIRECT_HOOKS_03,
+	IPT_NAT_ERR_SNAT_HOOKS_4,
+	IPT_NAT_ERR_DNAT_HOOKS_03,
+	IPT_NAT_ERR_MAP_IPS,
+	IPT_NAT_ERR_RANGESIZE,
+	IPT_NAT_ERR_MAX,
+};
+
+#endif
diff --git a/include/linux/netfilter_ipv4/ipt_REJECT.h b/include/linux/netfilter_ipv4/ipt_REJECT.h
index 4293a1a..89ba84e 100644
--- a/include/linux/netfilter_ipv4/ipt_REJECT.h
+++ b/include/linux/netfilter_ipv4/ipt_REJECT.h
@@ -13,6 +13,15 @@ enum ipt_reject_with {
 	IPT_ICMP_ADMIN_PROHIBITED
 };
 
+enum {
+	IPT_REJECT_ERR_NONE,
+	IPT_REJECT_ERR_FILTER_TABLE,
+	IPT_REJECT_ERR_HOOKS_123,
+	IPT_REJECT_ERR_ECHOREPLY,
+	IPT_REJECT_ERR_NOT_TCP,
+	IPT_REJECT_ERR_MAX,
+};
+
 struct ipt_reject_info {
 	enum ipt_reject_with with;      /* reject type */
 };
diff --git a/include/linux/netfilter_ipv4/ipt_ULOG.h b/include/linux/netfilter_ipv4/ipt_ULOG.h
index 417aad2..2129672 100644
--- a/include/linux/netfilter_ipv4/ipt_ULOG.h
+++ b/include/linux/netfilter_ipv4/ipt_ULOG.h
@@ -23,6 +23,13 @@
  * Assuming a standard ethernet-mtu of 1500, we could define this up
  * to 80... but even 50 seems to be big enough. */
 
+enum {
+	IPT_ULOG_ERR_NONE,
+	IPT_ULOG_ERR_PREFIXLEN,
+	IPT_ULOG_ERR_QLEN,
+	IPT_ULOG_ERR_MAX,
+};
+
 /* private data structure for each rule with a ULOG target */
 struct ipt_ulog_info {
 	unsigned int nl_group;
diff --git a/include/linux/netfilter_ipv4/ipt_addrtype.h b/include/linux/netfilter_ipv4/ipt_addrtype.h
index 446de6a..59480c5 100644
--- a/include/linux/netfilter_ipv4/ipt_addrtype.h
+++ b/include/linux/netfilter_ipv4/ipt_addrtype.h
@@ -8,6 +8,14 @@ enum {
 	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
 };
 
+enum {
+	IPT_ADDRTYPE_ERR_NONE,
+	IPT_ADDRTYPE_ERR_IFACE_BOTH,
+	IPT_ADDRTYPE_ERR_IFACE_IN_HOOKS_34,
+	IPT_ADDRTYPE_ERR_IFACE_OUT_HOOKS_01,
+	IPT_ADDRTYPE_ERR_MAX,
+};	
+
 struct ipt_addrtype_info_v1 {
 	u_int16_t	source;		/* source-type mask */
 	u_int16_t	dest;		/* dest-type mask */
diff --git a/include/linux/netfilter_ipv4/ipt_ah.h b/include/linux/netfilter_ipv4/ipt_ah.h
index 7b9a2ac..5734201 100644
--- a/include/linux/netfilter_ipv4/ipt_ah.h
+++ b/include/linux/netfilter_ipv4/ipt_ah.h
@@ -1,6 +1,13 @@
 #ifndef _IPT_AH_H
 #define _IPT_AH_H
 
+enum {
+	IPT_AH_ERR_NONE,
+	IPT_AH_ERR_PROTO,
+	IPT_AH_ERR_FLAGS,
+	IPT_AH_ERR_MAX,
+};
+
 struct ipt_ah
 {
 	u_int32_t spis[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
index 1f0d9a4..57200c1 100644
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -18,6 +18,14 @@
 
 #define IPT_ECN_OP_MATCH_MASK	0xce
 
+enum {
+	IPT_ECN_ERR_NONE,
+	IPT_ECN_ERR_OPERATION,
+	IPT_ECN_ERR_INVERT,
+	IPT_ECN_ERR_NOT_TCP,
+	IPT_ECN_ERR_MAX,
+};
+
 /* match info */
 struct ipt_ecn_info {
 	u_int8_t operation;


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
