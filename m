From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/56] netfilter: ebtables: simplify a device in/out check
Date: Tue, 29 Jun 2010 10:42:41 +0200
Message-ID: <1277801017-30600-2-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44216 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0F2Ink (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:40 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stumbled across and fixed to be more readable.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 59ca00e..3c3fcca 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -140,11 +140,13 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 		return 1;
 	if (FWINV2(ebt_dev_check(e->out, out), EBT_IOUT))
 		return 1;
-	if ((!in || !in->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_in, in->br_port->br->dev), EBT_ILOGICALIN))
+	if (in != NULL && in->br_port != NULL &&
+	    FWINV2(ebt_dev_check(e->logical_in, in->br_port->br->dev),
+		   EBT_ILOGICALIN))
 		return 1;
-	if ((!out || !out->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_out, out->br_port->br->dev), EBT_ILOGICALOUT))
+	if (out != NULL && out->br_port != NULL &&
+	    FWINV2(ebt_dev_check(e->logical_out, out->br_port->br->dev),
+		   EBT_ILOGICALOUT))
 		return 1;
 
 	if (e->bitmask & EBT_SOURCEMAC) {
-- 
1.7.1

