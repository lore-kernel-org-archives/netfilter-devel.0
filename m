From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/26] netfilter: Remove references to obsolete CONFIG_IP_ROUTE_FWMARK
Date: Wed,  6 Jul 2016 16:24:06 +0200
Message-ID: <1467815048-2240-25-git-send-email-pablo@netfilter.org>
References: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbcGFO1F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jul 2016 10:27:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B481C17DB6E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:27:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A3F5B9EBC2
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:27:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 389249EBAE
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Jul 2016 16:27:00 +0200 (CEST)
In-Reply-To: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Moritz Sichert <moritz+linux@sichert.me>

This option was removed in commit 47dcf0cb1005 ("[NET]: Rethink mark field
in struct flowi").

Signed-off-by: Moritz Sichert <moritz+linux@sichert.me>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 95e757c..9266cee 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -609,9 +609,8 @@ config NETFILTER_XT_MARK
 	The target allows you to create rules in the "mangle" table which alter
 	the netfilter mark (nfmark) field associated with the packet.
 
-	Prior to routing, the nfmark can influence the routing method (see
-	"Use netfilter MARK value as routing key") and can also be used by
-	other subsystems to change their behavior.
+	Prior to routing, the nfmark can influence the routing method and can
+	also be used by other subsystems to change their behavior.
 
 config NETFILTER_XT_CONNMARK
 	tristate 'ctmark target and match support'
@@ -753,9 +752,8 @@ config NETFILTER_XT_TARGET_HMARK
 
 	The target allows you to create rules in the "raw" and "mangle" tables
 	which set the skbuff mark by means of hash calculation within a given
-	range. The nfmark can influence the routing method (see "Use netfilter
-	MARK value as routing key") and can also be used by other subsystems to
-	change their behaviour.
+	range. The nfmark can influence the routing method and can also be used
+	by other subsystems to change their behaviour.
 
 	To compile it as a module, choose M here. If unsure, say N.
 
-- 
2.1.4

