Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602D8482CB
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aXpaX0kG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FuMlcvhfpwLq3DTD1TvMxPiZLDqGk0kn5qjhuTGPDB4=; b=aXpaX0kGKf5MWUnZMtEIR81Xdf
	eoyCqU8ve72yFXr+dK8UG0TwYJPLLzmSMVIMhDVFo66+K85YiGiDZGvzGHhOlg6gbjcZ5AM07Uoyh
	JfUdwUcp7xV7voW/C2oKuOKay5QdV1aPqoHOT7CRupqwWqs+e4wSm+ZiyFyLjrGJzK66LIorAOIgs
	wghxbkhr62OshVS828bt804dWuiemfU1K0nD6w6UT47zqqjp4zCR39m9oOsZetRkbDgaZY8WeWaOZ
	IWKuQnWH6h7tZF6sF8wyDDs81rd1udIDx6VxzzWhdbpuGpcaCNM/7Nratn8ReAsr+EoUQX4d2e9r8
	GzhCjSTw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5k-0004KA-BA
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 13/23] extensions: libebt_mark: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:26 +0100
Message-ID: <20231220160636.11778-14-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_mark.c | 140 +++++++++++++++------------------------
 1 file changed, 54 insertions(+), 86 deletions(-)

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index 40e49618e0215..0dc598fe1009d 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -12,27 +12,39 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_mark_t.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 
-#define MARK_TARGET  '1'
-#define MARK_SETMARK '2'
-#define MARK_ORMARK  '3'
-#define MARK_ANDMARK '4'
-#define MARK_XORMARK '5'
-static const struct option brmark_opts[] = {
-	{ .name = "mark-target",.has_arg = true,	.val = MARK_TARGET },
+enum {
+	O_SET_MARK = 0,
+	O_AND_MARK,
+	O_OR_MARK,
+	O_XOR_MARK,
+	O_MARK_TARGET,
+	F_SET_MARK  = 1 << O_SET_MARK,
+	F_AND_MARK  = 1 << O_AND_MARK,
+	F_OR_MARK   = 1 << O_OR_MARK,
+	F_XOR_MARK  = 1 << O_XOR_MARK,
+	F_ANY       = F_SET_MARK | F_AND_MARK | F_OR_MARK | F_XOR_MARK,
+};
+
+static const struct xt_option_entry brmark_opts[] = {
+	{ .name = "mark-target",.id = O_MARK_TARGET, .type = XTTYPE_STRING },
 	/* an oldtime messup, we should have always used the scheme
 	 * <extension-name>-<option> */
-	{ .name = "set-mark",	.has_arg = true,	.val = MARK_SETMARK },
-	{ .name = "mark-set",	.has_arg = true,	.val = MARK_SETMARK },
-	{ .name = "mark-or",	.has_arg = true,	.val = MARK_ORMARK },
-	{ .name = "mark-and",	.has_arg = true,	.val = MARK_ANDMARK },
-	{ .name = "mark-xor",	.has_arg = true,	.val = MARK_XORMARK },
-	XT_GETOPT_TABLEEND,
+	{ .name = "set-mark",	.id = O_SET_MARK, .type = XTTYPE_UINT32,
+	  .excl = F_ANY },
+	{ .name = "mark-set",	.id = O_SET_MARK, .type = XTTYPE_UINT32,
+	  .excl = F_ANY },
+	{ .name = "mark-or",	.id = O_OR_MARK, .type = XTTYPE_UINT32,
+	  .excl = F_ANY },
+	{ .name = "mark-and",	.id = O_AND_MARK, .type = XTTYPE_UINT32,
+	  .excl = F_ANY },
+	{ .name = "mark-xor",	.id = O_XOR_MARK, .type = XTTYPE_UINT32,
+	  .excl = F_ANY },
+	XTOPT_TABLEEND,
 };
 
 static void brmark_print_help(void)
@@ -54,83 +66,39 @@ static void brmark_init(struct xt_entry_target *target)
 	info->mark = 0;
 }
 
-#define OPT_MARK_TARGET   0x01
-#define OPT_MARK_SETMARK  0x02
-#define OPT_MARK_ORMARK   0x04
-#define OPT_MARK_ANDMARK  0x08
-#define OPT_MARK_XORMARK  0x10
-
-static int
-brmark_parse(int c, char **argv, int invert, unsigned int *flags,
-	     const void *entry, struct xt_entry_target **target)
+static void brmark_parse(struct xt_option_call *cb)
 {
-	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)
-				       (*target)->data;
-	char *end;
-	uint32_t mask;
-
-	switch (c) {
-	case MARK_TARGET:
-		{ unsigned int tmp;
-		EBT_CHECK_OPTION(flags, OPT_MARK_TARGET);
-		if (ebt_fill_target(optarg, &tmp))
+	static const unsigned long target_orval[] = {
+		[O_SET_MARK]	= MARK_SET_VALUE,
+		[O_AND_MARK]	= MARK_AND_VALUE,
+		[O_OR_MARK]	= MARK_OR_VALUE,
+		[O_XOR_MARK]	= MARK_XOR_VALUE,
+	};
+	struct ebt_mark_t_info *info = cb->data;
+	unsigned int tmp;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_MARK_TARGET:
+		if (ebt_fill_target(cb->arg, &tmp))
 			xtables_error(PARAMETER_PROBLEM,
 				      "Illegal --mark-target target");
 		/* the 4 lsb are left to designate the target */
 		info->target = (info->target & ~EBT_VERDICT_BITS) |
 			       (tmp & EBT_VERDICT_BITS);
-		}
-		return 1;
-	case MARK_SETMARK:
-		EBT_CHECK_OPTION(flags, OPT_MARK_SETMARK);
-		mask = (OPT_MARK_ORMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
-		if (*flags & mask)
-			xtables_error(PARAMETER_PROBLEM,
-				      "--mark-set cannot be used together with"
-				      " specific --mark option");
-		info->target = (info->target & EBT_VERDICT_BITS) |
-			       MARK_SET_VALUE;
-		break;
-	case MARK_ORMARK:
-		EBT_CHECK_OPTION(flags, OPT_MARK_ORMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_XORMARK);
-		if (*flags & mask)
-			xtables_error(PARAMETER_PROBLEM,
-				      "--mark-or cannot be used together with"
-				      " specific --mark option");
-		info->target = (info->target & EBT_VERDICT_BITS) |
-			       MARK_OR_VALUE;
-		break;
-	case MARK_ANDMARK:
-		EBT_CHECK_OPTION(flags, OPT_MARK_ANDMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ORMARK|OPT_MARK_XORMARK);
-		if (*flags & mask)
-			xtables_error(PARAMETER_PROBLEM,
-				      "--mark-and cannot be used together with"
-				      " specific --mark option");
-		info->target = (info->target & EBT_VERDICT_BITS) |
-			       MARK_AND_VALUE;
-		break;
-	case MARK_XORMARK:
-		EBT_CHECK_OPTION(flags, OPT_MARK_XORMARK);
-		mask = (OPT_MARK_SETMARK|OPT_MARK_ANDMARK|OPT_MARK_ORMARK);
-		if (*flags & mask)
-			xtables_error(PARAMETER_PROBLEM,
-				      "--mark-xor cannot be used together with"
-				      " specific --mark option");
-		info->target = (info->target & EBT_VERDICT_BITS) |
-			       MARK_XOR_VALUE;
+		return;
+	case O_SET_MARK:
+	case O_OR_MARK:
+	case O_AND_MARK:
+	case O_XOR_MARK:
 		break;
 	default:
-		return 0;
+		return;
 	}
 	/* mutual code */
-	info->mark = strtoul(optarg, &end, 0);
-	if (*end != '\0' || end == optarg)
-		xtables_error(PARAMETER_PROBLEM, "Bad MARK value '%s'",
-			      optarg);
-
-	return 1;
+	info->mark = cb->val.u32;
+	info->target = (info->target & EBT_VERDICT_BITS) |
+		       target_orval[cb->entry->id];
 }
 
 static void brmark_print(const void *ip, const struct xt_entry_target *target,
@@ -156,9 +124,9 @@ static void brmark_print(const void *ip, const struct xt_entry_target *target,
 	printf(" --mark-target %s", ebt_target_name(tmp));
 }
 
-static void brmark_final_check(unsigned int flags)
+static void brmark_final_check(struct xt_fcheck_call *fc)
 {
-	if (!flags)
+	if (!fc->xflags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify some option");
 }
@@ -215,11 +183,11 @@ static struct xtables_target brmark_target = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_mark_t_info)),
 	.help		= brmark_print_help,
 	.init		= brmark_init,
-	.parse		= brmark_parse,
-	.final_check	= brmark_final_check,
+	.x6_parse	= brmark_parse,
+	.x6_fcheck	= brmark_final_check,
 	.print		= brmark_print,
 	.xlate		= brmark_xlate,
-	.extra_opts	= brmark_opts,
+	.x6_options	= brmark_opts,
 };
 
 void _init(void)
-- 
2.43.0

