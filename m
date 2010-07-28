From: Meik Piepmeyer <meik.piepmeyer.lists@online.de>
Subject: [PATCH] netfilter : fix typo in Kconfig
Date: Wed, 28 Jul 2010 14:46:19 +0200
Message-ID: <4C50269B.2010908@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Jiri Kosina <trivial@kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0G1Mq3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:46:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Meik Piepmeyer <meik.piepmeyer.lists@online.de>

Fixes a typo of the description of the new netfilter config switch
"NETFILTER_XT_TARGET_RATEEST" introduced in 2.6.35.

Signed-off-by: Meik Piepmeyer <meik.piepmeyer.lists@online.de>

---
 netfilter/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -up net/netfilter/Kconfig{.orig,}:
--- net/netfilter/Kconfig.orig	2010-07-28 14:00:35.000000000 +0200
+++ net/netfilter/Kconfig	2010-07-28 14:01:36.000000000 +0200
@@ -503,7 +503,7 @@ config NETFILTER_XT_TARGET_RATEEST
 	  To compile it as a module, choose M here.  If unsure, say N.

 config NETFILTER_XT_TARGET_TEE
-	tristate '"TEE" - packet cloning to alternate destiantion'
+	tristate '"TEE" - packet cloning to alternate destination'
 	depends on NETFILTER_ADVANCED
 	depends on (IPV6 || IPV6=n)
 	depends on !NF_CONNTRACK || NF_CONNTRACK
