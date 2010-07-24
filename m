From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH iptables] libxt_quota: don't ignore the quota value on deletion
Date: Sat, 24 Jul 2010 12:30:44 +0800
Message-ID: <1279945844-24068-1-git-send-email-xiaosuo@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0GXEbC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 00:31:02 -0400
Received: by pwi5 with SMTP id 5so3784743pwi.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 21:31:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

don't ignore the quota value on deletion, then we can remove a special rule
everytime.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 extensions/libxt_quota.c           |    2 +-
 include/linux/netfilter/xt_quota.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index ac7c686..8e28e4c 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -82,7 +82,7 @@ static struct xtables_match quota_match = {
 	.name		= "quota",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
-	.userspacesize	= offsetof(struct xt_quota_info, quota),
+	.userspacesize	= offsetof(struct xt_quota_info, master),
 	.help		= quota_help,
 	.parse		= quota_parse,
 	.print		= quota_print,
diff --git a/include/linux/netfilter/xt_quota.h b/include/linux/netfilter/xt_quota.h
index 8dc89df..b0d28c6 100644
--- a/include/linux/netfilter/xt_quota.h
+++ b/include/linux/netfilter/xt_quota.h
@@ -11,9 +11,9 @@ struct xt_quota_priv;
 struct xt_quota_info {
 	u_int32_t		flags;
 	u_int32_t		pad;
+	aligned_u64		quota;
 
 	/* Used internally by the kernel */
-	aligned_u64		quota;
 	struct xt_quota_priv	*master;
 };
 
