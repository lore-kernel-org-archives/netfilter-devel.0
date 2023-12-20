Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF0C482CE
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NLCsfW4/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oEHVrkdD+y9jdXZtthq4uKjaPjUliPLOS9lCHROU0Do=; b=NLCsfW4/QeP6y2awraMyQVn65k
	aX3rFxMUCStj0Xsbdbtl+QYicSioJrcJxd8cm02POWJrKMptI2k7vSQPG4OGmU6EkhWdBS3/VCC4w
	Nhtl/Imji1+/uPsCq5lvCGMvuF2/ibNhSeDMvybd7vXd0BUmFn+sZvFh1FmEE1z1Ep0VX8nHjkAR0
	3TW+LV6vcz7AmF0SmmT8cVOpgaC4XyQ9eQKt/gyTzQZHl9Zgb0eRPYVxI120MWwK1OCSZfkvIhq/M
	CAX6sQaa6L8vSvHAPXm/QVh7Aao7NVYo1Ay88wyQQqlkh8GqCy5BLq6w0YLZa8QnLadK/yNmypunU
	/d3L2fUw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5l-0004Ka-FP
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 14/23] extensions: libebt_nflog: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:27 +0100
Message-ID: <20231220160636.11778-15-phil@nwl.cc>
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
 extensions/libebt_nflog.c | 82 +++++++++------------------------------
 1 file changed, 18 insertions(+), 64 deletions(-)

diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index 762d6d5d8bbe2..48cd53218bf08 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -16,27 +16,30 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
 #include "iptables/nft.h"
 #include "iptables/nft-bridge.h"
 #include <linux/netfilter_bridge/ebt_nflog.h>
 
 enum {
-	NFLOG_GROUP	= 0x1,
-	NFLOG_PREFIX	= 0x2,
-	NFLOG_RANGE	= 0x4,
-	NFLOG_THRESHOLD	= 0x8,
-	NFLOG_NFLOG	= 0x16,
+	O_GROUP	= 0,
+	O_PREFIX,
+	O_RANGE,
+	O_THRESHOLD,
+	O_NFLOG,
 };
 
-static const struct option brnflog_opts[] = {
-	{ .name = "nflog-group",     .has_arg = true,  .val = NFLOG_GROUP},
-	{ .name = "nflog-prefix",    .has_arg = true,  .val = NFLOG_PREFIX},
-	{ .name = "nflog-range",     .has_arg = true,  .val = NFLOG_RANGE},
-	{ .name = "nflog-threshold", .has_arg = true,  .val = NFLOG_THRESHOLD},
-	{ .name = "nflog",           .has_arg = false, .val = NFLOG_NFLOG},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brnflog_opts[] = {
+	{ .name = "nflog-group",     .id = O_GROUP, .type = XTTYPE_UINT16,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nflog_info, group) },
+	{ .name = "nflog-prefix",    .id = O_PREFIX, .type = XTTYPE_STRING,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nflog_info, prefix) },
+	{ .name = "nflog-range",     .id = O_RANGE, .type = XTTYPE_UINT32,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nflog_info, len) },
+	{ .name = "nflog-threshold", .id = O_THRESHOLD, .type = XTTYPE_UINT16,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_nflog_info, threshold) },
+	{ .name = "nflog",           .id = O_NFLOG, .type = XTTYPE_NONE },
+	XTOPT_TABLEEND,
 };
 
 static void brnflog_help(void)
@@ -59,55 +62,6 @@ static void brnflog_init(struct xt_entry_target *t)
 	info->threshold = EBT_NFLOG_DEFAULT_THRESHOLD;
 }
 
-static int brnflog_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_target **target)
-{
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)(*target)->data;
-	unsigned int i;
-
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM,
-			      "The use of '!' makes no sense for the"
-			      " nflog watcher");
-
-	switch (c) {
-	case NFLOG_PREFIX:
-		EBT_CHECK_OPTION(flags, NFLOG_PREFIX);
-		if (strlen(optarg) > EBT_NFLOG_PREFIX_SIZE - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Prefix too long for nflog-prefix");
-		strncpy(info->prefix, optarg, EBT_NFLOG_PREFIX_SIZE);
-		break;
-	case NFLOG_GROUP:
-		EBT_CHECK_OPTION(flags, NFLOG_GROUP);
-		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				      "--nflog-group must be a number!");
-		info->group = i;
-		break;
-	case NFLOG_RANGE:
-		EBT_CHECK_OPTION(flags, NFLOG_RANGE);
-		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				      "--nflog-range must be a number!");
-		info->len = i;
-		break;
-	case NFLOG_THRESHOLD:
-		EBT_CHECK_OPTION(flags, NFLOG_THRESHOLD);
-		if (!xtables_strtoui(optarg, NULL, &i, 1, UINT32_MAX))
-			xtables_error(PARAMETER_PROBLEM,
-				      "--nflog-threshold must be a number!");
-		info->threshold = i;
-		break;
-	case NFLOG_NFLOG:
-		EBT_CHECK_OPTION(flags, NFLOG_NFLOG);
-		break;
-	default:
-		return 0;
-	}
-	return 1;
-}
-
 static void
 brnflog_print(const void *ip, const struct xt_entry_target *target,
 	      int numeric)
@@ -153,10 +107,10 @@ static struct xtables_target brnflog_watcher = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_nflog_info)),
 	.init		= brnflog_init,
 	.help		= brnflog_help,
-	.parse		= brnflog_parse,
+	.x6_parse	= xtables_option_parse,
 	.print		= brnflog_print,
 	.xlate		= brnflog_xlate,
-	.extra_opts	= brnflog_opts,
+	.x6_options	= brnflog_opts,
 };
 
 void _init(void)
-- 
2.43.0

