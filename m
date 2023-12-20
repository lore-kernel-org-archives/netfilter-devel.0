Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83586482F7
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DyszJnMo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=smjp3aVxl5EAHlTdvm7FffAiKCN5wUaR96AnSm8jb6s=; b=DyszJnMovRGeyfR7UGviFw3Ln0
	U2azJojH62Vg+XlFAwpgcdiy0FBHvcNlxQB1oHFUVLkDI/EKEiU7x6ewubbplFiLpOQpGGX+TBzxo
	OMFA6hASXZyYQzcYYVIYtTEq4UZFClXAzlNrwGzqixZQMnqic4l6hD1dagfCLt8dN3WkTL+hlaLTx
	tT0Rd1SvmlPiz9DuvEgll7aQnycGY1w1ezTtWYhDfKj2sGTvZYNkZmXlzK2FK0ITHFYMZpj7mpSDT
	EztlYM9uNeGN63LXnk7LTQUZ63dCkKQiZ4tojuYENWfPhRyA79LfD9J5FmdyJdabnsQwjUgv0Mofh
	8bJOKFgA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5p-0004LN-Le
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:45 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 20/23] extensions: libxt_limit: Use guided option parser for NFPROTO_BRIDGE, too
Date: Wed, 20 Dec 2023 17:06:33 +0100
Message-ID: <20231220160636.11778-21-phil@nwl.cc>
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
 extensions/libxt_limit.c | 50 ++--------------------------------------
 1 file changed, 2 insertions(+), 48 deletions(-)

diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index e6ec67f302688..63f3289d82c22 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -7,7 +7,6 @@
 #define _DEFAULT_SOURCE 1
 #define _ISOC99_SOURCE 1
 #include <errno.h>
-#include <getopt.h>
 #include <math.h>
 #include <stdio.h>
 #include <string.h>
@@ -202,44 +201,6 @@ static int limit_xlate_eb(struct xt_xlate *xl,
 	return 1;
 }
 
-#define FLAG_LIMIT		0x01
-#define FLAG_LIMIT_BURST	0x02
-#define ARG_LIMIT		'1'
-#define ARG_LIMIT_BURST		'2'
-
-static int brlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_match **match)
-{
-	struct xt_rateinfo *r = (struct xt_rateinfo *)(*match)->data;
-	uintmax_t num;
-
-	switch (c) {
-	case ARG_LIMIT:
-		EBT_CHECK_OPTION(flags, FLAG_LIMIT);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unexpected `!' after --limit");
-		if (!parse_rate(optarg, &r->avg))
-			xtables_error(PARAMETER_PROBLEM,
-				      "bad rate `%s'", optarg);
-		break;
-	case ARG_LIMIT_BURST:
-		EBT_CHECK_OPTION(flags, FLAG_LIMIT_BURST);
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unexpected `!' after --limit-burst");
-		if (!xtables_strtoul(optarg, NULL, &num, 0, 10000))
-			xtables_error(PARAMETER_PROBLEM,
-				      "bad --limit-burst `%s'", optarg);
-		r->burst = num;
-		break;
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
 static void brlimit_print(const void *ip, const struct xt_entry_match *match,
 			  int numeric)
 {
@@ -250,13 +211,6 @@ static void brlimit_print(const void *ip, const struct xt_entry_match *match,
 	printf(" --limit-burst %u ", r->burst);
 }
 
-static const struct option brlimit_opts[] =
-{
-	{ .name = "limit",	.has_arg = true,	.val = ARG_LIMIT },
-	{ .name = "limit-burst",.has_arg = true,	.val = ARG_LIMIT_BURST },
-	XT_GETOPT_TABLEEND,
-};
-
 static struct xtables_match limit_match[] = {
 	{
 		.family		= NFPROTO_UNSPEC,
@@ -280,9 +234,9 @@ static struct xtables_match limit_match[] = {
 		.userspacesize	= offsetof(struct xt_rateinfo, prev),
 		.help		= limit_help,
 		.init		= limit_init,
-		.parse		= brlimit_parse,
+		.x6_parse	= limit_parse,
 		.print		= brlimit_print,
-		.extra_opts	= brlimit_opts,
+		.x6_options	= limit_opts,
 		.xlate		= limit_xlate_eb,
 	},
 };
-- 
2.43.0

