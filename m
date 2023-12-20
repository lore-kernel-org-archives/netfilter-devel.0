Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EFB482C6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VjdJNWgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BVV1gTaSldI5eTFXe6NDSJmEtWQVavql3cuw/Z1p2zs=; b=VjdJNWgGbEz8EUhABJCLNJzIE8
	Ubwc/mVbMdhBHjOb1JzpQ3iagBNpmUDc880Csj1CeNehTfInefWAqxbm3jJfBe9zJdnXWuLPdOEeS
	+YunQs5bXJW6K3/N74eDqH+6EWdj6ZSG1ZhrhVWpjU0qLaRs6V5oYVorerqmwS/wcs2nIIaSA4zjZ
	ez2FPRcf++WOKXMvpGn0CaThWQHN+j6odUxtK4SGhB8JCqUVBVfWa8h+prPy4+YmPO7SZMtMD4mtM
	wkIwZeB5Sh9gKrcYVQ8JdPFi8QYViAONae1it1cWkwuPeawwGU4XHvlqhnaYceIbyyqSd6MVs2MlB
	njn/5+5Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5l-0004Ke-Pp
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/23] extensions: libebt_log: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:25 +0100
Message-ID: <20231220160636.11778-13-phil@nwl.cc>
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
 extensions/libebt_log.c | 121 ++++++++++------------------------------
 1 file changed, 30 insertions(+), 91 deletions(-)

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 9f8d158956802..dc2357c022bf0 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -14,19 +14,11 @@
 #include <stdlib.h>
 #include <syslog.h>
 #include <string.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_log.h>
 
 #define LOG_DEFAULT_LEVEL LOG_INFO
 
-#define LOG_PREFIX '1'
-#define LOG_LEVEL  '2'
-#define LOG_ARP    '3'
-#define LOG_IP     '4'
-#define LOG_LOG    '5'
-#define LOG_IP6    '6'
-
 struct code {
 	char *c_name;
 	int c_val;
@@ -43,26 +35,26 @@ static struct code eight_priority[] = {
 	{ "debug", LOG_DEBUG }
 };
 
-static int name_to_loglevel(const char *arg)
-{
-	int i;
-
-	for (i = 0; i < 8; i++)
-		if (!strcmp(arg, eight_priority[i].c_name))
-			return eight_priority[i].c_val;
-
-	/* return bad loglevel */
-	return 9;
-}
+enum {
+	/* first three must correspond with bit pos in respective EBT_LOG_* */
+	O_LOG_IP = 0,
+	O_LOG_ARP = 1,
+	O_LOG_IP6 = 3,
+	O_LOG_PREFIX,
+	O_LOG_LEVEL,
+	O_LOG_LOG,
+};
 
-static const struct option brlog_opts[] = {
-	{ .name = "log-prefix",		.has_arg = true,  .val = LOG_PREFIX },
-	{ .name = "log-level",		.has_arg = true,  .val = LOG_LEVEL  },
-	{ .name = "log-arp",		.has_arg = false, .val = LOG_ARP    },
-	{ .name = "log-ip",		.has_arg = false, .val = LOG_IP     },
-	{ .name = "log",		.has_arg = false, .val = LOG_LOG    },
-	{ .name = "log-ip6",		.has_arg = false, .val = LOG_IP6    },
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry brlog_opts[] = {
+	{ .name = "log-prefix", .id = O_LOG_PREFIX, .type = XTTYPE_STRING,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_log_info, prefix) },
+	{ .name = "log-level", .id = O_LOG_LEVEL, .type = XTTYPE_SYSLOGLEVEL,
+	  .flags = XTOPT_PUT, XTOPT_POINTER(struct ebt_log_info, loglevel) },
+	{ .name = "log-arp",	.id = O_LOG_ARP,	.type = XTTYPE_NONE },
+	{ .name = "log-ip",	.id = O_LOG_IP,		.type = XTTYPE_NONE },
+	{ .name = "log",	.id = O_LOG_LOG,	.type = XTTYPE_NONE },
+	{ .name = "log-ip6",	.id = O_LOG_IP6,	.type = XTTYPE_NONE },
+	XTOPT_TABLEEND,
 };
 
 static void brlog_help(void)
@@ -87,73 +79,21 @@ static void brlog_init(struct xt_entry_target *t)
 {
 	struct ebt_log_info *loginfo = (struct ebt_log_info *)t->data;
 
-	loginfo->bitmask = 0;
-	loginfo->prefix[0] = '\0';
 	loginfo->loglevel = LOG_NOTICE;
 }
 
-static unsigned int log_chk_inv(int inv, unsigned int bit, const char *suffix)
-{
-	if (inv)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Unexpected `!' after --log%s", suffix);
-	return bit;
-}
-
-static int brlog_parse(int c, char **argv, int invert, unsigned int *flags,
-		       const void *entry, struct xt_entry_target **target)
+static void brlog_parse(struct xt_option_call *cb)
 {
-	struct ebt_log_info *loginfo = (struct ebt_log_info *)(*target)->data;
-	long int i;
-	char *end;
-
-	switch (c) {
-	case LOG_PREFIX:
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Unexpected `!` after --log-prefix");
-		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Prefix too long");
-		if (strchr(optarg, '\"'))
-			xtables_error(PARAMETER_PROBLEM,
-				      "Use of \\\" is not allowed"
-				      " in the prefix");
-		strcpy((char *)loginfo->prefix, (char *)optarg);
+	struct ebt_log_info *loginfo = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_LOG_IP:
+	case O_LOG_ARP:
+	case O_LOG_IP6:
+		loginfo->bitmask |= 1 << cb->entry->id;
 		break;
-	case LOG_LEVEL:
-		i = strtol(optarg, &end, 16);
-		if (*end != '\0' || i < 0 || i > 7)
-			loginfo->loglevel = name_to_loglevel(optarg);
-		else
-			loginfo->loglevel = i;
-
-		if (loginfo->loglevel == 9)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with the log-level");
-		break;
-	case LOG_IP:
-		loginfo->bitmask |= log_chk_inv(invert, EBT_LOG_IP, "-ip");
-		break;
-	case LOG_ARP:
-		loginfo->bitmask |= log_chk_inv(invert, EBT_LOG_ARP, "-arp");
-		break;
-	case LOG_LOG:
-		loginfo->bitmask |= log_chk_inv(invert, 0, "");
-		break;
-	case LOG_IP6:
-		loginfo->bitmask |= log_chk_inv(invert, EBT_LOG_IP6, "-ip6");
-		break;
-	default:
-		return 0;
 	}
-
-	*flags |= loginfo->bitmask;
-	return 1;
-}
-
-static void brlog_final_check(unsigned int flags)
-{
 }
 
 static void brlog_print(const void *ip, const struct xt_entry_target *target,
@@ -204,11 +144,10 @@ static struct xtables_target brlog_target = {
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_log_info)),
 	.init		= brlog_init,
 	.help		= brlog_help,
-	.parse		= brlog_parse,
-	.final_check	= brlog_final_check,
+	.x6_parse	= brlog_parse,
 	.print		= brlog_print,
 	.xlate		= brlog_xlate,
-	.extra_opts	= brlog_opts,
+	.x6_options	= brlog_opts,
 };
 
 void _init(void)
-- 
2.43.0

