From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] iptables: Add limits.h to get INT_MIN, INT_MAX, ...
Date: Fri, 20 Feb 2009 16:28:31 -0800
Message-ID: <20090220162831.1d0bf3d4@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:34978 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZBUA2c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:28:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix build failure of iptables utilities on debian/ubuntu, maybe other distros.
The values INT_MIN and INT_MAX are used by many filters and these
are defined in limits.h
---
  patch against current iptables.git

diff --git a/include/xtables.h.in b/include/xtables.h.in
index b5f1af2..e346778 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -8,6 +8,7 @@
 
 #include <sys/socket.h> /* PF_* */
 #include <sys/types.h>
+#include <limits.h>
 #include <stdbool.h>
 #include <netinet/in.h>
 #include <net/if.h>
-- 
1.5.6.3

