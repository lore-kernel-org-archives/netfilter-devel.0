From: Karl Hiramoto <karl@hiramoto.org>
Subject: [RFC 1/4] netfilter/Kconfig: NF_QUEUE_CONNBYTES_BYPASS
Date: Sat, 24 Jul 2010 17:44:42 +0200
Message-ID: <1279986285-11665-2-git-send-email-karl@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Cc: Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:37915 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0GXPqH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:46:07 -0400
Received: from homiemail-a30.g.dreamhost.com (caiajhbdcbbj.dreamhost.com [208.97.132.119])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 892C717C791
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 08:46:07 -0700 (PDT)
In-Reply-To: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Create config option to add nf_queue bypass feature.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 net/netfilter/Kconfig |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8593a77..4468365 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -11,7 +11,18 @@ config NETFILTER_NETLINK_QUEUE
 	help
 	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
-	  
+
+config NF_QUEUE_CONNBYTES_BYPASS
+	  bool  'NF_QUEUE bypass support'
+	  depends on NF_CONNTRACK
+	  depends on NETFILTER_NETLINK_QUEUE
+	  help
+	  This option allows user-space to tell nfnetlink_queue so allow X bytes
+	  to bypass the queue with the ACCEPT verdict.
+	  In conditions where you know X bytes must be accepted, it avoid the
+	  copy to user-space and can be over a 2X speed improvement.
+
+
 config NETFILTER_NETLINK_LOG
 	tristate "Netfilter LOG over NFNETLINK interface"
 	default m if NETFILTER_ADVANCED=n
-- 
1.7.1

