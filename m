From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] netfilter: xtables: print details on size mismatch
Date: Wed, 10 Feb 2010 18:39:04 +0100
Message-ID: <1265823547-10358-5-git-send-email-jengelh@medozas.de>
References: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57305 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0BJRjS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:39:18 -0500
In-Reply-To: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Print which revision has been used and which size are which
(kernel/user) for easier debugging.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index dc2e05c..760ea3e 100644
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
1.6.6.1

