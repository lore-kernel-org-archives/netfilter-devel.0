From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxt_conntrack: improve error message on parsing violation
Date: Thu,  1 Sep 2011 11:15:49 +0200
Message-ID: <1314868551-4281-3-git-send-email-jengelh@medozas.de>
References: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54861 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab1IAJP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:15:56 -0400
In-Reply-To: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tom Eastep <teastep@shorewall.net>

Tom Eastep noted:

$ iptables -A foo -m conntrack --ctorigdstport 22
iptables v1.4.12: conntrack rev 2 does not support port ranges
Try `iptables -h' or 'iptables --help' for more information.

Commit v1.4.12-41-g1ad6407 takes care of the actual cause of the bug,
but let's include Tom's patch nevertheless for the better error
message in case one actually does specify a range with rev 2.

References: http://marc.info/?l=netfilter-devel&m=131370592105298&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_conntrack.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 060b947..fff69f8 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -129,13 +129,20 @@ static const struct xt_option_entry conntrack2_mt_opts[] = {
 	 .flags = XTOPT_INVERT},
 	{.name = "ctexpire", .id = O_CTEXPIRE, .type = XTTYPE_UINT32RC,
 	 .flags = XTOPT_INVERT},
-	{.name = "ctorigsrcport", .id = O_CTORIGSRCPORT, .type = XTTYPE_PORT,
+	/*
+	 * Rev 1 and 2 only store one port, and we would normally use
+	 * %XTTYPE_PORT (rather than %XTTYPE_PORTRC) for that. The resulting
+	 * error message - in case a user passed a range nevertheless -
+	 * "port 22:23 resolved to nothing" is not quite as useful as using
+	 * %XTTYPE_PORTC and libxt_conntrack's own range test.
+	 */
+	{.name = "ctorigsrcport", .id = O_CTORIGSRCPORT, .type = XTTYPE_PORTRC,
 	 .flags = XTOPT_INVERT | XTOPT_NBO},
-	{.name = "ctorigdstport", .id = O_CTORIGDSTPORT, .type = XTTYPE_PORT,
+	{.name = "ctorigdstport", .id = O_CTORIGDSTPORT, .type = XTTYPE_PORTRC,
 	 .flags = XTOPT_INVERT | XTOPT_NBO},
-	{.name = "ctreplsrcport", .id = O_CTREPLSRCPORT, .type = XTTYPE_PORT,
+	{.name = "ctreplsrcport", .id = O_CTREPLSRCPORT, .type = XTTYPE_PORTRC,
 	 .flags = XTOPT_INVERT | XTOPT_NBO},
-	{.name = "ctrepldstport", .id = O_CTREPLDSTPORT, .type = XTTYPE_PORT,
+	{.name = "ctrepldstport", .id = O_CTREPLDSTPORT, .type = XTTYPE_PORTRC,
 	 .flags = XTOPT_INVERT | XTOPT_NBO},
 	{.name = "ctdir", .id = O_CTDIR, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
-- 
1.7.3.4

