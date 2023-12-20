Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD56482D0
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UYs9Lf6w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XPJ821BGacYNH2dzfdvFA1O6s8hhpn6PWwTX3ugZlDA=; b=UYs9Lf6w1CLyDL+TAuR/Tgn5p9
	i3Ntz1wsMSlZgZZz3g+UbNVljsFDQhfRVJbXkfk3EmjtkJ0UeMwjvWkgk5PMtz2PBR6F+btXsfJpF
	uTNnoix5I9bIrmHH8ExYxwuh86t+HYpzDTFvs2Gcyql2OQuXXNy5Tf1YADA0SLgeBZ/mI4IRh8YM2
	6QLe1avfjCgdhU+IPEFxU+uOPXhnLtb+a0XlA3GjB+2urLcbdr88D0KDOlLGf4IvfAGncq8xNZV5Z
	Pn4TrcIL3wo6TLiElShYKKJYKP33qI4GHhgY+vEcAoo56yHLWjimeoqHXpoyoXXuAH6Rr3miUa9ls
	gZpDcAfQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5o-0004L9-Kg
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 22/23] extensions: libebt_mark_m: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:35 +0100
Message-ID: <20231220160636.11778-23-phil@nwl.cc>
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

Can't use XTTYPE_MARKMASK32 here because in 'val/mask', 'val' is
optional. Would have to extend xtopt_parse_markmask() to accept this,
maybe guarded by a new XTOPT_ flag to avoid unexpected changes in
behaviour?

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_mark_m.c | 58 +++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index 178c9ecef94da..f17fe99ab18ef 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -12,15 +12,17 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
-#define MARK '1'
+enum {
+	O_MARK = 0,
+};
 
-static const struct option brmark_m_opts[] = {
-	{ .name = "mark",	.has_arg = true, .val = MARK },
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brmark_m_opts[] = {
+	{ .name = "mark", .id = O_MARK, .type = XTTYPE_STRING,
+	  .flags = XTOPT_INVERT | XTOPT_MAND },
+	XTOPT_TABLEEND,
 };
 
 static void brmark_m_print_help(void)
@@ -30,45 +32,30 @@ static void brmark_m_print_help(void)
 "--mark    [!] [value][/mask]: Match nfmask value (see man page)\n");
 }
 
-#define OPT_MARK 0x01
-static int
-brmark_m_parse(int c, char **argv, int invert, unsigned int *flags,
-	       const void *entry, struct xt_entry_match **match)
+static void brmark_m_parse(struct xt_option_call *cb)
 {
-	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)
-				       (*match)->data;
+	struct ebt_mark_m_info *info = cb->data;
 	char *end;
 
-	switch (c) {
-	case MARK:
-		if (invert)
-			info->invert = 1;
-		info->mark = strtoul(optarg, &end, 0);
+	xtables_option_parse(cb);
+
+	switch (cb->entry->id) {
+	case O_MARK:
+		info->invert = cb->invert;
+		info->mark = strtoul(cb->arg, &end, 0);
 		info->bitmask = EBT_MARK_AND;
 		if (*end == '/') {
-			if (end == optarg)
+			if (end == cb->arg)
 				info->bitmask = EBT_MARK_OR;
 			info->mask = strtoul(end+1, &end, 0);
 		} else {
-			info->mask = 0xffffffff;
+			info->mask = UINT32_MAX;
 		}
-		if (*end != '\0' || end == optarg)
+		if (*end != '\0' || end == cb->arg)
 			xtables_error(PARAMETER_PROBLEM, "Bad mark value '%s'",
-				      optarg);
+				      cb->arg);
 		break;
-	default:
-		return 0;
 	}
-
-	*flags |= info->bitmask;
-	return 1;
-}
-
-static void brmark_m_final_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			      "You must specify proper arguments");
 }
 
 static void brmark_m_print(const void *ip, const struct xt_entry_match *match,
@@ -101,7 +88,7 @@ static int brmark_m_xlate(struct xt_xlate *xl,
 	if (info->bitmask == EBT_MARK_OR) {
 		xt_xlate_add(xl, "and 0x%x %s0 ", (uint32_t)info->mask,
 			     info->invert ? "" : "!= ");
-	} else if (info->mask != 0xffffffffU) {
+	} else if (info->mask != UINT32_MAX) {
 		xt_xlate_add(xl, "and 0x%x %s0x%x ", (uint32_t)info->mask,
 			   op == XT_OP_EQ ? "" : "!= ", (uint32_t)info->mark);
 	} else {
@@ -119,11 +106,10 @@ static struct xtables_match brmark_m_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_mark_m_info)),
 	.help		= brmark_m_print_help,
-	.parse		= brmark_m_parse,
-	.final_check	= brmark_m_final_check,
+	.x6_parse	= brmark_m_parse,
 	.print		= brmark_m_print,
 	.xlate		= brmark_m_xlate,
-	.extra_opts	= brmark_m_opts,
+	.x6_options	= brmark_m_opts,
 };
 
 void _init(void)
-- 
2.43.0

