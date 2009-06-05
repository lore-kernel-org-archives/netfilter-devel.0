From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] NFQUEUE: use NFPROTO_UNSPEC
Date: Fri,  5 Jun 2009 03:17:58 +0200
Message-ID: <1244164679-11032-2-git-send-email-fw@strlen.de>
References: <1244164679-11032-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48522 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204AbZFEBNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:13:09 -0400
In-Reply-To: <1244164679-11032-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also, xtables_strtoui() does the range check for us, no need for binary "&".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_NFQUEUE.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 3ca2239..6939c6f 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -32,12 +32,12 @@ static void
 parse_num(const char *s, struct xt_NFQ_info *tinfo)
 {
 	unsigned int num;
-       
+
 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
 		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid queue number `%s'\n", s);
 
-    	tinfo->queuenum = num & 0xffff;
+	tinfo->queuenum = num;
 }
 
 static int
@@ -78,7 +78,7 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target nfqueue_target = {
-	.family		= NFPROTO_IPV4,
+	.family		= NFPROTO_UNSPEC,
 	.name		= "NFQUEUE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
@@ -90,21 +90,7 @@ static struct xtables_target nfqueue_target = {
 	.extra_opts	= NFQUEUE_opts
 };
 
-static struct xtables_target nfqueue_target6 = {
-	.family		= NFPROTO_IPV6,
-	.name		= "NFQUEUE",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
-	.help		= NFQUEUE_help,
-	.parse		= NFQUEUE_parse,
-	.print		= NFQUEUE_print,
-	.save		= NFQUEUE_save,
-	.extra_opts	= NFQUEUE_opts,
-};
-
 void _init(void)
 {
 	xtables_register_target(&nfqueue_target);
-	xtables_register_target(&nfqueue_target6);
 }
-- 
1.6.0.6

