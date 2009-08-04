From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 030/103] netfilter: xtables: print details on size mismatch
Date: Tue,  4 Aug 2009 09:25:14 +0200
Message-ID: <1249370787-17583-31-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50627 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558AbZHDH1G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:06 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print which revision has been used and which size are which
(kernel/user) for easier debugging.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index eff972f..ff4bd71 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -366,8 +366,10 @@ int xt_check_match(struct xt_mtchk_param *par,
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
 		 */
-		pr_err("%s_tables: %s match: invalid size %Zu != %u\n",
+		pr_err("%s_tables: %s.%u match: invalid size "
+		       "(kernel) %zu != (user) %u\n",
 		       xt_prefix[par->family], par->match->name,
+		       par->match->revision,
 		       XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
 	}
@@ -516,8 +518,10 @@ int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
 	if (XT_ALIGN(par->target->targetsize) != size) {
-		pr_err("%s_tables: %s target: invalid size %Zu != %u\n",
+		pr_err("%s_tables: %s.%u target: invalid size "
+		       "(kernel) %zu != (user) %u\n",
 		       xt_prefix[par->family], par->target->name,
+		       par->target->revision,
 		       XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
 	}
-- 
1.6.3.3

