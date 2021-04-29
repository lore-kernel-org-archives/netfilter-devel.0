Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF0EC433B4
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF876144E
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhD2Nkh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbhD2Nkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:40:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03F9C06138B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Apr 2021 06:39:50 -0700 (PDT)
Received: from localhost ([::1]:37192 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lc6tR-0000VF-7U; Thu, 29 Apr 2021 15:39:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: SECMARK: Implement revision 1
Date:   Thu, 29 Apr 2021 15:39:42 +0200
Message-Id: <20210429133942.20244-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The changed data structure for communication with kernel allows to
exclude the field 'secid' which is populated on kernel side. Thus
this fixes the formerly always failing extension comparison breaking
rule check and rule delete by content.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_SECMARK.c           | 90 +++++++++++++++++++++-------
 extensions/libxt_SECMARK.t           |  4 ++
 include/linux/netfilter/xt_SECMARK.h |  6 ++
 3 files changed, 80 insertions(+), 20 deletions(-)
 create mode 100644 extensions/libxt_SECMARK.t

diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 6ba8606355daa..7aaa19de7b0e9 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -29,6 +29,13 @@ static const struct xt_option_entry SECMARK_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+static const struct xt_option_entry SECMARK_opts_v1[] = {
+	{.name = "selctx", .id = O_SELCTX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_PUT,
+	 XTOPT_POINTER(struct xt_secmark_tginfo, secctx)},
+	XTOPT_TABLEEND,
+};
+
 static void SECMARK_parse(struct xt_option_call *cb)
 {
 	struct xt_secmark_target_info *info = cb->data;
@@ -37,15 +44,23 @@ static void SECMARK_parse(struct xt_option_call *cb)
 	info->mode = SECMARK_MODE_SEL;
 }
 
-static void print_secmark(const struct xt_secmark_target_info *info)
+static void SECMARK_parse_v1(struct xt_option_call *cb)
+{
+	struct xt_secmark_tginfo *info = cb->data;
+
+	xtables_option_parse(cb);
+	info->mode = SECMARK_MODE_SEL;
+}
+
+static void print_secmark(__u8 mode, const char *secctx)
 {
-	switch (info->mode) {
+	switch (mode) {
 	case SECMARK_MODE_SEL:
-		printf("selctx %s", info->secctx);
+		printf("selctx %s", secctx);
 		break;
-	
+
 	default:
-		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", mode);
 	}
 }
 
@@ -56,7 +71,17 @@ static void SECMARK_print(const void *ip, const struct xt_entry_target *target,
 		(struct xt_secmark_target_info*)(target)->data;
 
 	printf(" SECMARK ");
-	print_secmark(info);
+	print_secmark(info->mode, info->secctx);
+}
+
+static void SECMARK_print_v1(const void *ip,
+			     const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_secmark_tginfo *info =
+		(struct xt_secmark_tginfo *)(target)->data;
+
+	printf(" SECMARK ");
+	print_secmark(info->mode, info->secctx);
 }
 
 static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
@@ -65,24 +90,49 @@ static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 		(struct xt_secmark_target_info*)target->data;
 
 	printf(" --");
-	print_secmark(info);
+	print_secmark(info->mode, info->secctx);
 }
 
-static struct xtables_target secmark_target = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "SECMARK",
-	.version	= XTABLES_VERSION,
-	.revision	= 0,
-	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
-	.help		= SECMARK_help,
-	.print		= SECMARK_print,
-	.save		= SECMARK_save,
-	.x6_parse	= SECMARK_parse,
-	.x6_options	= SECMARK_opts,
+static void SECMARK_save_v1(const void *ip,
+			    const struct xt_entry_target *target)
+{
+	const struct xt_secmark_tginfo *info =
+		(struct xt_secmark_tginfo *)target->data;
+
+	printf(" --");
+	print_secmark(info->mode, info->secctx);
+}
+
+static struct xtables_target secmark_tg_reg[] = {
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "SECMARK",
+		.version	= XTABLES_VERSION,
+		.revision	= 0,
+		.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
+		.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
+		.help		= SECMARK_help,
+		.print		= SECMARK_print,
+		.save		= SECMARK_save,
+		.x6_parse	= SECMARK_parse,
+		.x6_options	= SECMARK_opts,
+	},
+	{
+		.family		= NFPROTO_UNSPEC,
+		.name		= "SECMARK",
+		.version	= XTABLES_VERSION,
+		.revision	= 1,
+		.size		= XT_ALIGN(sizeof(struct xt_secmark_tginfo)),
+		.userspacesize	= XT_ALIGN(offsetof(struct xt_secmark_tginfo, secid)),
+		.help		= SECMARK_help,
+		.print		= SECMARK_print_v1,
+		.save		= SECMARK_save_v1,
+		.x6_parse	= SECMARK_parse_v1,
+		.x6_options	= SECMARK_opts_v1,
+	}
 };
 
 void _init(void)
 {
-	xtables_register_target(&secmark_target);
+	xtables_register_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
diff --git a/extensions/libxt_SECMARK.t b/extensions/libxt_SECMARK.t
new file mode 100644
index 0000000000000..39d4c09348bf4
--- /dev/null
+++ b/extensions/libxt_SECMARK.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+*security
+-j SECMARK --selctx system_u:object_r:firewalld_exec_t:s0;=;OK
+-j SECMARK;;FAIL
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index 989092bd6274b..f3b520e954e28 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -19,4 +19,10 @@ struct xt_secmark_target_info {
 	char secctx[SECMARK_SECCTX_MAX];
 };
 
+struct xt_secmark_tginfo {
+	__u8 mode;
+	char secctx[SECMARK_SECCTX_MAX];
+	__u32 secid;
+};
+
 #endif /*_XT_SECMARK_H_target */
-- 
2.31.0

