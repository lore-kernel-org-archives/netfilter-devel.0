Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD99C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiKCBl5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBl4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E3F11465
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cHGIl+bGjwigHEY+pywA+wc7BroK5BURQKesIF0/86g=; b=C8t5MwpFzjRxqeYSdmof5dhua3
        5yFoRKEREcQ7yBJocByr9aS3Ot9WRf3ZHzB1lsF+NLI+4BmKuOwVLUkXqAym2TXRyeh4+qU41yx7P
        SR1tkumBcUkISv6gSDqzvE6hUWJdDcWbC0bw2V3SOMmtKSJOYjbJsmeK4TKfinWUTMcDTPmobi0d6
        iWFFBpI0WR+na2WFYLMfypQZD2ZSOwcMK0lYz6Wq6M8GIOuqIZ91o4bdDfkBD2rz5m781Fop5qnQk
        Bnx6IjRokyR776Yzc5eHBgLAU98dsqdXKzt6MQZHZlm17w3o3CUBBecRMOX9RIEGl1E060MTHLGv3
        aSwMW+AA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEv-0005HG-Q6
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/6] extensions: DNAT: Generate print, save and xlate callbacks
Date:   Thu,  3 Nov 2022 02:41:11 +0100
Message-Id: <20221103014113.10851-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each extension's callbacks follow the same scheme so introduce a
generator which accepts the specifics as parameter - including the
method to transform from per-extension data into struct nf_nat_range2.

Also move the different parser frontends and fcheck callbacks in one
spot for clarity.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.c | 266 +++++++++++++---------------------------
 1 file changed, 86 insertions(+), 180 deletions(-)

diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 9b94062512c09..e53002541ee03 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -25,6 +25,14 @@
 	.min_proto	= TO_IPV4_MRC(ptr)->range[0].min,	\
 	.max_proto	= TO_IPV4_MRC(ptr)->range[0].max,	\
 };
+#define TO_NF_NAT_RANGE(ptr) ((const struct nf_nat_range *)(ptr))
+#define RANGE2_INIT_FROM_RANGE(ptr) {				\
+	.flags		= TO_NF_NAT_RANGE(ptr)->flags,		\
+	.min_addr	= TO_NF_NAT_RANGE(ptr)->min_addr,	\
+	.max_addr	= TO_NF_NAT_RANGE(ptr)->max_addr,	\
+	.min_proto	= TO_NF_NAT_RANGE(ptr)->min_proto,	\
+	.max_proto	= TO_NF_NAT_RANGE(ptr)->max_proto,	\
+};
 
 enum {
 	O_TO_DEST = 0,
@@ -256,6 +264,30 @@ static void DNAT_parse(struct xt_option_call *cb)
 	}
 }
 
+static void DNAT_parse6(struct xt_option_call *cb)
+{
+	struct nf_nat_range2 range = RANGE2_INIT_FROM_RANGE(cb->data);
+	struct nf_nat_range *range_v1 = (void *)cb->data;
+	const struct ip6t_entry *entry = cb->xt_entry;
+
+	__DNAT_parse(cb, entry->ipv6.proto, &range, AF_INET6);
+	memcpy(range_v1, &range, sizeof(*range_v1));
+}
+
+static void DNAT_parse_v2(struct xt_option_call *cb)
+{
+	const struct ipt_entry *entry = cb->xt_entry;
+
+	__DNAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
+}
+
+static void DNAT_parse6_v2(struct xt_option_call *cb)
+{
+	const struct ip6t_entry *entry = cb->xt_entry;
+
+	__DNAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
+}
+
 static void DNAT_fcheck(struct xt_fcheck_call *cb)
 {
 	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
@@ -267,6 +299,15 @@ static void DNAT_fcheck(struct xt_fcheck_call *cb)
 			      "Shifted portmap ranges not supported with this kernel");
 }
 
+static void DNAT_fcheck6(struct xt_fcheck_call *cb)
+{
+	struct nf_nat_range *range = (void *)cb->data;
+
+	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Shifted portmap ranges not supported with this kernel");
+}
+
 static char *sprint_range(const struct nf_nat_range2 *r, int family)
 {
 	bool brackets = family == AF_INET6 &&
@@ -317,25 +358,6 @@ static void __NAT_print(const struct nf_nat_range2 *r, int family,
 	if (r->flags & NF_NAT_RANGE_PERSISTENT)
 		printf(" %spersistent", flag_pfx);
 }
-#define __DNAT_print(r, family) __NAT_print(r, family, "to:", "", false)
-#define __DNAT_save(r, family) __NAT_print(r, family, "--to-destination ", "--", false)
-#define __REDIRECT_print(r) __NAT_print(r, AF_INET, "redir ports ", "", true)
-#define __REDIRECT_save(r) __NAT_print(r, AF_INET, "--to-ports ", "--", true)
-
-static void DNAT_print(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
-
-	__DNAT_print(&range, AF_INET);
-}
-
-static void DNAT_save(const void *ip, const struct xt_entry_target *target)
-{
-	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
-
-	__DNAT_save(&range, AF_INET);
-}
 
 static int
 __NAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r,
@@ -362,162 +384,46 @@ __NAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r,
 	return 1;
 }
 
-static int DNAT_xlate(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
-{
-	struct nf_nat_range2 range =
-		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
-
-	return __NAT_xlate(xl, &range, AF_INET, "dnat");
-}
-
-static void DNAT_parse_v2(struct xt_option_call *cb)
-{
-	const struct ipt_entry *entry = cb->xt_entry;
-
-	__DNAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
-}
-
-static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	__DNAT_print((const void *)target->data, AF_INET);
-}
-
-static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
-{
-	__DNAT_save((const void *)target->data, AF_INET);
-}
-
-static int DNAT_xlate_v2(struct xt_xlate *xl,
-			  const struct xt_xlate_tg_params *params)
-{
-	return __NAT_xlate(xl, (const void *)params->target->data,
-			   AF_INET, "dnat");
-}
-
-static void DNAT_parse6(struct xt_option_call *cb)
-{
-	const struct ip6t_entry *entry = cb->xt_entry;
-	struct nf_nat_range *range_v1 = (void *)cb->data;
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, range_v1, sizeof(*range_v1));
-	__DNAT_parse(cb, entry->ipv6.proto, &range, AF_INET6);
-	memcpy(range_v1, &range, sizeof(*range_v1));
-}
-
-static void DNAT_fcheck6(struct xt_fcheck_call *cb)
-{
-	struct nf_nat_range *range = (void *)cb->data;
-
-	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Shifted portmap ranges not supported with this kernel");
+#define PSX_GEN(name, converter, family,                                       \
+		print_rangeopt, save_rangeopt, skip_colon, xlate)              \
+static void name##_print(const void *ip, const struct xt_entry_target *target, \
+			 int numeric)                                          \
+{                                                                              \
+	struct nf_nat_range2 range = converter(target->data);                  \
+	                                                                       \
+	__NAT_print(&range, family, print_rangeopt, "", skip_colon);           \
+}                                                                              \
+static void name##_save(const void *ip, const struct xt_entry_target *target)  \
+{                                                                              \
+	struct nf_nat_range2 range = converter(target->data);                  \
+	                                                                       \
+	__NAT_print(&range, family, save_rangeopt, "--", skip_colon);          \
+}                                                                              \
+static int name##_xlate(struct xt_xlate *xl,                                   \
+			const struct xt_xlate_tg_params *params)               \
+{                                                                              \
+	struct nf_nat_range2 range = converter(params->target->data);          \
+	                                                                       \
+	return __NAT_xlate(xl, &range, family, xlate);                         \
 }
 
-static void DNAT_print6(const void *ip, const struct xt_entry_target *target,
-			int numeric)
-{
-	struct nf_nat_range2 range = {};
+PSX_GEN(DNAT, RANGE2_INIT_FROM_IPV4_MRC, \
+	AF_INET, "to:", "--to-destination ", false, "dnat")
 
-	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__DNAT_print(&range, AF_INET6);
-}
+PSX_GEN(DNATv2, *(struct nf_nat_range2 *), \
+	AF_INET, "to:", "--to-destination ", false, "dnat")
 
-static void DNAT_save6(const void *ip, const struct xt_entry_target *target)
-{
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__DNAT_save(&range, AF_INET6);
-}
-
-static int DNAT_xlate6(struct xt_xlate *xl,
-		       const struct xt_xlate_tg_params *params)
-{
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, (const void *)params->target->data,
-	       sizeof(struct nf_nat_range));
-	return __NAT_xlate(xl, &range, AF_INET6, "dnat");
-}
+PSX_GEN(DNAT6, RANGE2_INIT_FROM_RANGE, \
+	AF_INET6, "to:", "--to-destination ", false, "dnat")
 
-static void DNAT_parse6_v2(struct xt_option_call *cb)
-{
-	const struct ip6t_entry *entry = cb->xt_entry;
-
-	__DNAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
-}
+PSX_GEN(DNAT6v2, *(struct nf_nat_range2 *), \
+	AF_INET6, "to:", "--to-destination ", false, "dnat")
 
-static void DNAT_print6_v2(const void *ip, const struct xt_entry_target *target,
-			   int numeric)
-{
-	__DNAT_print((const void *)target->data, AF_INET6);
-}
+PSX_GEN(REDIRECT, RANGE2_INIT_FROM_IPV4_MRC, \
+	AF_INET, "redir ports ", "--to-ports ", true, "redirect")
 
-static void DNAT_save6_v2(const void *ip, const struct xt_entry_target *target)
-{
-	__DNAT_save((const void *)target->data, AF_INET6);
-}
-
-static int DNAT_xlate6_v2(struct xt_xlate *xl,
-			  const struct xt_xlate_tg_params *params)
-{
-	return __NAT_xlate(xl, (const void *)params->target->data,
-			   AF_INET6, "dnat");
-}
-
-static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
-                           int numeric)
-{
-	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
-
-	__REDIRECT_print(&range);
-}
-
-static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
-{
-	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
-
-	__REDIRECT_save(&range);
-}
-
-static int REDIRECT_xlate(struct xt_xlate *xl,
-			   const struct xt_xlate_tg_params *params)
-{
-	struct nf_nat_range2 range =
-		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
-
-	return __NAT_xlate(xl, &range, AF_INET, "redirect");
-}
-
-static void REDIRECT_print6(const void *ip, const struct xt_entry_target *target,
-                            int numeric)
-{
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__REDIRECT_print(&range);
-}
-
-static void REDIRECT_save6(const void *ip, const struct xt_entry_target *target)
-{
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__REDIRECT_save(&range);
-}
-
-static int REDIRECT_xlate6(struct xt_xlate *xl,
-			   const struct xt_xlate_tg_params *params)
-{
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, (const void *)params->target->data,
-	       sizeof(struct nf_nat_range));
-	return __NAT_xlate(xl, &range, AF_INET6, "redirect");
-}
+PSX_GEN(REDIRECT6, RANGE2_INIT_FROM_RANGE, \
+	AF_INET6, "redir ports ", "--to-ports ", true, "redirect")
 
 static struct xtables_target dnat_tg_reg[] = {
 	{
@@ -558,12 +464,12 @@ static struct xtables_target dnat_tg_reg[] = {
 		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
 		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
 		.help		= DNAT_help,
-		.print		= DNAT_print6,
-		.save		= DNAT_save6,
+		.print		= DNAT6_print,
+		.save		= DNAT6_save,
 		.x6_parse	= DNAT_parse6,
 		.x6_fcheck	= DNAT_fcheck6,
 		.x6_options	= DNAT_opts,
-		.xlate		= DNAT_xlate6,
+		.xlate		= DNAT6_xlate,
 	},
 	{
 		.name		= "REDIRECT",
@@ -572,12 +478,12 @@ static struct xtables_target dnat_tg_reg[] = {
 		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
 		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
 		.help		= REDIRECT_help,
-		.print		= REDIRECT_print6,
-		.save		= REDIRECT_save6,
+		.print		= REDIRECT6_print,
+		.save		= REDIRECT6_save,
 		.x6_parse	= DNAT_parse6,
 		.x6_fcheck	= DNAT_fcheck6,
 		.x6_options	= REDIRECT_opts,
-		.xlate		= REDIRECT_xlate6,
+		.xlate		= REDIRECT6_xlate,
 	},
 	{
 		.name		= "DNAT",
@@ -587,11 +493,11 @@ static struct xtables_target dnat_tg_reg[] = {
 		.size		= XT_ALIGN(sizeof(struct nf_nat_range2)),
 		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range2)),
 		.help		= DNAT_help_v2,
-		.print		= DNAT_print_v2,
-		.save		= DNAT_save_v2,
+		.print		= DNATv2_print,
+		.save		= DNATv2_save,
 		.x6_parse	= DNAT_parse_v2,
 		.x6_options	= DNAT_opts,
-		.xlate		= DNAT_xlate_v2,
+		.xlate		= DNATv2_xlate,
 	},
 	{
 		.name		= "DNAT",
@@ -601,11 +507,11 @@ static struct xtables_target dnat_tg_reg[] = {
 		.size		= XT_ALIGN(sizeof(struct nf_nat_range2)),
 		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range2)),
 		.help		= DNAT_help_v2,
-		.print		= DNAT_print6_v2,
-		.save		= DNAT_save6_v2,
+		.print		= DNAT6v2_print,
+		.save		= DNAT6v2_save,
 		.x6_parse	= DNAT_parse6_v2,
 		.x6_options	= DNAT_opts,
-		.xlate		= DNAT_xlate6_v2,
+		.xlate		= DNAT6v2_xlate,
 	},
 };
 
-- 
2.38.0

