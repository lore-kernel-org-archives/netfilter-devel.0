Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8214C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 16:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbiAJQbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 11:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237471AbiAJQbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 11:31:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB50C06173F
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jan 2022 08:31:38 -0800 (PST)
Received: from localhost ([::1]:59114 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n6xa2-0002si-FF; Mon, 10 Jan 2022 17:31:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: *NAT: Kill multiple IPv4 range support
Date:   Mon, 10 Jan 2022 17:31:30 +0100
Message-Id: <20220110163130.7517-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is the year of the great revolution, nobody cares about kernel
versions below 2.6.11 anymore. Time to get rid of the cruft.

While being at it, drop the explicit duplicate argument check and
instead just remove XTOPT_MULTI flag from the respective
xt_option_entry.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_DNAT.c  | 138 ++++++++++++---------------------
 extensions/libipt_SNAT.c  | 158 ++++++++++++++------------------------
 extensions/libxt_DNAT.man |   6 --
 extensions/libxt_SNAT.man |   6 --
 4 files changed, 106 insertions(+), 202 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 5b33fd23f6e36..eefa95eb73630 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -18,14 +18,6 @@ enum {
 	F_X_TO_DEST = 1 << O_X_TO_DEST,
 };
 
-/* Dest NAT data consists of a multi-range, indicating where to map
-   to. */
-struct ipt_natinfo
-{
-	struct xt_entry_target t;
-	struct nf_nat_ipv4_multi_range_compat mr;
-};
-
 static void DNAT_help(void)
 {
 	printf(
@@ -46,41 +38,20 @@ static void DNAT_help_v2(void)
 
 static const struct xt_option_entry DNAT_opts[] = {
 	{.name = "to-destination", .id = O_TO_DEST, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND | XTOPT_MULTI},
+	 .flags = XTOPT_MAND},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
 	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
-static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct nf_nat_ipv4_range *range)
-{
-	unsigned int size;
-
-	/* One rangesize already in struct ipt_natinfo */
-	size = XT_ALIGN(sizeof(*info) + info->mr.rangesize * sizeof(*range));
-
-	info = realloc(info, size);
-	if (!info)
-		xtables_error(OTHER_PROBLEM, "Out of memory\n");
-
-	info->t.u.target_size = size;
-	info->mr.range[info->mr.rangesize] = *range;
-	info->mr.rangesize++;
-
-	return info;
-}
-
 /* Ranges expected in network order. */
-static struct xt_entry_target *
-parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
+static void
+parse_to(const char *orig_arg, int portok, struct nf_nat_ipv4_range *range)
 {
-	struct nf_nat_ipv4_range range;
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
 	arg = xtables_strdup(orig_arg);
-	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
 
 	if (colon) {
@@ -90,7 +61,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
@@ -104,8 +75,8 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 
 		dash = strchr(colon, '-');
 		if (!dash) {
-			range.min.tcp.port
-				= range.max.tcp.port
+			range->min.tcp.port
+				= range->max.tcp.port
 				= htons(port);
 		} else {
 			int maxport;
@@ -118,18 +89,18 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 				/* People are stupid. */
 				xtables_error(PARAMETER_PROBLEM,
 					   "Port range `%s' funky\n", colon+1);
-			range.min.tcp.port = htons(port);
-			range.max.tcp.port = htons(maxport);
+			range->min.tcp.port = htons(port);
+			range->max.tcp.port = htons(maxport);
 		}
 		/* Starts with a colon? No IP info...*/
 		if (colon == arg) {
 			free(arg);
-			return &(append_range(info, &range)->t);
+			return;
 		}
 		*colon = '\0';
 	}
 
-	range.flags |= NF_NAT_RANGE_MAP_IPS;
+	range->flags |= NF_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 	if (colon && dash && dash > colon)
 		dash = NULL;
@@ -141,24 +112,24 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	if (!ip)
 		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
-	range.min_ip = ip->s_addr;
+	range->min_ip = ip->s_addr;
 	if (dash) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 				   dash+1);
-		range.max_ip = ip->s_addr;
+		range->max_ip = ip->s_addr;
 	} else
-		range.max_ip = range.min_ip;
+		range->max_ip = range->min_ip;
 
 	free(arg);
-	return &(append_range(info, &range)->t);
+	return;
 }
 
 static void DNAT_parse(struct xt_option_call *cb)
 {
+	struct nf_nat_ipv4_multi_range_compat *mr = (void *)cb->data;
 	const struct ipt_entry *entry = cb->xt_entry;
-	struct ipt_natinfo *info = (void *)(*cb->target);
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -173,18 +144,11 @@ static void DNAT_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_DEST:
-		if (cb->xflags & F_X_TO_DEST) {
-			if (!kernel_version)
-				get_kernel_version();
-			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				xtables_error(PARAMETER_PROBLEM,
-					   "DNAT: Multiple --to-destination not supported");
-		}
-		*cb->target = parse_to(cb->arg, portok, info);
+		parse_to(cb->arg, portok, mr->range);
 		cb->xflags |= F_X_TO_DEST;
 		break;
 	case O_PERSISTENT:
-		info->mr.range[0].flags |= NF_NAT_RANGE_PERSISTENT;
+		mr->range->flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
@@ -196,6 +160,8 @@ static void DNAT_fcheck(struct xt_fcheck_call *cb)
 
 	if ((cb->xflags & f) == f)
 		mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
+
+	mr->rangesize = 1;
 }
 
 static void print_range(const struct nf_nat_ipv4_range *r)
@@ -221,32 +187,28 @@ static void print_range(const struct nf_nat_ipv4_range *r)
 static void DNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	const struct ipt_natinfo *info = (const void *)target;
-	unsigned int i = 0;
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+				(const void *)target->data;
 
 	printf(" to:");
-	for (i = 0; i < info->mr.rangesize; i++) {
-		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
-			printf(" random");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
-			printf(" persistent");
-	}
+	print_range(mr->range);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" random");
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
+		printf(" persistent");
 }
 
 static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_natinfo *info = (const void *)target;
-	unsigned int i = 0;
-
-	for (i = 0; i < info->mr.rangesize; i++) {
-		printf(" --to-destination ");
-		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
-			printf(" --random");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
-			printf(" --persistent");
-	}
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+				(const void *)target->data;
+
+	printf(" --to-destination ");
+	print_range(mr->range);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" --random");
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
+		printf(" --persistent");
 }
 
 static void print_range_xlate(const struct nf_nat_ipv4_range *r,
@@ -272,23 +234,21 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 static int DNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)params->target;
-	unsigned int i = 0;
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+			(const void *)params->target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
-	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_xlate_add(xl, "dnat to ");
-		print_range_xlate(&info->mr.range[i], xl);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
-			xt_xlate_add(xl, " random");
-			sep_need = true;
-		}
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT) {
-			if (sep_need)
-				sep = ",";
-			xt_xlate_add(xl, "%spersistent", sep);
-		}
+	xt_xlate_add(xl, "dnat to ");
+	print_range_xlate(mr->range, xl);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		xt_xlate_add(xl, " random");
+		sep_need = true;
+	}
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT) {
+		if (sep_need)
+			sep = ",";
+		xt_xlate_add(xl, "%spersistent", sep);
 	}
 
 	return 1;
@@ -406,10 +366,6 @@ static void DNAT_parse_v2(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_DEST:
-		if (cb->xflags & F_X_TO_DEST) {
-			xtables_error(PARAMETER_PROBLEM,
-				   "DNAT: Multiple --to-destination not supported");
-		}
 		parse_to_v2(cb->arg, portok, range);
 		cb->xflags |= F_X_TO_DEST;
 		break;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index c655439ec9192..bd36830ae91ce 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -20,14 +20,6 @@ enum {
 	F_X_TO_SRC     = 1 << O_X_TO_SRC,
 };
 
-/* Source NAT data consists of a multi-range, indicating where to map
-   to. */
-struct ipt_natinfo
-{
-	struct xt_entry_target t;
-	struct nf_nat_ipv4_multi_range_compat mr;
-};
-
 static void SNAT_help(void)
 {
 	printf(
@@ -39,42 +31,21 @@ static void SNAT_help(void)
 
 static const struct xt_option_entry SNAT_opts[] = {
 	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND | XTOPT_MULTI},
+	 .flags = XTOPT_MAND},
 	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
 	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
 	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
 	XTOPT_TABLEEND,
 };
 
-static struct ipt_natinfo *
-append_range(struct ipt_natinfo *info, const struct nf_nat_ipv4_range *range)
-{
-	unsigned int size;
-
-	/* One rangesize already in struct ipt_natinfo */
-	size = XT_ALIGN(sizeof(*info) + info->mr.rangesize * sizeof(*range));
-
-	info = realloc(info, size);
-	if (!info)
-		xtables_error(OTHER_PROBLEM, "Out of memory\n");
-
-	info->t.u.target_size = size;
-	info->mr.range[info->mr.rangesize] = *range;
-	info->mr.rangesize++;
-
-	return info;
-}
-
 /* Ranges expected in network order. */
-static struct xt_entry_target *
-parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
+static void
+parse_to(const char *orig_arg, int portok, struct nf_nat_ipv4_range *range)
 {
-	struct nf_nat_ipv4_range range;
 	char *arg, *colon, *dash, *error;
 	const struct in_addr *ip;
 
 	arg = xtables_strdup(orig_arg);
-	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
 
 	if (colon) {
@@ -84,7 +55,7 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
@@ -98,8 +69,8 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 
 		dash = strchr(colon, '-');
 		if (!dash) {
-			range.min.tcp.port
-				= range.max.tcp.port
+			range->min.tcp.port
+				= range->max.tcp.port
 				= htons(port);
 		} else {
 			int maxport;
@@ -112,18 +83,18 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 				/* People are stupid. */
 				xtables_error(PARAMETER_PROBLEM,
 					   "Port range `%s' funky\n", colon+1);
-			range.min.tcp.port = htons(port);
-			range.max.tcp.port = htons(maxport);
+			range->min.tcp.port = htons(port);
+			range->max.tcp.port = htons(maxport);
 		}
 		/* Starts with a colon? No IP info...*/
 		if (colon == arg) {
 			free(arg);
-			return &(append_range(info, &range)->t);
+			return;
 		}
 		*colon = '\0';
 	}
 
-	range.flags |= NF_NAT_RANGE_MAP_IPS;
+	range->flags |= NF_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
 	if (colon && dash && dash > colon)
 		dash = NULL;
@@ -135,24 +106,24 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	if (!ip)
 		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
-	range.min_ip = ip->s_addr;
+	range->min_ip = ip->s_addr;
 	if (dash) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
 			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 				   dash+1);
-		range.max_ip = ip->s_addr;
+		range->max_ip = ip->s_addr;
 	} else
-		range.max_ip = range.min_ip;
+		range->max_ip = range->min_ip;
 
 	free(arg);
-	return &(append_range(info, &range)->t);
+	return;
 }
 
 static void SNAT_parse(struct xt_option_call *cb)
 {
+	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 	const struct ipt_entry *entry = cb->xt_entry;
-	struct ipt_natinfo *info = (void *)(*cb->target);
 	int portok;
 
 	if (entry->ip.proto == IPPROTO_TCP
@@ -167,18 +138,11 @@ static void SNAT_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_SRC:
-		if (cb->xflags & F_X_TO_SRC) {
-			if (!kernel_version)
-				get_kernel_version();
-			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				xtables_error(PARAMETER_PROBLEM,
-					   "SNAT: Multiple --to-source not supported");
-		}
-		*cb->target = parse_to(cb->arg, portok, info);
+		parse_to(cb->arg, portok, mr->range);
 		cb->xflags |= F_X_TO_SRC;
 		break;
 	case O_PERSISTENT:
-		info->mr.range[0].flags |= NF_NAT_RANGE_PERSISTENT;
+		mr->range->flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
 	}
 }
@@ -190,9 +154,11 @@ static void SNAT_fcheck(struct xt_fcheck_call *cb)
 	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 
 	if ((cb->xflags & f) == f)
-		mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
+		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
 	if ((cb->xflags & r) == r)
-		mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+
+	mr->rangesize = 1;
 }
 
 static void print_range(const struct nf_nat_ipv4_range *r)
@@ -218,36 +184,32 @@ static void print_range(const struct nf_nat_ipv4_range *r)
 static void SNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	const struct ipt_natinfo *info = (const void *)target;
-	unsigned int i = 0;
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+				(const void *)target->data;
 
 	printf(" to:");
-	for (i = 0; i < info->mr.rangesize; i++) {
-		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
-			printf(" random");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-			printf(" random-fully");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
-			printf(" persistent");
-	}
+	print_range(mr->range);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" random");
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" random-fully");
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
+		printf(" persistent");
 }
 
 static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct ipt_natinfo *info = (const void *)target;
-	unsigned int i = 0;
-
-	for (i = 0; i < info->mr.rangesize; i++) {
-		printf(" --to-source ");
-		print_range(&info->mr.range[i]);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
-			printf(" --random");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-			printf(" --random-fully");
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
-			printf(" --persistent");
-	}
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+				(const void *)target->data;
+
+	printf(" --to-source ");
+	print_range(mr->range);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
+		printf(" --random");
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" --random-fully");
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
+		printf(" --persistent");
 }
 
 static void print_range_xlate(const struct nf_nat_ipv4_range *r,
@@ -274,29 +236,27 @@ static void print_range_xlate(const struct nf_nat_ipv4_range *r,
 static int SNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct ipt_natinfo *info = (const void *)params->target;
-	unsigned int i = 0;
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+				(const void *)params->target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
-	for (i = 0; i < info->mr.rangesize; i++) {
-		xt_xlate_add(xl, "snat to ");
-		print_range_xlate(&info->mr.range[i], xl);
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
-			xt_xlate_add(xl, " random");
-			sep_need = true;
-		}
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-			if (sep_need)
-				sep = ",";
-			xt_xlate_add(xl, "%sfully-random", sep);
-			sep_need = true;
-		}
-		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT) {
-			if (sep_need)
-				sep = ",";
-			xt_xlate_add(xl, "%spersistent", sep);
-		}
+	xt_xlate_add(xl, "snat to ");
+	print_range_xlate(mr->range, xl);
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		xt_xlate_add(xl, " random");
+		sep_need = true;
+	}
+	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
+		if (sep_need)
+			sep = ",";
+		xt_xlate_add(xl, "%sfully-random", sep);
+		sep_need = true;
+	}
+	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT) {
+		if (sep_need)
+			sep = ",";
+		xt_xlate_add(xl, "%spersistent", sep);
 	}
 
 	return 1;
diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index 225274ff30b99..c3daea9a40394 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -18,12 +18,6 @@ if the rule also specifies one of the following protocols:
 If no port range is specified, then the destination port will never be
 modified. If no IP address is specified then only the destination port
 will be modified.
-In Kernels up to 2.6.10 you can add several \-\-to\-destination options. For
-those kernels, if you specify more than one destination address, either via an
-address range or multiple \-\-to\-destination options, a simple round-robin (one
-after another in cycle) load balancing takes place between these addresses.
-Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
-anymore.
 .TP
 \fB\-\-random\fP
 If option
diff --git a/extensions/libxt_SNAT.man b/extensions/libxt_SNAT.man
index 8cd0b80e9ed4a..087664471d110 100644
--- a/extensions/libxt_SNAT.man
+++ b/extensions/libxt_SNAT.man
@@ -19,12 +19,6 @@ If no port range is specified, then source ports below 512 will be
 mapped to other ports below 512: those between 512 and 1023 inclusive
 will be mapped to ports below 1024, and other ports will be mapped to
 1024 or above. Where possible, no port alteration will occur.
-In Kernels up to 2.6.10, you can add several \-\-to\-source options. For those
-kernels, if you specify more than one source address, either via an address
-range or multiple \-\-to\-source options, a simple round-robin (one after another
-in cycle) takes place between these addresses.
-Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges
-anymore.
 .TP
 \fB\-\-random\fP
 If option
-- 
2.34.1

