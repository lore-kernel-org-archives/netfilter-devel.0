Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD86FC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiKLAVO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKLAVN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABFDE0DB
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SoWZ+iys3HmZC4T07nIqVVKgld3NgpRELIxAYQUwSd8=; b=Rv5TjkhhG3VMSm7RVWKWvqUkhU
        2k86BEMTh2CoxSGBwBX0Sh99jjrrAxaEW18iotLIjWvGooQ9KabFw5IbL5M+cIoqI3woEFrwlH5Nd
        mJ6mxEorUoOAQh5tjq7RK9sQYvG7tGvooJ54U1+92Cgt/0np9Fi/tMCYSzW0UiilYHUKtUpp4iWMh
        qH07NxFCbP6v9ZvowtnNTdKjrW+kquxPZjzrIdH5gSs7Wd9c2s5+h8PX1+o6jKMca2WCDtU7gfyo/
        o+y0+wutyEJ0zOdS1WiWlplMZEbqo7VKuNYQq1tme44XmBM0SyRWs81BmvGrC4of0CP4KCkW5qCpA
        d2cBpvMg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteGk-00022N-IN
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/7] extensions: libip*t_LOG: Merge extensions
Date:   Sat, 12 Nov 2022 01:20:52 +0100
Message-Id: <20221112002056.31917-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Data structures were identical already, make use of the names in
xt_LOG.h and merge all code into a single extension of family
NFPROTO_UNSPEC.

While being at it, define SYSLOG_NAMES and use the array in syslog.h
instead of dragging along an own level->name mapping two times.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_LOG.c                   | 250 ----------------------
 extensions/{libip6t_LOG.c => libxt_LOG.c} | 158 +++++---------
 2 files changed, 58 insertions(+), 350 deletions(-)
 delete mode 100644 extensions/libipt_LOG.c
 rename extensions/{libip6t_LOG.c => libxt_LOG.c} (52%)

diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
deleted file mode 100644
index 36e2e73b7e360..0000000000000
--- a/extensions/libipt_LOG.c
+++ /dev/null
@@ -1,250 +0,0 @@
-#include <stdio.h>
-#include <string.h>
-#include <syslog.h>
-#include <xtables.h>
-#include <linux/netfilter_ipv4/ipt_LOG.h>
-
-#define LOG_DEFAULT_LEVEL LOG_WARNING
-
-#ifndef IPT_LOG_UID /* Old kernel */
-#define IPT_LOG_UID	0x08	/* Log UID owning local socket */
-#undef  IPT_LOG_MASK
-#define IPT_LOG_MASK	0x0f
-#endif
-
-enum {
-	O_LOG_LEVEL = 0,
-	O_LOG_PREFIX,
-	O_LOG_TCPSEQ,
-	O_LOG_TCPOPTS,
-	O_LOG_IPOPTS,
-	O_LOG_UID,
-	O_LOG_MAC,
-};
-
-static void LOG_help(void)
-{
-	printf(
-"LOG target options:\n"
-" --log-level level		Level of logging (numeric or see syslog.conf)\n"
-" --log-prefix prefix		Prefix log messages with this prefix.\n\n"
-" --log-tcp-sequence		Log TCP sequence numbers.\n\n"
-" --log-tcp-options		Log TCP options.\n\n"
-" --log-ip-options		Log IP options.\n\n"
-" --log-uid			Log UID owning the local socket.\n\n"
-" --log-macdecode		Decode MAC addresses and protocol.\n\n");
-}
-
-#define s struct ipt_log_info
-static const struct xt_option_entry LOG_opts[] = {
-	{.name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, level)},
-	{.name = "log-prefix", .id = O_LOG_PREFIX, .type = XTTYPE_STRING,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, prefix), .min = 1},
-	{.name = "log-tcp-sequence", .id = O_LOG_TCPSEQ, .type = XTTYPE_NONE},
-	{.name = "log-tcp-options", .id = O_LOG_TCPOPTS, .type = XTTYPE_NONE},
-	{.name = "log-ip-options", .id = O_LOG_IPOPTS, .type = XTTYPE_NONE},
-	{.name = "log-uid", .id = O_LOG_UID, .type = XTTYPE_NONE},
-	{.name = "log-macdecode", .id = O_LOG_MAC, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-#undef s
-
-static void LOG_init(struct xt_entry_target *t)
-{
-	struct ipt_log_info *loginfo = (struct ipt_log_info *)t->data;
-
-	loginfo->level = LOG_DEFAULT_LEVEL;
-
-}
-
-struct ipt_log_names {
-	const char *name;
-	unsigned int level;
-};
-
-struct ipt_log_xlate {
-	const char *name;
-	unsigned int level;
-};
-
-static const struct ipt_log_names ipt_log_names[]
-= { { .name = "alert",   .level = LOG_ALERT },
-    { .name = "crit",    .level = LOG_CRIT },
-    { .name = "debug",   .level = LOG_DEBUG },
-    { .name = "emerg",   .level = LOG_EMERG },
-    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
-    { .name = "info",    .level = LOG_INFO },
-    { .name = "notice",  .level = LOG_NOTICE },
-    { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
-    { .name = "warning", .level = LOG_WARNING }
-};
-
-static void LOG_parse(struct xt_option_call *cb)
-{
-	struct ipt_log_info *info = cb->data;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_LOG_PREFIX:
-		if (strchr(cb->arg, '\n') != NULL)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Newlines not allowed in --log-prefix");
-		break;
-	case O_LOG_TCPSEQ:
-		info->logflags |= IPT_LOG_TCPSEQ;
-		break;
-	case O_LOG_TCPOPTS:
-		info->logflags |= IPT_LOG_TCPOPT;
-		break;
-	case O_LOG_IPOPTS:
-		info->logflags |= IPT_LOG_IPOPT;
-		break;
-	case O_LOG_UID:
-		info->logflags |= IPT_LOG_UID;
-		break;
-	case O_LOG_MAC:
-		info->logflags |= IPT_LOG_MACDECODE;
-		break;
-	}
-}
-
-static void LOG_print(const void *ip, const struct xt_entry_target *target,
-                      int numeric)
-{
-	const struct ipt_log_info *loginfo
-		= (const struct ipt_log_info *)target->data;
-	unsigned int i = 0;
-
-	printf(" LOG");
-	if (numeric)
-		printf(" flags %u level %u",
-		       loginfo->logflags, loginfo->level);
-	else {
-		for (i = 0; i < ARRAY_SIZE(ipt_log_names); ++i)
-			if (loginfo->level == ipt_log_names[i].level) {
-				printf(" level %s", ipt_log_names[i].name);
-				break;
-			}
-		if (i == ARRAY_SIZE(ipt_log_names))
-			printf(" UNKNOWN level %u", loginfo->level);
-		if (loginfo->logflags & IPT_LOG_TCPSEQ)
-			printf(" tcp-sequence");
-		if (loginfo->logflags & IPT_LOG_TCPOPT)
-			printf(" tcp-options");
-		if (loginfo->logflags & IPT_LOG_IPOPT)
-			printf(" ip-options");
-		if (loginfo->logflags & IPT_LOG_UID)
-			printf(" uid");
-		if (loginfo->logflags & IPT_LOG_MACDECODE)
-			printf(" macdecode");
-		if (loginfo->logflags & ~(IPT_LOG_MASK))
-			printf(" unknown-flags");
-	}
-
-	if (strcmp(loginfo->prefix, "") != 0)
-		printf(" prefix \"%s\"", loginfo->prefix);
-}
-
-static void LOG_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct ipt_log_info *loginfo
-		= (const struct ipt_log_info *)target->data;
-
-	if (strcmp(loginfo->prefix, "") != 0) {
-		printf(" --log-prefix");
-		xtables_save_string(loginfo->prefix);
-	}
-
-	if (loginfo->level != LOG_DEFAULT_LEVEL)
-		printf(" --log-level %d", loginfo->level);
-
-	if (loginfo->logflags & IPT_LOG_TCPSEQ)
-		printf(" --log-tcp-sequence");
-	if (loginfo->logflags & IPT_LOG_TCPOPT)
-		printf(" --log-tcp-options");
-	if (loginfo->logflags & IPT_LOG_IPOPT)
-		printf(" --log-ip-options");
-	if (loginfo->logflags & IPT_LOG_UID)
-		printf(" --log-uid");
-	if (loginfo->logflags & IPT_LOG_MACDECODE)
-		printf(" --log-macdecode");
-}
-
-static const struct ipt_log_xlate ipt_log_xlate_names[] = {
-	{"alert",	LOG_ALERT },
-	{"crit",	LOG_CRIT },
-	{"debug",	LOG_DEBUG },
-	{"emerg",	LOG_EMERG },
-	{"err",		LOG_ERR },
-	{"info",	LOG_INFO },
-	{"notice",	LOG_NOTICE },
-	{"warn",	LOG_WARNING }
-};
-
-static int LOG_xlate(struct xt_xlate *xl,
-		     const struct xt_xlate_tg_params *params)
-{
-	const struct ipt_log_info *loginfo =
-		(const struct ipt_log_info *)params->target->data;
-	unsigned int i = 0;
-
-	xt_xlate_add(xl, "log");
-	if (strcmp(loginfo->prefix, "") != 0) {
-		if (params->escape_quotes)
-			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
-		else
-			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(ipt_log_xlate_names); ++i)
-		if (loginfo->level != LOG_DEFAULT_LEVEL &&
-		    loginfo->level == ipt_log_xlate_names[i].level) {
-			xt_xlate_add(xl, " level %s",
-				   ipt_log_xlate_names[i].name);
-			break;
-		}
-
-	if ((loginfo->logflags & IPT_LOG_MASK) == IPT_LOG_MASK) {
-		xt_xlate_add(xl, " flags all");
-	} else {
-		if (loginfo->logflags & (IPT_LOG_TCPSEQ | IPT_LOG_TCPOPT)) {
-			const char *delim = " ";
-
-			xt_xlate_add(xl, " flags tcp");
-			if (loginfo->logflags & IPT_LOG_TCPSEQ) {
-				xt_xlate_add(xl, " sequence");
-				delim = ",";
-			}
-			if (loginfo->logflags & IPT_LOG_TCPOPT)
-				xt_xlate_add(xl, "%soptions", delim);
-		}
-		if (loginfo->logflags & IPT_LOG_IPOPT)
-			xt_xlate_add(xl, " flags ip options");
-		if (loginfo->logflags & IPT_LOG_UID)
-			xt_xlate_add(xl, " flags skuid");
-		if (loginfo->logflags & IPT_LOG_MACDECODE)
-			xt_xlate_add(xl, " flags ether");
-	}
-
-	return 1;
-}
-static struct xtables_target log_tg_reg = {
-	.name          = "LOG",
-	.version       = XTABLES_VERSION,
-	.family        = NFPROTO_IPV4,
-	.size          = XT_ALIGN(sizeof(struct ipt_log_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ipt_log_info)),
-	.help          = LOG_help,
-	.init          = LOG_init,
-	.print         = LOG_print,
-	.save          = LOG_save,
-	.x6_parse      = LOG_parse,
-	.x6_options    = LOG_opts,
-	.xlate	       = LOG_xlate,
-};
-
-void _init(void)
-{
-	xtables_register_target(&log_tg_reg);
-}
diff --git a/extensions/libip6t_LOG.c b/extensions/libxt_LOG.c
similarity index 52%
rename from extensions/libip6t_LOG.c
rename to extensions/libxt_LOG.c
index 40adc69d85ed4..e3f4290ba003f 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libxt_LOG.c
@@ -1,25 +1,22 @@
 #include <stdio.h>
 #include <string.h>
+#define SYSLOG_NAMES
 #include <syslog.h>
 #include <xtables.h>
-#include <linux/netfilter_ipv6/ip6t_LOG.h>
-
-#ifndef IP6T_LOG_UID	/* Old kernel */
-#define IP6T_LOG_UID	0x08
-#undef  IP6T_LOG_MASK
-#define IP6T_LOG_MASK	0x0f
-#endif
+#include <linux/netfilter/xt_LOG.h>
 
 #define LOG_DEFAULT_LEVEL LOG_WARNING
 
 enum {
-	O_LOG_LEVEL = 0,
-	O_LOG_PREFIX,
-	O_LOG_TCPSEQ,
+	/* make sure the values correspond with XT_LOG_* bit positions */
+	O_LOG_TCPSEQ = 0,
 	O_LOG_TCPOPTS,
 	O_LOG_IPOPTS,
 	O_LOG_UID,
+	__O_LOG_NFLOG,
 	O_LOG_MAC,
+	O_LOG_LEVEL,
+	O_LOG_PREFIX,
 };
 
 static void LOG_help(void)
@@ -35,7 +32,7 @@ static void LOG_help(void)
 " --log-macdecode		Decode MAC addresses and protocol.\n");
 }
 
-#define s struct ip6t_log_info
+#define s struct xt_log_info
 static const struct xt_option_entry LOG_opts[] = {
 	{.name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, level)},
@@ -52,37 +49,14 @@ static const struct xt_option_entry LOG_opts[] = {
 
 static void LOG_init(struct xt_entry_target *t)
 {
-	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)t->data;
+	struct xt_log_info *loginfo = (void *)t->data;
 
 	loginfo->level = LOG_DEFAULT_LEVEL;
-
 }
 
-struct ip6t_log_names {
-	const char *name;
-	unsigned int level;
-};
-
-struct ip6t_log_xlate {
-	const char *name;
-	unsigned int level;
-};
-
-static const struct ip6t_log_names ip6t_log_names[]
-= { { .name = "alert",   .level = LOG_ALERT },
-    { .name = "crit",    .level = LOG_CRIT },
-    { .name = "debug",   .level = LOG_DEBUG },
-    { .name = "emerg",   .level = LOG_EMERG },
-    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
-    { .name = "info",    .level = LOG_INFO },
-    { .name = "notice",  .level = LOG_NOTICE },
-    { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
-    { .name = "warning", .level = LOG_WARNING }
-};
-
 static void LOG_parse(struct xt_option_call *cb)
 {
-	struct ip6t_log_info *info = cb->data;
+	struct xt_log_info *info = cb->data;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
@@ -92,53 +66,53 @@ static void LOG_parse(struct xt_option_call *cb)
 				   "Newlines not allowed in --log-prefix");
 		break;
 	case O_LOG_TCPSEQ:
-		info->logflags |= IP6T_LOG_TCPSEQ;
-		break;
 	case O_LOG_TCPOPTS:
-		info->logflags |= IP6T_LOG_TCPOPT;
-		break;
 	case O_LOG_IPOPTS:
-		info->logflags |= IP6T_LOG_IPOPT;
-		break;
 	case O_LOG_UID:
-		info->logflags |= IP6T_LOG_UID;
-		break;
 	case O_LOG_MAC:
-		info->logflags |= IP6T_LOG_MACDECODE;
+		info->logflags |= 1 << cb->entry->id;
 		break;
 	}
 }
 
+static const char *priority2name(unsigned char level)
+{
+	int i;
+
+	for (i = 0; prioritynames[i].c_name; ++i) {
+		if (level == prioritynames[i].c_val)
+			return prioritynames[i].c_name;
+	}
+	return NULL;
+}
+
 static void LOG_print(const void *ip, const struct xt_entry_target *target,
                       int numeric)
 {
-	const struct ip6t_log_info *loginfo
-		= (const struct ip6t_log_info *)target->data;
-	unsigned int i = 0;
+	const struct xt_log_info *loginfo = (const void *)target->data;
 
 	printf(" LOG");
 	if (numeric)
 		printf(" flags %u level %u",
 		       loginfo->logflags, loginfo->level);
 	else {
-		for (i = 0; i < ARRAY_SIZE(ip6t_log_names); ++i)
-			if (loginfo->level == ip6t_log_names[i].level) {
-				printf(" level %s", ip6t_log_names[i].name);
-				break;
-			}
-		if (i == ARRAY_SIZE(ip6t_log_names))
+		const char *pname = priority2name(loginfo->level);
+
+		if (pname)
+			printf(" level %s", pname);
+		else
 			printf(" UNKNOWN level %u", loginfo->level);
-		if (loginfo->logflags & IP6T_LOG_TCPSEQ)
+		if (loginfo->logflags & XT_LOG_TCPSEQ)
 			printf(" tcp-sequence");
-		if (loginfo->logflags & IP6T_LOG_TCPOPT)
+		if (loginfo->logflags & XT_LOG_TCPOPT)
 			printf(" tcp-options");
-		if (loginfo->logflags & IP6T_LOG_IPOPT)
+		if (loginfo->logflags & XT_LOG_IPOPT)
 			printf(" ip-options");
-		if (loginfo->logflags & IP6T_LOG_UID)
+		if (loginfo->logflags & XT_LOG_UID)
 			printf(" uid");
-		if (loginfo->logflags & IP6T_LOG_MACDECODE)
+		if (loginfo->logflags & XT_LOG_MACDECODE)
 			printf(" macdecode");
-		if (loginfo->logflags & ~(IP6T_LOG_MASK))
+		if (loginfo->logflags & ~(XT_LOG_MASK))
 			printf(" unknown-flags");
 	}
 
@@ -148,8 +122,7 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
 
 static void LOG_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ip6t_log_info *loginfo
-		= (const struct ip6t_log_info *)target->data;
+	const struct xt_log_info *loginfo = (const void *)target->data;
 
 	if (strcmp(loginfo->prefix, "") != 0) {
 		printf(" --log-prefix");
@@ -159,35 +132,23 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
 		printf(" --log-level %d", loginfo->level);
 
-	if (loginfo->logflags & IP6T_LOG_TCPSEQ)
+	if (loginfo->logflags & XT_LOG_TCPSEQ)
 		printf(" --log-tcp-sequence");
-	if (loginfo->logflags & IP6T_LOG_TCPOPT)
+	if (loginfo->logflags & XT_LOG_TCPOPT)
 		printf(" --log-tcp-options");
-	if (loginfo->logflags & IP6T_LOG_IPOPT)
+	if (loginfo->logflags & XT_LOG_IPOPT)
 		printf(" --log-ip-options");
-	if (loginfo->logflags & IP6T_LOG_UID)
+	if (loginfo->logflags & XT_LOG_UID)
 		printf(" --log-uid");
-	if (loginfo->logflags & IP6T_LOG_MACDECODE)
+	if (loginfo->logflags & XT_LOG_MACDECODE)
 		printf(" --log-macdecode");
 }
 
-static const struct ip6t_log_xlate ip6t_log_xlate_names[] = {
-	{"alert",       LOG_ALERT },
-	{"crit",        LOG_CRIT },
-	{"debug",       LOG_DEBUG },
-	{"emerg",       LOG_EMERG },
-	{"err",         LOG_ERR },
-	{"info",        LOG_INFO },
-	{"notice",      LOG_NOTICE },
-	{"warn",        LOG_WARNING }
-};
-
 static int LOG_xlate(struct xt_xlate *xl,
 		     const struct xt_xlate_tg_params *params)
 {
-	const struct ip6t_log_info *loginfo =
-		(const struct ip6t_log_info *)params->target->data;
-	unsigned int i = 0;
+	const struct xt_log_info *loginfo = (const void *)params->target->data;
+	const char *pname = priority2name(loginfo->level);
 
 	xt_xlate_add(xl, "log");
 	if (strcmp(loginfo->prefix, "") != 0) {
@@ -197,44 +158,41 @@ static int LOG_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(ip6t_log_xlate_names); ++i)
-		if (loginfo->level == ip6t_log_xlate_names[i].level &&
-		    loginfo->level != LOG_DEFAULT_LEVEL) {
-			xt_xlate_add(xl, " level %s",
-				   ip6t_log_xlate_names[i].name);
-			break;
-		}
+	if (loginfo->level != LOG_DEFAULT_LEVEL && pname)
+		xt_xlate_add(xl, " level %s", pname);
+	else if (!pname)
+		return 0;
 
-	if ((loginfo->logflags & IP6T_LOG_MASK) == IP6T_LOG_MASK) {
+	if ((loginfo->logflags & XT_LOG_MASK) == XT_LOG_MASK) {
 		xt_xlate_add(xl, " flags all");
 	} else {
-		if (loginfo->logflags & (IP6T_LOG_TCPSEQ | IP6T_LOG_TCPOPT)) {
+		if (loginfo->logflags & (XT_LOG_TCPSEQ | XT_LOG_TCPOPT)) {
 			const char *delim = " ";
 
 			xt_xlate_add(xl, " flags tcp");
-			if (loginfo->logflags & IP6T_LOG_TCPSEQ) {
+			if (loginfo->logflags & XT_LOG_TCPSEQ) {
 				xt_xlate_add(xl, " sequence");
 				delim = ",";
 			}
-			if (loginfo->logflags & IP6T_LOG_TCPOPT)
+			if (loginfo->logflags & XT_LOG_TCPOPT)
 				xt_xlate_add(xl, "%soptions", delim);
 		}
-		if (loginfo->logflags & IP6T_LOG_IPOPT)
+		if (loginfo->logflags & XT_LOG_IPOPT)
 			xt_xlate_add(xl, " flags ip options");
-		if (loginfo->logflags & IP6T_LOG_UID)
+		if (loginfo->logflags & XT_LOG_UID)
 			xt_xlate_add(xl, " flags skuid");
-		if (loginfo->logflags & IP6T_LOG_MACDECODE)
+		if (loginfo->logflags & XT_LOG_MACDECODE)
 			xt_xlate_add(xl, " flags ether");
 	}
 
 	return 1;
 }
-static struct xtables_target log_tg6_reg = {
+static struct xtables_target log_tg_reg = {
 	.name          = "LOG",
 	.version       = XTABLES_VERSION,
-	.family        = NFPROTO_IPV6,
-	.size          = XT_ALIGN(sizeof(struct ip6t_log_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct ip6t_log_info)),
+	.family        = NFPROTO_UNSPEC,
+	.size          = XT_ALIGN(sizeof(struct xt_log_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_log_info)),
 	.help          = LOG_help,
 	.init          = LOG_init,
 	.print         = LOG_print,
@@ -246,5 +204,5 @@ static struct xtables_target log_tg6_reg = {
 
 void _init(void)
 {
-	xtables_register_target(&log_tg6_reg);
+	xtables_register_target(&log_tg_reg);
 }
-- 
2.38.0

