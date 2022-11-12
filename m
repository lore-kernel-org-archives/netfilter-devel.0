Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B69C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiKLAVa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiKLAVa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:30 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD940DF22
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K7QdtqClHNlObySf62UrWlrwOGX+MWZ6W/MeN7epoBQ=; b=Fs0P8dSeh9gBpMcK3j/3KDt6Ui
        dA8MP7V5ppeqLzImVKVP1uVExGGIMwOtUQZ1ww6JPkqITcJUqtOWEXe5IVq8Uk/7SxZyHQ5mzJarQ
        7UQBMT1er7mGFlrnS1Us720QMQRZfP2X2hafYkTMmANq8c8s7v7Hcle8kntJDD+qPkO8F/FBWxbKi
        4ADlCsURUhXCaNDdMoCKLhGUuaie5BKkAFx2L4OX7944572Dx8vx/VGjhE90dUYr2p1WwpZLl2DmP
        rmyV1ftKsoR4rCEAtOJ3Rfjmr4FMRAs1nyg7vyvksQiEc3Sau/CH5VAJ/eqDGBTKoUoU3KBgLcJF5
        naW6/Z/w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteH1-00023A-6N
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 7/7] extensions: Unify ICMP parser into libxt_icmp.h
Date:   Sat, 12 Nov 2022 01:20:56 +0100
Message-Id: <20221112002056.31917-8-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221112002056.31917-1-phil@nwl.cc>
References: <20221112002056.31917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge all four copies of the ICMP/ICMPv6/IGMP parameter parsing code.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c     |  82 +-----------------------
 extensions/libebt_ip6.c    |  73 +--------------------
 extensions/libip6t_icmp6.c |  55 +---------------
 extensions/libipt_icmp.c   |  55 +---------------
 extensions/libxt_icmp.h    | 126 +++++++++++++++++++++++++++++++++++++
 5 files changed, 131 insertions(+), 260 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 27ae84e9470d8..fd87dae7e2c62 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -102,82 +102,6 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 }
 
 /* original code from ebtables: useful_functions.c */
-static char *parse_range(const char *str, unsigned int res[])
-{
-	char *next;
-
-	if (!xtables_strtoui(str, &next, &res[0], 0, 255))
-		return NULL;
-
-	res[1] = res[0];
-	if (*next == ':') {
-		str = next + 1;
-		if (!xtables_strtoui(str, &next, &res[1], 0, 255))
-			return NULL;
-	}
-
-	return next;
-}
-
-static int ebt_parse_icmp(const struct xt_icmp_names *codes, size_t n_codes,
-			  const char *icmptype, uint8_t type[], uint8_t code[])
-{
-	unsigned int match = n_codes;
-	unsigned int i, number[2];
-
-	for (i = 0; i < n_codes; i++) {
-		if (strncasecmp(codes[i].name, icmptype, strlen(icmptype)))
-			continue;
-		if (match != n_codes)
-			xtables_error(PARAMETER_PROBLEM, "Ambiguous ICMP type `%s':"
-					" `%s' or `%s'?",
-					icmptype, codes[match].name,
-					codes[i].name);
-		match = i;
-	}
-
-	if (match < n_codes) {
-		type[0] = type[1] = codes[match].type;
-		if (code) {
-			code[0] = codes[match].code_min;
-			code[1] = codes[match].code_max;
-		}
-	} else {
-		char *next = parse_range(icmptype, number);
-		if (!next) {
-			xtables_error(PARAMETER_PROBLEM, "Unknown ICMP type `%s'",
-							icmptype);
-			return -1;
-		}
-
-		type[0] = (uint8_t) number[0];
-		type[1] = (uint8_t) number[1];
-		switch (*next) {
-		case 0:
-			if (code) {
-				code[0] = 0;
-				code[1] = 255;
-			}
-			return 0;
-		case '/':
-			if (code) {
-				next = parse_range(next+1, number);
-				code[0] = (uint8_t) number[0];
-				code[1] = (uint8_t) number[1];
-				if (next == NULL)
-					return -1;
-				if (next && *next == 0)
-					return 0;
-			}
-		/* fallthrough */
-		default:
-			xtables_error(PARAMETER_PROBLEM, "unknown character %c", *next);
-			return -1;
-		}
-	}
-	return 0;
-}
-
 static void print_icmp_code(uint8_t *code)
 {
 	if (!code)
@@ -256,15 +180,13 @@ brip_parse(int c, char **argv, int invert, unsigned int *flags,
 	case IP_EBT_ICMP:
 		if (invert)
 			info->invflags |= EBT_IP_ICMP;
-		ebt_parse_icmp(icmp_codes, ARRAY_SIZE(icmp_codes), optarg,
-			      info->icmp_type, info->icmp_code);
+		ebt_parse_icmp(optarg, info->icmp_type, info->icmp_code);
 		info->bitmask |= EBT_IP_ICMP;
 		break;
 	case IP_EBT_IGMP:
 		if (invert)
 			info->invflags |= EBT_IP_IGMP;
-		ebt_parse_icmp(igmp_types, ARRAY_SIZE(igmp_types), optarg,
-			       info->igmp_type, NULL);
+		ebt_parse_igmp(optarg, info->igmp_type);
 		info->bitmask |= EBT_IP_IGMP;
 		break;
 	case IP_EBT_TOS: {
diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index ac20666af5ba3..18bb2720ccbec 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -72,76 +72,6 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 	free(buffer);
 }
 
-static char *parse_range(const char *str, unsigned int res[])
-{
-	char *next;
-
-	if (!xtables_strtoui(str, &next, &res[0], 0, 255))
-		return NULL;
-
-	res[1] = res[0];
-	if (*next == ':') {
-		str = next + 1;
-		if (!xtables_strtoui(str, &next, &res[1], 0, 255))
-			return NULL;
-	}
-
-	return next;
-}
-
-static int
-parse_icmpv6(const char *icmpv6type, uint8_t type[], uint8_t code[])
-{
-	static const unsigned int limit = ARRAY_SIZE(icmpv6_codes);
-	unsigned int match = limit;
-	unsigned int i, number[2];
-
-	for (i = 0; i < limit; i++) {
-		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type)))
-			continue;
-		if (match != limit)
-			xtables_error(PARAMETER_PROBLEM, "Ambiguous ICMPv6 type `%s':"
-					" `%s' or `%s'?",
-					icmpv6type, icmpv6_codes[match].name,
-					icmpv6_codes[i].name);
-		match = i;
-	}
-
-	if (match < limit) {
-		type[0] = type[1] = icmpv6_codes[match].type;
-		code[0] = icmpv6_codes[match].code_min;
-		code[1] = icmpv6_codes[match].code_max;
-	} else {
-		char *next = parse_range(icmpv6type, number);
-		if (!next) {
-			xtables_error(PARAMETER_PROBLEM, "Unknown ICMPv6 type `%s'",
-							icmpv6type);
-			return -1;
-		}
-		type[0] = (uint8_t) number[0];
-		type[1] = (uint8_t) number[1];
-		switch (*next) {
-		case 0:
-			code[0] = 0;
-			code[1] = 255;
-			return 0;
-		case '/':
-			next = parse_range(next+1, number);
-			code[0] = (uint8_t) number[0];
-			code[1] = (uint8_t) number[1];
-			if (next == NULL)
-				return -1;
-			if (next && *next == 0)
-				return 0;
-		/* fallthrough */
-		default:
-			xtables_error(PARAMETER_PROBLEM, "unknown character %c", *next);
-			return -1;
-		}
-	}
-	return 0;
-}
-
 static void print_port_range(uint16_t *ports)
 {
 	if (ports[0] == ports[1])
@@ -266,8 +196,7 @@ brip6_parse(int c, char **argv, int invert, unsigned int *flags,
 	case IP_ICMP6:
 		if (invert)
 			info->invflags |= EBT_IP6_ICMP6;
-		if (parse_icmpv6(optarg, info->icmpv6_type, info->icmpv6_code))
-			return 0;
+		ebt_parse_icmpv6(optarg, info->icmpv6_type, info->icmpv6_code);
 		info->bitmask |= EBT_IP6_ICMP6;
 		break;
 	case IP_TCLASS:
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 44f7109528166..439291eaaaca5 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -28,59 +28,6 @@ static const struct xt_option_entry icmp6_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-static void
-parse_icmpv6(const char *icmpv6type, uint8_t *type, uint8_t code[])
-{
-	static const unsigned int limit = ARRAY_SIZE(icmpv6_codes);
-	unsigned int match = limit;
-	unsigned int i;
-
-	for (i = 0; i < limit; i++) {
-		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type))
-		    == 0) {
-			if (match != limit)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Ambiguous ICMPv6 type `%s':"
-					   " `%s' or `%s'?",
-					   icmpv6type,
-					   icmpv6_codes[match].name,
-					   icmpv6_codes[i].name);
-			match = i;
-		}
-	}
-
-	if (match != limit) {
-		*type = icmpv6_codes[match].type;
-		code[0] = icmpv6_codes[match].code_min;
-		code[1] = icmpv6_codes[match].code_max;
-	} else {
-		char *slash;
-		char buffer[strlen(icmpv6type) + 1];
-		unsigned int number;
-
-		strcpy(buffer, icmpv6type);
-		slash = strchr(buffer, '/');
-
-		if (slash)
-			*slash = '\0';
-
-		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid ICMPv6 type `%s'\n", buffer);
-		*type = number;
-		if (slash) {
-			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
-				xtables_error(PARAMETER_PROBLEM,
-					   "Invalid ICMPv6 code `%s'\n",
-					   slash+1);
-			code[0] = code[1] = number;
-		} else {
-			code[0] = 0;
-			code[1] = 0xFF;
-		}
-	}
-}
-
 static void icmp6_init(struct xt_entry_match *m)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
@@ -93,7 +40,7 @@ static void icmp6_parse(struct xt_option_call *cb)
 	struct ip6t_icmp *icmpv6info = cb->data;
 
 	xtables_option_parse(cb);
-	parse_icmpv6(cb->arg, &icmpv6info->type, icmpv6info->code);
+	ipt_parse_icmpv6(cb->arg, &icmpv6info->type, icmpv6info->code);
 	if (cb->invert)
 		icmpv6info->invflags |= IP6T_ICMP_INV;
 }
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index f0e838874286b..b0318aebc2c57 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -35,59 +35,6 @@ static const struct xt_option_entry icmp_opts[] = {
 	XTOPT_TABLEEND,
 };
 
-static void 
-parse_icmp(const char *icmptype, uint8_t *type, uint8_t code[])
-{
-	static const unsigned int limit = ARRAY_SIZE(icmp_codes);
-	unsigned int match = limit;
-	unsigned int i;
-
-	for (i = 0; i < limit; i++) {
-		if (strncasecmp(icmp_codes[i].name, icmptype, strlen(icmptype))
-		    == 0) {
-			if (match != limit)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Ambiguous ICMP type `%s':"
-					   " `%s' or `%s'?",
-					   icmptype,
-					   icmp_codes[match].name,
-					   icmp_codes[i].name);
-			match = i;
-		}
-	}
-
-	if (match != limit) {
-		*type = icmp_codes[match].type;
-		code[0] = icmp_codes[match].code_min;
-		code[1] = icmp_codes[match].code_max;
-	} else {
-		char *slash;
-		char buffer[strlen(icmptype) + 1];
-		unsigned int number;
-
-		strcpy(buffer, icmptype);
-		slash = strchr(buffer, '/');
-
-		if (slash)
-			*slash = '\0';
-
-		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid ICMP type `%s'\n", buffer);
-		*type = number;
-		if (slash) {
-			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
-				xtables_error(PARAMETER_PROBLEM,
-					   "Invalid ICMP code `%s'\n",
-					   slash+1);
-			code[0] = code[1] = number;
-		} else {
-			code[0] = 0;
-			code[1] = 0xFF;
-		}
-	}
-}
-
 static void icmp_init(struct xt_entry_match *m)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)m->data;
@@ -101,7 +48,7 @@ static void icmp_parse(struct xt_option_call *cb)
 	struct ipt_icmp *icmpinfo = cb->data;
 
 	xtables_option_parse(cb);
-	parse_icmp(cb->arg, &icmpinfo->type, icmpinfo->code);
+	ipt_parse_icmp(cb->arg, &icmpinfo->type, icmpinfo->code);
 	if (cb->invert)
 		icmpinfo->invflags |= IPT_ICMP_INV;
 }
diff --git a/extensions/libxt_icmp.h b/extensions/libxt_icmp.h
index d6d9f9b6ffc98..a763e50c1de32 100644
--- a/extensions/libxt_icmp.h
+++ b/extensions/libxt_icmp.h
@@ -102,6 +102,132 @@ static const struct xt_icmp_names {
 	{ "membership-report-v3", 0x22 },
 };
 
+static inline char *parse_range(const char *str, unsigned int res[])
+{
+	char *next;
+
+	if (!xtables_strtoui(str, &next, &res[0], 0, 255))
+		return NULL;
+
+	res[1] = res[0];
+	if (*next == ':') {
+		str = next + 1;
+		if (!xtables_strtoui(str, &next, &res[1], 0, 255))
+			return NULL;
+	}
+
+	return next;
+}
+
+static void
+__parse_icmp(const struct xt_icmp_names codes[], size_t n_codes,
+	     const char *codes_name, const char *fmtstring,
+	     uint8_t type[], uint8_t code[])
+{
+	unsigned int match = n_codes;
+	unsigned int i, number[2];
+
+	for (i = 0; i < n_codes; i++) {
+		if (strncasecmp(codes[i].name, fmtstring, strlen(fmtstring)))
+			continue;
+		if (match != n_codes)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Ambiguous %s type `%s': `%s' or `%s'?",
+				      codes_name, fmtstring, codes[match].name,
+				      codes[i].name);
+		match = i;
+	}
+
+	if (match < n_codes) {
+		type[0] = type[1] = codes[match].type;
+		if (code) {
+			code[0] = codes[match].code_min;
+			code[1] = codes[match].code_max;
+		}
+	} else {
+		char *next = parse_range(fmtstring, number);
+		if (!next)
+			xtables_error(PARAMETER_PROBLEM, "Unknown %s type `%s'",
+				      codes_name, fmtstring);
+		type[0] = (uint8_t) number[0];
+		type[1] = (uint8_t) number[1];
+		switch (*next) {
+		case 0:
+			if (code) {
+				code[0] = 0;
+				code[1] = 255;
+			}
+			return;
+		case '/':
+			if (!code)
+				break;
+
+			next = parse_range(next + 1, number);
+			if (!next)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Unknown %s code `%s'",
+					      codes_name, fmtstring);
+			code[0] = (uint8_t) number[0];
+			code[1] = (uint8_t) number[1];
+			if (!*next)
+				break;
+		/* fallthrough */
+		default:
+			xtables_error(PARAMETER_PROBLEM,
+				      "unknown character %c", *next);
+		}
+	}
+}
+
+static inline void
+__ipt_parse_icmp(const struct xt_icmp_names *codes, size_t n_codes,
+		 const char *codes_name, const char *fmtstr,
+		 uint8_t *type, uint8_t code[])
+{
+	uint8_t types[2];
+
+	__parse_icmp(codes, n_codes, codes_name, fmtstr, types, code);
+	if (types[1] != types[0])
+		xtables_error(PARAMETER_PROBLEM,
+			      "%s type range not supported", codes_name);
+	*type = types[0];
+}
+
+static inline void
+ipt_parse_icmp(const char *str, uint8_t *type, uint8_t code[])
+{
+	__ipt_parse_icmp(icmp_codes, ARRAY_SIZE(icmp_codes),
+			 "ICMP", str, type, code);
+}
+
+static inline void
+ipt_parse_icmpv6(const char *str, uint8_t *type, uint8_t code[])
+{
+	__ipt_parse_icmp(icmpv6_codes, ARRAY_SIZE(icmpv6_codes),
+			 "ICMPv6", str, type, code);
+}
+
+static inline void
+ebt_parse_icmp(const char *str, uint8_t type[], uint8_t code[])
+{
+	__parse_icmp(icmp_codes, ARRAY_SIZE(icmp_codes),
+		     "ICMP", str, type, code);
+}
+
+static inline void
+ebt_parse_icmpv6(const char *str, uint8_t type[], uint8_t code[])
+{
+	__parse_icmp(icmpv6_codes, ARRAY_SIZE(icmpv6_codes),
+		     "ICMPv6", str, type, code);
+}
+
+static inline void
+ebt_parse_igmp(const char *str, uint8_t type[])
+{
+	__parse_icmp(igmp_types, ARRAY_SIZE(igmp_types),
+		     "IGMP", str, type, NULL);
+}
+
 static void xt_print_icmp_types(const struct xt_icmp_names *_icmp_codes,
 				unsigned int n_codes)
 {
-- 
2.38.0

