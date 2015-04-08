From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [kernel PATCH] uapi: ebtables: don't include linux/if.h
Date: Wed, 08 Apr 2015 19:41:40 +0200
Message-ID: <20150408174140.25208.67942.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38321 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475AbbDHRlt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:41:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

linux/if.h creates conflicts in userspace with net/if.h

By using it here we force userspace to use linux/if.h while
net/if.h may be needed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux/netfilter_bridge/ebtables.h      |    3 ++-
 include/uapi/linux/netfilter_bridge/ebtables.h |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 34e7a2b..f1bd396 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -12,9 +12,10 @@
 #ifndef __LINUX_BRIDGE_EFF_H
 #define __LINUX_BRIDGE_EFF_H
 
+#include <linux/if.h>
+#include <linux/if_ether.h>
 #include <uapi/linux/netfilter_bridge/ebtables.h>
 
-
 /* return values for match() functions */
 #define EBT_MATCH 0
 #define EBT_NOMATCH 1
diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index ba99336..773dfe8 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -12,9 +12,7 @@
 
 #ifndef _UAPI__LINUX_BRIDGE_EFF_H
 #define _UAPI__LINUX_BRIDGE_EFF_H
-#include <linux/if.h>
 #include <linux/netfilter_bridge.h>
-#include <linux/if_ether.h>
 
 #define EBT_TABLE_MAXNAMELEN 32
 #define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN

