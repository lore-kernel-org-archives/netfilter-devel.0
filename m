Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF14C61D9C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344440AbjKVVpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344355AbjKVVpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0E1B3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1XzJ8v7m5TQoLNiiA6LQLWtENiEtuayESJouAjlGOmM=; b=KNnmomf9q2efo0G/ZLVugXKU57
        UbQF2GPwTey4+aM48AuqXW5T9UvYtlVLVCYZ49OzPWkH3wqQiVZ6B1HoMnonlSA15vXpbLioMrMBI
        czhlSZUc1YTrBQvo335onQvak+43ks5aXB0OnJnX6Fw0TFWQoza5H5ULRlA6I7vYYIVOcHXztIXIv
        IQU9iTN9f68tIS1p85zdLimhjxur/QxWxLUJILIjoSp+ThC7DXmAZbLZl/WwkMiubKYr/sqLI9mFB
        WTzy9K9gJ2zkKmetQZCEUykJ+IMkhCxg1zD3Em4/NFDu8Zq0FYNy0My8pRTLspq2chh/JkPbYfaXU
        Jcv/PRlA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1k-0003hk-Hn
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/6] extensions: MARK: arptables: Use guided option parser
Date:   Wed, 22 Nov 2023 22:53:01 +0100
Message-ID: <20231122215301.15725-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It expects mark values in hex which is possible by setting the base
field.

The only adjustment needed to use the revision 2 parser is to fill the
mask for --set-mark: With XTTYPE_MARKMASK32, an omitted mask sets all
mask bits, XTTYPE_UINT32 leaves it uninitialized, though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_MARK.c | 82 ++++++++---------------------------------
 1 file changed, 15 insertions(+), 67 deletions(-)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index d6eacfcb33f69..703d894f233d9 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -1,4 +1,3 @@
-#include <getopt.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <xtables.h>
@@ -69,6 +68,16 @@ static const struct xt_option_entry mark_tg_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+static const struct xt_option_entry mark_tg_arp_opts[] = {
+	{.name = "set-mark", .id = O_SET_MARK, .type = XTTYPE_UINT32,
+	 .base = 16, .excl = F_ANY},
+	{.name = "and-mark", .id = O_AND_MARK, .type = XTTYPE_UINT32,
+	 .base = 16, .excl = F_ANY},
+	{.name = "or-mark", .id = O_OR_MARK, .type = XTTYPE_UINT32,
+	 .base = 16, .excl = F_ANY},
+	XTOPT_TABLEEND,
+};
+
 static void mark_tg_help(void)
 {
 	printf(
@@ -136,6 +145,8 @@ static void mark_tg_parse(struct xt_option_call *cb)
 	case O_SET_MARK:
 		info->mark = cb->val.mark;
 		info->mask = cb->val.mark | cb->val.mask;
+		if (cb->entry->type == XTTYPE_UINT32)
+			info->mask = UINT32_MAX;
 		break;
 	case O_AND_MARK:
 		info->mark = 0;
@@ -263,70 +274,6 @@ static void mark_tg_arp_print(const void *ip,
 	mark_tg_arp_save(ip, target);
 }
 
-#define MARK_OPT 1
-#define AND_MARK_OPT 2
-#define OR_MARK_OPT 3
-
-static struct option mark_tg_arp_opts[] = {
-	{ .name = "set-mark", .has_arg = required_argument, .flag = 0, .val = MARK_OPT },
-	{ .name = "and-mark", .has_arg = required_argument, .flag = 0, .val = AND_MARK_OPT },
-	{ .name = "or-mark", .has_arg = required_argument, .flag = 0, .val =  OR_MARK_OPT },
-	{ .name = NULL}
-};
-
-static int
-mark_tg_arp_parse(int c, char **argv, int invert, unsigned int *flags,
-		  const void *entry, struct xt_entry_target **target)
-{
-	struct xt_mark_tginfo2 *info =
-		(struct xt_mark_tginfo2 *)(*target)->data;
-	int i;
-
-	switch (c) {
-	case MARK_OPT:
-		if (sscanf(argv[optind-1], "%x", &i) != 1) {
-			xtables_error(PARAMETER_PROBLEM,
-				"Bad mark value `%s'", optarg);
-			return 0;
-		}
-		info->mark = i;
-		info->mask = 0xffffffffU;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-				"MARK: Can't specify --set-mark twice");
-		*flags = 1;
-		break;
-	case AND_MARK_OPT:
-		if (sscanf(argv[optind-1], "%x", &i) != 1) {
-			xtables_error(PARAMETER_PROBLEM,
-				"Bad mark value `%s'", optarg);
-			return 0;
-		}
-		info->mark = 0;
-		info->mask = ~i;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-				"MARK: Can't specify --and-mark twice");
-		*flags = 1;
-		break;
-	case OR_MARK_OPT:
-		if (sscanf(argv[optind-1], "%x", &i) != 1) {
-			xtables_error(PARAMETER_PROBLEM,
-				"Bad mark value `%s'", optarg);
-			return 0;
-		}
-		info->mark = info->mask = i;
-		if (*flags)
-			xtables_error(PARAMETER_PROBLEM,
-				"MARK: Can't specify --or-mark twice");
-		*flags = 1;
-		break;
-	default:
-		return 0;
-	}
-	return 1;
-}
-
 static int mark_tg_xlate(struct xt_xlate *xl,
 			 const struct xt_xlate_tg_params *params)
 {
@@ -429,8 +376,9 @@ static struct xtables_target mark_tg_reg[] = {
 		.help          = mark_tg_help,
 		.print         = mark_tg_arp_print,
 		.save          = mark_tg_arp_save,
-		.parse         = mark_tg_arp_parse,
-		.extra_opts    = mark_tg_arp_opts,
+		.x6_parse      = mark_tg_parse,
+		.x6_fcheck     = mark_tg_check,
+		.x6_options    = mark_tg_arp_opts,
 		.xlate	       = mark_tg_xlate,
 	},
 };
-- 
2.41.0

