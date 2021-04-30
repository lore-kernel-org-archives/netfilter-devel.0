Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EA7C43460
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 12:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3631161474
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 12:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhD3MBL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Apr 2021 08:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbhD3MBK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 08:01:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC160C06174A
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 05:00:22 -0700 (PDT)
Received: from localhost ([::1]:39912 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lcRoj-00031R-0J; Fri, 30 Apr 2021 14:00:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [net-next PATCH v2] netfilter: xt_SECMARK: add new revision to fix structure layout
Date:   Fri, 30 Apr 2021 14:00:13 +0200
Message-Id: <20210430120013.28875-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This extension breaks when trying to delete rules, add a new revision to
fix this.

Fixes: 5e6874cdb8de ("[SECMARK]: Add xtables SECMARK target")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Formal submission of this patch which I received in private. Used it to
implement user space side and thereby discovered a bug:
secmark_tg_check_v1() would not populate the legacy data structure with
the 'secid' value initialized in the new data structure, thereby
breaking functionality for old user space.

Changes since v1:
- Choose a more suitable name for v1 data structure
- Fix name suffixes of revision-specific callbacks
---
 include/uapi/linux/netfilter/xt_SECMARK.h |  6 ++
 net/netfilter/xt_SECMARK.c                | 88 ++++++++++++++++++-----
 2 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_SECMARK.h b/include/uapi/linux/netfilter/xt_SECMARK.h
index 1f2a708413f5d..beb2cadba8a9c 100644
--- a/include/uapi/linux/netfilter/xt_SECMARK.h
+++ b/include/uapi/linux/netfilter/xt_SECMARK.h
@@ -20,4 +20,10 @@ struct xt_secmark_target_info {
 	char secctx[SECMARK_SECCTX_MAX];
 };
 
+struct xt_secmark_target_info_v1 {
+	__u8 mode;
+	char secctx[SECMARK_SECCTX_MAX];
+	__u32 secid;
+};
+
 #endif /*_XT_SECMARK_H_target */
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 75625d13e976c..498a0bf6f0444 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -24,10 +24,9 @@ MODULE_ALIAS("ip6t_SECMARK");
 static u8 mode;
 
 static unsigned int
-secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
+secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 {
 	u32 secmark = 0;
-	const struct xt_secmark_target_info *info = par->targinfo;
 
 	switch (mode) {
 	case SECMARK_MODE_SEL:
@@ -41,7 +40,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
-static int checkentry_lsm(struct xt_secmark_target_info *info)
+static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
 	int err;
 
@@ -73,15 +72,15 @@ static int checkentry_lsm(struct xt_secmark_target_info *info)
 	return 0;
 }
 
-static int secmark_tg_check(const struct xt_tgchk_param *par)
+static int
+secmark_tg_check(const char *table, struct xt_secmark_target_info_v1 *info)
 {
-	struct xt_secmark_target_info *info = par->targinfo;
 	int err;
 
-	if (strcmp(par->table, "mangle") != 0 &&
-	    strcmp(par->table, "security") != 0) {
+	if (strcmp(table, "mangle") != 0 &&
+	    strcmp(table, "security") != 0) {
 		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
-				    par->table);
+				    table);
 		return -EINVAL;
 	}
 
@@ -116,25 +115,76 @@ static void secmark_tg_destroy(const struct xt_tgdtor_param *par)
 	}
 }
 
-static struct xt_target secmark_tg_reg __read_mostly = {
-	.name       = "SECMARK",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = secmark_tg_check,
-	.destroy    = secmark_tg_destroy,
-	.target     = secmark_tg,
-	.targetsize = sizeof(struct xt_secmark_target_info),
-	.me         = THIS_MODULE,
+static int secmark_tg_check_v0(const struct xt_tgchk_param *par)
+{
+	struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.mode	= info->mode,
+	};
+	int ret;
+
+	memcpy(newinfo.secctx, info->secctx, SECMARK_SECCTX_MAX);
+
+	ret = secmark_tg_check(par->table, &newinfo);
+	info->secid = newinfo.secid;
+
+	return ret;
+}
+
+static unsigned int
+secmark_tg_v0(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_secmark_target_info *info = par->targinfo;
+	struct xt_secmark_target_info_v1 newinfo = {
+		.secid	= info->secid,
+	};
+
+	return secmark_tg(skb, &newinfo);
+}
+
+static int secmark_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	return secmark_tg_check(par->table, par->targinfo);
+}
+
+static unsigned int
+secmark_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	return secmark_tg(skb, par->targinfo);
+}
+
+static struct xt_target secmark_tg_reg[] __read_mostly = {
+	{
+		.name		= "SECMARK",
+		.revision	= 0,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v0,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v0,
+		.targetsize	= sizeof(struct xt_secmark_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "SECMARK",
+		.revision	= 1,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= secmark_tg_check_v1,
+		.destroy	= secmark_tg_destroy,
+		.target		= secmark_tg_v1,
+		.targetsize	= sizeof(struct xt_secmark_target_info_v1),
+		.usersize	= offsetof(struct xt_secmark_target_info_v1, secid),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init secmark_tg_init(void)
 {
-	return xt_register_target(&secmark_tg_reg);
+	return xt_register_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 static void __exit secmark_tg_exit(void)
 {
-	xt_unregister_target(&secmark_tg_reg);
+	xt_unregister_targets(secmark_tg_reg, ARRAY_SIZE(secmark_tg_reg));
 }
 
 module_init(secmark_tg_init);
-- 
2.31.0

