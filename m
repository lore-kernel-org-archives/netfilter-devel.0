From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/4] libip6t_* extensions
Date: Sun, 21 Jun 2009 00:07:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906210006160.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57573 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZFTWHB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:07:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 969698828D
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:07:03 +0200 (CEST)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N4I0p7ubJ6OE for <netfilter-devel@vger.kernel.org>;
	Sun, 21 Jun 2009 00:07:03 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id 7C4168828C
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jun 2009 00:07:03 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The libip6t_* extensions with the error reporting function.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 extensions/libip6t_HL.c                        |   34 ++++++++++++++++++++++++
 extensions/libip6t_LOG.c                       |   25 ++++++++++++++++++
 extensions/libip6t_REJECT.c                    |   31 ++++++++++++++++++++++
 extensions/libip6t_ah.c                        |   21 +++++++++++++++
 extensions/libip6t_dst.c                       |   22 ++++++++++++++++
 extensions/libip6t_eui64.c                     |   18 +++++++++++++
 extensions/libip6t_frag.c                      |   21 +++++++++++++++
 extensions/libip6t_hbh.c                       |   26 ++++++++++++++++++
 extensions/libip6t_icmp6.c                     |   22 ++++++++++++++++
 extensions/libip6t_ipv6header.c                |   16 +++++++++++
 extensions/libip6t_mh.c                        |   26 ++++++++++++++++++
 extensions/libip6t_rt.c                        |   26 ++++++++++++++++++
 include/linux/netfilter_ipv6/ip6t_HL.h         |    8 ++++++
 include/linux/netfilter_ipv6/ip6t_LOG.h        |    7 +++++
 include/linux/netfilter_ipv6/ip6t_REJECT.h     |    9 ++++++
 include/linux/netfilter_ipv6/ip6t_ah.h         |    6 ++++
 include/linux/netfilter_ipv6/ip6t_eui64.h      |   10 +++++++
 include/linux/netfilter_ipv6/ip6t_frag.h       |    6 ++++
 include/linux/netfilter_ipv6/ip6t_ipv6header.h |    6 ++++
 include/linux/netfilter_ipv6/ip6t_mh.h         |    7 +++++
 include/linux/netfilter_ipv6/ip6t_opts.h       |    7 +++++
 include/linux/netfilter_ipv6/ip6t_rt.h         |    7 +++++
 22 files changed, 361 insertions(+), 0 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 12d8e72..6382df3 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -89,6 +89,39 @@ static void HL_check(unsigned int flags)
 				"HL: You must specify an action");
 }
 
+static void
+HL_error(u_int8_t errcode, u_int8_t family,
+	 const struct xt_entry_target *target)
+{
+	const struct ip6t_HL_info *info = 
+		(struct ip6t_HL_info *) target->data;
+
+	switch (errcode) {
+	case XT_HL_ERR_MANGLE_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"HL target can only be used in the "
+			"\"mangle\" table.");
+		break;
+	case XT_HL_ERR_MODE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Mode `%s' is unknown for the kernel.",
+			info->mode == IP6T_HL_SET ? "--hl-set" :
+			info->mode == IP6T_HL_INC ? "--hl-inc" :
+			info->mode == IP6T_HL_DEC ? "--hl-dec" :
+			"fixme");
+		break;
+	case XT_HL_ERR_SET:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"HL value cannot be %s by zero.",
+			info->mode == IP6T_HL_INC ? "incremented" :
+			"decremented");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void HL_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ip6t_HL_info *info = 
@@ -146,6 +179,7 @@ static struct xtables_target hl_tg6_reg = {
 	.help		= HL_help,
 	.parse		= HL_parse,
 	.final_check	= HL_check,
+	.kernel_error	= HL_error,
 	.print		= HL_print,
 	.save		= HL_save,
 	.extra_opts	= HL_opts,
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index f713201..ad8cb61 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -186,6 +186,30 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+LOG_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_target *target)
+{
+	const struct ip6t_log_info *info = 
+		(struct ip6t_log_info *)target->data;
+
+	switch (errcode) {
+	case IP6T_LOG_ERR_LEVEL:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Log level %u is >= 8.", info->level);
+		break;
+	case IP6T_LOG_ERR_PREFIXLEN:
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
@@ -251,6 +275,7 @@ static struct xtables_target log_tg6_reg = {
     .help          = LOG_help,
     .init          = LOG_init,
     .parse         = LOG_parse,
+    .kernel_error  = LOG_error,
     .print         = LOG_print,
     .save          = LOG_save,
     .extra_opts    = LOG_opts,
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 9ad3b68..8d93c5f 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -100,6 +100,36 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+REJECT_error(u_int8_t errcode, u_int8_t family,
+	     const struct xt_entry_target *target)
+{
+	switch (errcode) {
+	case IP6T_REJECT_ERR_FILTER_TABLE:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"\"filter\" table.");
+		break;
+	case IP6T_REJECT_ERR_HOOKS_123:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Target can only be used in the "
+			"INPUT, FORWARD and OUTPUT chains.");
+		break;
+	case IP6T_REJECT_ERR_ECHOREPLY:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Reject with echo-reply is not supported.");
+		break;
+	case IP6T_REJECT_ERR_NOT_TCP:
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
@@ -135,6 +165,7 @@ static struct xtables_target reject_tg6_reg = {
 	.help		= REJECT_help,
 	.init		= REJECT_init,
 	.parse		= REJECT_parse,
+	.kernel_error	= REJECT_error,
 	.print		= REJECT_print,
 	.save		= REJECT_save,
 	.extra_opts	= REJECT_opts,
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 19b7ad4..a05d5bc 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -117,6 +117,26 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+ah_error(u_int8_t errcode, u_int8_t family,
+	 const struct xt_entry_match *match)
+{
+	const struct ip6t_ah *info = (struct ip6t_ah *)match->data;
+
+	switch (errcode) {
+	case IP6T_AH_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Negation of `%s' is not recognized by the kernel.",
+			info->invflags & IP6T_AH_INV_SPI ? "--ahspi" :
+			info->invflags & IP6T_AH_INV_LEN ? "--ahlen" :
+			"fixme");
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
@@ -195,6 +215,7 @@ static struct xtables_match ah_mt6_reg = {
 	.help          = ah_help,
 	.init          = ah_init,
 	.parse         = ah_parse,
+	.kernel_error  = ah_error,
 	.print         = ah_print,
 	.save          = ah_save,
 	.extra_opts    = ah_opts,
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index a47e3a3..7354861 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -163,6 +163,27 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+dst_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct ip6t_opts *info = (struct ip6t_opts *)match->data;
+
+	switch (errcode) {
+	case IP6T_OPTS_ERR_FLAGS:
+		if (info->invflags & IP6T_OPTS_INV_LEN)
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Mode ! --dst-len is unknown for the kernel.");
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
 print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
@@ -229,6 +250,7 @@ static struct xtables_match dst_mt6_reg = {
 	.help          = dst_help,
 	.init          = dst_init,
 	.parse         = dst_parse,
+	.kernel_error  = dst_error,
 	.print         = dst_print,
 	.save          = dst_save,
 	.extra_opts    = dst_opts,
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index c92c868..f337cdd 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -10,6 +10,7 @@
 #include <linux/if_ether.h>
 #endif
 #include <xtables.h>
+#include <linux/netfilter_ipv6/ip6t_eui64.h>
 
 static void eui64_help(void)
 {
@@ -25,6 +26,22 @@ static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static void
+eui64_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case IP6T_EUI64_ERR_HOOKS_012:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Match can only be used in the "
+			"PREROUTING, INPUT and FORWARD chains.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static struct xtables_match eui64_mt6_reg = {
 	.name 		= "eui64",
 	.version	= XTABLES_VERSION,
@@ -33,6 +50,7 @@ static struct xtables_match eui64_mt6_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= eui64_help,
 	.parse		= eui64_parse,
+	.kernel_error	= eui64_error,
 };
 
 void _init(void)
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 905b494..954da88 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -148,6 +148,26 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+frag_error(u_int8_t errcode, u_int8_t family,
+	   const struct xt_entry_match *match)
+{ 
+	const struct ip6t_frag *info = (struct ip6t_frag *)match->data;
+
+	switch (errcode) {
+	case IP6T_FRAG_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Negation of `%s' is not recognized by the kernel.",
+			info->invflags & IP6T_FRAG_INV_IDS ? "--fragid" :
+			info->invflags & IP6T_FRAG_INV_LEN ? "--fraglen" :
+			"fixme");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_ids(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
 {
@@ -240,6 +260,7 @@ static struct xtables_match frag_mt6_reg = {
 	.help          = frag_help,
 	.init          = frag_init,
 	.parse         = frag_parse,
+	.kernel_error  = frag_error,
 	.print         = frag_print,
 	.save          = frag_save,
 	.extra_opts    = frag_opts,
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e08d84a..9028d2e 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -157,6 +157,31 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+hbh_error(u_int8_t errcode, u_int8_t family,
+	  const struct xt_entry_match *match)
+{
+	const struct ip6t_opts *info = (struct ip6t_opts *)match->data;
+
+	switch (errcode) {
+	case IP6T_OPTS_ERR_FLAGS:
+		if (info->invflags & IP6T_OPTS_INV_LEN)
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Mode ! --hbh-len is unknown for the kernel.");
+		else
+			xtables_error_tail(PARAMETER_PROBLEM,
+				"Unknown invflags value `%u'.", info->invflags);
+		break;
+	case IP6T_OPTS_ERR_STRICT:
+		xtables_error_tail(PARAMETER_PROBLEM,
+				"Strict mode is not implemented.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
@@ -216,6 +241,7 @@ static struct xtables_match hbh_mt6_reg = {
 	.help		= hbh_help,
 	.init		= hbh_init,
 	.parse		= hbh_parse,
+	.kernel_error	= hbh_error,
 	.print		= hbh_print,
 	.save		= hbh_save,
 	.extra_opts	= hbh_opts,
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e41a670..e77c0d7 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -173,6 +173,27 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+icmp6_error(u_int8_t errcode, u_int8_t family,
+	    const struct xt_entry_match *match)
+{
+	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
+
+	switch (errcode) {
+	case IP6T_ICMPV6_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"icmpv6 match is only valid for protocol ICMPV6.");
+		break;
+	case IP6T_ICMPV6_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Unknown invflags value `%u'.", info->invflags);
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
 static void print_icmpv6type(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
 			   int invert,
@@ -252,6 +273,7 @@ static struct xtables_match icmp6_mt6_reg = {
 	.init		= icmp6_init,
 	.parse		= icmp6_parse,
 	.final_check	= icmp6_check,
+	.kernel_error	= icmp6_error,
 	.print		= icmp6_print,
 	.save		= icmp6_save,
 	.extra_opts	= icmp6_opts,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 2674c8f..b41cbbd 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -216,6 +216,21 @@ static void ipv6header_check(unsigned int flags)
 }
 
 static void
+ipv6header_error(u_int8_t errcode, u_int8_t family,
+		 const struct xt_entry_match *match)
+{
+	switch (errcode) {
+	case IP6T_IPV6HEADER_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Invalid --header flags in hard mode.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_header(u_int8_t flags){
         int have_flag = 0;
 
@@ -279,6 +294,7 @@ static struct xtables_match ipv6header_mt6_reg = {
 	.init		= ipv6header_init,
 	.parse		= ipv6header_parse,
 	.final_check	= ipv6header_check,
+	.kernel_error	= ipv6header_error,
 	.print		= ipv6header_print,
 	.save		= ipv6header_save,
 	.extra_opts	= ipv6header_opts,
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 47d5544..944b864 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -147,6 +147,31 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static void
+mh_error(u_int8_t errcode, u_int8_t family,
+	 const struct xt_entry_match *match)
+{
+	const struct ip6t_mh *info = (struct ip6t_mh *)match->data;
+
+	switch (errcode) {
+	case IP6T_MH_ERR_PROTO:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"mh match is only valid for protocol ipv6-mh.");
+		break;
+	case IP6T_MH_ERR_FLAGS:
+		if (info->invflags & IP6T_MH_INV_TYPE)
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
 static const char *type_to_name(u_int8_t type)
 {
 	unsigned int i;
@@ -229,6 +254,7 @@ static struct xtables_match mh_mt6_reg = {
 	.help		= mh_help,
 	.init		= mh_init,
 	.parse		= mh_parse,
+	.kernel_error	= mh_error,
 	.print		= mh_print,
 	.save		= mh_save,
 	.extra_opts	= mh_opts,
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index c9bf994..5744eaa 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -230,6 +230,31 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
+rt_error(u_int8_t errcode, u_int8_t family,
+	 const struct xt_entry_match *match)
+{
+	const struct ip6t_rt *info = (struct ip6t_rt *)match->data;
+
+	switch (errcode) {
+	case IP6T_RT_ERR_FLAGS:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Negation of `%s' is not recognized by the kernel.",
+			info->invflags & IP6T_RT_INV_TYP ? "--rt-type" :
+			info->invflags & IP6T_RT_INV_SGS ? "--rt-seqsleft" :
+			info->invflags & IP6T_RT_INV_LEN ? "--rt-len" :
+			"fixme");
+		break;
+	case IP6T_RT_ERR_RT0:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"`--rt-type 0' required before using`--rt-0-*'.");
+		break;
+	default:
+		xtables_error_tail(PARAMETER_PROBLEM,
+			"Internal error, unknown errcode: %u.", errcode);
+	}
+}
+
+static void
 print_nums(const char *name, u_int32_t min, u_int32_t max,
 	    int invert)
 {
@@ -332,6 +357,7 @@ static struct xtables_match rt_mt6_reg = {
 	.help		= rt_help,
 	.init		= rt_init,
 	.parse		= rt_parse,
+	.kernel_error	= rt_error,
 	.print		= rt_print,
 	.save		= rt_save,
 	.extra_opts	= rt_opts,
diff --git a/include/linux/netfilter_ipv6/ip6t_HL.h b/include/linux/netfilter_ipv6/ip6t_HL.h
index afb7813..a529fc2 100644
--- a/include/linux/netfilter_ipv6/ip6t_HL.h
+++ b/include/linux/netfilter_ipv6/ip6t_HL.h
@@ -6,6 +6,14 @@
 #define _IP6T_HL_H
 
 enum {
+	XT_HL_ERR_NONE,
+	XT_HL_ERR_MANGLE_TABLE,
+	XT_HL_ERR_MODE,
+	XT_HL_ERR_SET,
+	XT_HL_ERR_MAX,
+};
+
+enum {
 	IP6T_HL_SET = 0,
 	IP6T_HL_INC,
 	IP6T_HL_DEC
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
index 0d0119b..17f3c4d 100644
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h
@@ -9,6 +9,13 @@
 #define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
 #define IP6T_LOG_MASK		0x1f
 
+enum {
+	IP6T_LOG_ERR_NONE,
+	IP6T_LOG_ERR_LEVEL,
+	IP6T_LOG_ERR_PREFIXLEN,
+	IP6T_LOG_ERR_MAX,
+};
+
 struct ip6t_log_info {
 	unsigned char level;
 	unsigned char logflags;
diff --git a/include/linux/netfilter_ipv6/ip6t_REJECT.h b/include/linux/netfilter_ipv6/ip6t_REJECT.h
index 6be6504..02f8dcd 100644
--- a/include/linux/netfilter_ipv6/ip6t_REJECT.h
+++ b/include/linux/netfilter_ipv6/ip6t_REJECT.h
@@ -11,6 +11,15 @@ enum ip6t_reject_with {
 	IP6T_TCP_RESET
 };
 
+enum {
+	IP6T_REJECT_ERR_NONE,
+	IP6T_REJECT_ERR_FILTER_TABLE,
+	IP6T_REJECT_ERR_HOOKS_123,
+	IP6T_REJECT_ERR_ECHOREPLY,
+	IP6T_REJECT_ERR_NOT_TCP,
+	IP6T_REJECT_ERR_MAX,
+};
+
 struct ip6t_reject_info {
 	u_int32_t	with;	/* reject type */
 };
diff --git a/include/linux/netfilter_ipv6/ip6t_ah.h b/include/linux/netfilter_ipv6/ip6t_ah.h
index 8531879..7c664c6 100644
--- a/include/linux/netfilter_ipv6/ip6t_ah.h
+++ b/include/linux/netfilter_ipv6/ip6t_ah.h
@@ -1,6 +1,12 @@
 #ifndef _IP6T_AH_H
 #define _IP6T_AH_H
 
+enum {
+	IP6T_AH_ERR_NONE,
+	IP6T_AH_ERR_FLAGS,
+	IP6T_AH_ERR_MAX,
+};
+
 struct ip6t_ah
 {
 	u_int32_t spis[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv6/ip6t_eui64.h b/include/linux/netfilter_ipv6/ip6t_eui64.h
new file mode 100644
index 0000000..b9fe28b
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6t_eui64.h
@@ -0,0 +1,10 @@
+#ifndef _IP6T_EUI64_H
+#define _IP6T_EUI64_H
+
+enum {
+	IP6T_EUI64_ERR_NONE,
+	IP6T_EUI64_ERR_HOOKS_012,
+	IP6T_EUI64_ERR_MAX,
+};
+
+#endif /*_IP6T_EUI64_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_frag.h b/include/linux/netfilter_ipv6/ip6t_frag.h
index 66070a0..22be05c 100644
--- a/include/linux/netfilter_ipv6/ip6t_frag.h
+++ b/include/linux/netfilter_ipv6/ip6t_frag.h
@@ -1,6 +1,12 @@
 #ifndef _IP6T_FRAG_H
 #define _IP6T_FRAG_H
 
+enum {
+	IP6T_FRAG_ERR_NONE,
+	IP6T_FRAG_ERR_FLAGS,
+	IP6T_FRAG_ERR_MAX,
+};
+
 struct ip6t_frag
 {
 	u_int32_t ids[2];			/* Security Parameter Index */
diff --git a/include/linux/netfilter_ipv6/ip6t_ipv6header.h b/include/linux/netfilter_ipv6/ip6t_ipv6header.h
index 51c53fc..d516f67 100644
--- a/include/linux/netfilter_ipv6/ip6t_ipv6header.h
+++ b/include/linux/netfilter_ipv6/ip6t_ipv6header.h
@@ -8,6 +8,12 @@ on whether they contain certain headers */
 #ifndef __IPV6HEADER_H
 #define __IPV6HEADER_H
 
+enum {
+	IP6T_IPV6HEADER_ERR_NONE,
+	IP6T_IPV6HEADER_ERR_FLAGS,
+	IP6T_IPV6HEADER_ERR_MAX,
+};
+
 struct ip6t_ipv6header_info
 {
 	u_int8_t matchflags;
diff --git a/include/linux/netfilter_ipv6/ip6t_mh.h b/include/linux/netfilter_ipv6/ip6t_mh.h
index b9ca9a5..0da311c 100644
--- a/include/linux/netfilter_ipv6/ip6t_mh.h
+++ b/include/linux/netfilter_ipv6/ip6t_mh.h
@@ -1,6 +1,13 @@
 #ifndef _IP6T_MH_H
 #define _IP6T_MH_H
 
+enum {
+	IP6T_MH_ERR_NONE,
+	IP6T_MH_ERR_PROTO,
+	IP6T_MH_ERR_FLAGS,
+	IP6T_MH_ERR_MAX,
+};
+
 /* MH matching stuff */
 struct ip6t_mh
 {
diff --git a/include/linux/netfilter_ipv6/ip6t_opts.h b/include/linux/netfilter_ipv6/ip6t_opts.h
index a07e363..21a4f60 100644
--- a/include/linux/netfilter_ipv6/ip6t_opts.h
+++ b/include/linux/netfilter_ipv6/ip6t_opts.h
@@ -3,6 +3,13 @@
 
 #define IP6T_OPTS_OPTSNR 16
 
+enum {
+	IP6T_OPTS_ERR_NONE,
+	IP6T_OPTS_ERR_FLAGS,
+	IP6T_OPTS_ERR_STRICT,
+	IP6T_OPTS_ERR_MAX,
+};
+
 struct ip6t_opts
 {
 	u_int32_t hdrlen;			/* Header Length */
diff --git a/include/linux/netfilter_ipv6/ip6t_rt.h b/include/linux/netfilter_ipv6/ip6t_rt.h
index 5215602..ccd6185 100644
--- a/include/linux/netfilter_ipv6/ip6t_rt.h
+++ b/include/linux/netfilter_ipv6/ip6t_rt.h
@@ -5,6 +5,13 @@
 
 #define IP6T_RT_HOPS 16
 
+enum {
+	IP6T_RT_ERR_NONE,
+	IP6T_RT_ERR_FLAGS,
+	IP6T_RT_ERR_RT0,
+	IP6T_RT_ERR_MAX,
+};
+
 struct ip6t_rt
 {
 	u_int32_t rt_type;			/* Routing Type */


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
