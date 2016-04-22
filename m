From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] netfilter: resolve compilation error in userspace when using ip_tables.h
Date: Fri, 22 Apr 2016 16:04:30 +0200
Message-ID: <1461333870-17030-1-git-send-email-jengelh@inai.de>
References: <alpine.LSU.2.20.1604221535250.14824@nerf40.vanv.qr>
Cc: netfilter-devel@vger.kernel.org, mikko.rapeli@iki.fi,
	normand@linux.vnet.ibm.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46998 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbcDVOEc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Apr 2016 10:04:32 -0400
In-Reply-To: <alpine.LSU.2.20.1604221535250.14824@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Compilation of iptables plugins which include these two lines

	#include <xtables.h>
	#include <linux/netfilter_ipv4/ip_tables.h>

fails since commit 1ffad83dffd675cd742286ae82dca7d746cb0da8, because
the userspace parts almost everywhere include <net/if.h>, which
collides with <linux/if.h>.

Use the __KERNEL__ trick that was last present in
d16cf20e2f2f13411eece7f7fb72c17d141c4a84^:include/linux/netfilter_ipv4/ip_queue.h
to resolve this.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter_ipv4/ip_tables.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
index d0da53d..784a4b7 100644
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -17,7 +17,11 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <linux/if.h>
+#ifdef __KERNEL__
+#	include <linux/if.h>
+#else
+#	include <net/if.h>
+#endif
 #include <linux/netfilter_ipv4.h>
 
 #include <linux/netfilter/x_tables.h>
-- 
2.6.6

