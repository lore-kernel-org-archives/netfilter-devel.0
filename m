From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH][RESEND] fix ebtables build dependency
Date: Sun, 17 Jul 2011 18:04:49 +0200
Message-ID: <4E230821.10807@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:41628 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab1GQQEy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:04:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The configuration of ebtables shouldn't depend on
CONFIG_BRIDGE_NETFILTER, only on CONFIG_NETFILTER.

Reported-by: S=E9bastien Laveze <slaveze@gmail.com>
Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>=20


--- linux/net/bridge/netfilter/Kconfig.ori	2011-06-29 22:32:38.70273499=
9 +0200
+++ linux/net/bridge/netfilter/Kconfig	2011-06-29 22:33:33.702734999 +0=
200
@@ -4,7 +4,7 @@
=20
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
-	depends on BRIDGE && BRIDGE_NETFILTER
+	depends on BRIDGE && NETFILTER
 	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification


--=20
Bart De Schuymer
www.artinalgorithms.be
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
