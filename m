From: Jan Engelhardt <jengelh@medozas.de>
Subject: physdev: remove extra space in output
Date: Wed, 6 Aug 2008 17:32:19 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808061732050.3527@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56325 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYHFVcV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:32:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 99f9a7790de1f94d0d8a46c5699f2beb32ac193e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Aug 6 17:31:08 2008 -0400

physdev: remove extra space in output

Just a cosmetic fix for `iptables -S` and `iptables-save` printing
two spaces between arguments in the physdev match.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_physdev.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 34547c8..0a937ea 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -143,22 +143,23 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 		(struct xt_physdev_info*)match->data;
 
 	if (info->bitmask & XT_PHYSDEV_OP_ISIN)
-		printf("%s --physdev-is-in",
-		       info->invert & XT_PHYSDEV_OP_ISIN ? " !":"");
+		printf("%s--physdev-is-in ",
+		       (info->invert & XT_PHYSDEV_OP_ISIN) ? "! " : "");
 	if (info->bitmask & XT_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
-		(info->invert & XT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
+		printf("%s--physdev-in %s ",
+		       (info->invert & XT_PHYSDEV_OP_IN) ? "! " : "",
+		       info->physindev);
 
 	if (info->bitmask & XT_PHYSDEV_OP_ISOUT)
-		printf("%s --physdev-is-out",
-		       info->invert & XT_PHYSDEV_OP_ISOUT ? " !":"");
+		printf("%s--physdev-is-out ",
+		       (info->invert & XT_PHYSDEV_OP_ISOUT) ? "! " : "");
 	if (info->bitmask & XT_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
-		(info->invert & XT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
+		printf("%s--physdev-out %s ",
+		       (info->invert & XT_PHYSDEV_OP_OUT) ? "! " : "",
+		       info->physoutdev);
 	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
-		printf("%s --physdev-is-bridged",
-		       info->invert & XT_PHYSDEV_OP_BRIDGED ? " !":"");
-	printf(" ");
+		printf("%s--physdev-is-bridged ",
+		       (info->invert & XT_PHYSDEV_OP_BRIDGED) ? "! " : "");
 }
 
 static struct xtables_match physdev_match = {

