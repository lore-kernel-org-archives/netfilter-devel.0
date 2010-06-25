From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] libxt_hashlimit: always print burst value
Date: Fri, 25 Jun 2010 14:45:40 +0200
Message-ID: <1277469942-26270-2-git-send-email-jengelh@medozas.de>
References: <1277469942-26270-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58080 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab0FYMpq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:45:46 -0400
In-Reply-To: <1277469942-26270-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables -L lists the burst value, and so should iptables -S. I was
certainly surprised to see it gone even when explicitly specifying
--hashlimit-burst 5 on the command line.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index a8fe588..7442dfc 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -591,8 +591,7 @@ static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_hashlimit_info *r = (const void *)match->data;
 
 	fputs("--hashlimit ", stdout); print_rate(r->cfg.avg);
-	if (r->cfg.burst != XT_HASHLIMIT_BURST)
-		printf("--hashlimit-burst %u ", r->cfg.burst);
+	printf("--hashlimit-burst %u ", r->cfg.burst);
 
 	fputs("--hashlimit-mode ", stdout);
 	print_mode(r->cfg.mode, ',');
@@ -617,8 +616,7 @@ hashlimit_mt_save(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 	else
 		fputs("--hashlimit-upto ", stdout);
 	print_rate(info->cfg.avg);
-	if (info->cfg.burst != XT_HASHLIMIT_BURST)
-		printf("--hashlimit-burst %u ", info->cfg.burst);
+	printf("--hashlimit-burst %u ", info->cfg.burst);
 
 	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
 	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
-- 
1.7.1

