From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] netfilter: xtables: resort osf kconfig text
Date: Wed, 17 Mar 2010 14:19:01 +0100
Message-ID: <1268831945-6041-7-git-send-email-jengelh@medozas.de>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59359 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0CQNTW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:19:22 -0400
In-Reply-To: <1268831945-6041-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Restore alphabetical ordering of the list and put the xt_osf option
into its 'right' place again.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6ac28ef..8055786 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -774,6 +774,19 @@ config NETFILTER_XT_MATCH_MULTIPORT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_OSF
+	tristate '"osf" Passive OS fingerprint match'
+	depends on NETFILTER_ADVANCED && NETFILTER_NETLINK
+	help
+	  This option selects the Passive OS Fingerprinting match module
+	  that allows to passively match the remote operating system by
+	  analyzing incoming TCP SYN packets.
+
+	  Rules and loading software can be downloaded from
+	  http://www.ioremap.net/projects/osf
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_OWNER
 	tristate '"owner" match support'
 	depends on NETFILTER_ADVANCED
@@ -958,19 +971,6 @@ config NETFILTER_XT_MATCH_U32
 
 	  Details and examples are in the kernel module source.
 
-config NETFILTER_XT_MATCH_OSF
-	tristate '"osf" Passive OS fingerprint match'
-	depends on NETFILTER_ADVANCED && NETFILTER_NETLINK
-	help
-	  This option selects the Passive OS Fingerprinting match module
-	  that allows to passively match the remote operating system by
-	  analyzing incoming TCP SYN packets.
-
-	  Rules and loading software can be downloaded from
-	  http://www.ioremap.net/projects/osf
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 endif # NETFILTER_XTABLES
 
 endmenu
-- 
1.7.0.2

