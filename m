From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/21] libxt_conntrack: remove one misleading comment
Date: Sun, 21 Aug 2011 13:09:17 +0200
Message-ID: <1313924977-8623-3-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38722 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab1HULJl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:41 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 8e1777e..a401125 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -143,8 +143,8 @@ static const struct xt_option_entry conntrack2_mt_opts[] = {
 };
 #undef s
 
-#define s struct xt_conntrack_mtinfo3 /* for v1-v3 */
-/* We exploit the fact that v1-v3 share the same layout */
+#define s struct xt_conntrack_mtinfo3
+/* Difference from v2 is the non-NBO form. */
 static const struct xt_option_entry conntrack3_mt_opts[] = {
 	{.name = "ctstate", .id = O_CTSTATE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
-- 
1.7.3.4

