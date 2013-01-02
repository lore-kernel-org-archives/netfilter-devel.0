From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH] iptables: fix wording in DNPT target
Date: Wed, 2 Jan 2013 17:03:49 +0100
Message-ID: <20130102160349.GB3760@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.sophos.com ([145.253.124.137]:34888 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3ABQDx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:03:53 -0500
Received: from mx1.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id E18085B80A5
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 16:03:51 +0000 (GMT)
Received: from de-wie-exch3b.green.sophos (de-wie-exch3b.green.sophos [10.60.70.62])
	by mx1.sophos.com (Postfix) with ESMTPS id B10665B808C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jan 2013 16:03:51 +0000 (GMT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

replaces SNPT by DNPT

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 extensions/libip6t_DNPT.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/extensions/libip6t_DNPT.c b/extensions/libip6t_DNPT.c
index 9e4dc5c..7439816 100644
--- a/extensions/libip6t_DNPT.c
+++ b/extensions/libip6t_DNPT.c
@@ -8,7 +8,7 @@ enum {
 	O_DST_PFX	= 1 << 1,
 };
 
-static const struct xt_option_entry SNPT_options[] = {
+static const struct xt_option_entry DNPT_options[] = {
 	{ .name = "src-pfx", .id = O_SRC_PFX, .type = XTTYPE_HOSTMASK,
 	  .flags = XTOPT_MAND },
 	{ .name = "dst-pfx", .id = O_DST_PFX, .type = XTTYPE_HOSTMASK,
@@ -16,16 +16,16 @@ static const struct xt_option_entry SNPT_options[] = {
 	{ }
 };
 
-static void SNPT_help(void)
+static void DNPT_help(void)
 {
-	printf("SNPT target options:"
+	printf("DNPT target options:"
 	       "\n"
 	       " --src-pfx prefix/length\n"
 	       " --dst-pfx prefix/length\n"
 	       "\n");
 }
 
-static void SNPT_parse(struct xt_option_call *cb)
+static void DNPT_parse(struct xt_option_call *cb)
 {
 	struct ip6t_npt_tginfo *npt = cb->data;
 
@@ -42,7 +42,7 @@ static void SNPT_parse(struct xt_option_call *cb)
 	}
 }
 
-static void SNPT_print(const void *ip, const struct xt_entry_target *target,
+static void DNPT_print(const void *ip, const struct xt_entry_target *target,
 		       int numeric)
 {
 	const struct ip6t_npt_tginfo *npt = (const void *)target->data;
@@ -59,10 +59,10 @@ static struct xtables_target snpt_tg_reg = {
 	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_npt_tginfo)),
 	.userspacesize	= offsetof(struct ip6t_npt_tginfo, adjustment),
-	.help		= SNPT_help,
-	.x6_parse	= SNPT_parse,
-	.print		= SNPT_print,
-	.x6_options	= SNPT_options,
+	.help		= DNPT_help,
+	.x6_parse	= DNPT_parse,
+	.print		= DNPT_print,
+	.x6_options	= DNPT_options,
 };
 
 void _init(void)
-- 
1.8.0.2

